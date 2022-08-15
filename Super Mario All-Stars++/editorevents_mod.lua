local events = {}

local oldevents = require("base/editorevents")

local blockutils = require("blocks/blockutils")

function events.onInitAPI()
    registerEvent(events, "onStart", "onStart", true)
    registerEvent(events, "onCameraDraw")
    registerEvent(events, "onTick")
    registerEvent(events, "onLoadSection")
    
    local oldevents = nil
end

---------------
-- ENUM MAPS --
---------------

local function loadGraphic(obj)
    if type(obj) == "table" then
        return obj.img
    else
        return obj
    end
end

local noise = Graphics.sprites.hardcoded["53-0"]
local perlin = Graphics.sprites.hardcoded["53-1"]

--Effects
local weatherMap = { "p_rain.ini", "p_snow.ini", "p_fog.ini", "p_sandstorm.ini", "p_cinder.ini", "p_wisp.ini" }
local screeneffectmap = { 
                            { {-100, "wave.frag", {time = -0.719, intensity = 1.5}}, {0, "wave.frag", {intensity = 0.8, time = 0.4}} },
                            { {-100, "smoke.frag", {color = Color(0.7, 0.5, 0.4), size = vector.v2(0.5,300)}}, {0, "lava.frag"} },
                            { {-65.0 , "caustics.frag", {mask = true, tex1 = Graphics.sprites.hardcoded["53-2"]}} },
                            { --[[Underwater effect filled later]] },
                            { {-5, "smoke.frag", {color = Color.white, size = vector.v2(1,700)}} },
                            { {0, "../colormatrix.frag", {matrix = vector.mat3(0.39,     0.349,      0.272,       0.769,     0.686,     0.534,         0.189,    0.168,    0.131)}} },
                            { {0, "../colormatrix.frag", {matrix = vector.mat3(0.299,   0.299,   0.299,       0.587,  0.587,  0.587,         0.114,    0.114,    0.114)}} },
                            { {0, "invert.frag"} },
                            { {0, "gameboy.frag"} },
                            { {0, "gameboydither.frag"} }
                        }
            
--Fill underwater effect            
screeneffectmap[4][1] = screeneffectmap[1][1]
screeneffectmap[4][2] = screeneffectmap[1][2]
screeneffectmap[4][3] = screeneffectmap[3][1]


-------------------------
--  GLOBAL CONSTANTS   --
-------------------------

_G["WEATHER_NONE"]        = 0
_G["WEATHER_RAIN"]         = 1
_G["WEATHER_SNOW"]         = 2
_G["WEATHER_FOG"]         = 3
_G["WEATHER_SANDSTORM"] = 4
_G["WEATHER_CINDERS"]     = 5
_G["WEATHER_WISPS"]     = 6


_G["SEFFECT_NONE"]               = 0
_G["SEFFECT_WAVY"]                = 1
_G["SEFFECT_LAVA"]                 = 2
_G["SEFFECT_CAUSTICS"]             = 3
_G["SEFFECT_UNDERWATER"]        = 4
_G["SEFFECT_MIST"]             = 5
_G["SEFFECT_SEPIA"]             = 6
_G["SEFFECT_GRAYSCALE"]        = 7
_G["SEFFECT_INVERTED"]          = 8
_G["SEFFECT_GAMEBOY"]              = 9
_G["SEFFECT_DITHERED_GAMEBOY"] = 10



local screeneffectbuffer

--Values for level-only settings
local shadowmap
local falloffmap

if not isOverworld then
    --Darkness
    shadowmap = { Darkness.shadow.NONE, Darkness.shadow.RAYMARCH, Darkness.shadow.HARD_RAYMARCH }
    falloffmap = { Darkness.falloff.INV_SQR, Darkness.falloff.LINEAR, Darkness.falloff.SIGMOID, Darkness.falloff.HARD, Darkness.falloff.STEP, Darkness.falloff.SQR_STEP }
end


---------------
--  EVENTS   --
---------------

local sectionData = {}

