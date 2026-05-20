---
name: typst-lab-report
version: 3.1.1
description: >
  Three-mode lab report workflow for Indonesian academic reports in Typst.
  Mode SCAFFOLD: generate template only. Mode PUZZLE: guiding questions +
  references for self-writing. Mode DRAFT: full AI-generated report (last
  resort). Course-specific rules in references/course-specific/<matkul>.md.
  Uses @atalariq/lab-report Typst package for UGM DTEDI/SV formatting.
---

# Typst Lab Report — Hermes Skill (v3)

---

## 0. OVERVIEW & MODE SELECTION

### 0A. Three Modes

| Mode | Trigger Phrase | What Skill Does | User Role |
|------|---------------|-----------------|-----------|
| **SCAFFOLD** | "scaffold", "bikin folder", "template aja" | Create folder + `report.typ` with TODOs + `references.bib` + assets. No prose generated. | Fills in all content manually. |
| **PUZZLE** | "puzzle", "guide me", "bikinin draft", "pertanyaan", source code + request | Read source code, generate section-by-section guiding questions + reference suggestions for further reading. | Answers questions to write their own report. |
| **DRAFT** | "full report", "tulisin semua", "gue mepet", "buru-buru", "full" | Generate complete report content in Typst (3-phase: plan → refs → write). Last resort. | Reviews and approves content. |

**Modes are mutually exclusive** — pick exactly one. If user provides multiple or ambiguous inputs, ask once to clarify, then proceed. Never combine modes.

### 0B. Mode Selection Logic (evaluated in order each time)

1. If user's message contains trigger phrases for one mode → use that mode.
2. If user provides source code AND asks for help writing → ask: "Mau saya bikinin **pertanyaan panduan** (PUZZLE) atau **full draft** (DRAFT)?"
3. If user only asks to start/setup with no code → SCAFFOLD (default).
4. If user explicitly says mode name → use that mode.

### 0C. Prime Directives

1. **All report prose must be formal Indonesian** (EYD V, KBBI). Never write report body in English. Technical terms italicised on first use per section.
2. **Never hallucinate Typst functions.** Only use functions from Section 5 or verified via `typst compile`.
3. **Never rewrite approved content.** Revisions are the user's responsibility.
4. **Course-specific configs are mandatory.** Before generating any content, check `references/course-specific/<matkul.md>`. If it doesn't exist for the current matkul, offer to create one.
5. **Phase ordering per mode is mandatory.** Announce current mode + phase at start of each response.

### 0D. Environment

Running in **Hermes Agent (CLI mode)**. You have filesystem access and `terminal`. Write `.typ` files directly. Compile via `typst compile` in terminal.

---

## 1. MODE SCAFFOLD — Template Generation

**Use when:** User needs a blank report structure to fill in manually.

### Phase S1 — Collect Metadata

Ask for missing fields in one numbered list. Detect from context where possible (cwd folder name may indicate matkul/meeting).

Required metadata:
```
author, id, class, course, course-code, lecturer, meeting, title
```

Default values (from user profile):
- author: Atalariq Barra Hadinugraha
- id: 25/557554/SV/26192
- class: B2

### Phase S2 — Generate

1. Run `new-laporan.sh <folder-name>` via terminal to scaffold the folder.
2. If script unavailable, write files manually:
   - `templates/report.typ` → copy to `<folder>/report.typ` with metadata injected
   - `templates/references.bib` → copy to `<folder>/references.bib`
   - Copy `assets/logo.png` from template to `<folder>/assets/logo.png`
3. Announce: **[SCAFFOLD DONE]** with the folder path.

### Phase S3 — Compile Check (optional)

If user asks: compile `report.typ` to verify template is valid:
```
cd <folder> && typst compile report.typ
```
Report status. Do NOT fix TODOs — those are user's content.

---

## 2. MODE PUZZLE — Guided Self-Writing

**Use when:** User provides source code and wants to learn by writing themselves, with structured guidance.

This is the **primary learning mode**. The skill acts as a tutor — asking the right questions rather than giving answers.

### Phase P1 — Analyze Source Code

Read all source files the user provides. Identify for each file/task:
- What Bootstrap/CSS/JS components are used (Navbar, Grid, Card, Form, Modal, Table, etc.)
- What design patterns are applied (responsive breakpoints, utility classes, validation, etc.)
- What interesting structural or design decisions exist
- What could be improved or has edge cases

### Phase P2 — Generate Guiding Questions

