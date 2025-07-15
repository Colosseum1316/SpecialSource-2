#!/bin/bash

set -e

PS1="$"
BASE_DIR="$1"
WORKING_DIR="$1"

alias git="git -c commit.gpgsign=false"

decompilation_dir="${WORKING_DIR}/ss2/src"

rm -rf "${decompilation_dir}"
mkdir -p "${decompilation_dir}"
java -version
java -jar "${WORKING_DIR}/Panda/base/Paper/BuildData/bin/fernflower.jar" -den=1 -dgs=1 -hdc=0 -rbr=0 -asc=1 -udv=0 "${WORKING_DIR}/Panda/bin/SpecialSource-2.jar" "${decompilation_dir}"
cd "${decompilation_dir}"
jar xvf SpecialSource-2.jar
rm -rf SpecialSource-2.jar
rm -rf com
rm -rf joptsimple
rm -rf META-INF
rm -rf org

cd "$WORKING_DIR"

./_specialsource_2_patch.sh "$WORKING_DIR"
