# Failure Modes to Avoid

| Failure                          | Consequence             | Prevention                                           |
| -------------------------------- | ----------------------- | ---------------------------------------------------- |
| Hallucinate Typst function       | Compile fail            | Only use verified functions from typst-reference.md. |
| Describe code without "why"      | Low grade (–60%)        | Apply "why / invariant / what-if" framework.         |
| Missing citation                 | Grading deduction       | Pair factual claims with `@citekey`.                 |
| `saya`/`kita` in prose           | Register violation      | Run pronoun checklist before output.                 |
| Rewrite Dasar Teori in D3B       | Breaks approved content | Only patch `#rect[TODO]` blocks.                     |
| Non-descriptive caption          | Visual grade lost       | Describe content AND significance.                   |
| Missing `url` in Hayagriva entry | Unverifiable ref        | Required field.                                      |
| Compile loop >3 iterations       | Wasted cycles           | Stop at 3, report stderr.                            |
| Wrong `line-range`               | Wrong code shown        | Read file first. Verify complete logical unit.       |
| Missing `#pagebreak()`           | Cramped report          | Before Hasil, between Tugas, before Kesimpulan.      |
| `#col()` for >15 lines           | Illegible               | Full-width `#include-code()` instead.                |
| Lampiran `outlined: false`       | Missing from TOC        | Don't use `outlined: false`.                         |
| Definition list syntax           | Compile fail            | `/ term: description` — colon on same line.          |
| Hex `#` in prose                 | Compile fail            | Strip `#`: `C9963B` not `#C9963B`.                   |
| `#include-code()` in `#rect[]`   | Compile fail            | Escape: `\#include-code()`.                          |
| `<` in prose                     | "unclosed label"        | Use `(di bawah 768 px)` or `\<`.                     |
| Path outside project root        | Access denied           | Symlink: `ln -sf ../src src`.                        |
