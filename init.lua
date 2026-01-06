--[[
leny/pweneovim - init.lua
Author: leny

This file is the Lua rewrite of the legacy `init.vim`.
It keeps every original option, mapping, autocommand, and plugin behaviour intact,
while taking advantage of idiomatic Neovim Lua APIs and a documented structure.
The goal is parity with the previous configuration, not to introduce behavioural changes.

Also, cf. https://github.com/albingroen/quick.nvim/blob/main/init.lua
]]

-- ------------------------------------------------------------------------
-- Short aliases to make the rest of the configuration easier to read.
-- ------------------------------------------------------------------------

local fn = vim.fn
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local api = vim.api

-- Pre-plugin options

opt.termguicolors = true
cmd.colorscheme("tomorrow-night-eighties")

-- ------------------------------------------------------------------------
-- Plugin Management - lazy.nvim bootstrap (replaces vim-plug).
-- ------------------------------------------------------------------------

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
opt.rtp:prepend(lazypath)

-- Plugin specification mirrors the previous Plug register.
require("lazy").setup({
    {
        "vhyrro/luarocks.nvim",
        priority = 2000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
        config = true,
    },
    { "nvim-lua/plenary.nvim" }, -- Required by multiple Lua plugins.
    { "neovim/nvim-lspconfig" }, -- Core LSP client helpers.
    {
        "folke/neodev.nvim",
        opts = {
            library = {
                plugins = { "love" },
                types = true,
            },
        },
    },
    {
        "hrsh7th/nvim-cmp", -- completion
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
    },

    {
        "simrat39/rust-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    { "rafamadriz/friendly-snippets" },
    { "nvim-treesitter/nvim-treesitter", lazy = false, branch = "main", build = ":TSUpdate" },
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({
                symbol_in_winbar = {
                    enable = false,
                },
                beacon = {
                    enable = false,
                },
                lightbulb = {
                    enable = false,
                },
            })
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        }
    },
    { "folke/trouble.nvim" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "ThePrimeagen/harpoon", branch = "harpoon2" },
    { "stevearc/oil.nvim" },
    { "editorconfig/editorconfig-vim" },
    { "kshenoy/vim-signature" },
    { "terryma/vim-expand-region" },
    { "troydm/zoomwintab.vim" },
    { "airblade/vim-gitgutter" },
    {
        "prettier/vim-prettier",
        build = "yarn install",
        ft = {
            "javascript",
            "typescript",
            "typescriptreact",
            "css",
            "less",
            "scss",
            "json",
            "graphql",
            "markdown",
            "vue",
            "lua",
            "php",
            "python",
            "ruby",
            "html",
            "swift",
            "yaml",
        },
    },
    { "wesleimp/stylua.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "mileszs/ack.vim" },
    { "windwp/nvim-autopairs" },
    { "tpope/vim-surround" },
    { "chentoast/marks.nvim" },
    { "tpope/vim-eunuch" },
    { "wuelnerdotexe/vim-astro" },
    { "f-person/git-blame.nvim" },
    { "gbprod/substitute.nvim" },
    { "mattn/emmet-vim", commit = "3fb2f63799e1922f7647ed9ff3b32154031a76ee" },
    { "github/copilot.vim" },
}, {
    defaults = { lazy = false }, -- Keep the eager loading behaviour of vim-plug.
    install = { colorscheme = { "tomorrow-night-eighties" } },
    ui = { border = "rounded" },
})

-- ------------------------------------------------------------------------
-- Core editor settings (1:1 translation from the original Vimscript `set`)
-- ------------------------------------------------------------------------

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local opt = vim.opt

    opt.encoding = "utf-8"
    opt.fileencodings = { "utf-8" }
    opt.backup = false
    opt.swapfile = false
    opt.history = 250
    opt.hidden = true
    opt.number = true
    opt.tabstop = 4
    opt.softtabstop = 4
    opt.shiftwidth = 4
    opt.expandtab = true
    opt.foldmethod = "syntax"
    opt.ignorecase = true
    opt.smartcase = true
    opt.modelines = 0
    opt.showmatch = true
    opt.nrformats = { "hex", "alpha" }
    opt.wrap = false
    opt.fileformat = "unix"
    opt.fileformats = { "unix", "dos" }
    opt.foldlevel = 250
    opt.showmode = false
    opt.updatetime = 2000
    opt.smartindent = true
    opt.ttimeoutlen = 0 -- cf. https://github.com/wincent/terminus/issues/9#issuecomment-363775121
    opt.scrolloff = 4
    opt.sidescrolloff = 5
    opt.sidescroll = 1
    opt.paste = false
    opt.hlsearch = true
    opt.splitbelow = true
    opt.splitright = true
    opt.listchars = { trail = "·", tab = "··", eol = "¬", nbsp = "░" }
    opt.list = true

  end,
})