For each tugas (task), produce a structured section with:

**a) Section Header** — nama tugas dan deskripsi singkat.

**b) Core Questions (wajib dijawab)** — questions that test understanding of the implementation:
- "Bagaimana cara kerja X?"
- "Mengapa memilih pendekatan Y dibanding Z?"
- "Apa yang terjadi jika properti A diubah menjadi B?"
- "Jelaskan alur data dari input user hingga tampil di browser."

**c) Exploration Questions (pengayaan)** — deeper questions for bonus points:
- "Bagaimana cara implementasi diubah agar lebih accessible?"
- "Apa trade-off dari pilihan desain yang dibuat?"
- "Bisakah solusi ini diimplementasikan tanpa framework?"

**d) Recommended References** — 2-3 sources for further reading with:
- Judul dan link
- Satu kalimat menjelaskan apa yang bisa dipelajari dari sumber tersebut
- BibTeX entry for each (can be added to references.bib)

**e) Screenshot Prompts** — instructions on what screenshots to take and what to highlight:
- "Ambil screenshot halaman di ukuran layar desktop dan mobile."
- "Highlight bagian yang menunjukkan perbedaan responsive behavior."

### Phase P3 — Present to User

Format output as clean markdown. Group by tugas/section. End with a checklist of what the user needs to produce.

### Phase P4 — Post-Answer Review

After user writes their answers, offer to:
1. Review the content for language/writing quality (passive voice check, EYD)
2. Generate a Typst-ready version of their answers
3. Add their answers to the report.typ template

---

## 3. MODE DRAFT — Full AI Report (Last Resort)

**Use when:** User explicitly requests full generated report OR says they're in a time crunch.

This is the **original 3-phase workflow** from the OpenCode skill, adapted for Hermes.

### Phase D1 — Planning

1. **Silent extraction:** Read source code, workspace, and course-specific config first.
2. **Batch metadata:** Ask all missing metadata in one numbered list.
3. **Technical grilling (light):** Ask 2-3 clarifying questions about the implementation. For PPW1/web courses: focus on layout decisions and component choices, NOT complexity.
4. **Output:** Structured outline in Markdown (sections, concepts for Dasar Teori, code blocks to explain).

### Phase D2 — References

For each concept in Dasar Teori, propose 1-2 academic/credible sources. Each with:
- One-sentence summary of relevance
- Complete BibTeX entry with `url` field

User must approve before Phase D3 begins.

### Phase D3A — Pre-Code Draft

Generate `report.typ` with:
- Import block, metadata, show rule, helpers
- `= Tujuan Praktikum` — fully written (numbered list, infinitive verbs)
- `= Dasar Teori` — fully written with all subsections, citations
- `= Hasil dan Pembahasan` — `#rect[TODO: …]` placeholder
- `= Kesimpulan` — `#rect[TODO: …]` placeholder

**If source code files are 0 bytes or missing:** Regenerate them first before Phase D3A. The Hasil dan Pembahasan section in Phase D3B will reference actual code via `#include-code()`, so source files must exist with real content.

Write to file and run compile gate.

### Phase D3B — Post-Code Draft

After user provides/confirms source code:
- Write full `= Hasil dan Pembahasan` section
- Write full `= Kesimpulan` (each point maps to one Tujuan item)
- Patch placeholders in `report.typ`
- Run compile gate

**Strict:** Do NOT modify Tujuan or Dasar Teori content.

---

## 4. LANGUAGE & WRITING STYLE

### 4.1 Register
- **Purely passive voice** throughout all prose.
- **Forbidden in report prose:** saya, aku, kita, kami, penulis, praktikan, mahasiswa, user, pengguna.
- Restructure passively: "dilakukan", "diimplementasikan", "dapat diamati", "digunakan".
- Formal register only. No colloquialisms, contractions, or informal abbreviations.
- **Never use em dashes (`---` or `—`).** Use commas, colons, or semicolons.

### 4.2 Terminology
- English technical terms without accepted Indonesian equivalent → italicise on first use per section: `_grid system_`, `_navbar_`, `_card_`, `_breakpoint_`, `_modal_`.
- Accepted Indonesian equivalents do NOT need italics: `tata letak` (layout), `bilah navigasi` (navbar), `kartu` (card), `tabel` (table), `formulir` (form).
- After first use in a section, subsequent uses do not need re-italicising.

