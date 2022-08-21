local darkness = {}

local readmem = readmem
local tableremove = table.remove
local tableinsert = table.insert
local tablesort = table.sort
local max = math.max
local min = math.min
local cos = math.cos
local floor = math.floor
local pi = math.pi
local stringsub = string.sub
local readmem = readmem
local glDraw = Graphics.glDraw
local BlockIterateByFilterMap = Block.iterateByFilterMap
local NPCIterateByFilterMap = NPC.iterateByFilterMap
local BGOIterateByFilterMap = BGO.iterateByFilterMap
local rand = RNG.random

if isOverworld then
    return {}
end

local blockutils = require("blocks/blockutils")
local olddarkness = require("base/darkness")

local colorparse = Color.parse
    
local function isNotBlack(s)
    local n = tonumber(s)
    if n then
        return n > 0
    elseif s ~= "alphablack" and s ~= "black" and s ~= "transparent" and Color[s] then
        return true
    elseif type(s) == "Color" then
        return s[1] ~= 0 or s[2] ~= 0 or s[3] ~= 0
    else
        n = tonumber(stringsub(s, 2))
        if n then
            return n > 0
        else
            return false
        end
    end
end

darkness.falloff = {}
darkness.falloff.INV_SQR = Misc.resolveFile("shaders/darkness/falloff_sqr.glsl")
darkness.falloff.LINEAR = Misc.resolveFile("shaders/darkness/falloff_lin.glsl")
darkness.falloff.HARD = Misc.resolveFile("shaders/darkness/falloff_hard.glsl")
darkness.falloff.SIGMOID = Misc.resolveFile("shaders/darkness/falloff_sig.glsl")
darkness.falloff.STEP = Misc.resolveFile("shaders/darkness/falloff_step.glsl")
darkness.falloff.SQR_STEP = Misc.resolveFile("shaders/darkness/falloff_sqrstep.glsl")

darkness.falloff.DEFAULT = darkness.falloff.INV_SQR

darkness.shadow = {}
darkness.shadow.NONE = Misc.resolveFile("shaders/darkness/shadow_none.glsl")
darkness.shadow.RAYMARCH = Misc.resolveFile("shaders/darkness/shadow_raymarch.glsl")
darkness.shadow.HARD_RAYMARCH = Misc.resolveFile("shaders/darkness/shadow_raymarch_hard.glsl")
darkness.shadow.DEFAULT = darkness.shadow.NONE


darkness.lighttype = {}
darkness.lighttype.POINT = 0
darkness.lighttype.SPOT = 1

darkness.priority = {}
darkness.priority.DISTANCE = 0
darkness.priority.SIZE = 1
darkness.priority.BRIGHTNESS = 2

darkness.priorityType = darkness.priority.DISTANCE

darkness.shadowMaps = {}

local fragShader = Misc.resolveFile("shaders/darkness/darkness.frag")

local globalLights = {}
local fields = {}

local NullMT = {}
function NullMT.__index(tbl,key)
    if key == "isValid" then
        return false
    else
        error("Attempted to access a destroyed object.", 2)
    end
end

function NullMT.__newindex(tbl,key,val)
    error("Attempted to access a destroyed object.", 2)
end


local Light = {};
Light.__index = function(tbl, key)
    if     key == "color" then
        return tbl.colour
    elseif key == "intensity" then
        return tbl.brightness
    elseif key == "direction" then
        return tbl.dir
    elseif key == "attach" or key == "Attach" then
        return Light.Attach
    elseif key == "detach" or key == "Detach" then
        return Light.Detach
    elseif key == "destroy" or key == "Destroy" then
        return Light.Destroy
    elseif key == "isValid" then
        return true
    end
end
Light.__newindex = function(tbl, key, val)
    if     key == "color" then
        tbl.colour = val
    elseif key == "intensity" then
        tbl.brightness = val
    elseif key == "direction" then
        tbl.dir = val
    elseif key == "attach" or key == "Attach" or key == "detach" or key == "Detach" or key == "destroy" or key == "Destroy" or key == "isValid" then
        error("Cannot write to read-only field "..key, 2)
    else
        rawset(tbl,key,val)
    end
end

