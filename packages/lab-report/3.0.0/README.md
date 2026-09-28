# lab-report 3.0.0

A single Typst file for Indonesian academic lab reports (UGM Sekolah Vokasi
style), with zero _network_ dependency: code blocks are rendered by
[zebraw](https://github.com/hongjr03/typst-zebraw), vendored verbatim into
`vendor/zebraw/` rather than fetched from Typst Universe.

## Usage

**Copied next to your report** (no package installation needed) — copy both
`lib.typ` and `vendor/`:

```typst
#import "lab-report.typ": *
```

**Installed as a package:**

```typst
#import "@atalariq/lab-report:3.0.0": *
```

Both import forms expose the same API below.

### Quick start (full report)

```typst
#import "lab-report.typ": *

#show: full.with(
  author: "Jane Doe",
  id: "12/345/SV/6789",
  class: "A1",
  course: "Praktikum Struktur Data",
  course-code: "PSD",
  lecturer: "Dr. John Doe",
  meeting: "4",
  title: "Implementasi Stack dan Queue",
  logo: image("assets/logo.png", width: 6cm),
  bib: bibliography("references.bib"),
)

= Tujuan Praktikum
+ ...

= Dasar Teori
...

= Hasil dan Pembahasan
#code-figure(read("src/main.py"), lang: "python", caption: [Kode utama])

= Kesimpulan
+ ...
```

### Quick start (minimal report)

```typst
#import "lab-report.typ": *

#show: minimal.with(
  author: "Jane Doe",
  id: "12/345/SV/6789",
  class: "A1",
  course: "Praktikum Struktur Data",
  course-code: "PSD",
  lecturer: "Dr. John Doe",
  meeting: "6",
  title: "Tugas Cepat",
  logo: image("assets/logo.png", width: 6cm),
)

= Kode
#code-figure(read("src/main.py"), lang: "python")
```

`bib` and `logo` are always **content**, not path strings — pass
`bibliography("references.bib")` and `image("assets/logo.png")` yourself, so
relative paths resolve against your file, not this one.

See `examples/full.typ` and `examples/minimal.typ` for complete, compiling
examples.

## API reference

### Presets

#### `full(..., body)`

Complete report: cover, Daftar Isi / Daftar Gambar / Daftar Tabel (each
auto-hidden when empty), your `body`, an optional appendix, and an optional
bibliography.

| Parameter                                                                        | Default                                                                            | Description                                                       |
| -------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| `author`, `id`, `class`, `course`, `course-code`, `lecturer`, `meeting`, `title` | none (**required**)                                                                | Cover metadata; missing any one fails with an `assert` naming it. |
| `logo`                                                                           | none (**required**)                                                                | Cover logo, e.g. `image("assets/logo.png", width: 6cm)`.          |
| `association`                                                                    | UGM Sekolah Vokasi dict (`program`, `department`, `faculty`, `university`, `city`) | Institutional block printed under the logo/table.                 |
| `year`                                                                           | `datetime.today().year()`                                                          | Year printed on the cover.                                        |
| `bib`                                                                            | `none`                                                                             | `bibliography("references.bib")` or `none` to omit.               |
| `appendix-content`                                                               | `none`                                                                             | Content for the "Lampiran" section, or `none` to omit it.         |
| `font`                                                                           | `("Times New Roman", "New Computer Modern")`                                       | Body font fallback list.                                          |
| `mono-font`                                                                      | `("Fira Code", "DejaVu Sans Mono", "Menlo", "Courier New")`                        | Code font fallback list.                                          |
| `font-size`, `lang`, `region`, `paper`, `margin`                                 | `12pt`, `"id"`, `"id"`, `"a4"`, `1in`                                              | Forwarded to `report()`.                                          |

#### `minimal(..., body)`

Stripped-down report: cover + `body` only. No outlines, no bibliography, no
appendix. Same cover/metadata parameters as `full()` minus `bib` and
`appendix-content`. Call `toc()`/`tof()`/`tot()` yourself in `body` if you
want any of them.

### Base

#### `report(font:, mono-font:, font-size:, lang:, region:, paper:, margin:, bib:, body)`

The base show rule both presets build on: page/text setup, `A. / 1. / 1.1 /
1.1.1` heading numbering, table captions above / image captions below, IEEE
numeric bibliography rendered after `body`. Use directly for a fully custom
layout instead of either preset.

### Cover

#### `cover(author:, id:, class:, course:, course-code:, lecturer:, meeting:, title:, logo:, association:, year:)`

Renders the cover page standalone (the presets call this for you). All of
`author` … `logo` are required and fail loudly if omitted.

### Outlines

#### `toc(break-page: true)` / `tof(break-page: true)` / `tot(break-page: true)`

Daftar Isi / Daftar Gambar / Daftar Tabel. Each queries the document for
outlined headings / image figures / table figures and renders **nothing at
all** — no title, no page — when the count is zero. Entries are linked with
dot leaders.

### Figures

#### `img(body, caption: none)`

`body` must be content (e.g. `image("a.png", width: 80%)`). Centers it when
`caption` is `none`; otherwise wraps it in a captioned, numbered figure
(caption below), counted separately from tables and code.

#### `tbl(caption:, columns:, align-item:, stroke:, ..rows)`

Builds a `table()` from `..rows` and optionally wraps it in a captioned,
numbered figure (caption above). `columns` accepts an int (that many equal
`1fr` columns) or an explicit array like `(auto, 1fr, 2fr)`.

#### `code-figure(body, caption: none, ..args)`

Renders `body` with `codeblock()` (see below) and optionally wraps it in a
captioned, numbered figure — using its **own** counter, independent of
`img()`/`tbl()`, and breakable across a page boundary (`report()` sets
`show figure.where(kind: "code"): set block(breakable: true)`). `..args`
forwards to `codeblock()`.

#### `codeblock(body, lang:, lang-label:, ..args)`

A preset over vendored [zebraw](https://github.com/hongjr03/typst-zebraw)
(`vendor/zebraw/`, see `vendor/zebraw/README.md`), styled to match this
template: a bordered rounded frame, a grey floating language tab, a flat
white background, line numbers with a gutter separator, hanging indent on
wrapped lines. `body` is a `raw` element or a plain string (`lang:` names its
language). `..args` is forwarded straight to zebraw's own `zebraw()` — see
[its README](vendor/zebraw/README.md) or `vendor/zebraw/src/mod.typ` for the
full parameter list: `numbering:`, `highlight-lines:` (e.g.
`((8, [note content]),)` to highlight line 8 with an annotation), `header:`,
`footer:`, `line-range:`, etc. `codeblock`/`code-figure` also re-export
`zebraw` itself, for callers who want it unstyled.

**Language aliasing**: Typst's built-in highlighter only colours a
` ```php ` block once the source opens with `<?php`, and has no
`blade` grammar. `codeblock` resolves this transparently — a bare PHP
snippet is highlighted as `PHP Source`, and `blade` is highlighted as `html`
— while the tab still shows the original name (`php` / `blade`).

### Layout

#### `col(gutter: 1em, ratio: none, responsive: false, threshold: 30em, ..contents)`

Lays `..contents` out in `contents.len()` columns (equal `1fr` unless
`ratio` is given). With `responsive: true`, stacks into a single column
when the available width drops below `threshold`.

### Sections

#### `appendix(body)`

An unnumbered "Lampiran" heading followed by `body`, on its own page.

### Config

#### `CONTENT`

One dict holding every Indonesian label the template prints (cover text,
"Disusun Oleh:" labels, figure/table/code supplement words, outline titles,
"Daftar Pustaka", "Lampiran"). Fork `lib.typ` and edit this dict to relabel
the whole template (e.g. to English) in one place.

## Fonts

Body text defaults to `("Times New Roman", "New Computer Modern")` and code
to `("Fira Code", "DejaVu Sans Mono", "Menlo", "Courier New")`. Both lists
end in a font Typst bundles into its own binary (`New Computer Modern` for
text, `DejaVu Sans Mono` for code), so even a machine with **none** of the
other fonts installed still renders correctly — Typst falls through the
whole list and lands on its own embedded font rather than warning or
substituting something unpredictable. Override `font:` / `mono-font:` on
`report()`, `full()`, or `minimal()` for a different stack.

## Design notes

- `bib` and `logo` are always content, never path strings, so relative
  paths in your call resolve against _your_ file.
- Every cover field (including `logo`) is required and fails loudly via
  `assert` if omitted — there is no silent placeholder or blank box.
- `objectives()` / `results()` / `conclusion()` section helpers from 2.0.0
  were dropped: they added no real capability over writing `= Heading`
  directly, and the body is freeform either way.
