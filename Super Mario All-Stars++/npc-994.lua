local npcManager = require("npcManager")
local starman = require("starman/star")

local star = {}

local npcID = NPC_ID;

local settings = npcManager.setNpcSettings({
	id = npcID, 
	gfxwidth = 32, 
	gfxheight = 30, 
	width = 32, 
	height = 30, 
	frames = 4,
	framestyle = 0,
	framespeed = 2,
	score = 2,
	playerblock=false,
	nogravity = false,
	nofireball=true,
	noiceball=true,
	grabside = false,
	nohurt=true,
	noblockcollision=true,
	isinteractable=true,
	lightradius = 64,
	lightbrightness = 1,
	lightcolor = Color.white,
	duration = 13,
	powerup = true
})

function star.onInitAPI()
	starman.register(npcID)

	npcManager.registerEvent(npcID, star, "onTickNPC")
end

function star:onTickNPC()
	if self.isHidden or self:mem(0x124, FIELD_WORD) == 0 then
		return
	end
	
	local data = self.data._basegame
	
	if data.timer == nil then
		data.timer = 80
	end
	
	self.speedX = self.direction
	self.speedY = -0.75
	if self.dontMove then
		self.speedY = 0
	end
	data.timer = data.timer - 1
	if data.timer <= 0 then
		self.direction = -self.direction
		data.timer = 160
	end
end

return star;
