local bigSwitch = {}

local npcManager = require("npcManager")
local particles = require("particles")
local switchcolors = require("switchcolors")
local smasExtraSounds = require("smasExtraSounds")

local pSwitched = false

SaveData._basegame = SaveData._basegame or {}
SaveData._basegame.bigSwitch = SaveData._basegame.bigSwitch or {}
local SwitchData = SaveData._basegame.bigSwitch
GameData._basegame = GameData._basegame or {}
GameData._basegame.bigSwitch = {}
local PressData = GameData._basegame.bigSwitch

local UnsaveSwitchData = {};

local p_spade = Misc.resolveFile("particles/p_spade.ini")

bigSwitch.charms = {}

bigSwitch.sharedSettings = {
    gfxwidth = 64,
    gfxheight = 64,
    width = 64,
    height = 64,
    nogravity = false,
    frames = 2,
    framestyle = 0,
    framespeed = 8,
    noblockcollision = false,
    playerblock = true,
    playerblocktop = true,
    npcblock = true,
    npcblocktop = true,
    speed = 0,
    jumphurt = true,
    nohurt = true,
    score = 0,
    noiceball = true,
    nowaterphysics = true,
    foreground = true,
    noyoshi = true,
    notcointransformable = true,

    --lua settings
    pressedheight = 32,
    synchronize = true, --Whether the switches of this type should be synced
    switchon = true, --Whether the switch transforms "off" blocks into "on" blocks.
    switchoff = true, --Whether the switch transforms existing "on" blocks into off blocks.
    blockon = 1, --The ID of the switch's "on" blocks.
    blockoff = 2, --The ID of the switch's "off" blocks.
    exitlevel = true, --Whether or not the switch will work as a level exit.
    save = true, --Whether or not the switch will actually save, or only work for the level. Best changed in conjunction with exitlevel.
    bursts = 11, --number of switch bursts. Works best as 11 with exitlevel, and 1 without.
    burstinterval = 50 --yeah
}

local switchColorFunctions = {}

local switchColorIDs = {}

local function resolveParticleFile(filename)
    filename = "switch/part_"..filename..".png"
    local a = Misc.multiResolveFile(filename, "particles/"..filename, "graphics/particles/"..filename)
    return Graphics.loadImage(a)
end

local function charmBurst(effect, radius, angle, count)
    local v = vector.v2(0,-radius)
    v = v:rotate(-angle*0.5)
    for i=0,count do
        effect:setParam("xOffset",v.x)
        effect:setParam("yOffset",v.y)
        effect:Emit(1)
        v = v:rotate(angle/count)
    end
end

local function isPressed(settings, npc)
    if (not settings.synchronize) and npc then
        return npc.data._basegame.pressed
    end
    return (settings.save and SwitchData[settings.color]) or (not settings.save and UnsaveSwitchData[settings.color])
end

local function doSwitch(settings,undo)
    if settings.color == "pswitch" then
        if not pSwitched then
            Misc.doPSwitchRaw(true)
            triggerEvent "P Switch - Start"
        else
            Misc.doPSwitch(false)
            triggerEvent "P Switch - End"
        end
        return
--[[elseif settings.color == "stopwatch" then
        Defines.levelFreeze = not defines.levelFreeze
        return]]
    end

    if settings.blockon and settings.blockoff then
        switchcolors.switch(settings.blockon, settings.blockoff)
    end
    --[[local blocks_a = Block.get(settings.blockoff)
    local blocks_b = Block.get(settings.blockon)
    local switchon  = settings.switchon
    local switchoff = settings.switchoff
    if undo then
        switchon,switchoff = switchoff,switchon
    end
    if switchon then
        for _,v in ipairs(blocks_a) do
            v.id = settings.blockon
        end
    end
    if switchoff then
        for _,v in ipairs(blocks_b) do
            v.id = settings.blockoff
        end
    end]]
    switchColorFunctions[switchcolors.palaceColors[settings.color]]()
end

function switchcolors.onPalaceSwitch(col)
    local ids = switchColorIDs[col]
    if ids == nil then return end

    local settings
    local hasSwitchedSaved = false
    local hasSwitchedUnsaved = false
    for k,id in ipairs(ids) do
        if hasSwitchedSaved and hasSwitchedUnsaved then return end

        settings = NPC.config[id]
        local undo
        if settings.save and not hasSwitchedSaved then
            if isPressed(settings) then
                SwitchData[settings.color] = false
                undo = true
            else
                SwitchData[settings.color] = true
            end
            hasSwitchedSaved = true
        elseif not (settings.save or hasSwitchedUnsaved) then
            if isPressed(settings) then
                UnsaveSwitchData[settings.color] = false
                undo = true
            else
                UnsaveSwitchData[settings.color] = true
            end
            hasSwitchedUnsaved = true
        end
    end
end

local ids = {}
local idMap = {}

