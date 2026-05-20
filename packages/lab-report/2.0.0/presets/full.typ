// Full report preset — cover + TOC + body + bibliography + lampiran
//
// Usage:
//   #import "@atalariq/lab-report:2.0.0": *
//
//   #show: full.with(
//     ..meta,
//     association: (...),
//     year: 2026,
//     logo: image("assets/logo.png"),
//     bib: bibliography("references.bib"),
//     lampiran: [#include-code("src/main.py")],
//   )
//
//   = Tujuan Praktikum
//   + ...
//   = Dasar Teori
//   ...
//   = Hasil dan Pembahasan
//   ...
//   = Kesimpulan
//   + ...

#import "../src/report.typ": report
#import "../src/components/cover.typ": cover
#import "../src/components/toc.typ": toc
#import "../src/components/references.typ": lampiran

#let full(
  // Metadata
  author: "…",
  id: "…",
  class: "…",
  course: "…",
  course-code: "…",
  lecturer: "…",
  meeting: "…",
  title: "…",
  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
  ),
  year: datetime.today().year(),
  logo: none,

  // Optional extras
  bib: none,          // bibliography("refs.bib") or none
  lampiran: none,     // content block or none

  // Base config (passed to report())
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 12pt,
  lang: "id",
  region: "id",
  paper: "a4",
  margin: 1in,

  // Content
  body,
) = {
  report(
    font: font,
    code-font: code-font,
    font-size: font-size,
    lang: lang,
    region: region,
    paper: paper,
    margin: margin,
    bib: bib,

    {
      // Cover
      cover(
        author: author,
        id: id,
        class: class,
        course: course,
        course-code: course-code,
        lecturer: lecturer,
        meeting: meeting,
        title: title,
        association: association,
        year: year,
        logo: logo,
      )

      // Table of contents
      toc()

      // User content (tujuan, dasar teori, hasil, kesimpulan, etc.)
      body

      // Lampiran (rendered before bib which is handled by report())
      if lampiran != none {
        lampiran(lampiran)
      }
    },
  )
}
