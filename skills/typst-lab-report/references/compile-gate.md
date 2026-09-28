# Compile Gate (DRAFT mode only)

## Pre-Compile Checks

### 1. Bib checker

```bash
grep -oP '^\s*@\w+\{\K[^,]+' references.bib | sort > /tmp/bib-keys.txt
grep -oP '(?<!@preview)@[\w-]+' report.typ | sort -u > /tmp/used-keys.txt
comm -23 /tmp/bib-keys.txt /tmp/used-keys.txt  # unused bib entries
comm -13 /tmp/bib-keys.txt /tmp/used-keys.txt  # missing bib entries
```

If missing entries found → warn user, offer to add.

### 2. Path validator

```bash
grep -oP '#include-code\("\K[^"]+' report.typ | while IFS= read -r f; do
  [ -f "$f" ] || echo "MISSING: $f"
done
grep -oP '#img\("\K[^"]+' report.typ | while IFS= read -r f; do
  [ -f "$f" ] || echo "MISSING: $f"
done
```

If missing → offer to create file or fix path. For paths outside project root: `ln -sf <real-path> src/<name>`.

### 3. Structure checker

```bash
typst query report.typ '<heading level=1>' --one 2>/dev/null | grep -c '"level": 1' || true
typst query report.typ '<figure>' --one 2>/dev/null | grep -cP '"kind": "(image|table|code)"' || true
```

Verify: `Hasil dan Pembahasan` heading exists, at least one figure.

## Compile

After pre-checks pass:
1. `typst compile report.typ`
2. Success → **[COMPILE OK]**
3. Error → read stderr, fix Typst syntax only (never prose). Max 3 iterations.
4. Unresolved after 3 → stop, report stderr verbatim.
5. PPW1/web: compile gate optional unless user asks.
