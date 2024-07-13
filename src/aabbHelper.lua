--[[

	Lazy helper functions for AABBs

--]]

local aabbHelper = {}


function aabbHelper.scale(aabb, scale)

	local newAABB = AABB:new(
		aabb.left * scale,
		aabb.top * scale,
		aabb.right * scale,
		aabb.bottom * scale
	)
	
	return newAABB

end


function aabbHelper.move(aabb, x, y)

	local newAABB = AABB:new(
		aabb.left + x,
		aabb.top + y,
		aabb.right + x,
		aabb.bottom + y
	)
	
	return newAABB

end


return aabbHelper
