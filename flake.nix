{
  description = "yusof's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";

    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, claude-code, nur, ... }: {
    nixosConfigurations.computer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/computer

        {
          nixpkgs.overlays = [
            claude-code.overlays.default
            nur.overlays.default
          ];
        }

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.user = import ./modules/home-manager;
          };
        }
      ];
    };
  };
}