--Attach a light to an object. Objects must contain at least x and y components.
function Light:Attach(obj, snap)
    
    self.parent = obj
    
    if snap == false then
    
        self.parentoffset = vector.v2(self.x-obj.x, self.y-obj.y)
        
        if obj.width ~= nil then
            self.parentoffset.x = self.parentoffset.x - obj.width*0.5
        end
        
        if obj.height ~= nil then
            self.parentoffset.y = self.parentoffset.y - obj.height*0.5
        end
        
    else
        self.parentoffset = vector.zero2
    end
    
end

--Detach a light from its parent object.
function Light:Detach()
    self.parent = nil
end

--Remove a light from all parent objects and destroy it.
function Light:Destroy()
    for _,v in ipairs(fields) do
        local lights = v.field.lights
        for i = 1,#lights do
            if lights[i] == self then
                tableremove(lights,i)
            end
        end
    end
    
    for i = 1,#globalLights do
        if globalLights[i] == self then
            tableremove(globalLights,i)
        end
    end
    
    setmetatable(self, NullMT)
end

--Create a light object, which can be added to the light list or a specific field.
function darkness.Light(x,y,radius,brightness,colour,flicker)
    if type(x) == "table" then
        local l = {    
                    x = x.x, 
                    y = x.y, 
                    radius = x.radius, 
                    brightness = x.brightness or 1, 
                    colour = x.colour or x.color or Color.white, 
                    enabled = true, 
                    flicker = x.flicker or false, 
                    type = x.type or 0, 
                    dir = x.dir or x.direction or vector.down2, 
                    spotangle = x.spotangle or 45,
                    spotpower = x.spotpower or 8
                }
        
        setmetatable(l, Light)
        return l
    else
        colour = colour or Color.white
        brightness = brightness or 1
        local l = {x=x,y=y,radius=radius,brightness=brightness,colour=colour,enabled=true,flicker=flicker or false, type = 0}
        
        setmetatable(l, Light)
        return l
    end
end
darkness.light = darkness.Light

local nullLight = darkness.Light(0,0,0,0,0)
local baseambient = Color.fromHexRGB(0x0D0D19)

local Field = {}
Field.__index = function(tbl, key)
                    if key == "isValid" then
                        return true
                    else
                        return Field[key]
                    end
                end;
Field.__newindex = function(tbl, key, val)
                    if key == "isValid" then
                        error("Cannot assign to readonly property isValid.", 2)
                    else
                        error("Field with key "..key.." does not exist in Field data structure.", 2)
                    end
                end
                
