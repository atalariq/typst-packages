# Changelog

## [3.0.0] — 2026-09-24

### Added
- **Single-file template.** The whole package is one `lib.typ` (787 lines) with no external imports, so it can be copied next to a report and imported relatively (`#import "lab-report.typ": *`) or installed and imported as a package. A laprak sent to someone else compiles on their machine without downloading anything.
- **Own code-block renderer**, written in plain Typst, replacing `@preview/zebraw`: line numbers with offset and separator, line ranges with optional renumbering, line highlighting (single, array, custom colour, annotation comment, or colour plus annotation), configurable annotation prefix and colour, header and footer inside the frame, language tab, single or alternating background colours, hanging indent on wrapped lines, configurable inset and radius. Verified to keep numbering and striping intact across a mid-block page break.
- **Font fallback lists** instead of single font names, so the template degrades gracefully on a machine without Fira Code or Times New Roman.
- **Loud failure on missing required parameters.** `cover()` asserts with a message naming the parameter and showing a correct call.

### Changed
- **Breaking: `bib` and `logo` are content, not path strings.** Pass `bib: bibliography("references.bib")` and `logo: image("assets/logo.png")`. Typst resolves a relative path against the file where `bibliography()` or `image()` is written, so passing content from the calling file is what makes paths resolve against the report's own folder.
- `code()` / `code-from-file()` / `code-block()` collapsed into `codeblock()` plus `code-figure()` for the captioned variant.
- `image-wrapper()` renamed to `img()` and no longer takes `width`. The caller sizes their own `image()` and passes finished content.
- `cover()`'s identity fields and `logo` are now required rather than defaulting to placeholder text.

### Fixed
- `setup.sh` symlinked packages into `~/.local/share/typst/packages` on every platform. Typst on macOS reads `~/Library/Application Support/typst/packages`, so `@atalariq/*` never resolved there. The script now picks the directory per platform.
- 2.0.0's `examples/full.typ` set `logo` inside the `association` dict, but `cover()` reads `logo` as a top-level parameter, so that example's logo was silently ignored. `logo` is now unambiguously top-level.
- `cover()` drew an empty `rect` when `logo` was `none` instead of reporting the mistake.

### Removed
- Dependency on `@preview/zebraw`. Nothing is downloaded at compile time.
- Section helpers `objectives()`, `results()`, `conclusion()`. Writing `= Tujuan Praktikum` directly is the same amount of work and one less thing to learn.
- Not carried over from zebraw, deliberately: the copy button and HTML export hooks (`zebraw-init`), built-in themes (`zebraw-themes`), `fast-preview`, indentation guide lines, and the separate font dictionaries for comments, language tab, and line numbers. One `font` parameter covers all three.

## [2.0.0] — 2026-05-20

### Added
- **Modular component system** — independent building blocks: `cover()`, `objectives()`, `results()`, `conclusion()`, `toc()`, `tof()`, `tot()`, `print-bibliography()`, `appendix()`.
- **Presets** — `full` (cover → toc → body → bib → appendix) and `minimal` (cover → body only) for quick setup.
- **Code merged from `@atalariq/code`** — `code()`, `code-from-file()`, and new `code-block()` (source code as numbered figure with its own counter) are now built into `@atalariq/lab-report`. Single import, no separate package needed.
- **`col(responsive: true, threshold: 30em)`** — columns auto-stack vertically when container width drops below threshold.
- **`appendix-content` parameter** on `full` preset for including appendix content.

### Changed
- **Breaking: API restructured.** `report.with(...)` is now a bare show rule (fonts, margins, numbering only). Cover, bib, and lampiran are handled by components or presets. Migration guide:
  - `#show: report.with(...)` → `#show: full.with(...)` for complete reports, or use components individually.
  - `use-cover` flag removed → call `#cover(...)` explicitly or use preset.
- **Function names in English.** `tujuan()` → `objectives()`, `hasil()` → `results()`, `kesimpulan()` → `conclusion()`, `lampiran()` → `appendix()`, `daftar-isi/gambar/tabel()` → `table-of-contents/list-of-figures/list-of-tables()`.
- **`CONTENT` labels remain Indonesian** (section headings in reports stay "Tujuan Praktikum", "Hasil dan Pembahasan", etc.).
- **Bibliography heading** now always shows "Daftar Pustaka" centered. Removed dual label (`bibliography` vs `references`).
- **Removed dead code** from `report.typ` (commented-out term list, old spacing rules).

### Fixed
- Lampiran heading no longer uses `outlined: false` (now appears in Table of Contents).
- `examples/main.typ` double `#set par()` merged (justification now works correctly).

### Removed
- `@atalariq/code` is no longer a required import (merged into lab-report).
- `use-cover` and `lampiran` parameters from `report()` (handled by components instead).
- `CONTENT.references` label (use `CONTENT.bibliography` consistently).
- Compiled PDFs (`*.pdf`) removed from git tracking.

## [1.0.0] — 2026-04-29

### Added
- Initial release: monolithic `report.with()` template.
- Cover, daftar isi, helpers (`col`, `tbl`, `image-wrapper`).
- Course-specific configs (PPW1, PBD, PPBO, PSD).

---

## Hermes Skill (`typst-lab-report`)

### Added (2026-05-20)
- **Course auto-detect (Phase S0)** — extracts meeting number, course-code, and course name from folder name patterns, `TASK.md`/`README.md` content, and parent directory names.
- **Enhanced compile gate (Section 6)** — pre-compile checks: bib validator, path checker, structure checker via `typst query`.
- **Version lock** — `VERSION` file declares `lab-report >=2.0.0`. Skill warns if user tries to use an older template version.
- **Reference files:** `css-frameworks.md`, `php-patterns.md`, `laprak-evaluasi.md` merged into skill directory.

### Changed
- Skill stored at `~/Repos/typst-packages/skills/typst-lab-report/` and symlinked from `.hermes/skills/`. Changes tracked in repo.
- All template API references updated to 2.0.0 in SKILL.md.

### Removed
- Standalone skills `lab-report`, `practicum-laporan`, `ppw1`, `praktikum-basis-data` absorbed into `typst-lab-report`.
- Cron-based skills `morning-briefing-daily`, `study-buddy-daily-review` (inactive), `news-digest`, `paper-digest` (user request — laptop often off).
- `content-synthesis` absorbed into `study-guide-curation`.
- `platform-aware-formatter` skill (convention moved to memory then removed).
