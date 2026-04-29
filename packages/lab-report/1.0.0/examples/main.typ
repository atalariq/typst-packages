#import "@atalariq/lab-report:1.0.0": *
#import "@atalariq/code:1.0.0": *

#let metadata = (
  author: "Atalariq Barra Hadinugraha",
  id: "25/557554/SV/26192",
  class: "B2",
  course: "Praktikum Struktur Data dan Algoritma",
  course-code: "PSDA",
  lecturer: "Dr. John Doe",
  meeting: "4",
  title: "Implementasi Stack dan Queue Berbasis Linked List",
)

#show: report.with(
  ..metadata,

  association: (
    program: "D-IV TEKNOLOGI REKAYASA PERANGKAT LUNAK",
    department: "DEPARTEMEN TEKNIK ELEKTRO DAN INFORMATIKA",
    faculty: "SEKOLAH VOKASI",
    university: "UNIVERSITAS GADJAH MADA",
    city: "YOGYAKARTA",
    logo: image("assets/logo.png", width: 6cm),
  ),
  year: 2026,

  use-cover: true,
  bib: bibliography("references.bib"),
  font: "Times New Roman",
  code-font: "Fira Code",
  font-size: 11pt,
)

#set par(justify: true)
#set par(first-line-indent: (amount: 0.5in, all: true))

#let include-code(path, ..args) = code-from-file(read(path), lang: path.split(".").at(-1), header: path, ..args)
#let img(path, ..args) = image-wrapper(read(path, encoding: none), ..args)

#daftar-isi()
// #daftar-gambar()
// #daftar-tabel()

= Tujuan Praktikum

+ Memahami konsep Abstract Data Type (ADT) Stack dan Queue beserta karakteristik urutannya masing-masing.
+ Mengimplementasikan struktur data Stack dan Queue menggunakan Linked List dalam bahasa pemrograman Python.
+ Menganalisis kompleksitas waktu operasi inti Stack dan Queue, meliputi Push, Pop, Enqueue, dan Dequeue.
+ Membedakan karakteristik LIFO dan FIFO serta kasus penggunaan nyata dari masing-masing struktur data.


= Dasar Teori

== Abstract Data Type ADT

_Abstract Data Type_ (ADT) adalah model matematis untuk suatu tipe data yang didefinisikan melalui perilakunya dari sudut pandang pengguna, bukan melalui detail implementasinya @cormen2022. ADT memisahkan antara *antarmuka* (operasi apa yang tersedia dan semantiknya) dengan *implementasi* (bagaimana operasi itu dijalankan di memori), sehingga memungkinkan penggantian implementasi tanpa memengaruhi kode yang bergantung padanya @aho1983.

Konsep ini merupakan fondasi dari _information hiding_ dan pemrograman modular. Dalam praktiknya, Stack dan Queue adalah dua ADT paling fundamental yang mendefinisikan dua pola akses data yang berlawanan: LIFO dan FIFO @sedgewick2011.

#img("assets/queue-vs-stack.svg", width: 14cm, caption: [Queue vs Stack])

== Stack

Stack adalah ADT yang mengikuti disiplin akses _Last In, First Out_ (LIFO): elemen yang paling terakhir dimasukkan adalah yang pertama kali dikeluarkan @cormen2022. Operasi-operasi yang didefinisikan oleh ADT Stack adalah:

/ Push: Menyisipkan elemen baru ke bagian atas (_top_) Stack.
/ Pop: Menghapus dan mengembalikan elemen dari bagian atas Stack. Menghasilkan error jika Stack kosong.
/ Peek: Mengakses elemen teratas tanpa menghapusnya.
/ isEmpty: Memeriksa apakah Stack tidak memiliki elemen.

Analogi intuitifnya adalah tumpukan piring: piring yang diletakkan paling terakhir harus diambil terlebih dahulu sebelum dapat mengakses piring di bawahnya. Dalam sistem komputer, Stack digunakan secara luas pada mekanisme _call stack_ untuk manajemen pemanggilan fungsi rekursif, algoritma _backtracking_, evaluasi ekspresi aritmatika, dan fitur undo/redo pada editor teks @cormen2022.

