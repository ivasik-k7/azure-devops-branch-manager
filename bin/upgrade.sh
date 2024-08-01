#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e pipefail

AUTHOR="ivasik-k7"
REPOSITORY="azure-devops-branch-manager"

TOOL_DIR="/usr/local/adbm"
VERSION_FILE="meta.yaml"

META_FILE="$TOOL_DIR/$VERSION_FILE"

# shellcheck disable=SC2034
API_URL="https://api.github.com/repos/$AUTHOR/$REPOSITORY/releases"

response=$(curl -s "$API_URL")

if [ -z "$response" ]; then
    echo "Failed to fetch data from GitHub API."
    exit 1
fi

latest_release_version=$(echo "$response" | jq -r '.[0].tag_name' | sed 's/^v//')

if [ -z "$latest_release_version" ]; then
    echo "Failed to parse the latest release version."
    exit 1
fi

current_version=$(grep "^  version:" "$META_FILE" | awk '{print $2}' | tr -d '"')

if [ -z "$current_version" ]; then
    echo "Current version not found in '$META_FILE'."
    exit 1
fi

version_gt() {
    local v1="$1"
    local v2="$2"

    # shellcheck disable=SC2155
    local base_v1=$(echo "$v1" | sed 's/-.*//')
    # shellcheck disable=SC2155
    local base_v2=$(echo "$v2" | sed 's/-.*//')

    if [ "$base_v1" != "$base_v2" ]; then
        [ "$(echo -e "$base_v1\n$base_v2" | sort -V | head -n1)" != "$base_v1" ]
    else
        [ "$v1" != "$v2" ]
    fi
}

if version_gt "$latest_release_version" "$current_version"; then
    echo "Updating version from '$current_version' to '$latest_release_version' in '$META_FILE'."

    SCRIPT_PATH=$(readlink -f "$0")
    SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

    cd "$SCRIPT_DIR"
    cd ../

    ./scripts/uninstall.sh
    ./scripts/install.sh

    cd "$SCRIPT_DIR"

    echo "Version updated to '$latest_release_version'."
else
    echo "Current version '$current_version' is up-to-date!"
fi