cmd("syntax on")

g.mapleader = " "

-- ------------------------------------------------------------------------
-- Custom user commands ported from their Vimscript counterparts.
-- ------------------------------------------------------------------------

api.nvim_create_user_command("W", "w", { desc = "Quick typo helper for :w" })

-- ------------------------------------------------------------------------
-- Keymap helpers (all mappings gain descriptions for easier discoverability).
-- ------------------------------------------------------------------------

local map = vim.keymap.set
local keymap_opts = { silent = true }

map(
    "c",
    "w!!",
    "w !sudo tee % > /dev/null",
    vim.tbl_extend("force", keymap_opts, {
        desc = "Write current buffer with sudo (ex-mode override)",
    })
)

map("n", "<CR>", "<cmd>noh<CR><CR>", vim.tbl_extend("force", keymap_opts, { desc = "Clear search highlight" }))

map("i", "jj", "<Esc>", { desc = "Exit insert mode using jj" })
map("i", "kk", "<Esc>", { desc = "Exit insert mode using kk" })
map("i", ";;", ";<Esc>", { desc = "Leave insert mode after typing ;; " })

map("n", "<Tab>", "%", { desc = "Jump to matching pair" })
map("x", "<Tab>", "%", { desc = "Jump to matching pair" })

map("n", "<Up>", "<Nop>", { desc = "Disable arrow key" })
map("n", "<Down>", "<Nop>", { desc = "Disable arrow key" })
map("i", "<Up>", "<Nop>", { desc = "Disable arrow key" })
map("i", "<Down>", "<Nop>", { desc = "Disable arrow key" })
map("i", "<Left>", "<Nop>", { desc = "Disable arrow key" })
map("i", "<Right>", "<Nop>", { desc = "Disable arrow key" })

map("i", "<Space><Space>", "<Space><Space><Left>", { desc = "Keep one trailing space during insert" })

map("n", "<Left>", "<<", { remap = true, desc = "Shift current line left" })
map("n", "<Right>", ">>", { remap = true, desc = "Shift current line right" })
map("x", "<Left>", "<gv", { remap = true, desc = "Shift selection left and reselect" })
map("x", "<Right>", ">gv", { remap = true, desc = "Shift selection right and reselect" })

map("n", "j", function()
    return vim.v.count > 0 and "j" or "gj"
end, { expr = true, desc = "Prefer visual line movement when no count is provided" })

map("n", "k", function()
    return vim.v.count > 0 and "k" or "gk"
end, { expr = true, desc = "Prefer visual line movement when no count is provided" })

map("n", "Q", "<Nop>", { desc = "Prevent accidental entry into Ex mode" })
map("n", "K", "<Nop>", { desc = "Disable default man page lookup" })
map("n", "'", "`", { desc = "Fix dead-key behaviour for marks" })

map("n", "<leader><leader>!", "Bi!<Esc>", { desc = "Insert ! at beginning of word" })
map("n", "<leader><leader>;", "A;<Esc>", { desc = "Append ; to current line" })
map("n", "<leader><leader>,", "A,<Esc>", { desc = "Append , to current line" })
map("n", "<leader><leader>.", "A.<Esc>", { desc = "Append . to current line" })

map("x", "//", 'y/\\V<C-R>"<CR>', vim.tbl_extend("force", keymap_opts, { desc = "Search selected text" }))

map("n", "[b", function()
    vim.diagnostic.goto_prev()
end, { desc = "Go to previous diagnostic" })

