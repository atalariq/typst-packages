// Minimal report preset — cover + body only (no TOC, no bib, no theory)
// For fast turnaround when time is tight.
//
// Usage:
//   #import "@atalariq/lab-report:2.0.0": *
//
//   #show: minimal.with(
//     ..meta,
//     association: (...),
//     year: 2026,
//   )
//
//   == Tugas 1
//   ...
//   == Tugas 2
//   ...

#import "../src/report.typ": report
#import "../src/components/cover.typ": cover

#let minimal(
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

      // User content (just hasil sections)
      body
    },
  )
}
