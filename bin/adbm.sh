#!/usr/bin/env bash
# -*- coding: utf-8 -*-

BRANCH_SCRIPT="${PWD}/bin/branch.sh"
SET_SCRIPT="${PWD}/bin/set.sh"

print_help() {
    echo "Usage:"
    echo
    echo " adbm help"
    echo "      Help me, please!"
    echo
    echo " adbm branch <branch_code>"
    echo "    Creates a branch related to the given branch code."
    echo
    echo " adbm configure <variable>=<value>"
    echo "    Available variables:"
    echo "      project=<project_name>"
    echo "      organization=<organization_name>"
    echo "      pat=<personal_access_token>"
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
help)
    print_help
    exit 0
    ;;
branch)
    # shellcheck disable=SC1090
    source "$BRANCH_SCRIPT" "$1"
    exit 0
    ;;
*)
    echo "Provide a valid command"
    exit 1
    ;;
esac