== Queue

Queue adalah ADT yang mengikuti disiplin akses _First In, First Out_ (FIFO): elemen yang pertama kali dimasukkan adalah yang pertama kali dikeluarkan @cormen2022. Operasi-operasinya adalah:

/ Enqueue: Menyisipkan elemen baru ke bagian belakang (_rear_) Queue.
/ Dequeue: Menghapus dan mengembalikan elemen dari bagian depan (_front_) Queue.
/ isEmpty: Memeriksa apakah Queue tidak memiliki elemen.

Berbeda dengan Stack yang hanya membutuhkan satu titik akses (_top_), Queue memerlukan dua pointer: satu ke ujung depan (_front_) untuk operasi Dequeue, dan satu ke ujung belakang (_rear_) untuk operasi Enqueue. Keduanya bergerak maju secara independen seiring operasi yang dilakukan @sedgewick2011. Queue banyak dipakai pada _task scheduling_ sistem operasi, buffer I/O, dan algoritma _Breadth-First Search_ (BFS) pada graf.

== Linked List sebagai Basis Implementasi

Linked List adalah struktur data linear yang terdiri atas simpul-simpul (_node_) yang masing-masing menyimpan data dan sebuah pointer ke simpul berikutnya @cormen2022. Karakteristik ini menjadikannya pilihan alami sebagai basis implementasi Stack dan Queue karena tiga alasan:

+ Alokasi memori bersifat dinamis; ukuran struktur tumbuh dan menyusut mengikuti kebutuhan aktual, tanpa batas kapasitas tetap.
+ Operasi penyisipan dan penghapusan di ujung list berjalan dalam $O(1)$ karena hanya memanipulasi pointer tanpa pergeseran elemen.
+ Tidak ada pemborosan memori akibat pre-alokasi berlebih seperti yang terjadi pada implementasi berbasis array.

Implementasi berbasis array memang menawarkan _cache locality_ yang lebih baik, namun memerlukan resize yang berbiaya $O(n)$ saat kapasitas penuh @sedgewick2011. Untuk kasus umum di mana ukuran data tidak dapat diprediksi, Linked List memberikan garansi $O(1)$ yang konsisten.


= Hasil dan Pembahasan

== Implementasi Node

Kedua struktur data Stack dan Queue berbagi komponen dasar yang sama: sebuah kelas `Node` yang menjadi unit penyusun Linked List.

#code(
  ```python
  class Node:
    def __init__(self, data):
      self.data = data
      self.next = None
  ```,
)

Setiap `Node` menyimpan dua atribut: `data` yang menampung nilai elemen, dan `next` yang merupakan pointer ke Node berikutnya dalam rantai. Nilai awal `next = None` menandai bahwa Node baru belum terhubung ke simpul manapun.

== Implementasi Stack

#include-code("src/stack.py")

Pointer `self.top` bertindak sebagai satu-satunya titik akses ke seluruh struktur. Pada operasi `push`, Node baru disambungkan ke Node yang sebelumnya berada di _top_ (`node.next = self.top`), kemudian `top` diperbarui ke Node baru. Operasi ini bersifat $O(1)$ karena tidak bergantung pada jumlah elemen yang sudah ada.

Pada operasi `pop`, pointer `top` dimajukan ke Node berikutnya (`self.top = self.top.next`). Node lama tidak lagi direferensikan oleh struktur manapun, sehingga _garbage collector_ Python akan secara otomatis membebaskan memorinya. Pemeriksaan `is_empty()` sebelum mengakses `self.top.data` penting untuk mencegah `AttributeError` saat Stack kosong.

Berikut adalah demonstrasi eksekusi Stack:

#col(
  code(
    header: [Eksekusi],
    numbering: false,
    ```python
    s = Stack()
    s.push(10)
    s.push(20)
    s.push(30)
    print(s.pop())    # ?
    print(s.peek())   # ?
    print(s.size)     # ?
    ```,
  ),
  code(
    header: [Output],
    numbering: false,
    ```
    30
    20
    2
    ```,
  ),
)

