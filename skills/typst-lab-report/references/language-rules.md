# Language & Writing Rules

## Register

- Pasif impersonal ("dibuat", "dijalankan", "diverifikasi") adalah register standar untuk prosedur — bukan tanda menyembunyikan pelaku, dan bukan sesuatu yang perlu dihindari.
- Forbidden sebagai subjek kalimat: saya, aku, kita, kami, penulis, praktikan, mahasiswa, user, pengguna.
- Satu pengecualian: jangan sembunyikan pelaku ketika pelaku itu (biasanya framework/tool, bukan mahasiswa) yang menentukan hasil dan langkah berikutnya bergantung pada tahu siapa pelakunya. "Laravel mengarahkan request kembali ke form saat validasi gagal" — bukan "Request diarahkan kembali ke form" — kalau pembaca perlu tahu itu otomatis dari framework, bukan kode yang ditulis sendiri.
- No colloquialisms, contractions, informal abbreviations.
- No em dashes (`---` atau `—`). Pakai koma, titik dua, atau titik koma.

## Kalimat

- Satu kalimat, satu tindakan/ide. Kalimat yang menumpuk beberapa langkah dengan "lalu"/"kemudian"/"sehingga" dipecah jadi kalimat terpisah.
- Syarat sebelum instruksi: "Jika koneksi database gagal, periksa file `.env`" — bukan sebaliknya.
- Variasikan struktur kalimat berturutan; hindari pola subjek-predikat-objek yang berulang tanpa jeda.
- Hindari nominalisasi kata kerja yang membekukannya jadi kata benda: "dilakukan pengujian terhadap" → "diuji".

## Paragraf

- Satu ide pokok per paragraf.
- Paragraf analisis (Dasar Teori, Pembahasan): deduktif — ide pokok di kalimat pertama, penjelasan menyusul. Pembaca yang skim mencari kalimat pertama tiap paragraf dulu.

## Gaya Penulisan

Laprak bukan how-to murni ala Diátaxis (yang mensyaratkan how-to "action and
only action", alasan dipisah ke halaman lain). Pilihan sadar di sini
kebalikannya, demi reading flow ala Google Codelabs:

- `Langkah Kerja` boleh menyinggung ulang teori yang relevan secara singkat di tempat, bukan hanya merujuk balik ke `Dasar Teori`. Pembaca tidak harus bolak-balik antar-seksi untuk mengerti satu langkah.
- Redundansi antara `Dasar Teori` dan `Langkah Kerja`/`Pembahasan` itu diterima, bahkan disengaja — bukan pengulangan yang perlu dipangkas.
- Tetap jangan gabung tindakan + alasan dalam satu kalimat majemuk (lihat aturan Kalimat) — dua kalimat pendek berdekatan, bukan satu kalimat panjang.

## Terminology

- English terms without accepted Indonesian equivalent → italicise on first use per section: `_grid system_`, `_navbar_`, `_card_`, `_breakpoint_`, `_modal_`.
- Accepted Indonesian equivalents don't need italics: tata letak, bilah navigasi, kartu, tabel, formulir.
- After first use in a section, no re-italicising needed.

## Citations (IEEE)

- `@citekey` syntax in Typst.
- Every factual claim about tech/spec/standard MUST have citation.
- Placement: after the period of the supported sentence.
- Every `@citekey` must have matching entry in `references.yaml` with a `url` field.

## Referensi Bibliografi (Hayagriva)

- Format entri: `references.yaml` (Hayagriva), bukan `references.bib` (BibLaTeX). Typst native mendukung Hayagriva tanpa package tambahan.
- Field wajib per entri: `type`, `title`, `author` (list, format `Nama Belakang, Nama Depan`), `date`, `url`.
- Prefer sumber: MDN Web Docs, W3C, dokumentasi resmi framework, textbook.
- Laporan lama (sebelum 2026-09-29) yang masih pakai `references.bib` tetap valid dan tidak perlu dikonversi — Typst membaca dua-duanya. Hanya laporan baru yang pakai `.yaml`.
