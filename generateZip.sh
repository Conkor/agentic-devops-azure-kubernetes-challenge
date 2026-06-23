#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
CURRENT_DIR_NAME=$(basename "$REPO_ROOT")
ZIP_FILE_FULL_PATH="$REPO_ROOT/$CURRENT_DIR_NAME.zip"

cd "$REPO_ROOT"
echo "Creating $ZIP_FILE_FULL_PATH from tracked files..."
git archive --format=zip --output="$ZIP_FILE_FULL_PATH" HEAD
echo "Packaging complete: $ZIP_FILE_FULL_PATH"
