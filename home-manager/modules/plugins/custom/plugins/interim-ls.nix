{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "neorg-interim-ls";
        src = pkgs.fetchFromGitHub {
          owner = "benlubas";
          repo = "neorg-interim-ls";
          # rev = "1a7d6b1dfb2f176715ccc9e838be32d044f8a734";
          tag = "v2.1.0";
          sha256 = "Cveb65H3qVN/uC/nVdBwshXGetcWmY1E3glcQ7kN+hw=";
        };

        buildInputs = [
          pkgs.vimPlugins.neorg
        ];
      })
    ];
  };
}
