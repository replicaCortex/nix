{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      krita
      desmume
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
      sqlite

      fzf
      ripgrep

      gnutar
      gzip
      unzip
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

      tree-sitter

      texlab

      sqls
      sql-formatter

      # linter

      codespell
      luajitPackages.luacheck
      pylint
    ];
  };
}
