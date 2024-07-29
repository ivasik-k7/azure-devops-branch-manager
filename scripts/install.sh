#!/bin/bash

set -e

TOOL_DIR="/usr/local/adbm"
BIN_DIR="/usr/local/bin"

REPO="https://raw.githubusercontent.com/ivasik-k7/azure_workitems_helper"
BRANCH="main"

FILES=(
    "bin/adbm.sh"
    "bin/branch.sh"
    "bin/set.sh"
)

if [ ! -d "$TOOL_DIR" ]; then
    echo "Creating tool directory: $TOOL_DIR"
    sudo mkdir -p "$TOOL_DIR"
fi

for FILE in "${FILES[@]}"; do
    URL="${REPO}/${BRANCH}/${FILE}"
    DEST_DIR="$TOOL_DIR/$(dirname "$FILE")"

    if [ ! -d "$DEST_DIR" ]; then
        sudo mkdir -p "$DEST_DIR"
    fi

    echo "Downloading $FILE"
    sudo curl -fsSL "$URL" -o "$TOOL_DIR/$FILE"

    echo "Setting execute permissions for $FILE"
    sudo chmod +x "$TOOL_DIR/$FILE"

done

echo "Creating symlink in $BIN_DIR"
sudo ln -sf "$TOOL_DIR/bin/adbm.sh" "$BIN_DIR/adbm"

echo "Installation complete."
