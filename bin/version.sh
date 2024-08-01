#!/usr/bin/env bash
# -*- coding: utf-8 -*-

TOOL_DIR="/usr/local/adbm"
VERSION_FILE="meta.yaml"

META_FILE="$TOOL_DIR/$VERSION_FILE"

get_current_version() {
    if [ -f "$META_FILE" ]; then
        echo
        awk '
        /^  name:/ {print "Name:", substr($0, index($0, ":") + 2)}
        /^  description:/ {print "Description:", substr($0, index($0, ":") + 2)}
        /^  version:/ {print "Version:", substr($0, index($0, ":") + 2)}
        /^  release:/ {print "Release Date:", substr($0, index($0, ":") + 2)}
        /^  author:/ {print "Author:", substr($0, index($0, ":") + 2)}
        /^  license:/ {print "License:", substr($0, index($0, ":") + 2)}
        /^  support:/ {print "Support Email:", substr($0, index($0, ":") + 2)}
        ' "$META_FILE"
        echo
    else
        echo "Version file not found"
        exit 1
    fi
}

get_current_version
