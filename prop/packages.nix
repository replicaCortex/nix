{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      krita
      xp-pen-deco-01-v2-driver

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

      fzf
      ripgrep

      gnutar
      gzip
      unzip
      p7zip

      ffmpeg-full
      vimiv-qt
      (callPackage ../zen/zen.nix {})

      file

      telegram-desktop

      python312
      gcc
      gnumake

      zk
      neovim

      mpv
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

      tree-sitter

      texlab

      # linter

      codespell
      luajitPackages.luacheck
      sqls
      sql-formatter
      pylint
    ];
  };
}
