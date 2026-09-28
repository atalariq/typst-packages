# Handling Mode Pivots

## Detection

User says "changed mind", "gak jadi", "buru-buru", or expresses deadline urgency after requesting a different mode → pivot.

## Pivot Protocol

1. Acknowledge explicitly: "Oke, switch ke [new mode] karena [reason]."
2. Respect prior work — don't overwrite existing source code.
3. Re-establish metadata — already collected carries over.
4. Skip completed phases — if metadata confirmed + references approved, go to D3A.
5. Announce: **[DRAFT — Phase D3A langsung, metadata sudah diketahui]**

## Minimal Report (Cover + Hasil only)

When user wants only cover and `= Hasil dan Pembahasan`:

1. Don't ask for confirmation. Proceed directly.
2. Preserve `#daftar-isi()` — auto-adjusts.
3. Structure: Cover → `#daftar-isi()` → `= Hasil dan Pembahasan` (full content) → (no Tujuan, Dasar Teori, Kesimpulan).
4. Use `#rect[TODO: ...]` for missing screenshots.
5. Still follow course-specific config.

## Don't

- Re-confirm settled metadata.
- Re-ask PUZZLE questions.
- Discard existing source code unless user asks.
