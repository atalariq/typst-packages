#import "config/content.typ": CONTENT

#let report(
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "<course-name>",
  course-code: "<course-code>",
  lecturer: "<lecturer-name>",
  meeting: "<meeting>",
  title: "<report-title>",
  year: datetime.today().year(),
  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
    logo: none,
  ),
  lang: "id",
  region: "id",
  use-cover: true,
  bib: none,
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 12pt,
  paper: "a4",
  margin: 1in,
  body,
) = {
  //? Document
  set document(author: author, title: title)
  set page(paper: paper, margin: margin)

  //? Font
  set text(font: font, size: font-size, lang: lang, region: region)
  show raw: set text(font: code-font, size: 0.95em)
  show raw.where(block: true): set text(size: 0.85em)

  //? Paragraph
  // set par(leading: 0.65em, spacing: 2em, linebreaks: "optimized")

  //? Heading
  // show heading: set block(above: 1.4em, below: 1em)
  set heading(numbering: (..nums) => {
    nums = nums.pos()
    if nums.len() == 1 {
      return numbering("A.", nums.first())
    } else if nums.len() == 2 {
      return numbering("1.", nums.last())
    } else if nums.len() == 3 {
      return numbering("1.1", ..nums.slice(1))
    } else if nums.len() == 4 {
      return numbering("1.1.1", ..nums.slice(1))
    } else {
      return numbering("1.", nums.last())
    }
  })

  //? Table
  show figure.where(kind: table): set figure.caption(position: top)

  //? Figure
  set figure(supplement: it => {
    if it.func() == image { CONTENT.supplement.image } else if it.func() == table { CONTENT.supplement.table } else if (
      it.func() == raw
    ) { CONTENT.supplement.raw }
  })

  ////? Term List
  //show terms: it => {
  //  let rows = ()
  //  for item in it.children {
  //    rows.push(strong(item.term))
  //    rows.push(item.description)
  //  }
  //  table(
  //    columns: (auto, 1fr),
  //    stroke: none,
  //    gutter: 0pt,
  //    ..rows,
  //  )
  //}

  //? Bib
  set bibliography(style: "ieee", title: none, full: true)

  //? BEGIN OF CONTENT
  [#metadata(none)#label("report:begin")]

  //? Cover
  if use-cover {
    // Full cover
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

      //? Logo
      #if "logo" in association {
        association.logo
      } else {
        rect(width: 6cm, height: 6cm)
      }

      #v(1fr)

      //? Metadata
      #CONTENT.reported-by.title
      #table(
        columns: 3,
        align: left,
        stroke: none,
        [#CONTENT.reported-by.name], [:], [#author],
        [#CONTENT.reported-by.id], [:], [#id],
        [#CONTENT.reported-by.class], [:], [#course-code\-#class],
        [#CONTENT.reported-by.lecturer], [:], [#lecturer],
      )

      #v(1fr)

      //? Associations
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

  //? Content
  body

  //? References
  if bib != none {
    let resolved-title = if use-cover { CONTENT.bibliography } else { CONTENT.references }
    if use-cover { pagebreak() }
    align(center)[
      #heading(level: 1, numbering: none)[#resolved-title]
    ]
    set text(size: 0.9em)
    bib
  }

  //? END OF CONTENT
  [#metadata(none)#label("report:end")]
}
