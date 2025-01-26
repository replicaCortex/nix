{
	imports = [
	./modules/bundle.nix
	];

  home = {
    username = "replica";
    homeDirectory = "/home/replica";
    stateVersion = "24.11";
  };
}



	#programs.bash = {
		#enable = true;
		#bashrcExtra = "setxkbmap -option grp:caps_toggle";
		#shellAliases = {
		#home = "cd ~/.config/home-manager/modules";
		#hms = "home-manager switch";
		#".." = "cd ..";
		#nixConf = "sudo nvim /etc/nixos/configuration.nix";
		#};
	#};


