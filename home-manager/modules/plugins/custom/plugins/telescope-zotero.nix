{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "zotero";
        src = ../../../extra_plugins/lua;

        buildInputs = [
          pkgs.luaPackages.sqlite
        ];
        postInstall = ''
          mkdir -p $out/lua
          cp -rv $src/* $out/lua/  # Вместо $src/lua/*

        '';
      })
    ];
    extraConfigLuaPre = ''
      local telescope = require 'telescope'
       -- other telescope setup
       -- ...
       telescope.load_extension 'zotero'

    '';
  };
}
