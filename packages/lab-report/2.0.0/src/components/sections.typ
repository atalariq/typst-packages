#import "../config/content.typ": CONTENT

// ── Tujuan Praktikum ────────────────────────────────────────────────
// Usage: #tujuan[+ item 1 + item 2]
// Or with body: #tujuan(body)[+ item 1]
#let tujuan(body: none, ..items) = {
  = CONTENT.tujuan
  if body != none {
    body
  }
  if items.pos().len() > 0 {
    list(..items.pos())
  }
}

// ── Hasil dan Pembahasan ────────────────────────────────────────────
// Usage: #hasil[content here]
#let hasil(body) = {
  pagebreak()
  = CONTENT.hasil
  body
}

// ── Kesimpulan ──────────────────────────────────────────────────────
// Usage: #kesimpulan[+ point 1 + point 2]
#let kesimpulan(body: none, ..items) = {
  pagebreak()
  = CONTENT.kesimpulan
  if body != none {
    body
  }
  if items.pos().len() > 0 {
    list(..items.pos())
  }
}
