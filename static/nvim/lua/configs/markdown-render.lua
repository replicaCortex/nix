require("render-markdown").setup {
  completions = {
    lsp = { enabled = true },
    blink = { enabled = true },
  },
  checkbox = {
    custom = {
      trash = { raw = "[_]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      pause = { raw = "[=]", rendered = " ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
      query = { raw = "[?]", rendered = "? ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
    },
  },
}
