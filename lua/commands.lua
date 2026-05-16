vim.api.nvim_create_user_command("Zathura", function()
  local file_typ = vim.fn.expand "%"
  local file_pdf = string.sub(file_typ, 1, -4) .. "pdf"
  vim.system { "zathura", file_pdf }
end, {})
