{
  description = "A Nix flake for Cloak, a censorship circumvention tool to evade detection by authoritarian state adversaries";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        version = "2.8.0";
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages.cloak = pkgs.buildGoModule {
          pname = "cloak";
          version = version;
          src = pkgs.fetchFromGitHub {
            owner = "cbeuw";
            repo = "Cloak";
            rev = "v${version}";
            sha256 = "sha256-5UmJSeqRj71lHHiGcJO+RdeVg7GWDETsFrqnvzDvkpg=";
          };
          vendorHash = "sha256-oc208yCRt0Dk87b/KVjiJxWKbN9IrYIOr05RTEDMhPU=";
          ldflags = [ "-X main.version=${version}" ];
          subPackages = [ "cmd/ck-client" "cmd/ck-server" ];
          patches = [ ./go121.patch ];
        };

        packages.default = self.packages.${system}.cloak;
      });
}
