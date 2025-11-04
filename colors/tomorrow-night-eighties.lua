-- Tomorrow Night Eighties colourscheme (Lua port).
local fn = vim.fn
local cmd = vim.cmd
local api = vim.api

cmd("highlight clear")
if fn.exists("syntax_on") == 1 then
  cmd("syntax reset")
end

vim.o.background = "dark"
vim.g.colors_name = "tomorrow-night-eighties"

local colors = {
  foreground = "#cccccc",
  background = "#2d2d2d",
  selection = "#515151",
  line = "#393939",
  comment = "#999999",
  red = "#f2777a",
  orange = "#f99157",
  yellow = "#ffcc66",
  green = "#99cc99",
  aqua = "#66cccc",
  blue = "#6699cc",
  purple = "#cc99cc",
  window = "#4d5057",
}

local reset_attrs = {
  bold = false,
  italic = false,
  underline = false,
  undercurl = false,
  underdouble = false,
  underdotted = false,
  underdashed = false,
  strikethrough = false,
  reverse = false,
  standout = false,
}

local function apply_attr(opts, attr)
  if not attr then
    return
  end
  if attr == "bold" then
    opts.bold = true
  elseif attr == "italic" then
    opts.italic = true
  elseif attr == "reverse" then
    opts.reverse = true
  elseif attr == "none" then
    for key, value in pairs(reset_attrs) do
      opts[key] = value
    end
  end
end

local function highlight(group, fg, bg, attr)
  local opts = {}
  if fg then
    opts.fg = fg
  end
  if bg then
    opts.bg = bg
  end
  apply_attr(opts, attr)
  api.nvim_set_hl(0, group, opts)
end

