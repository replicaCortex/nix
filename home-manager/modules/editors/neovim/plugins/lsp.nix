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

    plugins.lsp-lines.enable = true;

    autoCmd = [
      {
        event = ["VimEnter"];
        callback.__raw = ''
          function()
            require("lsp_lines").toggle()
            -- vim.lsp.inlay_hint.enable(true)
          end
        '';
      }
      # {
      #   event = ["BufRead" "BufNewFile"];
      #   pattern = [".gitlab-ci.yml" ".gitlab-ci.yaml"];
      #   callback.__raw = ''
      #     function()
      #       vim.bo.filetype = "yaml.gitlab"
      #     end
      #   '';
      # }
    ];

    plugins.lsp = {
      enable = true;

      inlayHints = true;

      servers = {
        # https://github.com/MattSturgeon/nix-config/blob/main/nvim/config/lsp.nix
        nixd = {
          enable = true;
          settings = let
            flake = ''(builtins.getFlake "${self}")'';
            system = ''''${builtins.currentSystem}'';
          in {
            nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
            options = rec {
              nixos.expr = "${flake}.nixosConfigurations.desktop.options";
              home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions [ ]";
              nixvim.expr = "${flake}.packages.${system}.nvim.options";
            };
            diagnostic = {
              suppress = [
                "sema-escaping-with"
                "var-bind-to-this"
              ];
            };
          };
        };

        basedpyright.enable = true;

        texlab.enable = true;

        clangd.enable = true;

        # ltex.enable = true;

        dockerls.enable = true;

        bashls.enable = true;

        nginx_language_server.enable = true;

        html.enable = true;

        cssls.enable = true;

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
          {
            mode = "n";
            key = "<A-k>";
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
      };

      onAttach = ''
        local function on_attach(client, bufnr)
        	if client.server_capabilities.inlayHintProvider then
        		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

        		vim.keymap.set("n", "<localleader>ih", function()
        			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
        			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        		end, {
        			buffer = bufnr,
        		})
        	end
        end

        require("lspconfig")["basedpyright"].setup({
        	on_attach = on_attach,
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
