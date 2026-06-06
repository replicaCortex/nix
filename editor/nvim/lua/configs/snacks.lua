local Snacks = require "snacks"

return {
  explorer = {
    replace_netrw = true,
  },

  picker = {
    sources = {
      explorer = {
        actions = {
          bufadd = function(_, item)
            if vim.fn.bufexists(item.file) == 0 then
              local buf = vim.api.nvim_create_buf(true, false)
              vim.api.nvim_buf_set_name(buf, item.file)
              vim.api.nvim_buf_call(buf, vim.cmd.edit)
            end
          end,
          confirm_nofocus = function(picker, item)
            if item.dir then
              picker:action "confirm"
            else
              picker:action "bufadd"
            end
          end,
        },
        win = {
          list = {
            keys = {
              ["l"] = "confirm_nofocus",
              ["L"] = "confirm",
            },
          },
        },
        auto_close = true,
        layout = {
          cycle = true,
          preview = true,
          preset = "default",
        },
      },
    },
    layout = {
      preset = "default",
    },
    win = {
      input = {
        keys = {
          ["<C-u>"] = { "<Esc>ddi", mode = { "i" }, expr = true },
          ["<C-[>"] = { "cancel", mode = { "i", "n" } },
        },
      },
    },
  },
  notifier = {},
  indent = {},
  bigfile = {},
  input = {},
  gitbrowse = {},
  scope = {},
  quickfile = {},
  bufdelete = {},
  dashboard = {
    formats = {
      header = { "%s", align = "center" },
      sections = { "%s", align = "center" },
    },
    width = 50,
    sections = function()
      local header = [[
            ___            
           /\  \           
          /  \/ \          
     ___  \   O /  ___     
    /    \ \   / /    \    
   /   __ -    -  __   \   
  /___/ | <>   <> | \___\  
  O  ___|    ^    |___  O  
   /     \   ~   /    \    
  /   /\  \_____/ /\   \   
  \_ / /          \ \_ /   
  O   /   /\   /\  \  O    
       \ /  \ /  \ /       
        O    O    O        
            ]]
      local function greeting()
        local hour = tonumber(vim.fn.strftime "%H")
        local part_id = math.floor((hour + 6) / 8) + 1
        local day_part = ({ "night", "morning", "afternoon", "evening" })[part_id] or "day"
        local username = os.getenv "USER" or os.getenv "USERNAME" or "user"
        return ("Good %s, %s"):format(day_part, username)
      end

      return {
        { align = "center", text = { header, hl = "header" } },
        { align = "center", text = { greeting(), hl = "header" } },
        { padding = 1 },
        { icon = " ", key = "i", desc = "New File", action = ":ene | startinsert" },
        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { padding = 1 },
        { section = "startup" },
      }
    end,
  },
}
