#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# echo "version"
AUTHOR="ivasik-k7"
REPOSITORY="azure-devops-branch-manager"
VERSION_FILE="default.conf"

# shellcheck disable=SC2034
API_URL="https://api.github.com/repos/$AUTHOR/$REPOSITORY/releases"

VERSION_FILE="meta.yml"

get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "Version file not found"
        exit 1
    fi
}

# response=$(curl -s "$API_URL")

# if [ -z "$response" ]; then
#     echo "No releases found or failed to fetch data."
#     exit 1
# fi

# latest_release_version=$(echo "$response" | jq -r '.[0].tag_name')
