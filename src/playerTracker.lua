--[[

	The player tracker class.
	Checks if any controllable players exist or not.
	Hooks up player input managers to each individual player.

--]]


-- Load modules.
local playerInputManager = require("src.playerInputManager")


-- Create the class.
local PlayerTracker = Class(
	"Player Tracker",
	{
		-- The maximum number of player slots to check for.
		-- If it is possible to have more than 4, let me know.
		-- 8 player spelunky sounds fucking awesome.
		maxPlayerSlots = 4,
		
		-- Used to store all player input managers.
		-- Player indexes correspond to the player slot.
		playerInputManagers = {}
	}
)


-- Function to check if the screen allows for controlling the player.
function PlayerTracker:isValidScreen()

	local validScreen = (
		state.screen == SCREEN.CAMP or
		state.screen == SCREEN.LEVEL or
		state.screen == SCREEN.ARENA_LEVEL
	)

	-- If the screen is valid, return true.
	return validScreen

end


-- Track players.
function PlayerTracker:track()


	-- If the current screen is invalid.
	if not self:isValidScreen() then
	
		-- Destroy all player input managers.
		for _, playerInputManager in ipairs(self.playerInputManagers) do
			playerInputManager:destroy()
		end
		
		-- Clear the player input manager table.
		self.playerInputManagers = {}
		
		-- We don't need to track any players, so return.
		return
		
	end
	

	-- Iterate through all possible player slots.
	for playerSlot = 1, self.maxPlayerSlots do
		
		-- Attempt to look up the player.
		local player = players[playerSlot]
		
		
		if player then
			-- If a controllable player is found for this slot.
		
			-- If there is no input manager for this player slot, create one.
			if not self.playerInputManagers[playerSlot] then
				self.playerInputManagers[playerSlot] = playerInputManager(playerSlot)
			end
			
			-- Update the player input manager.
			self.playerInputManagers[playerSlot]:update()
		
		else
			-- If no controllable player is found for this slot.
		
			-- If an input manager exists for this player slot, destroy it.
			if self.playerInputManagers[playerSlot] then
				self.playerInputManagers[playerSlot]:destroy()
				self.playerInputManagers[playerSlot] = nil
			end
		
		end
		
	end


end


-- Call the draw function on each individual player input manager.
function PlayerTracker:draw(renderCtx)

	for _, playerInputManager in ipairs(self.playerInputManagers) do
		playerInputManager:draw(renderCtx)
	end

end


return PlayerTracker
