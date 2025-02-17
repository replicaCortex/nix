{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    # name = "Catppuccin-Mocha-Blue-Cursors";
    # package = pkgs.catppuccin-cursors.mochaBlue;
    size = 24;
  };
  catppuccin = {
    accent = "blue";
    cursors.enable = true;
    flavor = "mocha";
    # flavor = "latte";

    lazygit.enable = true;
    btop.enable = true;
    fzf.enable = true;
    mpv.enable = true;
    # zsh-syntax-highlighting.enable = true;
    obs.enable = true;
    # gtk.enable = true;
  };
}
