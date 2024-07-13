--[[

	The emote defenition class.

--]]


-- Load modules.
local Sprite = require("src.sprite")


local EmoteDef = Class(
	"Emote Defenition",
	{
		-- Frames to use.
		-- Will be set by the constructor.
		frames = nil,
		
		-- Sound to play.
		-- sound = nil,
		
		-- The sprite sheet containing all emotes.
		emoteSprite = Sprite("img/emoteStrip.png", 1792, 128, 128, 128),
	}
)


function EmoteDef:init(frames)
	
	-- Overwrite name, frames, and sound.
	self.frames = frames
	
end


return EmoteDef
