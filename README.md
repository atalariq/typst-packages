# Atalariq's Typst Packages

Local Typst package registry + Hermes agent skills.

## Installation

```bash
chmod +x setup.sh && ./setup.sh
```

This will:
- Symlink `packages/` → `~/.local/share/typst/packages/atalariq`
- Symlink `skills/typst-lab-report` → `~/.hermes/skills/productivity/typst-lab-report`

## Typst Packages

| Package | Version | Entrypoint | Description |
|---------|---------|------------|-------------|
| `lab-report` | 1.0.0 | `src/lib.typ` | Indonesian lab report template for UGM |
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
typst compile packages/lab-report/1.0.0/examples/main.typ
typst compile packages/code/1.0.0/example/main.typ
typst compile packages/cv/1.0.0/example/cv.typ
```

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
