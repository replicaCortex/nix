{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "citation.vim";
        src = pkgs.fetchFromGitHub {
          owner = "rafaqz";
          repo = "citation.vim";
          rev = "51ded63532956403c32dce8e854baf36ea907254";
          hash = "sha256-sT63XVczy0iU4v2o4UtHPgDQ3cjtTZtaUVl1ei+zyfI=";
        };
      })

      (pkgs.vimUtils.buildVimPlugin {
        name = "unite.vim";
        src = pkgs.fetchFromGitHub {
          owner = "Shougo";
          repo = "unite.vim";
          rev = "0ccb3f7988d61a9a86525374be97360bd20db6bc";
          hash = "sha256-nKbDaZU6zRGr11OelunXgwvvYQD4og2sk3dVB1YxoX0=";
        };
      })
    ];
  };
}
