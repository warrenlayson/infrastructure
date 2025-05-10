{
  description = "Infrastructure";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };
  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import (nixpkgs) {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        custom-tools = import ./nix { inherit pkgs; };

        terraform = "${pkgs.terraform}/bin/terraform";
        terraform-validate = custom-tools.terraform-validate;
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
            terraform-format = {
              enable = true;
              package = pkgs.terraform;
              entry = "${terraform} fmt -recursive";
            };
            terraform-validate = {
              enable = true;
              package = terraform-validate;
              entry = "${terraform-validate}/bin/terraform-validate";
            };
            tflint.enable = true;
          };
        };
      in
      {
        checks = {
          pre-commit = pre-commit-check;
        };
        devShell = pkgs.mkShell {
          inherit (pre-commit-check) shellHook;
          buildInputs = [
            pkgs.terraform
          ] ++ pre-commit-check.enabledPackages;

        };
      }
    );
}
