# Screenshot Splitting Workflow

When full-page screenshots are too tall for readable inline display in a
Typst report, split them into per-section crops.

## Step 1: Get section coordinates from browser

Open the HTML page and run this in `browser_console`:

```js
JSON.stringify({
  vw: window.innerWidth,
  dpr: window.devicePixelRatio,
  navbar: document.querySelector('.navbar').getBoundingClientRect(),
  hero: document.querySelector('.hero-section').getBoundingClientRect(),
  works: document.querySelector('#works').getBoundingClientRect(),
  about: document.querySelector('#about').getBoundingClientRect(),
  footer: document.querySelector('footer').getBoundingClientRect(),
})
```

This returns pixel positions relative to the viewport at the current
viewport width. The `bottom` value of section N is the `top` of section
N+1 (or the end of the page for the last section).

## Step 2: Calculate scale factor

```
scale = full_screenshot_height / page_total_height
```

Where `page_total_height` is `footer.bottom` from Step 1.

## Step 3: Crop with ImageMagick (v7 `magick`)

```bash
magick full-ss-desktop.png -crop WxH+X+Y +repage ss-desktop-section.png
```

- `W`: full screenshot width (keep unchanged for section crops)
- `H`: section height × scale
- `X`: always 0 (full width)
- `Y`: section.top × scale

Add margin (~30-50px in screenshot coordinates) above/below each crop so
borders/gaps between sections are visible.

## Real example (from PPW1 P9)

Browser reported at 1280px viewport:
- navbar: 0–101, hero: 0–850, works: 850–1608, about: 1608–2469, footer: 2469–2606
- page_total_height: 2606

Desktop screenshot: 2880×5164 → scale = 5164/2606 ≈ 1.98

Crops (Y values rounded down with 20px margin):
```bash
# Hero (0 to 1700)
magick full-ss-desktop.png -crop 2880x1700+0+0 +repage ss-desktop-hero.png

# Works (1680 to 3200)
magick full-ss-desktop.png -crop 2880x1520+0+1680 +repage ss-desktop-works.png

# About (3180 to 4900)
magick full-ss-desktop.png -crop 2880x1720+0+3180 +repage ss-desktop-about.png

# Footer (4880 to end, 5164)
magick full-ss-desktop.png -crop 2880x284+0+4880 +repage ss-desktop-footer.png
```

For tablet/mobile screenshots, use the same scale-factor logic with
their respective dimensions. The page is taller on smaller viewports
because content stacks vertically.

## Tip: verify crops quickly

```bash
identify assets/ss-*-*.png | awk '{print $1, $2}'
```

Look for reasonable aspect ratios — a section crop should be wider than
it is tall for desktop, and roughly square to portrait for mobile.
