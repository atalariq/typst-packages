# Changelog

## [3.0.0] — 2026-09-24

### Added

- **Single-file template.** The whole package is one `lib.typ` with no _network_ import, so it can be copied next to a report and imported relatively (`#import "lab-report.typ": *`) or installed and imported as a package. A laprak sent to someone else compiles on their machine without downloading anything.
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

- Section helpers `objectives()`, `results()`, `conclusion()`. Writing `= Tujuan Praktikum` directly is the same amount of work and one less thing to learn.

## [3.0.0] — 2026-09-28: codeblock rewritten on vendored zebraw

The from-scratch code-block engine shipped above had rough spacing and no
way to break a long figure across a page without leaving the rest of the
page blank. Replaced with a preset over
[zebraw](https://github.com/hongjr03/typst-zebraw) 0.6.3, vendored verbatim
into `packages/lab-report/3.0.0/vendor/zebraw/` (with one small local patch,
documented in `vendor/zebraw/README.md`) so the package keeps its zero
_network_-dependency property — nothing is fetched from Typst Universe at
compile time, but the "copy one file" usage mode now means copying `lib.typ`
**and** `vendor/`.

### Added

- **Language aliasing.** Typst's built-in highlighter only colours a ` ```php ` block once the source opens with `<?php`, and has no `blade` grammar. `codeblock`/`code-figure` now resolve this transparently — a bare PHP snippet highlights as `PHP Source`, `blade` highlights as `html` — while the tab still shows the original name.
- Code figures (`figure(kind: "code")`) can now break across a page boundary instead of jumping to the next page as one block and leaving a half-empty page behind (`report()`: `show figure.where(kind: "code"): set block(breakable: true)`).
- `codeblock`/`code-figure` re-export `zebraw` itself for callers who want it unstyled.

### Changed

- **Breaking: `codeblock`/`code-figure` take zebraw's own parameters**, not the old engine's. `numbers:` → `numbering:`, `range:`/`range-restart:` → `line-range:`, `highlight: (line:, color:, note:)` → `highlight-lines:` (e.g. `((8, [note content]),)`), `tab:`/`tab-color:`/`background:`/`annotate-*`/`number-*`/`font:` are gone — see `vendor/zebraw/src/mod.typ` or the README for the equivalents. `lang:` and `lang-label:` are unchanged. The only user found on this version (a p6 report using just `caption:`) was unaffected.

### Removed

- The from-scratch code-block engine (line-number gutter math, `show raw.line` rebuilding, the `measure()`/`par()` workarounds it needed) — superseded by zebraw.

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

### Changed (2026-09-29)

- Bibliography format switched from BibLaTeX (`references.bib`) to native Hayagriva (`references.yaml`) across the scaffold, `new-laporan.sh`, and all reference docs. Old `.bib` reports are untouched and still compile — nothing is retroactively converted.
- `language-rules.md`'s blanket "purely passive voice" rule replaced with nuance from `~/Kuliah/meta/ARTICLE.md`: impersonal passive is the expected register for procedure, not itself a violation; the actual rule is don't hide an actor whose identity the next step depends on knowing.
- Diátaxis's how-to/explanation separation deliberately **not** adopted — `Langkah Kerja` may restate relevant theory inline (Codelabs-style reading flow over strict mode separation), recorded as guidance only.

### Fixed (2026-09-29)

- `compile-gate.md`'s bib-checker script used `grep -oP` (PCRE), which macOS's stock `grep` (BSD) can't run at all — it never worked on this machine. Rewritten portably (`grep -E`/`sed -E`); same fix applied to the path validator and structure checker in the same file.
- Its `@preview`-exclusion regex and an `@`-prefix mismatch between bib-keys and used-keys meant the missing/unused citation check could never have matched correctly even with a working `-P`.

### Changed (2026-09-28)

- Templates/references updated to `lab-report >=3.0.0` (`VERSION`, `templates/report.typ`, `references/typst-reference.md`).
- `code-figure()` replaces `code-from-file()`; `logo:` moved to a top-level `full()`/`cover()` parameter instead of nested in `association:` (silently ignored there in 2.0.0, hard-fails in 3.0.0).

### Fixed (2026-09-28)

- `templates/report.typ`'s `#<space>` lines (`# import`, `# let`, ...) were never valid Typst syntax — verified every one fails to parse. Its own TODO placeholder text also called `#include-code()`/`#img()` unescaped inside a `#rect[]` block, the exact mistake `references/failure-modes.md` already warned against.

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
