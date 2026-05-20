#import "../config/content.typ": CONTENT

// ── Bibliography ────────────────────────────────────────────────────
// Usage: #bibliography(bibliography("refs.bib"))
#let bibliography(bib, title: none) = {
  let resolved-title = if title != none { title } else { CONTENT.bibliography }
  pagebreak()
  align(center)[
    #heading(level: 1, numbering: none)[#resolved-title]
  ]
  set text(size: 0.9em)
  bib
}

// ── Lampiran ────────────────────────────────────────────────────────
// Usage: #lampiran[#include-code("src/main.py")]
#let lampiran(body) = {
  pagebreak()
  heading(level: 1, numbering: none)[#CONTENT.lampiran]
  body
}
