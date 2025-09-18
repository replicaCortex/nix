{pkgs, ...}: {
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
      (callPackage ./zen/zen.nix {})

      file
      git

      translatepy

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

      qbittorrent-enhanced

      # --- document ---
      quarto
      pandoc
      texlive.combined.scheme-full

      # --- lsp ---
      inotify-tools

      basedpyright
      # ty
      black
      # ruff

      yaml-language-server

      prettier

      alejandra

      stylua
      lua-language-server

      bash-language-server
      shfmt

      mbake

      clang-tools
      neocmakelsp
      gdb

      tree-sitter

      texlab

      fixjson
    ];
  };
}
