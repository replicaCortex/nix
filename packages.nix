{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      git

      nh
      wl-clipboard
      gammastep
      xdragon
      cliphist
      jq
      btop

      fzf
      chafa

      gnutar
      gzip
      unzip
      unrar
      p7zip

      ffmpeg-full
      vimiv-qt
      (callPackage ./zen/zen.nix {})
      mpv

      file

      telegram-desktop

      (pkgs.python312.withPackages
        (ps: [
          ps.mdformat
          ps.mdformat-frontmatter
        ]))
      gcc

      zk
      neovim

      grim
      slurp

      zathura
      qbittorrent-enhanced

      # word
      quarto
      pandoc
      texlive.combined.scheme-full

      # lsp
      basedpyright
      # ty
      black

      yaml-language-server

      prettier

      alejandra

      stylua
      lua-language-server

      bash-language-server
      shfmt

      mbake

      clang-tools
      gdb

      tree-sitter

      texlab
    ];
  };
}
