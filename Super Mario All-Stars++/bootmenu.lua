--SMAS++ MAIN MENU
--Code by Spencer Everly, MrDoubleA, and others

local versionnumber = "Open Source Edition" --This is the version number of this episode. It can be changed to any version we're on.
local littleDialogue = require("littleDialogue")
local textplus = require("textplus")
local datetime = require("datetime")
--if Misc.inEditor() then
    --Misc.showRichDialog("SMAS++ Boot Menu Level", "Hello!\n\nYou are trying to access the boot level through the editor. What are YOU doing here?\nI bet you just wanna snoop around and mess with the episode, eh?\n\nOh well, I don't blame you. Everything is open, so go right ahead!", true)
--end
local extrasounds = require("extrasounds")
local autoscroll = require("autoscrolla")
local rng = require("base/rng")
local inputconfigurator = require("inputconfig")
local keyboard = require("keyboard")
local hearthover = require("hearthover") --Require hearthover to disable it
local sprite = require("base/sprite")
local aw = require("anotherwalljump")
local lineguide = require("lineguide")

local ready = false

local fontthree = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
local menufont = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus-1x.ini")
local menufontwebsite = textplus.loadFont("littleDialogue/font/hardcoded-45-2-website-textplus-1x.ini")

runPressedState = false

local bootmenu = {}

if bootmenu.active then
    aw.enabled = false
    littleDialogue.cursorEnabled = false
    Graphics.activateHud(false)
    smashud.visible.keys = false
    smashud.visible.itembox = false
    smashud.visible.bombs = false
    smashud.visible.coins = false
    smashud.visible.score = false
    smashud.visible.lives = false
    smashud.visible.stars = false
    smashud.visible.starcoins = false
    smashud.visible.timer = false
    smashud.visible.levelname = false
    smashud.visible.overworldPlayer = false
    smashud.visible.deathcount = false
    smashud.visible.customitembox = false
    datetime.bottomright = true
    datetime.topright = false
    extrasounds.active = false
end

bootmenu.active = false
bootmenu.menuactive = false
bootmenu.intromodeactive = false
bootmenu.hasSavedClasses = false

GameData.____holidayMenuEventEnded = false

local aprilfools = false
local aprilfoolserror = Graphics.loadImageResolved("SMAS - Intro/aprilfools1.png")

local Routine = require("routine")

local level = Level.filename()
local m = RNG.randomInt(1,56-1)

local versionactive = true
local logo = true
local website = true
local pressjumpwords = true
local active = false
local active3 = false
local charactercheck = false
local keyinput1 = false
local killed = false
local active4 = false
local escquit = true
local playernamebyImg = false
local pfpimage = false

local cooldown = 0

local middle = 0

local statusFont = textplus.loadFont("littleDialogue/font/6.ini")

local day = os.date("%d")

local month = os.date("%m")

local exacttime = os.date("%X")

bootmenu.npcResetProperties = {
    -- Monty moles
    [309] = {
        onStart = (function(v)
            local bootmenuData = v.data._bootmenu

            bootmenuData.startedFriendly = v.friendly
        end),
        extraSave = (function(v,fields)
            local bootmenuData = v.data._rooms

            fields.friendly = (bootmenuData and bootmenuData.startedFriendly)
        end),
        extraRestore = (function(v,fields)
            -- Basically just a copy of the normal onStartNPC

            local data = v.data._basegame

            data.wasBuried = 1
            if v.data._settings.startHidden == false then
                data.wasBuried = 0
            else
                data.vanillaFriendly = fields.friendly
                v.friendly = true
                v.noblockcollision = true
            end
            data.timer = 0
            data.direction = v.direction
            data.state = data.wasBuried
        end),
    },

    [469] = {respawn = false}, -- Boo circle boos are set to respawn? for some reason?

    -- Checkpoints
    [192] = {despawn = false,respawn = false},
    [400] = {despawn = false,respawn = false},
    [430] = {despawn = false,respawn = false},
}

bootmenu.classesToSave = {
    -- Classes that tend to shift around a lot (so therefore deletes everything and spawns new ones when resetting)
    {
        name = "Block",get = Block.get,getByIndex = Block,startFromZero = true,
        saveFields = {
            "layerName","contentID","isHidden","slippery","width","height","id","speedX","speedY","x","y",{0x5A,FIELD_BOOL},{0x5C,FIELD_BOOL},
            {0x0C,FIELD_STRING},{0x10,FIELD_STRING},{0x14,FIELD_STRING}, -- Event names
        },
        extraSave    = (function(v,fields) fields.data = table.deepclone(v.data) end),
        extraRestore = (function(v,fields)
            v:translate(0,0) -- Make sure the block array is sorted correctly
            v.data = table.deepclone(fields.data)
        end),

        remove = (function(v) v:delete() end),
        create = (function(fields) return blockSpawnWithSizeableOrdering(fields.id,fields.x,fields.y) end),
    },
    {
        name = "NPC",get = NPC.get,getByIndex = NPC,startFromZero = false,
        saveFields = {
            --[["x","y",]]"spawnX","spawnY","width","height","spawnWidth","spawnHeight","speedX","speedY","spawnSpeedX","spawnSpeedY",
            "direction","spawnDirection","layerName","id","spawnId","ai1","ai2","ai3","ai4","ai5","spawnAi1","spawnAi2","isHidden","section",
            "msg","attachedLayerName","activateEventName","deathEventName","noMoreObjInLayer","talkEventName","legacyBoss","friendly","dontMove",
            "isGenerator","generatorInterval","generatorTimer","generatorDirection","generatorType", -- Generator related stuff
            "despawnTimer",{0x124,FIELD_BOOL},{0x126,FIELD_BOOL},{0x128,FIELD_BOOL}, -- Despawning related stuff
        },
        --[[extraSave    = (function(v,fields) fields.extraSettings = v.data._settings end),
        extraRestore = (function(v,fields) v.data._settings = fields.extraSettings end),]]
        extraSave    = (function(v,fields)
            fields.extraSettings = table.deepclone(v.data._settings)
            fields.isOrbitingNPC = (v.data._orbits ~= nil and v.data._orbits.orbitCenter == nil)

            local properties = bootmenu.npcResetProperties[v.id]

            if properties ~= nil and properties.extraSave ~= nil then
                properties.extraSave(v,fields)
            end

            --if v.id == 119 then Misc.dialog(v.despawnTimer,v:mem(0x124,FIELD_BOOL)) end
        end),
        extraRestore = (function(v,fields)
            v.despawnTimer = 5
            v:mem(0x124,FIELD_BOOL,true)
            
            v:mem(0x14C,FIELD_WORD,1)


            --if v.id == 119 then Misc.dialog(v.despawnTimer,v:mem(0x124,FIELD_BOOL),fields.despawnTimer,fields[0x124]) end


            -- Failsafe because the SMW switch platforms use lineguide data, but don't actually check if it exists
            if lineguide.registeredNPCMap[v.id] and not v.data._basegame.lineguide then
                lineguide.onStartNPC(v)
            end

            -- Without these, hammer bros cause errors
            v.ai1,v.ai2 = fields.spawnAi1,fields.spawnAi2
            v.ai3,v.ai4,v.ai5 = 0,0,0

            v.data._settings = table.deepclone(fields.extraSettings)


            local properties = bootmenu.npcResetProperties[v.id]

            if properties ~= nil and properties.extraRestore ~= nil then
                properties.extraRestore(v,fields)
            end
        end),
        
        remove = (function(v)
            if (NPC.COLLECTIBLE_MAP[v.id] and not bootmenu.collectiblesRespawn) then return end -- Don't do this for collectibles, if set

            local properties = bootmenu.npcResetProperties[v.id]

            if properties ~= nil then
                if properties.despawn == false then
                    return
                elseif properties.remove ~= nil then
                    properties.remove(v)
                end
            end

            -- Rather complicated setup to destroy NPCs
            local data = v.data

            if not v.isGenerator then
                -- Trigger some events, just to make sure that everything gets cleaned up properly
                local eventObj = {cancelled = false}
                EventManager.callEvent("onNPCKill",eventObj,v.idx+1,HARM_TYPE_OFFSCREEN)
                
                if eventObj.cancelled then -- Make sure onPostNPCKill always runs
                    EventManager.callEvent("onPostNPCKill",v,HARM_TYPE_OFFSCREEN)
                end
            end

            v.deathEventName = ""
            v.animationFrame = -1000
            v.isGenerator = false

            v.id = 0

            v:kill(HARM_TYPE_OFFSCREEN)
        end),
        create = (function(fields)
            if (NPC.COLLECTIBLE_MAP[fields.id] and not bootmenu.collectiblesRespawn) then return end -- Don't do this for collectibles, if set
            if fields.spawnId == 0 or fields.layerName == "Spawned NPCs" or fields.isOrbitingNPC then return end -- If set not to respawn or on the spawned NPCs layer, stop
            
            local properties = bootmenu.npcResetProperties[fields.spawnId]

            if properties ~= nil and properties.respawn == false then return end


            return NPC.spawn(fields.spawnId,fields.spawnX,fields.spawnY,fields.section,true,false)
        end),
    },

    -- Classes that tend to be static (so therefore the old properties are just put back when resetting)
    {
        name = "BGO",get = BGO.get,getByIndex = BGO,startFromZero = true,
        saveFields = {"layerName","isHidden","id","x","y","width","height","speedX","speedY"},
    },
    {
        name = "Liquid",get = Liquid.get,getByIndex = Liquid,startFromZero = false,
        saveFields = {"layerName","isHidden","isQuicksand","x","y","width","height","speedX","speedY"},
    },
    {
        name = "Warp",get = Warp.get,getByIndex = Warp,startFromZero = true,
        saveFields = {
            "layerName","isHidden","locked","allowItems","noYoshi","starsRequired",
            "warpType","levelFilename","warpNumber","toOtherLevel","fromOtherLevel","worldMapX","worldMapY",
            "entranceX","entranceY","entranceWidth","entranceHeight","entranceSpeedX","entranceSpeedY","entranceDirection",
            "exitX","exitY","exitWidth","exitHeight","exitSpeedX","exitSpeedY","exitDirection",
        },
    },

    {
        name = "Layer",get = Layer.get,getByIndex = Layer,startFromZero = false,
        saveFields = {"name","isHidden","speedX","speedY"},
    },
    {
        name = "Section",get = Section.get,getByIndex = Section,startFromZero = true,
        saveFields = {
            "boundary","origBoundary","musicID","musicPath","wrapH","wrapV","hasOffscreenExit","backgroundID","origBackgroundID",
            "noTurnBack","isUnderwater","settings",
        },
    },
}

bootmenu.savedClasses = {}

