{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      aseprite

      git

      nh
      wl-clipboard
      xdragon
      gammastep
      cliphist
      bat
      jq
      btop

      fzf

      gnutar
      gzip
      unzip
      unrar
      p7zip

      ffmpeg-full
      vimiv-qt
      (callPackage ../zen/zen.nix {})
      mpv
      yt-dlp

      file

      telegram-desktop

      python312
      gcc

      zk
      neovim

      grim
      slurp

      zathura
      qbittorrent-enhanced
      texlive.combined.scheme-full

      # lsp
      basedpyright
      # ty
      black

      prettier

      alejandra

      stylua
      lua-language-server

      bash-language-server
      shfmt

      clang-tools
      gdb

      tree-sitter

      texlab
    ];
  };
}
