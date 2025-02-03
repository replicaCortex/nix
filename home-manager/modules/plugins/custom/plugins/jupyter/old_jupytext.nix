{pkgs, ...}: {
  programs.nixvim = {
    plugins.jupytext = {
      enable = true;
      settings = {
        custom_language_formatting = {
          python = {
            extension = "md";
            force_ft = "markdown";
            style = "markdown";
          };
        };
        force_ft = null;
        output_extension = "auto";
        style = "light";
      };
    };
    extraPackages = [(pkgs.python3.withPackages (p: [p.jupytext]))];
  };

  # home.packages = with pkgs; [
  #   jupyter
  #   # ipython
  # ];
}