local function compileScreenEffect(shd)    
    if not shd.compiled then
        for l,v in ipairs(shd) do
            if type(v[2]) == "string" then
                local sh = Shader()
                sh:compileFromFile(Misc.resolveFile("scripts/shaders/effects/screeneffect.vert"), Misc.resolveFile("scripts/shaders/effects/"..v[2]))
                v[2] = sh
            end
        end
        shd.compiled = true
    end
                    
    if screeneffectbuffer == nil then
        screeneffectbuffer = Graphics.CaptureBuffer(800,600)
    end
    
    return shd
end

local function getWeatherEffect(value)
    local s = weatherMap[value]
    if s == nil then
        return nil
    else
        return Particles.Emitter(0,0,Misc.resolveFile("particles/"..s), 5)
    end
end

local function setWeather(i, value)
    sectionData[i] = sectionData[i] or {}
    if value == sectionData[i].weather then
        return
    end
    if value and value > 0 then
                
        sectionData[i].weatherData = { getWeatherEffect(value) }
        sectionData[i].weatherData[1]:attachToCamera(camera, true)
                    
        if camera2.isValid then
            sectionData[i].weatherData[2] = getWeatherEffect(value)
            sectionData[i].weatherData[2]:attachToCamera(camera2, true)
        end
                
        sectionData[i].weather = value
    else
        sectionData[i].weather = 0
        sectionData[i].weatherData = nil
    end
end

local function getWeather(i)    
    if sectionData[i] then
        return sectionData[i].weather or 0
    else
        return 0
    end
end


local function setScreenEffect(i, value)
    sectionData[i] = sectionData[i] or {}
    if value == sectionData[i].screenEffect then
        return
    end
    if value and value > 0 then
        compileScreenEffect(screeneffectmap[value])
        sectionData[i].screenEffect = value
    else
        sectionData[i].screenEffect = 0
    end
end

local function getScreenEffect(i, value)
        return sectionData[i].screenEffect or 0
end




local function setPlayerLight(i, value)    
    sectionData[i] = sectionData[i] or {}    
    if sectionData[i].darknessplayerlight == value then
        return
    end
    local s = Section(i)
    local settings = s.settings.darkness or {}    
    local l = settings.playerlight or {}
    
    if value and s.darkness.effect then
        rawset(s.darkness, "playerLightEffects", {})
        for k,v in ipairs(Player.get()) do
            s.darkness.playerLightEffects[k] = Darkness.light(0,0, l.radius or 64, l.brightness, l.color, l.flicker)
            s.darkness.playerLightEffects[k]:attach(v, true)
            s.darkness.effect:addLight(s.darkness.playerLightEffects[k])
        end
    elseif not value then
        if s.darkness.playerLightEffects then
            for _,v in ipairs(s.darkness.playerLightEffects) do
                v:destroy()
            end
        end
        rawset(s.darkness, "playerLightEffects", nil)
    end
    sectionData[i].darknessplayerlight = value or false
end

local function getPlayerLight(i, value)
    return sectionData[i].darknessplayerlight or false
end




local function setDarkness(i, value)
    sectionData[i] = sectionData[i] or {}
    if sectionData[i].darknessEnabled == value then
        return
    end
    local s = Section(i)
    local settings = s.settings.darkness or {}
    
    if value then
        rawset(s.darkness, "effect", Darkness.create{
                                                        ambient = settings.ambient,
                                                        shadows = shadowmap[(settings.shadows or 0) + 1],
                                                        falloff = falloffmap[(settings.falloff or 0) + 1],
                                                        maxLights = settings.maxlights,
                                                        additiveBrightness = settings.addbright,
                                                        section = i
                                                    })
        if sectionData[i].darknessplayerlight then
            sectionData[i].darknessplayerlight = false
            setPlayerLight(i, true)
        end
    elseif s.darkness.effect then
        s.darkness.effect:destroy()
        rawset(s.darkness, "effect", nil)
    end
    sectionData[i].darknessEnabled = value or false
end

local function getDarkness(i)
    return sectionData[i].darknessEnabled or false
end




