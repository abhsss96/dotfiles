-- Fix for mason-lspconfig.mappings module not found error
-- This provides the missing get_mason_map function that LazyVim expects
-- This preload hook will be called when LazyVim tries to require the module

-- Set up the preload hook immediately so it's available when needed
package.preload["mason-lspconfig.mappings"] = function()
  -- Try to load the actual modules
  local ok_server, server = pcall(require, "mason-lspconfig.mappings.server")
  local ok_filetype, filetype = pcall(require, "mason-lspconfig.mappings.filetype")
  local ok_language, language = pcall(require, "mason-lspconfig.mappings.language")
  
  local M = {}
  
  if ok_server then
    function M.get_mason_map()
      return {
        lspconfig_to_package = server.lspconfig_to_package,
        package_to_lspconfig = server.package_to_lspconfig,
      }
    end
    
    M.server = server
  else
    -- Fallback if server module isn't available yet
    function M.get_mason_map()
      return {
        lspconfig_to_package = {},
        package_to_lspconfig = {},
      }
    end
  end
  
  if ok_filetype then
    M.filetype = filetype
  end
  
  if ok_language then
    M.language = language
  end
  
  return M
end