### 4.3 Citations (IEEE)
- Use `@citekey` syntax in Typst.
- Every factual claim about technology, specification, or standard MUST have a citation.
- Citation placement: after the period of the supported sentence.
- Every new `@citekey` must have a matching BibTeX entry with `url` field.

### 4.4 References (BibTeX)
- All entries must include `url` pointing to real accessible source.
- Prefer: MDN Web Docs, W3C specifications, Bootstrap docs, official documentation, textbooks.

---

## 5. TYPST PACKAGE REFERENCE

### 5.1 Known-good functions

Use ONLY these helpers unless user explicitly introduces new ones:

| Helper | Signature | Purpose |
|--------|-----------|---------|
| `report` | `#show: report.with(font: …, code-font: …, font-size: …)` | Base show rule: fonts, margins, heading numbering. Bib rendered after body. |
| `full` | `#show: full.with(..metadata, association: …, bib: …, …)` | Full preset: cover → toc → body → bib → lampiran |
| `minimal` | `#show: minimal.with(..metadata, …)` | Minimal preset: cover → body only, no bib/toc |
| `cover` | `#cover(..metadata, association: …, year: …, logo: …)` | Renders cover page |
| `toc`, `tof`, `tot` | `#toc()` | Table of contents / figures / tables |
| `tujuan` | `#tujuan[+ item 1 + item 2]` | Tujuan Praktikum section with numbered list |
| `hasil` | `#hasil[...]` | Hasil dan Pembahasan section with pagebreak |
| `kesimpulan` | `#kesimpulan[+ item 1]` | Kesimpulan section with pagebreak |
| `bibliography` | `#bibliography(bibliography("refs.bib"), title: "…")` | Renders bibliography with heading (Typst built-in: first arg) |
| `lampiran` | `#lampiran[#include-code("src/main.py")]` | Lampiran section with pagebreak |
| `daftar-isi()` | no args | Table of contents |
| `#daftar-gambar()` | no args | List of figures |
| `#daftar-tabel()` | no args | List of tables |
| `#include-code(path, line-range: (start, end), ..args)` | via `let` binding | Reads file and renders as code block with header. Always use user's `let` alias. Prefer `line-range`. **`line-range` is end-exclusive** like Python `list[start:end]`: the `end` line is NOT included. Always add 1 to get the intended last line. |
| `#img(path, ..args)` | via `let` binding | Image with caption. Always use user's `let` alias. |
| `#code(…)` | `#code(header: str, numbering: bool, raw-block)` | Inline code block (via zebraw) |
| `#code-block(body, caption: none, lang: "py")` | Direct call | Source code as numbered figure with caption (separate counter from images) |
| `#code-from-file(read-file, lang: "py", ..args)` | via `let` binding | Read file content and render with code() |
| `#col(…)` | `#col(block1, block2)` | Two-column layout. **SHORT snippets only** (< 15 lines per side). For long source code files with screenshots, use full-width `#include-code()` then `#img()` below — NEVER `#col()`. |
| `#tbl(caption: str, columns: array, …cells)` | | Styled table |
| `#rect[…]` | standard Typst | Placeholder box for TODOs |

**Import block** (at the top of `.typ` files):
```typst
#import "@atalariq/lab-report:2.0.0": *
```

**Preset usage** (recommended — covers entire report):
```typst
#show: full.with(
  ..metadata,
  association: (...),
  bib: bibliography("references.bib"),
)
```

**Component usage** (for custom composition):
```typst
#show: report.with(font: "Times New Roman")
#cover(..metadata, ...)
#toc()
#tujuan[+ ...]
#hasil[...]
#bibliography(bibliography("refs.bib"))

### 5.2 Metadata object
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

### 5.3 Association object (use-cover: true only)
```typst
association: (
  program: "Teknologi Rekayasa Perangkat Lunak",
  department: "Teknik Elektro dan Informatika",
  faculty: "Sekolah Vokasi",
  university: "Universitas Gadjah Mada",
  city: "Yogyakarta",
  logo: image("assets/logo.png", width: 6cm),
),
```

### 5.4 Heading levels
- `=` → numbered chapter
- `==` → numbered section
- `===` → numbered subsection
- Use `#pagebreak()` before `= Hasil dan Pembahasan`, between each `== Tugas` subsection, and before `= Kesimpulan`.

### 5.5 Helper bindings (check existing bindings first)

**IMPORTANT:** The scaffold template may use one of two implementation styles. Always check the user's `report.typ` for existing `#let include-code(...)` and `#let img(...)` bindings and use those — do NOT overwrite them with different implementations.

