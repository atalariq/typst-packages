# Vendor zebraw into lab-report instead of importing it or keeping a custom engine

`lab-report` 3.0.0 shipped with a from-scratch codeblock renderer to keep
the package free of network imports, but it had rough spacing and no way to
break a long code figure across a page. Replaced it with
[zebraw](https://github.com/hongjr03/typst-zebraw), copied verbatim into
`packages/lab-report/3.0.0/vendor/zebraw/` (with one local patch for an
upstream bug, documented in that folder's README) rather than fetched via
`#import "@preview/zebraw:..."` — this keeps the zero-network-dependency
property a plain `#import "@preview/..."` would have given up.

## Consequences

The `code` package (a separate, older package with its own codeblock
helpers) deliberately was **not** given the same treatment — it still
imports `@preview/zebraw:0.6.1` over the network, one version behind and
unvendored. It's kept independently maintained rather than merged or
synced, because course-specific config (`ppbo.md`) wires to it directly and
reports predating `lab-report` 2.0.0 import it directly too. A future
change to one does not need to touch the other.