function bigSwitch.registerSwitch(settings)
    local customSettings = table.join(settings,bigSwitch.sharedSettings)
    --if bigSwitch.charms[customSettings.color] ~= nil then --use npc.txt to change settings of existing switches
        --error("Use npc.txt to change settings of existing switches.")
    --end
    npcManager.setNpcSettings(customSettings)
    npcManager.registerEvent(customSettings.id,bigSwitch,"onTickNPC")
    npcManager.registerEvent(customSettings.id,bigSwitch,"onDrawNPC")
    bigSwitch.charms[customSettings.color] = resolveParticleFile(customSettings.color)
    local func, col = switchcolors.registerPalace(customSettings.color)
    switchColorFunctions[col] = func
    if (switchColorIDs[col] == nil) then
        switchColorIDs[col] = {}
    end
    table.insert(ids, customSettings.id)
    idMap[customSettings.id] = true
    table.insert(switchColorIDs[col], customSettings.id)
end

function bigSwitch.onInitAPI()
    for _,v in ipairs{"onStart","onTick","onEvent","onExit"} do
        registerEvent(bigSwitch,v)
    end
end

function bigSwitch.onStart()
    for _,settings in pairs(ids) do
        local v = NPC.config[settings]
        if SwitchData[v.color] then
            doSwitch(v)
            if not v.save then
                UnsaveSwitchData[v.color] = true
            end
            SwitchData[v.color] = true
        end
    end
end

function bigSwitch.onTick()
    local npcs = {}
    for _,p in ipairs(Player.get()) do
        if p:mem(0x176,FIELD_WORD) > 0 then
            table.insert(npcs,p.standingNPC)
        end
    end
    for _,v in ipairs(npcs) do
        if not idMap[v.id] then
            return;
        end
        local npc = v
        npc.data._basegame = npc.data._basegame or {}
        local data = npc.data._basegame
        local settings = NPC.config[npc.id]
        
        local pressed = isPressed(settings, npc)
        
        if not pressed and (--[[settings.id == "stopwatch" or]] not Defines.levelFreeze) then
            data.effect = particles.Emitter(npc.x+npc.width/2,npc.y+npc.height/2,p_spade)
            data.effect.texture = bigSwitch.charms[settings.color]
            data.effect:setParam("width",nil)
            data.effect:setParam("height",nil)
            --I'm not sure I understand how the attachment interacts with the changing NPC height.
            data.effect:Attach(npc,false)
            
            data.pressTimer = -1
            
            if settings.save then
                SwitchData[settings.color] = true
            else
                UnsaveSwitchData[settings.color] = true
            end
            data.pressed = true
            switchColorFunctions[switchcolors.palaceColors[settings.color]]()
            doSwitch(settings)
            
            triggerEvent(tostring(npc:mem(0x30,FIELD_STRING))) --death event
            
            Defines.earthquake = 25
            if settings.exitlevel then
                Level.winState(7)
                Defines.player_walkspeed = 0
                Defines.player_runspeed = 0 --link
                player.speedX = 0
                SFX.play(22)
                SFX.play(60)
                if settings.save then
                    PressData[settings.color] = true
                end
            else
                SFX.play(32)
            end
        end
    end
end

function bigSwitch.onTickNPC(npc)
    local settings = NPC.config[npc.id]
    local data = npc.data._basegame
    
    local pressed = isPressed(settings, npc)
    
    if --[[settings.color == "stopwatch" or]] not Defines.levelFreeze then
        if pressed and npc.height ~= settings.pressedheight then
            local feetPos = npc.y + npc.height
            npc.height = settings.pressedheight
            npc.y = feetPos - npc.height
        end

        npc.speedX = npc.speedX * 0.96 --temporary, how exactly do you do this?
        if math.abs(npc.speedX) < 0.1 then
            npc.speedX = 0
        end
        
        if pressed and data.effect ~= nil then
            local interval = settings.burstinterval
            if data.pressTimer <= (settings.bursts - 1) * interval then
                data.pressTimer = data.pressTimer + 1
                data.effect.enabled = false
                if data.pressTimer%interval == 0 then
                    charmBurst(data.effect, 16, 210, 12)
                    if settings.exitlevel == 0 and data.pressTimer > 0 and not npc.isHidden then
                        smasBooleans.musicMuted = true
                        SFX.play(75)
                    end
                end
            end
        end
    end
end

function bigSwitch.onDrawNPC(npc)
    if not npc.isHidden then
        local data = npc.data._basegame
        local pressed = isPressed(NPC.config[npc.id], npc)
        
        if pressed and data.effect ~= nil then
            data.effect:Draw(-36)
            npc.animationFrame = 1
        elseif pressed then
            npc.animationFrame = 1
        else
            npc.animationFrame = 0
        end
    end
end

function bigSwitch.onEvent(event)
    if event == "P Switch - Start" then
        pSwitched = true
    elseif event == "P Switch - End" then
        pSwitched = false
    end
end

function bigSwitch.onExit()
    smasBooleans.musicMuted = false
end

return bigSwitch