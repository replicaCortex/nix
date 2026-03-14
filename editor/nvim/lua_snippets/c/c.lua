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

return {
  s("randint", t "int randint(int min, int max) { return ((rand() % (max - min + 1)) + min); }"),

  s(
    "randfloat",
    t " float randfloat(float min, float max) { return (min + ((float)rand() / (float)RAND_MAX)) * (max - min); } "
  ),

  s(
    "choice",
    { i(1, "int"), t " choice(", i(2, "int"), t " *array, int size) { return array[randint(0, size - 1)]; } " }
  ),

  s("size", fmt("int {} = sizeof({}) / sizeof({}[0]);", { i(1, "size"), i(2, "arr"), rep(2) })),
}