function bootmenu.saveClass(class)
    -- If no class is provided, save all classes
    if class == nil then
        for _,c in ipairs(bootmenu.classesToSave) do
            bootmenu.saveClass(c.name)
        end
        return
    end

    -- Convert name to the actual class
    if type(class) ~= "table" then
        for _,c in ipairs(bootmenu.classesToSave) do
            if c.name == class then
                class = c
                break
            end
        end
    end

    -- Create a table for this class
    bootmenu.savedClasses[class.name] = {}

    -- Go through all objects in this class
    for _,v in ipairs(class.get()) do
        local fields = {}

        if class.saveFields then
            -- Save fields, if they exist
            for _,w in ipairs(class.saveFields) do
                if type(w) == "table" then -- For memory offsets
                    fields[w[1]] = v:mem(w[1],w[2])
                else
                    fields[w] = v[w]
                end
            end
        end

        if class.extraSave then
            class.extraSave(v,fields)
        end

        table.insert(bootmenu.savedClasses[class.name],fields)
    end
end

function bootmenu.restoreClass(class)
    -- If no class is provided, restore all classes
    if class == nil then
        for _,c in ipairs(bootmenu.classesToSave) do
            bootmenu.restoreClass(c.name)
        end
        return
    end

    if not bootmenu.savedClasses[class] then return end -- Don't attempt to restore it if it hasn't been saved yet

    -- Convert name to the actual class
    if type(class) ~= "table" then
        for _,c in ipairs(bootmenu.classesToSave) do
            if c.name == class then
                class = c
                break
            end
        end
    end

    -- Remove all
    if class.remove then
        for _,v in ipairs(class.get()) do
            class.remove(v)
        end
    end

    -- Restore all
    if class.create and class.saveFields or not class.remove and not class.create and class.getByIndex then
        for index,fields in ipairs(bootmenu.savedClasses[class.name]) do
            local v
            if class.create then
                v = class.create(fields)
            elseif class.getByIndex then
                local idx = index
                if class.startFromZero then
                    idx = idx-1
                end

                v = class.getByIndex(idx)
            end

            if v and (v.isValid ~= false) then
                for _,w in ipairs(class.saveFields) do
                    if type(w) == "table" then -- For memory offsets
                        v:mem(w[1],w[2],fields[w[1]])
                    else
                        v[w] = fields[w]
                    end
                end
                if class.extraRestore then
                    class.extraRestore(v,fields)
                end
            end
        end
    end
end

local function introExit()
    GameData.____mainMenuComplete = true
    autoscroll.scrollLeft(5000)
    Routine.waitFrames(38)
    GameData.startedmenu = 0
    Level.load("SMAS - Intro.lvlx", nil, nil)
end

