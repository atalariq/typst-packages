# PPW1 — Praktikum Pemrograman Web 1

## Identitas

- **Kode Matkul:** PPW1
- **Nama Lengkap:** Praktikum Pemrograman Web 1
- **Dosen:** Achmad Choirudin Emcha, S.Kom., M.Eng.

## Module Phases

| Pertemuan | Topik                                                             | Teknologi                          |
| --------- | ----------------------------------------------------------------- | ---------------------------------- |
| 1-9       | HTML + Bootstrap (layout, komponen, grid)                         | HTML, CSS, Bootstrap 5 — **no JS** |
| 10+       | JavaScript (dasar, output, dialog, operator, DOM)                 | JS intensif, vanilla CSS           |
| 11+       | PHP (form processing, server-side logic, date/time, BMI, profile) | PHP, HTML, CSS classless           |

## Evaluasi (dari laprak-evaluasi.md)

| Kriteria   | Bobot |
| ---------- | ----- |
| Kerapian   | 20%   |
| Penjelasan | 60%   |
| Gambar     | 10%   |
| Bonus      | 10%   |

## Struktur Laporan Wajib

1. Cover (via preset `full`/`minimal`, or `#cover(...)` standalone)
2. Tujuan Praktikum
3. Dasar Teori (cukup 1 paragraf per teori, singkat dan jelas)
4. Hasil dan Pembahasan (**hanya Tugas Praktikum, tanpa Latihan Praktikum**)
5. Kesimpulan
6. Daftar Pustaka (sitasi format IEEE)

## Kendala Semester (mahasiswa semester 2, masih belajar)

### JavaScript — Conditional on Module Phase

- **Pertemuan 1-9 (pre-JS):** Mahasiswa **belum belajar JS.** JANGAN gunakan JavaScript untuk validasi form atau interaktivitas apa pun. Form validation: hardcode `is-valid`/`is-invalid` classes di HTML langsung, bukan via JS real-time.
- **Pertemuan 10+ (JS modules):** JS adalah topik utama — penggunaan JS intensif diharapkan. Pisahkan JS ke file `.js` jika logic >30 baris atau ada state management.

### Styling — Depends on Task Type

| Task Focus                                 | Framework               | Notes                                                                              |
| ------------------------------------------ | ----------------------- | ---------------------------------------------------------------------------------- |
| HTML/CSS (layout, komponen, grid)          | **Bootstrap 5**         | Default Bootstrap styling, minimalkan custom CSS                                   |
| JavaScript (interaksi, kalkulator, dialog) | **Vanilla CSS**         | No Bootstrap. Cukup `<style>` inline atau file `.css` terpisah                     |
| Mixed (struktur HTML + JS behavior)        | Vanilla CSS             | Bootstrap card/table masih ok kalau cuma untuk layout container                    |
| PHP server-side (form, table, layout)      | **PicoCSS** (classless) | Default: PicoCSS (pico@2) via CDN. User settled on this after trying 3 frameworks. |

### Content & Images

- **Copy/konten sering diganti user.** Gunakan placeholder sederhana. Jangan menulis copy panjang/elaborat — user lebih suka menulis sendiri agar tidak terlihat seperti hasil AI.
- **Gambar fallback:** Jangan pakai Wikimedia thumbnails (sering 404). Gunakan `picsum.photos/seed/` sebagai fallback untuk gambar placeholder. Pastikan semua `<img>` links valid.
- **Color palette:** Light → Flexoki Light (stephango.com/flexoki). Dark → Everforest (everforest.vercel.app/palette) / Tokyonight. Pakai CSS custom properties (`:root { --var: value }`).

### Code Language — English Only

**Semua** source code dalam bahasa Inggris:

- Variable/function/class names: `let userName`, `function calculate()` — jangan `namaUser`, `hitung()`
- Semua komentar dalam bahasa Inggris
- UI text (label, placeholder, button, alert, prompt) dalam bahasa Inggris
- `lang="en"` di `<html>`, `console.log()` messages dalam Inggris
- Pengecualian: `nim`, `angkatan` sebagai proper noun — tetap lowercase English variable
- **PHP:** nama fungsi, parameter, komentar, label form — semuanya English

