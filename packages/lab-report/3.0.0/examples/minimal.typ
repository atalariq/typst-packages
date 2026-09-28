// Minimal report using the `minimal` preset: cover + body only.
// No TOC, no bibliography, no appendix — for fast turnaround.
// Compile: typst compile examples/minimal.typ

#import "@atalariq/lab-report:3.0.0": *

#show: minimal.with(
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "Praktikum Struktur Data",
  course-code: "PSD",
  lecturer: "Dr. John Doe",
  meeting: "6",
  title: "Implementasi Queue Sederhana",
  logo: image("assets/logo.png", width: 6cm),
  year: 2026,
)

#set par(justify: true)
#set heading(numbering: "1.")

// The `minimal` preset itself never renders outlines. Calling them here
// manually proves the auto-hide behaviour: toc() has headings to list, so
// it renders; tof() and tot() have no image or table figures anywhere in
// this document, so both must render nothing at all (no title, no blank
// page) rather than an empty "Daftar Gambar" / "Daftar Tabel" page.
#toc()
#tof()
#tot()

= Kode Program

#code-figure(read("src/queue.py"), lang: "python")

= Pembahasan

Implementasi ini tidak memerlukan gambar maupun tabel, sehingga Daftar Gambar
dan Daftar Tabel di atas benar-benar tidak tampil sama sekali.