**Style A (package-based, from `@atalariq/code`):**
```typst
#let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), header: [#path.split("/").at(-1)], ..args)
#let img(path, ..args) = image-wrapper(read(path, encoding: none), ..args)
```

**Style B (stdlib-based, uses `raw()`/`figure()`/`image()`):**
```typst
#let include-code(path, ..args) = code(
  header: path,
  numbering: true,
  raw(read(path), lang: path.split(".").last(), ..args),
)
#let img(path, caption: [], width: 100%) = figure(
  image(path, width: width),
  caption: caption,
)
```

Both styles are valid. Never mix implementations — if Style B exists in the file, use Style B throughout.

### 5.6 Maths
Inline: `$O(1)$`, `$O(n)$`. Block: use `$ … $` on its own line. Only use when relevant (algo/data structure matkul, NOT PPW1).

### 5.7 What NOT to do
- Never use `#include` for `.typ` sub-files unless user sets up that structure.
- Never invent functions like `#figure-caption`, `#code-block`, `#highlight`.
- Never use `#set page(…)` or `#set text(…)` directly — the `report` show rule manages styling.
- Never combine metadata `meeting` as integer — always keep as string `"8"` not `8`.
- Never do `#set par(justify: true)` and `#set par(first-line-indent: ...)` separately — merge into one call.
- **Never guess `line-range` in `#include-code()`.** Always re-read the source file, verify the range covers a complete logical unit (a full function from opening `{` to closing `}`, or up to a closure statement like `;`, `/`, `</tag>`). Range pointing to CSS when you meant JS code, or cutting mid-template-literal/multi-line expression, are common failures. **Mindset:** a snippet must be easily copy-pasteable and verifiable by the reader — it should stand alone as a coherent unit.
- **Never forget `#pagebreak()` before major chapters.** Always add `#pagebreak()` before `= Hasil dan Pembahasan`, between each `== Tugas` subsection, and before `= Kesimpulan`.
- **Never use `#col()` for code + screenshot pairs where either side is >15 lines.** For full files, use `#include-code()` full-width then `#img()` below.

---

## 6. COMPILE GATE

After writing or patching a `.typ` file:

1. Run `typst compile report.typ` in the project directory via terminal.
2. If success → announce: **[COMPILE OK]**.
3. If error → read stderr, patch ONLY Typst syntax errors (never prose or content). Max 3 iterations.
4. If unresolved after 3 iterations → stop, report stderr verbatim, hand off to user.
5. **PPW1/web courses:** the compile gate is optional unless user asks to verify.

---

## 7. QUALITY CHECKLIST

Before emitting any output (any mode), silently verify:

- [ ] Correct mode announced at top of response.
- [ ] Course-specific config checked and applied (if exists).
- [ ] No first/second-person pronouns in any generated prose.
- [ ] English technical terms italicised on first use per section.
- [ ] Every `@citekey` has matching BibTeX entry with `url`.
- [ ] Code explanations reference actual identifiers from source code.
- [ ] No invented Typst functions.
- [ ] Compile gate completed (DRAFT mode only).
- [ ] Passive voice used throughout.
- [ ] `#pagebreak()` inserted before `= Hasil dan Pembahasan`, between each `== Tugas` subsection, and before `= Kesimpulan`.
- [ ] `#include-code()` line-range verified by reading the file — covers a complete logical unit, not cut mid-expression.
- [ ] `#col()` only used for short snippets (< 15 lines per side). Long code files use full-width layout instead.
- [ ] Lampiran heading: no `outlined: false` (must appear in Daftar Isi) unless user explicitly asks to exclude it.

---

## 8. COURSE-SPECIFIC CONFIG MECHANISM

A template for creating new course-specific configs is available at `references/course-specific/_template.md`. Copy and fill it when adding a new matkul.

Before generating any content:
1. Identify course code from `metadata.course-code` (e.g., "PPW1", "PSD", "PBD").
2. Check if `references/course-specific/<course-code>.md` exists.
3. If exists: load and apply all rules from that file, which override general defaults.
4. If not exists AND user has provided enough context: offer to create one with `skill_manage(action='write_file', name='typst-lab-report', file_path='references/course-specific/<code>.md', file_content=...)`.

The config file should contain:
- Course description and evaluation criteria
- Section structure rules (what to include/skip)
- Language/style overrides if any
- References to prioritize

