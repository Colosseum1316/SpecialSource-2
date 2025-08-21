#!/bin/bash

PS1="$"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd ${SCRIPT_DIR}
./_specialsource_2_decompile.sh "${SCRIPT_DIR}"
