local arrowLift = {}

local npcManager = require("npcManager")
local lineguide = require("lineguide")
local npcutils = require("npcs/npcutils")

local npcID = NPC_ID

local config = npcManager.setNpcSettings({
	id = npcID,
	gfxwidth = 0,
	gfxheight = 0,
	width = 64,
	height = 32,
	frames = 4,
	framespeed = 8,
	framestyle = 0,
	score = 0,
	blocknpctop = true,
	playerblocktop = true,
	nohurt = true,
	nogravity = true,
	noblockcollision = true,
	noiceball = true,
	noyoshi = true,
	blocknpc = false,
	notcointransformable = true,
	nospecialanimation = false,
	spawnid = 418
})

function arrowLift.baseDataCheck(npc)
	local data = npc.data._basegame
	local settings = npc.data._settings
	if data.onLand == nil then
		data.onLand = {}
		data.type = settings.type or 0
		data.child = nil
		if not settings.override then
			settings.life = npc.data._settings.life
			settings.speed = npc.data._settings.speed
		end
	end
end

function arrowLift.ghostDataCheck(npc)
	local data = npc.data._basegame
	local settings = npc.data._settings
	if data.onLand == nil then
		data.onLand = {}
		settings.type = settings.type or 0
		settings.sp = settings.sp or false
		data.spdir = 1
		data.animation = 0
		data.timer = 0
		data.parent = nil
		if not settings.override then
			settings.life = npc.data._settings.life
			settings.speed = npc.data._settings.speed
		end
	end
end

lineguide.registerNpcs(npcID)

function arrowLift.onTickEndNPC(npc)
	if Defines.levelFreeze or npc:mem(0x12A, FIELD_WORD) <= 0 then return end
	arrowLift.baseDataCheck(npc)
	local data = npc.data._basegame

	npc.speedX = 0
	npc.speedY = 0

	local settings = npc.data._settings

	local pjump = {}
	for _, p in ipairs(Player.get()) do
		if p.standingNPC then
			pjump[p.idx] = p.standingNPC == npc
		end
		-- This is true the first frame the player jumps on the NPC
		if pjump[p.idx] and not data.onLand[p.idx] then
			p.y = p.y - 1
			if data.child and data.child.isValid then
				data.child:kill()
			end

			local ghost = NPC.spawn(config.spawnid, npc.x + npc.width*0.5, npc.y - 1, p.section, false, false)
			data.child = ghost
			local ghostdata = ghost.data._basegame
			local ghostsettings = ghost.data._settings
			arrowLift.ghostDataCheck(ghost)
			ghost.x = ghost.x - ghost.width*0.5
			ghost.dontMove = npc.dontMove
			ghost.layerName = "Spawned NPCs"
			ghostdata.parent = npc
			ghostsettings.life = npc.data._settings.life
			ghostsettings.speed = npc.data._settings.speed
			if settings.type == 0 then
				ghostsettings.type = -1
				ghostsettings.sp = true
			else
				ghostsettings.type = data.type - 1
				ghostsettings.sp = false
			end
		end
	end
	data.onLand = pjump

	if not arrowLift.nospecialanimation then
		local t = settings.type + 1
		local tf = config.frames * 0.25
		local offset = (t-1) * tf
		local gap = config.frames - (4-t) * tf
		npcutils.restoreAnimation(npc)
		npc.animationFrame = npcutils.getFrameByFramestyle(npc, {
			frames = tf,
			offset = offset,
			gap = gap
		})
	end
end

function arrowLift.onInitAPI()
	npcManager.registerEvent(npcID, arrowLift, "onTickEndNPC")
end

return arrowLift

--BASE
-- npc.data.type {
-- 	/What Type?
--    0 = !
-- 	  1 = Up
-- 	  2 = Left
-- 	  3 = Right
--   }
-- npc.data.life {
--   /How long should the ghost created last?
--   }
-- npc.data.speed {
--   /He speed
-- }

--Ghost
-- npc.data.type {
-- 	/Direction?
-- 	0 = up
-- 	1 = Left
-- 	2 = Right
-- }
-- npc.data.sp {
-- 	/Should change direction when jumped on?
-- 	true = Yes
-- 	false = No
-- }
-- npc.data.life {
--   /How long should the ghost last?
-- }
-- npc.data.speed {
--   /He speed
-- }
