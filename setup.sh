#!/usr/bin/env bash
# Setup script for Atalariq's Typst Packages + Hermes Skills
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Symlinking Typst packages..."
mkdir -p ~/.local/share/typst/packages
ln -sfn "$REPO_DIR/packages" ~/.local/share/typst/packages/atalariq
echo "  → @atalariq/* packages linked to ~/.local/share/typst/packages/atalariq"

echo "=== Symlinking Hermes skills..."
mkdir -p ~/.hermes/skills/productivity
ln -sfn "$REPO_DIR/skills/typst-lab-report" ~/.hermes/skills/productivity/typst-lab-report
echo "  → typst-lab-report skill linked to ~/.hermes/skills/productivity/typst-lab-report"

echo ""
echo "✓ Setup complete. Verify with:"
echo "  typst compile packages/lab-report/1.0.0/examples/main.typ"
echo "  ls -la ~/.hermes/skills/productivity/typst-lab-report"
