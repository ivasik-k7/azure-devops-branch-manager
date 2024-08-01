#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -e pipefail

echo "$ORG_NAME"
echo "$PAT"

if [ -z "$PAT" ]; then
    echo "Error: PAT is not set. Please configure it using the setup script."
    exit 1
fi

check_project_info() {
    # shellcheck disable=SC1090
    source "$BASH_PROFILE"

    if [ -z "$PROJECT_NAME" ]; then
        echo "PROJECT_NAME is not set."
        return 1
    fi

    if [ -z "$ORG_NAME" ]; then
        echo "ORG_NAME is not set."
        return 1
    fi
}

fetch_assigned_stories() {
    url="https://dev.azure.com/$ORG_NAME/$PROJECT/_apis/wit/wiql?api-version=7.0"
    query='{
        "query": "SELECT [System.Id], [System.Title], [System.WorkItemType], [System.AssignedTo], [System.State] FROM WorkItems WHERE [System.AssignedTo] = @Me AND [System.WorkItemType] = \"User Story\" ORDER BY [System.ChangedDate] DESC"
    }'

    response=$(curl -s -X POST -H "Content-Type: application/json" -u :"$PAT" -d "$query" "$url")

    work_item_ids=$(echo "$response" | jq -r '.workItems[].id')
    for id in $work_item_ids; do
        work_item_url="https://dev.azure.com/$ORG_NAME/_apis/wit/workItems/$id?api-version=7.0"
        work_item_response=$(curl -s -u :"$PAT" "$work_item_url")
        echo "$work_item_response" | jq '.'
    done

}

check_project_info
fetch_assigned_stories
