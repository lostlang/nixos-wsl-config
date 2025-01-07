{
inputs = {
	nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
	
	home-manager = {
		url = "github:nix-community/home-manager/release-24.11";
		inputs.nixpkgs.follows = "nixpkgs";
	};

	nixvim.url = "github:nix-community/nixvim";

	potatofox = {
		url = "git+https://codeberg.org/awwpotato/PotatoFox";
		flake = false;
	};
};

outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs:
let
	system = "x86_64-linux";
	stateVersion = "24.11";
	user = "lostlang";
	hosts = [
		{ hostname = "wsl"; core = "workstation"; }
		{ hostname = "h56"; core = "workstation"; }
	];

	makeSystem = { hostname, core, stateVersion }: nixpkgs.lib.nixosSystem {
		inherit system;
		specialArgs = {
			inherit inputs hostname stateVersion user;
		};

		modules = [
			./hosts/${hostname}
			./core/default
			./core/${core}
		];
	};
in {
	nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
		configs // {
			"${host.hostname}" = makeSystem {
			inherit (host) hostname core;
			inherit stateVersion;
		};
	}) {} hosts;

	homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
		pkgs = nixpkgs.legacyPackages.${system};
		extraSpecialArgs = {
			inherit inputs stateVersion user;
		};
	
		modules = [
			nixvim.homeManagerModules.nixvim
			./home
		];
	};
};
}

