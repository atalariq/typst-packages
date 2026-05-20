// Full report using the `full` preset with bibliography and appendix.
// Compile: typst compile examples/full.typ

#import "@atalariq/lab-report:2.0.0": *

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
  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
    logo: image("assets/logo.png", width: 6cm),
  ),
  year: 2026,
  bib: bibliography("references.bib"),
  appendix-content: [FULL SOURCE CODE ada di Lampiran. #code-from-file(read("src/stack.py"), lang: "python", header: "stack.py")],
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 11pt,
)

#set par(justify: true, first-line-indent: (amount: 0.5in, all: true))

#let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), header: path, ..args)
#let img(path, ..args) = image-wrapper(read(path, encoding: none), ..args)

= Tujuan Praktikum

+ Memahami konsep Abstract Data Type (ADT) Stack dan Queue beserta karakteristik urutannya masing-masing.
+ Mengimplementasikan struktur data Stack dan Queue menggunakan Linked List dalam bahasa pemrograman Python.
+ Menganalisis kompleksitas waktu operasi inti Stack dan Queue, meliputi Push, Pop, Enqueue, dan Dequeue.
+ Membedakan karakteristik LIFO dan FIFO serta kasus penggunaan nyata dari masing-masing struktur data.

= Dasar Teori

== Abstract Data Type ADT

_Abstract Data Type_ (ADT) adalah model matematis untuk suatu tipe data yang didefinisikan melalui perilakunya dari sudut pandang pengguna, bukan melalui detail implementasinya @cormen2022. ADT memisahkan antara *antarmuka* (operasi apa yang tersedia dan semantiknya) dengan *implementasi* (bagaimana operasi itu dijalankan di memori), sehingga memungkinkan penggantian implementasi tanpa memengaruhi kode yang bergantung padanya @aho1983.

#img("assets/queue-vs-stack.svg", width: 14cm, caption: [Queue vs Stack])

== Stack

Stack adalah ADT yang mengikuti disiplin akses _Last In, First Out_ (LIFO): elemen yang paling terakhir dimasukkan adalah yang pertama kali dikeluarkan @cormen2022. Operasi-operasinya meliputi Push, Pop, Peek, dan isEmpty.

== Queue

Queue adalah ADT yang mengikuti disiplin akses _First In, First Out_ (FIFO): elemen yang pertama kali dimasukkan adalah yang pertama kali dikeluarkan @cormen2022. Operasi-operasinya meliputi Enqueue, Dequeue, dan isEmpty.

== Linked List sebagai Basis Implementasi

Linked List adalah struktur data linear yang terdiri atas simpul-simpul (_node_) yang masing-masing menyimpan data dan sebuah pointer ke simpul berikutnya @cormen2022. Karakteristik ini menjadikannya pilihan alami sebagai basis implementasi Stack dan Queue karena alokasi memori dinamis dan operasi $O(1)$ pada ujung list.

= Hasil dan Pembahasan

== Implementasi Node

#code(
  ```python
  class Node:
    def __init__(self, data):
      self.data = data
      self.next = None
  ```,
)

== Implementasi Stack

#include-code("src/stack.py")

Berikut demonstrasi eksekusi Stack:

#col(
  code(header: [Eksekusi], numbering: false, ```python
  s = Stack()
  s.push(10); s.push(20); s.push(30)
  print(s.pop())
  ```),
  code(header: [Output], numbering: false, ```
  30
  ```),
)

== Implementasi Queue

#include-code("src/queue.py")

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

+ Stack sebagai ADT LIFO berhasil diimplementasikan menggunakan Linked List.
+ Queue sebagai ADT FIFO memerlukan dua pointer `front` dan `rear`.
+ Linked List memberikan garansi $O(1)$ untuk operasi di ujung list.
