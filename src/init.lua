--[[

	The entry point of the mod.
	Callbacks are set up here.

--]]


-- Load libraries (globally)
Class = require("lib.30log")


-- Load modules.
local PlayerTracker = require("src.PlayerTracker")


-- Used to store the main player tracker.
local playerTracker = nil


-- When the mod first loads.
local function onLoad()

	-- Create an instance of PlayerTracker.
	playerTracker = PlayerTracker()

end


-- On every in-game frame.
local function onGameFrame()

	-- Update the player tracker.
	playerTracker:track()

end


-- When the game gets drawn.
local function onDraw(renderCtx, depth)

	-- We only need depth 1.
	if depth ~= 1 then
		return
	end

	-- Call draw on the player tracker.
	playerTracker:draw(renderCtx)

end


-- Hook up each function to their corresponding callback(s).
set_callback(onLoad, ON.LOAD)
set_callback(onGameFrame, ON.GAMEFRAME)
set_callback(onDraw, ON.RENDER_POST_DRAW_DEPTH)


