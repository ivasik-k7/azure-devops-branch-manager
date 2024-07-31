#!/bin/bash
# -*- coding: utf-8 -*-
#
# Script for creating a Git branch based on Azure DevOps task details
#
# This script automates the process of creating a Git branch from an Azure DevOps work item.
# It performs the following tasks:
# 1. Checks if necessary utilities (`jq` and `curl`) are installed.
# 2. Validates if the required environment variables (`PROJECT_NAME`, `ORG_NAME`, and `PAT`) are set.
# 3. Validates the Personal Access Token (PAT) by making an authenticated request to Azure DevOps.
# 4. Fetches details of an Azure DevOps work item based on the provided task ID.
# 5. Creates a new Git branch with a name based on the work item details.
#
# Usage:
# Run this script with one argument:
#   1. The ID of the Azure DevOps work item (e.g., 1234).
#
# Note:
# Ensure that the required utilities (`jq`, `curl`) are installed and the environment variables are configured
# in your `.bashrc` file. Update `BASE_URL` if needed to match your Azure DevOps instance.

BASE_URL="https://dev.azure.com/${ORG_NAME}/${PROJECT_NAME}/_apis/wit/workitems"
BASH_PROFILE="$HOME/.bashrc"

# Function to check for required utilities
# This function checks if `jq` and `curl` are installed on the system.
# If any of these utilities are missing, it prompts the user to install them and exits.
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

# Function to check if required project information is set
# This function sources the `.bashrc` file to load environment variables and
# checks if `PROJECT_NAME` and `ORG_NAME` are set. It exits with an error if any
# of these variables are missing.
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

# Function to check if the Personal Access Token (PAT) is valid
# This function sources the `.bashrc` file to load environment variables and
# checks if `PAT` is set. It then verifies the PAT by making an authenticated
# request to Azure DevOps. It exits with an error if the PAT is invalid or
# expired, or if the request fails.
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

# Function to create a Git branch based on task details
# Arguments:
#   $1 - The task ID (e.g., 1234).
#   $2 - The task name (e.g., "Fix login issue").
#   $3 - The task type (e.g., "Bug").
# This function generates a branch name based on the task details and creates
# a new Git branch with that name. It exits with an error if the branch creation fails.
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

# Function to transform a string into a valid Git branch name
# Arguments:
#   $1 - The input string (e.g., "Fix login issue").
# This function transforms the input string by converting it to lowercase, replacing spaces with
# underscores, and removing any non-alphanumeric characters. The cleaned string is suitable for
# use as part of a Git branch name.
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

# Function to fetch details of an Azure DevOps work item
# Arguments:
#   $1 - The task ID (e.g., 1234).
# This function fetches details of a work item using the Azure DevOps REST API and extracts
# the task name and type. It exits with an error if the request fails or if the task is not found.
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
