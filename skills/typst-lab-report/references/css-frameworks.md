# CSS Framework Alternatives for PPW1

Drop-in classless/lightweight frameworks untuk tugas PPW1 yang butuh styling tanpa build tools.
Cukup tambahin satu `<link>` CDN — no npm, no webpack.

---

## Classless Frameworks (Recommended)

Zero CSS classes — just semantic HTML. Paling cocok buat tugas PPW1 yang fokus ke PHP/JS logic.

| Framework | Size | Style | Dark Mode | Notes |
|-----------|------|-------|-----------|-------|
| **Pico CSS** | ~10 KB | Modern, card-based, typography bagus | ✅ Auto | Paling recommended upgrade dari Milligram. Termasuk form, table, button styling. |
| **MVP.css** | ~8 KB | Clean, responsive | ❌ | Paling stabil. Hasilnya konsisten di semua browser. |
| **Simple.css** | ~6 KB | Documentation-style, mirip MDN | ✅ Manual via prefers-color-scheme | Cocok buat halaman yang isinya banyak teks + tabel. |
| **Water.css** | ~5 KB | Dark first, clean | ✅ Always dark | Paling enteng. Cocok kalo mau dark theme tanpa effort. |
| **Sakura** | ~8 KB | Typography-first, aesthetic | ✅ | Beberapa varian tema (sakura-vimmer, sakura-earthly, dll) |
| **Milligram** | ~7 KB | Minimal, clean | ❌ | Yang skrg dipake. Butuh custom CSS tambahan. |

### Quick compatibility matrix

| Feature | Pico | MVP | Simple | Water | Sakura | Milligram |
|---------|------|-----|--------|-------|--------|-----------|
| Form | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Table | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ (striping manual) |
| Button | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Navbar | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Grid/Columns | ✅ (auto) | ❌ | ❌ | ❌ | ❌ | ✅ (`.column`) |
| Code/Pre | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## Class-based Frameworks (Heavier)

Kalo butuh layout/components lebih kompleks.

| Framework | Size | Style | Notes |
|-----------|------|-------|-------|
| **Bulma** | ~180 KB | Flexbox, modern components | Navbar, card, modal, tabs, form — built-in. Gak perlu JS. |
| **Spectre.css** | ~45 KB | Lightweight component library | Navbar, card, toast, grid. Lebih enteng dari Bulma. |

---

## Decision Flow

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

---

## Example: Replace Milligram with Pico CSS

**Before (Milligram):**
```html
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css">
```

**After (Pico CSS — CDN satu baris):**
```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
```

PicoCSS includes normalization — no separate normalize.css or font import needed. Provides auto dark mode, modern form styling, and full-width inputs by default. User tested Milligram → MVP.css → PicoCSS and settled on PicoCSS as the default for PHP-server-side tasks.