map("n", "[n", function()
    vim.diagnostic.goto_next()
end, { desc = "Go to next diagnostic" })

map("n", "<C-J>", "<C-W><C-J>", { desc = "Move to split below" })
map("n", "<C-K>", "<C-W><C-K>", { desc = "Move to split above" })
map("n", "<C-L>", "<C-W><C-L>", { desc = "Move to split right" })
map("n", "<C-H>", "<C-W><C-H>", { desc = "Move to split left" })
map("n", "<C-W>:", "<C-W>_", { desc = "Maximise current split height" })

map(
    "n",
    "<leader>l",
    "<cmd>set list!<CR>",
    vim.tbl_extend("force", keymap_opts, { desc = "Toggle invisible characters" })
)
map("n", "<leader>W", "<cmd>set wrap!<CR>", vim.tbl_extend("force", keymap_opts, { desc = "Toggle wrapping" }))

map("n", "d", '"xd', { desc = "Delete without clobbering default register" })
map("x", "d", '"xd', { desc = "Delete selection without clobbering default register" })
map("n", "y", '"xy', { desc = "Yank into named register x" })
map("x", "y", '"xy', { desc = "Yank selection into named register x" })
map("n", "p", '"xp', { desc = "Paste from named register x" })
map("x", "p", '"xp', { desc = "Paste selection from named register x" })

map("n", "<leader>s", function()
    cmd.source(fn.stdpath("config") .. "/init.lua")
end, { desc = "Reload this configuration file" })

map("n", "gh", function()
    vim.lsp.buf.hover()
end, { desc = "LSP hover" })

map("n", "gd", function()
    vim.lsp.buf.definition()
end, { desc = "LSP go to definition" })

-- Telescope/Harpoon mappings are defined alongside their configuration later.

map(
    "n",
    "gr",
    "<cmd>Trouble diagnostics toggle<CR>",
    vim.tbl_extend("force", keymap_opts, {
        desc = "Toggle Trouble diagnostics",
    })
)
map(
    "n",
    "gt",
    "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
    vim.tbl_extend("force", keymap_opts, {
        desc = "Toggle Trouble diagnostics for current buffer",
    })
)

map("n", "gm", "<cmd>lua vim.lsp.buf.code_action()<CR>", vim.tbl_extend("force", keymap_opts, {
        desc = "Toggle Code Actions from LSP",
    }))
map("", "gm", "<cmd>lua vim.lsp.buf.code_action()<CR>", vim.tbl_extend("force", keymap_opts, {
        desc = "Toggle Code Actions from LSP",
    }))

map("n", "gz", "<cmd>ZoomWinTabToggle<CR>", vim.tbl_extend("force", keymap_opts, { desc = "Toggle window zoom" }))
map("n", "gn", "<cmd>tabnext<CR>", vim.tbl_extend("force", keymap_opts, { desc = "Go to next tab" }))

-- ------------------------------------------------------------------------
-- Autocommands & augroups translated from Vimscript.
-- ------------------------------------------------------------------------

local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd

-- Create directory tree automatically before saving (mirrors mkdir + silent).
autocmd("BufWritePre", {
    group = augroup("AutoMkdir", { clear = true }),
    callback = function(event)
        local file = event.match ~= "" and event.match or fn.expand("<afile>")
        local dir = fn.fnamemodify(file, ":p:h")
        if dir ~= "" and fn.isdirectory(dir) == 0 then
            fn.mkdir(dir, "p")
        end
    end,
    desc = "Auto-create missing directories before write",
})

-- Save buffers on focus loss / buffer leave + trim trailing whitespace.
local save_group = augroup("Save", { clear = true })

autocmd({ "FocusLost", "BufLeave" }, {
    group = save_group,
    callback = function()
        pcall(cmd, "wa")
    end,
    desc = "Write all buffers on focus loss or buffer leave",
})

