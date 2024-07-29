#!/bin/bash

set -ex

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

echo "Creating symlink in $BIN_DIR"
sudo ln -sf "$TOOL_DIR/bin/adbm.sh" "$BIN_DIR/adbm"

echo "Installation complete."
