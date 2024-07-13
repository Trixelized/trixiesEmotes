--[[

	The layout of the emote menu.
	NOT a class, just a single static table.
	
	Make sure your tab size is bigger than 4, you freaks.

--]]


-- Load modules.
local EmoteDef = require("src.emoteDef")


return {
	renderSize = 0.5,
	renderSizeBubble = 0.5,
	renderOffset = {
		x = 0,
		y = 1.65
	},
	renderOffsetBubble = {
		x = 0,
		y = 1.65
	},
	size = {
		x = 5,
		y = 3
	},
	start = {
		x = 3,
		y = 2
	},
	cells = {
		{1,	2,	3,	4,	5},
		{6,	7,	0,	8,	9},
		{10,	11,	12,	13,	14}
	},
	emoteDefs = {
		EmoteDef({1}),
		EmoteDef({2}),
		EmoteDef({3}),
		EmoteDef({4}),
		EmoteDef({5}),
		EmoteDef({6}),
		EmoteDef({7}),
		EmoteDef({8}),
		EmoteDef({9}),
		EmoteDef({10}),
		EmoteDef({11}),
		EmoteDef({12}),
		EmoteDef({13}),
		EmoteDef({14})
	}
}

