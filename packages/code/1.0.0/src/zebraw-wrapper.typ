#import "@preview/zebraw:0.6.1": *

#let code = zebraw.with(
  lang: false,
  numbering: true,
  comment-color: luma(240),
  background-color: (luma(245), luma(248), luma(252), luma(248)),
  hanging-indent: true,
  extend: true,
)

// Usage tips:
// #let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), header: path, ..args)
#let code-from-file(read-file, lang: "py", ..code-args) = {
  code(
    raw(read-file, block: true, lang: lang),
    ..code-args
  )
}

