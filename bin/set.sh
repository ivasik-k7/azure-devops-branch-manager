#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# Script for adding or updating environment variables in the user's profile
#
# This script updates the user's `.bashrc` file to include or modify environment variables.
# It checks if the variable already exists in the `.bashrc` file. If it does, it updates
# the variable's value. If not, it adds the variable with the specified value.
#
# Steps performed by this script:
# 1. Sets the environment variable in the current shell session.
# 2. Checks if the variable is present in the `.bashrc` file.
# 3. If the variable is not present, appends it to the `.bashrc` file.
# 4. If the variable is present, updates its value in the `.bashrc` file.
# 5. Sources the `.bashrc` file to apply changes immediately.
#
# Usage:
# Run this script with two arguments:
#   1. The name of the environment variable (e.g., MY_VAR).
#   2. The value to assign to the environment variable (e.g., my_value).
#
# Example:
# ./script.sh MY_VAR my_value
#
# Note:
# This script is intended to be used with `.bashrc`. For other shell profiles (e.g., `.bash_profile`,
# `.zshrc`), modify the `profile_file` variable accordingly.

# Function to add or update an environment variable in the user's profile
# Arguments:
#   $1 - The name of the environment variable (e.g., MY_VAR).
#   $2 - The value to assign to the environment variable (e.g., my_value).
# Globals:
#   PROFILE_FILE - Path to the user's profile file (e.g., $HOME/.bashrc).
# Outputs:
#   Updates the environment variable in the profile file and sources it.
add_to_profile() {
    local var_name="$1"
    local var_value="$2"
    local profile_file="$HOME/.bashrc"

    export "$var_name=$var_value"

    if ! grep -q "export $var_name=" "$profile_file"; then
        echo "export $var_name=\"$var_value\"" >>"$profile_file"
    else
        sed -i "s/export $var_name=.*/export $var_name=\"$var_value\"/" "$profile_file"
    fi

    # shellcheck disable=SC1090
    source "$profile_file"
    echo "$var_name has been set to $var_value and added to $profile_file."
}

add_to_profile "$1" "$2"
