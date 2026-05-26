{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./nixos/configuration.nix
        ({ lib, ... }: {
          users.users.vps.openssh.authorizedKeys.keys =
            let key = builtins.getEnv "LOCAL_VPS_SSH_KEY";
            in lib.optional (key != "") key;
        })
      ];
    };
  in {
    nixosConfigurations.local-vps = nixos;

    packages.${system}.default = import "${nixpkgs}/nixos/lib/make-disk-image.nix" {
      inherit pkgs;
      inherit (nixpkgs) lib;
      config = nixos.config;
      diskSize = "auto";
      additionalSpace = "1024M";
      format = "qcow2";
      partitionTableType = "legacy+gpt";
    };
  };
}
