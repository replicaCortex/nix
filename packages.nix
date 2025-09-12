{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      git

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
      (callPackage ./zen/zen.nix {})

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

      # document
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
