// Full report using the `full` preset: cover, TOC/LOF/LOT, body, appendix,
// bibliography.
// Compile: typst compile examples/full.typ

// Copied next to a report: #import "lab-report.typ": *
// Installed as a package:  #import "@atalariq/lab-report:3.0.0": *
#import "@atalariq/lab-report:3.0.0": *

#let meta = (
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "Praktikum Struktur Data dan Algoritma",
  course-code: "PSDA",
  lecturer: "Dr. John Doe",
  meeting: "4",
  title: "Implementasi Stack dan Queue Berbasis Linked List",
)

#show: full.with(
  ..meta,
  logo: image("assets/logo.png", width: 6cm),
  year: 2026,
  bib: bibliography("references.bib"),
  appendix-content: [
    Kode sumber lengkap kelas `Stack` ada di bawah ini.
    #code-figure(read("src/stack.py"), lang: "python", header: [stack.py])
  ],
  font-size: 11pt,
)

#set par(justify: true, first-line-indent: (amount: 0.5in, all: true))

= Tujuan Praktikum

+ Memahami konsep Abstract Data Type (ADT) Stack dan Queue beserta karakteristik urutannya masing-masing.
+ Mengimplementasikan struktur data Stack dan Queue menggunakan Linked List dalam bahasa pemrograman Python.
+ Menganalisis kompleksitas waktu operasi inti Stack dan Queue, meliputi Push, Pop, Enqueue, dan Dequeue.

= Dasar Teori

== Abstract Data Type (ADT)

_Abstract Data Type_ (ADT) adalah model matematis untuk suatu tipe data yang didefinisikan melalui perilakunya dari sudut pandang pengguna, bukan melalui detail implementasinya @cormen2022. ADT memisahkan antara *antarmuka* (operasi apa yang tersedia) dengan *implementasi* (bagaimana operasi itu dijalankan di memori).

== Stack dan Queue

Stack adalah ADT yang mengikuti disiplin akses _Last In, First Out_ (LIFO) @cormen2022. Queue adalah ADT yang mengikuti disiplin akses _First In, First Out_ (FIFO) @sedgewick2011.

#img(image("assets/logo.png", width: 4cm), caption: [Ilustrasi placeholder untuk diagram Stack vs Queue])

= Hasil dan Pembahasan

== Implementasi Stack

Kelas `Stack` diimplementasikan dengan sebuah list Python sebagai penyimpanan internal.

#code-figure(
  read("src/stack.py"),
  lang: "python",
  caption: [Implementasi kelas `Stack`],
  highlight-lines: ((8, [Melempar `IndexError` alih-alih diam-diam mengembalikan `None`.]),),
)

== Implementasi Queue

#code-figure(
  read("src/queue.py"),
  lang: "python",
  caption: [Implementasi kelas `Queue` berbasis `collections.deque`],
)

Berikut demonstrasi eksekusi Stack dan output-nya berdampingan:

#col(
  code-figure(```python
  s = Stack()
  s.push(10)
  s.push(20)
  print(s.pop())
  ```, header: [Eksekusi]),
  code-figure(```
  20
  ```, header: [Output], numbering: false),
)

== Catatan Highlighting Bahasa Lain

Cuplikan PHP tanpa tag pembuka `<?php` dan cuplikan Blade tetap diwarnai, karena
`codeblock`/`code-figure` mengalihkan highlighter-nya secara diam-diam (label
tab tetap menampilkan nama bahasa aslinya):

#code-figure(```php
public function edit(Project $project)
{
    return view('projects.edit', ['project' => $project]);
}
```, caption: [PHP tanpa `<?php`.])

#code-figure(```blade
@if (session('success'))
    <div class="alert">{{ session('success') }}</div>
@endif
```, caption: [Blade, diwarnai sebagai HTML.])

== Analisis Kompleksitas

#tbl(
  caption: "Kompleksitas Waktu Stack dan Queue Berbasis Linked List",
  columns: (1fr, auto, auto),
  [*Operasi*], [*Stack*], [*Queue*],
  [Push / Enqueue], [$O(1)$], [$O(1)$],
  [Pop / Dequeue], [$O(1)$], [$O(1)$],
  [Ruang (Space)], [$O(n)$], [$O(n)$],
)

= Kesimpulan

+ Stack sebagai ADT LIFO berhasil diimplementasikan.
+ Queue sebagai ADT FIFO berhasil diimplementasikan menggunakan `collections.deque`.
+ Kedua struktur data memberikan kompleksitas waktu $O(1)$ untuk operasi utamanya.
