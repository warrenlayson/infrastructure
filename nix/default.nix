{ pkgs }:

rec {
  terraform-validate = import ./terraform-validate {
    inherit (pkgs) writeScriptBin terraform;
  };
  terraform-docs = import ./terraform-docs {
    inherit (pkgs) writeScriptBin terraform-docs;
  };
}
