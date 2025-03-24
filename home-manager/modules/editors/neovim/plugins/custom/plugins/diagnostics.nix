{
  # https://github.com/nix-community/nixvim/issues/1578

  programs.nixvim = {
    diagnostics = {
      signs = {
        # text = {
        #   "__rawKey__vim.diagnostic.severity.ERROR" = "";
        #   "__rawKey__vim.diagnostic.severity.WARN" = "";
        #   "__rawKey__vim.diagnostic.severity.HINT" = "󰛩";
        #   "__rawKey__vim.diagnostic.severity.INFO" = "";
        # };
        texthl = {
          "__rawKey__vim.diagnostic.severity.ERROR" = "DiagnosticError";
          "__rawKey__vim.diagnostic.severity.WARN" = "DiagnosticWarn";
          "__rawKey__vim.diagnostic.severity.HINT" = "DiagnosticHint";
          "__rawKey__vim.diagnostic.severity.INFO" = "DiagnosticInfo";
        };
      };

      update_in_insert = true;
      severity_sort = true;

      float = {
        border = "rounded";
      };
    };

    # extraConfigLuaPre = ''
    #   vim.diagnostic.config({
    #     virtual_text = {
    #       prefix = ' ', -- Could be '●', '▎', 'x'
    #     }
    #   })
    # '';
  };
}
