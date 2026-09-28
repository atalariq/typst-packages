# Screenshot Splitting Workflow

When a full-page screenshot is too tall for readable inline display in a
Typst report, split it into per-section crops. This file covers the
general crop mechanics — how to get the section _boundary coordinates_ in
the first place depends on what you're screenshotting (a browser page, a
terminal, an IDE), so that step lives in the relevant
`course-specific/<code>.md` (e.g. `ppw1.md` has the browser-page technique).

## Step 1: Get section coordinates

However fits the source — for a web page, see `course-specific/ppw1.md`'s
browser-console technique. You need, for each section: its top/bottom
pixel position relative to the full capture, at the same scale the full
screenshot was taken at.

## Step 2: Calculate scale factor

```
scale = full_screenshot_height / page_total_height
```

Where `page_total_height` is the bottom edge of the last section (in the
coordinate system from Step 1).

## Step 3: Crop with Python/Pillow

`pip install --break-system-packages Pillow` if not already available (no
other tool needed — this avoids a system dependency like ImageMagick, which
may not be installed).

```python
from PIL import Image

im = Image.open("full-screenshot.png")
# box = (left, top, right, bottom), in the full screenshot's own pixels
im.crop((0, top, im.width, bottom)).save("section-name.png")
```

- `top`/`bottom`: `section.top * scale` / `section.bottom * scale` from Step 1/2.
- Crop full-width (`left=0`, `right=im.width`) unless the section itself is narrower.

Add margin (~30-50px in screenshot coordinates) above/below each crop so
borders/gaps between sections are visible.

## Tip: verify crops quickly

```python
from PIL import Image
import glob

for f in glob.glob("assets/ss-*-*.png"):
    print(f, Image.open(f).size)
```

Look for reasonable aspect ratios — a section crop should be wider than
it is tall for a desktop capture, and roughly square to portrait for a
narrower one.
