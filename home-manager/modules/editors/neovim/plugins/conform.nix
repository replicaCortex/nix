{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      stylua
      black
      ruff
      alejandra
      prettierd
      shfmt
      xmlformat
      yamlfmt
    ];

    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save = ''
          function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            return {
              timeout_ms = 500,
              lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype]
            }
          end
        '';
        formatters_by_ft = {
          lua = ["stylua"];
          python = ["ruff" "black"];
          nix = ["alejandra"];
          c = ["clang-format"];
          sh = ["shfmt"];
          yaml = ["yamlfmt"];
          xml = ["xmlformat"];

          javascript = ["prettierd"];
          html = ["prettierd"];
          css = ["prettierd"];
          # markdown = ["prettierd"];
          dockerfile = ["prettierd"];
        };
        formatters = {
          shfmt = {
            command = "shfmt";
            args = ["-i" "4" "-ci" "-kp"];
          };
        };
      };
    };
  };
}