autocmd("BufWritePre", {
    group = save_group,
    callback = function()
        local view = fn.winsaveview()
        cmd([[%s/\s\+$//e]])
        fn.winrestview(view)
    end,
    desc = "Trim trailing whitespace automatically",
})

-- Highlight the cursor line only in the active window.
local cursorline_group = augroup("CursorLine", { clear = true })
autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = cursorline_group,
    callback = function()
        api.nvim_win_set_option(0, "cursorline", true)
    end,
    desc = "Enable cursorline in active window",
})
autocmd("WinLeave", {
    group = cursorline_group,
    callback = function()
        api.nvim_win_set_option(0, "cursorline", false)
    end,
    desc = "Disable cursorline in inactive windows",
})

-- Toggle relative numbers based on mode focus.
local relativenumber_group = augroup("RelativeNumber", { clear = true })
autocmd({ "WinLeave", "InsertEnter" }, {
    group = relativenumber_group,
    callback = function()
        api.nvim_win_set_option(0, "relativenumber", false)
    end,
    desc = "Turn off relative numbers when leaving window or entering insert mode",
})
autocmd({ "BufEnter", "WinEnter", "InsertLeave" }, {
    group = relativenumber_group,
    callback = function()
        api.nvim_win_set_option(0, "relativenumber", true)
    end,
    desc = "Turn on relative numbers when re-entering window or leaving insert mode",
})

-- Automatically reload files modified outside of Neovim.
autocmd({ "CursorHold", "CursorHoldI" }, {
    group = augroup("CheckTime", { clear = true }),
    callback = function()
        cmd("checktime")
    end,
    desc = "Check if the file changed on disk",
})

-- Preserve folding when editing inside insert mode (mirrors w:last_fdm logic).
local preserve_group = augroup("PreserveFolding", { clear = true })
autocmd("InsertEnter", {
    group = preserve_group,
    callback = function()
        if vim.w.last_fdm == nil then
            vim.w.last_fdm = api.nvim_win_get_option(0, "foldmethod")
            api.nvim_win_set_option(0, "foldmethod", "manual")
        end
    end,
    desc = "Remember foldmethod before switching to insert mode",
})
autocmd({ "InsertLeave", "WinLeave" }, {
    group = preserve_group,
    callback = function()
        local last = vim.w.last_fdm
        if last ~= nil then
            api.nvim_win_set_option(0, "foldmethod", last)
            vim.w.last_fdm = nil
        end
    end,
    desc = "Restore foldmethod after insert mode or leaving window",
})

-- Fix pastemode issue by disabling it automatically.
autocmd("InsertLeave", {
    group = augroup("FixNoPasteIssue", { clear = true }),
    callback = function()
        opt.paste = false
    end,
    desc = "Ensure paste mode is disabled after insert mode",
})

-- Filetype-specific mappings & behaviours.
g["prettier#exec_cmd_async"] = 1
autocmd("FileType", {
    pattern = {
        "javascript",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "json",
        "css",
        "scss",
        "markdown",
        "php",
        "html",
    },
    callback = function(event)
        map(
            "n",
            "gp",
            "<cmd>Prettier<CR>",
            vim.tbl_extend("force", keymap_opts, {
                buffer = event.buf,
                desc = "Format buffer with Prettier",
            })
        )
    end,
})

autocmd("FileType", {
    pattern = {
        "javascript",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    callback = function(event)
        map(
            "n",
            "gl",
            function()
                local filepath = vim.fn.expand('%:p')
                local cmd = string.format('npx eslint --fix --cache %s', vim.fn.shellescape(filepath))

                print('Running eslint...')
                local output = vim.fn.system(cmd)

                if vim.v.shell_error == 0 then
                    print('ESLint: fixed!')
                    vim.cmd('checktime')
                else
                    print('ESLint error:')
                    print(output)
                end
            end,
            vim.tbl_extend("force", keymap_opts, {
                buffer = event.buf,
                desc = "ESLint fix current file",
            })
        )
    end,
})

autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.tsx",
    command = "set filetype=typescript.tsx",
    desc = "Force *.tsx buffers to use the TypeScript TSX filetype",
})

