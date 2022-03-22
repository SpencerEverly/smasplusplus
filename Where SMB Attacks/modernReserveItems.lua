--------------------------------------------------
--[[modernReserveItems.lua v1.1.1 by KBM-Quine]]--
--[[    massive amounts of code help from:    ]]--
--[[        rixithechao, Enjl, Hoeloe,        ]]--
--[[         PixelPest, and MrDoubleA         ]]--
--------------------------------------------------
local modernReserveItems = {}

local pm = require("playermanager")

modernReserveItems.enabled = true
modernReserveItems.autoHold = true
modernReserveItems.timeAutoHeld = 32
modernReserveItems.playSounds = true
modernReserveItems.playerXMomentum = 0
modernReserveItems.playerYMomentum = 0
modernReserveItems.allowThrownItems = true
modernReserveItems.allowHeldItems = true
modernReserveItems.allowHeldItemsInWarps = true
modernReserveItems.allowContainedItems = true
modernReserveItems.allowAnyItems = true

local patterns = {
	default = {
		speedX = 0,
		speedY = 0,
		isHeld = true,
        isContained = false,
        isThrown = false,
        containedID = 0,
        isMega = false,
        doesntMove = false,
        isEgg = false,
        SFX = 23,
        yoshiSFX = 50
	},
	thrown = {
		speedX = 5,
		speedY = -6,
		isHeld = false,
        isContained = false,
        isThrown = true,
		containedID = 0,
        isMega = false,
        doesntMove = false,
        isEgg = false,
        SFX = 11,
        yoshiSFX = 50
	},
	stationaryPowerup = {
		speedX = 3.5,
		speedY = -3,
		isHeld = false,
        isContained = false,
        isThrown = true,
		containedID = 0,
		isMega = false,
        doesntMove = false,
        isEgg = false,
        SFX = 11,
        yoshiSFX = 50
	},
	stationary = {
		speedX = 0,
		speedY = -7,
        isHeld = false,
        isContained = false,
        isThrown = true,
		containedID = 0,
		isMega = false,
        doesntMove = false,
        isEgg = false,
        SFX = 11,
        yoshiSFX = 50
	},
	mushroom = {
		speedX = 3,
		speedY = -3,
		isHeld = false,
        isContained = false,
        isThrown = true,
		containedID = 0,
		isMega = false,
        doesntMove = true,
        isEgg = false,
        SFX = 11,
        yoshiSFX = 50
	},
}

local thrownNPCSettings = {
    [95] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 95
        }
    },
    [98] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 98
        }
    },
    [99] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 99
        }
    },
    [100] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 100
        }
    },
    [148] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 148
        }
    },
    [149] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 149
        }
    },
    [150] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 150
        }
    },
    [188] = {
        speedX = 6,
        speedY = 0,
		isHeld = false,
        isThrown = true,
        pattren = default
	},
    [228] = {
		isHeld = true,
        isEgg = true,
        ai = {
            ai1 = 228
        },
        pattren = default
    },
	[248] = {
        speedX = 0,
		speedY = 0,
		isHeld = false,
        isContained = true,
        isThrown = false,
		containedID = 2,
        isMega = false,
        SFX = 11,
        yoshiSFX = 50,
        pattren = default
	},
	[293] = {
		speedX = 1.5,
		speedY = -3,
		isHeld = false,
        isThrown = true,
        SFX = 11,
        pattren = default
	},
	[425] = {
		speedX = 1,
		speedY = -3,
		isHeld = false,
        isThrown = true,
		isMega = true,
        SFX = 11,
        pattren = default
	}
}

local patternPresets = {
	mushroom = {9, 75, 90, 153, 184, 185, 186, 187, 273, 462},
	thrown = {16, 41, 97},
	stationary = {14, 34, 94, 101, 102, 198},
	stationaryPowerup = {169, 170, 182, 183, 240, 249, 254, 264, 277, 559}
}

for  k,v in pairs(patternPresets)  do
	for  _,v2 in ipairs(v)  do
		if  thrownNPCSettings[v2] == nil  then
			thrownNPCSettings[v2] = {}
		end
		thrownNPCSettings[v2].pattern = patterns[k]
	end
end

function modernReserveItems.onInitAPI()
	registerEvent (modernReserveItems, "onTick", "onTick", true)
