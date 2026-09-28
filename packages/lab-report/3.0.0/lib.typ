// @atalariq/lab-report 3.0.0 — entrypoint.
//
// Single self-contained file, zero external package imports. Works both
// copied next to a report (`#import "lab-report.typ": *`) and installed as
// a package (import path: @atalariq/lab-report:3.0.0, then `: *`).
//
// Layout of this file:
//   1. CONTENT      — Indonesian section labels, one place to change them
//   2. internal helpers (_require, outline wrapper)
//   3. codeblock    — vendored code-block rendering engine (Stage 2a)
//   4. figure helpers (img, tbl, code-figure), col(), appendix()
//   5. cover()
//   6. report()     — base show rule: page/text/heading setup + bibliography
//   7. full() / minimal() — presets

// ============================================================
// 1. Content strings
// ============================================================

// All Indonesian labels the template prints, in one dict, so a caller can
// fork this file and relabel everything (e.g. to English) by editing here.
#let CONTENT = (
  cover: (
    title: "LAPORAN PERTEMUAN",
    meeting: "Pertemuan",
  ),
  reported-by: (
    title: "Disusun Oleh:",
    name: "Nama",
    id: "NIM",
    class: "Kelas",
    lecturer: "Dosen Pengampu",
  ),
  supplement: (
    image: "Gambar",
    table: "Tabel",
    code: "Kode",
  ),
  table-of-contents: "Daftar Isi",
  list-of-figures: "Daftar Gambar",
  list-of-tables: "Daftar Tabel",
  bibliography: "Daftar Pustaka",
  appendix: "Lampiran",
)

// ============================================================
// 2. Internal helpers
// ============================================================

// Fails loudly, naming the missing parameter and showing a correct call,
// instead of silently rendering with a placeholder or an empty box.
// Returns none (not `value`) — a statement-position call in a code block
// must not leak its return value into the document as stray text.
#let _require(value, name, example) = {
  assert(
    value != none,
    message: "lab-report: `" + name + "` is required, e.g. " + example,
  )
  none
}

// Outline wrapper shared by toc()/tof()/tot(): linked entries with dot
// leaders, centered title, and (via the callers below) auto-hiding when
// the target list would be empty.
#let _outline(title, target: none, break-page: true) = {
  show outline: it => {
    show heading: set align(center)
    it
  }
  set outline.entry(fill: repeat([.], gap: 0.15em))
  show outline.entry: set block(above: 1.1em)
  show outline.entry: it => link(
    it.element.location(),
    it.indented(it.prefix(), it.inner()),
  )
  if target != none {
    outline(title: title, target: target)
  } else {
    outline(title: title)
  }
  if break-page { pagebreak() }
}

// ============================================================
// 3. codeblock — vendored from the Stage 2a engine, verbatim.
//    Do not "simplify" the measuring/par-construction below — see the
//    MECHANISM NOTE, which documents two real Typst traps this works
//    around (measure() inside `show raw.line` blows the recursion budget;
//    `set par(hanging-indent:)` inside a content block silently no-ops).
// ============================================================

// MECHANISM NOTE (verified against Typst 0.15.1 by experiment):
//   - `raw` exposes a synthesized `lines` field (of `raw.line` elements),
//     but that field can only be read from *inside* a `show raw.line`
//     rule's context — accessing `some-raw.lines` directly errors with
//     "field `lines` in raw is not known at this point".
//   - `show raw.line: it => ..` DOES fire once per source line, in order,
//     and `it` exposes `it.number` (1-indexed line number within that raw
//     element) and `it.text` (the plain-text line, whitespace intact) and
//     `it.body` (the same line as *highlighted* content — a sequence of
//     `styled` children carrying the syntax-highlighting colours). This is
//     the mechanism this file relies on to rebuild each line as a table
//     row without losing highlighting.
//   - Calling `measure()` *inside* the `show raw.line` closure itself blows
//     the interpreter's show-rule recursion budget ("maximum show rule
//     depth exceeded") — this reproduces even measuring an unrelated
//     `rect()`, and even just *displaying* a `length` value via `#len`
//     inside that closure has the same problem. The fix used below is to
//     do all measuring (of one monospace character's advance width, used
//     for hanging-indent and gutter-width math) in an outer `context`
//     block *before* the `show raw.line` rule is installed, and only feed
//     the resulting plain numbers into the closure.
//   - `set par(hanging-indent: ..)` followed by `it.body` as a *content
//     block argument* (`block(..)[#set par(..) #it.body]`) silently does
//     NOT apply the hanging indent — but calling `par(hanging-indent: ..,
//     ..)(it.body)` as a function with an explicit positional content
//     argument DOES apply it. This file always uses the function-call form.

