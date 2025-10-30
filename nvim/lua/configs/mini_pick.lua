local opt = function()
  local function show_filename_only(buf_id, items_to_show, query)
    local new_items = vim.tbl_map(function(item)
      local new_item = vim.deepcopy(item)
      local path_to_modify

      if type(new_item) == "string" then
        path_to_modify = new_item
      elseif type(new_item) == "table" and new_item.path then
        path_to_modify = new_item.path
      end

      if path_to_modify then
        local filename = vim.fn.fnamemodify(path_to_modify, ":t")
        if type(new_item) == "string" then
          return { path = new_item, text = filename }
        elseif type(new_item) == "table" then
          if new_item.text then
            new_item.text = new_item.text:gsub("^" .. vim.pesc(path_to_modify), filename)
          else
            new_item.text = filename
          end
          return new_item
        end
      end

      return item
    end, items_to_show)

    require("mini.pick").default_show(buf_id, new_items, query, { show_icons = true })
  end

  return {
    {
      "<leader>ff",
      function()
        require("mini.pick").builtin.files({}, {
          source = { show = show_filename_only },
        })
      end,
    },

    {
      "<leader>fo",
      function()
        require("mini.pick").start {
          source = {
            items = vim.v.oldfiles,
            name = "Old Files",
            show = show_filename_only,
          },
        }
      end,
    },

    {
      "<leader>fg",
      function()
        require("mini.pick").builtin.grep_live({}, {
          source = { show = show_filename_only },
        })
      end,
    },

    {
      "<leader>fd",
      function()
        require("mini.pick").registry.my_diagnostics {
          source = { show = show_filename_only },
        }
      end,
    },

    -- Эти пикеры не работают с путями к файлам, их можно оставить как есть
    { "<leader>fh", "<cmd>Pick help<CR>", desc = "Pick help" },
    { "/", "<cmd>Pick buf_lines<CR>", desc = "Pick buffer lines" },
    { "?", "<cmd>Pick buf_lines<CR>", desc = "Pick buffer lines (reverse)" },
    { ".", "<cmd>Pick buf_lines<CR>", desc = "Pick buffer lines (dot)" },
    { ",", "<cmd>Pick buf_lines<CR>", desc = "Pick buffer lines (comma)" },
  }
end

return opt
