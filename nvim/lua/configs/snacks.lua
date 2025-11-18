return {
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
          layout = {
            backdrop = false,
            row = 1,
            width = 0.4,
            min_width = 80,
            height = 0.8,
            border = "none",
            box = "vertical",
            { win = "preview", title = "{preview}", height = 0.4, border = true },
            {
              box = "vertical",
              border = true,
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
          },
        },
      },
    },
    layout = {
      preset = "dropdown",
    },
    win = {
      input = {
        keys = {
          ["<C-u>"] = { "<Esc>ddi", mode = { "i" }, expr = true },
        },
      },
    },
  },
  notifier = {},
  indent = {},
  bigfile = {},
  input = {},
  scope = {},
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
        local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
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
