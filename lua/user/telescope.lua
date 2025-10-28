local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require("telescope.actions")

local default_mappings = {
  i = {
    ["<Tab>"] = actions.move_selection_next,
    ["<S-Tab>"] = actions.move_selection_previous,
    ["<C-c>"] = actions.close,
    ["<CR>"] = actions.select_default,
    ["<C-d>"] = require("telescope.actions").delete_buffer,
  },

  n = {
    ["<esc>"] = actions.close,
    ["<CR>"] = actions.select_default,
    ["<Tab>"] = actions.move_selection_next,
    ["<S-Tab>"] = actions.move_selection_previous,
  },
}

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },

    file_ignore_patterns = {
      ".git/",
      "target/",
      "docs/",
      "%.lock",
      "__pycache__/*",
      "%.sqlite3",
      "%.ipynb",
      "node_modules/*",
      "%.jpg",
      "%.jpeg",
      "%.png",
      "%.svg",
      "%.otf",
      "%.ttf",
      "%.webp",
      ".dart_tool/",
      ".github/",
      ".gradle/",
      ".idea/",
      ".settings/",
      ".vscode/",
      "__pycache__/",
      "build/",
      "%.env/",
      "gradle/",
      "node_modules/",
      "%.pdb",
      "%.dll",
      "%.class",
      "%.exe",
      "%.cache",
      "%.ico",
      "%.pdf",
      "%.dylib",
      "%.jar",
      "%.docx",
      "%.met",
      "smalljre_*/*",
      ".vale/",
      "%.burp",
      "%.mp4",
      "%.mkv",
      "%.rar",
      "%.zip",
      "%.7z",
      "%.tar",
      "%.bz2",
      "%.epub",
      "%.flac",
      "%.tar.gz",
    },

    mappings = {
      i = {
        ["<S-Tab>"] = actions.move_selection_next,
        ["<Tab>"] = actions.move_selection_previous,
        ["<C-c>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-d>"] = require("telescope.actions").delete_buffer,
      },

      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<Tab>"] = actions.move_selection_next,
        ["<S-Tab>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    live_grep = {
      theme = "ivy",
      mappings = default_mappings,
    },
    find_files = {
      theme = "dropdown",
      previewer = false,
      hidden = true,
      mappings = default_mappings,
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
      mappings = default_mappings,
    },
    planets = {
      show_pluto = true,
      show_moon = true,
    },
    colorscheme = {},
    lsp_references = {
      theme = "dropdown",
      initial_mode = "normal",
    },
    lsp_definitions = {
      theme = "dropdown",
      initial_mode = "normal",
    },
    lsp_declarations = {
      theme = "dropdown",
      initial_mode = "normal",
    },
    lsp_implementations = {
      theme = "dropdown",
      initial_mode = "normal",
    },
  },
})
