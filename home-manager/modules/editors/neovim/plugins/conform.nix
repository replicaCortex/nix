{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      # Used to format Lua code
      stylua
      black
      ruff
      alejandra
      prettierd
      shfmt
    ];

    # Autoformat
    # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
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
          # latex = ["latexindent"];
          markdown = ["prettierd"];
          c = ["clang-format"];
          sh = ["shfmt"];
          # javascript = [ [ "prettierd" "prettier" ] ];
        };
        formatters = {
          shfmt = {
            command = "shfmt";
            args = ["-i" "4" "-ci" "-kp"];
          };
          # ruff = {
          #   command = "ruff";
          #   args = ["line-length = 80" "indent-width = 4" ''quote-style = "double"'' ''indent-style = "space"'' ''skip-magic-trailing-comma = false'' ''line-ending = "lf"''];
          # };
        };
      };
    };
  };
}
