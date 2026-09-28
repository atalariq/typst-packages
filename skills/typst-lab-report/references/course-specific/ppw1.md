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

## Evaluasi

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
- **Repositori GitHub:** Taruh link repo di **Lampiran**, bukan di Daftar Pustaka. Jangan tambahkan entry ke `references.yaml`.
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
- **Compile gate optional** — jalankan cuma kalau user minta (lihat `references/compile-gate.md`).

## Screenshot Splitting — Mengambil Koordinat dari Browser

Untuk teknik crop umumnya (scale factor, Pillow), lihat
`references/screenshot-splitting.md`. Langkah khusus web ini adalah cara
mendapatkan koordinat batas tiap section dari halaman yang sedang dikerjakan.

Buka halaman HTML-nya, jalankan ini di `browser_console`:

```js
JSON.stringify({
  vw: window.innerWidth,
  dpr: window.devicePixelRatio,
  navbar: document.querySelector(".navbar").getBoundingClientRect(),
  hero: document.querySelector(".hero-section").getBoundingClientRect(),
  works: document.querySelector("#works").getBoundingClientRect(),
  about: document.querySelector("#about").getBoundingClientRect(),
  footer: document.querySelector("footer").getBoundingClientRect(),
});
```

Ganti selector sesuai section halaman yang sedang dikerjakan. Ini
mengembalikan posisi piksel relatif terhadap viewport pada lebar viewport
saat ini. `bottom` dari section N adalah `top` dari section N+1 (atau akhir
halaman untuk section terakhir).

### Contoh nyata (dari PPW1 P9)

Browser melaporkan pada viewport 1280px:

- navbar: 0–101, hero: 0–850, works: 850–1608, about: 1608–2469, footer: 2469–2606
- page_total_height: 2606

Screenshot desktop: 2880×5164 → scale = 5164/2606 ≈ 1.98

Crop (nilai Y dibulatkan ke bawah dengan margin 20px), pakai Pillow
(`references/screenshot-splitting.md` Step 3):

```python
from PIL import Image

im = Image.open("full-ss-desktop.png")
im.crop((0, 0, im.width, 1700)).save("ss-desktop-hero.png")      # Hero (0-1700)
im.crop((0, 1680, im.width, 3200)).save("ss-desktop-works.png")  # Works (1680-3200)
im.crop((0, 3180, im.width, 4900)).save("ss-desktop-about.png")  # About (3180-4900)
im.crop((0, 4880, im.width, 5164)).save("ss-desktop-footer.png") # Footer (4880-end)
```

Untuk screenshot tablet/mobile, pakai logika scale factor yang sama dengan
dimensi masing-masing. Halaman lebih tinggi di viewport lebih kecil karena
konten menumpuk vertikal.

## Referensi Prioritas

