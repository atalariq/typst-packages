# typst-packages

Typst package registry (`@atalariq/*`) plus the `typst-lab-report` agent
skill that generates lab reports on top of the `lab-report` package.

## Language

**Laprak**:
A laporan praktikum (lab report) — the document a student turns in for one
practicum session. The artifact the skill produces; not the package.
_Avoid_: report, lab-report (that's the package name, not the artifact)

**Preset**:
A fixed composition of `report()`'s building blocks (`cover`, `toc`/`tof`/`tot`,
appendix, bibliography) exposed as one show-rule call — `full` or `minimal`.
Calling `cover()`/`toc()`/etc. by hand instead is "composing directly," not a
preset.

**Course-specific config**:
The `references/course-specific/<code>.md` file for exactly one matkul
(course) — its evaluation weights, report structure quirks, tech-stack
conventions, and citation sources. Checked before generating any report;
overrides/extends the skill's general (course-agnostic) rules. A rule that
only makes sense for one course belongs here, never in a general file.

**SCAFFOLD / PUZZLE / DRAFT**:
The skill's three mutually exclusive generation modes. SCAFFOLD produces an
empty structured `report.typ` with TODOs, no prose. PUZZLE produces guiding
questions per section — the student writes the prose. DRAFT produces the
prose directly — the last resort, reviewed rather than written by the
student.
_Avoid_: "mode" alone (ambiguous — Typst itself has unrelated render modes)

**Compile gate**:
The skill's pre-compile check pass (bib checker, path validator, structure
checker) run before/after DRAFT's phases, before an actual `typst compile`.
Whether it's mandatory or optional-unless-asked is a course-specific call.

**Vendoring** (as practiced in this repo):
Copying a dependency's source verbatim into `vendor/<name>/` inside a
package's own version folder, so the package has zero network fetch at
compile time. Different from a normal `#import "@preview/..."` (fetches on
first compile, cached after) — `lab-report` vendors zebraw; `code` doesn't
and still fetches it.
