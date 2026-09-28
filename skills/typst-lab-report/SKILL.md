---
name: typst-lab-report
version: 3.1.1
description: >
  Three-mode lab report workflow for Indonesian academic reports in Typst.
  Mode SCAFFOLD: template only. Mode PUZZLE: guiding questions. Mode DRAFT: full report.
  Course-specific rules in references/course-specific/<matkul>.md.
---

# Typst Lab Report

## Modes

| Mode         | Triggers                                         | What happens                                                    | User role         |
| ------------ | ------------------------------------------------ | --------------------------------------------------------------- | ----------------- |
| **SCAFFOLD** | "scaffold", "bikin folder", "template aja"       | Folder + `report.typ` with TODOs + `references.yaml`. No prose. | Fill in manually. |
| **PUZZLE**   | "puzzle", "guide me", "pertanyaan" + source code | Guiding questions per section + references.                     | Write own report. |
| **DRAFT**    | "full report", "tulisin semua", "gue mepet"      | Full AI-generated report (3-phase). Last resort.                | Review content.   |

Pick exactly one. If ambiguous, ask once. Never combine.

## Mode Selection

1. Trigger phrase in message → use that mode.
2. Source code + "help writing" → ask: PUZZLE or DRAFT?
3. No code, just "start" → SCAFFOLD.
4. Explicit mode name → use it.

## Prime Directives

1. All prose: formal Indonesian (EYD V, KBBI). No first/second person.
2. Never hallucinate Typst functions. Only use verified ones (see `references/typst-reference.md`).
3. Never rewrite approved content.
4. Course-specific config mandatory. Check `references/course-specific/<course-code>.md` first.
5. Announce mode + phase at start of each response.

## SCAFFOLD

**Phase S0 — Auto-detect metadata** from folder name (`Pertemuan 8`, `P8-`, `PPW1`, `PBD`, etc.), `TASK.md`/`README.md`, parent dirs. Present only unknowns.

**Phase S1 — Collect** remaining metadata (one numbered list). Skip if all detected.

**Phase S2 — Generate** via `new-laporan.sh <folder>` or write manually: `report.typ`, `references.yaml`, `assets/logo.png`. Announce **[SCAFFOLD DONE]**.

**Phase S3 — Compile check** (optional): `cd <folder> && typst compile report.typ`. Don't fix TODOs.

## PUZZLE

**P1 — Analyze** source files. Identify components, patterns, design decisions.

**P2 — Generate questions** per task:

- Core questions (wajib): "Bagaimana cara kerja X?", "Mengapa pendekatan Y?"
- Exploration (pengayaan): accessibility, trade-offs, alternatives
- References: 2-3 sources, Hayagriva format
- Screenshot prompts: what to capture

**P3 — Present** as markdown grouped by task. End with checklist.

**P4 — Post-answer review**: review language, generate Typst version, add to template.

## DRAFT

**D1 — Plan**: read source + course config, auto-detect metadata, ask 2-3 clarifying Qs, output outline.

**D2 — References**: 1-2 sources per Dasar Teori concept, Hayagriva format. User approves before D3.

**D3A — Pre-code draft**: `report.typ` with Tujuan + Dasar Teori written, Hasil/Kesimpulan as `#rect[TODO]`. Compile gate.

**D3B — Post-code draft**: fill Hasil dan Pembahasan + Kesimpulan. Patch TODOs. Compile gate. Don't touch Tujuan/Dasar Teori.

## Compile Gate (DRAFT only)

1. Bib checker: extract `@citekeys` from `references.yaml` vs `report.typ`, warn on mismatches.
2. Path validator: check all `#include-code()` and `#img()` paths exist.
3. Structure checker: verify `Hasil dan Pembahasan` heading + at least one figure.
4. `typst compile report.typ`. Max 3 error-fix iterations, then stop and report stderr.

Full commands: `references/compile-gate.md`

## Quality Checklist

- [ ] Mode announced.
- [ ] Course config checked.
- [ ] No first/second person pronouns.
- [ ] English terms italicised on first use per section.
- [ ] Every `@citekey` has matching Hayagriva entry with `url`.
- [ ] No invented Typst functions.
- [ ] `#pagebreak()` before `= Hasil dan Pembahasan`, between `== Tugas`, before `= Kesimpulan`.
- [ ] `#include-code()` line-range verified (complete logical unit, not cut mid-expression).
- [ ] `#col()` only for short snippets (<15 lines/side).

## Course Configs

Check `references/course-specific/<code>.md` before generating. Available:

- `ppw1.md` — PPW1 (Pemrograman Web 1)
- `ppbo.md` — PPBO (Pemrograman Berorientasi Objek)
- `pbd.md` — PBD (Basis Data) — Oracle XE 21c, SQL heavy
- `psd.md` — PSD (Struktur Data) — Python, OOP, complexity analysis

## References

- `references/typst-reference.md` — Typst functions, metadata, helpers
- `references/language-rules.md` — Formal Indonesian writing rules, citations, terminology
- `references/compile-gate.md` — Pre-compile checks and compile commands
- `references/mode-pivots.md` — Switching modes mid-session
- `references/failure-modes.md` — Common failures and prevention
- `references/screenshot-splitting.md` — Crop full-page screenshots per section
- `references/course-specific/` — Per-matkul overrides
