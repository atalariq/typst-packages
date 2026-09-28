# Compile Gate (DRAFT mode only)

## Pre-Compile Checks

### 1. Bib checker

Reference format is Hayagriva (`references.yaml`); a reopened pre-2026-09-29
folder may still have the legacy `references.bib` — handle both. These use
`grep -E`/`sed -E` (portable), not `grep -P` (macOS's stock `grep` is BSD
and has no `-P` — a PCRE pattern here just errors "invalid option").

```bash
if [ -f references.yaml ]; then
  grep -E '^[A-Za-z0-9_-]+:' references.yaml | sed -E 's/:.*//' | sort > /tmp/bib-keys.txt
elif [ -f references.bib ]; then
  grep -E '^\s*@[A-Za-z]+\{' references.bib | sed -E 's/^\s*@[A-Za-z]+\{([^,]+),.*/\1/' | sort > /tmp/bib-keys.txt
fi
grep -oE '@[A-Za-z0-9_-]+' report.typ | sed 's/^@//' | grep -v '^preview$' | sort -u > /tmp/used-keys.txt
comm -23 /tmp/bib-keys.txt /tmp/used-keys.txt  # unused bib entries
comm -13 /tmp/bib-keys.txt /tmp/used-keys.txt  # missing bib entries
```

If missing entries found → warn user, offer to add.

### 2. Path validator

```bash
sed -nE 's/.*#include-code\("([^"]+)".*/\1/p' report.typ | while IFS= read -r f; do
  [ -f "$f" ] || echo "MISSING: $f"
done
sed -nE 's/.*#img\("([^"]+)".*/\1/p' report.typ | while IFS= read -r f; do
  [ -f "$f" ] || echo "MISSING: $f"
done
```

If missing → offer to create file or fix path. For paths outside project root: `ln -sf <real-path> src/<name>`.

### 3. Structure checker

```bash
typst query report.typ '<heading level=1>' --one 2>/dev/null | grep -c '"level": 1' || true
typst query report.typ '<figure>' --one 2>/dev/null | grep -cE '"kind": "(image|table|code)"' || true
```

Verify: `Hasil dan Pembahasan` heading exists, at least one figure.

## Compile

After pre-checks pass:

1. `typst compile report.typ`
2. Success → **[COMPILE OK]**
3. Error → read stderr, fix Typst syntax only (never prose). Max 3 iterations.
4. Unresolved after 3 → stop, report stderr verbatim.
5. PPW1/web: compile gate optional unless user asks.
