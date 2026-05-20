// ── Table of Contents ───────────────────────────────────────────────
// Thin wrappers around table-of-contents / list-of-figures / list-of-tables.

#import "../helpers.typ": table-of-contents, list-of-figures, list-of-tables

#let toc(break-page: true) = {
  table-of-contents(break-page: break-page)
}

#let tof(break-page: true) = {
  list-of-figures(break-page: break-page)
}

#let tot(break-page: true) = {
  list-of-tables(break-page: break-page)
}
