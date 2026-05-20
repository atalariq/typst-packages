# Agent Notes

## Repository
Local Typst package registry for `@atalariq/*` packages + Hermes agent skills.
No build system, CI, or tests — everything is pure Typst source.

## Local Setup (Required)

Run `setup.sh` once to symlink both packages and skills:

```bash
./setup.sh
```

This creates:
- `~/.local/share/typst/packages/atalariq` → `packages/`
- `~/.hermes/skills/productivity/typst-lab-report` → `skills/typst-lab-report/`

## Package Layout
Follows Typst local package convention: `packages/<name>/<version>/`.

| Package      | Version | Entrypoint    | Notes                                                                                                                                                                    |
| ------------ | ------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `lab-report` | 1.0.0   | `src/lib.typ` | Indonesian lab report template for UGM. Hardcoded defaults (author, ID format, association names) are specific to the author; consumers override via `report.with(...)`. |
| `code`       | 1.0.0   | `src/lib.typ` | Codeblock utilities. `codedis` is adapted from [AugustinWinther/codedis](https://github.com/AugustinWinther/codedis).                                                   |
| `cv`         | 1.0.0   | `src/lib.typ` | ATS-friendly CV template. Ligatures are intentionally disabled.                                                                                                          |

## Skills Layout

| Skill | Path | Description |
|-------|------|-------------|
| `typst-lab-report` | `skills/typst-lab-report/` | 3-mode lab report generator. Symlinked to `~/.hermes/skills/productivity/`. |

## Entrypoints & Exports
- Each package exposes its public API through `src/lib.typ` via `#import "./<module>.typ": *`.
- `lab-report` exports `report` (main template), helper functions (`daftar-isi`, `daftar-gambar`, `daftar-tabel`, `image-wrapper`, `col`, `tbl`), and `CONTENT` config from `config/content.typ`.
- `code` exports `code`, `code-from-file`, `codedis`, and `zebraw-wrapper`.
- `cv` exports `cv`, layout helpers (`generic-two-by-two`, `generic-one-by-two`), and section components (`edu`, `work`, `experience`, `project`, `certificates`, `extracurriculars`).

## Verification
No automated test suite. Validate changes by compiling example documents:

```bash
# lab-report
typst compile packages/lab-report/1.0.0/examples/main.typ

# code
typst compile packages/code/1.0.0/example/main.typ

# cv
typst compile packages/cv/1.0.0/example/cv.typ
```

## Language & Defaults
- `lab-report` defaults to Indonesian (`lang: "id"`, `region: "id"`), Times New Roman, and UGM academic metadata.
- `cv` defaults to English (`lang: "en"`), New Computer Modern, and `us-letter` paper.

## When modifying typst-lab-report skill
- The skill is now stored at `skills/typst-lab-report/` (symlinked into `.hermes/skills/`).
- Changes take effect immediately — no reload needed for Hermes.
- Always fix both the SKILL.md AND any referenced template files in `packages/lab-report/` if they're related.
- After changing SKILL.md, verify Hermes can still load it: reload the session or test with a simple task.
