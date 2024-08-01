#!/usr/bin/env bash
# -*- coding: utf-8 -*-

TAG_VERSION=$1
OUTPUT_FILE=${2:-"meta.yaml"}
RELEASE_DATE=${3:-$(date +%Y-%m-%d)}

TOOL_NAME="Azure Devops Branch Manager (ADBM)"
DESCRIPTION="Azure DevOps Branch Manager (ADBM) is a command-line tool designed to streamline branch management tasks within Azure DevOps. It allows users to create, delete, and manage branches efficiently, automate workflows, and integrate seamlessly with existing DevOps pipelines and processes."
VERSION="$TAG_VERSION"
AUTHOR="Ivan Kovtun"
LICENSE="MIT"
SUPPORT_EMAIL="jeanlacroix@ukr.net"

if [[ "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    VERSION="${VERSION#v}"
fi

cat <<EOL >"$OUTPUT_FILE"
tool:
  name: $TOOL_NAME
  description: $DESCRIPTION
  version: "$VERSION"
  release: "$RELEASE_DATE"
  author: $AUTHOR
  license: $LICENSE
  support: $SUPPORT_EMAIL
EOL

echo "Metadata file '$OUTPUT_FILE' has been created/updated."
