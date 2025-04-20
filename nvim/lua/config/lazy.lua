local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- import/override with your plugins
    { import = "plugins" },
    -- Add ERB and Ruby related plugins
    { "vim-ruby/vim-ruby", ft = { "ruby", "eruby" } },
    { "tpope/vim-rails", ft = { "ruby", "eruby" } },
    { "tpope/vim-endwise", ft = { "ruby", "eruby" } },
    { "tpope/vim-surround", ft = { "ruby", "eruby" } },
    { "othree/html5.vim", ft = { "html", "eruby" } },
    { "pangloss/vim-javascript", ft = { "javascript", "eruby" } },
    { "leafgarland/typescript-vim", ft = { "typescript", "eruby" } },
    { "HerringtonDarkholme/yats.vim", ft = { "typescript", "eruby" } },
    -- Add generic folding support
    { "tmhedberg/SimpylFold", ft = { "eruby", "ruby" } },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Enable ERB folding
vim.cmd([[
  autocmd FileType eruby setlocal foldmethod=indent
]])

require("telekasten").setup({
  home = vim.fn.expand("~/Notes"), -- Put the name of your notes directory here
  extension = "", -- Set this to an empty string to prevent appending `.md`
  media_extension = { "png", "jpg" }, -- Optional: define image extensions
  take_over_my_home = false,
  auto_set_filetype = false,
  find_command = "rg --files --glob '*.rb' --glob '*.md' --glob '*.txt' --glob '*.json'", -- Include extensions
  -- Allow searching through specific extensions
  search_scope = {
    file_extensions = { "rb", "md", "txt", "json" }, -- Add extensions you want to include
  },
})
