rm ~/.config/zathura
rm ~/.config/sway
rm ~/.config/dunst
rm ~/.config/vimiv
rm ~/.config/foot
rm ~/.config/waybar
rm ~/.config/nvim
rm ~/.bashrc
rm ~/.inputrc

ln -s ~/nix/**/zathura ~/.config/
ln -s ~/nix/**/sway ~/.config/
ln -s ~/nix/**/dunst ~/.config/
ln -s ~/nix/**/vimiv ~/.config/
ln -s ~/nix/**/foot ~/.config/
ln -s ~/nix/**/nvim ~/.config/
ln -s ~/nix/**/waybar ~/.config/
ln -s ~/nix/**/bash/.bashrc ~/
ln -s ~/nix/.inputrc ~/
