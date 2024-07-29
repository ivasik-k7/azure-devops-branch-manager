#!/bin/bash

set -e

BASE_URL="https://dev.azure.com/${ORG_NAME}/${PROJECT_NAME}/_apis/wit/workitems"
BASH_PROFILE="$HOME/.bashrc"

check_utilities() {
    local missing_utilities=()

    if ! command -v jq &>/dev/null; then
        missing_utilities+=("jq")
    fi

    if ! command -v curl &>/dev/null; then
        missing_utilities+=("curl")
    fi

    if [ ${#missing_utilities[@]} -ne 0 ]; then
        echo "The following required utilities are missing:"
        for util in "${missing_utilities[@]}"; do
            echo "- $util"
        done
        echo "Please install them and try again."
        exit 1
    fi
}

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

check_pat() {
    # shellcheck disable=SC1090
    source "$BASH_PROFILE"

    if [ -z "$PAT" ]; then
        echo "Error: PAT is not set. Please configure it using the setup script."
        exit 1
    fi

    VALIDATION_URL="https://dev.azure.com/${ORG_NAME}/_apis/projects/?api-version=6.0"

    response=$(curl -s -o /dev/null -w "%{http_code}" -u ":$PAT" "$VALIDATION_URL")

    if [ "$response" -eq 200 ]; then
        echo "PAT is valid."
    elif [ "$response" -eq 401 ]; then
        echo "Error: PAT is invalid or expired."
        exit 1
    else
        echo "Error: Failed to validate PAT. HTTP response code: $response"
        exit 1
    fi
}

create_branch() {
    local task_id=$1
    local task_name=$2
    local task_type=$3

    transformed_name=$(transform_string "$task_name")
    transformed_type=$(transform_string "$task_type")
    branch_name="$transformed_type/$task_id/$transformed_name"

    echo "$branch_name"

    echo "$branch_name"

    if ! git checkout -b "$branch_name"; then
        echo "Failed to create the branch. Ensure you are in a Git repository."
        exit 1
    fi
}

transform_string() {
    local input="$1"

    local lowercase
    local underscores
    local cleaned

    lowercase=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    underscores=$(echo "$lowercase" | tr ' ' '_')
    # shellcheck disable=SC2001
    cleaned=$(echo "$underscores" | sed 's/[^a-z0-9_]//g')

    echo "$cleaned"
}

fetch_task_details() {
    local task_id="$1"
    local response
    local task_type
    local task_name

    if ! response=$(curl -s -u :"$PAT" "${BASE_URL}/${task_id}?api-version=6.0"); then
        echo "Failed to fetch data. Please check your PAT or URL."
        exit 1
    fi

    task_name=$(echo "$response" | jq -r '.fields."System.Title"')
    task_type=$(echo "$response" | jq -r '.fields."System.WorkItemType"')

    if [ "$task_name" == "null" ] || [ "$task_type" == "null" ]; then
        echo "Task with ID $task_id not found or missing fields."
        exit 1
    fi

    echo "$task_name|$task_type"
}

TASK_NUMBER=$1

check_utilities
check_project_info
check_pat

task_details=$(fetch_task_details "$TASK_NUMBER")

task_name=$(echo "$task_details" | cut -d'|' -f1)
task_type=$(echo "$task_details" | cut -d'|' -f2)

create_branch "$TASK_NUMBER" "$task_name" "$task_type"
