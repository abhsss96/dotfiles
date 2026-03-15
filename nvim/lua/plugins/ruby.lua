return {
  "vim-ruby/vim-ruby",
  ft = { "ruby", "eruby" },
  config = function()
    -- Enable Ruby folding
    vim.g.ruby_fold = 1
    vim.g.ruby_foldable_groups = 'def class module if describe context it before after around'
    
    -- Set filetype detection for Ruby files (not ERB)
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      pattern = {"*.rb", "*.ruby", "*.rake", "*.gemspec", "*.ru", "Gemfile", "Rakefile", "Vagrantfile", "*_spec.rb", "spec/**/*.rb"},
      callback = function()
        vim.bo.filetype = "ruby"
      end,
    })
    
    -- Set filetype detection for ERB files
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
      pattern = {"*.erb", "*.html.erb", "*.js.erb", "*.xml.erb"},
      callback = function()
        vim.bo.filetype = "eruby"
      end,
    })
    
    -- Configure ERB files for proper syntax highlighting
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "eruby",
      callback = function()
        -- Enable syntax highlighting
        vim.cmd('syntax enable')
        vim.cmd('syntax on')
        
        -- Set proper indentation
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true
        
        -- Enable folding
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldlevel = 1
        vim.opt_local.foldenable = true
      end,
    })
    
    -- Set foldmethod for Ruby files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "ruby",
      callback = function()
        -- Ensure syntax highlighting is enabled
        vim.cmd('syntax enable')
        vim.cmd('syntax on')
        
        -- Try different folding methods in sequence until one works
        local function try_folding_methods()
          -- First try syntax-based folding
          vim.opt_local.foldmethod = "syntax"
          vim.opt_local.foldlevel = 1
          vim.opt_local.foldnestmax = 3
          vim.opt_local.foldenable = true
          
          -- Force fold update
          vim.cmd('normal zx')
          
          -- Check if folds were created
          if vim.fn.foldlevel(1) == 0 then
            -- If no folds, try indent-based folding
            vim.opt_local.foldmethod = "indent"
            vim.cmd('normal zx')
            
            if vim.fn.foldlevel(1) == 0 then
              -- If still no folds, try marker-based folding
              vim.opt_local.foldmethod = "marker"
              vim.opt_local.foldmarker = "{{{,}}}"
              vim.cmd('normal zx')
            end
          end
        end
        
        -- For large files, try all methods
        if vim.fn.line('$') > 1000 then
          try_folding_methods()
        else
          -- For smaller files, just use syntax-based folding
          vim.opt_local.foldmethod = "syntax"
          vim.opt_local.foldlevel = 1
          vim.opt_local.foldnestmax = 3
          vim.opt_local.foldenable = true
          vim.cmd('normal zx')
        end
      end,
    })

    -- Additional Ruby settings
    vim.g.ruby_indent_access_modifier_style = "indent"
    vim.g.ruby_indent_block_style = "do"
    vim.g.ruby_indent_assignment_style = "variable"
    
    -- Ensure syntax highlighting is loaded
    vim.cmd('packadd vim-ruby')
  end,
}
