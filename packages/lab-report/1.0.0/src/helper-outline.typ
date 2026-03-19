#import "./content.typ": CONTENT

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
