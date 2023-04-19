local twirl = {}
--v2.3

local textplus = require("textplus")
local playeranim = require("playerAnim")
local smasExtraSounds = require("smasExtraSounds")
local smasBooleans = require("smasBooleans")
local smasTables = require("smasTables")

function twirl.onInitAPI()
	registerEvent(twirl, "onTick", "onTick")
	registerEvent(twirl, "onDraw", "onDraw")
end

twirl.showMeDebug = false
local twirlSfx = smasExtraSounds.sounds[154].sfx

local isTwirling = {false,false}
local timeline = {0,0}
local cooldown = {0,0}
local unmounting = {false,false}

--The Twirl™
twirl.descent =			1.5
twirl.impulsePercent =	1.5
twirl.extraImpulse =	1.3
twirl.cooldown =		10

--Animation
twirl.frames = {15, -2,-2, 13, 2,2}
twirl.animSpeed = 2
local twirlAnim = playeranim.Anim(twirl.frames, twirl.animSpeed)

--For compatibility with my other script ("dive.lua")
twirl.enableDownKey = false
function twirl.cancelTwirl(key,value)
	isTwirling[key] = false
	cooldown[key] = -1
	timeline[key] = 0
	twirlAnim:stop(value)
end

function twirl.onTick() for k, p in ipairs(Player.get()) do

	local function resetTwirling()
		isTwirling[k] = false
		timeline[k] = 0
		cooldown[k] = 0
	end

	-- Convenience Functions
	local function isOnGround() return(
		p:isOnGround()
		or (p.mount == MOUNT_BOOT and p:mem(0x10C,FIELD_BOOL))		-- Hopping in boot
		or p:mem(0x40,FIELD_WORD) > 0								-- Climbing	
	)end
	local function isOnMount() return(
		p.mount ~= 0 or
		p.climbing
	)end
	local function isUnderwater() return(
		p:mem(0x36,FIELD_BOOL)				-- In a liquid
		or p:mem(0x06,FIELD_BOOL)	-- In quicksand
	) end
	local function canTwirl() return (
			not isTwirling[k] and
			not isOnGround() and
			not p:mem(0x50,FIELD_BOOL) and -- Spinning
			not isUnderwater() and
			not isOnMount() and
			not unmounting[k] and
			not p:mem(0x44, FIELD_BOOL) and -- Riding a rainbow shell
			not p:mem(0x12E, FIELD_BOOL) and -- Ducking
			not p:mem(0x13C, FIELD_BOOL) and
			not p.holdingNPC and
			not p.isMega and
			p.deathTimer == 0 and
			Level.winState() == 0 and
			not (p.speedY > 0 and (p.powerup == 4 or p.powerup == 5)) and
			p.forcedState == 0 and
			(p.character == 1 or p.character == 2 or p.character == 4 or p.character == 7 or p.character == 15) and
            smasBooleans.cantTwirl == false and
            table.icontains(smasTables._noLevelPlaces,Level.filename()) == false and
            SaveData.SMASPlusPlus.player[1].currentCostume ~= "DEMO-XMASPILY"
	) end

	if p.keys.altJump and p.keys.up and cooldown[k] > twirl.cooldown then
		isTwirling[k] = true
	elseif canTwirl() then
		isTwirling[k] = false
		cooldown[k] = cooldown[k] + 1
	else
		cooldown[k] = 0
	end

	if isTwirling[k] then
		timeline[k] = timeline[k] + 1

		p.UnknownCTRLLock1 = 1 -- disables ducking without setting p.keys.down false... apparently.
	else
		p.UnknownCTRLLock1 = 0 -- re-enabling ducking. I might change this if this causes jank. for now it's very useful to me
	end

	if timeline[k] == 1 then
		twirlAnim:play(p)
		SFX.play(twirlSfx)
		if p.speedY > 2 then
			p.speedY = twirl.descent
		elseif p.speedY < -2 then
			p.speedY = p.speedY - (p.speedY % twirl.impulsePercent)-twirl.extraImpulse
		else
			p.speedY = -twirl.extraImpulse*2
		end
	end

	--Stop Animation
	if timeline[k] >= twirl.animSpeed*#twirl.frames or timeline[k] == 0 or isOnMount() then
		twirlAnim:stop(p)
	end

	--Unmounting
	if isOnMount() then
		unmounting[k] = true
	end
	if unmounting[k] and p.keys.altJump and p.keys.up then
		unmounting[k] = true
	elseif not p.keys.altJump and not p.keys.up then
		unmounting[k] = false
	end


	if timeline[k] > 20 then
		resetTwirling()
	end


--Debug: Prints Variables on Screen — Set ``twirl.showMeDebug`` to true in order to activate. (Works with 2 players)
	local function print(line, text, variable,color)
		if twirl.showMeDebug == false then return end
		debugFont = textplus.loadFont("scripts/textplus/font/11.ini")
	
		textplus.print{font=debugFont,xscale=1.5,yscale=1.5,x=20^k*1.02,y=(6+line)*15,text=text..": "..tostring(variable),color=color}
	end
	print(1,	"Player's Y Velocity",		p.speedY						)
	print(4,	"Is Twirling",				isTwirling[k]					)
	print(6,	"Can Twirl?",				canTwirl()						)
	print(8,	"Timeline of Twirl",		timeline[k]						)
	print(9,	"Is Mounting Something",	isOnMount()						)
	print(13,	"0x12E",					p:mem(0x12E, FIELD_BOOL)		)
	
	if cooldown[k] < twirl.cooldown then
		print(7,	"Cooldown",					cooldown[k]		,Color(1, 0.4, 0.4))
	else
		print(7,	"Cooldown",					cooldown[k]		,Color.green)
	end
	if unmounting[k] then
		print(10,	"Jumping off Mounting",		unmounting[k]	,Color.lightblue)
		print(7,	"Cooldown",					cooldown[k]		,Color.lightblue)
	else
		print(10,	"Jumping off Mounting",		unmounting[k])
	end

	if canTwirl() then
		if p.speedY > 2 then
			print(12,	"Down","Cat!")
		elseif p.speedY < -2 then
			print(12,	"Up","Dog!")
		else
			print(12,	"Mid-air","Platypus!")
		end
	end
end
end

--Good job me, I'm proud.

return twirl