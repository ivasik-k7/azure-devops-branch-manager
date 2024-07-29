#!/bin/bash

TOOL_DIR="/usr/local/adbm"
BIN_DIR="/usr/local/bin"

if [ -L "$BIN_DIR/mytool" ]; then
    echo "Removing symlink from $BIN_DIR"
    sudo rm "$BIN_DIR/adbm"
fi

# Remove tool directory
if [ -d "$TOOL_DIR" ]; then
    echo "Removing tool directory: $TOOL_DIR"
    sudo rm -rf "$TOOL_DIR"
fi

echo "Uninstallation complete."
