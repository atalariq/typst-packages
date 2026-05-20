# PHP Patterns for PPW1

Kumpulan pola reusable untuk tugas PPW1 pertemuan 11+.

---

## 1. Form Processing — Generic Template

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

---

## 2. Date Helpers

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

---

## 3. BMI Calculator — Core Functions

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

---

## 4. HTML-Safe Output Helper

```php
function e(?string $value): string
{
    return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8');
}

// Usage in template:
// <input value="<?= e($_POST['name'] ?? '') ?>">
// <p><?= e($userInput) ?></p>
```

---

## 5. Content-Type & Encoding Note

Semua file PHP di PPW1 sebaiknya declare charset:

```php
<meta charset="UTF-8">
```

PHP `htmlspecialchars()` default charset tergantung PHP config (`default_charset`). Explicit `'UTF-8'` lebih aman.
