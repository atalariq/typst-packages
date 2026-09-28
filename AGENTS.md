# Agent Notes

## Repository

Local Typst package registry for `@atalariq/*` packages + agent skills.
Pure Typst source, no build step; `.github/workflows/compile-check.yml`
compiles the current-version example of every package plus a scaffolded
skill report on every push/PR — see `## Verification` for the same commands
locally.

## Change Control

- `CONTEXT.md` — domain glossary (laprak, preset, course-specific config,
  SCAFFOLD/PUZZLE/DRAFT, compile gate, vendoring). Read it for vocabulary
  before using a term that might mean something specific here; update it
  the moment a term gets resolved or challenged, not in a batch later.
- `docs/adr/` — decisions that are hard to reverse, surprising without
  context, or the result of a real trade-off (not every choice). Check
  before "fixing" something that looks wrong but was deliberate.
- Both maintained via the `domain-modeling` skill pattern (glossary +
  lazy ADRs), not a heavier process — this is a personal, single-maintainer
  repo.

## Local Setup (Required)

Run `setup.sh` once to symlink both packages and skills. It resolves the
platform-specific Typst packages directory itself (macOS:
`~/Library/Application Support/typst/packages`; elsewhere:
`${XDG_DATA_HOME:-~/.local/share}/typst/packages`) — don't hardcode either
path, read `setup.sh` for the current logic:

```bash
./setup.sh
```

This creates:

- `<platform typst packages dir>/atalariq` → `packages/`
- `~/.agents/skills/typst-lab-report` → `skills/typst-lab-report/`

## Package Layout

Follows Typst local package convention: `packages/<name>/<version>/`.

| Package      | Version | Entrypoint    | Notes                                                                                                                                                                                                                                                                                                                                                                       |
| ------------ | ------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lab-report` | 3.0.0   | `lib.typ`     | Single-file lab report template. Code blocks via vendored `vendor/zebraw/` (no network dependency).                                                                                                                                                                                                                                                                         |
| `code`       | 1.0.0   | `src/lib.typ` | Codeblock utilities, standalone (still `@preview/zebraw:0.6.1` via network, not vendored). Kept independently — `ppbo.md`'s course config wires to it directly, and reports predating lab-report 2.0.0 import it directly too; not synced to lab-report's vendored zebraw. `codedis` is adapted from [AugustinWinther/codedis](https://github.com/AugustinWinther/codedis). |
| `cv`         | 1.0.0   | `src/lib.typ` | ATS-friendly CV template. Ligatures are intentionally disabled.                                                                                                                                                                                                                                                                                                             |

## Skills Layout

| Skill              | Path                       | Description                                                    |
| ------------------ | -------------------------- | -------------------------------------------------------------- |
| `typst-lab-report` | `skills/typst-lab-report/` | 3-mode lab report generator. Symlinked to `~/.agents/skills/`. |

## Entrypoints & Exports

- Each package exposes its public API through its entrypoint (see Package Layout table) via `#import "@atalariq/<name>:<version>": *`.
- `lab-report` (3.0.0) exports `report` (base show rule), presets `full`/`minimal`, `cover`, outlines `toc`/`tof`/`tot`, figure helpers `img`/`tbl`/`code-figure`, `codeblock` (a styled preset over vendored `zebraw`, also re-exported directly), layout helper `col`, `appendix`, and `CONTENT` (the Indonesian label dict). `daftar-isi`/`image-wrapper`/`objectives`/`results`/`conclusion` etc. are dead 1.0.0/2.0.0-era names — do not use them.
- `code` (1.0.0) exports `code`, `code-from-file`, `codedis`, and `zebraw-wrapper`.
- `cv` (1.0.0) exports `cv`, layout helpers (`generic-two-by-two`, `generic-one-by-two`), and section components (`edu`, `work`, `experience`, `project`, `certificates`, `extracurriculars`).

## Verification

No automated test suite, but CI (`.github/workflows/compile-check.yml`) compiles the current-version example of every package plus a scaffolded skill report on every push/PR. Run the same checks locally:

```bash
# lab-report
typst compile packages/lab-report/3.0.0/examples/full.typ
typst compile packages/lab-report/3.0.0/examples/minimal.typ

# code
typst compile packages/code/1.0.0/example/main.typ

# cv
typst compile packages/cv/1.0.0/example/cv.typ

# skill scaffold
bash skills/typst-lab-report/scripts/new-laporan.sh test-folder
typst compile test-folder/report.typ
```

## Language & Defaults

- `lab-report` defaults to Indonesian (`lang: "id"`, `region: "id"`), Times New Roman, and UGM academic metadata.
- `cv` defaults to English (`lang: "en"`), New Computer Modern, and `us-letter` paper.

## When modifying typst-lab-report skill

- The skill is stored at `skills/typst-lab-report/` (symlinked into `~/.agents/skills/`).
- Changes take effect immediately — no reload needed.
- Always fix both the SKILL.md AND any referenced template files in `packages/lab-report/` if they're related.
- After changing SKILL.md, verify the agent host can still load it: reload the session or test with a simple task.
- `skills/typst-lab-report/VERSION` declares the minimum `lab-report` version the skill assumes; SKILL.md's `## Version Check` section is the actual enforcement point — keep both in sync when the API changes.
