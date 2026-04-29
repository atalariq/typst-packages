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
#let daftar-isi(break-page: true) = context {
  let n = query(heading.where(outlined: true)).len()
  if n > 0 { _outline(break-page: break-page, title: CONTENT.table-of-content) }
}

//? Daftar Gambar
#let daftar-gambar(break-page: true) = context {
  let n = query(figure.where(kind: image, outlined: true)).len()
  if n > 0 { _outline(break-page: break-page, title: CONTENT.table-of-picture, target: figure.where(kind: image)) }
}

//? Daftar Tabel
#let daftar-tabel(break-page: true) = context {
  let n = query(figure.where(kind: table, outlined: true)).len()
  if n > 0 { _outline(break-page: break-page, title: CONTENT.table-of-table, target: figure.where(kind: table)) }
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
#let col(gutter: 1em, ratio: none, ..contents) = {
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

