#import "@atalariq/code:1.0.0": *

#let file-code = read("fib.py")

#let code-raw = ```python
print("Hello, World!")
def fib(n):
    fib_list = [1, 1]
    for i in range(2, n):
        fib_list.append(fib_list[i - 1] + fib_list[i - 2])
    return fib_list[n - 1]

print(fib(3))
print(fib(9))
```

= raw text

#code-raw

= raw from file

#raw(file-code, block: true, lang: "python", tab-size: 4)


= code (raw code)

#code(code-raw, header: "file.py", indentation: 4)

= code-from-file

#code-from-file(file-code, header: "file.py", indentation: 4)

== Usage Tips

Add this line to your document:

#code(
  ```typ
  #let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), header: path, ..args)

  ...
  #include-code("your/code/path")
  ...
  ```,
)

#let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), header: path, ..args)

Result example:
#include-code("fib.py")

= codedis (file)

#codedis(file-code, line-numbers: true)

