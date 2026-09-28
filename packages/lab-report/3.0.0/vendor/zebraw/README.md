# Vendored: zebraw 0.6.3

Upstream: https://github.com/hongjr03/typst-zebraw
Version: 0.6.3 (Typst Universe: `@preview/zebraw:0.6.3`)
License: MIT (see `LICENSE`)

Copied from the Typst package cache (`src/` + `LICENSE`), with one local
patch (see below). Vendored so `lab-report` has zero network dependency at
compile time.

## Local patch

`src/indentation.typ`, `indentation-render-line`: guarded `line.indentation`
behind `.at("indentation", default: "")`. Upstream accesses it unconditionally
in the `hanging-indent: true` branch, which panics ("dictionary does not
contain key indentation") as soon as a `highlight-lines` entry carries a
note/comment — `util.typ`'s `process-highlight-line` pushes that annotation
line's dictionary without an `indentation` key (the `else` branch a few lines
down already guards the same access). Search "PATCH (lab-report)" in that
file. Re-check whether this is fixed upstream on the next sync, and drop the
guard if so.

To sync to a newer zebraw release: download the new version via Typst
(`#import "@preview/zebraw:<version>": *` in a scratch file, then `typst
compile` to populate the cache), diff `~/Library/Caches/typst/packages/preview/zebraw/<version>/`
against this folder, and copy `src/` + `LICENSE` over. Re-verify
`packages/lab-report/3.0.0/lib.typ`'s `codeblock` preset still calls valid
zebraw parameter names after the sync.