local function BattleRandomLevelSelect()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = true
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(smastables.__classicBattleModeLevels[rng.randomInt(1,#smastables.__classicBattleModeLevels)], nil, nil)
end

local function Battle1()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_battleshrooms.lvlx", nil, nil)
end

local function Battle2()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_battle-zone.lvlx", nil, nil)
end

local function Battle3()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_classic-castle-battle.lvlx", nil, nil)
end

local function Battle4()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_dry-dry-desert.lvlx", nil, nil)
end

local function Battle5()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_hyrule-temple.lvlx", nil, nil)
end

local function Battle6()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_invasion-battlehammer.lvlx", nil, nil)
end

local function Battle7()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_lakitu-mechazone.lvlx", nil, nil)
end

local function Battle8()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_lethal-lava-level.lvlx", nil, nil)
end

local function Battle9()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_retroville-underground.lvlx", nil, nil)
end

local function Battle10()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_slippy-slap-snowland.lvlx", nil, nil)
end

local function Battle11()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_woody-warzone.lvlx", nil, nil)
end

local function Battle12()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_testlevel.lvlx", nil, nil)
end

local function Battle13()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_nsmbds1.lvlx", nil, nil)
end

local function Battle14()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_nsmbds2.lvlx", nil, nil)
end

local function Battle15()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.battlemoderngactive = false
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("battle_nsmbds3.lvlx", nil, nil)
end



local function startRushMode()
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    GameData.rushModeActive = true
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load(smastables.__allMandatoryLevels[rng.randomInt(1,#smastables.__allMandatoryLevels)], nil, nil)
end



local function theme1()
    SaveData.introselect = 1
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMAS.lvlx", nil, nil)
end

local function theme2()
    SaveData.introselect = 2
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMBX1.0.lvlx", nil, nil)
end

local function theme3()
    SaveData.introselect = 3
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMBX1.1.lvlx", nil, nil)
end

local function theme4()
    SaveData.introselect = 4
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMBX1.2.lvlx", nil, nil)
end

local function theme4scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(19)
    autoscroll.scrollLeft(15)
    Routine.wait(8.2)
    Routine.loop(1768, theme4scrolling, true)
end

local function theme5()
    SaveData.introselect = 5
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMBX1.3.lvlx", nil, nil)
end

local function theme5scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(17.3)
    autoscroll.scrollLeft(15)
    Routine.wait(7.2)
    Routine.loop(1571, theme5scrolling, true)
end

local function theme6()
    SaveData.introselect = 6
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_WSMBA.lvlx", nil, nil)
end

local function theme6scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(19.5)
    autoscroll.scrollLeft(15)
    Routine.wait(8)
    Routine.loop(1787, theme6scrolling, true)
end

local function theme7()
    SaveData.introselect = 7
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMBX2.lvlx", nil, nil)
end

local function theme8()
    SaveData.introselect = 8
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_theeditedboss.lvlx", nil, nil)
end

local function theme8scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(17.5)
    autoscroll.scrollLeft(15)
    Routine.wait(7.5)
    Routine.loop(1625, theme8scrolling, true)
end

local function theme9()
    SaveData.introselect = 9
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMBX1.3og.lvlx", nil, nil)
end

local function theme9scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(13.8)
    autoscroll.scrollLeft(15)
    Routine.wait(6.2)
    Routine.loop(1265, theme9scrolling, true)
end

local function theme10()
    SaveData.introselect = 10
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_SMBX2b3.lvlx", nil, nil)
end

local function theme11()
    SaveData.introselect = 11
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_8bit.lvlx", nil, nil)
end

local function theme11scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(16.2)
    autoscroll.scrollLeft(15)
    Routine.wait(7.2)
    Routine.loop(1521, theme11scrolling, true)
end

local function theme12()
    SaveData.introselect = 12
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_S!TS!.lvlx", nil, nil)
end

local function theme13()
    SaveData.introselect = 13
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_sunsetbeach.lvlx", nil, nil)
end

local function theme14()
    SaveData.introselect = 14
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_scrollingheights.lvlx", nil, nil)
end

local function theme14scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollUp(6)
    Routine.wait(13.6)
    autoscroll.scrollDown(15)
    Routine.wait(6.4)
    Routine.loop(1300, theme14scrolling, true)
end

local function theme15()
    SaveData.introselect = 15
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_jakebrito1.lvlx", nil, nil)
end

local function theme15scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(26.2)
    autoscroll.scrollLeft(15)
    Routine.wait(11.0)
    Routine.loop(2418, theme15scrolling, true)
end

local function theme16()
    SaveData.introselect = 16
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_marioforever.lvlx", nil, nil)
end

local function theme17()
    SaveData.introselect = 17
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_jakebrito2.lvlx", nil, nil)
end

local function theme17scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(10.6)
    autoscroll.scrollLeft(15)
    Routine.wait(4.6)
    Routine.loop(lunatime.toTicks(15.2), theme17scrolling, true)
end

local function theme18()
    SaveData.introselect = 18
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_circuitcity.lvlx", nil, nil)
end

local function theme18scrolling()
    bootmenu.restoreClass("NPC")
    autoscroll.scrollRight(6)
    Routine.wait(16.6)
    autoscroll.scrollLeft(15)
    Routine.wait(7)
    Routine.loop(lunatime.toTicks(23.6), theme18scrolling, true)
end

local function theme19()
    SaveData.introselect = 19
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("intro_metroidprime2.lvlx", nil, nil)
end

local function mapExit()
    GameData.____mainMenuComplete = true
    autoscroll.scrollLeft(5000)
    Routine.waitFrames(38)
    GameData.startedmenu = 0
    Level.load("map.lvlx", nil, nil)
end

local function easterEgg() --SnooPINGAS I see? ._.
    Routine.wait(900, true)
    smasbooleans.overrideMusicVolume = true
    Audio.MusicFadeOut(player.section, 4000)
    Routine.wait(10, true)
    Sound.changeMusic("_OST/All Stars Secrets/ZZZ_Easter Egg.ogg", 0)
    Routine.wait(4.2, true)
    active4 = true
end

local function SaveDataError2()
    Sound.muteMusic(-1)
    Audio.SeizeStream(0)
    Routine.wait(1.5)
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0>It looks like SavaData couldn't be read or corrupted.<page>If that is happening, you probably loaded this episode on the broken X2 launcher found in the actual SMBX2 program.<page>Unfortunately, this means that SaveData could be corrupted.<page>Next time, please launch the game using the X2 launch menu found on SMBX2.exe.<page>Please close this dialogue box by pressing jump, then press pause to exit the game.", speakerName = "Whoops!", pauses = false, updatesInPause = true})
end

local function FirstBoot1()
    Sound.changeMusic("_OST/_Sound Effects/nothing.ogg", 0)
    Routine.wait(1.5)
    active = true
    logo = false
    pressjumpwords = false
    Sound.changeMusic("_OST/All Stars Menu/Boot Menu (First Time Boot Menu).ogg", 0)
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.7>Welcome to Super Mario All-Stars++.<page>This game combines Super Mario Bros. 1-3, The Lost Levels, World,<page>And also includes a new game, along with extra content.<page>Please note that this is an Open Source project.<page>So please understand that BUGS may occur! Don't hesitate to report them on the GitHub page.<page>You can find it at https://github.com/SpencerEverly/smasplusplus/.<page>Other than that, please enjoy the game!<page>But, before we get started, this game needs to set up some prerequisite options.<question FirstBootMenuOne>", speakerName = "Welcome!", pauses = false, updatesInPause = true})
end

local function MigrateOldSave1()
    Sound.changeMusic("_OST/_Sound Effects/nothing.ogg", 0)
    Routine.wait(1.5)
    active = true
    logo = false
    pressjumpwords = false
    Sound.changeMusic("_OST/Photo Channel (Wii)/Slideshow (Scenic).ogg", 0)
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.7>It looks like you have an old save you'll need to migrate immediately.<page>The reason why you'll need to migrate your save is because your current save is outdated and needs to be refreshed for this Demo,<page>and beyond for future releases. Please note that, once you migrate your data, it will be imcompatible with old releases.<page>So please do this if you are actually willing to upgrade to Demo 3 and beyond.<question MigrateSaveMenuOne>", pauses = false, updatesInPause = true})
end

local function MigrateOldSave2()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.7>Please note that before you do this, a final reminder that this save data will be upgraded, and the data will not be compatible with older releases.<page>Be sure you want to proceed before doing so.<question MigrateSaveMenuTwo>", pauses = false, updatesInPause = true})
end

local starList
local starListOptional

local function MigrateOldSave3()
    SaveData.totalCoinsClassic = mem(0x00B2C5A8, FIELD_WORD)
    SaveData.totalLives = mem(0x00B2C5AC, FIELD_FLOAT)
    SaveData.totalScoreClassic = Misc.score()
    GameData.temporaryPowerupStored = player.powerup
    for k,v in ipairs(smastables.__allLevels) do
        if table.icontains(Misk.getLegacyStarsCollectedNameOnly(),v) == true then
            table.insert(SaveData.completeLevels, v)
        end
    end
    for k,v in ipairs(smastables.__allLevelsOptional) do
        if table.icontains(Misk.getLegacyStarsCollectedNameOnly(),v) == true then
            table.insert(SaveData.completeLevelsOptional, v)
        end
    end
    SaveData.totalStarCount = #SaveData.completeLevels
    Misk.eraseMainSaveSlot(Misc.saveSlot())
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.7>Save has been officially migrated! Please go ahead and restart the game to successfully migrate your entire data.<question RestartOptionNoSaveErase>", pauses = false, updatesInPause = true})
end

local function MigrateOldSaveCancelled()
    Sound.changeMusic("_OST/_Sound Effects/nothing.ogg", 0)
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.7>Please note that you need to upgrade your save data to use Demo 3. Try again next time when you are ready to do so.<question MigrateSaveMenuCancel>", pauses = false, updatesInPause = true})
end

local function FirstBoot3()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.6>Check the date and time below (It should be on the bottom-right corner). Is that time, and the system date correct?<question FirstBootMenuTwo>", pauses = false, updatesInPause = true})
end

local function FirstBoot4()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.6>And now, we need to know your name. What is your name? Press Begin and type up your name (You'll need to use a keyboard for this).<question FirstBootMenuThree>", pauses = false, updatesInPause = true})
end

local function FirstBootKeyboardConfig()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.3>Finally, we need you to configurate your inputs for the game. To start configuring the controls, please select start. You'll want to configurate Player 2's controls later if you're playing in 1.3 Mode.<question FirstBootMenuKeyboard>", pauses = false, updatesInPause = true})
end

local function FirstBoot5()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.8>Looks like you're good! Before you begin, do you know how to play the game?<page>If you already know how to play, you can select Skip.<question FirstBootMenuFour>", pauses = false, updatesInPause = true})
end

local function FirstBoot6()
    Sound.changeMusic("_OST/All Stars Menu/Boot Menu (First Boot).ogg", 0)
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.4>Without further ado, Super Mario All-Stars++!<question FirstBootMenuFive>", pauses = false, updatesInPause = true})
    if SaveData.firstBootCompleted == false then
        SaveData.firstBootCompleted = true
        GameData.playernameenterfirstboot = false
    end
    GameData.playernameenterfirstboot = false
    Misc.saveGame()
end
    
local function FirstBootGameHelp()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.3>To get help in playing the game, you'll need to redirect to the Game Help level. Would you like to enter the level, or skip? You can load Game Help again on the title screen later if you want to.<question FirstBootMenuGameHelp>", pauses = false, updatesInPause = true})
    Misc.saveGame()
end

local function TimeFixInfo1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.6>Depending on the issue, please visit sites like https://support.kaspersky.com/common/windows/3508<page>Or use Google/DuckDuckGo and search up -fixing system time-.<page>Please fix the time first, then after fixing the time should automatically update. Press -Recheck- to recheck the time again.<question FirstBootMenuTimeFix>", pauses = false, updatesInPause = true})
end

local function FailsafeMessage1()
    active = true
    if SaveData.failsafeMessageOne == 1 then
        SaveData.failsafeMessageOne = SaveData.failsafeMessageOne - 1
    end
    Sound.muteMusic(-1)
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.9>It looks like the menu restarted.<page>When that happened, you probably died here in the boot screen.<page>If there are any problems, don't hesitate to email spencer.everly at gmail.com or contact them on Discord at Spencer Everly#1997.<question ToMenuResetTwo>", speakerName = "Whoops!", pauses = false, updatesInPause = true})
end

local function bootDialogue()
    bootmenu.menuactive = true
    active = true
    active4 = false
    pressjumpwords = false
    playernamebyImg = false
    pfpimage = false
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0><question MainMenu>", speakerName = "Main Menu", pauses = false, updatesInPause = true})
end

local function menuDialogue()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0><question MainMenu>", speakerName = "Main Menu", pauses = false, updatesInPause = true})
end

local function gamebootDialogue()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.3><question GameBoot>", speakerName = "Start Game", pauses = false, updatesInPause = true})
end

local function battleModeDialogue()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.5><question BattleSelect>", speakerName = "Minigames", pauses = false, updatesInPause = true})
end

local function optionsMenu1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0><question Options>", speakerName = "Options", pauses = false, updatesInPause = true})
end

local function themeMenu1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0><question IntroTheme>", speakerName = "Themes", pauses = false, updatesInPause = true})
end

local function ResolutionSelect1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.2><question ResolutionSelect>", speakerName = "Resolution Selection", pauses = false, updatesInPause = true})
end

local function ClockSelect1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0><question ClockSelect>", speakerName = "Clock Theme Selection", pauses = false, updatesInPause = true})
end



local function classicBattleSelect()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.1>Select level.<question BattleLevelSelect>", pauses = false, updatesInPause = true})
end

local function ChangeName1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.1>To change your name in the game, please select Begin to get started (Keyboard only).<question StartNameChange>", pauses = false, updatesInPause = true})
end

local function ChangePFP1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.8>To change your profile picture in the game, please select Begin to get started (Keyboard only).<question StartPFPChange>", pauses = false, updatesInPause = true})
end

local function ResolutionChange1()
    Sound.playSFX("resolution-set.ogg")
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.8>Resolution changed. Check it out right now!<question ReturnMenu>", pauses = false, updatesInPause = true})
end

local function ResolutionChangeBorder2()
    if SaveData.borderEnabled == true then
        Sound.playSFX("resolutionborder-disable.ogg")
        SaveData.borderEnabled = false
    elseif SaveData.borderEnabled == false then
        Sound.playSFX("resolutionborder-enable.ogg")
        SaveData.borderEnabled = true
    end
    littleDialogue.create({text = "<setPos 400 32 0.5 -2.1>Border toggled on/off. Check it out right now!<question ReturnMenu>", pauses = false, updatesInPause = true})
end

local function ResolutionChangeScale3()
    if SaveData.letterbox == true then
        Sound.playSFX("letterbox-disable.ogg")
        SaveData.letterbox = false
    elseif SaveData.letterbox == false then
        Sound.playSFX("letterbox-enable.ogg")
        SaveData.letterbox = true
    end
    littleDialogue.create({text = "<setPos 400 32 0.5 -2.3>Scaling toggled on/off. Check it out right now!<question ReturnMenu>", pauses = false, updatesInPause = true})
end

local function ClockChange1()
    Sound.playSFX("hour-change.ogg")
    littleDialogue.create({text = "<setPos 400 32 0.5 -2.3>Clock theme changed. Check it out right now!<question ReturnMenu>", pauses = false, updatesInPause = true})
end

local function credits1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.1>For information on everything that made this episode possible,<page>It wouldn't have been possible without more than 100 people and counting.<page>To see the credits of this episode, go into the worlds folder,<page>the SMAS folder, and redirect to the CREDITS.txt file in the folder.<question ReturnMenu>", speakerName = "Credits", pauses = false, updatesInPause = true})
end

local function X2Char()
    if SaveData.disableX2char == false then
        Sound.playSFX("1.3Mode/bowser-killed.ogg")
        SaveData.disableX2char = true
        SaveData.thirteenmodelives = mem(0x00B2C5AC,FIELD_FLOAT)
        littleDialogue.create({text = "<setPos 400 32 0.5 -2.3>Game settings have been applied.<question OkayToMenu>", pauses = false, updatesInPause = true})
    elseif SaveData.disableX2char == true then
        Sound.playSFX("x2-mode-enabled.ogg")
        SaveData.disableX2char = false
        littleDialogue.create({text = "<setPos 400 32 0.5 -2.3>Game settings have been applied.<question OkayToMenu>", pauses = false, updatesInPause = true})
    end
end

local function InputConfig1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.2>To begin configuring the inputs of the game,<page>please select an option depending on the controls currently being used.<question StartInputs>", pauses = false, updatesInPause = true})
end

local function startConfigurator()
    inputconfigurator.controlConfigOpen = true
end

local function startPreConfiguratorKeyboard()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.4>Which player would you like to assign keys to?<question StartInputPlayers>", pauses = false, updatesInPause = true})
end

local function startConfiguratorKeyboard()
    inputconfigurator.keyConfigOpen = true
    inputconfigurator.assigningToPlayer1 = true
end

local function startConfiguratorKeyboardP2()
    inputconfigurator.keyConfigOpen = true
    inputconfigurator.assigningToPlayer2 = true
end

local function startKeyboard()
    keyboard.active = true
    GameData.enablekeyboard = true
    GameData.playernameenter = true
end

local function startKeyboardFirstBoot()
    keyboard.active = true
    GameData.enablekeyboard = true
    GameData.playernameenterfirstboot = true
end

local function startKeyboardPFP()
    keyboard.active = true
    GameData.enablekeyboard = true
    GameData.playerpfpenter = true
end

local function startSaveSwitcher1()
    keyboard.active = true
    GameData.enablekeyboard = true
    GameData.saveslotswitchenter = true
end

local function PFPinfo1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0>Your profile picture can be used when you launch Online Multiplayer, or to see who is running the game at this session.<page>Your profile picture will also be used during the story, along with your name.<page>To specify the profile picture using the keyboard, please type up the path from '___MainUserDirectory' to the profile picture you are going to use.<page>'___MainUserDirectory' is a user modifiable directory that can be used for files you specify for the episode, such as a profile picture (PNG only).<page>Don't worry if you don't want to specify one, there's already a default profile picture for you already set up.<page>But if you want to go ahead and set one up, please specify to begin anytime on that menu.<page>With that out of the way, that's how you set up a profile picture for the episode!<question OkayToMenuOptions>", pauses = false, updatesInPause = true})
end

local function X2DisableCheck1()
    if Player.count() == 1 then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.4>Would you like to enable/disable SMBX 1.3 mode?<page>If enabled, certain features will be disabled and some compatibility for 2 player mode will be restored.<page>Costumes will reset, so be careful enabling this option!<question X2CharacterDisableOne>", pauses = false, updatesInPause = true})
    end
    if Player.count() == 2 then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.4>You can't use 2 player mode on X2 mode. Please disable SMBX 1.3 mode first before proceeding.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
    end
end

local function TwoPlayerDisEnable1()
    if SaveData.disableX2char == true then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.2>Since you have X2 characters disabled, you can use 2 player mode!<page>Would you like to enable/disable 2 player mode?<question TwoPlayerDisableOne>", pauses = false, updatesInPause = true})
    elseif SaveData.disableX2char == false then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.8>Unfortunately, you'll need to turn on 1.3 Mode to toggle this on and off.<page>This is due to stability and game breaking reasons.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
    end
end

local function BattleModeDisEnable1()
    if SaveData.disableX2char == true then
        if Player.count() == 1 then
            littleDialogue.create({text = "<setPos 400 32 0.5 -1.2>Since you have X2 characters disabled, you can use Battle Mode!<page>Would you like to start battle mode? We'll need to enable 2 player mode first.<question BattleTwoPlayerCheckOne>", pauses = false, updatesInPause = true})
        end
        if Player.count() == 2 then
            littleDialogue.create({text = "<setPos 400 32 0.5 -1.2>Since you have X2 characters disabled, you can use Battle Mode!<page>Would you like to start battle mode? You already have 2 player mode enabled for this.<question BattleTwoPlayerCheckTwo>", pauses = false, updatesInPause = true})
        end
    elseif SaveData.disableX2char == false then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.8>Unfortunately, you'll need to turn on 1.3 Mode to start Classic Battle Mode.<page>This is due to stability and game breaking reasons.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
    end
end

local function RushModeMenu1()
    if Player.count() == 1 then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.8>It looks like you can use Rush Mode!<page>Would you like to start Rush Mode?<question RushModeSelectionOne>", pauses = false, updatesInPause = true})
    end
    if Player.count() == 2 then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.0>You'll need to disable 2 player mode before continuing. To disable 2 player mode, head into Settings and select 2 Player Mode.<question OkayToMenuTwoOptions>", pauses = false, updatesInPause = true})
    end
end

local function FramerateToggle1()
    SaveData.framerateEnabled = not SaveData.framerateEnabled
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.2>Framerate has been toggled either on or off. You can see it on the top-left corner of the screen.<question OkayToMenu>", pauses = false, updatesInPause = true})
end

local function TwoPlayerCheck()
    Playur.activate2ndPlayer()
    Defines.player_hasCheated = false
    littleDialogue.create({text = "<setPos 400 32 0.5 -3.1>2 player mode activated.<question OkayToMenu>", pauses = false, updatesInPause = true})
end

local function TwoPlayerCheckBattle()
    Playur.activate2ndPlayer()
    Defines.player_hasCheated = false
    littleDialogue.create({text = "<setPos 400 32 0.5 -3.1>2 player mode activated.<question OkayToBattle>", pauses = false, updatesInPause = true})
end

local function ExitClassicBattle()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.2>Exiting battle mode activated. You'll need to manually turn off 2 player mode in the settings tab.<question OkayToMenu>", pauses = false, updatesInPause = true})
end

local function OnePlayerCheckWarning()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.9>Please note that there are errors and bugs that occur when switching back to 1 player mode within this option.<page>To prevent errors, we need you to press 'No' and restart the game by closing it.<page>But, if you wanna REALLY make sure you wanna error out the episode for debugging if you are smart enough to report a fix, please press 'Yes' instead.<question OnePlayerChoosing>", pauses = false, updatesInPause = true})
end

local function OnePlayerCheck()
    Playur.activate1stPlayer()
    Defines.player_hasCheated = false
    littleDialogue.create({text = "<setPos 400 32 0.5 -3.1>1 player mode activated.<question OkayToMenu>", pauses = false, updatesInPause = true})
end

local function FailsafeMessage1()
    --SaveData.totalLives = SaveData.totalLives + 1
end

local function PathFix1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.6>Would you like to fix the world map paths? Only do this if future updates break the map.<question ToBeAddedSoon>", pauses = false, updatesInPause = true})
end

local function ChangeChar1()
    if SaveData.disableX2char == false then
        littleDialogue.create({text = "<setPos 400 32 0.5 -0.9>Who shall you change into?<question CharacterListX2>", pauses = false, updatesInPause = true})
    end
    if SaveData.disableX2char == true then
        if Player.count() == 2 then
            littleDialogue.create({text = "<setPos 400 32 0.5 -1.7>Which player do you want to change characters to?<question PlayerChoosingOne>", pauses = false, updatesInPause = true})
        elseif Player.count() == 1 then
            littleDialogue.create({text = "<setPos 400 32 0.5 -0.9>Who shall you change Player 1 into?<question CharacterList1>", pauses = false, updatesInPause = true})
        end
    end
end

local function ChangeChar1P()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.9>Who shall you change Player 1 into?<question CharacterList1>", pauses = false, updatesInPause = true})
end

local function ChangeChar2P()
    littleDialogue.create({text = "<setPos 400 32 0.5 -0.9>Who shall you change Player 2 into?<question CharacterList2>", pauses = false, updatesInPause = true})
end

local function ChangedCharacter()
    Sound.playSFX("charcost-selected.ogg")
    if Player.count() == 1 then
        littleDialogue.create({text = "<setPos 400 32 0.5 -2.5>Character changing succeeded.<question OkayToMenuOptions>", pauses = false, updatesInPause = true})
    end
    if Player.count() == 2 then
        littleDialogue.create({text = "<setPos 400 32 0.5 -2.5>Character changing succeeded.<question OkayToMenuOptions>", pauses = false, updatesInPause = true})
    end
end

local function SaveOptions1()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.3><question SavingMenuOne>", speakerName = "Saving Options", pauses = false, updatesInPause = true})
end

local function SaveSlot1()
    if not Misc.inEditor() then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.2>To begin switching the save slot, please select Begin to get started (Keyboard only).<page>THIS WILL OVERWRITE ANY SAVES THAT WERE SWITCHED TO ANY SLOT, USE WITH CAUTION!<question StartSaveSwitcher>", pauses = false, updatesInPause = true})
    elseif Misc.inEditor() then
        littleDialogue.create({text = "<setPos 400 32 0.5 -1.5>You can't do this while in the editor mode.<page>Please start an actual game to switch saves.<page>You can also manually do this yourself by renaming save slots in the episode folder.<question OkayToMenuOptions>", pauses = false, updatesInPause = true})
    end
end

local function EraseSave1()
    Sound.muteMusic(-1)
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.4>Once you erase your save, you CAN NOT go back unless you use tools like Recuva.<page>Erasing your save is for if you want to start over from the beginning.<question SaveErasePreChoice>", pauses = false, updatesInPause = true})
end

local function EraseSave2()
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.8>ARE YOU SURE YOU WANT TO ERASE YOUR SAVE DATA?<question SaveEraseChoice>", pauses = false, updatesInPause = true})
end

local function BootDialogueMusicReset()
    bootmenu.menuactive = true
    active = true
    active4 = false
    pressjumpwords = false
    stpatricksday = false
    playernamebyImg = false
    pfpimage = false
    littleDialogue.create({text = "<setPos 400 32 0.5 -1.0><question MainMenu>", speakerName = "Main Menu", pauses = false, updatesInPause = true})
    Sound.restoreMusic(-1)
end

local function ExitDialogueFirstBoot()
    bootmenu.menuactive = false
    playernamebyImg = true
    pfpimage = true
    active = false
    logo = true
    pressjumpwords = true
    if SaveData.firstBootCompleted == true then
        GameData.startedmenu = GameData.startedmenu - 1
    end
    if GameData.startedmenu == nil then
        GameData.startedmenu = 4
    end
    if Time.month() == 03 and Time.day() == 17 then
        stpatricksday = true
    end
end

local function ExitDialogue()
    bootmenu.menuactive = false
    active = false
    logo = true
    playernamebyImg = true
    pfpimage = true
    pressjumpwords = true
    if SaveData.firstBootCompleted == true then
        GameData.startedmenu = GameData.startedmenu - 1
    end
    if Time.month() == 03 and Time.day() == 17 then
        stpatricksday = true
    end
end

local function ExitDialogueMusicReset()
    bootmenu.menuactive = false
    active = false
    logo = true
    playernamebyImg = true
    pfpimage = true
    pressjumpwords = true
    if SaveData.firstBootCompleted == true then
        GameData.startedmenu = GameData.startedmenu - 1
    end
    if Time.month() == 03 and Time.day() == 17 then
        stpatricksday = true
    end
    Sound.restoreMusic(-1)
end

local function MusicReset()
    bootmenu.menuactive = false
    if Time.month() == 03 and Time.day() == 17 then
        stpatricksday = true
    end
    Sound.restoreMusic(-1)
end

local function ExitGame1()
    exitscreen = true
    Sound.muteMusic(-1)
    Misc.saveGame()
    Routine.wait(0.4)
    Misc.exitEngine()
end

local function ExitGameNoSave()
    exitscreen = true
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.exitEngine()
end

local function SaveEraseStart()
    --Start opening SMAS++'s save files. From there, write default data to the files.
    Misk.eraseSaveSlot(Misc.saveSlot())
    --Then make the message telling that it's erased.
    littleDialogue.create({text = "<setPos 400 32 0.5 -3.1>Erasing complete.<question RestartOption>", pauses = false, updatesInPause = true})
end

local function ExitToIntro() --This command will auto load the intro
    Level.load("SMAS - Intro.lvlx", nil, nil)
end

local function ExitToMap() --This command will exit to the main map
    Level.load("map.lvlx", nil, nil)
end

local function BootSMASPlusPlusPreExecute() --This is the routine animation to execute the SMAS++ countdown to load either the intro or the map.
    Sound.playSFX("startsmasboot-executed.ogg")
    Sound.playSFX("startsmasboot-timerbeep.ogg")
    active3 = true
    logo = true
    Routine.wait(1.0) --Each second play a sound
    Sound.playSFX("startsmasboot-timerbeep.ogg")
    Routine.wait(1.0)
    Sound.playSFX("startsmasboot-timerbeep.ogg")
    Routine.wait(1.0)
    Sound.playSFX("startsmasboot-fullyexecuted.ogg")
    exitscreen = true --Black out everything
    logo = false
    active3 = false
    autoscroll.scrollLeft(5000) --Make sure that autoscroll doesn't move the player when loading any other level by accident
    Sound.muteMusic(-1) --Change the music to nothing
    Routine.wait(0.5)
    Misc.saveGame()
    if (player.keys.down == KEYS_DOWN) == true then --Either one when holding down or not, executes a routine on which one to execute
        Routine.run(mapExit)
    end
    if (player.keys.down == KEYS_DOWN) == false then 
        Routine.run(introExit)
    end
end

local function BootCredits() --The credits lvl will probably be scrapped or not, depends
    Sound.muteMusic(-1)
    exitscreen = true
    SFX.play(14)
    Routine.wait(0.5)
    Level.load("SMAS - Credits.lvlx", nil, nil)
end

local function RestartSMASPlusPlusResetSave() --This restarts SMAS++ entirely, when erasing the save data
    Sound.muteMusic(-1)
    exitscreen = true
    Routine.wait(0.5)
    Misc.dialog("There WILL be a few errors before restarting. This is normal. Just click okay (Or press ENTER) on all dialog boxes that pop up, and the episode will restart.")
    SaveData.clear()
    GameData.clear()
    SaveData.flush()
    if Misc.loadEpisode("Super Mario All-Stars++") == false then
        SFX.play("wrong.ogg")
        error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
    end
end

local function RestartSMASPlusPlus() --This restarts SMAS++ entirely
    Sound.muteMusic(-1)
    exitscreen = true
    Routine.wait(0.5)
    if Misc.loadEpisode("Super Mario All-Stars++") == false then
        SFX.play("wrong.ogg")
        error("SMAS++ is not found. How is that even possible? Reinstall the game using the SMASUpdater, since something has gone terribly wrong.")
    end
end

local function BootGameHelpPreExecute() --Boot the game help level, the boot menu version at least
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("SMAS - Game Help (Boot Menu).lvlx", nil, nil)
end

local function BootOnlinePreExecute() --Boot the Online Menu level
    exitscreen = true
    autoscroll.scrollLeft(5000)
    Sound.muteMusic(-1)
    Routine.wait(0.4)
    Misc.saveGame()
    Level.load("SMAS - Online (Menu).lvlx", nil, nil)
end

local function PigeonRaca1() --This executes the True Final Battle
    if player.keys.jump == KEYS_PRESSED then
        player.keys.jump = KEYS_UNPRESSED
        Routine.wait(4.5) --Wait until loading the True Final Battle cutscene...
        GameData.startedmenu = 0
        Level.load("SMAS - Raca's World (Part 0).lvlx", nil, nil)
    end
end

local function foolsinapril() --April Fools event for 4/1 of any year
    GameData.holidayrun = false
    Misc.pause()
    Routine.wait(5.5, true)
    Sound.playSFX("aprilfools.ogg")
    Routine.wait(2, true)
    Misc.unpause()
    aprilfools = false
    GameData.musreset = true
    logo = true
    datetime.bottomright = true
    active = false
    pressjumpwords = true
    GameData.____holidayMenuEventEnded = true
    GameData.startedmenu = GameData.startedmenu - 1
end

function bootmenu.onInitAPI() --This requires some libraries to start
    registerEvent(bootmenu,"onExit")
    registerEvent(bootmenu,"onStart")
    registerEvent(bootmenu,"onTick")
    registerEvent(bootmenu,"onTickEnd")
    registerEvent(bootmenu,"onInputUpdate")
    registerEvent(bootmenu,"onEvent")
    registerEvent(bootmenu,"onDraw")
    registerEvent(bootmenu,"onEvent")
    registerEvent(bootmenu,"onPlayerHarm")
    
    local Routine = require("routine")
    
    ready = true --We're ready, so we can begin
end

function bootmenu.onTickEnd()
    -- Save classes (this is done after onStart so custom stuff has already been initiated)
    if not bootmenu.hasSavedClasses then
        bootmenu.saveClass()
        bootmenu.hasSavedClasses = true
    end
end

function bootmenu.onStart()
    if bootmenu.active then
        cursor.create()
        cursor.showCursor = true
        Audio.MusicVolume(nil) --Let the music volume reset
        if mem(0x00B251E0, FIELD_WORD) >= 1 then
            GameData.saveDataMigrated = false
        end
        if mem(0x00B251E0, FIELD_WORD) == 0 then
            GameData.saveDataMigrated = true
        end
        if GameData.saveDataMigrated == false then
            Routine.run(MigrateOldSave1)
            GameData.startedmenu = 1
        end
        if SaveData.firstBootCompleted == nil then
            SaveData.firstBootCompleted = false --If starting for the first time, first boot will happen
        end
        if SaveData.firstBootCompleted == false and GameData.saveDataMigrated == true then
            Routine.run(FirstBoot1)
            GameData.startedmenu = 1
        end
        if SaveData.firstBootCompleted == true and GameData.saveDataMigrated == true then
            GameData.playernameenterfirstboot = false
            Routine.run(easterEgg, true)
            playernamebyImg = true
            pfpimage = true
        end
        if Time.month() == 12 and Time.day() == 25 then --Change the weather on Christmas Day to snow
            Section(0).effects.weather = WEATHER_SNOW
        end
        if SaveData.disableX2char == false then
            x2noticecheck = active
            x2noticecheckactive = not active
        end
        if SaveData.disableX2char == true then
            x2noticecheck = not active
            x2noticecheckactive = active
        end
        Misc.saveGame()
        Defines.cheat_donthurtme = true --These are to prevent the player from dying
        Defines.cheat_shadowmario = true
        hearthover.active = false --No hearthover on the bootmenu
        if Time.month() == 04 and Time.day() == 01 then --BSOD lmao
            if GameData.____holidayMenuEventExecuted == nil or GameData.____holidayMenuEventExecuted == false and GameData.____holidayMenuEventEnded == false then
                GameData.startedmenu = 1
            elseif GameData.____holidayMenuEventEnded == true then
                GameData.startedmenu = 0
            end
        end
        if Time.month() == 03 and Time.day() == 17 then --St. Patrick's Day event
            stpatricksday = true
        end
        if Level.filename() == "intro_SMAS.lvlx" then
            if not SaveData.firstBootCompleted then
                --Nothing
            elseif SaveData.firstBootCompleted then
                Sound.changeMusic("_OST/All Stars Menu/Boot Menu.ogg", 0)
            end
        end
        if Level.filename() == "intro_SMBX1.2.lvlx" then
            Routine.run(theme4scrolling)
        end
        if Level.filename() == "intro_SMBX1.3.lvlx" then
            Routine.run(theme5scrolling)
        end
        if Level.filename() == "intro_WSMBA.lvlx" then
            Routine.run(theme6scrolling)
        end
        if Level.filename() == "intro_theeditedboss.lvlx" then
            Routine.run(theme8scrolling)
        end
        if Level.filename() == "intro_SMBX1.3og.lvlx" then
            Routine.run(theme9scrolling)
        end
        if Level.filename() == "intro_8bit.lvlx" then
            Routine.run(theme11scrolling)
        end
        if Level.filename() == "intro_scrollingheights.lvlx" then
            Routine.run(theme14scrolling)
        end
        if Level.filename() == "intro_jakebrito1.lvlx" then
            Routine.run(theme15scrolling)
        end
        if Level.filename() == "intro_jakebrito2.lvlx" then
            Routine.run(theme17scrolling)
        end
        if Level.filename() == "intro_circuitcity.lvlx" then
            Routine.run(theme18scrolling)
        end
    end
end

function bootmenu.onPlayerHarm(eventToken, harmedPlayer)
    if bootmenu.active then
        if stateVar == 1 then
            eventToken.cancelled = true
        end
    end
end

function bootmenu.onTick()
    if bootmenu.active then
        if SaveData.firstBootCompleted == nil then
            SaveData.firstBootCompleted = false
        end
        if SaveData.firstBootCompleted == false then
            GameData.startedmenu = 1
        end
        if SaveData.firstBootCompleted == true then
            
        end
        if GameData.startedmenu == nil then
            GameData.startedmenu = GameData.startedmenu or 0
        end
        if GameData.reopenmenu == true then
            Routine.run(bootDialogue)
            GameData.reopenmenu = false
        end
        if GameData.firstbootfive == true then
            Routine.run(FirstBoot5)
            GameData.firstbootfive = false
        end
        if GameData.firstbootkeyboardconfig == true then
            Routine.run(FirstBootKeyboardConfig)
            GameData.firstbootkeyboardconfig = false
        end
        if GameData.reopenmenumusreset == true then
            Routine.run(BootDialogueMusicReset)
            GameData.reopenmenumusreset = false
        end
        if GameData.musreset == true then
            Routine.run(MusicReset)
            GameData.musreset = false
        end
        Graphics.activateHud(false)
        littleDialogue.defaultStyleName = "bootmenudialog" --Change the text box to the SMBX 1.3 menu textbox format
        if Player.count() == 1 then
            twoplayercheck = active
            twoplayercheckactive = not active
        end
        if not bootmenu.intromodeactive then
            for _,p in ipairs(Player.get()) do
                p:setFrame(50) --Prevent any player from showing up on the boot menu
                p:mem(0x140, FIELD_BOOL, 150)
                if p:mem(0x140, FIELD_BOOL) == 0 then
                    p:mem(0x140, FIELD_BOOL, 150)
                end
                p.x = camera.x + 450 - (p.width / 2) --Force all players somewhere to prevent deaths
                p.y = camera.y - 1 - (p.height / 2)
            end
        end
        if Player.count() >= 2 then
            twoplayercheck = not active
            twoplayercheckactive = active
        end
        if SaveData == nil then
            Routine.run(SaveDataError1)
        end
        if SaveData.disableX2char == nil then
            SaveData.disableX2char = false
        end
        if SaveData.disableX2char == false then
            x2noticecheck = active
            x2noticecheckactive = not active
            smashud.visible.lives = false
        end
        if SaveData.disableX2char == true then
            smashud.visible.lives = false
            x2noticecheck = not active
            x2noticecheckactive = active
            for _,p in ipairs(Player.get()) do
                p.setCostume(1, nil)
                p.setCostume(2, nil)
                p.setCostume(3, nil)
                p.setCostume(4, nil)
                p.setCostume(5, nil)
            end
        end
        if(not killed and player:mem(0x13E,FIELD_BOOL)) then
            killed = true
            SaveData.failsafeMessageOne = SaveData.failsafeMessageOne + 1
        end
        if SaveData.failsafeMessageOne == nil then
            SaveData.failsafeMessageOne = SaveData.failsafeMessageOne or 0
        end
        if SaveData.failsafeMessageOne == 0 then
            --Nothing happens
        end
        if SaveData.failsafeMessageOne == 1 then
            Routine.run(FailsafeMessage1)
        end
        for i = 1,91 do
            Audio.sounds[i].muted = true
        end
        Audio.sounds[1].muted = true
        Audio.sounds[2].muted = true
        Audio.sounds[3].muted = true
        Audio.sounds[4].muted = true
        Audio.sounds[5].muted = true
        Audio.sounds[6].muted = true
        Audio.sounds[7].muted = true
        Audio.sounds[8].muted = true
        Audio.sounds[9].muted = true
        Audio.sounds[10].muted = true
        Audio.sounds[11].muted = true
        Audio.sounds[12].muted = true
        Audio.sounds[13].muted = true
        Audio.sounds[14].muted = true
        Audio.sounds[15].muted = true
        Audio.sounds[16].muted = true
        Audio.sounds[17].muted = true
        Audio.sounds[18].muted = true
        Audio.sounds[19].muted = true
        Audio.sounds[20].muted = true
        Audio.sounds[21].muted = true
        Audio.sounds[22].muted = true
        Audio.sounds[23].muted = true
        Audio.sounds[24].muted = true
        Audio.sounds[25].muted = true
        Audio.sounds[29].muted = true
        Audio.sounds[31].muted = true
        Audio.sounds[32].muted = true
        Audio.sounds[33].muted = true
        Audio.sounds[34].muted = true
        Audio.sounds[35].muted = true
        Audio.sounds[36].muted = true
        Audio.sounds[37].muted = true
        Audio.sounds[42].muted = true
        Audio.sounds[43].muted = true
        Audio.sounds[44].muted = true
        Audio.sounds[46].muted = true
        Audio.sounds[48].muted = true
        Audio.sounds[49].muted = true
        Audio.sounds[50].muted = true
        Audio.sounds[51].muted = true
        Audio.sounds[52].muted = true
        Audio.sounds[54].muted = true
        Audio.sounds[55].muted = true
        Audio.sounds[57].muted = true
        Audio.sounds[58].muted = true
        Audio.sounds[59].muted = true
        Audio.sounds[61].muted = true
        Audio.sounds[62].muted = true
        Audio.sounds[63].muted = true
        Audio.sounds[71].muted = true
        Audio.sounds[72].muted = true
        Audio.sounds[73].muted = true
        Audio.sounds[74].muted = true
        Audio.sounds[75].muted = true
        Audio.sounds[76].muted = true
        Audio.sounds[77].muted = true
        Audio.sounds[78].muted = true
        Audio.sounds[79].muted = true
        Audio.sounds[80].muted = true
        Audio.sounds[81].muted = true
        Audio.sounds[82].muted = true
        Audio.sounds[83].muted = true
        Audio.sounds[84].muted = true
        Audio.sounds[85].muted = true
        Audio.sounds[86].muted = true
        Audio.sounds[87].muted = true
        Audio.sounds[88].muted = true
        Audio.sounds[89].muted = true
        Audio.sounds[90].muted = true
        Audio.sounds[91].muted = true
        
        if runPressedState == true then
            player.keys.run = false
        end
    end
end

function bootmenu.onPause(evt)
    if bootmenu.active then
        evt.cancelled = true;
        isPauseMenuOpen = not isPauseMenuOpen
    end
end

function bootmenu.onInputUpdate()
    if bootmenu.active then
        player.keys.run = false
        player.keys.altJump = false
        player.keys.altRun = false
        player.keys.dropItem = false
        if player.rawKeys.pause == KEYS_PRESSED and bootmenu.menuactive == false then
            if SaveData.firstBootCompleted == true then
                Routine.run(ExitGame1)
                Sound.playSFX("littleDialogue/smbx13/choose.wav")
            end
        end
        if GameData.startedmenu == 0 then
            if player.keys.jump == KEYS_PRESSED then
                Routine.run(bootDialogue)
                GameData.startedmenu = GameData.startedmenu + 1
            end
        end
        if GameData.startedmenu == 1 then
            if player.keys.jump == KEYS_PRESSED then
                --Nothing
            end
        end
        if GameData.startedmenu == 2 then
            if player.keys.jump == KEYS_PRESSED then
                Sound.changeMusic("_OST/All Stars Menu/Boot Menu (Crash SFX).ogg", 0)
                Section(player.section).effects.weather = WEATHER_NONE
                x2noticecheck = false
                x2noticecheckactive = false
                x2noticecheck = false
                twoplayercheck = false
                twoplayercheckactive = false
                versionactive = false
                logo = false
                datetime.bottomright = false
                active = true
                pressjumpwords = false
                Section(0).backgroundID = 6
                Routine.run(PigeonRaca1)
            end
        end
        if (Time.month() == 04 and Time.day() == 01) then
            if GameData.____holidayMenuEventExecuted == nil or GameData.____holidayMenuEventExecuted == false and GameData.____holidayMenuEventEnded == false then
                if player.keys.jump == KEYS_PRESSED then
                    GameData.startedmenu = 1
                    Sound.muteMusic(-1)
                    logo = false
                    datetime.bottomright = false
                    active = true
                    pressjumpwords = false
                    aprilfools = true
                    Sound.playSFX("windows_error.ogg")
                    GameData.holidayrun = true
                    if GameData.holidayrun == true then
                        GameData.____holidayMenuEventExecuted = true
                        Routine.run(foolsinapril)
                    end
                end
                if GameData.____holidayMenuEventExecuted == true then
                    --Nothing
                end
            elseif GameData.____holidayMenuEventEnded == true then
                if player.keys.jump == KEYS_PRESSED then
                    
                end
            end
        end
        if GameData.startedmenu == 4 then
            player.keys.jump = true
            player.rawKeys.jump = true
            if player.keys.jump == KEYS_PRESSED then
                Level.load("SMAS - Start.lvlx", nil, nil)
            end
        end
        if SaveData.racaActivated == 1 then
            GameData.startedmenu = 2
        end
    end
end

local function harmNPC(npc,...) -- npc:harm but it returns if it actually did anything
    local oldKilled     = npc:mem(0x122,FIELD_WORD)
    local oldProjectile = npc:mem(0x136,FIELD_BOOL)
    local oldHitCount   = npc:mem(0x148,FIELD_FLOAT)
    local oldImmune     = npc:mem(0x156,FIELD_WORD)
    local oldID         = npc.id
    local oldSpeedX     = npc.speedX
    local oldSpeedY     = npc.speedY

    npc:harm(...)

    return (
           oldKilled     ~= npc:mem(0x122,FIELD_WORD)
        or oldProjectile ~= npc:mem(0x136,FIELD_BOOL)
        or oldHitCount   ~= npc:mem(0x148,FIELD_FLOAT)
        or oldImmune     ~= npc:mem(0x156,FIELD_WORD)
        or oldID         ~= npc.id
        or oldSpeedX     ~= npc.speedX
        or oldSpeedY     ~= npc.speedY
    )
end

function bootmenu.onDraw()
    if bootmenu.active then
        local smaslogo = Graphics.loadImageResolved("smaslogo.png")
        local pressstart = Graphics.loadImageResolved("pressstarttojump.png")
        local bluecurtains = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
        local redcurtains = Graphics.loadImageResolved("theming_smbxcurtainsred.png")
        local orangecurtains = Graphics.loadImageResolved("theming_smbxcurtainsorange.png")
        local smaslogowide = Graphics.loadImageResolved("smaslogo-wide.png")
        local pressstartwide = Graphics.loadImageResolved("pressstarttojump-wide.png")
        
        local stpatricksday = false
        local hitNPCs = Colliders.getColliding{a = cursor.scenepos, b = hitNPCs, btype = Colliders.NPC}
        
        if pfpimage then
            if SaveData.playerPfp == nil then
                sprite.draw{texture = Img.load("pfp/pfp.png"), width = 40, height = 40, x = 10, y = 555, priority = -7}
            elseif SaveData.playerPfp then
                sprite.draw{texture = Img.load("___MainUserDirectory/"..SaveData.playerPfp..""), width = 40, height = 40, x = 10, y = 555, priority = -7}
            elseif unexpected_condition then
                sprite.draw{texture = Img.load("pfp/pfp.png"), width = 40, height = 40, x = 10, y = 555, priority = -7}
            end
        end
        if playernamebyImg then
            if SaveData.playerName == nil then
                textplus.print{x = 60, y = 569, text = "<color rainbow>Player</color>", font = fontthree, priority = -7, xscale = 1, yscale = 1}
            else
                textplus.print{x = 60, y = 569, text = "<color rainbow>"..SaveData.playerName.."</color>", font = fontthree, priority = -7, xscale = 1, yscale = 1}
            end
        end
        if Level.filename() == "intro_8bit.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_theeditedboss.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_S!TS!.lvlx" then
            --No curtains
        end
        if Level.filename() == "intro_SMAS.lvlx" then
            --No curtains
        end
        if Level.filename() == "intro_SMBX1.0.lvlx" then
            Graphics.drawImageWP(redcurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.1.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.2.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.3.lvlx" then
            Graphics.drawImageWP(orangecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX1.3og.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_SMBX2.lvlx" then
            --No curtains
        end
        if Level.filename() == "intro_SMBX2b3.lvlx" then
            Graphics.drawImageWP(orangecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_WSMBA.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_sunsetbeach.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_scrollingheights.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_jakebrito1.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_jakebrito2.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        if Level.filename() == "intro_circuitcity.lvlx" then
            Graphics.drawImageWP(bluecurtains, -1000, 0, -12)
        end
        
        local rngspark = rng.randomInt(1,20)
        local rngsparkmovement = rng.randomInt(1,1.2)
        
        if cursor.left == KEYS_DOWN then
            Effect.spawn(80, cursor.sceneX + rngspark*0.5, cursor.sceneY + rngspark*0.5, player.section, false, true).speedX = rngsparkmovement*0.5
            Effect.spawn(80, cursor.sceneX + rngspark*0.5, cursor.sceneY + rngspark*0.5, player.section, false, true).speedY = rngsparkmovement*0.5
            for _,npc in ipairs(hitNPCs) do
                if npc ~= v and npc.id > 0 then
                    -- Hurt the NPC, and make sure to not give the automatic score
                    local oldScore = NPC.config[npc.id].score
                    NPC.config[npc.id].score = 0
                    NPC.config[npc.id].score = oldScore
                    
                    local hurtNPC = harmNPC(npc,HARM_TYPE_NPC)
                    if hurtNPC then
                        Misc.givePoints(0,{x = npc.x+npc.width*1.5,y = npc.y+npc.height*0.5},true)
                    end
                end
            end
        end
        if cursor.left == KEYS_UP then
            
        end
        if versionactive then
            Graphics.drawBox{x=660, y=5, width=136, height=20, color=Color.black..0.5, priority=-7}
            textplus.print{x=667, y=10, text = versionnumber, priority=-6, color=Color.white, font=fontthree} --Version number of the episode
        end
        if escquit then
            textplus.print{x=10, y=10, text = "Press pause to quit.", priority=-6, color=Color.yellow}
            Graphics.drawBox{x=5, y=5, width=95, height=20, color=Color.red..0.5, priority=-7}
        end
        if pressjumpwords then
            textplus.print{x=210, y=390, text = "Press jump to start", priority=-6, xscale = 2, yscale = 2, color=Color.white, font=menufont}
            --Graphics.drawImageWP(pressstart, 150, 552, -4)
        end
        if website then
            textplus.print{x=30, y=522, text = "github.com/SpencerEverly/smasplusplus", priority=-6, xscale = 2, yscale = 2, color=Color.white, font=menufontwebsite}
        end
        if logo then
            Graphics.drawImageWP(smaslogo, 176, 16, -4)
        end
        if exitscreen then
            Graphics.drawScreen{color = Color.black, priority = 10}
        end
        if not logo then
            --nothing
        end
        if twoplayercheck then
            textplus.print{x=295, y=10, text = "Two player mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont}
        end
        if twoplayercheckactive then
            textplus.print{x=300, y=10, text = "Two player mode is ENABLED", priority=-7, color=Color.lightred, font=statusFont}
        end
        if x2noticecheck then
            textplus.print{x=303, y=20, text = "SMBX 1.3 mode is DISABLED", priority=-7, color=Color.yellow, font=statusFont}
        end
        if x2noticecheckactive then
            textplus.print{x=308, y=20, text = "SMBX 1.3 mode is ENABLED", priority=-7, color=Color.lightred, font=statusFont}
        end
        if charactercheck then
            textplus.print{x=303, y=20, text = "P1's Active Character: ", priority=-7, color=Color.yellow, font=statusFont}
        end
        if not charactercheck then
            --nothing
        end
        if not active then
            textplus.print{x=290, y=500, text = "Game by Spencer Everly, SMBX by redigit, SMBX2 by", priority=-7, color=Color.red}
            textplus.print{x=286, y=497, text = "Game by Spencer Everly, SMBX by redigit, SMBX2 by", priority=-6, color=Color.yellow}
            textplus.print{x=286, y=510, text = "Horikawa Otane, Kevsoft, Rednaxela, Hoeloe, and Enjl", priority=-7, color=Color.red}
            textplus.print{x=282, y=507, text = "Horikawa Otane, Kevsoft, Rednaxela, Hoeloe, and Enjl", priority=-6, color=Color.yellow}
        end
        if active then
            --nothing
        end
        if active3 then
            textplus.print{x=160, y=500, text = "Hold down NOW to instantly skip to the World Map (3 seconds).", priority=0, color=Color.red, font=statusFont}
        end
        if active4 then
            textplus.print{x=150, y=550, text = "Welcome to Totaka's Song. Congrats, you found the easter egg ;)", priority=0, color=Color.yellow, font=statusFont}
        end
        if keyinput1 then
            textplus.print{x=300, y=400, text = "Press the key that will assign the up button.", priority=0, color=Color.lightred, font=statusFont}
        end
        if aprilfools then    
            Graphics.drawImageWP(aprilfoolserror, 0, 0, 0)
        end
        if not aprilfools then
            
        end
        if stpatricksday then
            textplus.print{x=300, y=460, text = "Happy St. Patricks Day!", priority=0, color=Color.green, font=statusFont}
        end
    end
end

function bootmenu.onExit()
    if bootmenu.active then
        Audio.MusicVolume(nil)
        autoscroll.unlockSection(0, 1)
        if SaveData.firstBootCompleted == true then
            GameData.startedmenu = 0
        end
        if SaveData.firstBootCompleted == false then
            GameData.startedmenu = 1
        end
        Defines.cheat_donthurtme = false
        Defines.cheat_shadowmario = false
        autoscroll.scrollLeft(5000)
    end
end

--The rest of the code will disable cheats to avoid breaking the main menu. They aren't categorized, but you can see a list here https://docs.codehaus.moe/#/features/cheats

Cheats.enabled = false



littleDialogue.registerAnswer("MainMenu",{text = "Start Game",chosenFunction = function() Routine.run(BootSMASPlusPlusPreExecute) end})
littleDialogue.registerAnswer("MainMenu",{text = "Load Game Help",chosenFunction = function() Routine.run(BootGameHelpPreExecute) end})
littleDialogue.registerAnswer("MainMenu",{text = "Minigames",chosenFunction = function() Routine.run(battleModeDialogue) end})
if SMBX_VERSION == VER_SEE_MOD then
    littleDialogue.registerAnswer("MainMenu",{text = "Online Multiplayer",chosenFunction = function() Routine.run(BootOnlinePreExecute) end})
end
littleDialogue.registerAnswer("MainMenu",{text = "Main Menu Themes",chosenFunction = function() Routine.run(themeMenu1) end})
littleDialogue.registerAnswer("MainMenu",{text = "Settings/Options",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("MainMenu",{text = "Exit Main Menu",chosenFunction = function() Routine.run(ExitDialogue) end})
littleDialogue.registerAnswer("MainMenu",{text = "Exit Game",chosenFunction = function() Routine.run(ExitGame1) end})


littleDialogue.registerAnswer("BattleSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})
littleDialogue.registerAnswer("BattleSelect",{text = "Classic Battle Mode (2P)",chosenFunction = function() Routine.run(BattleModeDisEnable1) end})
littleDialogue.registerAnswer("BattleSelect",{text = "Rush Mode (1P)",chosenFunction = function() Routine.run(RushModeMenu1) end})


littleDialogue.registerAnswer("Options",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})
littleDialogue.registerAnswer("Options",{text = "Change Character",chosenFunction = function() Routine.run(ChangeChar1) end})
littleDialogue.registerAnswer("Options",{text = "2 Player Mode",chosenFunction = function() Routine.run(TwoPlayerDisEnable1) end})
littleDialogue.registerAnswer("Options",{text = "SMBX 1.3 Mode",chosenFunction = function() Routine.run(X2DisableCheck1) end})
littleDialogue.registerAnswer("Options",{text = "Input Configuration",chosenFunction = function() Routine.run(InputConfig1) end})
littleDialogue.registerAnswer("Options",{text = "Change Player Name",chosenFunction = function() Routine.run(ChangeName1) end})
littleDialogue.registerAnswer("Options",{text = "Change Profile Picture",chosenFunction = function() Routine.run(ChangePFP1) end})
littleDialogue.registerAnswer("Options",{text = "Change Clock Theme",chosenFunction = function() Routine.run(ClockSelect1) end})
littleDialogue.registerAnswer("Options",{text = "Change Resolution",chosenFunction = function() Routine.run(ResolutionSelect1) end})
littleDialogue.registerAnswer("Options",{text = "Toggle Letterbox Scaling",chosenFunction = function() Routine.run(ResolutionChangeScale3) end})
littleDialogue.registerAnswer("Options",{text = "Toggle Resolution Border",chosenFunction = function() Routine.run(ResolutionChangeBorder2) end})
littleDialogue.registerAnswer("Options",{text = "Framerate Toggling",chosenFunction = function() Routine.run(FramerateToggle1) end})
littleDialogue.registerAnswer("Options",{text = "Save Options",chosenFunction = function() Routine.run(SaveOptions1) end})
littleDialogue.registerAnswer("Options",{text = "Credits",chosenFunction = function() Routine.run(credits1) end})



littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Super Mario All-Stars++",chosenFunction = function() Routine.run(theme1) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Where SMB Attacks",chosenFunction = function() Routine.run(theme6) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.0.0",chosenFunction = function() Routine.run(theme2) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.1.0",chosenFunction = function() Routine.run(theme3) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.2.2",chosenFunction = function() Routine.run(theme4) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3.0",chosenFunction = function() Routine.run(theme9) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX 1.3.0.1",chosenFunction = function() Routine.run(theme5) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 3",chosenFunction = function() Routine.run(theme10) end})
littleDialogue.registerAnswer("IntroTheme",{text = "SMBX2 Beta 4",chosenFunction = function() Routine.run(theme7) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Edited Boss (Eighth Edition)",chosenFunction = function() Routine.run(theme8) end})
littleDialogue.registerAnswer("IntroTheme",{text = "8-Bit (By TepigFan101)",chosenFunction = function() Routine.run(theme11) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Spencer! The Show! REBOOT",chosenFunction = function() Routine.run(theme12) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Sunset Beach (By IkOshi1)",chosenFunction = function() Routine.run(theme13) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Scrolling Heights",chosenFunction = function() Routine.run(theme14) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Firey Castle (By Jake Brito)",chosenFunction = function() Routine.run(theme15) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Mario Forever (Classic)",chosenFunction = function() Routine.run(theme16) end})
littleDialogue.registerAnswer("IntroTheme",{text = "The Watery Airship (By Jake Brito)",chosenFunction = function() Routine.run(theme17) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Circuit Central (By RvBNut91)",chosenFunction = function() Routine.run(theme18) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Metroid Prime 2 (By SilverDeoxys)",chosenFunction = function() Routine.run(theme19) end})
littleDialogue.registerAnswer("IntroTheme",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("BattleLevelSelect",{text = "Exit Battle Mode",chosenFunction = function() Routine.run(ExitClassicBattle) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Random Level",chosenFunction = function() Routine.run(BattleRandomLevelSelect) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Battle Zone (SMBX 1.3)",chosenFunction = function() Routine.run(Battle1) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Battleshrooms (SMBX 1.3)",chosenFunction = function() Routine.run(Battle2) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Classic Castle Battle (SMBX 1.3)",chosenFunction = function() Routine.run(Battle3) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Dry Dry Desert (SMBX 1.3)",chosenFunction = function() Routine.run(Battle4) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Hyrule Temple (SMBX 1.3)",chosenFunction = function() Routine.run(Battle5) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Invasion Battlehammer (SMBX 1.3)",chosenFunction = function() Routine.run(Battle6) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Lakitu Mechazone (SMBX 1.3)",chosenFunction = function() Routine.run(Battle7) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Lethal Lava Level (SMBX 1.3)",chosenFunction = function() Routine.run(Battle8) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Retroville Underground (SMBX 1.3.0.1)",chosenFunction = function() Routine.run(Battle9) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Slippy Slap Snowland (SMBX 1.3)",chosenFunction = function() Routine.run(Battle10) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Woody Warzone (SMBX 1.3)",chosenFunction = function() Routine.run(Battle11) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Sky High Into the Skies",chosenFunction = function() Routine.run(Battle12) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "New Super Mario Bros. DS, Level 1 (By hrthrdh)",chosenFunction = function() Routine.run(Battle13) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "New Super Mario Bros. DS, Level 2 (By hrthrdh)",chosenFunction = function() Routine.run(Battle14) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "New Super Mario Bros. DS, Level 3 (By hrthrdh)",chosenFunction = function() Routine.run(Battle15) end})
littleDialogue.registerAnswer("BattleLevelSelect",{text = "Exit Battle Mode",chosenFunction = function() Routine.run(ExitClassicBattle) end})



littleDialogue.registerAnswer("ClockSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Default (Normal)",chosenFunction = function() SaveData.clockTheme = "normal" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Vintage",chosenFunction = function() SaveData.clockTheme = "vintage" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Homedics SS-4000",chosenFunction = function() SaveData.clockTheme = "homedics" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "R.O.B. Clock",chosenFunction = function() SaveData.clockTheme = "rob" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Modern",chosenFunction = function() SaveData.clockTheme = "modern" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Windows 98",chosenFunction = function() SaveData.clockTheme = "windows98" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Windows XP",chosenFunction = function() SaveData.clockTheme = "windowsxp" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Windows 7",chosenFunction = function() SaveData.clockTheme = "windows7" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Windows 10",chosenFunction = function() SaveData.clockTheme = "windows10" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Windows 11",chosenFunction = function() SaveData.clockTheme = "windows11" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Mac OS X",chosenFunction = function() SaveData.clockTheme = "macosx" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Ubuntu",chosenFunction = function() SaveData.clockTheme = "ubuntu" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Disable Clock",chosenFunction = function() SaveData.clockTheme = "disabled" Routine.run(ClockChange1) end})
littleDialogue.registerAnswer("ClockSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("ResolutionSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Fullscreen (Default)",chosenFunction = function() SaveData.resolution = "fullscreen" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Widescreen (Most Screens)",chosenFunction = function() SaveData.resolution = "widescreen" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Ultrawide (Movie Resolution)",chosenFunction = function() SaveData.resolution = "ultrawide" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "NES, SNES, Genesis",chosenFunction = function() SaveData.resolution = "nes" Routine.run(ResolutionChange1) end})
--littleDialogue.registerAnswer("ResolutionSelect",{text = "Gameboy, Gameboy Color",chosenFunction = function() SaveData.resolution = "gameboy" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Gameboy Advance",chosenFunction = function() SaveData.resolution = "gba" Routine.run(ResolutionChange1) end})
--littleDialogue.registerAnswer("ResolutionSelect",{text = "iPhone (1st Generation)",chosenFunction = function() SaveData.resolution = "iphone1st" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Nintendo 3DS (Top Screen)",chosenFunction = function() SaveData.resolution = "3ds" Routine.run(ResolutionChange1) end})
littleDialogue.registerAnswer("ResolutionSelect",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("SavingMenuOne",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Move Save to a Different Slot",chosenFunction = function() Routine.run(SaveSlot1) end})
littleDialogue.registerAnswer("SavingMenuOne",{text = "Erase Save Data",chosenFunction = function() Routine.run(EraseSave1) end})




littleDialogue.registerAnswer("SaveEraseChoice",{text = "Do not Erase",chosenFunction = function() Routine.run(BootDialogueMusicReset) end})
littleDialogue.registerAnswer("SaveEraseChoice",{text = "ERASE",chosenFunction = function() Routine.run(SaveEraseStart) end})




littleDialogue.registerAnswer("SaveErasePreChoice",{text = "I understand",chosenFunction = function() Routine.run(EraseSave2) end})
littleDialogue.registerAnswer("SaveErasePreChoice",{text = "Nevermind",chosenFunction = function() Routine.run(BootDialogueMusicReset) end})



littleDialogue.registerAnswer("StartNameChange",{text = "Begin",chosenFunction = function() Routine.run(startKeyboard) end})
littleDialogue.registerAnswer("StartNameChange",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartPFPChange",{text = "Begin",chosenFunction = function() Routine.run(startKeyboardPFP) end})
littleDialogue.registerAnswer("StartPFPChange",{text = "How do I use this?",chosenFunction = function() Routine.run(PFPinfo1) end})
littleDialogue.registerAnswer("StartPFPChange",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartInputs",{text = "Keyboard",chosenFunction = function() Routine.run(startPreConfiguratorKeyboard) end})
littleDialogue.registerAnswer("StartInputs",{text = "Controller",chosenFunction = function() Routine.run(startConfigurator) end})
littleDialogue.registerAnswer("StartInputs",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartInputPlayers",{text = "Player 1",chosenFunction = function() Routine.run(startConfiguratorKeyboard) end})
littleDialogue.registerAnswer("StartInputPlayers",{text = "Player 2",chosenFunction = function() Routine.run(startConfiguratorKeyboardP2) end})
littleDialogue.registerAnswer("StartInputPlayers",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("StartSaveSwitcher",{text = "Begin",chosenFunction = function() Routine.run(startSaveSwitcher1) end})
littleDialogue.registerAnswer("StartSaveSwitcher",{text = "Exit",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("ReturnMenu",{text = "Exit",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("RestartOption",{text = "Restart",chosenFunction = function() Routine.run(RestartSMASPlusPlusResetSave) end})



littleDialogue.registerAnswer("RestartOptionNoSaveErase",{text = "Restart",chosenFunction = function() Routine.run(RestartSMASPlusPlus) end})



littleDialogue.registerAnswer("FirstBootMenuOne",{text = "Begin",chosenFunction = function() Routine.run(FirstBoot3) end})



littleDialogue.registerAnswer("MigrateSaveMenuOne",{text = "Upgrade now",chosenFunction = function() Routine.run(MigrateOldSave2) end})
littleDialogue.registerAnswer("MigrateSaveMenuOne",{text = "No thanks",chosenFunction = function() Routine.run(MigrateOldSaveCancelled) end})


littleDialogue.registerAnswer("MigrateSaveMenuCancel",{text = "Quit Game",chosenFunction = function() Routine.run(ExitGameNoSave) end})



littleDialogue.registerAnswer("MigrateSaveMenuTwo",{text = "Start the upgrade now",chosenFunction = function() Routine.run(MigrateOldSave3) end})
littleDialogue.registerAnswer("MigrateSaveMenuTwo",{text = "No thanks",chosenFunction = function() Routine.run(MigrateOldSaveCancelled) end})


littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "Yes",chosenFunction = function() Routine.run(FirstBoot4) end})
littleDialogue.registerAnswer("FirstBootMenuTwo",{text = "No",chosenFunction = function() Routine.run(TimeFixInfo1) end})




littleDialogue.registerAnswer("FirstBootMenuThree",{text = "Begin",chosenFunction = function() Routine.run(startKeyboardFirstBoot) end})




littleDialogue.registerAnswer("FirstBootMenuKeyboard",{text = "Start",chosenFunction = function() Routine.run(startConfiguratorKeyboard) end})



littleDialogue.registerAnswer("OnePlayerChoosing",{text = "Yes",chosenFunction = function() Routine.run(OnePlayerCheck) end})
littleDialogue.registerAnswer("OnePlayerChoosing",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})


littleDialogue.registerAnswer("FirstBootMenuFour",{text = "How do I play?",chosenFunction = function() Routine.run(FirstBootGameHelp) end})
littleDialogue.registerAnswer("FirstBootMenuFour",{text = "Skip",chosenFunction = function() Routine.run(FirstBoot6) end})




littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Start Game Help",chosenFunction = function() Routine.run(BootGameHelpPreExecute) end})
littleDialogue.registerAnswer("FirstBootMenuGameHelp",{text = "Skip",chosenFunction = function() Routine.run(FirstBoot6) end})




littleDialogue.registerAnswer("FirstBootMenuFive",{text = "Let's get started!",chosenFunction = function() Routine.run(ExitDialogueFirstBoot) end})



littleDialogue.registerAnswer("FirstBootMenuTimeFix",{text = "Recheck",chosenFunction = function() Routine.run(FirstBoot3) end})



littleDialogue.registerAnswer("SaveSlotMove1",{text = "WIP",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("InputConfigStart",{text = "Begin",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("X2CharacterDisableOne",{text = "Yes", chosenFunction = function() Routine.run(X2Char) end})




littleDialogue.registerAnswer("BattleTwoPlayerCheckOne",{text = "Yes",chosenFunction = function() Routine.run(TwoPlayerCheckBattle) end})
littleDialogue.registerAnswer("BattleTwoPlayerCheckOne",{text = "No",chosenFunction = function() Routine.run(ExitClassicBattle) end})




littleDialogue.registerAnswer("BattleTwoPlayerCheckTwo",{text = "Yes",chosenFunction = function() Routine.run(classicBattleSelect) end})
littleDialogue.registerAnswer("BattleTwoPlayerCheckTwo",{text = "No",chosenFunction = function() Routine.run(ExitClassicBattle) end})



littleDialogue.registerAnswer("RushModeSelectionOne",{text = "Yes",chosenFunction = function() Routine.run(startRushMode) end})
littleDialogue.registerAnswer("RushModeSelectionOne",{text = "No",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "Yes (2 Player Mode)",chosenFunction = function() Routine.run(TwoPlayerCheck) end})
littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "Yes (1 Player Mode)",chosenFunction = function() Routine.run(OnePlayerCheck) end})
littleDialogue.registerAnswer("TwoPlayerDisableOne",{text = "No",chosenFunction = function() Routine.run(optionsMenu1) end})


littleDialogue.registerAnswer("ToBeAddedSoon",{text = "WIP",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuTwo",{text = "Alright.",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuTwoOptions",{text = "Alright.",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("OkayToBattle",{text = "Alrighty!",chosenFunction = function() Routine.run(classicBattleSelect) end})



littleDialogue.registerAnswer("OkayToMenu",{text = "Okay!",chosenFunction = function() Routine.run(bootDialogue) end})



littleDialogue.registerAnswer("OkayToMenuOptions",{text = "Okay!",chosenFunction = function() Routine.run(optionsMenu1) end})



littleDialogue.registerAnswer("OkayToMenuTheme",{text = "Oh yeah, right.",chosenFunction = function() Routine.run(themeMenu1) end})



littleDialogue.registerAnswer("ToMenuResetTwo",{text = "Gotcha.",chosenFunction = function() Routine.run(ExitDialogueMusicReset) end})





littleDialogue.registerAnswer("PlayerChoosingOne",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})
littleDialogue.registerAnswer("PlayerChoosingOne",{text = "Player 1",chosenFunction = function() Routine.run(ChangeChar1P) end})
littleDialogue.registerAnswer("PlayerChoosingOne",{text = "Player 2",chosenFunction = function() Routine.run(ChangeChar2P) end})



littleDialogue.registerAnswer("CharacterList1",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Mario (Slot 1)",chosenFunction = function() player:transform(1, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Luigi (Slot 2)",chosenFunction = function() player:transform(2, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Peach (Slot 3)",chosenFunction = function() player:transform(3, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Toad (Slot 4)",chosenFunction = function() player:transform(4, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList1",{text = "Link (Slot 5)",chosenFunction = function() player:transform(5, true) Routine.run(ChangedCharacter) end})


littleDialogue.registerAnswer("CharacterList2",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Mario (Slot 1)",chosenFunction = function() player2:transform(1, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Luigi (Slot 2)",chosenFunction = function() player2:transform(2, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Peach (Slot 3)",chosenFunction = function() player2:transform(3, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Toad (Slot 4)",chosenFunction = function() player2:transform(4, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterList2",{text = "Link (Slot 5)",chosenFunction = function() player2:transform(5, true) Routine.run(ChangedCharacter) end})


littleDialogue.registerAnswer("CharacterListX2",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(optionsMenu1) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Mario (Slot 1)",chosenFunction = function() player:transform(1, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Luigi (Slot 2)",chosenFunction = function() player:transform(2, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Peach (Slot 3)",chosenFunction = function() player:transform(3, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Toad (Slot 4)",chosenFunction = function() player:transform(4, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Link (Slot 5)",chosenFunction = function() player:transform(5, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Mega Man (Slot 6)",chosenFunction = function() player:transform(6, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Wario (Slot 7)",chosenFunction = function() player:transform(7, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Bowser (Slot 8)",chosenFunction = function() player:transform(8, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Klonoa (Slot 9)",chosenFunction = function() player:transform(9, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Yoshi (Slot 10)",chosenFunction = function() player:transform(10, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Rosalina (Slot 11)",chosenFunction = function() player:transform(11, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Snake (Slot 12)",chosenFunction = function() player:transform(12, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Zelda (Slot 13)",chosenFunction = function() player:transform(13, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Minecraft Steve (Slot 14)",chosenFunction = function() player:transform(14, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Uncle Broadsword (Slot 15)",chosenFunction = function() player:transform(15, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Samus (Slot 16)",chosenFunction = function() player:transform(16, true) Routine.run(ChangedCharacter) end})
littleDialogue.registerAnswer("CharacterListX2",{text = "Return to Previous Menu",chosenFunction = function() Routine.run(bootDialogue) end})

return bootmenu