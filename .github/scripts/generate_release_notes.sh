#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e

if [ ! -d .git ]; then
    echo "This script must be run in a Git repository."
    exit 1
fi

LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

if [ -z "$LATEST_TAG" ]; then
    echo "No tags found in the repository. Including all commits."
    COMMITS=$(git log --oneline)
    RELEASE_NOTES="### Release Notes:\n\n"
else
    echo "Latest Tag: $LATEST_TAG"
    COMMITS=$(git log "$LATEST_TAG"..HEAD --oneline)
    if [ -z "$COMMITS" ]; then
        echo "No new commits since the latest tag."
        exit 0
    fi
    RELEASE_NOTES="### Release Notes since $LATEST_TAG:\n\n"
fi

RELEASE_NOTES+="$(echo "$COMMITS" | sed 's/^/- /')"

OUTPUT_FILE="RELEASE_NOTES.md"

echo -e "$RELEASE_NOTES" >"$OUTPUT_FILE"
echo -e "$RELEASE_NOTES"

echo "Release notes generated successfully."

echo "RELEASE_NOTES<<EOF" >>$GITHUB_ENV
cat "$OUTPUT_FILE" >>$GITHUB_ENV
echo "EOF" >>$GITHUB_ENV