highlight("Normal", colors.foreground, colors.background, nil)
highlight("LineNr", colors.selection, nil, nil)
highlight("NonText", colors.selection, nil, nil)
highlight("SpecialKey", colors.selection, nil, nil)
highlight("Search", colors.background, colors.yellow, nil)
highlight("TabLine", colors.window, colors.foreground, "reverse")
highlight("TabLineFill", colors.window, colors.foreground, "reverse")
highlight("StatusLine", colors.window, colors.yellow, "reverse")
highlight("StatusLineNC", colors.window, colors.foreground, "reverse")
highlight("VertSplit", colors.window, colors.window, "none")
highlight("Visual", nil, colors.selection, nil)
highlight("Directory", colors.blue, nil, nil)
highlight("ModeMsg", colors.green, nil, nil)
highlight("MoreMsg", colors.green, nil, nil)
highlight("Question", colors.green, nil, nil)
highlight("WarningMsg", colors.red, nil, nil)
highlight("MatchParen", nil, colors.selection, nil)
highlight("Folded", colors.comment, colors.background, nil)
highlight("FoldColumn", nil, colors.background, nil)
highlight("CursorLine", nil, colors.line, "none")
highlight("CursorLineNR", colors.yellow, colors.line, "bold")
highlight("CursorColumn", nil, colors.line, "none")
highlight("PMenu", colors.foreground, colors.selection, "none")
highlight("PMenuSel", colors.foreground, colors.selection, "reverse")
highlight("SignColumn", nil, colors.background, "none")
highlight("ColorColumn", nil, colors.line, "none")
highlight("Comment", colors.comment, nil, "italic")
highlight("Todo", colors.comment, colors.background, "italic")
highlight("Title", colors.comment, nil, nil)
highlight("Identifier", colors.red, nil, "none")
highlight("Statement", colors.foreground, nil, nil)
highlight("Conditional", colors.foreground, nil, nil)
highlight("Repeat", colors.foreground, nil, nil)
highlight("Structure", colors.purple, nil, nil)
highlight("Function", colors.blue, nil, nil)
highlight("Constant", colors.orange, nil, nil)
highlight("Keyword", colors.orange, nil, "italic")
highlight("String", colors.green, nil, nil)
highlight("Special", colors.foreground, nil, nil)
highlight("PreProc", colors.purple, nil, nil)
highlight("Operator", colors.aqua, nil, "none")
highlight("Type", colors.blue, nil, "none")
highlight("Define", colors.purple, nil, "none")
highlight("Include", colors.blue, nil, "italic")
highlight("vimCommand", colors.red, nil, "none")
highlight("cType", colors.yellow, nil, nil)
highlight("cStorageClass", colors.purple, nil, nil)
highlight("cConditional", colors.purple, nil, nil)
highlight("cRepeat", colors.purple, nil, nil)
highlight("phpVarSelector", colors.red, nil, nil)
highlight("phpType", colors.blue, nil, nil)
highlight("phpKeyword", colors.purple, nil, "italic")
highlight("phpRepeat", colors.purple, nil, nil)
highlight("phpConditional", colors.purple, nil, nil)
highlight("phpStatement", colors.purple, nil, nil)
highlight("phpMemberSelector", colors.foreground, nil, nil)
highlight("rubySymbol", colors.green, nil, nil)
highlight("rubyConstant", colors.yellow, nil, nil)
highlight("rubyAccess", colors.yellow, nil, nil)
highlight("rubyAttribute", colors.blue, nil, nil)
highlight("rubyInclude", colors.blue, nil, nil)
highlight("rubyLocalVariableOrMethod", colors.orange, nil, nil)
highlight("rubyCurlyBlock", colors.orange, nil, nil)
highlight("rubyStringDelimiter", colors.green, nil, nil)
highlight("rubyInterpolationDelimiter", colors.orange, nil, nil)
highlight("rubyConditional", colors.purple, nil, nil)
highlight("rubyRepeat", colors.purple, nil, nil)
highlight("rubyControl", colors.purple, nil, nil)
highlight("rubyException", colors.purple, nil, nil)
highlight("crystalSymbol", colors.green, nil, nil)
highlight("crystalConstant", colors.yellow, nil, nil)
highlight("crystalAccess", colors.yellow, nil, nil)
highlight("crystalAttribute", colors.blue, nil, nil)
highlight("crystalInclude", colors.blue, nil, nil)
highlight("crystalLocalVariableOrMethod", colors.orange, nil, nil)
highlight("crystalCurlyBlock", colors.orange, nil, nil)
highlight("crystalStringDelimiter", colors.green, nil, nil)
highlight("crystalInterpolationDelimiter", colors.orange, nil, nil)
highlight("crystalConditional", colors.purple, nil, nil)
highlight("crystalRepeat", colors.purple, nil, nil)
highlight("crystalControl", colors.purple, nil, nil)
highlight("crystalException", colors.purple, nil, nil)
highlight("pythonInclude", colors.purple, nil, nil)
highlight("pythonStatement", colors.purple, nil, nil)
highlight("pythonConditional", colors.purple, nil, nil)
highlight("pythonRepeat", colors.purple, nil, nil)
highlight("pythonException", colors.purple, nil, nil)
highlight("pythonFunction", colors.blue, nil, nil)
highlight("pythonPreCondit", colors.purple, nil, nil)
highlight("pythonRepeat", colors.aqua, nil, nil)
highlight("pythonExClass", colors.orange, nil, nil)
highlight("jsThis", colors.red, nil, "italic")
highlight("jsSuper", colors.orange, nil, "italic")
highlight("jsReturn", colors.purple, nil, nil)
highlight("jsDecorator", colors.purple, nil, "italic")
highlight("jsDecoratorFunction", colors.purple, nil, "italic")
highlight("javaScriptBraces", colors.foreground, nil, nil)
highlight("javaScriptFunction", colors.purple, nil, nil)
highlight("javaScriptConditional", colors.purple, nil, nil)
highlight("javaScriptRepeat", colors.purple, nil, nil)
highlight("javaScriptNumber", colors.orange, nil, nil)
highlight("javaScriptMember", colors.orange, nil, nil)
highlight("javascriptNull", colors.orange, nil, nil)
highlight("javascriptGlobal", colors.blue, nil, nil)
highlight("javascriptStatement", colors.red, nil, nil)
highlight("typescriptImport", colors.blue, nil, "italic")
highlight("typescriptExport", colors.blue, nil, "italic")
highlight("typescriptStatementKeyword", colors.purple, nil, nil)
highlight("typescriptNull", colors.blue, nil, nil)
highlight("typescriptVariable", colors.blue, nil, nil)
highlight("coffeeRepeat", colors.purple, nil, nil)
highlight("coffeeConditional", colors.purple, nil, nil)
highlight("coffeeKeyword", colors.purple, nil, nil)
highlight("coffeeObject", colors.yellow, nil, nil)
highlight("htmlTag", colors.red, nil, nil)
highlight("htmlTagName", colors.red, nil, nil)
highlight("htmlArg", colors.red, nil, nil)
highlight("htmlScriptTag", colors.red, nil, nil)
highlight("xmlTag", colors.red, nil, nil)
highlight("xmlTagName", colors.red, nil, nil)
highlight("xmlAttrib", colors.orange, nil, "italic")
highlight("xmlEndTag", colors.red, nil, nil)
highlight("diffAdd", nil, "#4c4e39", nil)
highlight("diffDelete", colors.background, colors.red, nil)
highlight("diffChange", nil, "#2b5b77", nil)
highlight("diffText", colors.line, colors.blue, nil)
highlight("ShowMarksHLl", colors.orange, colors.background, "none")
highlight("ShowMarksHLo", colors.purple, colors.background, "none")
highlight("ShowMarksHLu", colors.yellow, colors.background, "none")
highlight("ShowMarksHLm", colors.aqua, colors.background, "none")
highlight("luaStatement", colors.purple, nil, nil)
highlight("luaRepeat", colors.purple, nil, nil)
highlight("luaCondStart", colors.purple, nil, nil)
highlight("luaCondElseif", colors.purple, nil, nil)
highlight("luaCond", colors.purple, nil, nil)
highlight("luaCondEnd", colors.purple, nil, nil)
highlight("cucumberGiven", colors.blue, nil, nil)
highlight("cucumberGivenAnd", colors.blue, nil, nil)
highlight("goDirective", colors.purple, nil, nil)
highlight("goDeclaration", colors.purple, nil, nil)
highlight("goStatement", colors.purple, nil, nil)
highlight("goConditional", colors.purple, nil, nil)
highlight("goConstants", colors.orange, nil, nil)
highlight("goTodo", colors.yellow, nil, nil)
highlight("goDeclType", colors.blue, nil, nil)
highlight("goBuiltins", colors.purple, nil, nil)
highlight("goRepeat", colors.purple, nil, nil)
highlight("goLabel", colors.purple, nil, nil)
highlight("clojureConstant", colors.orange, nil, nil)
highlight("clojureBoolean", colors.orange, nil, nil)
highlight("clojureCharacter", colors.orange, nil, nil)
highlight("clojureKeyword", colors.green, nil, nil)
highlight("clojureNumber", colors.orange, nil, nil)
highlight("clojureString", colors.green, nil, nil)
highlight("clojureRegexp", colors.green, nil, nil)
highlight("clojureParen", colors.aqua, nil, nil)
highlight("clojureVariable", colors.yellow, nil, nil)
highlight("clojureCond", colors.blue, nil, nil)
highlight("clojureDefine", colors.purple, nil, nil)
highlight("clojureException", colors.red, nil, nil)
highlight("clojureFunc", colors.blue, nil, nil)
highlight("clojureMacro", colors.blue, nil, nil)
highlight("clojureRepeat", colors.blue, nil, nil)
highlight("clojureSpecial", colors.purple, nil, nil)
highlight("clojureQuote", colors.blue, nil, nil)
highlight("clojureUnquote", colors.blue, nil, nil)
highlight("clojureMeta", colors.blue, nil, nil)
highlight("clojureDeref", colors.blue, nil, nil)
highlight("clojureAnonArg", colors.blue, nil, nil)
highlight("clojureRepeat", colors.blue, nil, nil)
highlight("clojureDispatch", colors.blue, nil, nil)
highlight("scalaKeyword", colors.purple, nil, nil)
highlight("scalaKeywordModifier", colors.purple, nil, nil)
highlight("scalaOperator", colors.blue, nil, nil)
highlight("scalaPackage", colors.red, nil, nil)
highlight("scalaFqn", colors.foreground, nil, nil)
highlight("scalaFqnSet", colors.foreground, nil, nil)
highlight("scalaImport", colors.purple, nil, nil)
highlight("scalaBoolean", colors.orange, nil, nil)
highlight("scalaDef", colors.purple, nil, nil)
highlight("scalaVal", colors.purple, nil, nil)
highlight("scalaVar", colors.aqua, nil, nil)
highlight("scalaClass", colors.purple, nil, nil)
highlight("scalaObject", colors.purple, nil, nil)
highlight("scalaTrait", colors.purple, nil, nil)
highlight("scalaDefName", colors.blue, nil, nil)
highlight("scalaValName", colors.foreground, nil, nil)
highlight("scalaVarName", colors.foreground, nil, nil)
highlight("scalaClassName", colors.foreground, nil, nil)
highlight("scalaType", colors.yellow, nil, nil)
highlight("scalaTypeSpecializer", colors.yellow, nil, nil)
highlight("scalaAnnotation", colors.orange, nil, nil)
highlight("scalaNumber", colors.orange, nil, nil)
highlight("scalaDefSpecializer", colors.yellow, nil, nil)
highlight("scalaClassSpecializer", colors.yellow, nil, nil)
highlight("scalaBackTick", colors.green, nil, nil)
highlight("scalaRoot", colors.foreground, nil, nil)
highlight("scalaMethodCall", colors.blue, nil, nil)
highlight("scalaCaseType", colors.yellow, nil, nil)
highlight("scalaLineComment", colors.comment, nil, nil)
highlight("scalaComment", colors.comment, nil, nil)
highlight("scalaDocComment", colors.comment, nil, nil)
highlight("scalaDocTags", colors.comment, nil, nil)
highlight("scalaEmptyString", colors.green, nil, nil)
highlight("scalaMultiLineString", colors.green, nil, nil)
highlight("scalaUnicode", colors.orange, nil, nil)
highlight("scalaString", colors.green, nil, nil)
highlight("scalaStringEscape", colors.green, nil, nil)
highlight("scalaSymbol", colors.orange, nil, nil)
highlight("scalaChar", colors.orange, nil, nil)
highlight("scalaXml", colors.green, nil, nil)
highlight("scalaConstructorSpecializer", colors.yellow, nil, nil)
highlight("scalaBackTick", colors.blue, nil, nil)
highlight("diffAdded", colors.green, nil, nil)
highlight("diffRemoved", colors.red, nil, nil)
highlight("gitcommitSummary", nil, nil, "bold")
