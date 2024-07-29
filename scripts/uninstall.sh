#!/bin/bash

set -e

TOOL_DIR="/usr/local/adbm"
BIN_DIR="/usr/local/bin"
SYMLINK="$BIN_DIR/adbm"

if [ -L "$SYMLINK" ]; then
    echo "Removing symlink $SYMLINK"
    sudo rm "$SYMLINK"
else
    echo "Symlink $SYMLINK does not exist"
fi

if [ -d "$TOOL_DIR" ]; then
    echo "Removing tool directory: $TOOL_DIR"
    sudo rm -rf "$TOOL_DIR"
else
    echo "Tool directory $TOOL_DIR does not exist"
fi

echo "Uninstallation complete."
