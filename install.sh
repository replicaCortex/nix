rm ~/.config/zathura
rm ~/.config/dunst
rm ~/.config/vimiv
rm ~/.config/foot
rm ~/.config/waybar
rm ~/.config/nvim
rm ~/.config/vimb
rm ~/.config/niri
rm ~/.bashrc
rm ~/.inputrc

ln -s ~/nix/userChrome.css ~/.zen/**Default*/chrome/
ln -s ~/nix/zathura ~/.config/
ln -s ~/nix/dunst ~/.config/
ln -s ~/nix/vimiv ~/.config/
ln -s ~/nix/foot ~/.config/
ln -s ~/nix/nvim ~/.config/
ln -s ~/nix/vimb ~/.config/
ln -s ~/nix/niri ~/.config/
ln -s ~/nix/waybar ~/.config/
ln -s ~/nix/bash/.bashrc ~/
ln -s ~/nix/bash/.zshrc ~/
ln -s ~/nix/.inputrc ~/
