#!/usr/bin/env bash
# -*- coding: utf-8 -*-

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

BRANCH_SCRIPT="$SCRIPT_DIR/branch.sh"
SET_SCRIPT="$SCRIPT_DIR/set.sh"
ASSIGNMENTS_SCRIPT="$SCRIPT_DIR/assignments.sh"
VERSION_SCRIPT="$SCRIPT_DIR/version.sh"

print_help() {
    echo
    echo "Usage:"
    echo
    echo " adbm help | --help | -h"
    echo "    Displays this help message."
    echo
    echo " adbm version | --version | -v"
    echo "    Displays the version of the tool."
    echo
    echo " adbm branch <branch_code>"
    echo "    Creates a new branch with the specified branch code."
    echo "    Example: adbm branch 1234"
    echo
    echo " adbm configure <variable>=<value>"
    echo "    Configures the specified variable with the given value."
    echo "    Available variables:"
    echo "      project=<project_name>         Sets the project name."
    echo "      organization=<organization_name> Sets the organization name."
    echo "      pat=<personal_access_token>    Sets the Personal Access Token (PAT)."
    echo "    Example: adbm configure project=my_project"
    echo
    echo " adbm assignments"
    echo "    Lists the work items assigned to you."
    echo

}

COMMAND=$1
shift

case $COMMAND in
configure)
    while [ "$#" -gt 0 ]; do
        case $1 in
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
    echo "Invalid command: $0 $COMMAND"
    echo "Please refer to the usage by executing: $0 help"
    exit 0
    ;;
esac
