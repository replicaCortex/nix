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

    extraConfigLuaPre = " 
    vim.api.nvim_create_user_command('ToggleDiagnostics', function()
      local loclist_exists = vim.fn.loclist(0) ~= ''
      if loclist_exists then
        vim.cmd('lclose')  -- Закрыть, если уже открыт
      else
        vim.diagnostic.setloclist()  -- Обновить и открыть, если закрыт
        vim.cmd('lopen')
      end
    end, {})
    ";

    keymaps = [
      {
        mode = "n";
        key = "]d";
        action = "<Cmd>lua vim.diagnostic.goto_next()<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }

      {
        mode = "n";
        key = "[d";
        action = "<Cmd>lua vim.diagnostic.goto_prev()<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];
  };
}
