--[[

	The emote menu class.

--]]


-- Load modules.
local EmoteMenuLayout = require("src.emoteMenuLayout")
local Sprite = require("src.sprite")
local aabbHelper = require("src.aabbHelper")


-- Create the class.
local EmoteMenu = Class(
	"Emote Menu",
	{
		-- If the menu should be hidden, used for online players.
		hidden = false,
		
		time = 0, -- Used for tracking how long the object exists, in seconds.
		timeToHold = 0.15, -- How long to hold before fading in.
		fadeTime = 0.1, -- How long the fade-in takes.
		fading = false,
		
		-- The opacity to render at, used for the fade-in effect.
		opacity = 0,
		
		-- The current selection.
		selection = {
			x = EmoteMenuLayout.start.x,
			y = EmoteMenuLayout.start.y
		},
		selectionMoved = false,
		
		-- The visual selection.
		-- Purely used for juicing up the menu a little.
		selectionVisual = {
			x = EmoteMenuLayout.start.x,
			y = EmoteMenuLayout.start.y
		},
		selectionVisualLerp = 0.66,
		
		-- The menu sprite and quad.
		menuSprite = Sprite("img/emoteMenu.png", 600, 400),
		menuAABB = AABB:new(
			-EmoteMenuLayout.size.x / 2,
			EmoteMenuLayout.size.y / 2,
			EmoteMenuLayout.size.x / 2,
			-EmoteMenuLayout.size.y / 2
		):extrude(0.5),
		
		-- The emote selector.
		emoteSelectorSprite = Sprite("img/emoteSelector.png", 200, 200)
		
	}
)


-- Update the selection, move based on input.
function EmoteMenu:updateSelection(input, inputPrevious)

	-- How much to move in X and Y.
	local moveX = 0
	local moveY = 0
	
	-- Detect for button presses and update accordingly.
	if test_mask(input, INPUTS.LEFT) and not test_mask(inputPrevious, INPUTS.LEFT) then
		moveX = moveX - 1
	end
	if test_mask(input, INPUTS.RIGHT) and not test_mask(inputPrevious, INPUTS.RIGHT) then
		moveX = moveX + 1
	end
	if test_mask(input, INPUTS.UP) and not test_mask(inputPrevious, INPUTS.UP) then
		moveY = moveY - 1
	end
	if test_mask(input, INPUTS.DOWN) and not test_mask(inputPrevious, INPUTS.DOWN) then
		moveY = moveY + 1
	end
	
	-- If we need to move in X
	if moveX ~= 0 then
	
		-- Update the actual position based on the input.
		-- Clamp between 1 and the layout size.
		self.selection.x = math.max(
			1,
			math.min(
				EmoteMenuLayout.size.x,
				self.selection.x + moveX
			)
		)
		
		self.selectionMoved = true
		
	end
	
	-- If we need to move in Y
	if moveY ~= 0 then
	
		-- Update the actual position based on the input.
		-- Clamp between 1 and the layout size.
		self.selection.y = math.max(
			1,
			math.min(
				EmoteMenuLayout.size.y,
				self.selection.y + moveY
			)
		)
		
		self.selectionMoved = true
		
	end
	
	-- Lerp the visual. Very cute!
	local sm = self.selectionVisualLerp
	self.selectionVisual.x = self.selectionVisual.x * (1 - sm) + self.selection.x * sm
	self.selectionVisual.y = self.selectionVisual.y * (1 - sm) + self.selection.y * sm
	

end


-- Used for returning what emote the player has selected.
function EmoteMenu:getSelection()

	-- Find the emote index
	local x = self.selection.x
	local y = self.selection.y
	local emoteIndex = EmoteMenuLayout.cells[y][x]
	
	if emoteIndex > 0 then
		-- If a proper emoji was selected.
		
		-- Return the emote defenition
		return EmoteMenuLayout.emoteDefs[emoteIndex]
		
	else
		-- If no emoji was selected.
	
		return nil
	
	end

end


