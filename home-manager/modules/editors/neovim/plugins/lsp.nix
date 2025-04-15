{self, ...}: {
  programs.nixvim = {
    extraConfigLuaPre = ''
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded"
        }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = "rounded"
        }
      )
    '';
    plugins.cmp-nvim-lsp = {
      enable = true;
    };

    plugins.fidget = {
      enable = true;
    };

    # autoGroups = {
    #   "kickstart-lsp-attach" = {
    #     clear = true;
    #   };
    # };

    plugins = {
      lsp-lines.enable = true;
      # lsp-signature.enable = true;
    };

    autoCmd = [
      {
        event = ["VimEnter"];
        callback.__raw = ''
          function()
            require("lsp_lines").toggle()
            vim.lsp.inlay_hint.enable(true)
          end
        '';
      }
    ];

    plugins.lsp = {
      enable = true;

      # NOTE: not work, use "lua vim.lsp.inlay_hint.enable(true)"
      inlayHints = true;

      servers = {
        # https://github.com/MattSturgeon/nix-config/blob/main/nvim/config/lsp.nix
        nixd = {
          # Nix LS
          enable = true;
          settings = let
            flake = ''(builtins.getFlake "${self}")'';
            system = ''''${builtins.currentSystem}'';
          in {
            nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
            options = rec {
              # flake-parts.expr = "${flake}.debug.options";
              nixos.expr = "${flake}.nixosConfigurations.desktop.options";
              home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
              nixvim.expr = "${flake}.packages.${system}.nvim.options";
            };
            diagnostic = {
              # Suppress noisy warnings
              suppress = [
                "sema-escaping-with"
                "var-bind-to-this"
              ];
            };
          };
        };

        # pyright.enable = true;
        # TODO: сделать прочныный фон для виртуального текста
        basedpyright.enable = true;

        texlab.enable = true;

        clangd.enable = true;

        # ltex.enable = true;

        dockerls.enable = true;

        bashls.enable = true;

        lua_ls = {
          enable = true;
          settings = {
            completion = {
              callSnippet = "Replace";
            };
          };
        };
      };

      keymaps = {
        extra = [
          # {
          #   mode = "n";
          #   key = "<leader>fd";
          #   action.__raw = "require('telescope.builtin').lsp_definitions";
          # }
          # {
          #   mode = "n";
          #   key = "<leader>fr";
          #   action.__raw = "require('telescope.builtin').lsp_references";
          # }
          # {
          #   mode = "n";
          #   key = "<leader>ftd";
          #   action.__raw = "require('telescope.builtin').lsp_type_definitions";
          # }

          {
            mode = "n";
            key = "K";
            action.__raw = "function() vim.lsp.buf.hover() end";
            options = {
              silent = true;
              noremap = true;
            };
          }

          {
            mode = "i";
            key = "<A-k>";
            action = "<Cmd>lua vim.lsp.buf.signature_help()<CR>";
            options = {
              silent = true;
              noremap = true;
            };
          }
        ];

        lspBuf = {
          "<leader>rn" = {
            action = "rename";
          };
        };
      };

      onAttach = ''
         -- to define small helper and utility functions so you don't have to repeat yourself.
         --
         -- In this case, we create a function that lets us more easily define mappings specific
         -- for LSP related items. It sets the mode, buffer and description for us each time.
         -- local map = function(keys, func, desc)
         --   vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
         -- end

         -- The following two autocommands are used to highlight references of the
         -- word under the cursor when your cursor rests there for a little while.
         --    See `:help CursorHold` for information about when this is executed
         --
         -- When you move your cursor, the highlights will be cleared (the second autocommand).
         -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
         --   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
         --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
         --     buffer = bufnr,
         --     group = highlight_augroup,
         --     callback = vim.lsp.buf.document_highlight,
         --   })
         --
         --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
         --     buffer = bufnr,
         --     group = highlight_augroup,
         --     callback = vim.lsp.buf.clear_references,
         --   })
         --
         --   vim.api.nvim_create_autocmd('LspDetach', {
         --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
         --     callback = function(event2)
         --       vim.lsp.buf.clear_references()
         --       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
         --     end,
         --   })
         -- end
         --
         -- -- The following autocommand is used to enable inlay hints in your
         -- -- code, if the language server you are using supports them
         -- --
         -- -- This may be unwanted, since they displace some of your code
          --  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          --    map('<leader>th', function()
          --      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          --    end, '[T]oggle Inlay [H]ints')
          --  end

         -- require("lspconfig")["pyright"].setup({
         --     on_attach = on_attach,
         --     capabilities = capabilities,
         --     settings = {
         --         python = {
         --             analysis = {
         --                 diagnosticSeverityOverrides = {
         --                     reportUnusedExpression = "none",
         --                 },
         --             },
         --         },
         --     },
         -- })

        require("lspconfig")["basedpyright"].setup({
            -- on_attach = on_attach,
            -- capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        inlayHints = true,
                        diagnosticSeverityOverrides = {
                            reportUnusedExpression = "none",
                        },
                    },
                },
            },
        })

      '';
    };
  };
}