autocmd("FileType", {
    pattern = "rust",
    callback = function(event)
        map("n", "gp", function()
            vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", keymap_opts, { buffer = event.buf, desc = "Format Rust buffer via LSP" }))
    end,
})

autocmd("FileType", {
    pattern = "lua",
    callback = function(event)
        map("n", "gp", function()
            require("stylua").format()
        end, vim.tbl_extend(
            "force",
            keymap_opts,
            { buffer = event.buf, desc = "Format Lua buffer with StyLua" }
        ))

        map(
            "n",
            "g<CR>",
            "<cmd>!love src<CR>",
            vim.tbl_extend("force", keymap_opts, {
                buffer = event.buf,
                desc = "Run Love2D project",
            })
        )
    end,
})

-- Folds

vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- ------------------------------------------------------------------------
-- Plugin-specific configuration blocks (ported directly from Vimscript).
-- ------------------------------------------------------------------------

g.ackprg = "ag --vimgrep"
g.lsp_diagnostics_echo_cursor = 1

-- ---------- LSP configuration ------------------------------------------------

-- local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lua_workspace_library = api.nvim_get_runtime_file("", true)
local love_types_path = fn.stdpath("data") .. "/lazy/neodev.nvim/types/love"
if vim.loop.fs_stat(love_types_path) then
    table.insert(lua_workspace_library, love_types_path)
end

local neodev_before_init
do
    local ok, neodev_lsp = pcall(require, "neodev.lsp")
    if ok and type(neodev_lsp) == "table" and neodev_lsp.before_init then
        neodev_before_init = neodev_lsp.before_init
    end
end

vim.lsp.config("*", {
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = cmp_nvim_lsp.default_capabilities(),
})

local lua_ls_config = {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            completion = {
                callSnippet = "Replace",
            },
            diagnostics = {
                globals = { "vim", "require", "love" },
            },
            workspace = {
                checkThirdParty = false,
                library = lua_workspace_library,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

if neodev_before_init then
    lua_ls_config.before_init = neodev_before_init
end

local lsps = {
    {
        "ts_ls",
        {
            root_markers = { "tsconfig.json", "package.json" },
            single_file_support = false,
            settings = {
                typescript = {
                    suggest = {
                        autoImports = true,
                        preferTypeOnlyAutoImports = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
                javascript = {
                    suggest = {
                        autoImports = true,
                        includeCompletionsForModuleExports = true,
                    },
                },
            },
            init_options = {
                preferences = {
                    includePackageJsonAutoImports = "on",
                    quotePreference = "double",
                    preferTypeOnlyAutoImports = true,
                },
            },
        },
    },
    { "cssls" },
    { "eslint" },
    { "graphql" },
    { "html" },
    { "lua_ls", lua_ls_config },
}

for _, lsp in pairs(lsps) do
    local name, config = lsp[1], lsp[2]
    if config then
        vim.lsp.config(name, config)
    end
    vim.lsp.enable(name)
end

-- ---------- Completion configuration (nvim-cmp) ------------------------------

opt.completeopt = { "menu", "menuone", "noselect" }

require("luasnip.loaders.from_vscode").lazy_load()

local cmp = require("cmp")
local luasnip = require("luasnip")

local select_opts = { behavior = cmp.SelectBehavior.Insert }

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "path" },
        { name = "nvim_lsp", keyword_length = 3 },
        { name = "buffer", keyword_length = 3 },
        { name = "luasnip", keyword_length = 2 },
    },
    window = {
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = "λ",
                luasnip = "φ",
                buffer = "β",
                path = "δ",
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = {
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),

        ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
        ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        ["<C-d>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<C-b>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            local col = fn.col(".") - 1

            if cmp.visible() then
                cmp.select_next_item(select_opts)
            elseif col == 0 or fn.getline("."):sub(col, col):match("%s") then
                fallback()
            else
                cmp.complete()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item(select_opts)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<Right>"] = cmp.mapping(function(fallback)
            cmp.mapping.abort()
            local copilot_keys = fn["copilot#Accept"]()
            if copilot_keys ~= "" then
                api.nvim_feedkeys(copilot_keys, "i", true)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
})

-- ---------- Treesitter -------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})

-- ---------- Telescope + Harpoon ----------------------------------------------

local telescope = require("telescope")
telescope.setup({
    defaults = {
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
        },
        file_ignore_patterns = {
            "node_modules",
            ".git/",
            "%.lock",
            "%.sqlite3",
            "%.ipynb",
            "%.png",
            "%.jpg",
            "%.jpeg",
            "%.otf",
            "%.ttf",
            "%.webp",
            "%.gif",
            "%.pdf",
            "%.dmg",
            "%.zip",
            "%.tar",
            "%.gz",
            "%.rar",
            "%.7z",
            "%.mp4",
            "%.mp3",
            "%.mov",
            "%.avi",
            "%.wmv",
            "%.flv",
            "%.mkv",
            "%.exe",
            "%.dll",
            "%.ogg",
            "%.pxd",
        },
    },
    extensions = {
        file_browser = {
            hijack_netrw = true,
            dir_icon = "",
        },
    },
})

