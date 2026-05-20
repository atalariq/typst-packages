// @atalariq/lab-report — entrypoint

// Base show rule
#import "./report.typ": report

// Components
#import "./components/cover.typ": cover
#import "./components/sections.typ": tujuan, hasil, kesimpulan
#import "./components/toc.typ": toc, tof, tot
#import "./components/references.typ": bibliography, lampiran

// Config
#import "./config/content.typ": CONTENT

// Helpers (image, table, col, code, etc.)
#import "./helpers.typ": *

// Presets
#import "../presets/full.typ": full
#import "../presets/minimal.typ": minimal
