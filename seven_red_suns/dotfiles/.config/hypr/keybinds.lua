---- Special Workspaces ----
local function open_music_space()
	local win = hl.get_window("class:dev.aunetx.deezer")
	if not win then
		hl.exec_cmd("deezer-desktop")
	end

	hl.dispatch(hl.dsp.workspace.toggle_special("music"))
end

local function open_communication_space()
	local vesktop = hl.get_window("vesktop")
	local discord = hl.get_window("discord")
	local ws = hl.get_active_special_workspace()

	if ws == nil then
		if not discord then
			hl.exec_cmd("discord")
		end
		if not vesktop then
			hl.exec_cmd("vesktop")
		end
	end

	hl.dispatch(hl.dsp.workspace.toggle_special("communication"))
end

hl.bind(mainMod .. " + SHIFT + M", open_music_space)
hl.bind(mainMod .. " + CTRL + M", hl.dsp.exec_cmd("pkill -f 'deezer'"))

hl.bind(mainMod .. " + SHIFT + D", open_communication_space)
hl.bind(mainMod .. " + CTRL + D", hl.dsp.exec_cmd("pkill -f 'discord|vesktop'"))

-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

---- Noctalia ----
local ipc = "noctalia msg "

hl.bind(mainMod .. "+Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"), { description = "launcher" })
hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. "+comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(mainMod .. "+Return", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. "+B", hl.dsp.exec_cmd(ipc .. "bar-toggle"))
hl.bind(mainMod .. "+ESCAPE", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
-- hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))
-- hl.bind("ALT + Tab", hl.dsp.focus({ last = true }), { description = "go to last focused window" })

---- Screenshot ----
hl.bind(mainMod .. "+ SHIFT + S", hl.dsp.exec_cmd(ipc .. "screenshot-region"), { description = "screenshot region" })
hl.bind(
	mainMod .. "+ CTRL + S",
	hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen"),
	{ description = "fullscreen screenshot of the current monitor" }
)

-- media keys
hl.bind("xf86audioraisevolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("xf86audiolowervolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("xf86audiomute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
hl.bind("xf86monbrightnessup", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("xf86monbrightnessdown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

---- Other ----
hl.bind(mainMod .. "+ SHIFT + F", hl.dsp.window.fullscreen("fullscreen", "toggle"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(terminal))

local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

hl.bind(
	mainMod .. "+ SHIFT + ESCAPE",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"),
	{ description = "exit hyprland" }
)

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "toggle float mode" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. "+ SHIFT + N", hl.dsp.exec_cmd("kitty -d ~/vimwiki --hold sh -c 'nvim -c VimwikiIndex'"))

-- Monocle layout
hl.bind(mainMod .. " + H", function()
	local active_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
	if active_ws.tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cycleprev"))
	end
end)

hl.bind(mainMod .. " + L", function()
	local active_ws = hl.get_active_special_workspace() or hl.get_active_workspace()
	if active_ws.tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cyclenext"))
	end
end)

-- MOVE FOCUS
local function focus_monitor(opts)
	return function()
		local monitor = hl.get_active_monitor()
		local monitor_nb = #hl.get_monitors()

		if monitor == nil then
			hl.dispatch(hl.dsp.exec_cmd("notify-send 'get_active_monitor() is not working properly'"))
		elseif opts.direction == "left" then
			local monitor_to_focus = (monitor.id - 1) % monitor_nb
			if opts.wrap == false and monitor.id == 0 then
				monitor_to_focus = 0
			end
			hl.dispatch(hl.dsp.focus({ monitor = monitor_to_focus }))
		elseif opts.direction == "right" then
			local monitor_to_focus = (monitor.id + 1) % monitor_nb
			if opts.wrap == false and monitor.id == monitor_nb - 1 then
				monitor_to_focus = monitor_nb - 1
			end
			hl.dispatch(hl.dsp.focus({ monitor = monitor_to_focus }))
		end
	end
end

local function focus(opts)
	return function()
		local monitor = hl.get_active_monitor()

		hl.dispatch(hl.dsp.focus({ direction = opts.direction }))
		if monitor ~= hl.get_active_monitor() then
			if opts.direction == "left" then
				hl.dispatch(hl.dsp.focus({ direction = "right" }))
			elseif opts.direction == "right" then
				hl.dispatch(hl.dsp.focus({ direction = "left" }))
			end
		end
	end
end

hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + h", focus({ direction = "left" }))
hl.bind(mainMod .. " + l", focus({ direction = "right" }))
hl.bind(mainMod .. "+ CTRL + h", focus_monitor({ direction = "left", wrap = false }))
hl.bind(mainMod .. "+ CTRL + l", focus_monitor({ direction = "right", wrap = false }))
hl.bind(mainMod .. "+ CTRL + SHIFT + h", hl.dsp.window.move({ monitor = "0" }))
hl.bind(mainMod .. "+ CTRL + SHIFT + l", hl.dsp.window.move({ monitor = "1" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- for i = 1, 10 do
-- 	local key = i % 10 -- 10 maps to key 0
-- 	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
-- 	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
-- end


-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- LAYOUTS

local function layout_bind(bind_table)
	return function()
		local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()

		if not workspace then
			return
		end

		local layout = workspace.tiled_layout

		if bind_table[layout] then
			hl.dispatch(bind_table[layout])
		end
	end
end

hl.bind(
	"SUPER + SHIFT + H",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol l"), -- Scrolling: swap column with left one
		monocle = hl.dsp.layout("cycleprev"), -- Monocle and master: cycle prev window
		master = hl.dsp.layout("cycleprev"),
	})
)

hl.bind(
	"SUPER + SHIFT + L",
	layout_bind({
		scrolling = hl.dsp.layout("swapcol r"), -- Scrolling: swap column with right one
		dwindle = hl.dsp.layout("togglesplit"), -- Dwindle: toggle window split
		monocle = hl.dsp.layout("cyclenext"), -- Monocle and master: cycle next window
		master = hl.dsp.layout("cyclenext"),
	})
)

hl.bind(mainMod .. "+ R", hl.dsp.layout("colresize -conf"), { description = "cycle column size" })
hl.bind(mainMod .. "+ SHIFT + R", hl.dsp.layout("colresize +conf"), { description = "cycle column size" })
hl.bind(mainMod .. "+ F", hl.dsp.layout("colresize 1.0"))

---- Toggle animations ----
hl.bind("SUPER + F1", function()
	local game_mode = (hl.get_config("animations.enabled") == false)

	if game_mode then
		hl.exec_cmd("hyprctl reload")
		return
	end

	hl.config({
		general = {
			gaps_in = 0,
			gaps_out = 0, -- Disable gaps
			border_size = 0,
		},

		animations = {
			enabled = false, -- Disable animations
		},

		-- Disable blur, shadow and window rounding
		decoration = {
			shadow = { enabled = false },
			blur = { enabled = false },
			rounding = 0,
		},
	})
end)

---- Cycle workspace layout ----
hl.bind("SUPER + tab", function()
	local layouts = { "scrolling", "dwindle", "master", "monocle" }
	local workspace = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end

	local next_layout = "dwindle"

	if not workspace then
		return
	end

	for i = 1, #layouts do
		if layouts[i] == workspace.tiled_layout then
			local next_layout_idx = (i % #layouts) + 1
			next_layout = layouts[next_layout_idx]
			break
		end
	end

	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
end)
