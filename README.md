# Atalariq's Typst Packages

Local Typst package registry + Hermes agent skills.

## Installation

```bash
chmod +x setup.sh && ./setup.sh
```

This will:
- Symlink `packages/` → the platform's Typst package directory, as `atalariq`
- Symlink `skills/typst-lab-report` → `~/.hermes/skills/productivity/typst-lab-report`

## Typst Packages

| Package | Version | Entrypoint | Description |
|---------|---------|------------|-------------|
| `lab-report` | 3.0.0 | `lib.typ` | Indonesian lab report template for UGM. Single file, zero external dependencies |
| `lab-report` | 2.0.0 | `src/lib.typ` | Previous modular version. Depends on `@preview/zebraw` |
| `lab-report` | 1.0.0 | `src/lib.typ` | First release, monolithic |
| `code` | 1.0.0 | `src/lib.typ` | Codeblock utilities |
| `cv` | 1.0.0 | `src/lib.typ` | ATS-friendly CV template |

Usage in `.typ` file:

```typst
#import "@atalariq/<package>:<version>": *
```

## Hermes Skills

| Skill | Description |
|-------|-------------|
| `typst-lab-report` | 3-mode lab report generator (SCAFFOLD / PUZZLE / DRAFT) |

Skills live under `skills/` and are symlinked into `~/.hermes/skills/` for discovery.

## Verification

```bash
typst compile packages/lab-report/3.0.0/examples/full.typ
typst compile packages/lab-report/3.0.0/examples/minimal.typ
typst compile packages/code/1.0.0/example/main.typ
typst compile packages/cv/1.0.0/example/cv.typ
```

`setup.sh` picks the package directory per platform: `~/Library/Application Support/typst/packages`
on macOS, `$XDG_DATA_HOME/typst/packages` elsewhere. Earlier versions of the script always used
the XDG path, so `@atalariq/*` never resolved on macOS.

## Structure

```
.
├── packages/                # @atalariq/* Typst packages
│   ├── lab-report/
│   ├── code/
│   └── cv/
├── skills/                  # Hermes agent skills
│   └── typst-lab-report/
├── setup.sh                 # One-shot symlink setup
├── README.md
└── AGENTS.md                # Agent context for Hermes
```
