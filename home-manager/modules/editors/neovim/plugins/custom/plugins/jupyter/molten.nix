{
  programs.nixvim = {
    plugins.molten = {
      enable = true;
      # python3Dependencies = p: with p; [];
      settings = {
        auto_open_output = false;
        save_path.__raw = "vim.fn.stdpath('data')..'/molten'";
        output_win_border = ["" "━" "" ""];
        # image_provider = "wezterm";
        image_provider = "image.nvim";
        image_location = "virt";
        output_win_max_height = 12;
        virt_lines_off_by_1 = true;
        virt_text_output = true;
        wrap_output = true;
        tick_rate = 142;
      };
    };

    plugins.wezterm = {
      enable = false;
    };

    keymaps = [
      {
        mode = "n";
        key = "<localleader>mi";
        action = ":MoltenInit<CR>";
      }

      {
        mode = "n";
        key = "<localleader>mdi";
        action = ":MoltenDeinit<CR>";
      }
    ];
    extraConfigLuaPre = ''

      vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
        pattern = {"*.md"},

        callback = function()
        vim.cmd("setlocal conceallevel=0")
        end
        })

      -- vim.api.nvim_set_hl(0, "MoltenCell", { link = "Normal" }) -- убирает выделение клеток

      -- Полностью отключаем фон для клеток
      vim.api.nvim_set_hl(0, "MoltenCell", {
        bg = "none",    -- прозрачный фон
      })

      -- automatically import output chunks from a jupyter notebook
      -- tries to find a kernel that matches the kernel in the jupyter notebook
      -- falls back to a kernel that matches the name of the active venv (if any)
      local imb = function(e) -- init molten buffer
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()
          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)
          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            if venv ~= nil then
              kernel_name = string.match(venv, "/.+/(.+)")
            end
          end
          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(("MoltenInit %s"):format(kernel_name))
          end
          vim.cmd("MoltenImportOutput")
        end)
      end

      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd("BufAdd", {
        pattern = { "*.ipynb" },
        callback = imb,
      })

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.ipynb" },
        callback = function(e)
          if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            imb(e)
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.ipynb" },
        callback = function()
          require("image").setup = image_setup_original
          require("image").setup({
            backend="ueberzug",
            integrations = {
              markdown = {
                enabled = true,
                -- clear_in_insert_mode = false,
                -- download_remote_images = false,
                -- only_render_image_at_cursor = true,
                filetypes = { "markdown", "quarto" }, -- markdown extensions (ie. quarto) can go here
              },
              neorg = {
                enabled = true,
                -- clear_in_insert_mode = false,
                -- download_remote_images = false,
                only_render_image_at_cursor = true,
                filetypes = { "norg" },
              },
            },
            -- max_width = 100,
            -- max_height = 8,
            -- NODE: временно убрал huge
            -- max_height_window_percentage = math.huge,
            -- max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
            tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
            window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "fidget", ""},
          })
        end,
      })

      -- automatically export output chunks to a jupyter notebook on write
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.ipynb" },
        callback = function()
          if require("molten.status").initialized() == "Molten" then
            vim.cmd("MoltenExportOutput!")
          end
        end,
      })

      -- -- change the configuration when editing a python file
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.py",
        callback = function(e)
          if string.match(e.file, ".otter.") then
            return
          end
          if require("molten.status").initialized() == "Molten" then -- this is kinda a hack...
            vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
            vim.fn.MoltenUpdateOption("virt_text_output", false)
          else
            vim.g.molten_virt_lines_off_by_1 = false
            vim.g.molten_virt_text_output = false
          end
        end,
      })
      --
      -- -- Undo those config changes when we go back to a markdown or quarto file
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.qmd", "*.md", "*.ipynb" },
        callback = function(e)
          if string.match(e.file, ".otter.") then
            return
          end
          if require("molten.status").initialized() == "Molten" then
            vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
            vim.fn.MoltenUpdateOption("virt_text_output", true)
          else
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output = true
          end
        end,
      })

      -- Provide a command to create a blank new Python notebook
      -- note: the metadata is needed for Jupytext to understand how to parse the notebook.
      -- if you use another language than Python, you should change it in the template.
      local default_notebook = [[
              {
                "cells": [
                 {
                  "cell_type": "markdown",
                  "metadata": {},
                  "source": [
                    ""
                  ]
                 }
                ],
                "metadata": {
                 "kernelspec": {
                  "display_name": "Python 3",
                  "language": "python",
                  "name": "python3"
                 },
                 "language_info": {
                  "codemirror_mode": {
                    "name": "ipython"
                  },
                  "file_extension": ".py",
                  "mimetype": "text/x-python",
                  "name": "python",
                  "nbconvert_exporter": "python",
                  "pygments_lexer": "ipython3"
                 }
                },
                "nbformat": 4,
                "nbformat_minor": 5
              }
            ]]

      local function new_notebook(filename)
        local path = filename .. ".ipynb"
        local file = io.open(path, "w")
        if file then
          file:write(default_notebook)
          file:close()
          vim.cmd("edit " .. path)
        else
          print("Error: Could not open new notebook file for writing.")
        end
      end

      vim.api.nvim_create_user_command("NewNotebook", function(opts)
        new_notebook(opts.args)
      end, {
        nargs = 1,
        complete = "file",
      })

    '';
  };
}
