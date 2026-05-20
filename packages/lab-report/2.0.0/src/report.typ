// Base show rule for lab reports.
// Handles document setup and optional bibliography rendering.
// Does NOT render cover, TOC, or lampiran — use components/presets for that.
//
// Usage:
//   #show: report.with(
//     font: "Times New Roman",
//     bib: bibliography("refs.bib"),
//   )
//   ...content here...

#import "config/content.typ": CONTENT

#let report(
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 12pt,
  lang: "id",
  region: "id",
  paper: "a4",
  margin: 1in,
  bib: none,
  body,
) = {
  // Document
  set page(paper: paper, margin: margin)

  // Font
  set text(font: font, size: font-size, lang: lang, region: region)
  show raw: set text(font: code-font, size: 0.95em)
  show raw.where(block: true): set text(size: 0.85em)

  // Heading numbering
  set heading(numbering: (..nums) => {
    nums = nums.pos()
    if nums.len() == 1 {
      return numbering("A.", nums.first())
    } else if nums.len() == 2 {
      return numbering("1.", nums.last())
    } else if nums.len() == 3 {
      return numbering("1.1", ..nums.slice(1))
    } else if nums.len() == 4 {
      return numbering("1.1.1", ..nums.slice(1))
    } else {
      return numbering("1.", nums.last())
    }
  })

  // Table caption on top
  show figure.where(kind: table): set figure.caption(position: top)

  // Bibliography style
  set bibliography(style: "ieee", title: none, full: true)

  // Content
  body

  // Bibliography (rendered after body, Typst sees it statically)
  if bib != none {
    pagebreak()
    align(center)[
      #heading(level: 1, numbering: none)[#CONTENT.bibliography]
    ]
    set text(size: 0.9em)
    bib
  }
}
