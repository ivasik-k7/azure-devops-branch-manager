#!/usr/bin/env bash
# -*- coding: utf-8 -*-

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

BRANCH_SCRIPT="$SCRIPT_DIR/branch.sh"
SET_SCRIPT="$SCRIPT_DIR/set.sh"
ASSIGNMENTS_SCRIPT="$SCRIPT_DIR/assignments.sh"
VERSION_SCRIPT="$SCRIPT_DIR/version.sh"
UPGRADE_SCRIPT="$SCRIPT_DIR/upgrade.sh"

print_help() {
    echo
    echo "Usage:"
    echo
    echo " adbm [command] [options]"
    echo
    echo "Available commands:"
    echo
    echo "  help        Display this help message."
    echo "  version     Show the version of the tool."
    echo "  branch      Create a new branch."
    echo "  configure   Set configuration variables."
    echo "  assignments List work items assigned to you."
    echo "  upgrade     Upgrade the tool to the latest version."
    echo
    echo "Detailed command descriptions:"
    echo
    echo "  help | --help | -h"
    echo "      Show this help message and exit."
    echo
    echo "  version | --version | -v"
    echo "      Display the current version of the tool."
    echo
    echo "  branch <branch_code>"
    echo "      Create a new branch with the specified branch code."
    echo "      Example: adbm branch 1234"
    echo
    echo "  configure <variable>=<value>"
    echo "      Configure the specified variable with the given value."
    echo "      Available variables:"
    echo "        project=<project_name>          Sets the project name."
    echo "        organization=<organization_name> Sets the organization name."
    echo "        pat=<personal_access_token>     Sets the Personal Access Token (PAT)."
    echo "      Example: adbm configure project=my_project"
    echo "      You can also provide a configuration file with --file:"
    echo "      Example: adbm configure --file .env"
    echo
    echo "  assignments"
    echo "      List the work items assigned to you."
    echo "      Example: adbm assignments"
    echo
    echo "  upgrade"
    echo "      Upgrade the tool to the latest version."
    echo "      Example: adbm upgrade"
    echo
}

process_config_file() {
    local file="$1"
    while IFS='=' read -r key value; do
        case "$key" in
        PROJECT_NAME | ORG_NAME | PAT)
            # shellcheck disable=SC1090
            source "$SET_SCRIPT" "$key" "$value"
            ;;
        *)
            echo "Unknown configuration key: $key"
            ;;
        esac
    done <"$file"
}

COMMAND=$1
shift

case $COMMAND in
configure)
    while [ "$#" -gt 0 ]; do
        case $1 in
        --file)
            CONFIG_FILE="$2"

            if [ ! -f "$CONFIG_FILE" ]; then
                echo "Configuration file $CONFIG_FILE not found."
                exit 1
            fi

            process_config_file "$CONFIG_FILE"
            ;;
        project=*)
            PROJECT_NAME="${1#*=}"
            # shellcheck disable=SC1090
            source "$SET_SCRIPT" "PROJECT_NAME" "$PROJECT_NAME"
            ;;
        organization=*)
            ORG_NAME="${1#*=}"
            # shellcheck disable=SC1090
            source "$SET_SCRIPT" "ORG_NAME" "$ORG_NAME"
            ;;
        pat=*)
            PAT="${1#*=}"
            # shellcheck disable=SC1090
            source "$SET_SCRIPT" "PAT" "$PAT"
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
        esac
        shift
    done
    ;;
assignments)
    # shellcheck disable=SC1090
    source "$ASSIGNMENTS_SCRIPT"
    ;;
help | --help | -h)
    print_help
    exit 0
    ;;
version | --version | -v)
    # shellcheck disable=SC1090
    source "$VERSION_SCRIPT"
    exit 0
    ;;
upgrade)
    # shellcheck disable=SC1090
    source "$UPGRADE_SCRIPT"
    exit 0
    ;;
branch)
    if [ -z "$1" ]; then
        echo "Branch name is required."
        exit 1
    fi
    # shellcheck disable=SC1090
    source "$BRANCH_SCRIPT" "$1"
    exit 0
    ;;
*)
    echo "Invalid command: adbm $COMMAND"
    echo "Please refer to the usage by executing: adbm help"
    exit 0
    ;;
esac
