-- Load editor configurations
local editor = require("config.editor")
editor.setup()

-- Load mason-lspconfig fix early
require("config.mason-fix") 