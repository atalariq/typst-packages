# Changelog

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