--Create a new darkness field. Arguments are:
--
--falloff                 - enum:falloff     - Determines how light intensity in this field should propagate. Defaults to falloff.DEFAULT. Paths to shaders can also be supplied.
--shadows                 - enum:shadow     - Determines how shadows should be rendered in this field. Defaults to shadow.DEFAULT. Paths to shaders can also be supplied.
--maxLights                - integer         - Maximum number of lights that can be rendered at any one time. Defaults to 60.
--uniforms                - table            - Extra uniforms to supply to the shader (can be used to tweak behaviour).
--priorityType            - enum:priority    - Determines how lights should be selected if there are too many to render. Defaults to priority.DISTANCE.
--bounds                - rect            - The boundaries of this feild. If left nil, will apply to the entire scene.
--boundBlendLength        - number        - How large the fadeout on the boundaries of this field will be, if they are used. Defaults to 64.
--section                - number        - Which section this field should apply to. -1 means all sections. Defaults to -1.
--sections    `            - table            - Takes precedence over "section". Allows multiple sections to be specified.
--ambient                - Color            - The ambient light colour. Defaults to 0x0D0D19.
--priority                - number        - The render priority of this field. Defaults to 0.
--additiveBrightness    - bool            - Whether the renderer should additively apply brightness values above 1. Defaults to true.
--distanceField            - bool            - Whether the renderer should generate a distance field map or just a regular mask. Defaults to false.

function darkness.Create(args)
    args = args or {}
    local f = {
        lights = {}, 
        falloff = args.falloff,
        shadows = args.shadows,
        maxLights = args.maxLights or 60, 
        uniforms = args.uniforms or {},
        priorityType = args.priorityType or darkness.priority.DISTANCE,
        bounds = args.bounds,
        boundBlendLength = args.boundBlendLength or 64,
        section = args.sections or args.section or -1,
        shader = Shader(),
        subshaders = {},
        ambient = args.ambient or baseambient,
        priority = args.priority or -5,
        distanceField = args.distanceField or false,
        additiveBrightness = args.additiveBrightness,
        enabled = true
        }
        
    if f.additiveBrightness == nil then
        f.additiveBrightness = true
    end
        
    setmetatable(f,Field)
        
    f:RebuildShader()
    
    tableinsert(fields, {field = f, uniforms = {cameraPos = {0, 0}}, lightdata = {}})
    return f
end
darkness.create = darkness.Create

--Adds a light from this particular field (consider using the global list instead)
function Field:AddLight(light)    
    if light.__removeList ~= nil and light.__removeList[self] then
        light.__removeList[self] = nil
    end
    tableinsert(self.lights, light)
    return light
end
Field.addLight = Field.AddLight

--Removes a light from this particular field (consider using the global list instead)
function Field:RemoveLight(light)
    if light.__removeList == nil then
        light.__removeList = {[self] = true}
    else
        light.__removeList[self] = true
    end
end
Field.removeLight = Field.RemoveLight


local function getComponentSize(self, d, useMaximal)
    local c = 0
    for _,v in ipairs(d) do
        if v.name ~= "lightData[0]" then
            c = c + Graphics.glGetComponentSize(v.type, useMaximal)*v.arrayCount
        end
    end
    return c
end

--Recompiles the darkness field shader. This is necessary for changes to certain properties, including:
--maxLights
--falloff
--shadows
function Field:RebuildShader()
    local adbri = self.additiveBrightness
    if adbri == nil then
        adbri = true
    end
    
    self.shader:compileFromFile(nil, fragShader, { _MAXLIGHTS = self.maxLights, FALLOFF = self.falloff or darkness.falloff.DEFAULT, SHADOWS = self.shadows or darkness.shadow.DEFAULT, ADDITIVE_BRIGHTNESS = adbri })
    
    local d = self.shader:getUniformInfo()
    
    if d == nil or #d == 0 then    --Shader failed, perhaps due to too many lights, so try smart recompilation
        
        if Graphics.GL_MAX_FRAGMENT_UNIFORM_COMPONENTS > 0 then --Don't attempt smart recompilation if we don't have access to this value
        
            --Adjust this if the light data type changes in future
            local lightDataType = GL_FLOAT_MAT3x4
        
            --Compile a test shader to check size of non-array uniforms
            local testShader = Shader()
            testShader:compileFromFile(nil, fragShader, { _MAXLIGHTS = 1, FALLOFF = self.falloff or darkness.falloff.DEFAULT, SHADOWS = self.shadows or darkness.shadow.DEFAULT, ADDITIVE_BRIGHTNESS = adbri })
            local baseData = testShader:getUniformInfo()
            
            --Get spec-compliant component sizes
            local c = getComponentSize(self, baseData, false)
            local lightSize = Graphics.glGetComponentSize(lightDataType, false)
            
            --Calculate maximum array length
            local m = floor((Graphics.GL_MAX_FRAGMENT_UNIFORM_COMPONENTS - c)/lightSize)
            
            --Try again
            self.shader:compileFromFile(nil, fragShader, { _MAXLIGHTS = m, FALLOFF = self.falloff or darkness.falloff.DEFAULT, SHADOWS = self.shadows or darkness.shadow.DEFAULT, ADDITIVE_BRIGHTNESS = adbri })
            local d = self.shader:getUniformInfo()
            if d == nil or  #d == 0 then    --Welp, failed again, try maximal component sizes
            
                --Get maximal component sizes
                c = getComponentSize(self, baseData, true)
                lightSize = Graphics.glGetComponentSize(lightDataType, true)
                
                --Calculate maximum array length
                local m = floor((Graphics.GL_MAX_FRAGMENT_UNIFORM_COMPONENTS - c)/lightSize)
                
                --Try again
                self.shader:compileFromFile(nil, fragShader, { _MAXLIGHTS = m, FALLOFF = self.falloff or darkness.falloff.DEFAULT, SHADOWS = self.shadows or darkness.shadow.DEFAULT, ADDITIVE_BRIGHTNESS = adbri })
                local d = self.shader:getUniformInfo()
                
                if d == nil or #d == 0 then    --Oof. Just give up here.
                    error("Could not compile darkness shader. Try lowering the maximum light count.", 2)
                else
                    Misc.warn("Specified maximum light count "..self.maxLights.." was too high for the graphics hardware. Adjusting value to "..m.." to remain within hardware limits.", 2)
                    self.maxLights = m
                end
            else
                Misc.warn("Specified maximum light count "..self.maxLights.." was too high for the graphics hardware. Adjusting value to "..m.." to remain within hardware limits.", 2)
                self.maxLights = m
            end
        else --If we don't have access to the hardware uniform component limit, smart recompilation cannot work, so just error instead
            error("Could not compile darkness shader. Try lowering the maximum light count.", 2)
        end
    end
    
    self.subshaders = {}
    local i = 0
    while i < self.maxLights do
        self.subshaders[i] = Shader()
        self.subshaders[i]:compileFromFile(nil, fragShader, { _MAXLIGHTS = i, FALLOFF = self.falloff or darkness.falloff.DEFAULT, SHADOWS = self.shadows or darkness.shadow.DEFAULT, ADDITIVE_BRIGHTNESS = adbri })
        if i == 0 then
            i = 1
        else
            i = i*2
        end
    end
end
Field.rebuildShader = Field.RebuildShader

--Destroys a darkness field and prevents it from being used again
function Field:Destroy()
    for i = 1,#fields do
        if fields[i].field == self then
            tableremove(fields,i)
            break
        end
    end
    
    setmetatable(self, NullMT)
end
Field.destroy = Field.Destroy


--Adds a light to the global light list
function darkness.AddLight(light)
    if light.__removeList ~= nil and light.__removeList[darkness] then
        light.__removeList[darkness] = nil
    end
    tableinsert(globalLights, light)
    return light
end
darkness.addLight = darkness.AddLight

--Removes a light from the global light list
function darkness.RemoveLight(light)    
    if light.__removeList == nil then
        light.__removeList = {[darkness] = true}
    else
        light.__removeList[darkness] = true
    end
end
darkness.removeLight = darkness.RemoveLight


--Internal library functions
do
    --Sort lights by priority
    local function lightSort(a, b)
        return a[2] < b[2]
    end

    --Get the priority value for a specific light (in case we have too many to draw)
    local function GetPriority(ptype, light, centre)
        if     ptype == darkness.priority.DISTANCE then
                    local x = light.x-centre[1]
                    local y = light.y-centre[2]
                    return x*x + y*y
        elseif ptype == darkness.priority.SIZE then
            return -light.radius
        elseif ptype == darkness.priority.BRIGHTNESS then
            return -light.brightness
        else
            return 0
        end
    end

    local function lightUpdate(self)
        local parent = self.parent
        if parent ~= nil then
            if not parent.isValid then
                self:destroy()
                return false
            elseif  (parent.__type == "NPC" and (parent:mem(0x40, FIELD_BOOL) or not parent:mem(0x124, FIELD_BOOL) or parent.isGenerator))         --NPC is invisible or despawned
                or  (parent.__type == "Player" and (parent:mem(0x13C, FIELD_BOOL) or parent:mem(0x13E, FIELD_WORD) ~= 0)) --Player is dead
                or ((parent.__type == "Block" or parent.__type == "BGO") and (parent.isHidden)) then                        --Block or BGO is invisible
                return false
            else
                local data = parent.data
                if data ~= nil then
                    data = data._basegame
                    if data ~= nil then
                        local darkdata = data._darkness
                        if darkdata ~= nil and darkdata[1] ~= parent.id then
                            darkdata[2]:destroy()
                            data._darkness = nil
                            return false
                        end
                    end
                end
                
                local dmult = 1
                if parent.direction ~= nil then
                    dmult = parent.direction
                    
                    if parent.__type == "NPC" and NPC.config[parent.id].framestyle == 0 then
                        dmult = 1
                    end
                end
                
                self.x = parent.x + self.parentoffset.x*dmult
                self.y = parent.y + self.parentoffset.y
                if parent.width ~= nil then
                    self.x = self.x + parent.width*0.5
                end
                if self.parent.height ~= nil then
                    self.y = self.y + parent.height*0.5
                end
            end
        end
        return true
    end

    --List the lights and their distances from the centrepoint.
    --Also remove any lights that we've queued for removal.
    local function getLights(obj, list, centre, priorityType, isglobal, rtrn)
        local k = 1
        
        while k <= #list do
            local v = list[k]
            if v.enabled then
                if lightUpdate(v) then
                    if v.__removeList and v.__removeList[obj] then
                        v.__removeList[obj] = nil
                        tableremove(list, k)
                    else
                        tableinsert(rtrn, {k, GetPriority(priorityType, v, centre), v, isglobal})
                        k = k + 1
                    end
                else
                    k = k+1
                end
            else
                k = k+1
            end
        end
    end

    local list = {}
    local colList = {}
    local distList = {}
    local spotList = {}
    local centre = vector.zero2
    
    --Choose which lights we should render in a specific frame
    local function chooseLights(field, cam)
        for i = 1,#distList do
            distList[i] = nil
        end
     
        centre.x,centre.y = cam.x + cam.width*0.5, cam.y + cam.height*0.5 --Screen centre
        
        --Get lights from both the global and local list
        getLights(darkness, globalLights, centre, darkness.priorityType, true, distList)
        getLights(field, field.lights, centre, field.priorityType, false, distList)
        
        --Remove duplicates of the same light
        local hash = {}
        for i = #distList,1,-1 do
            local v = distList[i][3]
            if not hash[v] then
                hash[v] = true
            else
                tableremove(distList,i)
            end
        end
        
        --Sort the lights by priority
        tablesort(distList, lightSort)
        
        local count = 0
        
        local idx = 1
        
        --Iterate through lights and add them to the list
        for i=1,#distList,1 do
            --Break early if we have too many lights
            if count >= field.maxLights then
                break
            end
            local val = distList[i]
            if val[4] then
                val = globalLights[val[1]]
            else
                val = field.lights[val[1]]
            end
            
            local r = val.radius
            if val.flicker then
                local maxmult = 128
                local fd = 0.03125
                if r <= 128 then
                    r = max(r * (1 + rand(-fd, fd)), 1)
                else
                    r = max(r + rand(-fd, fd)*128, 1)
                end
            end
            --Don't add lights if the light is entirely offscreen
            if val.x+r > cam.x and val.x-r < cam.x+cam.width and val.y+r > cam.y and val.y-r < cam.y+cam.height then
                count = count + 1
                
                list[idx],list[idx+1],list[idx+2] = val.x, val.y, r
                
                if val.type == darkness.lighttype.SPOT then
                    list[idx+3] = val.spotpower
                else
                    list[idx+3] = 0
                end
                
                idx = idx + 4
                
                for j = 0,2 do
                    list[idx+j] = val.colour[j+1]
                end
                list[idx+3] = val.brightness
                
                idx = idx + 4
                
                if val.type == darkness.lighttype.SPOT then
                    local a = max(val.spotangle, 0)
                    local b = 0
                    if a > 180 then
                        b = (cos(min(a,360)*pi/180)+ 1)*0.5
                        a = 180
                    end
                        
                    if val.flicker then
                        local fd = 0.03125
                        a = max(min(a * (1 + rand(-fd, fd)), 180), 0)
                    end
                    list[idx],list[idx+1],list[idx+2],list[idx+3] = val.dir.x, val.dir.y, 1 - (cos(a*pi/180)+1)*0.5 + b, 1
                else
                    for j = 0,3 do
                        list[idx+j] = 0
                    end
                end
                
                idx = idx + 4
            end
        end
        --Fill unused lights with null values
        for i=count+1,field.maxLights do
            for j = 0,11 do
                list[idx+j] = 0
            end
            
            idx = idx + 12
        end
        
        return list,count
    end
    
    local scenecapture = Graphics.CaptureBuffer(800,600)
    
    local screendraw = {vertexCoords = {0,0,800,0,800,600,0,600}, textureCoords = {0,0,1,0,1,1,0,1}, primitive = Graphics.GL_TRIANGLE_FAN, texture = scenecapture, sceneCoords = false }
    local fielddraw =     { vertexCoords = {}, textureCoords = {}, primitive = Graphics.GL_TRIANGLE_FAN, texture = scenecapture, sceneCoords = false }
    
    local function hasLight(tbl)
        local radius = tbl.lightradius
        if radius == nil or radius <= 0 then
            return false
        end
        local brightness = tbl.lightbrightness
        if brightness == nil or brightness <= 0 then
            return false
        end
        if tbl.lightcolor == nil then
            return true
        else
            return isNotBlack(tbl.lightcolor)
        end
    end
    
    local drawBlocks = blockutils.getMask
    
    --Sort fields by render priority (needed to ensure capture buffers are correct)
    local function fieldsort(a, b)
        return a.field.priority < b.field.priority
    end
    
    
    --Object Definitions
    do
    local npcdefaults = 
    {
            [12] = {x=0, y=0, radius = 64, brightness = 1, color = Color.orange, flicker = true},
            [13] = {x=0, y=0, radius = 32, brightness = 1, color = Color.orange, flicker = true},
            [85] = {x=8, y=0, radius = 32, brightness = 1, color = Color.orange, flicker = true},
            [87] = {x=12, y=0, radius = 64, brightness = 1, color = Color.orange, flicker = true},
            [108] = {x=0, y=0, radius = 64, brightness = 1, color = Color.orange, flicker = true},
            [160] = {x=-96, y=0, radius = 64, brightness = 1, color = Color.orange, flicker = true},
            [210] = {x=0, y=0, radius = 64, brightness = 1, color = Color.orange, flicker = false},
            [211] = {x=0, y=0, radius = 64, brightness = 1, color = Color.red, flicker = false},
            [246] = {x=0, y=0, radius = 32, brightness = 1, color = Color.orange, flicker = true},
            [259] = {x=0, y=0, radius = 64, brightness = 1, color = Color.white, flicker = false},
            [260] = {x=0, y=0, radius = 32, brightness = 1, color = Color.orange, flicker = true},
            [265] = {x=0, y=0, radius = 32, brightness = 1, color = Color.cyan, flicker = false},
            [266] = {x=0, y=0, radius = 32, brightness = 1, color = Color.white, flicker = false},
            [282] = {x=18, y=0, radius = 64, brightness = 2, color = Color.orange, flicker = true},
    }
    
    local function setCfg(cfg, v)
        cfg.lightradius = v.radius
        cfg.lightcolor = v.color
        cfg.lightbrightness = v.brightness
        cfg.lightoffsetx = v.x
        cfg.lightoffsety = v.y
        cfg.lightflicker = v.flicker
    end
    
    for id, v in pairs(npcdefaults) do
        local cfg = NPC.config[id]
        setCfg(cfg,v)
    end
end

    --Library Events

    function darkness.onInitAPI()
        registerEvent(darkness, "onStart")
        registerEvent(darkness, "onDraw")
        registerEvent(darkness, "onCameraDraw")
        registerEvent(darkness, "onNPCConfigChange")
        registerEvent(darkness, "onBlockConfigChange")
        registerEvent(darkness, "onBGOConfigChange")
        
        unregisterEvent(olddarkness, "onStart")
        unregisterEvent(olddarkness, "onDraw")
        unregisterEvent(olddarkness, "onCameraDraw")
        unregisterEvent(olddarkness, "onNPCConfigChange")
        unregisterEvent(olddarkness, "onBlockConfigChange")
        unregisterEvent(olddarkness, "onBGOConfigChange")
    end
    
    local function updateIDMap(list, maxID, config)
        for i = 1,maxID do
            list[i] = hasLight(config[i])
        end
    end
    
    local function updateIDList(list, maxID, config)
        local idx = 1
        for i = 1,maxID do
            if hasLight(config[i]) then
                list[idx] = i
                idx = idx + 1
            end
        end
        
        local c = #list
        for i=idx,c do
            list[i] = nil
        end
    end
    
    local blockIDMap = {}
    local function updateBlockIDMap()
        updateIDMap(blockIDMap, BLOCK_MAX_ID, Block.config)
    end
    
    local npcIDMap = {}
    local function updateNPCIDMap()
        updateIDMap(npcIDMap, NPC_MAX_ID, NPC.config)
    end
    
    local bgoIDMap = {}
    local function updateBGOIDMap()
        updateIDMap(bgoIDMap, BGO_MAX_ID, BGO.config)
    end
    
    local importantkeys = {lightradius = true, lightbrightness = true, lightcolor = true, lightoffsetx = true, lightoffsety = true}
    
    function darkness.onBlockConfigChange(id, key)
        if importantkeys[key] then
            blockIDMap[id] = hasLight(Block.config[id])
            if EventManager.onStartRan then
                for _,v in Block.iterate(id) do
                    local darkdata = v.data._basegame._darkness
                    if darkdata and darkdata[2] then
                        darkdata[2]:destroy()
                    end
                    v.data._basegame._darkness = nil
                end
            end
        end
    end
    
    function darkness.onNPCConfigChange(id, key)
        if importantkeys[key] then
            npcIDMap[id] = hasLight(NPC.config[id])
            if EventManager.onStartRan then
                for _,v in NPC.iterate(id) do
                    local darkdata = v.data._basegame._darkness
                    if darkdata and darkdata[2] then
                        darkdata[2]:destroy()
                    end
                    v.data._basegame._darkness = nil
                end
            end
        end
    end
    
    function darkness.onBGOConfigChange(id, key)
        if importantkeys[key] then
            bgoIDMap[id] = hasLight(BGO.config[id])
            if EventManager.onStartRan then
                for _,v in BGO.iterate(id) do
                    local darkdata = v.data._basegame._darkness
                    if darkdata and darkdata[2] then
                        darkdata[2]:destroy()
                    end
                    v.data._basegame._darkness = nil
                end
            end
        end
    end
    
    local function addLight(class, v)
        if class ~= nil and class.config ~= nil then
            local tbl = class.config[v.id]
            
            if tbl ~= nil then
                local radius = tbl.lightradius or 0
                local color = colorparse(tbl.lightcolor or Color.white)
                local brightness = tbl.lightbrightness or 0
                
                if radius > 0 and (color.r ~= 0 or color.g ~= 0 or color.b ~= 0) and brightness > 0 then    
                    local light = darkness.addLight(darkness.light(0,0, radius, brightness, color, tbl.lightflicker))
                    light:attach(v, true)
                    light.parentoffset.x = tbl.lightoffsetx or 0
                    light.parentoffset.y = tbl.lightoffsety or 0
                    
                    return light
                end
            end
        end
    end
    
    local function convertBounds(bounds, output)
        local useBounds = 1
        if bounds then
            if bounds.x and bounds.y and bounds.width and bounds.height then
                output[1] = bounds.x
                output[2] = bounds.y
                output[3] = bounds.x+bounds.width
                output[4] = bounds.y+bounds.height
            elseif bounds.left and bounds.top and bounds.right and bounds.bottom then
                output[1] = bounds.left
                output[2] = bounds.top
                output[3] = bounds.right
                output[4] = bounds.bottom
            elseif bounds[1] and bounds[2] and bounds[3] and bounds[4] then
                output = bounds
            else
                useBounds = 0
                output = nil
            end
        else
            useBounds = 0
            output = nil
        end
        
        return useBounds, output
    end
    
    local function isInSection(field, s)
        local sect = field.section
        return sect == s or sect == -1 or (type(sect)=="table" and table.icontains(sect, s))
    end
    
    --Used to disable drawing the dark field when ambient is white - no longer a valid assumption since addition of additive brightness
    local function isNotWhite(c)
        for i=1,3 do
            if c[i] < 1 then
                return true
            end
        end
        
        return false
    end
    
    local function hasPossibleLights(f)
        return f.additiveBrightness or isNotWhite(f.ambient)
    end
    
    local sectionlist = {}
    local anyFieldsValid = false
    local function anyValidFields()
        sectionlist[1] = player.section
        if Player.count() == 2 then
            sectionlist[2] = player2.section
        else
            sectionlist[1] = player.section
        end
        
        local cnt = #sectionlist
        for _,v in ipairs(fields) do
            local field = v.field
            if field.enabled and hasPossibleLights(field) then
                for _,s in ipairs(sectionlist) do
                    if isInSection(field, s) then
                        return true
                    end
                end
            end
        end
        
        return false
    end
    
    local function checkLightData(v, darkdata, class)
        if darkdata == nil then
            darkdata = {v.id, addLight(class, v)}
        elseif v.id ~= darkdata[1] then
            if darkdata[2] then
                darkdata[2]:destroy()
            end
            darkdata[1] = v.id
            darkdata[2] = addLight(class, v)
        end
        return darkdata
    end
    
    function darkness.onStart()
        updateBGOIDMap()
        updateBlockIDMap()
        updateNPCIDMap()
    end
    
    function darkness.onDraw()
        anyFieldsValid = anyValidFields()
        
        if anyFieldsValid then
        
            --updateBGOIDMap()
            for _,v in BGOIterateByFilterMap(bgoIDMap) do
                local data = v.data._basegame
                data._darkness = checkLightData(v, data._darkness, BGO)
            end
            
            --updateBlockIDMap()
            for _,v in BlockIterateByFilterMap(blockIDMap) do
                local data = v.data._basegame
                data._darkness = checkLightData(v, data._darkness, Block)
            end
            
            local sectionIdxMap = {}
            for _,v in ipairs(Player.get()) do
                sectionIdxMap[v.section] = true
            end
            
            --updateNPCIDMap()
            for _,v in NPCIterateByFilterMap(npcIDMap) do
                if not v.isGenerator and sectionIdxMap[v.section] then
                    local data = v.data._basegame
                    data._darkness = checkLightData(v, data._darkness, NPC)
                end
            end
        end
    
        for _,v in ipairs(fields) do
            local useBounds = 1
            local bounds = v.field.bounds
            local useBounds, b = convertBounds(bounds, {})
            
            local uni = v.uniforms
            for k,w in pairs(v.field.uniforms) do
                uni[k] = w
            end

            uni.ambient = v.field.ambient
            uni.bounds = b
            uni.useBounds = useBounds
            uni.boundBlend = v.field.boundBlendLength
            
            v.useBounds = useBounds==1
        end
    end
    
    local function getBestShader(field, count)
        if count >= field.maxLights then
            return field.shader, field.maxLights
        elseif field.subshaders[count] then
            return field.subshaders[count], count
        else
            local best = field.subshaders[0]
            local i = 0
            while i < count do
                if i == 0 then
                    i = 1
                else
                    i = i*2
                end
                best = field.subshaders[i]        
                
                if best == nil then
                    return field.shader, field.maxLights
                end
            end
            
            return best, i
        end
        
    end
    
    local function cleanLightList(lis, count)
        local l = #lis
        for i=(count*12)+1,l do
            lis[i] = nil
        end
    end
    
    function darkness.onCameraDraw(camidx)
        if anyFieldsValid then
            local cam = Camera(camidx)
            
            tablesort(fields, fieldsort)
            
            local p = -101
            
            local drawnblocks = false
            local playerobj = Player(camidx)
            
            local camx,camy = cam.x, cam.y
            
            for _,v in ipairs(fields) do
                local field = v.field
                if field.shader and field.enabled and hasPossibleLights(field) and isInSection(field, playerobj.section) then
                    
                    local uniforms = v.uniforms
                    
                    if not drawnBlocks and field.shadows ~= nil and field.shadows ~= darkness.shadow.NONE then
                        uniforms.mask = drawBlocks(cam, field.distanceField)
                        drawnblocks = true
                    end
                    if field.priority >= p then
                        p = field.priority
                        scenecapture:captureAt(p)
                    end
                    
                    local lights,lightCount = chooseLights(field, cam)
                    
                    uniforms.cameraPos[1], v.uniforms.cameraPos[2] = camx, camy
                    uniforms.lightData = lights
                    
                    local shad, listcnt = getBestShader(field,lightCount)
                    cleanLightList(lights, listcnt)
                    
                    if not v.useBounds then
                        screendraw.shader = shad
                        screendraw.uniforms = uniforms
                        screendraw.priority = p
                        glDraw(screendraw)
                    else       
                        local b = uniforms.bounds
                        local b1x = max(b[1]-camx, 0)
                        local b1y = max(b[2]-camy, 0)
                        local b2x = min(b[3]-camx, 800)
                        local b2y = min(b[4]-camy, 600)
                        
                        if b2x > b1x and b2y > b1y then
                        
                            local t1x, t1y = b1x/800, b1y/600
                            local t2x, t2y = b2x/800, b2y/600
                            
                            
                            local vc = fielddraw.vertexCoords
                            local tc = fielddraw.textureCoords
                            
                            vc[1],vc[2],vc[3],vc[4],vc[5],vc[6],vc[7],vc[8] = b1x, b1y, b2x, b1y, b2x, b2y, b1x, b2y
                            tc[1],tc[2],tc[3],tc[4],tc[5],tc[6],tc[7],tc[8] = t1x, t1y, t2x, t1y, t2x, t2y, t1x, t2y
                            
                            fielddraw.shader = shad
                            fielddraw.uniforms = uniforms
                            fielddraw.priority = p
                            glDraw(fielddraw)
                        end
                        
                    end
                    
                end
            end
            
        end
    end
    
    
end

_G.Darkness = darkness

return darkness