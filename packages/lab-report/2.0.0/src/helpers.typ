#import "config/content.typ": CONTENT

//? Internal: Outline wrapper
#let _outline(break-page: true, ..args) = {
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
  outline(..args)
  if break-page { pagebreak() }
}

//? Daftar Isi
#let table-of-contents(break-page: true) = context {
  let n = query(heading.where(outlined: true)).len()
  if n > 0 { _outline(break-page: break-page, title: CONTENT.table-of-contents) }
}

//? Daftar Gambar
#let list-of-figures(break-page: true) = context {
  let n = query(figure.where(kind: image, outlined: true)).len()
  if n > 0 { _outline(break-page: break-page, title: CONTENT.list-of-figures, target: figure.where(kind: image)) }
}

//? Daftar Tabel
#let list-of-tables(break-page: true) = context {
  let n = query(figure.where(kind: table, outlined: true)).len()
  if n > 0 { _outline(break-page: break-page, title: CONTENT.list-of-tables, target: figure.where(kind: table)) }
}

//? Image
//  width: length or ratio (e.g. 10cm, 80%)
//
// Usage:
// #let img(path, ..args) = image-wrapper(read(path), ..args)
#let image-wrapper(src, caption: none, width: 100%, ..image-args) = {
  let image = image(bytes(src), width: width, ..image-args)
  if caption == none {
    align(center)[#image]
  } else {
    figure(image, caption: caption, kind: "image", supplement: [#CONTENT.supplement.image])
  }
}


//? n-column layout
//  ratio: array of fr/length values e.g. (2fr, 1fr)
//         if none, equal columns
//  responsive: when true, stack columns vertically if available width < threshold
#let col(
  gutter: 1em,
  ratio: none,
  responsive: false,
  threshold: 30em,
  ..contents,
) = {
  if responsive {
    context {
      let w = layout(size => size.width)
      if w < threshold {
        // Stack: single column, items flow as rows
        grid(columns: 1fr, gutter: gutter, ..contents.pos())
      } else {
        let cols = if ratio != none {
          ratio
        } else {
          (1fr,) * contents.pos().len()
        }
        grid(columns: cols, gutter: gutter, ..contents.pos())
      }
    }
  } else {
    let cols = if ratio != none {
      ratio
    } else {
      (1fr,) * contents.pos().len()
    }
    grid(
      columns: cols,
      gutter: gutter,
      ..contents.pos(),
    )
  }
}

//? Table
//  columns: int  → that many equal (1fr) columns
//           array → used as-is  e.g. (auto, 1fr, 2fr)
//           auto  → passed to table() directly (each col sized to content)
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

// ── Code (via @preview/zebraw) ───────────────────────────────────────────────
// Merged from @atalariq/code so lab-report users only need one import.

#import "@preview/zebraw:0.6.1": zebraw

#let code = zebraw.with(
  lang: false,
  numbering: true,
  comment-color: luma(240),
  background-color: (luma(245), luma(248), luma(252), luma(248)),
  hanging-indent: true,
  extend: true,
)

#let code-from-file(read-file, lang: "py", ..code-args) = {
  code(
    raw(read-file, block: true, lang: lang),
    ..code-args,
  )
}

// ── Code Block with Figure Caption ──────────────────────────────────────────
// Renders source code as a numbered figure with caption, using its own
// counter (separate from image and table counters).
//
// Usage:
//   #code-block(read("src/main.py"), lang: "python", caption: [Main program])
//
// Or with the standard include-code binding:
//   #let include-code(path, ..args) = code-from-file(read(path), ..args)
//   #code-block(include-code("src/main.py"), caption: [...])
#let code-block(
  body,
  caption: none,
  lang: "py",
) = {
  let rendered = code(raw(body, block: true, lang: lang), header: [#lang])
  if caption == none {
    rendered
  } else {
    figure(
      rendered,
      caption: caption,
      kind: "code",
      supplement: [#CONTENT.supplement.raw],
    )
  }
}

