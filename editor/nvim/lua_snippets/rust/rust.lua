local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require "luasnip.util.types"

return {

  s("debug", t "#[derive(Debug)]"),
  s("deadcode", t "#[allow(dead_code)]"),

  s(":turbofish", { t { "::<" }, i(0), t { ">" } }),

  s("struct", {
    t { "#[derive(Debug)]", "" },
    t { "struct " },
    i(1),
    t { " {", "" },
    i(0),
    t { "}", "" },
  }),

  s("test", {
    t { "#[test]", "" },
    t { "fn " },
    i(1),
    t { "() {", "" },
    t { "	assert" },
    i(0),
    t { "", "" },
    t { "}" },
  }),

  s("testcfg", {
    t { "#[cfg(test)]", "" },
    t { "mod " },
    i(1),
    t { " {", "" },
    t { "	#[test]", "" },
    t { "	fn " },
    i(2),
    t { "() {", "" },
    t { "		assert" },
    i(0),
    t { "", "" },
    t { "	}", "" },
    t { "}" },
  }),
}
