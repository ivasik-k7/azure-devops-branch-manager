#!/usr/bin/env bash
# -*- coding: utf-8 -*-

VERSION_FILE="meta.yaml"

get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "Version file not found"
        exit 1
    fi
}
