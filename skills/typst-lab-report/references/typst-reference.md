# Typst Package Reference

## Import

```typst
#import "@atalariq/lab-report:3.0.0": *
```

## Preset (recommended)

```typst
#show: full.with(
  ..metadata,
  logo: image("assets/logo.png", width: 6cm),
  association: (...),
  bib: bibliography("references.bib"),
  appendix-content: [#include-code("src/main.py")],
)
```

`logo` is a **top-level** parameter of `full`/`minimal`/`cover`, never inside
`association`. It's required — omitting it fails loudly with an `assert`.

## Component usage (custom composition)

```typst
#show: report.with(font: "Times New Roman")
#cover(..metadata, logo: image("assets/logo.png", width: 6cm), ...)
#toc()
= Tujuan Praktikum
+ ...
#bibliography("refs.bib")
```

There is no `objectives()`/`results()`/`conclusion()` component in 3.0.0 —
write `= Tujuan Praktikum` etc. directly; the body is freeform either way.

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

## Association object (cover only — no `logo` key here)

```typst
association: (
  program: "Teknologi Rekayasa Perangkat Lunak",
  department: "Teknik Elektro dan Informatika",
  faculty: "Sekolah Vokasi",
  university: "Universitas Gadjah Mada",
  city: "Yogyakarta",
),
```

## Known-good helpers

| Helper                | Signature                                                  | Purpose                                                                                |
| --------------------- | ---------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `report`              | `#show: report.with(font:, mono-font:, font-size:, bib:)`  | Base show rule                                                                         |
| `full`                | `#show: full.with(..meta, logo:, bib:, appendix-content:)` | Full preset: cover→toc/tof/tot→body→bib→appendix                                       |
| `minimal`             | `#show: minimal.with(..metadata, logo:, ...)`              | Minimal: cover→body only                                                               |
| `cover`               | `#cover(..metadata, logo:, association:, year:)`           | Cover page, called standalone                                                          |
| `toc` / `tof` / `tot` | `#toc()`                                                   | Daftar Isi/Gambar/Tabel — auto-hidden when empty                                       |
| `img`                 | `#img(body, caption:)`                                     | `body` is content (`image(...)`), not a path — see `include-code`/`img` bindings below |
| `tbl`                 | `#tbl(caption:, columns:, ..rows)`                         | Styled table                                                                           |
| `code-figure`         | `#code-figure(body, caption:, lang:, ..zebraw-args)`       | Numbered code figure; `body` is a raw block or a string                                |
| `codeblock`           | `#codeblock(body, lang:, ..zebraw-args)`                   | Same rendering, uncaptioned                                                            |
| `col`                 | `#col(block1, block2, responsive:, threshold:)`            | Two-column. **SHORT snippets only (<15 lines/side).**                                  |
| `appendix`            | `#appendix[...]`                                           | Lampiran, its own page                                                                 |
| `CONTENT`             | dict                                                       | Every Indonesian label the template prints; fork `lib.typ` to relabel                  |

`code-figure`/`codeblock` forward `..args` straight to zebraw (vendored in
`packages/lab-report/3.0.0/vendor/zebraw/`) — useful ones: `numbering:`
(bool), `line-range: (lo, hi)` (1-based, **end-exclusive** — add 1 to the
last line you want), `highlight-lines: ((8, [note content]),)` to highlight
a line with an annotation, `header:`, `footer:`. There is no `range`,
`highlight: (line:, note:)`, `numbers:`, `tab:`, or `font:` parameter —
those were the old (pre-2026-09-28) from-scratch engine's names.

**Always set `lang:`.** Typst's built-in highlighter needs it to colour
anything; a bare fenced block with no language stays plain black-and-white.
`code-figure`/`codeblock` alias two special cases so the tab still shows the
name you wrote: `php` highlights even without a `<?php` opening tag, and
`blade` highlights using the `html` grammar.

## Helper bindings

**Check existing bindings first.** `img`/`toc` etc. are the package's own
names — don't redefine them without aliasing the original first (a `#let
img(...) = img(...)` self-reference recurses infinitely). This is the
`report.typ` template's pattern:

```typst
#import "@atalariq/lab-report:3.0.0": *
#import "@atalariq/lab-report:3.0.0": img as lab-img

#let include-code(path, ..args) = code-figure(read(path), lang: path.split(".").at(-1), header: [#path.split("/").at(-1)], ..args)
#let img(path, width: 100%, ..args) = lab-img(image(path, width: width), ..args)
```

## Heading levels

- `=` → numbered chapter
- `==` → numbered section
- `===` → numbered subsection
- `#pagebreak()` before `= Hasil dan Pembahasan`, between each `== Tugas`, before `= Kesimpulan`

## What NOT to do

- Never use `#include` for `.typ` sub-files unless user sets it up.
- Never invent functions (`#figure-caption`, `#highlight`, `#code()`, `#code-block()`, `#image-wrapper()` — all dropped in 3.0.0).
- Never use `#set page()` or `#set text()` directly — `report` show rule manages styling.
- Never use `meeting` as integer — always string `"8"` not `8`.
- Never guess `line-range`. Read the file first, verify complete logical unit, remember it's end-exclusive.
- Never use `#col()` for code >15 lines. Use full-width `#code-figure()`/`#include-code()` instead.
- Never use `outlined: false` on Lampiran heading (must appear in TOC).
- Never write a bare code fence without `lang:` if it should be highlighted — see the aliasing note above for `php`/`blade`.
- Hex colors: strip `#` prefix in prose (`C9963B` not `#C9963B`).
- Angle brackets `<` in prose → Typst interprets as label. Use `(di bawah 768 px)` or `\<`.
- A literal `#include-code()`/`#img()` written as prose text (e.g. inside a `#rect[]` TODO placeholder) is still a real function call — escape it: `\#include-code()`.
- Definition list: `/ term: description` — colon must be on same line as `/`.
- Maths: `$O(1)$` inline. Only for algo/DS matkul, not PPW1.
