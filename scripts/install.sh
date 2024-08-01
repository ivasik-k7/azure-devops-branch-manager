#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# Script for installing the ADBM tool from a GitHub repository release
#
# This script automates the process of installing the ADBM (Azure DevOps Branch Manager) tool
# by downloading the latest or pre-release ZIP file from the specified GitHub repository,
# unzipping the file to a designated directory, setting execute permissions, and creating
# a symlink for easy access.
#
# Steps performed by this script:
# 1. Creates a tool directory if it does not already exist.
# 2. Downloads the latest release or, if that fails, the latest pre-release ZIP file.
# 3. Unzips the downloaded file to the tool directory.
# 4. Sets execute permissions for the tool's scripts.
# 5. Creates a symlink in `/usr/local/bin` to provide easy access to the main executable.
#
# Usage:
# Run this script with sufficient permissions to create directories, download files,
# and install the tool. It assumes that `curl`, `jq`, and `unzip` are installed on the system.
#
# Prerequisites:
# - curl: for downloading files from the internet.
# - jq: for parsing JSON responses from GitHub API.
# - zip: for extracting ZIP files.
#
# Repository:
# - https://github.com/ivasik-k7/azure-devops-branch-manager

set -e pipefail

AUTHOR="ivasik-k7"
REPOSITORY="azure-devops-branch-manager"

TOOL_DIR="/usr/local/adbm"
BIN_DIR="/usr/local/bin"
TEMP_DIR="/tmp/adbm_install"

if [ ! -d "$TOOL_DIR" ]; then
    echo "Creating tool directory: $TOOL_DIR"
    sudo mkdir -p "$TOOL_DIR"
fi

# Function to download the ZIP file of the latest or pre-release
# Arguments:
#   $1 - Release type, either "latest" or "pre-release"
# Globals:
#   AUTHOR, REPOSITORY, TEMP_DIR
# Outputs:
#   Downloads the ZIP file to TEMP_DIR
download_zip() {
    local release_type="$1"
    local release_info_url
    local download_url

    if [ "$release_type" == "latest" ]; then
        release_info_url="https://api.github.com/repos/$AUTHOR/$REPOSITORY/releases/latest"
    elif [ "$release_type" == "pre-release" ]; then
        release_info_url="https://api.github.com/repos/$AUTHOR/$REPOSITORY/releases"
    else
        echo "Unknown release type: $release_type"
        exit 1
    fi

    RELEASE_INFO=$(curl -s "$release_info_url")

    if [ "$release_type" == "latest" ]; then
        download_url=$(echo "$RELEASE_INFO" | grep "browser_download_url" | grep ".zip" | head -n 1 | cut -d '"' -f 4)
    else
        download_url=$(echo "$RELEASE_INFO" | jq '.[] | select(.prerelease == true) | .assets[] | select(.name | endswith(".zip")) | .browser_download_url' | head -n 1 | tr -d '"')
    fi

    if [ -z "$download_url" ]; then
        echo "Error: Unable to find a ZIP file in $release_type releases."
        return 1
    fi

    local filename
    filename=$(basename "$download_url")

    echo "Downloading $filename from $download_url..."
    curl -L -o "$TEMP_DIR/$filename" "$download_url"

    if [ $? -eq 0 ]; then
        echo "Download completed: $TEMP_DIR/$filename"
        return 0
    else
        echo "Error: Download failed."
        return 1
    fi
}

# Function to install the tool from the downloaded ZIP file
# Arguments:
#   $1 - Path to the ZIP file
# Globals:
#   TOOL_DIR, TEMP_DIR, BIN_DIR
# Outputs:
#   Extracts the ZIP file and sets up the tool
install_from_zip() {
    local zip_file="$1"

    echo "Unzipping $zip_file..."
    sudo unzip -q "$zip_file" -d "$TOOL_DIR"

    rm -rf "$TEMP_DIR"

    echo "Setting execute permissions for the main script..."
    sudo chmod +x "$TOOL_DIR/bin/"*

    echo "Creating symlink in $BIN_DIR..."
    sudo ln -sf "$TOOL_DIR/bin/adbm.sh" "$BIN_DIR/adbm"

    echo "Installation complete."
}

echo "Installing of ADBM tool..."

mkdir -p "$TEMP_DIR"

if ! download_zip "latest"; then
    echo "No latest release found or download failed. Trying pre-releases..."
    if ! download_zip "pre-release"; then
        echo "Error: No releases or pre-releases found."
        exit 1
    fi
fi

install_from_zip "$TEMP_DIR/*.zip"
