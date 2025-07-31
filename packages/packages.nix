{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      krita

      retroarch
      libretro.desmume

      git
      git-lfs

      nh
      wl-clipboard
      xdragon
      gammastep
      cliphist
      bat
      jq
      btop
      sqlite

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
      wf-recorder

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
      libreoffice

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