// Splits `s` on line breaks, keeping empty trailing lines (mirrors what
// `raw` itself considers a "line" so line numbers of a rebuilt raw element
// line up with the original text).
#let _split-lines(s) = s.split("\n")

// Counts leading ASCII space characters in `s` (used for hanging-indent).
// Tabs are not special-cased — if source uses tabs for indent, hanging
// indent will simply not trigger for that line; documented as a known
// limitation rather than silently mishandled.
#let _leading-spaces(s) = s.len() - s.trim(" ", at: start, repeat: true).len()

// Normalises the `highlight` argument (int, array of int/dictionary, or a
// single dictionary) into a dictionary keyed by *displayed* line number
// (as a string, since dictionary keys must be strings), each entry holding
// a resolved `color` and optional `note` content.
#let _normalize-highlight(highlight, default-color) = {
  let entries = if type(highlight) == array { highlight } else { (highlight,) }
  let map = (:)
  for entry in entries {
    if entry == none { continue }
    let (ln, col, note) = if type(entry) == int {
      (entry, default-color, none)
    } else if type(entry) == dictionary {
      (
        entry.at("line"),
        entry.at("color", default: default-color),
        entry.at("note", default: none),
      )
    } else {
      panic("codeblock: highlight entries must be an int or a dictionary with a `line` key, got " + repr(entry))
    }
    map.insert(str(ln), (color: col, note: note))
  }
  map
}

