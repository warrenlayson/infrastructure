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
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
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