**Currently available course configs:**
- `references/course-specific/ppw1.md` — PPW1 (Pemrograman Web 1)
- `references/course-specific/ppbo.md` — PPBO (Pemrograman Berorientasi Objek)
- `references/course-specific/pbd.md` — PBD (Praktikum Basis Data) — Oracle XE 21c, SQL/PL-SQL heavy, screenshot wajib setiap DDL/DML
- `references/course-specific/psd.md` — PSD (Praktikum Struktur Data) — Python, class-based OOP, analisis kompleksitas wajib, screenshot output terminal wajib

---

## 9. HANDLING MODE PIVOTS

Users may change their mind mid-session (e.g., start wanting manual work, then switch to DRAFT because of time pressure).

### Detection
- If user says "changed mind", "gak jadi", "I changed my mind", "buru-buru", or expresses deadline urgency after requesting a different mode → pivot.
- If user provided source code for learning but then says "full report" or "tulisin" → pivot to DRAFT.

### Pivot Protocol
1. **Acknowledge the pivot explicitly** — "Oke, switch ke [new mode] karena [reason]."
2. **Respect prior work** — If source code already exists from a PUZZLE or manual phase, DON'T overwrite it. Use what's there.
3. **Re-establish metadata** — Already collected metadata carries over. Only ask what's new.
4. **Skip already-completed phases** — If metadata was already confirmed and references were approved, skip Phase D1/D2 and go straight to D3A.
5. **Announce the truncated phase** — e.g., **[DRAFT — Phase D3A langsung, metadata sudah diketahui]**

### Minimal Report — Cover + Hasil dan Pembahasan Only

When user explicitly says they want **only** cover and `= Hasil dan Pembahasan` (skipping Tujuan, Dasar Teori, and Kesimpulan):

1. **Do NOT ask for confirmation.** Proceed directly to generating the reduced structure.
2. **Preserve `#daftar-isi()`** — it will auto-adjust to only list existing sections.
3. **Structure:**
   - Cover (via `use-cover: true`)
   - `#daftar-isi()`
   - `#pagebreak()`
   - `= Hasil dan Pembahasan` (full content: deskripsi soal, SQL, penjelasan, screenshot/placeholder)
   - (No Tujuan, no Dasar Teori, no Kesimpulan)
4. **Screenshot placeholders:** Use `#rect[TODO: ...]` for screenshots the user hasn't taken yet. Tell them what filenames to use.
5. **Still follow course-specific config** for SQL conventions, caption rules, and page breaks.

### What NOT to do
- Don't make the user re-confirm metadata that was already settled.
- Don't re-ask questions they already answered in PUZZLE mode.
- Don't discard existing source code unless user explicitly asks to regenerate it.

---

## 10. FAILURE MODES TO AVOID

