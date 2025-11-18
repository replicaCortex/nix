rm -rf ~/.config/zathura
rm -rf ~/.config/dunst
rm -rf ~/.config/vimiv
rm -rf ~/.config/foot
rm -rf ~/.config/mpv
rm -rf ~/.config/waybar
rm -rf ~/.config/nvim
rm -rf ~/.config/fish
rm -rf ~/.config/niri
rm -rf ~/.inputrc

ln -s ~/nix/userChrome.css ~/.zen/**Default*/chrome/
ln -s ~/nix/zathura ~/.config/
ln -s ~/nix/dunst ~/.config/
ln -s ~/nix/vimiv ~/.config/
ln -s ~/nix/foot ~/.config/
ln -s ~/nix/nvim ~/.config/
ln -s ~/nix/mpv ~/.config/
ln -s ~/nix/fish ~/.config/
ln -s ~/nix/niri ~/.config/
ln -s ~/nix/waybar ~/.config/
ln -s ~/nix/.inputrc ~/
