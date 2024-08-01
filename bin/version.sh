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
        awk '
        /^  name:/ {print "Name:", substr($0, index($0, ":") + 2)}
        /^  description:/ {print "Description:", substr($0, index($0, ":") + 2)}
        /^  version:/ {print "Version:", substr($0, index($0, ":") + 2)}
        /^  release:/ {print "Release Date:", substr($0, index($0, ":") + 2)}
        /^  author:/ {print "Author:", substr($0, index($0, ":") + 2)}
        /^  license:/ {print "License:", substr($0, index($0, ":") + 2)}
        /^  support:/ {print "Support Email:", substr($0, index($0, ":") + 2)}
        ' "$VERSION_FILE"
    else
        echo "Version metadata not found"
        exit 1
    fi
}

get_current_version
