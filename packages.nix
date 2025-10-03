{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      nh
      wl-clipboard
      gammastep
      xdragon
      jq
      btop

      fzf
      chafa
      cliphist

      gnutar
      gzip
      unzip
      unrar
      p7zip

      ffmpeg-full
      vimiv-qt
      mpv
      zathura
      (callPackage ./zen/zen.nix { })

      file
      git

      telegram-desktop

      (pkgs.python312.withPackages (ps: [
        ps.mdformat
        ps.mdformat-frontmatter
      ]))

      zk
      neovim

      grim
      slurp

      qbittorrent-enhanced
      wineWowPackages.wayland

      # --- lsp ---
      inotify-tools

      yaml-language-server

      prettier

      stylua
      lua-language-server

      bash-language-server
      shfmt

      mbake

      nil

      fixjson

      sqls
      sleek

      taplo
    ];
  };
}
