# Commit each package's current-version example PDFs

Compiled PDFs are normally build output and a common `.gitignore` candidate
— an earlier CHANGELOG entry even claimed they'd been "removed from git
tracking." They're committed here on purpose instead: they're the preview
a prospective user sees before deciding whether to depend on a package, and
GitHub renders a linked PDF/PNG inline in the README without the viewer
needing Typst installed. Only the **current** version of each package keeps
a committed PDF — regenerate and replace it on every version bump rather
than accumulating one per historical version.
