#!/bin/bash
# -*- coding: utf-8 -*-
#
# Script for uninstalling the ADBM tool
#
# This script automates the process of uninstalling the ADBM (Azure DevOps Branch Manager) tool
# by removing the symlink created for the tool's executable and deleting the directory where
# the tool was installed.
#
# Steps performed by this script:
# 1. Removes the symbolic link for the tool's executable if it exists.
# 2. Deletes the directory where the tool was installed if it exists.
#
# Usage:
# Run this script with sufficient permissions to remove files and directories. Ensure
# that `sudo` is available for performing operations that require elevated privileges.
#
# Repository:
# - https://github.com/ivasik-k7/azure-devops-branch-manager

set -e pipefail

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
