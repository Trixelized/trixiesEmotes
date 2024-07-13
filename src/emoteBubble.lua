--[[

	The actual emote bubble / popup.

--]]


-- Load modules.
local EmoteMenuLayout = require("src.emoteMenuLayout")
local Sprite = require("src.sprite")
local aabbHelper = require("src.aabbHelper")


-- Create the class.
local EmoteBubble = Class(
	"Emote Bubble",
	{
		-- This bubble's emote defenition.
		emoteDef = nil,
		
		-- Set to true if the emote bubble should be destroyed.
		shouldBeDestroyed = false,
		
		-- The bubble sprite and quad.
		bubbleSprite = Sprite("img/emoteBubble.png", 300, 300),
		bubbleAABB = AABB:new():extrude(1.5),
		
		lifespan = 3, -- How long the object should exist.
		time = 0, -- Used for tracking how long the object exists, in seconds.
		fadeTime = 0.1, -- How long the fade-in / fade-out takes.
		
		-- The opacity to render at, used for the fade-in effect.
		opacity = 0,
		
	}
)




-- Constructor
function EmoteBubble:init(emoteDef)

	self.emoteDef = emoteDef

end


-- Update
function EmoteBubble:update()

	-- Update the timer.
	local deltaTime = 1 / CONST.ENGINE_FPS
	self.time = self.time + deltaTime
	
	-- Destroy.
	if self.time >= self.lifespan then
		self.shouldBeDestroyed = true
		return
	end
	
	-- Update opacity.
	local fadeIn = self.time / self.fadeTime
	local fadeOut = math.abs(self.lifespan - self.time) / self.fadeTime
	self.opacity = math.min(fadeIn, fadeOut, 1)

end


-- Draw the emote bubble.
function EmoteBubble:draw(renderCtx, player)


	-- Get the player position.
	local x, y, l = get_render_position(player.uid)
	
	local offsetX = x + EmoteMenuLayout.renderOffsetBubble.x
	local offsetY = y + EmoteMenuLayout.renderOffsetBubble.y
	
	local color = Color:new(1, 1, 1, self.opacity)
	
	
	-- The bubble AABB.
	local scaledBubbleAABB = aabbHelper.scale(
		aabbHelper.move(
			self.bubbleAABB,
			0, -0.5
		),
		EmoteMenuLayout.renderSizeBubble
	)
	
	-- Draw the bubble itself.
	renderCtx:draw_world_texture(
		self.bubbleSprite.texture,
		0, 0,
		Quad:new(scaledBubbleAABB):offset(offsetX, offsetY),
		color,
		WORLD_SHADER.TEXTURE_COLOR
	)
	
	
	-- Draw the emote.
	renderCtx:draw_world_texture(
		self.emoteDef.emoteSprite.texture,
		0, self.emoteDef.frames[1] - 1,
		Quad:new(scaledBubbleAABB:extrude(-0.25)):offset(offsetX, offsetY),
		color,
		WORLD_SHADER.TEXTURE_COLOR
	)

end


return EmoteBubble


