#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e pipefail

fetch_assigned_tasks() {
    curl -s -u :$PAT \
        "https://vssps.dev.azure.com/$ORG/_apis/profile/profiles/me?api-version=6.0" | jq -r '{
      displayName: .displayName,
      emailAddress: .emailAddress,
      id: .id,
      publicAlias: .publicAlias,
      lastAccessedDate: .lastAccessedDate
    }'
}
