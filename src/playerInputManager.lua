--[[

	The player input manager class.
	Checks a single player's inputs.
	Instances of this class should not be called when the player is invalid.

--]]


-- Load modules.
local EmoteMenu = require("src.emoteMenu")
local EmoteBubble = require("src.emoteBubble")


-- Create the class.
local PlayerInputManager = Class(
	"Player Input Manager",
	{
		-- What player this input manager will handle.
		playerSlot = nil,
		
		-- Used for storing the current and previous frames' inputs.
		input = nil,
		inputPrevious = nil,
		
		-- Used for storing the emote menu.
		emoteMenu = nil,
		
		-- Used for storing the emote popup.
		emoteBubble = nil,
		
		-- Button for opening the emote menu.
		emoteMenuButton = INPUTS.DOOR,
		
	}
)


-- Constructor.
function PlayerInputManager:init(playerSlot)

	-- The player slot this input manager is dedicated to.
	self.playerSlot = playerSlot

end


-- Destructor.
function PlayerInputManager:destroy()
	
	-- Unused, but could come in handy.
	
end


-- Used to check if a player has the required amount of control for inputs to be received.
function PlayerInputManager:playerHasControl()
	
	local validState = (
		players[self.playerSlot].state ~= CHAR_STATE.ENTERING and
		players[self.playerSlot].state ~= CHAR_STATE.EXITING and
		players[self.playerSlot].state ~= CHAR_STATE.LOADING
	)
	
	local isNotDead = test_flag(players[self.playerSlot].flags, ENT_FLAG.DEAD) == false
	
	-- Return true if everything is valid.
	return (validState and isNotDead)

end


-- Used to check if a player is holding movement inputs.
function PlayerInputManager:playerInputMoving()
	
	local directional = (
		test_mask(self.inputPrevious, INPUTS.LEFT) or
		test_mask(self.inputPrevious, INPUTS.RIGHT) or
		test_mask(self.inputPrevious, INPUTS.UP) or
		test_mask(self.inputPrevious, INPUTS.DOWN)
	)
	
	-- Return true if directional input has been found.
	return directional

end


-- Function to update inputs from this player.
-- Called by the regular update function.
function PlayerInputManager:updateInput()

	-- Update the previous input to the current one.
	self.inputPrevious = self.input
	
	-- Get and update the current input.
	self.input = players[self.playerSlot].input.buttons_gameplay
	
	-- On the first frame, previous input might still be nil.
	-- We will just set it to the current one, as if it was already held.
	if not self.inputPrevious then
		self.inputPrevious = self.input
	end

end


-- Create/Update the emote bubble.
-- Called by the regular update function.
function PlayerInputManager:updateEmoteBubble()

	if self.emoteBubble then
		-- If an emote bubble exists.
		
		-- Update it.
		self.emoteBubble:update()
		
		
		-- Check if it should be destroyed, then destroy.
		if self.emoteBubble.shouldBeDestroyed then
			self.emoteBubble = nil
		end
		
	end

end



-- Create/Update the emote menu.
-- Called by the regular update function.
function PlayerInputManager:updateEmoteMenu()

	if self.emoteMenu then
		-- If an emote menu exists.
		
		
		-- Update it.
		self.emoteMenu:update(self.input, self.inputPrevious)
		
		
		-- If we aren't pressing the door button anymore.
		if not test_mask(self.inputPrevious, self.emoteMenuButton) then
		

			local emoteDef = self.emoteMenu:getSelection()
			
			
			-- If it's a valid emote defenition, and the player isn't moving.
			if emoteDef and not self:playerInputMoving() then
			
				-- Create the emote bubble!
				self.emoteBubble = EmoteBubble(emoteDef)
			
			end
		
			-- We're done here.
			-- Destroy the emote menu.
			self.emoteMenu = nil
			
		end
		
		
	else
		-- If no emote menu exists.
		
		
		-- If we pressed the door button.
		if test_mask(self.input, self.emoteMenuButton)
		and not test_mask(self.inputPrevious, self.emoteMenuButton) then
		
			-- If the player is not inputting any movement.
			if not self:playerInputMoving() then
			
				-- Create the emote menu.
				self.emoteMenu = EmoteMenu()
				
			end
			
		end
		
		
	end
	

end


-- Update the inputs.
function PlayerInputManager:update()

	-- Update the inputs.
	self:updateInput()

	if self:playerHasControl() then
		-- If the player has control.
		
		
		-- Handle the emote menu.
		self:updateEmoteMenu()
		self:updateEmoteBubble()
	
	
	else
		-- If the player does not have control.
		
		
		-- Destroy the emote menu and/or bubble.
		self.emoteMenu = nil
		self.emoteBubble = nil
		
		
	end

end


-- Call the draw function on the emote menu.
function PlayerInputManager:draw(renderCtx)

	-- Double check if a player exists.
	if players[self.playerSlot] then
	
		-- If an emote bubble exists.
		if self.emoteBubble then
			self.emoteBubble:draw(renderCtx, players[self.playerSlot])
		end

		-- If the menu is open.
		if self.emoteMenu then
			self.emoteMenu:draw(renderCtx, players[self.playerSlot])
		end
	
	end

end


return PlayerInputManager
