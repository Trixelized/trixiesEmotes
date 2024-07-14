--[[

	Lazy texture creation class.
	Meant to be called just once, on creation.

--]]


-- Create the class.
local Sprite = Class(
	"Sprite",
	{
		texture = nil
	}
)


-- Constructor.
-- Requires the path (eg. "img/sprite.png").
-- Width and height require the images' size in pixels.
-- tileWidth and tileHeight are optional, but need to be divisible by the full size.
function Sprite:init(path, width, height, tileWidth, tileHeight)

	-- In case no tile size is provided, just set to the same size.
	local tileWidth = tileWidth or width
	local tileHeight = tileHeight or height

	-- Get the most basic of texture defenitions.
	local textureDef = TextureDefinition.new()
	
	-- Change parameters, the ones with 0 are unused.
	textureDef.texture_path = path
	textureDef.width = width
	textureDef.height = height
	textureDef.tile_width = tileWidth
	textureDef.tile_height = tileHeight
	
	-- Define and store the texture.
	self.texture = define_texture(textureDef)

end


return Sprite