// Code-block renderer: line numbers, ranges, per-line highlighting with
// optional annotations, header/footer, a language tab, zebra-striped or
// flat backgrounds, hanging indent on wrapped lines. Syntax highlighting
// itself is delegated entirely to the built-in `raw` element.
//
// `body` — either a `raw` element (e.g. a ```` ```python .. ``` ```` block
//   passed straight through) or a plain string, in which case `lang` names
//   its language for syntax highlighting.
#let codeblock(
  body,
  // -- language / normalization --
  lang: none, // language override; only meaningful when `body` is a string, or to force a different highlighter than the raw element already carries
  // -- line numbers --
  numbers: true, // show the line-number gutter
  number-start: 1, // number shown on the first rendered line (ignored when `range` is set and `range-restart` is false)
  number-rule: true, // draw a vertical separator between the gutter and the code
  number-color: luma(130), // text colour of the line numbers
  // -- line range --
  range: none, // (lo, hi), 1-indexed inclusive, selects a slice of `body`'s original lines; none renders everything
  range-restart: false, // when a range is given: true renumbers the slice from 1, false (default) keeps the original file's line numbers
  // -- line highlighting --
  highlight: (), // int, dictionary (line:, color:, note:), or an array mixing both; `line` numbers always refer to the *original* file numbering
  highlight-color: rgb("#fff3b0"), // default highlight background when a highlight entry doesn't specify its own `color`
  // -- annotation comments --
  annotate-prefix: ">", // marker rendered before an annotation's `note` content
  annotate-color: luma(240), // background of the annotation band
  // -- header / footer --
  header: none, // arbitrary content rendered above the code, inside the same frame
  footer: none, // arbitrary content rendered below the code, inside the same frame
  // -- language tab --
  tab: true, // show the language-name tab; set false to hide it entirely
  tab-color: luma(230), // background of the header/tab strip
  lang-label: none, // override the auto-detected language name shown in the tab
  // -- background --
  background: white, // a single colour, or an array of colours cycled per rendered line (zebra striping)
  // -- hanging indent --
  hanging-indent: true, // wrapped long lines continue indented to the original line's own indentation instead of column 0
  // -- typography --
  font: ("Fira Code", "DejaVu Sans Mono", "Menlo", "Courier New"), // fallback list so code renders monospaced even on machines missing the first choices
  font-size: 9.5pt,
  // -- box --
  inset: 8pt, // horizontal padding of each line / header / footer; vertical padding is derived from it
  radius: 4pt, // corner radius of the outer frame
) = {
  // --- 1. normalize `body` into a `raw` element ------------------------
  let src-raw = if type(body) == content and body.func() == raw {
    if lang != none { raw(body.text, lang: lang, block: true) } else { body }
  } else if type(body) == str {
    raw(body, lang: lang, block: true)
  } else {
    panic("codeblock: `body` must be a raw element or a string, got " + repr(type(body)))
  }

  // A raw element with no language annotation does not merely have
  // `lang: none` — the `lang` field is entirely absent, and accessing it
  // with plain dot syntax panics with "field `lang` in raw is not known
  // at this point" (this reproduces even inside `context`, unlike the
  // `.lines` field described in the MECHANISM NOTE above). `.at(...,
  // default: ...)` is the field accessor that tolerates an absent field.
  let src-lang = src-raw.at("lang", default: none)

  let full-lang = if lang-label != none {
    lang-label
  } else if src-lang != none {
    src-lang
  } else {
    ""
  }

  // --- 2. slice to the requested line range -----------------------------
  let all-lines = _split-lines(src-raw.text)
  let (lo, hi) = if range != none { range } else { (1, all-lines.len()) }
  let hi-clamped = calc.min(hi, all-lines.len())
  let sliced = all-lines.slice(lo - 1, hi-clamped)
  // Rebuild a fresh `raw` from just the visible lines so `raw.line.number`
  // (which is always 1-indexed *within its own raw element*) maps directly
  // onto the visible rows; the true displayed number is computed below.
  let view-raw = raw(sliced.join("\n"), lang: src-lang, block: true)
  let start-num = if range != none and not range-restart { lo } else { number-start }
  let line-count = sliced.len()

  // --- 3. normalize highlight + background ------------------------------
  let hl-map = _normalize-highlight(highlight, highlight-color)
  let bg-list = if type(background) == array { background } else { (background,) }

  // --- 4. render ----------------------------------------------------------
  context {
    // Monospace advance width of one character, measured once, outside any
    // `raw.line` show rule (see MECHANISM NOTE above for why it must be
    // measured here and not inside the closure).
    let char-w = measure(text(font: font, size: font-size)[0]).width
    let max-digits = str(start-num + line-count - 1).len()
    let gutter-width = char-w * max-digits + 1em

    // The `show raw.line` rule below is deliberately scoped to only the
    // `rendered-code` block below (via the `{ show ..; view-raw }` content
    // block), NOT the whole outer frame — `header`/`footer` are arbitrary
    // caller content that may itself contain unrelated `raw` elements
    // (e.g. inline code in a footer caption), and those must render with
    // Typst's normal raw styling, not be swallowed into code rows here.
    let rendered-code = {
      set block(spacing: 0pt)
      show raw.line: it => {
        let displayed = start-num + it.number - 1
        let hl = hl-map.at(str(displayed), default: none)
        let line-bg = if hl != none {
          hl.color
        } else {
          bg-list.at(calc.rem(it.number - 1, bg-list.len()))
        }

        let indent = if hanging-indent {
          char-w * _leading-spaces(it.text)
        } else {
          0pt
        }

        // The code itself: `par` as a *function call* (not `set par` inside
        // a content block — see MECHANISM NOTE) so hanging-indent actually
        // takes effect.
        let code-content = par(
          hanging-indent: indent,
          first-line-indent: 0pt,
          justify: false,
          {
            set text(font: font, size: font-size)
            it.body
          },
        )

        let row = if numbers {
          grid(
            columns: (gutter-width, 1fr),
            fill: line-bg,
            stroke: if number-rule {
              (x, y) => if x == 1 { (left: 0.5pt + luma(200)) } else { none }
            } else {
              none
            },
            align(right + top, pad(right: 0.5em, top: 3pt, bottom: 3pt, text(fill: number-color, size: font-size)[#displayed])),
            pad(left: inset, right: inset, top: 3pt, bottom: 3pt, code-content),
          )
        } else {
          block(
            width: 100%,
            fill: line-bg,
            inset: (left: inset, right: inset, top: 3pt, bottom: 3pt),
            code-content,
          )
        }

        // Annotation band directly under the line it belongs to. `hl.note`
        // is caller content and may itself contain inline raw (e.g. a
        // `` `variable` `` in the note text). Without the inner show rule
        // below, that inline raw would still be inside the `show
        // raw.line` scope installed just above and get rebuilt into a
        // full numbered code row instead of showing as normal inline
        // code — the inner rule shadows the outer one for this content.
        if hl != none and hl.note != none {
          let note-block = {
            show raw.line: line-it => line-it.body
            block(
              width: 100%,
              fill: annotate-color,
              inset: (left: inset, right: inset, top: 3pt, bottom: 3pt),
            )[#text(font: font, size: font-size * 0.9)[#annotate-prefix #h(0.4em) #hl.note]]
          }
          [#row #note-block]
        } else {
          row
        }
      }
      view-raw
    }

    // Outer frame: header/tab strip, the code body, then the footer, all
    // clipped to one rounded rectangle. `breakable: true` lets the block
    // span a page break; each page fragment keeps its own full corner
    // radius (verified by experiment — Typst does not try to draw a
    // "continuing" flat edge, it simply re-rounds every fragment, which
    // looks correct rather than corrupted).
    block(
      width: 100%,
      radius: radius,
      clip: true,
      breakable: true,
      stroke: 0.5pt + luma(215),
    )[
      #if header != none or (tab and full-lang != "") {
        grid(
          columns: (1fr, auto),
          fill: tab-color,
          inset: (left: inset, right: inset, top: 6pt, bottom: 6pt),
          if header != none { header } else { [] },
          if tab and full-lang != "" {
            text(font: font, size: font-size, weight: "bold")[#full-lang]
          } else {
            []
          },
        )
      }
      #rendered-code
      #if footer != none {
        block(
          width: 100%,
          fill: tab-color,
          inset: (left: inset, right: inset, top: 6pt, bottom: 6pt),
          footer,
        )
      }
    ]
  }
}

// ============================================================
// 4. Outlines, figure helpers, layout, appendix
// ============================================================

// Daftar Isi — hidden entirely when the document has no outlined headings.
#let toc(break-page: true) = context {
  let n = query(heading.where(outlined: true)).len()
  if n > 0 { _outline(CONTENT.table-of-contents, break-page: break-page) }
}

// Daftar Gambar — hidden entirely when there are no image figures.
#let tof(break-page: true) = context {
  let n = query(figure.where(kind: image, outlined: true)).len()
  if n > 0 { _outline(CONTENT.list-of-figures, target: figure.where(kind: image), break-page: break-page) }
}

// Daftar Tabel — hidden entirely when there are no table figures.
#let tot(break-page: true) = context {
  let n = query(figure.where(kind: table, outlined: true)).len()
  if n > 0 { _outline(CONTENT.list-of-tables, target: figure.where(kind: table), break-page: break-page) }
}

// Wraps an image in a captioned figure (caption below), or just centers it
// when there is no caption. `body` must be content (e.g. `image("a.png",
// width: 80%)`), never a path string, so relative paths resolve against
// the calling file and sizing is the caller's own `image()` call.
#let img(body, caption: none) = {
  if caption == none {
    align(center)[#body]
  } else {
    figure(body, caption: caption, kind: image, supplement: [#CONTENT.supplement.image])
  }
}

// Table figure, caption positioned above (set globally in report()).
//  columns: int  → that many equal (1fr) columns
//           array → used as-is  e.g. (auto, 1fr, 2fr)
#let tbl(
  caption: none,
  columns: auto,
  align-item: left,
  stroke: 0.5pt,
  ..rows,
) = {
  let cols = if type(columns) == int {
    (1fr,) * columns
  } else {
    columns
  }

  let table-content = table(
    columns: cols,
    align: align-item,
    stroke: stroke,
    ..rows,
  )

  if caption == none {
    table-content
  } else {
    figure(
      table-content,
      caption: caption,
      supplement: [#CONTENT.supplement.table],
      kind: table,
    )
  }
}

// Code as a captioned figure, using its own counter — separate from the
// image and table counters, since it's figure(kind: "code") rather than
// figure(kind: image/table). `body` is passed straight through to
// codeblock(), so it accepts any codeblock() argument (lang, highlight,
// range, etc.) via `..args`.
#let code-figure(body, caption: none, ..args) = {
  let rendered = codeblock(body, ..args)
  if caption == none {
    rendered
  } else {
    figure(
      rendered,
      caption: caption,
      kind: "code",
      supplement: [#CONTENT.supplement.code],
    )
  }
}

// n-column layout.
//  ratio: array of fr/length values e.g. (2fr, 1fr); none → equal columns
//  responsive: when true, stacks into a single column if the available
//    width drops below `threshold` (e.g. a narrow multi-column page or a
//    column already nested inside another layout).
#let col(
  gutter: 1em,
  ratio: none,
  responsive: false,
  threshold: 30em,
  ..contents,
) = {
  let items = contents.pos()
  if responsive {
    context {
      let w = layout(size => size.width)
      if w < threshold {
        grid(columns: 1fr, gutter: gutter, ..items)
      } else {
        let cols = if ratio != none { ratio } else { (1fr,) * items.len() }
        grid(columns: cols, gutter: gutter, ..items)
      }
    }
  } else {
    let cols = if ratio != none { ratio } else { (1fr,) * items.len() }
    grid(columns: cols, gutter: gutter, ..items)
  }
}

// Lampiran — its own unnumbered top-level heading, rendered wherever the
// caller places it (typically at the end of the body, before the
// bibliography, which report() renders separately after the body).
#let appendix(body) = {
  pagebreak()
  heading(level: 1, numbering: none)[#CONTENT.appendix]
  body
}

// ============================================================
// 5. Cover page
// ============================================================

// Cover page. `logo` must be content (e.g. `image("logo.png")`), never a
// path string or `none` — a missing logo is a caller error, not a blank
// rect (see design decision in the Stage 2b brief).
#let cover(
  author: none,
  id: none,
  class: none,
  course: none,
  course-code: none,
  lecturer: none,
  meeting: none,
  title: none,
  logo: none,
  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
  ),
  year: datetime.today().year(),
) = {
  _require(author, "author", "cover(author: \"Jane Doe\", ...)")
  _require(id, "id", "cover(id: \"12/345/SV/6789\", ...)")
  _require(class, "class", "cover(class: \"B2\", ...)")
  _require(course, "course", "cover(course: \"Praktikum Struktur Data\", ...)")
  _require(course-code, "course-code", "cover(course-code: \"PSD\", ...)")
  _require(lecturer, "lecturer", "cover(lecturer: \"Dr. John Doe\", ...)")
  _require(meeting, "meeting", "cover(meeting: \"4\", ...)")
  _require(title, "title", "cover(title: \"Implementasi ...\", ...)")
  _require(logo, "logo", "cover(logo: image(\"assets/logo.png\", width: 6cm), ...)")

  align(center)[
    #upper(
      text(size: 1.25em, weight: "bold")[
        #CONTENT.cover.title \
        #course \
        #CONTENT.cover.meeting #meeting \
        #title
      ],
    )

    #v(1fr)

    #logo

    #v(1fr)

    #CONTENT.reported-by.title
    #table(
      columns: 3,
      align: left,
      stroke: none,
      [#CONTENT.reported-by.name], [:], [#author],
      [#CONTENT.reported-by.id], [:], [#id],
      [#CONTENT.reported-by.class], [:], [#course-code \- #class],
      [#CONTENT.reported-by.lecturer], [:], [#lecturer],
    )

    #v(1fr)

    #text(weight: "bold")[
      #upper(association.program) \
      #upper(association.department) \
      #upper(association.faculty) \
      #upper(association.university) \
      #upper(association.city) \
      #year
    ]
  ]

  pagebreak()
}

// ============================================================
// 6. report() — base show rule
// ============================================================

// Base document setup: page/text/heading numbering, table captions above
// / image captions below, and the bibliography (rendered after `body`,
// centered "Daftar Pustaka" heading, IEEE numeric style). Does not render
// a cover or any outline — use the presets below, or call this directly
// for a fully custom layout.
//
// `bib` must be content (e.g. `bibliography("references.bib")`), never a
// path string, so it resolves relative to the calling file; `none` skips
// the bibliography entirely.
#let report(
  font: ("Times New Roman", "New Computer Modern"),
  mono-font: ("Fira Code", "DejaVu Sans Mono", "Menlo", "Courier New"),
  font-size: 12pt,
  lang: "id",
  region: "id",
  paper: "a4",
  margin: 1in,
  bib: none,
  body,
) = {
  set page(paper: paper, margin: margin)
  set text(font: font, size: font-size, lang: lang, region: region)
  show raw: set text(font: mono-font, size: 0.95em)
  show raw.where(block: true): set text(size: 0.85em)

  // A. / 1. / 1.1 / 1.1.1 heading numbering.
  set heading(numbering: (..nums) => {
    nums = nums.pos()
    if nums.len() == 1 {
      numbering("A.", nums.first())
    } else if nums.len() == 2 {
      numbering("1.", nums.last())
    } else if nums.len() == 3 {
      numbering("1.1", ..nums.slice(1))
    } else if nums.len() == 4 {
      numbering("1.1.1", ..nums.slice(1))
    } else {
      numbering("1.", nums.last())
    }
  })

  show figure.where(kind: table): set figure.caption(position: top)
  set bibliography(style: "ieee", title: none, full: true)

  body

  if bib != none {
    pagebreak()
    align(center)[
      #heading(level: 1, numbering: none)[#CONTENT.bibliography]
    ]
    set text(size: 0.9em)
    bib
  }
}

