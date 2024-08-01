#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# echo "version"
AUTHOR="ivasik-k7"
REPOSITORY="azure-devops-branch-manager"

TOOL_DIR="/usr/local/adbm"
META_FILE="meta.yaml"

VERSION_FILE="$TOOL_DIR/$META_FILE"

# shellcheck disable=SC2034
API_URL="https://api.github.com/repos/$AUTHOR/$REPOSITORY/releases"

get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        while IFS= read -r line; do
            case "$line" in
            tool:)
                echo -e "\033[1;34m$line\033[0m"
                ;;
            name:* | description:* | version:* | release:* | author:* | license:* | support:*)
                key=$(echo "$line" | cut -d: -f1 | xargs)
                value=$(echo "$line" | cut -d: -f2- | xargs)
                echo -e "  \033[1;32m$key\033[0m: \033[1;37m$value\033[0m" # Green for keys, white for values
                ;;
            *)
                echo "$line"
                ;;
            esac
        done <$VERSION_FILE
    else
        echo "Version metadata not found"
        exit 1
    fi
}

get_current_version
# response=$(curl -s "$API_URL")

# if [ -z "$response" ]; then
#     echo "No releases found or failed to fetch data."
#     exit 1
# fi

# latest_release_version=$(echo "$response" | jq -r '.[0].tag_name')