## Pola Source Code (JS Module)

Untuk modul JavaScript (Pertemuan 10+), pola tergantung task spec:

### 1. Two-Field Calculator

Task yang mensyaratkan 2 input fields + 4 operation buttons (berdasarkan TASK.md):

- HTML: dua `<input type="number">` dengan `step="any"`, empat tombol operasi dalam flex container
- JS: `parseFloat()` + `isNaN()` untuk validasi, switch-case untuk operasi, penanganan division by zero
- File separation: `.html` struktur, `.js` logic (defer loading)
- `onsubmit="return false"` untuk mencegah form submission

### 2. Expression-Input Calculator (untuk tugas kalkulator general-purpose)

- Button-based dengan arbitrary expression input (state machine: firstOperand, operator, waitingForSecondOperand, currentValue)
- Tombol digit 0-9, operator, clear, backspace, keyboard support
- Layout: CSS Grid untuk button grid

### 3. Dialog / Form Data Pattern

- `confirm()` → `prompt()` chain untuk input serial.
- Tampilkan hasil dalam **tabel** (bisa vanilla CSS atau Bootstrap tergantung task type).
- Escape HTML dari input user (`escapeHtml()` helper) untuk mencegah XSS.
- Handle cancel/null pada setiap prompt secara independen.

### 4. Output Methods Demo

- `console.log()` → check browser console
- `alert()` → popup dialog
- `document.write()` → overwrites entire page (catat: side effect)
- `innerHTML` → modifies specific element only

### Aturan Umum JS

- **Event handlers:** `addEventListener` preferred (lebih modern). `onclick` attribute juga fine untuk file pendek (<30 baris).
- **CSS:** Vanilla CSS only (no Bootstrap). Buat layout dengan PicoCSS atau CSS Grid untuk button grid.

## PHP Module Patterns (Pertemuan 11+)

### Form Processing Pattern

Gunakan `$_SERVER['REQUEST_METHOD']` untuk ngecek metode request (lebih reliable dari `isset($_POST['...'])`):

```php
$error = '';
$result = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $value = filter_input(INPUT_POST, 'field', FILTER_VALIDATE_FLOAT);

    if ($value === false) {
        $error = 'Please enter a valid number.';
    } elseif ($value <= 0) {
        $error = 'Value must be positive.';
    } else {
        $result = doCalculation($value);
    }
}

$inputDisplay = htmlspecialchars($_POST['field'] ?? '');
```

### PHP Output Pattern

- `<?= $var ?>` — short echo tag, prefer over `<?php echo $var; ?>`
- Selalu gunakan `htmlspecialchars($var, ENT_QUOTES, 'UTF-8')` saat output user-supplied data
- Simpan nilai POST untuk value retention: `$value = htmlspecialchars($_POST['field'] ?? '')`
- Wrap conditional blocks in `<?php if (...): ?> ... <?php endif; ?>`

### Head Structure for PHP Pages

Gunakan **PicoCSS (pico@2)** via CDN — no build tools:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Page Title</title>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css"
    />
  </head>
  <body>
    <main>
      <!-- konten di sini -->
    </main>
  </body>
</html>
```

**Poin penting:**

- Jangan include normalize.css atau external font terpisah — PicoCSS handle itu.
- Gunakan `<main>` sebagai wrapper konten (semantic HTML5), bukan `<div class="container">`.
- `style.css` terpisah bersifat opsional — kalo cuma overrides dikit, cukup inline style.
- Semua halaman harus punya `<meta charset="UTF-8">` — wajib buat validasi HTML.

### Layout & Alignment Preferences

```html
<main style="text-align: center;">
  <h1>Heading Centered</h1>
  <table style="text-align: left; margin-inline: auto;">
    <tr>
      <th>Label</th>
      <td>Value</td>
    </tr>
  </table>