// ============================================================
// 7. Presets
// ============================================================

// Complete report: cover + Daftar Isi/Gambar/Tabel (auto-hiding) + body +
// appendix + bibliography.
//
// Usage:
//   #show: full.with(
//     author: "...", id: "...", class: "...", course: "...",
//     course-code: "...", lecturer: "...", meeting: "...", title: "...",
//     logo: image("assets/logo.png", width: 6cm),
//     bib: bibliography("references.bib"),
//   )
//   = Tujuan Praktikum
//   ...
#let full(
  // Cover metadata (all required — see cover() for the assert messages)
  author: none,
  id: none,
  class: none,
  course: none,
  course-code: none,
  lecturer: none,
  meeting: none,
  title: none,
  logo: none,
  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
  ),
  year: datetime.today().year(),

  // Optional extras
  bib: none, // bibliography("references.bib") or none
  appendix-content: none, // content for the appendix, or none to omit it

  // Base config, forwarded to report()
  font: ("Times New Roman", "New Computer Modern"),
  mono-font: ("Fira Code", "DejaVu Sans Mono", "Menlo", "Courier New"),
  font-size: 12pt,
  lang: "id",
  region: "id",
  paper: "a4",
  margin: 1in,

  body,
) = {
  report(
    font: font,
    mono-font: mono-font,
    font-size: font-size,
    lang: lang,
    region: region,
    paper: paper,
    margin: margin,
    bib: bib,
    {
      cover(
        author: author,
        id: id,
        class: class,
        course: course,
        course-code: course-code,
        lecturer: lecturer,
        meeting: meeting,
        title: title,
        logo: logo,
        association: association,
        year: year,
      )

      toc()
      tof()
      tot()

      body

      if appendix-content != none {
        appendix(appendix-content)
      }
    },
  )
}

