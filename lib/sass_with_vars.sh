#!/bin/sh
set -eu

if [ $# -lt 3 ]; then
  echo "Usage: $0 SASS_PATH INPUT OUTPUT [SASS_INCLUDE...]" >&2
  exit 1
fi

sass_path="$1"
in="$2"
out="$3"
shift
shift
shift

in_dir="$(dirname -- "$in")"
in="$(readlink -f -- "$in")"
out="$(readlink -f -- "$out")"

cd "$in_dir"
{ echo "$@" ' '; cat "$in"; } | exec "$sass_path" --stdin -- "$out"
