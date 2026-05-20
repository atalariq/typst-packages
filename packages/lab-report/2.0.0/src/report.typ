// Base show rule for lab reports.
// Handles document setup only: fonts, margins, heading numbering, figures, paragraphs.
// Does NOT render cover, TOC, bibliography, or lampiran — use components/presets for that.
//
// Usage:
//   #show: report.with(font: "Times New Roman", font-size: 12pt)
//   ...content here...

#let report(
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 12pt,
  lang: "id",
  region: "id",
  paper: "a4",
  margin: 1in,
  body,
) = {
  // Document
  set document(author: none, title: none)
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
}
