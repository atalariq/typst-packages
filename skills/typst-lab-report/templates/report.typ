#import "@atalariq/lab-report:3.0.0": *
#import "@atalariq/lab-report:3.0.0": img as lab-img

#let meta = (
  author: "…",
  id: "…",
  class: "…",
  course: "…",
  course-code: "…",
  lecturer: "…",
  meeting: "…",
  title: "…",
)

#show: full.with(
  ..meta,
  logo: image("assets/logo.png", width: 6cm),
  association: (
    program: "Teknologi Rekayasa Perangkat Lunak",
    department: "Teknik Elektro dan Informatika",
    faculty: "Sekolah Vokasi",
    university: "Universitas Gadjah Mada",
    city: "Yogyakarta",
  ),
  year: 2026,
  bib: bibliography("references.bib", style: "ieee"),
  font: "Times New Roman",
  mono-font: "Fira Code",
  font-size: 12pt,
)

// NOTE: justify and first-line-indent must be in ONE #set par call
#set par(justify: true, first-line-indent: (amount: 0.5in, all: true))
#set heading(numbering: "1.")
#set enum(numbering: "a.1.")

#let include-code(path, ..args) = code-figure(read(path), lang: path.split(".").at(-1), header: [#path.split("/").at(-1)], ..args)
#let img(path, width: 100%, ..args) = lab-img(image(path, width: width), ..args)

// ── Tujuan Praktikum ────────────────────────────────────────────────────────

= Tujuan Praktikum

#rect[
  TODO: Tulis tujuan praktikum dalam numbered list.
  Contoh:
  + Memahami mekanisme grid system Bootstrap 5.
  + Mampu mengimplementasikan layout responsif menggunakan class grid.
]

// ── Dasar Teori ─────────────────────────────────────────────────────────────

= Dasar Teori

== Konsep 1

#rect[
  TODO: Tulis penjelasan konsep pertama (1 paragraf, disertai sitasi).
]

== Konsep 2

#rect[
  TODO: Tulis penjelasan konsep kedua (1 paragraf, disertai sitasi).
]

// ── Hasil dan Pembahasan ────────────────────────────────────────────────────

= Hasil dan Pembahasan

== Tugas 1: [Judul Tugas 1]

#rect[
  TODO: Tulis pembahasan Tugas 1.
  - Jelaskan implementasi
  - Sertakan potongan kode dengan \#include-code()
  - Sertakan screenshot dengan \#img()
]

== Tugas 2: [Judul Tugas 2]

#rect[
  TODO: Tulis pembahasan Tugas 2.
]

== Tugas 3: [Judul Tugas 3]

#rect[
  TODO: Tulis pembahasan Tugas 3.
]

// ── Kesimpulan ───────────────────────────────────────────────────────────────

= Kesimpulan

#rect[
  TODO: Tulis kesimpulan dalam numbered list.
  Setiap poin harus memetakan kembali ke satu tujuan praktikum.
]
