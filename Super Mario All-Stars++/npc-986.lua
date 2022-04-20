local npcManager = require("npcManager")
local colliders = require("colliders")
local extrasounds = require("extrasounds")

local customNPC = {}
local npcID = NPC_ID

local exiting = false

local drawCastlePlayer = false
local castlePlayerTicks = 65
local castlePlayerX = 0
local castlePlayerY = 0

local customNPCSettings = {
    id = npcID,
    gfxheight = 32,
    gfxwidth = 32,
    width = 32,
    height = 32,
    gfxoffsetx = 16,
    gfxoffsety = 0,
    frames = 3,
    framestyle = 0,
    framespeed = 8,
    nohurt = true,
    nogravity = true,
    jumphurt = true,
}

local castles = {16, 17}

npcManager.setNpcSettings(customNPCSettings)

function customNPC.onInitAPI()
    npcManager.registerEvent(npcID, customNPC, "onTickNPC")
    registerEvent(customNPC, "onPlayerHarm")
	registerEvent(customNPC, "onPlayerKill")
    registerEvent(customNPC, "onDraw")
end

function customNPC.onTickNPC(v)
    if Defines.levelFreeze then return end

    local data = v.data

    if v.despawnTimer <= 0 then
        data.initialized = false
        return
    end

    if not data.initialized then
        data.state = 0
        data.tick = 0
        data.countTime = false
        data.castleX = math.huge
        data.castleWidth = 0
        data.initialized = true
    end

    if player.y >= v.y
    and player.x >= v.x
    and player.x <= v.x + v.width
    and player.section == v.section
    and data.state == 0 then
        data.state = 1
		GameData.muteMusic = true
		Audio.MusicVolume(0)
        SFX.play(Misc.resolveSoundFile("smb-flagslide.wav"))
        exiting = true
        data.countTime = Timer.isActive()
		--Timer.toggle()
        Timer.isVisible = true

        local score = 10 - math.floor((player.y - v.y) / 32)
        Misc.givePoints(score, vector(player.x, player.y))
    end

    if data.state ~= 0 then
        player.keys.up = false
        player.keys.down = false
        player.keys.left = false
        player.keys.right = false
        player.keys.jump = false
        player.keys.altJump = false
        player.keys.run = false
        player.keys.altRun = false
        player.keys.pause = false
        player.keys.dropItem = false
    end

    if data.state == 1 then
        data.tick = data.tick + 1
        player.x = v.x - player.width + 16
        player.speedX = 0
        player.speedY = 3 - Defines.player_grav
        player.direction = 1
        player:setFrame(3)
        v.speedY = 3

        if data.tick > 65 * 1.5 then
            player.x = player.x + player.width
            player.direction = -1
        end
        if data.tick > 65 * 2 then
            data.tick = 0
            data.state = 2
            SFX.play(Misc.resolveSoundFile("smb-exit.spc"))
        end
    elseif data.state == 2 then
        player.keys.right = true

        for _, castleid in ipairs(castles) do
            for _, bgo in ipairs(BGO.get(castleid)) do
                if colliders.collide(player, bgo) then
                    data.castleX = bgo.x
                    data.castleWidth = bgo.width
                end
            end
        end

        if player.x >= data.castleX + data.castleWidth / 2 - player.width / 2 then
            data.state = 3
            drawCastlePlayer = true
            castlePlayerX = data.castleX + data.castleWidth / 2 - player.width / 2
            castlePlayerY = player.y
            Timer.hurryTime = -1
        end
    elseif data.state == 3 then
        player.x = castlePlayerX
        player.y = castlePlayerY

        if Timer.getValue() > 0 and data.countTime then
            SFX.play(extrasounds.id[113])
            if Timer.getValue() >= 100 then
                Timer.add(-10)
                SaveData.totalScoreClassic = SaveData.totalScoreClassic + 100
            else
                Timer.add(-1)
                SaveData.totalScoreClassic = SaveData.totalScoreClassic + 10
            end
        else
            data.tick = data.tick + 1
        end
		
		if Timer.getValue() == 0 and data.countTime then
			SFX.play(extrasounds.id[114], 1, 1, 2500)
		end
		
        if data.tick > 65 * 5 then
			GameData.muteMusic = false
            Level.exit(LEVEL_WIN_TYPE_STAR)
        end
    end
end

function customNPC.onPlayerKill(eventToken, p)
    if exiting then
        eventToken.cancelled = true
    end
end

function customNPC.onPlayerHarm(e, p)
    if exiting then
        e.cancelled = true
    end
end

function customNPC.onDraw()
    if drawCastlePlayer then
        castlePlayerTicks = math.max(castlePlayerTicks - 1, 0)
        player.frame = 50
        player:render{
            frame = 15,
            x = castlePlayerX,
            y = castlePlayerY,
            color = Color(1, 1, 1, castlePlayerTicks / 65)
        }
    end
end

return customNPC
