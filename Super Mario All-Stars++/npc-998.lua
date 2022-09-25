local npcManager = require("npcManager")
local colliders = require("colliders")
local extrasounds = require("extrasounds")
local starman = require("starman/star")
local smasbooleans = require("smasbooleans")

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

local plr

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
    for _,p in ipairs(Player.get()) do
        if p.y >= v.y
        and p.x >= v.x
        and p.x <= v.x + v.width
        and p.section == v.section
        and data.state == 0 then
            data.state = 1
            smasbooleans.musicMuted = true
            Audio.MusicVolume(0)
            GameData.winStateActive = true
            SFX.play(extrasounds.sound.sfx[135])
            exiting = true
            data.countTime = Timer.isActive()
            --Timer.toggle()
            Timer.isVisible = true

            local score = 10 - math.floor((p.y - v.y) / 32)
            Misc.givePoints(score, vector(p.x, p.y))
        end

        if data.state ~= 0 then
            p.keys.up = false
            p.keys.down = false
            p.keys.left = false
            p.keys.right = false
            p.keys.jump = false
            p.keys.altJump = false
            p.keys.run = false
            p.keys.altRun = false
            p.keys.pause = false
            p.keys.dropItem = false
        end

        if data.state == 1 then
            Misc.npcToCoins()
            starman.stop(p)
            smasbooleans.musicMuted = true
            Audio.SeizeStream(-1)
            Audio.MusicStop()
            if p.y >= v.y and p.x >= v.x and p.x <= v.x + v.width and p.section == v.section then
                plr = p
            end
            if Player.count() == 1 then
                data.tick = data.tick + 1
            else
                data.tick = data.tick + 1 / Player.count()
            end
            if data.tick > 2 then
                data.state = 1.1
            end
            exiting = true
        end
        if data.state == 1.1 then
            if Player.count() == 1 then
                data.tick = data.tick + 1
            else
                data.tick = data.tick + 1 / Player.count()
            end
            if p.idx ~= plr.idx then
                p.section = plr.section
                p.x = (plr.x+(plr.width/2)-(p.width/2))
                p.y = (plr.y+plr.height-p.height)
                p.speedX,p.speedY = 0,0
                p.forcedState,p.forcedTimer = 8,-plr.idx
            end
            p.x = v.x - p.width + 16
            p.speedX = 0
            p.speedY = 3 - Defines.player_grav
            p.direction = 1
            p:setFrame(3)
            v.speedY = 3
            exiting = true

            if data.tick > 65 * 1.5 then
                p.x = p.x + p.width
                p.direction = -1
            end
            if data.tick > 65 * 2 then
                data.tick = 0
                data.state = 2
                if GameData.rushModeActive == false or GameData.rushModeActive == nil then
                    if Misc.inMarioChallenge() == false then
                        if v.data._settings.useOptionalTable then
                            if not table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
                                if v.data._settings.incrementStarCount then
                                    SaveData.totalStarCount = SaveData.totalStarCount + 1
                                else
                                    SaveData.totalStarCount = SaveData.totalStarCount
                                end
                                if v.data._settings.addToTable then
                                    table.insert(SaveData.completeLevelsOptional,Level.filename())
                                end
                            elseif table.icontains(SaveData.completeLevelsOptional,Level.filename()) then
                                SaveData.totalStarCount = SaveData.totalStarCount
                            end
                        else
                            if not table.icontains(SaveData.completeLevels,Level.filename()) then
                                if v.data._settings.incrementStarCount then
                                    SaveData.totalStarCount = SaveData.totalStarCount + 1
                                else
                                    SaveData.totalStarCount = SaveData.totalStarCount
                                end
                                if v.data._settings.addToTable then
                                    table.insert(SaveData.completeLevels,Level.filename())
                                end
                            elseif table.icontains(SaveData.completeLevels,Level.filename()) then
                                SaveData.totalStarCount = SaveData.totalStarCount
                            end
                        end
                    end
                end
                SFX.play(52)
            end
        elseif data.state == 2 then
            GameData.stopStarman = false
            smasbooleans.musicMuted = true
            if GameData.rushModeActive == true then
                GameData.rushModeWon = true
            end
            exiting = true
            p.speedX = 3
            p.direction = 1

            for _, castleid in ipairs(castles) do
                for _, bgo in ipairs(BGO.get(castleid)) do
                    if colliders.collide(p, bgo) then
                        data.castleX = bgo.x
                        data.castleWidth = bgo.width
                    end
                end
            end
            
            if p.x >= data.castleX + data.castleWidth / 2 - p.width / 2 then
                data.state = 3
                drawCastlePlayer = true
                castlePlayerX = data.castleX + data.castleWidth / 2 - p.width / 2
                castlePlayerY = p.y
                Timer.hurryTime = -1
            end
        elseif data.state == 3 then
            smasbooleans.musicMuted = true
            p.x = castlePlayerX
            p.y = castlePlayerY
            
            exiting = true
            
            if Timer.getValue() > 0 and data.countTime then
                SFX.play(extrasounds.sound.sfx[113])
                if Timer.getValue() >= 100 then
                    Timer.add(-10)
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 100
                else
                    Timer.add(-1)
                    SaveData.totalScoreClassic = SaveData.totalScoreClassic + 10
                end
            else
                if Player.count() == 1 then
                    data.tick = data.tick + 1
                else
                    data.tick = data.tick + 1 / Player.count()
                end
            end
            
            if Timer.getValue() == 0 and data.countTime then
                SFX.play(extrasounds.sound.sfx[114], 1, 1, 2500)
            end
            
            if data.tick > 65 * 2 then
                smasbooleans.musicMuted = false
                GameData.winStateActive = false
                if GameData.rushModeActive == false or GameData.rushModeActive == nil then
                    Level.exit(v.data._settings.winType)
                elseif GameData.rushModeActive == true and GameData.rushModeWon == true then
                    Level.load("SMAS - Rush Mode Results.lvlx")
                end
            end
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
        for _,p in ipairs(Player.get()) do
            p.frame = 50
            p:render{
                frame = 15,
                x = castlePlayerX,
                y = castlePlayerY,
                color = Color(1, 1, 1, castlePlayerTicks / 65)
            }
        end
    end
end

return customNPC
