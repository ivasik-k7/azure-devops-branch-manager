#!/usr/bin/env bash
# -*- coding: utf-8 -*-

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
