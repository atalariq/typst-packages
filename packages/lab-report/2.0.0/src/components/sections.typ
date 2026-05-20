#import "../config/content.typ": CONTENT

// ── Objectives ─────────────────────────────────────────────────────
// Usage: #objectives[+ item 1 + item 2]
#let objectives(body: none, ..items) = {
  heading(level: 1, numbering: none)[#CONTENT.objectives]
  if body != none {
    body
  }
  if items.pos().len() > 0 {
    list(..items.pos())
  }
}

// ── Results and Discussion ─────────────────────────────────────────
// Usage: #results[content here]
#let results(body) = {
  pagebreak()
  heading(level: 1, numbering: none)[#CONTENT.results]
  body
}

// ── Conclusion ─────────────────────────────────────────────────────
// Usage: #conclusion[+ point 1 + point 2]
#let conclusion(body: none, ..items) = {
  pagebreak()
  heading(level: 1, numbering: none)[#CONTENT.conclusion]
  if body != none {
    body
  }
  if items.pos().len() > 0 {
    list(..items.pos())
  }
}
