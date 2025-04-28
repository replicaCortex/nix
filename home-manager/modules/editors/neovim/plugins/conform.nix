{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      stylua
      black
      ruff
      alejandra
      prettierd
      shfmt
      rubocop
      xmlformat
      yamlfmt
      nginx-config-formatter
    ];

    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save = ''
          function(bufnr)
            -- Disable "format_on_save lsp_fallback" for lanuages that don't
            -- have a well standardized coding style. You can add additional
            -- lanuages here or re-enable it for the disabled ones.
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
          ruby = ["rubocop"];
          yaml = ["yamlfmt"];
          xml = ["xmlformat"];
          nginx = ["nginxfmt"];

          javascript = ["prettierd"];
          # html = ["prettierd"];
          # css = ["prettierd"];
          markdown = ["prettierd"];
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
