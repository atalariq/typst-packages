# Typst Package Reference

## Import

```typst
#import "@atalariq/lab-report:2.0.0": *
```

## Preset (recommended)

```typst
#show: full.with(
  ..metadata,
  association: (...),
  bib: bibliography("references.bib"),
  appendix-content: [#include-code("src/main.py")],
)
```

## Component usage (custom composition)

```typst
#show: report.with(font: "Times New Roman")
#cover(..metadata, ...)
#toc()
#objectives[+ ...]
#results[...]
#bibliography(bibliography("refs.bib"))
```

## Metadata object

```typst
#let metadata = (
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "...",
  course-code: "...",
  lecturer: "...",
  meeting: "...",
  title: "...",
)
```

## Association object (cover only)

```typst
association: (
  program: "Teknologi Rekayasa Perangkat Lunak",
  department: "Teknik Elektro dan Informatika",
  faculty: "Sekolah Vokasi",
  university: "Universitas Gadjah Mada",
  city: "Yogyakarta",
  logo: image("assets/logo.png", width: 6cm),
),
```

## Known-good helpers

| Helper | Signature | Purpose |
|--------|-----------|---------|
| `report` | `#show: report.with(font:, code-font:, font-size:)` | Base show rule |
| `full` | `#show: full.with(..meta, bib:, appendix-content:)` | Full preset: cover→toc→body→bib→appendix |
| `minimal` | `#show: minimal.with(..metadata, ...)` | Minimal: cover→body only |
| `cover` | `#cover(..metadata, association:, year:, logo:)` | Cover page |
| `toc` / `tof` / `tot` | `#toc()` | Table of contents/figures/tables |
| `objectives` | `#objectives[+ item 1 + item 2]` | Tujuan section |
| `results` | `#results[...]` | Hasil section |
| `conclusion` | `#conclusion[+ item 1]` | Kesimpulan section |
| `bibliography` | `#bibliography(bibliography("refs.bib"), title: "...")` | Bibliography |
| `appendix` | `#appendix[#include-code("src/main.py")]` | Lampiran |
| `include-code` | `#include-code(path, line-range: (start, end))` | Code block from file. **line-range is end-exclusive** — add 1 to last line. |
| `img` | `#img(path, caption:, width:)` | Image with caption |
| `code` | `#code(header:, numbering:, raw-block)` | Inline code block |
| `code-block` | `#code-block(body, caption:, lang:)` | Numbered code figure |
| `col` | `#col(block1, block2, responsive:, threshold:)` | Two-column. **SHORT snippets only (<15 lines/side).** |
| `tbl` | `#tbl(caption:, columns:, ...cells)` | Styled table |
| `rect` | `#rect[...]` | TODO placeholder |

## Helper bindings

**Check existing bindings first.** Two styles exist:

**Style A** (package-based, from `@atalariq/code`):
```typst
#let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), header: [#path.split("/").at(-1)], ..args)
#let img(path, ..args) = image-wrapper(read(path, encoding: none), ..args)
```

**Style B** (stdlib-based):
```typst
#let include-code(path, ..args) = code(header: path, numbering: true, raw(read(path), lang: path.split(".").last(), ..args))
#let img(path, caption: [], width: 100%) = figure(image(path, width: width), caption: caption)
```

Never mix. If Style B exists in file, use Style B throughout.

## Heading levels

- `=` → numbered chapter
- `==` → numbered section
- `===` → numbered subsection
- `#pagebreak()` before `= Hasil dan Pembahasan`, between each `== Tugas`, before `= Kesimpulan`

## What NOT to do

- Never use `#include` for `.typ` sub-files unless user sets it up.
- Never invent functions (`#figure-caption`, `#code-block`, `#highlight`).
- Never use `#set page()` or `#set text()` directly — `report` show rule manages styling.
- Never use `meeting` as integer — always string `"8"` not `8`.
- Never guess `line-range`. Read the file first, verify complete logical unit.
- Never use `#col()` for code >15 lines. Use full-width `#include-code()` instead.
- Never use `outlined: false` on Lampiran heading (must appear in TOC).
- Hex colors: strip `#` prefix in prose (`C9963B` not `#C9963B`).
- Angle brackets `<` in prose → Typst interprets as label. Use `(di bawah 768 px)` or `\<`.
- `#include-code()` in `#rect[]` → escape: `\#include-code()`.
- Definition list: `/ term: description` — colon must be on same line as `/`.
- Maths: `$O(1)$` inline. Only for algo/DS matkul, not PPW1.