-- Fade in logic.
function EmoteMenu:fadeIn(deltaTime)

	if not self.fading then
		-- If we aren't already fading in.
	
		
		-- If the timer reaches the hold time, start fading.
		if self.time >= self.timeToHold then
			self.fading = true
		end
		
		-- Also start fading if the selection has moved.
		if self.selectionMoved then
			self.fading = true
		end
	
	
	else
		-- If we are currently fading in.
		
		
		-- Increase opacity.
		local increment = deltaTime / self.fadeTime
		self.opacity = math.min(1, self.opacity + increment)
		
	
	end

end


-- Update the emote menu.
function EmoteMenu:update(input, inputPrevious)

	-- Update the timer.
	local deltaTime = 1 / CONST.ENGINE_FPS
	self.time = self.time + deltaTime
	
	-- Fade in if we need to.
	if (self.opacity < 1) then
		self:fadeIn(deltaTime)
	end
	
	-- Update the selection.
	self:updateSelection(input, inputPrevious)

end


-- Used for checking if the emote menu should be rendered.
function EmoteMenu:shouldBeRendered(player)

	-- Make sure we are viewing the right layer.
	local isCorrectLayer = (state.camera_layer == player.layer)
	
	-- If correct, return true.
	return isCorrectLayer

end


-- Draw the emote menu.
function EmoteMenu:draw(renderCtx, player)


	-- Get the player position.
	local x, y, l = get_render_position(player.uid)
	
	-- How much to offset the draw functions.
	local offsetX = x + EmoteMenuLayout.renderOffset.x
	local offsetY = y + EmoteMenuLayout.renderOffset.y
	
	-- The regular 'opacity' colors.
	local color = Color:new(1, 1, 1, self.opacity)

	-- Draw the menu.
	local maabb = aabbHelper.scale(
		self.menuAABB,
		EmoteMenuLayout.renderSize
	)
	renderCtx:draw_world_texture(
		self.menuSprite.texture,
		0, 0,
		Quad:new(maabb):offset(offsetX, offsetY),
		color,
		WORLD_SHADER.TEXTURE_COLOR
	)
	
	
	-- The shift for 'grid based' elements.
	local aabbShiftX = -EmoteMenuLayout.size.x / 2
	local aabbShiftY = -EmoteMenuLayout.size.y / 2
	
	
	-- Draw the emote selector.
	local saabb = aabbHelper.scale(
		AABB:new(
			( self.selectionVisual.x + aabbShiftX - 1),
			(-self.selectionVisual.y - aabbShiftY + 1),
			( self.selectionVisual.x + aabbShiftX),
			(-self.selectionVisual.y - aabbShiftY)
		),
		EmoteMenuLayout.renderSize
	)
	saabb:extrude(EmoteMenuLayout.renderSize * 0.625)
	
	renderCtx:draw_world_texture(
		self.emoteSelectorSprite.texture,
		0, 0,
		Quad:new(saabb):offset(offsetX, offsetY),
		color,
		WORLD_SHADER.TEXTURE_COLOR
	)
	
	
	-- Draw the menu icons.
	for yy = 1, EmoteMenuLayout.size.y do
		for xx = 1, EmoteMenuLayout.size.x do
		
			local index = EmoteMenuLayout.cells[yy][xx]
			local emoteDef = EmoteMenuLayout.emoteDefs[index]
			
			-- If a proper emoji defenition exists.
			if emoteDef then
			
				-- Check if we are the currently selected one.
				local isSelected = (self.selection.x == xx and self.selection.y == yy)
				
				local eaabb = aabbHelper.scale(
					AABB:new(
						( xx + aabbShiftX - 1),
						(-yy - aabbShiftY + 1),
						( xx + aabbShiftX),
						(-yy - aabbShiftY)
					),
					EmoteMenuLayout.renderSize
				)
				
				if isSelected then
					eaabb:extrude(EmoteMenuLayout.renderSize * 0.125)
				end
				
				renderCtx:draw_world_texture(
					emoteDef.emoteSprite.texture,
					0, emoteDef.frames[1] - 1,
					Quad:new(eaabb):offset(offsetX, offsetY),
					color,
					WORLD_SHADER.TEXTURE_COLOR
				)
			
			end
			
		end
	end
	

end


return EmoteMenu
