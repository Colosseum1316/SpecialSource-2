#!/bin/bash

PS1="$"
BASE_DIR="$1"
WORKING_DIR="$1"

wget_dir="${WORKING_DIR}/tmp"
decompilation_dir="${wget_dir}/dec"
mkdir -p "${decompilation_dir}" || true
output_dir="${WORKING_DIR}/ss2/src"

uname -a

function ss2_script_download_file {
  local target_filename="$1"
  local target_url="$2"
  local target_checksum="$3"
  local checksum="$(echo -En "${target_checksum}  ${wget_dir}/${target_filename}")"

  if [[ -f "${wget_dir}/${target_filename}" ]]; then
    set -x
    if ! (echo -En "${checksum}" | shasum -a 256 -c); then
      rm -rf "${wget_dir}/${target_filename}"
    else
      set +x
      return
    fi
    set +x
  fi
  if [[ ! -f "${wget_dir}/${target_filename}" ]]; then
    echo "Downloading ${target_filename} from ${target_url}"
    if ! wget --progress=dot:giga -O "${wget_dir}/${target_filename}" "${target_url}"; then
      echo "Failed to download ${target_filename}!!!"
      exit 1
    fi

    set -x
    if ! (echo -En "${checksum}" | shasum -a 256 -c); then
      set +x
      echo "Corrupted file: ${target_filename}"
      exit 1
    fi
    set +x
  fi
}

ss2_script_download_file "fernflower.jar" "https://hub.spigotmc.org/stash/projects/SPIGOT/repos/builddata/raw/bin/fernflower.jar?at=838b40587fa7a68a130b75252959bc8a3481d94f" "29359771a5722c7f45ce723d567a86ae18cba7a72ee6ca7bd785235004aa1610"
ss2_script_download_file "SpecialSource-2.jar" "https://github.com/hpfxd/PandaSpigot/raw/984537bbd85e6a531efeb21c0626d0c82da46163/bin/SpecialSource-2.jar" "fc740dbb230c659df710084d0822b4a20d910bf707d6e66f935351bedf4e8bba"

rm -rf "${output_dir}"
rm -rf "${output_dir}/../target"
mkdir -p "${output_dir}/net/md_5/ss"

cd "${decompilation_dir}"
cp "${wget_dir}/SpecialSource-2.jar" .
jar xf SpecialSource-2.jar
rm -rf SpecialSource-2.jar
rm -rf com
rm -rf joptsimple
rm -rf META-INF
rm -rf org
java -version
set -x
java -jar "${wget_dir}/fernflower.jar" -den=1 -dgs=1 -hdc=0 -rbr=0 -asc=1 -udv=0 "net/md_5/ss" "${output_dir}/net/md_5/ss"
set +x
rm -rf ${decompilation_dir}

cd "$WORKING_DIR"

./_specialsource_2_patch.sh "$WORKING_DIR"