local effects_mt = {}
effects_mt.__index = function(tbl,k)
    if k == "weather" then
        return getWeather(tbl.__idx)
    elseif k == "screenEffect" then
        return getScreenEffect(tbl.__idx)
    end
end
effects_mt.__newindex = function(tbl,k,v)
    if k == "weather" then
        setWeather(tbl.__idx, v)
    elseif k == "screenEffect" then
        setScreenEffect(tbl.__idx, v)
    end
end


local darkness_mt = {}
darkness_mt.__index = function(tbl,k)
    if k == "enabled" then
        return getDarkness(tbl.__idx)
    elseif k == "playerLightEnabled" then
        return getPlayerLight(tbl.__idx)
    end
end
darkness_mt.__newindex = function(tbl,k,v)
    if k == "enabled" then
        setDarkness(tbl.__idx, v)
    elseif k == "playerLightEnabled" then
        setPlayerLight(tbl.__idx, v)
    end
end



local screenEffectUniforms = {  }

local function drawScreenEffect(section, index, c)            
    local e = compileScreenEffect(screeneffectmap[index])
    if e == nil then 
        return 
    end
    local u = screenEffectUniforms
    c = c or camera
    
    local b = section.boundary
    u.sectionBounds = { b.left, b.top, b.right, b.bottom }
    u.cameraBounds = { c.x, c.y, c.x + c.width, c.y + c.height }
        
    u.noise = noise.img
    u.perlin = perlin.img
    
    for _,w in ipairs(e) do
                
        u.time = lunatime.tick()
        u.intensity = 1
        u.size = nil
        u.color = nil
        u.matrix = nil
        
        u.mask = nil
        u.tex1 = nil
        
        if w[3] then
            u.time = u.time * (w[3].time or 1)
            u.intensity = w[3].intensity or 1
            if w[3].mask then
                u.mask = blockutils.getMask(c, false)
            else
                u.mask = nil
            end
            
            u.size = w[3].size
            u.color = w[3].color
            u.matrix = w[3].matrix
            u.tex1 = loadGraphic(w[3].tex1)
        end
    
        screeneffectbuffer:captureAt(-5)
        Graphics.drawScreen{texture=screeneffectbuffer, shader = w[2], priority = -5, uniforms = u, camera = c}
        
    end
end

if not isOverworld then
    Section.drawScreenEffect = drawScreenEffect
    Section.getWeatherEffect = getWeatherEffect
end

function events.onStart()
    if not isOverworld then
        --Load LVLX data for LVLX features
        local levelData = FileFormats.getLevelData()
        
        --Section settings
        for k,s in ipairs(Section.get()) do
        
            rawset(s, "effects", s.effects or setmetatable({__idx = k-1}, effects_mt))
            rawset(s, "darkness", s.darkness or setmetatable({__idx = k-1}, darkness_mt))
            rawset(s, "beatTimer", s.beatTimer or { enabled = false, bpm = 40, useMusicClock = false, timeSignature = 4 })
            
            --LVLX data
            local data = levelData.sections[k]
            
            --Vertical wrap
            s.wrapV = data.wrapV or false
            
            --Effects
            if s.settings.effects then
                
                --Weather
                setWeather(k-1, s.settings.effects.weather)
                
                setScreenEffect(k-1, s.settings.effects.screenEffects)
                
            end
            
            --Darkness
            if s.settings.darkness then
                setDarkness(k-1, s.settings.darkness.enableDarkness)
            
                if s.settings.darkness.playerlight then
                    setPlayerLight(k-1, s.settings.darkness.playerlight.enabled)
                end
            end
            
            --Beat Blocks
            if s.settings.beat then
                s.beatTimer.enabled = s.settings.beat.enabled or s.beatTimer.enabled
                s.beatTimer.bpm = s.settings.beat.bpm or s.beatTimer.bpm
                s.beatTimer.useMusicClock = s.settings.beat.useMusicClock or s.beatTimer.useMusicClock
                s.beatTimer.timeSignature = s.settings.beat.timeSignature or s.beatTimer.timeSignature
            end
        end
    end
