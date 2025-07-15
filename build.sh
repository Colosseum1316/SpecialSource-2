#!/bin/bash

set -e
set -o pipefail

PS1="$"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

alias git="git -c commit.gpgsign=false"

git submodule update --init
cd Panda
git submodule update --init
cd base/Paper
git submodule update --init -- BuildData
cd ${SCRIPT_DIR}

./_specialsource_2_decompile.sh "${SCRIPT_DIR}"
