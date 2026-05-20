# import "../config/content.typ": CONTENT

// Render cover page.
// Spread metadata dict as keyword args, e.g.:
// #cover(..meta, association: (...), year: 2026, logo: image("logo.png"))
#let cover(
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
) = {
  align(center)[
    #upper(
      text(size: 1.25em, weight: "bold")[
        #CONTENT.cover.title \
        #course \
        #CONTENT.cover.meeting #meeting \
        #title
      ],
    )

    #v(1fr)

    #if logo != none {
      logo
    } else {
      rect(width: 6cm, height: 6cm)
    }

    #v(1fr)

    #CONTENT.reported-by.title
    #table(
      columns: 3,
      align: left,
      stroke: none,
      [#CONTENT.reported-by.name], [:], [#author],
      [#CONTENT.reported-by.id], [:], [#id],
      [#CONTENT.reported-by.class], [:], [#course-code \- #class],
      [#CONTENT.reported-by.lecturer], [:], [#lecturer],
    )

    #v(1fr)

    #text(weight: "bold")[
      #upper(association.program) \
      #upper(association.department) \
      #upper(association.faculty) \
      #upper(association.university) \
      #upper(association.city) \
      #year
    ]
  ]

  pagebreak()
}
