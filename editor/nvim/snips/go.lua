---@diagnostic disable: unused-local
local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local treesitter_postfix = require("luasnip.extras.treesitter_postfix").treesitter_postfix
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
local opt = require "luasnip.nodes.optional_arg"
local extras = require "luasnip.extras"
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require "luasnip.extras.expand_conditions"
local postfix = require("luasnip.extras.postfix").postfix
local types = require "luasnip.util.types"
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local function is_line_begin(line_to_cursor)
  return line_to_cursor:match "^%s*%a*$" ~= nil
end

local function is_package()
  local node = vim.treesitter.get_node()
  while node do
    if
      node:type() == "function_declaration"
      or node:type() == "method_declaration"
      or node:type() == "func_literal"
    then
      return false
    end
    node = node:parent()
  end
  return true --
end

local function package_level_condition(line_to_cursor)
  return is_line_begin(line_to_cursor) and is_package()
end

return {
  s(
    "erp",
    fmt(
      [[
    if err != nil {{
      println(err)
    }}

    {}
  ]],
      {
        i(1),
      }
    )
  ),

  s(
    "err",
    fmt(
      [[
    if err != nil {{
      return err
    }}
    
    {}
  ]],
      {
        i(1),
      }
    )
  ),

  s(
    "fn",
    fmt(
      [[
    func {}({}) {} {{
      {}
    }}
    ]],
      {
        i(1, "foo"),
        i(2),
        i(3),
        i(4),
      }
    )
  ),

  s(
    "new",
    fmt(
      [[
    func New{}({}) *{} {{
      return &{}{{
        {}
      }}
    }}
    ]],
      {
        i(1, "StructName"),
        i(2),
        rep(1),
        rep(1),
        i(3),
      }
    )
  ),

  s(
    "ifor",
    fmt(
      [[
      for {} := 0; {} < {}; {}++ {{
        {}
      }}
      ]],
      { i(1, "i"), rep(1), i(2, "n"), rep(1), i(3) }
    )
  ),

  s(
    "for",
    fmt(
      [[
      for {{
        {}
      }}
      ]],
      { i(1) }
    )
  ),

  s(
    {
      trig = "st",
      condition = conds.line_begin,
      show_condition = package_level_condition,
    },
    fmt(
      [[
  type {} struct {{
    {}
  }}
  ]],
      {
        i(1, "nameStruct"),
        i(2),
      }
    )
  ),

  s(
    {
      trig = "in",
      condition = conds.line_begin,
      show_condition = package_level_condition,
    },
    fmt(
      [[
    type {} interface {{
      {}
    }}
    ]],
      { i(1, "Name"), i(2) }
    )
  ),

  s(
    "pjson",
    fmt(
      [[
    {} {} `json:"{}"`
    ]],
      {
        i(1, "Field"),
        i(2, "string"),
        f(function(args)
          local text = args[1][1] or ""
          if text == "" then
            return ""
          end
          return text:sub(1, 1):lower() .. text:sub(2)
        end, { 1 }),
      }
    )
  ),

  s(
    {
      trig = "met",
      condition = conds.line_begin,
      show_condition = package_level_condition,
    },
    fmt(
      [[
    func (*{}) {}({}) {} {{
      {}
    }}
    ]],
      {
        i(1, "StructName"),
        i(2, "MethodName"),
        i(3),
        i(4),
        i(5),
      }
    )
  ),

  s(
    "gof",
    fmt(
      [[
    go func() {{
      {}
    }}()
    ]],
      { i(1) }
    )
  ),

  postfix(".json", {
    l("json.Marshal(" .. l.POSTFIX_MATCH .. ")"),
  }),

  s(
    "ifok",
    fmt(
      [[
    if {}, ok := {}[{}]; ok {{
      {}
    }}
    ]],
      {
        i(1, "val"),
        i(2, "m"),
        i(3, "key"),
        i(4),
      }
    )
  ),
}
