{ pkgs }:

rec {
  terraform-validate = import ./terraform-validate {
    inherit (pkgs) writeScriptBin terraform;
  };
}
