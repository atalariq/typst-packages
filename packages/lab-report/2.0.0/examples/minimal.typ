// Minimal report using the `minimal` preset (no TOC, no theory, no bib).
// Compile: typst compile examples/minimal.typ

#import "@atalariq/lab-report:2.0.0": *

#let meta = (
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "Praktikum Struktur Data",
  course-code: "PSD",
  lecturer: "Dr. John Doe",
  meeting: "6",
  title: "Implementasi Dequeue pada Sistem Antrean",
)

#show: minimal.with(
  ..meta,
  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
    logo: image("assets/logo.png", width: 6cm),
  ),
  year: 2026,
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 12pt,
)

#set par(justify: true)
#set heading(numbering: "1.")

#let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), ..args)
#let img(path, ..args) = image-wrapper(read(path, encoding: none), ..args)

== Kode Program

#include-code("src/deque.py")

== Output

#img("assets/deque.png", caption: [Hasil output program `antrean_deque.py`])
