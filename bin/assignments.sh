#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e pipefail

echo "$ORG_NAME"
echo "$PAT"

fetch_assigned_tasks() {
    AUTH_HEADER=$(echo -n ":$PAT" | base64)

    response="$(curl -s -H "Authorization: Basic $AUTH_HEADER" \
        "https://vssps.dev.azure.com/$ORG_NAME/_apis/profile/profiles/me?api-version=6.0")"

    if echo "$response" | grep -q "<html>"; then
        echo "Error: Authentication failed or redirection issue. Please check your PAT and organization name."
    else
        echo "$response" | jq -r '{
        displayName: .displayName,
        emailAddress: .emailAddress,
        id: .id,
        publicAlias: .publicAlias,
        lastAccessedDate: .lastAccessedDate
        }'
    fi
}

fetch_assigned_tasks
