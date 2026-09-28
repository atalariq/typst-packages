#!/usr/bin/env bash
# Setup script for Atalariq's Typst Packages + Hermes Skills
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# Typst resolves local packages from a platform-specific data directory.
# macOS uses ~/Library/Application Support, everything else follows XDG.
case "$(uname -s)" in
  Darwin) TYPST_PKG_DIR="$HOME/Library/Application Support/typst/packages" ;;
  *)      TYPST_PKG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/typst/packages" ;;
esac

echo "=== Symlinking Typst packages..."
mkdir -p "$TYPST_PKG_DIR"
ln -sfn "$REPO_DIR/packages" "$TYPST_PKG_DIR/atalariq"
echo "  → @atalariq/* linked to $TYPST_PKG_DIR/atalariq"

echo "=== Symlinking Agents skills..."
mkdir -p ~/.agents/skills
ln -sfn "$REPO_DIR/skills/typst-lab-report" ~/.agents/skills/typst-lab-report
echo "  → typst-lab-report skill linked to ~/.agents/skills/typst-lab-report"

echo ""
echo "✓ Setup complete. Verify with:"
echo "  typst compile packages/lab-report/3.0.0/examples/full.typ"
echo "  ls -la ~/.agents/skills/typst-lab-report"