// Stripped-down report: cover + body only. No outlines, no bibliography,
// no appendix — for quick turnaround work.
//
// Usage:
//   #show: minimal.with(
//     author: "...", id: "...", class: "...", course: "...",
//     course-code: "...", lecturer: "...", meeting: "...", title: "...",
//     logo: image("assets/logo.png", width: 6cm),
//   )
//   == Tugas 1
//   ...
#let minimal(
  author: none,
  id: none,
  class: none,
  course: none,
  course-code: none,
  lecturer: none,
  meeting: none,
  title: none,
  logo: none,
  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
  ),
  year: datetime.today().year(),

  font: ("Times New Roman", "New Computer Modern"),
  mono-font: ("Fira Code", "DejaVu Sans Mono", "Menlo", "Courier New"),
  font-size: 12pt,
  lang: "id",
  region: "id",
  paper: "a4",
  margin: 1in,

  body,
) = {
  report(
    font: font,
    mono-font: mono-font,
    font-size: font-size,
    lang: lang,
    region: region,
    paper: paper,
    margin: margin,
    {
      cover(
        author: author,
        id: id,
        class: class,
        course: course,
        course-code: course-code,
        lecturer: lecturer,
        meeting: meeting,
        title: title,
        logo: logo,
        association: association,
        year: year,
      )

      body
    },
  )
}
