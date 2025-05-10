{ writeScriptBin, terraform }:

writeScriptBin "terraform-validate" ''
  #!/usr/bin/env bash
  set -eux
  for arg in "$@"; do
    dirname "$arg"
  done | sort | uniq | while read dir; do
    ${terraform} -chdir="$dir" validate
  done
''