end

function events.onCameraDraw(camidx)
    if not isOverworld then
        --Section draw events
        local sidx = Player(camidx).section
        local v = Section(sidx)
        
        local c = Camera(camidx)
        
        --Effects
        if sectionData[sidx] then
            
            --Weather
            if sectionData[sidx].weatherData then
                sectionData[sidx].weatherData[camidx]:draw(-5)
            end
            
            --Full Screen Effects
            if sectionData[sidx].screenEffect and sectionData[sidx].screenEffect > 0 then
                drawScreenEffect(v, sectionData[sidx].screenEffect, c)
            end
            
        end
    end
end

function events.onTick()
    if not isOverworld then
    
        --Vertical Wrap
        local slist = {}
        local secs = {}
        for _,v in ipairs(Player.get()) do
            local s = Section(v.section)
            local b = s.boundary
            if s.wrapV then
                table.insert(slist, v.section)
                secs[v.section] = b
                if v.y > b.bottom then
                    v.y = b.top - v.height
                elseif v.y + v.height < b.top then
                    v.y = b.bottom
                end
            end
        end
        
        if #slist > 0 then
            for _,v in ipairs(NPC.get(-1, slist)) do
                local b = secs[v:mem(0x146,FIELD_WORD)]
                if v.y > b.bottom then
                    v.y = v.y - (b.bottom-b.top) - v.height
                elseif v.y + v.height < b.top then
                    v.y = v.y + (b.bottom-b.top) + v.height
                end
            end
        end
        
        
        --Portal warps
        for _,w in ipairs(Player.get()) do
            for _,v in ipairs(Warp.getIntersectingEntrance(w.x, w.y, w.x+w.width, w.y+w.height)) do
                if v.warpType == 3 and not v.isHidden then
                    if w:mem(0x15C, FIELD_WORD) == 0 then
                        if v.locked and w.holdingNPC and w.holdingNPC.id == 31 then
                            w.holdingNPC:kill()
                            v.locked = false
                        end
                        
                        if not v.locked and mem(0x00B251E0, FIELD_WORD) >= v.starsRequired then
                            if v.levelFilename and v.levelFilename ~= "" and not v.isLevelEntrance then
                                Level.load(v.levelFilename, nil, v.warpNumber)
                            elseif v.isLevelExit then
                                local overworldDataPtr = mem(0xB2C5C8, FIELD_DWORD)
                                mem(overworldDataPtr + 0x40, FIELD_DFLOAT, v.worldMapX)
                                mem(overworldDataPtr + 0x48, FIELD_DFLOAT, v.worldMapY)
                                Level.exit()
                            else
                                w.x = v.exitX+(v.exitWidth-w.width)*0.5
                                w.y = v.exitY+(v.exitHeight-w.height)
                                
                                local s = w.section
                                w.section = v.exitSection
                                
                                if w.section ~= s then
                                    playMusic(w.section)
                                end
                                
                                if not v.allowCarriedNPCs and w.holdingNPC then
                                    w.holdingNPC:mem(0x12C,FIELD_WORD,0)    
                                    --w.holdingNPC:mem(0x124, FIELD_WORD, 0)
                                    --w.holdingNPC:mem(0x128, FIELD_WORD, -1)
                                    --w.holdingNPC:mem(0x12A, FIELD_WORD, -1)
                                    w:mem(0x154,FIELD_WORD,0)
                                end
                                if v.noYoshi and w.mount > 0 then
                                    w.mount = 0
                                    w.mountColor = 0
                                end
                            end
                        end
                    end
                    w:mem(0x15C, FIELD_WORD, 2)
                end
            end
        end
        
    end
end

function events.onLoadSection(playerindex)
    local s = Section(Player(playerindex).section)
    if s.beatTimer.enabled then
        Misc.setBPM(s.beatTimer.bpm)
        Misc.setBeatSignature(s.beatTimer.timeSignature)
        Misc.beatUsesMusicClock = s.beatTimer.useMusicClock
    end
end
    
return events