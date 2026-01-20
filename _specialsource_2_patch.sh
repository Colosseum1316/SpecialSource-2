#!/bin/bash

set -e

PS1="$"
BASE_DIR="$1"
WORKING_DIR="$1"

decompilation_dir="${WORKING_DIR}/ss2/src"

if [[ ! -d "${decompilation_dir}" ]]; then
  echo "Run decompilation first!"
  exit 1
fi

function patchdirs {
  local patch_work_dir="$1"
  local patches_dir="$2"
  for _patch in $(ls $patches_dir)
  do
    patch -d "$patch_work_dir" < "${_patch}"
  done
}

WORKING_DIR="${decompilation_dir}/net/md_5/ss"
patchdirs "${WORKING_DIR}/remapper" "${BASE_DIR}/patches/remapper/*.patch"
patchdirs "${WORKING_DIR}/repo" "${BASE_DIR}/patches/repo/*.patch"
patchdirs "${WORKING_DIR}/util" "${BASE_DIR}/patches/util/*.patch"
patchdirs "${WORKING_DIR}/" "${BASE_DIR}/patches/*.patch"

WORKING_DIR="$1"
WORKING_DIR="${WORKING_DIR}/ss2"
cd "$WORKING_DIR"
mvn -B -V -e -ntp clean package
