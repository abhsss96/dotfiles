-- lua/plugins.lua or your equivalent plugins file

return {
  -- Rails core plugins
  { "tpope/vim-rails" },
  { "tpope/vim-endwise" },
  { "tpope/vim-haml" },
  { "othree/html5.vim" },
  
  -- Additional useful plugins
  { "tpope/vim-bundler" },  -- Bundler integration
  { "tpope/vim-dispatch" }, -- Asynchronous build and test dispatcher
  { "tpope/vim-fugitive" }, -- Git integration
  { "tpope/vim-rbenv" },   -- rbenv integration
  { "tpope/vim-rake" },    -- Rake integration
  
  -- Testing plugins
  { "janko/vim-test" },    -- Test runner
  
  config = function()
    -- Rails specific settings
    vim.g.rails_projections = {
      ["app/models/*.rb"] = {
        alternate = "spec/models/{}_spec.rb",
        type = "model"
      },
      ["app/controllers/*.rb"] = {
        alternate = "spec/controllers/{}_spec.rb",
        type = "controller"
      },
      ["app/views/*.erb"] = {
        alternate = "spec/views/{}.erb_spec.rb",
        type = "view"
      }
    }

    -- Key mappings for Rails
    vim.keymap.set('n', '<leader>rr', ':Rake<CR>', { desc = 'Run Rake task' })
    vim.keymap.set('n', '<leader>rg', ':Rgenerate<CR>', { desc = 'Rails generate' })
    vim.keymap.set('n', '<leader>rd', ':Rdestroy<CR>', { desc = 'Rails destroy' })
    vim.keymap.set('n', '<leader>rs', ':Rserver<CR>', { desc = 'Start Rails server' })
    vim.keymap.set('n', '<leader>rc', ':Rconsole<CR>', { desc = 'Start Rails console' })
    vim.keymap.set('n', '<leader>rt', ':Rtest<CR>', { desc = 'Run Rails test' })
    
    -- Test runner configuration
    vim.g['test#strategy'] = 'dispatch'
    vim.g['test#ruby#rspec#executable'] = 'bundle exec rspec'
    
    -- Enable Rails file type detection (Ruby files only, not ERB)
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      pattern = {
        "*.rb", "*.ruby", "*.rake", "*.gemspec", "*.ru",
        "Gemfile", "Rakefile", "Vagrantfile",
        "*_spec.rb", "spec/**/*.rb", "config/**/*.rb",
        "app/**/*.rb", "lib/**/*.rb"
      },
      callback = function()
        vim.bo.filetype = "ruby"
      end,
    })
    
    -- ERB files should be detected as eruby (handled by vim-ruby)
    -- This ensures proper syntax highlighting for embedded Ruby in HTML
  end
}
