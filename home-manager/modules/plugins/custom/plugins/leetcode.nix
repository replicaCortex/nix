{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      leetcode-nvim
    ];

    extraConfigLuaPre = ''

      require('leetcode').setup

      {
        lang = 'python',

        image_support = true,
      }

    '';
  };
}