- MDN Web Docs (https://developer.mozilla.org/)
- Bootstrap 5 Documentation (https://getbootstrap.com/docs/5.3/)
- W3C CSS Specifications
- Referensi CSS framework: lihat `## Alternatif CSS Framework` di bawah
- Referensi PHP patterns: lihat `## Pola PHP (Pertemuan 11+)` di bawah

## Alternatif CSS Framework

Drop-in classless/lightweight frameworks untuk tugas PPW1 yang butuh styling
tanpa build tools. Cukup tambahin satu `<link>` CDN — no npm, no webpack.

### Classless Frameworks (Recommended)

Zero CSS classes — just semantic HTML. Paling cocok buat tugas PPW1 yang
fokus ke PHP/JS logic.

| Framework      | Size   | Style                                | Dark Mode                          | Notes                                                                            |
| -------------- | ------ | ------------------------------------ | ---------------------------------- | -------------------------------------------------------------------------------- |
| **Pico CSS**   | ~10 KB | Modern, card-based, typography bagus | ✅ Auto                            | Paling recommended upgrade dari Milligram. Termasuk form, table, button styling. |
| **MVP.css**    | ~8 KB  | Clean, responsive                    | ❌                                 | Paling stabil. Hasilnya konsisten di semua browser.                              |
| **Simple.css** | ~6 KB  | Documentation-style, mirip MDN       | ✅ Manual via prefers-color-scheme | Cocok buat halaman yang isinya banyak teks + tabel.                              |
| **Water.css**  | ~5 KB  | Dark first, clean                    | ✅ Always dark                     | Paling enteng. Cocok kalo mau dark theme tanpa effort.                           |
| **Sakura**     | ~8 KB  | Typography-first, aesthetic          | ✅                                 | Beberapa varian tema (sakura-vimmer, sakura-earthly, dll)                        |
| **Milligram**  | ~7 KB  | Minimal, clean                       | ❌                                 | Yang skrg dipake. Butuh custom CSS tambahan.                                     |

#### Quick compatibility matrix

| Feature      | Pico      | MVP | Simple | Water | Sakura | Milligram            |
| ------------ | --------- | --- | ------ | ----- | ------ | -------------------- |
| Form         | ✅        | ✅  | ✅     | ✅    | ✅     | ✅                   |
| Table        | ✅        | ✅  | ✅     | ✅    | ✅     | ✅ (striping manual) |
| Button       | ✅        | ✅  | ✅     | ✅    | ✅     | ✅                   |
| Navbar       | ✅        | ❌  | ❌     | ❌    | ❌     | ❌                   |
| Grid/Columns | ✅ (auto) | ❌  | ❌     | ❌    | ❌     | ✅ (`.column`)       |
| Code/Pre     | ✅        | ✅  | ✅     | ✅    | ✅     | ✅                   |

### Class-based Frameworks (Heavier)

Kalo butuh layout/components lebih kompleks.

| Framework       | Size    | Style                         | Notes                                                     |
| --------------- | ------- | ----------------------------- | --------------------------------------------------------- |
| **Bulma**       | ~180 KB | Flexbox, modern components    | Navbar, card, modal, tabs, form — built-in. Gak perlu JS. |
| **Spectre.css** | ~45 KB  | Lightweight component library | Navbar, card, toast, grid. Lebih enteng dari Bulma.       |

### Decision Flow

```
Butuh framework buat tugas PHP/JS?
├── Ya, cuma bikin halaman + form + tabel sederhana
│   ├── Pilih classless (~5-10 KB)
│   │   ├── Pengen dark mode → Pico CSS (auto) atau Water.css (always dark)
│   │   ├── Mau mirip Milligram tapi lebih modern → Pico CSS
│   │   └── Mau yang paling minimal → MVP.css atau Simple.css
│   └── Pilih class-based
│       ├── Mau navbar/card/modal siap pakai → Bulma
│       └── Mau lebih enteng dari Bulma → Spectre.css
└── Gak butuh framework → Vanilla CSS (khusus tugas JS)
```

### Example: Replace Milligram with Pico CSS

**Before (Milligram):**

```html
<link
  rel="stylesheet"
  href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic"
/>
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css"
/>
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css"
/>
```

**After (Pico CSS — CDN satu baris):**

```html
<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css"
/>
```

PicoCSS includes normalization — no separate normalize.css or font import needed. Provides auto dark mode, modern form styling, and full-width inputs by default. User tested Milligram → MVP.css → PicoCSS and settled on PicoCSS as the default for PHP-server-side tasks.

## Pola PHP (Pertemuan 11+)

Kumpulan pola reusable untuk tugas PPW1 pertemuan 11+.

### 1. Form Processing — Generic Template

```php
<?php
$field1 = '';
$field2 = '';
$result = '';
$error   = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $field1 = filter_input(INPUT_POST, 'field1', FILTER_VALIDATE_FLOAT);
    $field2 = filter_input(INPUT_POST, 'field2', FILTER_VALIDATE_FLOAT);

    if ($field1 === false || $field2 === false) {
        $error = 'Please enter valid numbers.';
    } elseif ($field1 <= 0 || $field2 <= 0) {
        $error = 'Values must be positive.';
    } else {
        $result = $field1 + $field2; // replace with actual logic
    }
}

// Escape for HTML output — always do this AFTER processing
$f1 = htmlspecialchars($_POST['field1'] ?? '');
$f2 = htmlspecialchars($_POST['field2'] ?? '');
?>

<form method="POST" action="">
  <input type="number" name="field1" value="<?= $f1 ?>" required>
  <input type="number" name="field2" value="<?= $f2 ?>" required>
  <button type="submit">Calculate</button>
</form>

<?php if ($error): ?>
  <p class="error"><?= $error ?></p>
<?php elseif ($result !== ''): ?>
  <p>Result: <?= $result ?></p>
<?php endif; ?>
```

### 2. Date Helpers

```php
// Get current month info
$today     = new DateTime();
$monthNum  = (int) $today->format('n');   // 1-12, no leading zero
$day       = (int) $today->format('j');   // 1-31, no leading zero
$totalDays = (int) $today->format('t');   // 28-31
$remaining = $totalDays - $day;

// Month name in Indonesian (no strftime dependency)
$months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
           'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
$monthName = $months[$monthNum - 1];
```

### 3. BMI Calculator — Core Functions

```php
function getBMI(float $weightKg, float $heightM): float
{
    return round($weightKg / ($heightM * $heightM), 1);
}

function getBMICategory(float $bmi): string
{
    if ($bmi < 18.5)     return 'Underweight';
    if ($bmi < 25.0)     return 'Normal weight';
    if ($bmi < 30.0)     return 'Overweight';
    return 'Obese';
}

function getIdealWeightRange(float $heightM): array
{
    $sq = $heightM * $heightM;
    return [
        'min' => round(18.5 * $sq, 1),
        'max' => round(24.9 * $sq, 1),
    ];
}

function getIdealWeightInsight(float $weightKg, float $heightM): array
{
    $bmi  = getBMI($weightKg, $heightM);
    $sq   = $heightM * $heightM;
    $min  = round(18.5 * $sq, 1);
    $max  = round(24.9 * $sq, 1);

    if ($bmi < 18.5) {
        return [
            'range'   => "{$min} kg - {$max} kg",
            'message' => "You need to gain " . round($min - $weightKg, 1) . " kg.",
        ];
    }
    if ($bmi <= 24.9) {
        return [
            'range'   => "{$min} kg - {$max} kg",
            'message' => "You are within the normal range.",
        ];
    }
    return [
        'range'   => "{$min} kg - {$max} kg",
        'message' => "You need to lose " . round($weightKg - $max, 1) . " kg.",
    ];
}
```

### 4. HTML-Safe Output Helper

```php
function e(?string $value): string
{
    return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8');
}

// Usage in template:
// <input value="<?= e($_POST['name'] ?? '') ?>">
// <p><?= e($userInput) ?></p>
```

### 5. Content-Type & Encoding Note

Semua file PHP di PPW1 sebaiknya declare charset:

```php
<meta charset="UTF-8">
```

PHP `htmlspecialchars()` default charset tergantung PHP config (`default_charset`). Explicit `'UTF-8'` lebih aman.
