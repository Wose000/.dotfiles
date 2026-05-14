local M = {}

---comment
---@param c Palette
---@param opts any
---@return table
function M.get(c, opts)
  -- stylua: ignore
  return {
--    Foo                         = { bg = c.magenta2, fg = c.fg },
    Comment                     = { fg = c.grey}, -- any comment
    ColorColumn                 = { bg = c.black }, -- used for the columns set with 'colorcolumn'
    Conceal                     = { fg = c.bright_black }, -- placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor                      = { fg = c.black, bg = c.white }, -- character under the cursor
    lCursor                     = { fg = c.black, bg = c.white }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM                    = { fg = c.black, bg = c.white }, -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn                = { bg = c.black_blue }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine                  = { bg = c.black_blue }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory                   = { fg = c.blue }, -- directory names (and other special names in listings)
--    DiffAdd                     = { bg = c.diff.add }, -- diff mode: Added line |diff.txt|
--    DiffChange                  = { bg = c.diff.change }, -- diff mode: Changed line |diff.txt|
--    DiffDelete                  = { bg = c.diff.delete }, -- diff mode: Deleted line |diff.txt|
--    DiffText                    = { bg = c.diff.text }, -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer                 = { fg = c.black }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    ErrorMsg                    = { fg = c.peach }, -- error messages on the command line
    VertSplit                   = { fg = c.bright_black }, -- the column separating vertically split windows
    WinSeparator                = { fg = c.bright_black, bold = true }, -- the column separating vertically split windows
    Folded                      = { fg = c.blue, bg = c.ui.fg_hi }, -- line used for closed folds
    FoldColumn                  = { bg = opts.transparent and c.ui.none or c.ui.bg, fg = c.grey }, -- 'foldcolumn'
    SignColumn                  = { bg = opts.transparent and c.ui.none or c.ui.bg, fg = c.ui.fg }, -- column where |signs| are displayed
    SignColumnSB                = { bg = c.ui.bg_popup, fg = c.ui.fg_hi }, -- column where |signs| are displayed
    Substitute                  = { bg = c.magenta, fg = c.black }, -- |:substitute| replacement text highlighting
    LineNr                      = { fg = c.ui.fg_hi }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr                = { fg = c.peach, bold = true }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    LineNrAbove                 = { fg = c.ui.fg },
    LineNrBelow                 = { fg = c.ui.fg },
    MatchParen                  = { fg = c.peach, bold = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg                     = { fg = c.white, bold = true }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MsgArea                     = { fg = c.white }, -- Area for messages and cmdline
    MoreMsg                     = { fg = c.blue }, -- |more-prompt|
    NonText                     = { fg = c.white_blue }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Normal                      = { fg = c.ui.fg, bg = opts.transparent and c.ui.none or c.ui.bg }, -- normal text
    NormalNC                    = { fg = c.ui.fg, bg = opts.transparent and c.ui.none or opts.dim_inactive and c.black or c.ui.bg }, -- normal text in non-current windows
    NormalSB                    = { fg = c.ui.fg, bg = c.bright_black }, -- normal text in sidebar
    NormalFloat                 = { fg = c.ui.fg, bg = c.ui.bg_popup }, -- Normal text in floating windows.
    FloatBorder                 = { fg = c.ui.border_hi, bg = c.ui.bg_popup },
    FloatTitle                  = { fg = c.ui.border_hi, bg = c.ui.bg_popup },
    Pmenu                       = { bg = c.ui.bg_popup, fg = c.ui.fg }, -- Popup menu: normal item.
    PmenuMatch                  = { bg = c.ui.bg_popup, fg = c.blue }, -- Popup menu: Matched text in normal item.
--     PmenuSel                    = { bg = Util.blend_bg(c.fg_gutter, 0.8) }, -- Popup menu: selected item.
--     PmenuMatchSel               = { bg = Util.blend_bg(c.fg_gutter, 0.8), fg = c.blue1 }, -- Popup menu: Matched text in selected item.
--     PmenuSbar                   = { bg = Util.blend_fg(c.bg_popup, 0.95) }, -- Popup menu: scrollbar.
    PmenuThumb                  = { bg = c.ui.fg_hi }, -- Popup menu: Thumb of the scrollbar.
    Question                    = { fg = c.blue }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine                = { bg = c.ui.bg_visual, bold = true }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search                      = { bg = c.ui.bg, fg = c.ui.fg }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    IncSearch                   = { bg = c.peach, fg = c.black }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    CurSearch                   =  "IncSearch",
    SpecialKey                  = { fg = c.white }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad                    = { sp = c.diagnostic.error, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap                    = { sp = c.diagnostic.warning, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal                  = { sp = c.diagnostic.info, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare                   = { sp = c.diagnostic.hint, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    StatusLine                  = { fg = c.ui.fg_hi, bg = c.ui.bg_popup }, -- status line of current window
    StatusLineNC                = { fg = c.ui.fg_hi, bg = c.ui.bg_popup }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine                     = { bg = c.ui.bg_popup, fg = c.ui.fg_hi }, -- tab pages line, not active tab page label
    TabLineFill                 = { bg = opts.transparent and c.ui.none or c.black }, -- tab pages line, where there are no labels
    TabLineSel                  = { fg = c.black, bg = c.blue }, -- tab pages line, active tab page label
    Title                       = { fg = c.blue, bold = true }, -- titles for output from ":set all", ":autocmd" etc.
    Visual                      = { fg = c.bright_black, bg = c.ui.bg_visual }, -- Visual mode selection
    VisualNOS                   = { bg = c.ui.bg_visual }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg                  = { fg = c.diagnostic.warning }, -- warning messages
    Whitespace                  = { fg = c.grey }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    WildMenu                    = { bg = c.black }, -- current match in 'wildmenu' completion
    WinBar                      = "StatusLine" , -- window bar
    WinBarNC                    = "StatusLineNC", -- window bar in inactive windows

    Bold                        = { bold = true, fg = c.white }, -- (preferred) any bold text
    Character                   = { fg = c.green }, --  a character constant: 'c', '\n'
    Constant                    = { fg = c.peach }, -- (preferred) any constant
    Debug                       = { fg = c.peach }, --    debugging statements
    Delimiter                   =  "Special", --  character that needs attention
    Error                       = { fg = c.diagnostic.error }, -- (preferred) any erroneous construct
    Function                    = { fg = c.purple, italic=true}, -- function name (also: methods for classes)
    Identifier                  = { fg = c.magenta}, -- (preferred) any variable name
    Italic                      = { italic = true, fg = c.yellow }, -- (preferred) any italic text
    Keyword                     = { fg = c.violet }, --  any other keyword
    Operator                    = { fg = c.peach }, -- "sizeof", "+", "*", etc.
    PreProc                     = { fg = c.dark_blue }, -- (preferred) generic Preprocessor
    Special                     = { fg = c.blue }, -- (preferred) any special symbol
    Statement                   = { fg = c.magenta }, -- (preferred) any statement
    String                      = { fg = c.yellow }, --   a string constant: "this is a string"
    Todo                        = { bg = c.yellow, fg = c.black_blue }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
    Type                        = { fg = c.teal }, -- (preferred) int, long, char, etc.
    Underlined                  = { underline = true }, -- (preferred) text that stands out, HTML links
    -- debugBreakpoint             = { bg = Util.blend_bg(c.info, 0.1), fg = c.info }, -- used for breakpoint colors in terminal-debug
    debugPC                     = { bg = c.black }, -- used for highlighting the current line in terminal-debug
    dosIniLabel                 = "@property",
    helpCommand                 = { bg = c.black, fg = c.blue },
    htmlH1                      = { fg = c.magenta, bold = true },
    htmlH2                      = { fg = c.blue, bold = true },
    qfFileName                  = { fg = c.blue },
    qfLineNr                    = { fg = c.black },

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own.
    LspReferenceText            = { bg = c.violet }, -- used for highlighting "text" references
    LspReferenceRead            = { bg = c.green }, -- used for highlighting "read" references
    LspReferenceWrite           = { bg = c.peach }, -- used for highlighting "write" references
--    LspSignatureActiveParameter = { bg = Util.blend_bg(c.bg_visual, 0.4), bold = true },
    LspCodeLens                 = { fg = c.grey },
--    LspInlayHint                = { bg = Util.blend_bg(c.blue7, 0.1), fg = c.dark3 },
    LspInfoBorder               = { fg = c.white, bg = c.black },
    ComplHint                   = { fg = c.black },

    -- diagnostics
    DiagnosticError             = { fg = c.diagnostic.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticWarn              = { fg = c.diagnostic.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticInfo              = { fg = c.diagnostic.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticHint              = { fg = c.diagnostic.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticUnnecessary       = { fg = c.black }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
--    DiagnosticVirtualTextError  = { bg = Util.blend_bg(c.error, 0.1), fg = c.error }, -- Used for "Error" diagnostic virtual text
--    DiagnosticVirtualTextWarn   = { bg = Util.blend_bg(c.warning, 0.1), fg = c.warning }, -- Used for "Warning" diagnostic virtual text
--    DiagnosticVirtualTextInfo   = { bg = Util.blend_bg(c.info, 0.1), fg = c.info }, -- Used for "Information" diagnostic virtual text
--    DiagnosticVirtualTextHint   = { bg = Util.blend_bg(c.hint, 0.1), fg = c.hint }, -- Used for "Hint" diagnostic virtual text
    DiagnosticUnderlineError    = { undercurl = true, sp = c.diagnostic.error }, -- Used to underline "Error" diagnostics
    DiagnosticUnderlineWarn     = { undercurl = true, sp = c.diagnostic.warn }, -- Used to underline "Warning" diagnostics
    DiagnosticUnderlineInfo     = { undercurl = true, sp = c.diagnostic.info }, -- Used to underline "Information" diagnostics
    DiagnosticUnderlineHint     = { undercurl = true, sp = c.diagnostic.hint }, -- Used to underline "Hint" diagnostics

    -- Health
    healthError                 = { fg = c.diagnostic.error },
    healthSuccess               = { fg = c.diagnostic.success },
    healthWarning               = { fg = c.diagnostic.warn },

    -- diff (not needed anymore?)
 --   diffAdded                   = { bg = c.diff.add, fg = c.git.add },
 --   diffRemoved                 = { bg = c.diff.delete, fg = c.git.delete },
 --   diffChanged                 = { bg = c.diff.change, fg = c.git.change },
 --   diffOldFile                 = { fg = c.blue1, bg=c.diff.delete },
 --   diffNewFile                 = { fg = c.blue1, bg=c.diff.add },
 --   diffFile                    = { fg = c.blue },
 --   diffLine                    = { fg = c.comment },
 --   diffIndexLine               = { fg = c.magenta },
 --   helpExample                 = { fg = c.comment },
  }
end

return M
