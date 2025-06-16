local ls = require "luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require "luasnip.util.events"
local ai = require "luasnip.nodes.absolute_indexer"
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

local match_pattern = "[%wА-Яа-яЁёЦцТтРрЪъЬьШшЮюЩщХхЭэУуФфНнБбЫыЧч_-]+$"

local function formatter(args)
  return string.lower(string.gsub(args[1][1], " ", "_"))
end

return {
  s({ trig = "!lualatex" }, {
    t "%! TeX program = lualatex",
  }),

  ms({ "fig", "ашп" }, {

    t { "\\begin{figure}", "\t\\begin{center}", "\t\t\\includegraphics[width=0.80\\textwidth]{fig/" },
    i(1, "fig"),
    t "}",
    t { "", "\t\\end{center}", "\t\\caption{" },
    i(2, "capiton"),
    t "}",
    t { "\\label{fig:" },
    f(formatter, { 1 }),
    t { "}", "\\end{figure}", " " },
    i(0),
  }),

  postfix(
    {
      trig = ".bt",
      match_pattern = match_pattern,
    },
    fmt(
      [[
  \textbf{{{}}} 
  ]],
      f(function(_, parent)
        return parent.snippet.env.POSTFIX_MATCH
      end)
    )
  ),

  postfix(
    {
      trig = ".ие",
      match_pattern = match_pattern,
    },
    fmt(
      [[
  \textbf{{{}}} 
  ]],
      f(function(_, parent)
        return parent.snippet.env.POSTFIX_MATCH
      end)
    )
  ),

  postfix(
    {
      trig = ".ше",
      match_pattern = match_pattern,
    },
    fmt(
      [[
  \textit{{{}}} 
  ]],
      f(function(_, parent)
        return parent.snippet.env.POSTFIX_MATCH
      end)
    )
  ),

  postfix(
    {
      trig = ".it",
      match_pattern = match_pattern,
    },
    fmt(
      [[
  \textit{{{}}} 
  ]],
      f(function(_, parent)
        return parent.snippet.env.POSTFIX_MATCH
      end)
    )
  ),

  ms(
    { "cite", "сшеу" },
    fmt(
      [[
    \cite{{{}}}
    ]],
      i(1, "autor")
    )
  ),

  ms(
    { "h1", "р1" },
    fmt(
      [[
    \section{{{}}} % (fold)[

    {}
    
    % section {} (end)]
    ]],
      {
        i(1, "name"),
        i(0, "text"),
        rep(1),
      }
    )
  ),

  ms(
    { "h2", "р2" },
    fmt(
      [[
    \subsection{{{}}} % (fold)[

    {}
    
    % subsection {} (end)]
    ]],
      {
        i(1, "name"),
        i(0, "text"),
        rep(1),
      }
    )
  ),

  ms(
    { "h3", "р3" },
    fmt(
      [[
    \subsubsection{{{}}} % (fold)[

    {}
    
    % subsubsection {} (end)]
    ]],
      {
        i(1, "name"),
        i(0, "text"),
        rep(1),
      }
    )
  ),

  ms(
    { "h4", "р4" },
    fmt(
      [[
    \paragraph{{{}}} % (fold)[

    {}
    
    % paragraph {} (end)]
    ]],
      {
        i(1, "name"),
        i(0, "text"),
        rep(1),
      }
    )
  ),

  ms(c(1, {
    t "\\setmainfont{TimesNewerRoman}",
    t "\\setmainfont{Ubuntu}",
    sn(nil, fmt("\\setmainfont{{{}}}", { i(1, "font") })),
  })),

  ms(
    { "font", "ащте" },
    c(1, {
      fmt(
        [[
\usepackage[left={}cm, right={}cm, top={}cm, bottom={}cm{}]{{geometry}}


]],
        {
          i(1, "1.0"), -- left
          i(2, "1.0"), -- right
          i(3, "1.0"), -- top
          i(4, "1.0"), -- bottom
          c(5, {
            t "",
            t ", includeheadfoot",
          }),
        }
      ),

      fmt(
        [[
\usepackage[margin={}cm]{{geometry}}


]],
        {
          i(1, "1.0"), -- margin
        }
      ),
    })
  ),
}
