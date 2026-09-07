hl.workspace_rule({
	workspace = "special:music",
	layout = "monocle",
})

hl.workspace_rule({
	workspace = "special:communication",
	layout = "monocle",
})

hl.window_rule({
	match = {
		class = "dev.aunetx.deezer",
	},
	workspace = "special:music",
})

hl.window_rule({
	match = {
		class = "vesktop|discord",
	},
	workspace = "special:communication",
})

package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")

smw.setup({
	workspace_count = 5, -- This will create 5 persistent workspaces on each monitor at startup
})

local mainMod = "SUPER"
for i = 1, smw.get_amount_of_workspaces() do
	local n = tostring(i)
	if n == "10" then
		n = "0"
	end
	-- Switch to the Nth workspace on the currently focused monitor.
	hl.bind(mainMod .. " +" .. n, smw.workspace(n))
	-- Move the active window to the Nth workspace on the currently focused monitor silently (no focus change).
	hl.bind(mainMod .. " + SHIFT +" .. n, smw.move_to_workspace(n))
end