Urutan output `30, 20` mengonfirmasi perilaku LIFO: meskipun `10` di-push pertama, `30` yang di-push terakhir adalah yang pertama dikembalikan. Setelah `pop`, `top` kini menunjuk ke Node berisi `20`, yang dikembalikan oleh `peek` tanpa mengubah struktur.

== Implementasi Queue

#include-code("src/queue.py")

Implementasi Queue memerlukan perhatian khusus pada dua kondisi tepi (_edge cases_). Pertama, pada `enqueue` saat Queue kosong: Node baru harus diassign ke `self.front` sekaligus `self.rear`, karena elemen pertama sekaligus menjadi ujung depan dan belakang. Kedua, pada `dequeue` saat elemen terakhir dihapus: `self.front` akan menjadi `None`, sehingga `self.rear` juga harus disetel `None` untuk menjaga konsistensi state. Jika kondisi ini diabaikan, `rear` akan menjadi _dangling pointer_ yang menunjuk ke Node yang sudah tidak valid.

#col(
  code(
    header: [Eksekusi],
    numbering: false,
    ```python
    q = Queue()
    q.enqueue("A")
    q.enqueue("B")
    q.enqueue("C")
    print(q.dequeue())   # ?
    print(q.dequeue())   # ?
    print(q.size)        # ?
    ```,
  ),
  code(
    header: [Output],
    numbering: false,
    ```
    A
    B
    1
    ```,
  ),
)

Urutan output `A, B` mengonfirmasi perilaku FIFO: `A` yang masuk pertama adalah yang pertama keluar, terlepas dari urutan elemen di belakangnya.

== Analisis Kompleksitas

#tbl(
  caption: "Kompleksitas Waktu dan Ruang Stack dan Queue Berbasis Linked List",
  columns: (1fr, auto, auto),
  [*Operasi*], [*Stack*], [*Queue*],
  [Push / Enqueue], [$O(1)$], [$O(1)$],
  [Pop / Dequeue], [$O(1)$], [$O(1)$],
  [Peek / Front], [$O(1)$], [$O(1)$],
  [Pencarian (Search)], [$O(n)$], [$O(n)$],
  [Ruang (Space)], [$O(n)$], [$O(n)$],
)

Semua operasi inti Stack dan Queue berbasis Linked List berjalan dalam waktu konstan $O(1)$ karena setiap operasi hanya memanipulasi satu atau dua pointer tanpa iterasi @cormen2022. Ini berbeda dengan implementasi berbasis array, di mana operasi `push` sesekali membutuhkan $O(n)$ saat terjadi resize. Kompleksitas ruang $O(n)$ mencerminkan bahwa total memori yang digunakan sebanding lurus dengan jumlah elemen yang tersimpan, ditambah _overhead_ pointer `next` pada setiap Node.

= Kesimpulan

Berdasarkan hasil implementasi dan analisis pada praktikum ini, dapat ditarik kesimpulan sebagai berikut:

+ Stack sebagai ADT LIFO berhasil diimplementasikan menggunakan Linked List dengan satu pointer `top`, di mana operasi `push` dan `pop` keduanya berjalan dalam $O(1)$ tanpa overhead alokasi statis.
+ Queue sebagai ADT FIFO memerlukan dua pointer `front` dan `rear` untuk mempertahankan efisiensi $O(1)$ pada operasi `enqueue` dan `dequeue`; penanganan _edge case_ saat Queue kosong atau tinggal satu elemen merupakan aspek kritis implementasi yang benar.
+ Linked List terbukti menjadi basis implementasi yang efisien untuk keduanya, dengan kelebihan utama berupa alokasi memori dinamis yang menghilangkan batasan kapasitas tetap dan operasi manipulasi ujung list yang selalu $O(1)$.
+ Perbedaan mendasar antara Stack dan Queue terletak pada pola akses data: Stack cocok untuk skenario yang memerlukan pembalikan urutan (call stack, backtracking, undo/redo), sedangkan Queue cocok untuk skenario yang memerlukan pemrosesan berurutan (task scheduling, BFS, buffer I/O).