</main>
```

Aturan:

- **Heading** → center (`text-align: center`)
- **Tabel** → centered on page (`margin-inline: auto`), konten **rata kiri** (`text-align: left`)
- **Form inputs** → full width (default PicoCSS), labels rata kiri
- **Result section** → center kalo cuma satu nilai besar (BMI result, calculator result)
- JANGAN pake `<div class="container">` — pake `<main>` semantic element langsung

### Common PHP Pitfalls

1. **Undefined variable warnings** — semua variable yang muncul di view harus punya default value sebelum HTML dimulai.
2. **BMI category logic gap** — jangan pakai range check `>= X && <= Y`. Pake chained `<`:
   ```php
   if ($bmi < 18.5) return 'Underweight';
   elseif ($bmi < 25) return 'Normal weight';
   elseif ($bmi < 30) return 'Overweight';
   else return 'Obese';
   ```
3. **Misleading parameter names** — nama parameter harus sesuai nilai yang diterima, bukan satuan asal.
4. **Division by zero** — validasi input height > 0, weight > 0 sebelum kalkulasi.
5. **Form value retention** — setelah POST, input fields harus tetap nampak isinya via `value="<?= htmlspecialchars($_POST['field'] ?? '') ?>"`.
6. **`setlocale()` tidak berguna dengan `date()`** — untuk nama bulan Indonesia, pake array mapping manual.

## Aturan Konten

- Hasil latihan praktikum **tidak perlu dimasukkan** ke laporan, tapi source code tetap harus ada di repo GitHub.
- **Repositori GitHub:** Taruh link repo di **Lampiran**, bukan di Daftar Pustaka. Jangan tambahkan entry ke `references.bib`.
- Sertakan link Figma (jika ada desain UI/UX).

## Mode PUZZLE — Fokus Pertanyaan

Untuk PPW1, pertanyaan panduan harus fokus pada:

- **Mekanisme CSS/Bootstrap:** Bagaimana class bekerja, responsive behavior, utility classes.
- **Struktur HTML:** Semantik elemen, aksesibilitas, nesting yang benar.
- **Pilihan desain:** Mengapa memilih layout tertentu, trade-off antara approach.
- **Interaktivitas:** Bagaimana JS/Bootstrap JS mengontrol komponen (modal, alert, collapse).
- **Perilaku responsif:** Apa yang terjadi di berbagai ukuran layar, bagaimana breakpoint bekerja.

## Mode DRAFT — Rules Tambahan

- **Skip Analisis Kompleksitas** dan `#tbl()` summary table — tidak relevan untuk web development.
- **Skip Analisis Mekanisme** subsection — ganti dengan penjelasan visual/behavioral.
- Gunakan `#col(Kode, Hasil)` untuk snippet PENDEK (< 15 baris). Untuk source code panjang, gunakan full-width `#include-code()` diikuti `#img()` di bawahnya.
- **WAJIB** sertakan screenshot output di setiap tugas.
- Caption gambar harus **single-line, padat** — tidak multi-line.
- **Dasar Teori: 1 paragraf per subsection** — jangan gunakan definition list (`/ term: desc`).
- **Tugas 2 (Analisis):** cukup pemetaan komponen + grid analysis. Jangan sertakan `#code()` full source code.
- **Page break:** Tambahkan `#pagebreak()` sebelum `= Hasil dan Pembahasan` dan sebelum `= Kesimpulan`.
- **Lampiran:** gunakan `#heading(level: 1, numbering: none)[Lampiran]` (jangan `outlined: false`).
- Contoh caption baik: `caption: [Hasil render Tugas 1 yang menampilkan bilah navigasi _sticky_ dan kartu profil dengan lencana status _absolute_.]`

## Referensi Prioritas

- MDN Web Docs (https://developer.mozilla.org/)
- Bootstrap 5 Documentation (https://getbootstrap.com/docs/5.3/)
- W3C CSS Specifications
- Referensi CSS framework comparison: lihat `references/css-frameworks.md`
- Referensi PHP patterns: lihat `references/php-patterns.md`
