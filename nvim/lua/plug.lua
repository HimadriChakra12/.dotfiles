-- /lua/..
require('keybindings')
require('netwr')

-- /pack/..
require('telescope').setup{}
require('neogit').setup{}
require('buffer-manager').setup{}

-- /lua/statusline..
require("status.theme")
require("status.style")

-- /lua/startup..
require("startups.startup4")
require("startups.startup1")

-- /lua/plugins..
--require("plugins.shell")
require('plugins.pcmp').setup()
require("plugins.bufshift")
-- require("plugins.tree") --[Replaced with explorer.lua]
require("plugins.explo")
require("plugins.zox").setup() 
require("plugins.termim").setup()

-- require("plugins.zoxvim").setup() --[Replaced with zox.lua]
-- require("plugins.ff") [Replaced by telescope.nvim]
-- require("plugins.explorer")
-- require("scope").setup() [Replaced with telescope.nvim]
