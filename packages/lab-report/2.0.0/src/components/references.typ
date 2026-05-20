#import "../config/content.typ": CONTENT

// ── Bibliography ────────────────────────────────────────────────────
// Usage: #bibliography(bibliography("refs.bib"))
#let print-bibliography(bib, title: none) = {
  let resolved-title = if title != none { title } else { CONTENT.bibliography }
  pagebreak()
  align(center)[
    #heading(level: 1, numbering: none)[#resolved-title]
  ]
  set text(size: 0.9em)
  bib
}

// ── Appendix ────────────────────────────────────────────────────────
// Usage: #appendix[#include-code("src/main.py")]
#let appendix(body) = {
  pagebreak()
  heading(level: 1, numbering: none)[#CONTENT.appendix]
  body
}
