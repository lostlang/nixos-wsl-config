{ pkgs, ... }: {
nixpkgs.config = {
	allowUnfree = true;
};

environment.systemPackages = with pkgs; [
	openssh
	git
	home-manager
	zsh
	wget
	zip
	unzip

	zig
	gnumake
	cmake

	ollama
];
}
