--[[

    Cape for anotherpowerup.lua
    by MrDoubleA

    Credit to JDaster64 for the SMW physics guide
    Graphics from AwesomeZackC

]]

local npcManager = require("npcManager")
local ap = require("scripts/powerups/anotherpowerup")

local powerup = {}
local npcID = NPC_ID

local powerupSettings = {
	id = npcID,
	
	gfxheight = 32,
	gfxwidth = 32,
	
	width = 32,
	height = 32,
	
	gfxoffsetx = 0,
	gfxoffsety = 2,
	
	frames = 1,
	framestyle = 1,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	powerup = true,
	nohurt = true,
	nogravity = true,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi = false,
	nowaterphysics = false,
	
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = true,
	harmlessthrown = true,

	isinteractable = true,
}

npcManager.setNpcSettings(powerupSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})

if not SaveData.disableX2char then
    ap.registerPowerup("ap_cape")
    ap.registerItemTier(npcID,true)
end


-- Fix for redigit? I guess?
local stateProperties = {
	[1] = {speedChange = vector(0.3  ,-0.25),changeStateRequirement = (function(v) return v.speedY <= 0 end),changeDirection = false},
	[2] = {speedChange = vector(-0.3 ,-0.02),changeStateRequirement = (function(v) return v.speedX <= 0 end),changeDirection = true },
	[3] = {speedChange = vector(-0.1 ,0.4  ),changeStateRequirement = (function(v) return v.speedY >= 3 end),changeDirection = false},
	[4] = {speedChange = vector(-0.3 ,-0.25),changeStateRequirement = (function(v) return v.speedY <= 0 end),changeDirection = false},
	[5] = {speedChange = vector(0.3  ,-0.02),changeStateRequirement = (function(v) return v.speedX >= 0 end),changeDirection = true },
	[6] = {speedChange = vector(0.1  ,0.4  ),changeStateRequirement = (function(v) return v.speedY >= 3 end),changeDirection = false},
}

function powerup.onInitAPI()
	npcManager.registerEvent(npcID,powerup,"onTickNPC")
end

function powerup.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local config = NPC.config[v.id]
	local data = v.data
	
	if v.despawnTimer <= 0 then
		data.fallingState = nil
		return
	end

	if not data.fallingState then
		data.fallingState = 0
	end


	if v.dontMove then
		v.speedY = math.min(8,v.speedY+Defines.npc_grav)
		return
	elseif v:mem(0x138,FIELD_WORD) == 1 then -- Coming out of the top of a block
		v:mem(0x138,FIELD_WORD,0)
		
		v.height = config.height
		v.y = v.y - v.height

		v.speedY = -6
	elseif v:mem(0x12C,FIELD_WORD) > 0 or v:mem(0x136,FIELD_BOOL) or v:mem(0x138,FIELD_WORD) > 0 then -- Grabbed/thrown/in a 'forced state'
		return
	end


	v.noblockcollision = true
	
	if data.fallingState == 0 then
		v.speedY = v.speedY+Defines.npc_grav

		if v.speedY > 0 then
			data.fallingState = #stateProperties
			v.speedY = 0
		end
	else
		local properties = stateProperties[data.fallingState]

		v.speedX = v.speedX + properties.speedChange.x
		v.speedY = v.speedY + properties.speedChange.y

		if properties.changeStateRequirement(v) then
			if properties.changeDirection then
				v.speedX = 0
			end

			data.fallingState = (data.fallingState%#stateProperties)+1
		end
	end
end


return powerup