end

function modernReserveItems.getThrowSettings(npcID)
    return thrownNPCSettings[npcID]
end

function modernReserveItems.setThrowSettings(npcID, patternTable)
    local settings = thrownNPCSettings[npcID]  or  {}
	thrownNPCSettings[npcID] = table.join(thrownNPCSettings[npcID]  or  {}, patternTable)
end

local function resolveThrowSettings(npcID, field)
    local pattern
    local key
    if thrownNPCSettings[npcID] ~= nil then
        key = thrownNPCSettings[npcID][field]
        pattern = thrownNPCSettings[npcID].pattern
    end
    if key == nil and pattern ~= nil then
        if pattern[field] ~= nil then
            key = pattern[field]
        else
            key = patterns.default[field]
        end
    elseif key == nil and pattern == nil then
        key = patterns.default[field]
    end
    return key
end

local powerStateBlacklist = {1, 2, 4, 5, 6, 8, 9, 10, 11, 12, 41, 227, 228, 500}
function modernReserveItems.drop(ID, p)
    local ps = PlayerSettings.get(pm.getCharacters()[p.character].base, p.powerup)
    local speedX = resolveThrowSettings(ID, "speedX")
    local speedY = resolveThrowSettings(ID, "speedY")
    local isHeld = resolveThrowSettings(ID, "isHeld")
    local isContained = resolveThrowSettings(ID, "isContained") -- this is only used by the reserve box stopwatch
    local isThrown = resolveThrowSettings(ID, "isThrown")
    local containedID = resolveThrowSettings(ID, "containedID") -- this is only used by the reserve box stopwatch
    local isMega = resolveThrowSettings(ID, "isMega") -- for larger items when thrown(mega mushroom only uses this so far)
    local doesntMove = resolveThrowSettings(ID, "doesntMove")
    local isEgg = resolveThrowSettings(ID, "isEgg") -- disallows yoshi from eating yoshis
    local data = resolveThrowSettings(ID, "data")
    local ai = resolveThrowSettings(ID, "ai")
    local SFX = resolveThrowSettings(ID, "SFX")
    local yoshiSFX = resolveThrowSettings(ID, "yoshiSFX")
    local npcID = ID
    if isEgg then
        npcID = 96
    end
    for _,v in ipairs(Warp.get()) do -- if the warp doesen't allow items, then don't spawn them 
        if (p.TargetWarpIndex == v.idx+1 or p.TargetWarpIndex == 0) and p.ForcedAnimationTimer > 1 then
            if not v.allowItems then
                return
            end
        end
    end
    if p.ForcedAnimationState == 7 or p.ForcedAnimationState == 3 then
        if p.ForcedAnimationTimer >= 1 and not modernReserveItems.allowHeldItemsInWarps or (isThrown or isContained) then
            return
        end
    end
    for _,v in ipairs(powerStateBlacklist) do -- don't allow spawning if the player is in a forced state
        if p.ForcedAnimationState == v then
            return
        end
    end
    if p.MountType == MOUNT_YOSHI and NPC.config[npcID].noyoshi and isHeld then return end -- if on yoshi, don't spawn an item that doesn't allow yoshi to eat it
    if p.MountType == MOUNT_BOOT and isHeld then return end -- can't hold something if your in a boot, silly
    if p:mem(0xB8, FIELD_WORD) ~= 0 and isHeld then return end -- cancel spawn if yoshi is holding something
    if p.holdingNPC ~= nil and isHeld then return end -- you can't hold more then one item, you'd need more arms!
    if p.BlinkTimer == 1 and p.BlinkState then return end -- workaround for launch barrels 
    if p.ClimbingState > 0 and isHeld then return end -- you can't climb AND hold an item, you'd need more arms!
    if not p.TanookiStatueActive and isHeld then return end -- can't hold something if you can't move your hands!
    if not modernReserveItems.allowThrownItems and isThrown then return end
    if not modernReserveItems.allowHeldItems and isHeld then return end
    if not modernReserveItems.allowContainedItems and isContained then return end
    if not modernReserveItems.allowAnyItems then return end
    local spawnedX = p.x+(p.width*0.5)
    local spawnedY = p.y+(p.height*0.5)
    if not isContained then
        if isMega and p.MountType == MOUNT_CLOWNCAR then
            spawnedY = (((-ps.hitboxHeight*0.5)+10) - (NPC.config[npcID].height*0.5))
        elseif p.MountType == MOUNT_CLOWNCAR then
            if isHeld then
                spawnedY = p.y + 16 - NPC.config[npcID].height
            else
                spawnedY = ((-ps.hitboxHeight*0.5)+10)
            end
        else
            if isHeld then
                spawnedY = p.y
            end
        end
        if p.MountType == MOUNT_CLOWNCAR then
            spawnedX = p.x+(p.width*0.5)+(48*p.direction)
        elseif p.MountType == MOUNT_YOSHI then
            spawnedX = p.x+((NPC.config[npcID].width*0.5))*p.direction
        elseif isHeld then
            spawnedX = p.x+(28+(NPC.config[npcID].width*0.5))*p.direction
        end
    end
    local spawned = NPC.spawn(npcID, spawnedX, spawnedY, p.section, false, true)
    spawned.direction = p.direction
    spawned.dontMove = doesntMove
    if doesntMove and isThrown then
        spawned:mem(0x136, FIELD_BOOL, true) -- Projectile Flag
    end
    spawned:mem(0x138, FIELD_WORD, containedID) --Forced State/Contained In
    spawned:mem(0x132, FIELD_WORD, p.idx) -- Thrown by Player
    if data ~= nil then
        for  k,_ in pairs(data)  do
            spawned.data[k] = data[k]
        end
    end
    if ai ~= nil then
        for  k,_ in pairs(ai) do
            spawned[k] = ai[k]
        end
    end

    if not isContained then
        spawned:mem(0x12E, FIELD_WORD, 30) -- Grab Timer?
        spawned:mem(0x130, FIELD_WORD, p.idx) -- Grabbing Player
    end
    if isThrown then
        if speedX ~= nil then
            spawned.speedX = speedX*spawned.direction+(p.speedX*modernReserveItems.playerXMomentum)
        end
        if speedY ~= nil then
            spawned.speedY = speedY+(p.speedY*modernReserveItems.playerYMomentum)
        end
    end
    
    if p.MountType == MOUNT_NONE and isHeld and not isContained  then
        p.HeldNPCIndex = spawned.idx+1
        spawned:mem(0x12C, FIELD_WORD, p.idx) -- Player carrying index
        if modernReserveItems.autoHold then
            p:mem(0x62, FIELD_WORD, modernReserveItems.timeAutoHeld) -- Force Hold Timer
        end
    elseif p.MountType == MOUNT_YOSHI and isHeld and not isContained  then
        p.MountState = 1
        p:mem(0xB4, FIELD_WORD, -1) -- Tongue x offset
        p:mem(0xB8, FIELD_WORD, spawned.idx+1) -- Tongue contained NPC index
        p:mem(0xB6, FIELD_BOOL, true) -- Tongue retracting flag
        spawned:mem(0x138, FIELD_WORD, 6) -- Forced State/Contained In
        spawned:mem(0x13C, FIELD_DFLOAT, p.idx) -- Forced State Timer 1
        
    elseif p.MountType == MOUNT_CLOWNCAR  and isHeld and not isContained  then
        spawned:mem(0x60, FIELD_WORD, p.idx) -- Clown Car Player
        spawned:mem(0x62, FIELD_WORD, 32) -- Distance from Clown Car
    end

    if p.MountType == MOUNT_YOSHI and isHeld then
        if modernReserveItems.playSounds then
            Audio.playSFX(yoshiSFX)
        end
    elseif not isContained then
        if modernReserveItems.playSounds then
            Audio.playSFX(SFX)
        end
    end

    p.reservePowerup = 0
end

function modernReserveItems.onTick()
    if not isOverworld and modernReserveItems.enabled then
        for _, p in ipairs(Player.get()) do
            p:mem(0x130,FIELD_BOOL,false) -- "DropRelease" from source, via MrDoubleA
            if p.reservePowerup ~= 0 and p.keys.dropItem == KEYS_PRESSED and not Misc.isPaused() then
                modernReserveItems.drop(p.reservePowerup, p)
            end
        end
    end
end

modernReserveItems.patterns = patterns

return modernReserveItems