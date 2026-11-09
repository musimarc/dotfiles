-- Swayimg 5.5+ quicklook configuration.
-- Keep image paths in Lua and shell-quote them before calling external tools;
-- do not interpolate Swayimg's % placeholder into an exec shell command.

swayimg.overlay = true
swayimg.text.visible = false
swayimg.imagelist.adjacent = true
swayimg.imagelist.order = "alpha"
swayimg.imagelist.fsmon = false
swayimg.viewer.preload = 2
swayimg.viewer.history = 3

local home = os.getenv("HOME")
local thunar_con_id = os.getenv("QUICKLOOK_THUNAR_CON_ID")

local function shell_quote(value)
	return "'" .. value:gsub("'", "'\\''") .. "'"
end

local function run_with_path(program, path, extra)
	local command = shell_quote(home .. "/.local/bin/" .. program)
	if extra then
		command = command .. " " .. extra
	end
	return os.execute(command .. " " .. shell_quote(path))
end

swayimg.viewer.on_key("up", function()
	swayimg.viewer.open("prev")
end)

swayimg.viewer.on_key("down", function()
	swayimg.viewer.open("next")
end)

swayimg.viewer.on_key("Delete", function()
	local image = swayimg.viewer.get_image()
	if not image then
		return
	end

	local ok = run_with_path("quicklook-trash", image.path)
	if ok then
		local opened = swayimg.viewer.open("next")
		swayimg.imagelist.remove(image.path)
		if not opened then
			swayimg.exit()
		end
	end
end)

swayimg.viewer.on_key("Shift+Delete", function() end)

swayimg.viewer.on_key("Escape", function()
	local image = swayimg.viewer.get_image()
	if image and thunar_con_id and thunar_con_id:match("^%d+$") then
		run_with_path("thunar-select", image.path, thunar_con_id)
	end
	swayimg.exit()
end)
