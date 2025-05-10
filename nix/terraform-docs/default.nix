{ writeScriptBin, terraform-docs }:

writeScriptBin "terraform-docs" ''
  #!/usr/bin/env bash
  set -eux

  resolve_dir() {
    if [ -d "$1" ]; then
      echo "$1"
    else
      dirname "$1"
    fi
  }
  for arg in "$@"; do
    resolve_dir "$arg"
  done | sort | uniq | while read dir; do
    ${terraform-docs}/bin/terraform-docs markdown --output-file README.md "$dir"
  done
''
