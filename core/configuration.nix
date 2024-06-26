{ ... }: {
imports = [
	./modules/bundle.nix
];

networking.hostName = "lostwsl";

wsl.enable = true;
wsl.defaultUser = "nixos";

system.stateVersion = "23.11";

nix.settings.experimental-features = [
	"flakes"
	"nix-command"
];
}
