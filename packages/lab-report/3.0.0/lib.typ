// @atalariq/lab-report 3.0.0 — entrypoint.
//
// Self-contained aside from one vendored dependency: `vendor/zebraw/` (a
// verbatim copy of @preview/zebraw 0.6.3, see vendor/zebraw/README.md), so
// the package still has zero *network* dependency at compile time. Works
// both copied next to a report (copy `lib.typ` + `vendor/` together, then
// `#import "lib.typ": *`) and installed as a package (import path:
// @atalariq/lab-report:3.0.0, then `: *`).
//
// Layout of this file:
//   1. CONTENT      — Indonesian section labels, one place to change them
//   2. internal helpers (_require, outline wrapper)
//   3. codeblock    — zebraw preset (vendored engine) + language aliasing
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
// 3. codeblock — preset over vendored zebraw (vendor/zebraw/, a verbatim
//    copy of @preview/zebraw 0.6.3; see vendor/zebraw/README.md). Line
//    numbers, ranges, per-line highlighting/annotations, header/footer and
//    a language tab all come from zebraw; this section only adds a
//    3.0.0-styled preset plus language aliasing for grammars Typst's `raw`
//    only colours under conditions callers don't usually meet.
// ============================================================

#import "vendor/zebraw/src/lib.typ": zebraw

// Typst's built-in highlighter only colours a ```` ```php ```` block once
// the source itself opens with `<?php` (a bare snippet, the common case in
// a lab report, stays plain), and has no `blade` grammar at all. Rather
// than ask every caller to remember `lang: "PHP Source"` or `lang: "html"`,
// `_highlight-lang` resolves the language actually fed to `raw` (for
// syntax colouring) while `codeblock` keeps showing the original name
// (`php` / `blade`) in the tab.
#let _blade-like = ("blade",)
#let _highlight-lang(lang, text) = {
  if lang == "php" and not text.trim(at: start).starts-with("<?") {
    "PHP Source"
  } else if lang in _blade-like {
    "html"
  } else {
    lang
  }
}

// Normalizes `body` into a `raw` element whose `lang` is set for correct
// syntax colouring (see `_highlight-lang` above), plus the original
// language name to display in zebraw's tab (`none` when there was none).
//
// `body` — either a `raw` element (e.g. a ```` ```python .. ``` ```` block
//   passed straight through) or a plain string, in which case `lang` names
//   its language for syntax highlighting.
#let _normalize-code(body, lang) = {
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
  // at this point". `.at(..., default: ...)` tolerates an absent field.
  let display-lang = src-raw.at("lang", default: none)
  let highlight-lang = if display-lang == none { none } else { _highlight-lang(display-lang, src-raw.text) }

  let hl-raw = if highlight-lang == display-lang {
    src-raw
  } else {
    raw(src-raw.text, lang: highlight-lang, block: true)
  }
  (raw: hl-raw, label: display-lang)
}

// Code-block renderer. A thin preset over `zebraw` (line numbers, ranges,
// per-line highlighting/annotations via `highlight-lines:`, header/footer,
// language tab — see vendor/zebraw/src/mod.typ or the upstream README for
// the full parameter list), styled to match this template's look: a
// bordered, rounded frame with a grey language tab and a flat white
// background. `..args` is forwarded to `zebraw` as-is.
#let codeblock(
  body,
  lang: none, // language override; only meaningful when `body` is a string, or to force a different highlighter than the raw element already carries
  lang-label: none, // override the tab label shown; defaults to the raw element's own language name
  ..args,
) = {
  let (raw: code-raw, label: raw-lang) = _normalize-code(body, lang)
  let tab-label = if lang-label != none { lang-label } else if raw-lang != none { raw-lang } else { false }

  // Not `clip: true` here — zebraw floats its language tab above the code
  // block via a negative vertical offset (see vendor/zebraw/src/util.typ's
  // `render-lang-tab`), which a clipping ancestor cuts off. zebraw's own
  // inner block already clips its fill to `radius`, matched below, so this
  // outer block only contributes the border stroke around the same shape.
  block(
    width: 100%,
    radius: 4pt,
    breakable: true,
    stroke: 0.5pt + luma(215),
  )[
    #zebraw(
      numbering: true,
      numbering-separator: true,
      lang: tab-label,
      lang-color: luma(230),
      background-color: white,
      highlight-color: rgb("#fff3b0"),
      comment-color: luma(240),
      hanging-indent: true,
      extend: true,
      radius: 4pt,
      inset: (top: 0.28em, right: 8pt, bottom: 0.28em, left: 8pt),
      ..args,
      code-raw,
    )
  ]
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
// codeblock(), so it accepts any codeblock()/zebraw argument (lang,
// highlight-lines, line-range, etc.) via `..args`.
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
  // A long code-figure would otherwise jump to the next page as one block
  // and leave the current page half empty; let it split like ordinary text.
  show figure.where(kind: "code"): set block(breakable: true)
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
