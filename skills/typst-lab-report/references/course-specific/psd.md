# PSD — Praktikum Struktur Data

## Identitas
- **Kode Matkul:** PSD
- **Nama Lengkap:** Praktikum Struktur Data
- **Dosen:** Firma Syahrian, S.Kom., M.Cs.

## Evaluasi (dari silabus/RPS)
| Kriteria | Bobot |
|----------|-------|
| Kebenaran implementasi (kode berfungsi sesuai spesifikasi) | 40% |
| Penjelasan konsep dan algoritma | 30% |
| Analisis kompleksitas waktu | 15% |
| Kerapian dan kelengkapan laporan (screenshot, diagram, daftar pustaka) | 15% |

## Struktur Laporan Wajib
1. Cover
2. Tujuan Praktikum
3. Dasar Teori
4. Hasil dan Pembahasan
5. Kesimpulan
6. Daftar Pustaka (IEEE)
7. Lampiran — source code lengkap

## Aturan Konten (course-specific)
- Dasar Teori mencakup BST, DFS, BFS dengan penjelasan konsep + kompleksitas
- Setiap method pada implementasi BST wajib disertai penjelasan alur kerjanya
- Traversal (inorder, preorder, postorder) dijelaskan perbedaan dan kegunaannya
- Graf untuk DFS/BFS harus divisualisasikan (diagram pohon/graf atau adjacency list)
- Screenshot output terminal wajib untuk setiap program
- Analisis kompleksitas waktu wajib untuk setiap algoritma yang diimplementasikan
- Sertakan diagram pohon untuk tugas manual (Tugas 3)

## Mode PUZZLE — Fokus Pertanyaan
- Kompleksitas waktu dan ruang setiap operasi BST (search, insert, min, max)
- Perbandingan DFS vs BFS: kapan menggunakan masing-masing?
- Edge cases: pencarian nilai yang tidak ada, tree kosong, root saja
- Perbedaan traversal inorder, preorder, postorder dalam konteks aplikasi nyata

## Mode DRAFT — Rules Tambahan
- Sertakan diagram BST hasil konstruksi manual (Tugas 3) sebagai teks atau gambar
- Gunakan `#include-code()` dengan `line-range` untuk setiap method utama
- Setiap method yang dibahas harus disertakan snippet kode yang relevan
- Gunakan `$O(…)$` untuk notasi kompleksitas waktu
- Bahasa pemrograman: Python (`lang: "python"`)

## Referensi Prioritas
- Modul Praktikum Struktur Data (module.pdf)
- GeeksforGeeks — Binary Search Tree: https://www.geeksforgeeks.org/binary-search-tree-data-structure/
- GeeksforGeeks — BFS vs DFS: https://www.geeksforgeeks.org/bfs-vs-dfs-binary-tree/
- Python Software Foundation — Data Structures: https://docs.python.org/3/tutorial/datastructures.html
- Introduction to Algorithms (CLRS) — Bab 12: Binary Search Trees, Bab 22: Elementary Graph Algorithms
