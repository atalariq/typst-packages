// ── Table of Contents ───────────────────────────────────────────────
// Thin wrappers around daftar-isi / daftar-gambar / daftar-tabel.
// These are re-exported from helpers.typ but also available as components.

#let toc(break-page: true) = {
  daftar-isi(break-page: break-page)
}

#let tof(break-page: true) = {
  daftar-gambar(break-page: break-page)
}

#let tot(break-page: true) = {
  daftar-tabel(break-page: break-page)
}