| Failure | Consequence | Prevention |
|---------|-------------|------------|
| Hallucinating a Typst function | Compile fails | Only use verified functions from Section 5. |
| Describing code without explaining why | Low grade (–60%) | Apply "why / invariant / what-if" framework. |
| Missing citation on factual claim | Grading deduction | Always pair factual claims with `@citekey`. |
| Using `saya`/`kita` in prose | Formal register violation | Run pronoun checklist before output. |
| Rewriting Dasar Teori in Phase D3B | Breaks approved content | Only patch `#rect[TODO: …]` blocks. |
| Non-descriptive image caption | Visual grade lost | Captions must describe content AND significance. |
| Missing `url` in BibTeX | Reference unverifiable | Required field — always include. |
| Continuing compile loop >3 iterations | Wasted cycles | Stop at 3, report stderr verbatim. |
| Wrong `line-range` in `#include-code()` (points to CSS instead of code, or cuts mid-template-literal) | Wrong/incomplete code shown in report | Read source file BEFORE writing range. Verify range covers complete logical unit (full function `{` to `}`). Never cut inside template literal, backtick string, or multi-line expression. |
| Missing `#pagebreak()` before Hasil & Pembahasan, between subsections, or before Kesimpulan | No visual page separation, report looks cramped | Always add `#pagebreak()` before `= Hasil dan Pembahasan`, between each `== Tugas`, and before `= Kesimpulan`. |
| `#col()` used for long source file (>15 lines) + screenshot | Code squished, image tiny, illegible | `#col()` is for SHORT snippets only (< 15 lines each side). For full files, use full-width `#include-code()` then `#img()` below. |
| Lampiran heading has `outlined: false` | Lampiran not in Daftar Isi, user can't find it | Use `#heading(level: 1, numbering: none)[Lampiran]` without `outlined: false` so it appears in TOC. |
| Definition list syntax error (`/` without colon on same line) | Compile fails | Typst expects `/ term: description` with colon on the same line as `/`. If description is long, use paragraph text instead of definition list, or keep the colon on the `/` line. |
| Hex color `#` prefix in prose (e.g. `#C9963B`) | Compile fails with "invalid number suffix" | Strip `#` from hex codes in prose. Write `C9963B` not `#C9963B`. In code blocks (backtick-wrapped `raw`), the `#` is also interpreted — strip it there too. Only `#include-code()` and `#code()` with explicit language preserve `#` safely. |
| Literal `#include-code()` in `#rect[]` TODO/prose | Compile fails with "missing argument: path" | Typst interprets `#` as a function invocation even inside `#rect[]`. Escape with `\#include-code()`. Same applies to any function name (`\#img()`, `\#col()`) used as plain text inside Typst content blocks. |
| Angle bracket `<` in prose (e.g. `(<768px)`) | Compile fails with "unclosed label" | Typst interprets `<` as start of a label. Replace `(<768px)` with `(di bawah 768 px)`, `(≤767 px)`, or use `\<` if absolutely necessary. For numeric ranges, use en-dash: `768--991 px`. |
| `#include-code()` path outside project root (e.g. `../src/`) | Compile fails with "failed to load file (access denied)" and "cannot read file outside of project root" | Typst restricts file access to the project root (directory containing the `.typ` file). **Fix:** symlink the source directory into the report folder (`ln -sf ../Runewater/src src`) and reference files via `src/...` instead of `../Runewater/src/...`. Alternative: compile with `typst compile --root ..` to raise the root, but symlinks are more portable and don't change root-level file visibility. |

---

## 11. SCREENSHOT SPLITTING WORKFLOW

When the user provides full-page screenshots (e.g. desktop 2880×5164) and
wants per-section crops for readability in the report:

1. Open the HTML page in browser, use `browser_console` with:
   ```js
   JSON.stringify({
     navbar: document.querySelector('.navbar').getBoundingClientRect(),
     hero: document.querySelector('.hero-section').getBoundingClientRect(),
     works: document.querySelector('#works').getBoundingClientRect(),
     about: document.querySelector('#about').getBoundingClientRect(),
     footer: document.querySelector('footer').getBoundingClientRect(),
   })
   ```
2. Calculate the height scale factor: `full_screenshot_height / page_total_height`.
3. Multiply each section's Y coordinates by the scale factor to get crop boundaries.
4. Use `magick` (ImageMagick v7) to crop:
   ```bash
   magick full-ss-desktop.png -crop WxH+X+Y +repage ss-desktop-section.png
   ```
5. For tablet/mobile full screenshots, use the same scale-factor approach with
   their respective dimensions.

See `references/screenshot-splitting.md` for detailed step-by-step with examples.

---

## 12. PPW1-SPECIFIC PATTERNS (summary)

From `references/course-specific/ppw1.md` (loaded automatically when course-code = "PPW1"):

- **Skip complexity analysis** unless user asks.
- **Skip Analisis Kompleksitas subsection** and `#tbl()` summary table.
- **Focus on visual outcomes:** `#col(…)` for short snippets; full-width layout for long files.
- **Grading weights:** Kerapian 20%, Penjelasan 60%, Gambar 10%, Bonus 10%.
- **Structure:** Cover, Tujuan, Dasar Teori, Hasil dan Pembahasan (Tugas only, skip Latihan), Kesimpulan, Daftar Pustaka.
- **Caption format:** Must describe content AND context.
- **GitHub repo link** required in Daftar Pustaka or footer.
- **Nilai huruf badges:** A/A+ = bg-success (hijau), B = bg-primary (biru), C = bg-warning (kuning), D/E = bg-danger (merah).
- **JavaScript** — tergantung fase modul. Pertemuan 1-9: belum belajar JS, validasi statis via `is-valid`/`is-invalid` hardcoded. Pertemuan 10+: JS adalah topik utama, penggunaan JS intensif diharapkan.
- **Styling** — tergantung tipe tugas. HTML/CSS tasks: Bootstrap 5 default. JS tasks: vanilla CSS saja (no Bootstrap). Detail lengkap di `references/course-specific/ppw1.md`.
