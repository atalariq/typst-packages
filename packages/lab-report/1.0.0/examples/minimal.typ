#import "@atalariq/lab-report:1.0.0": *
#import "@atalariq/code:1.0.0": *

#let metadata = (
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "Praktikum Struktur Data",
  course-code: "PSD",
  lecturer: "Dr. John Doe",
  meeting: "6",
  title: "Implementasi Dequeue pada Sistem Antrean",
)

#show: report.with(
  ..metadata,
  use-cover: false,
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 12pt,
)


// ? imple header
#align(center)[
  #text(1.25em, weight: "bold")[
    Tugas #metadata.course \
    #metadata.title
  ]

  #text(0.8em)[
    #metadata.author (#metadata.id)
  ]
]
#line(length: 100%)


#set par(justify: true)
#set heading(numbering: "1.")
#set enum(numbering: "a.1.")

#let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), ..args)
#let img(path, ..args) = image-wrapper(read(path, encoding: none), ..args)

= Dasar Teori

Dequeue (double-ended queue) adalah struktur data linear yang mendukung operasi
penambahan dan penghapusan elemen dari kedua ujungnya secara efisien. Properti
inilah yang membuatnya cocok untuk sistem antrean dengan dua kelas pelanggan
tanpa memerlukan dua struktur terpisah.

Pada sistem antrean bank ini, satu `deque` tunggal merepresentasikan seluruh
antrean. Perbedaan perlakuan antara pelanggan reguler dan prioritas diatur
melalui *titik masuk* yang berbeda:

- Pelanggan *reguler* ditambahkan ke ujung belakang via `append()`, sehingga
  mengikuti urutan kedatangan normal (FIFO).
- Pelanggan *prioritas* ditambahkan ke ujung depan via `appendleft()`, sehingga
  langsung menempati posisi terdepan di antara semua pelanggan yang sudah ada.

Pelayanan selalu diambil dari depan antrean via `popleft()`, artinya pelanggan
prioritas yang baru masuk akan selalu dilayani lebih dahulu daripada pelanggan
reguler mana pun, terlepas dari waktu kedatangan pelanggan reguler tersebut.

Seluruh operasi inti yang digunakan, yaitu `append()`, `appendleft()`, dan
`popleft()`, berjalan dalam waktu $O(1)$ amortized. Hal ini dimungkinkan karena
implementasi `deque` pada Python menggunakan double-linked list of fixed-size
blocks, sehingga akses ke kedua ujung tidak memerlukan pergeseran elemen seperti
yang terjadi pada `list` biasa. Dengan demikian, sistem antrean ini tetap
efisien bahkan saat jumlah pelanggan bertambah besar.

Satu catatan penting: jika beberapa pelanggan prioritas masuk secara berurutan,
masing-masing akan ditempatkan di posisi paling depan saat itu. Artinya,
pelanggan prioritas yang masuk *terakhir* justru berada di urutan *paling depan*
di antara sesama pelanggan prioritas. Ini merupakan perilaku LIFO di antara
kelompok prioritas, bukan FIFO. Perilaku ini perlu diperhatikan jika sistem
menuntut fairness di antara sesama pelanggan prioritas. Maka dari itu, solusi ke-2 ditawarkan (lihat @solusi-2).

#pagebreak()

= Implementasi

== Kode Program dan Penjelasan

Import dan deklarasi struktur data `deque` dari module `collections` (bawaan dari Python)
#include-code("./src/deque.py", line-range: (1, 5))

Deklrasi fungsi bantuan untuk menampilkan daftar antrean:
#include-code("./src/deque.py", line-range: (5, 13))

Deklrasi fungsi untuk menambahkan pelanggan reguler ke belakang antrean:
#include-code("./src/deque.py", line-range: (13, 16))

Deklrasi fungsi untuk menambahkan pelanggan prioritas ke awal antrean:
#include-code("./src/deque.py", line-range: (16, 19))

Deklarasi fungsi untuk melayani pelanggan yang berada di awal antrean:
#include-code("./src/deque.py", line-range: (19, 23))

Contoh penggunaan fungsi-fungsi yang telah diimplementasikan:
#include-code("./src/deque.py", line-range: (23, 36))

== Output

#img("assets/deque.png", caption: [Hasil output program `antrean_deque.py`])

#pagebreak()

= Lampiran

== Solusi Kedua <solusi-2>

Modifikasi deque untuk menyelesaikan antrean pelanggan prioritas dengan `queue` biasa (FIFO).

#include-code("./src/deque_fixed.py", header: [antrean_deque_modified.py], line-range: (1, 60))

#img("assets/deque-fixed.png", caption: [Hasil output untuk implementasi solusi ke-2 (`antrean_deque_modified.py`)])

