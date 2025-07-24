require("markview").setup {
  require("markview").setup {
    markdown = {
      list_items = {
        shift_width = function(buffer, item)
          --- Reduces the `indent` by 1 level.
          ---
          ---         indent                      1
          --- ------------------------- = 1 ÷ --------- = new_indent
          --- indent * (1 / new_indent)       new_indent
          ---
          local parent_indnet = math.max(1, item.indent - vim.bo[buffer].shiftwidth)

          return item.indent * (1 / (parent_indnet * 2))
        end,
        marker_minus = {
          add_padding = function(_, item)
            return item.indent > 1
          end,
        },
      },
    },
  },
  markdown_inline = {
    checkboxes = {
      enable = true,

      checked = { text = " ", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxChecked" },
      unchecked = { text = "☐ ", hl = "MarkviewCheckboxUnchecked", scope_hl = "MarkviewCheckboxUnchecked" },

      [">"] = { text = " ", hl = "MarkviewCheckboxCancelled" },
      ["_"] = { text = " ", hl = "MarkviewCheckboxCancelled", scope_hl = "MarkviewCheckboxStriked" },
      ["/"] = { text = "󰥔 ", hl = "MarkviewCheckboxPending" },
      ["?"] = { text = " ", hl = "MarkviewCheckboxPending" },
      ["!"] = { text = "󰀦 ", hl = "MarkviewCheckboxUnchecked" },
      ["*"] = { text = "󰓎 ", hl = "MarkviewCheckboxPending" },
      ["="] = { text = " ", hl = "MarkviewCheckboxProgress" },
      ["i"] = { text = "󰛨 ", hl = "MarkviewCheckboxPending" },
      ["l"] = { text = " ", hl = "MarkviewCheckboxChecked" },
      ["d"] = { text = " ", hl = "MarkviewCheckboxUnchecked" },
    },
  },
}
