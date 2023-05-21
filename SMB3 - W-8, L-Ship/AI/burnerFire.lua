--burnerFire.lua - Modified torches.lua by IAmPlayer

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local torches = {}

--***************************************************************************************************
--                                                                                                  *
--              DEFAULTS AND NPC CONFIGURATION                                                      *
--                                                                                                  *
--***************************************************************************************************

function torches.register(id)
    npcManager.registerEvent(id, torches, "onTickEndNPC")
	
	if NPC.config[id].duration <= 64 then
		NPC.config[id].duration = 64
	end
end

--*********************************************
--                                            *
--                     AI                     *
--                                            *
--*********************************************

-- DINO TORCH FLAMES
function torches.onTickEndNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data._basegame
	
	if v:mem(0x12A, FIELD_WORD) <= 0 or v:mem(0x138,FIELD_WORD) > 0 then
		data.exists = false
		return
	end
	
	-- Initialization
	if not data.exists then
		v.ai1 = 0 -- animation timer
		v.ai2 = 0 -- flicker timer before fading
		
		local data = v.data._basegame
		data.frame = 0
		data.exists = true;
		
		if data.friendly == nil then
			data.friendly = v.friendly
		end
		
		if data.parent and data.parent.isValid then
			data.xOffset = v.x - data.parent.x
			data.yOffset = v.y - data.parent.y
		end
	end
	
	-- Snap to parent of the torch
	if data.parent then
		if not data.parent.isValid or data.parent:mem(0x12C, FIELD_WORD) > 0 or data.parent:mem(0x138, FIELD_WORD) > 0 then
			v:kill(9)
			return
		else
			v.x = data.parent.x + data.xOffset
			v.y = data.parent.y + data.yOffset
		end
	else
		local lspdx = 0
		local lspdy = 0
		if not Layer.isPaused() then
			lspdx = v.layerObj.speedX
			lspdy = v.layerObj.speedY
		end
		v.speedX = lspdx
		v.speedY = lspdy
	end
	
	-- flame shouldn't hit you until it's fully out
	if data.frame >= 6 then
		v.friendly = data.friendly;
	else
		v.friendly = true;
	end
	
	-- hardcoded animation time baybee
	-- i want to clean this up but at the same time i have no idea how i'd do it lol
	v.ai1 = v.ai1 + 1;
	--Text.print(v.ai1, v.x - camera.x, v.y - camera.y)
	
	if v.ai1 <= 18 and v.ai1 % 3 == 0 then
		data.frame = data.frame + 1;
	end
	
	if v.ai1 == 21 then
		data.frame = 7;
		v.ai2 = 4;
	end
	
	if v.ai1 == NPC.config[v.id].duration - 28 then
		v.ai2 = 0;
		data.frame = 7;
	end
	
	if v.ai1 >= NPC.config[v.id].duration - 24 and v.ai1 <= NPC.config[v.id].duration - 4 and v.ai1 % 4 == 2 then
		data.frame = data.frame - 1;
	end
	
	if v.ai1 == NPC.config[v.id].duration then
		v:kill(9)
		return
	end
	
	-- flicker before fading
	if v.ai2 >= 1 then
		v.ai2 = v.ai2 - 1;
	end
	
	if v.ai2 == 1 then
		v.ai2 = 4;
		if data.frame == 7 then
			data.frame = 6;
		else
			data.frame = 7;
		end
	end
	
	-- update animations
	v.animationTimer = 500
	v.animationFrame = npcutils.getFrameByFramestyle(v, {
		frame = data.frame,
		frames = NPC.config[v.id].frames,
	});
end

return torches;