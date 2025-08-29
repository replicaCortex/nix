local M = {}

M.base46 = {
  theme = "gruvbox",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    ["LspInlayHint"] = { bg = "#282828" },
  },
}

M.ui = {
  tabufline = {
    enabled = false,
  },
  statusline = {
    theme = "default",
    separator_style = "block",
  },
}

return M