telescope.load_extension("file_browser")

local harpoon = require("harpoon")
harpoon:setup({})

map("n", "<leader>a", function()
    harpoon:list():add()
end, { desc = "Add file to Harpoon list" })

local telescope_config = require("telescope.config").values
local function toggle_harpoon_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Harpoon",
            finder = require("telescope.finders").new_table({
                results = file_paths,
            }),
            previewer = telescope_config.file_previewer({}),
            sorter = telescope_config.generic_sorter({}),
        })
        :find()
end

map("n", "<C-y>", function()
    toggle_harpoon_telescope(harpoon:list())
end, { desc = "Open Harpoon files in Telescope" })

map("n", "<C-p>", function()
    require("telescope.builtin").git_files()
end, { desc = "Search git files" })

map("n", "<C-o>", function()
    telescope.extensions.file_browser.file_browser()
end, { desc = "Open Telescope file browser" })

map("n", "<C-b>", function()
    require("telescope.builtin").buffers()
end, { desc = "List open buffers" })

map("n", "<C-e>", function()
    require("telescope.builtin").diagnostics({ bufnr = 0 })
end, { desc = "Show diagnostics for current buffer" })

map("n", "<C-g>", function()
    require("telescope.builtin").live_grep()
end, { desc = "Global ripgrep search" })

map("n", "<C-a>", function()
    require("telescope.builtin").lsp_document_symbols()
end, { desc = "List LSP document symbols" })

-- ---------- Expand region ----------------------------------------------------

map("x", "v", "<Plug>(expand_region_expand)", { desc = "Expand selection", silent = true })
map("x", "<C-v>", "<Plug>(expand_region_shrink)", { desc = "Shrink selection", silent = true })

-- ---------- LuaLine ----------------------------------------------------------

require("lualine").setup({
    options = { section_separators = "", component_separators = "" },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            {
                "diagnostics",
                sections = { "error", "warn" },
                symbols = { error = "●", warn = "◇", info = "†", hint = "‡" },
                always_visible = true,
            },
        },
        lualine_c = { "filename" },

        lualine_x = { "encoding" },
        lualine_y = { "filetype" },
        lualine_z = { "location" },
    },
})

-- ---------- Autopairs --------------------------------------------------------

require("nvim-autopairs").setup({})

-- ---------- Trouble ----------------------------------------------------------

require("trouble").setup({
    fold_open = "v",
    fold_closed = ">",
    indent_lines = false,
    signs = {
        error = "●",
        warning = "◇",
        information = "†",
        hint = "‡",
    },
    use_diagnostic_signs = false,
    auto_preview = false,
})

-- ---------- Git blame --------------------------------------------------------

require("gitblame").setup({
    enabled = false,
})

-- ---------- Substitute -------------------------------------------------------

require("substitute").setup()

map("n", "s", require("substitute").operator, { noremap = true, desc = "Substitute operator" })
map("n", "ss", require("substitute").line, { noremap = true, desc = "Substitute current line" })
map("n", "S", require("substitute").eol, { noremap = true, desc = "Substitute to line end" })
map("x", "s", require("substitute").visual, { noremap = true, desc = "Substitute selection" })

-- ---------- Oil ----------------------------------------------------------------

require("oil").setup({
    use_default_keymaps = false,
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<cr>"] = "actions.select",
        ["<c-m>"] = "actions.preview",
        ["<c-c>"] = { "actions.close", mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    view_options = {
        show_hidden = true,
        natural_order = "fast",
        case_insensitive = false,
        sort = {
            { "type", "asc" },
            { "name", "asc" },
        },
    },
})
