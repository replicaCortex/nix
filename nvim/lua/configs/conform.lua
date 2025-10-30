require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    python = { "ruff_format", "ruff_organize_imports" },
    css = { "prettier" },
    html = { "prettier" },
    c = { "clang-format " },
    make = { "bake" },
    quarto = { "injected" },
    markdown = { "mdformat" },
    json = { "fixjson" },
    sql = { "sleek" },
    rust = { "rustfmt" },
  },
  format_on_save = {
    lsp_format = "fallback",
    timeout_ms = 500,
  },
}

require("conform").formatters.mdformat = {
  append_args = { "--number" },
}

require("conform").formatters.bake = {
  command = "mbake",
}

require("conform").formatters.injected = {
  options = {
    ignore_errors = false,
    lang_to_ext = {
      bash = "sh",
      c_sharp = "cs",
      elixir = "exs",
      javascript = "js",
      julia = "jl",
      latex = "tex",
      markdown = "md",
      python = "py",
      ruby = "rb",
      rust = "rs",
      teal = "tl",
      r = "r",
      typescript = "ts",
    },
    lang_to_formatters = {},
  },
}
