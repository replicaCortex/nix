{pkgs, ...}: {
  programs.nixvim = {
    plugins.cmp-nvim-lsp = {
      enable = true;
    };

    plugins.fidget = {
      enable = true;
    };

    autoGroups = {
      "kickstart-lsp-attach" = {
        clear = true;
      };
    };

    plugins.lsp = {
      enable = true;

      servers = {
        # TODO: разобраться как это работает
        nixd = {
          enable = true;
          # cmd = ["nixd"];
          # rootDir = builtins.getEnv "HOME";
        };

        # nil_ls = {
        #   enable = true;
        # };

        pyright = {
          # package = null;
          enable = true;
        };

        texlab = {
          enable = true;
        };

        ltex = {
          enable = true;
        };

        # marksman = {
        #   enable = true;
        # };

        # csharp_ls = {
        #   enable = true;
        #   package = null;
        # };

        clangd = {
          enable = true;
          package = null;
        };

        lua_ls = {
          enable = true;

          # cmd = {
          #};
          # filetypes = {
          #};
          settings = {
            completion = {
              callSnippet = "Replace";
            };
            #diagnostics = {
            #  disable = [
            #    "missing-fields"
            #  ];
            #};
          };
        };
      };

      keymaps = {
        diagnostic = {
          "<leader>l[" = "goto_prev";
          "<leader>l]" = "goto_next";
          "<leader>lH" = "open_float";
        };

        # diagnostic = {
        #   "<leader>q" = {
        #     #mode = "n";
        #     action = "setloclist";
        #     desc = "Open diagnostic [Q]uickfix list";
        #   };
        # };

        extra = [
          {
            mode = "n";
            key = "<leader>fd";
            action.__raw = "require('telescope.builtin').lsp_definitions";
          }
          {
            mode = "n";
            key = "<leader>fr";
            action.__raw = "require('telescope.builtin').lsp_references";
          }
          # {
          #   mode = "n";
          #   key = "gI";
          #   action.__raw = "require('telescope.builtin').lsp_implementations";
          # }
          {
            mode = "n";
            key = "<leader>ftd";
            action.__raw = "require('telescope.builtin').lsp_type_definitions";
          }

          {
            mode = "n";
            key = "K";
            action.__raw = "function() vim.lsp.buf.hover() end";
            settings = {
              silent = true;
              noremap = true;
            };
          }

          {
            mode = "i";
            key = "<A-k>";
            action = "<Cmd>lua vim.lsp.buf.signature_help()<CR>";
            settings = {
              silent = true;
              noremap = true;
            };
          }
          # {
          #   mode = "n";
          #   key = "<leader>fds";
          #   action.__raw = "require('telescope.builtin').lsp_document_symbols";
          # }
          # {
          #   mode = "n";
          #   key = "<leader>fs";
          #   action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
          # }
        ];

        # lspBuf = {
        #   # Rename the variable under your cursor.
        #   #  Most Language Servers support renaming across files, etc.
        #   "<leader>rn" = {
        #     action = "rename";
        #     desc = "LSP: [R]e[n]ame";
        #   };
        #   # Execute a code action, usually your cursor needs to be on top of an error
        #   # or a suggestion from your LSP for this to activate.
        #   "<leader>ca" = {
        #     #mode = "n";
        #     action = "code_action";
        #     desc = "LSP: [C]ode [A]ction";
        #   };
        #   "gD" = {
        #     action = "declaration";
        #     desc = "LSP: [G]oto [D]eclaration";
        #   };
        # };
      };

      # LSP servers and clients are able to communicate to each other what features they support.
      #  By default, Neovim doesn't support everything that is in the LSP specification.
      #  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      #  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      #'';

      # This function gets run when an LSP attaches to a particular buffer.
      #   That is to say, every time a new file is opened that is associated with
      #   an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      #   function will be executred to configure the current buffer
      onAttach = ''
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- The following two autocommands are used to highlight references of the
        -- word under the cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end

        require("lspconfig")["pyright"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
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
