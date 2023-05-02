local hair = {}

local verlet = require("actors/verletrope")

local hair_mt = {

    __index = function(t,k)
        if k == "x" then
            return t.strand.segments[1].position.x
        elseif k == "y" then
            return t.strand.segments[1].position.y
        elseif k == "endx" then
            if t.fixTarget then
                return t.target.x
            else
                local vs = t.strand.segments
                return vs[#vs].position.x
            end
        elseif k == "endy" then
            if t.fixTarget then
                return t.target.x
            else
                local vs = t.strand.segments
                return vs[#vs].position.y
            end
        elseif k == "fixTarget" then
            return t.strand.segments[#t.strand.segments].fixed
        elseif k == "floorY" then
            return t.strand.ylimit
        end
    end,

    __newindex = function(t,k,v)
        if k == "x" then
            t.strand.segments[1].position.x = v
        elseif k == "y" then
            t.strand.segments[1].position.y = v
        elseif k == "endx" then
            if t.fixTarget then
                t.target.x = v
            else
                local vs = t.strand.segments
                vs[#vs].position.x = v
            end
        elseif k == "endy" then    
            if t.fixTarget then
                t.target.y = v
            else
                local vs = t.strand.segments
                vs[#vs].position.y = v
            end
        elseif k == "fixTarget" then
            t.strand.segments[#t.strand.segments].fixed = v
        elseif k == "floorY" then
            t.strand.ylimit = v
        end
    end

}

local function updateHair(h)
    if h.fixTarget then
        local p = h.strand.segments[#h.strand.segments].position
        p.x = h.target.x
        p.y = h.target.y
    else
        h.targetdir = (h.strand.segments[#h.strand.segments].position-h.strand.segments[(#h.strand.segments-1)].position):normalize()
    end
    
    h.strand:update()
end

local vs = {}
local ts = {}
local function drawHair(h, priority)
    priority = priority or -45
    local i = 1
    for k,v in ipairs(h.strand.segments) do
        if k ~= #h.strand.segments then
            vs[i]    = v.position.x-12
            vs[i+1]  = v.position.y-12
            vs[i+2]  = v.position.x+12
            vs[i+3]  = v.position.y-12
            vs[i+4]  = v.position.x-12
            vs[i+5]  = v.position.y+12
            vs[i+6]  = v.position.x-12
            vs[i+7]  = v.position.y+12
            vs[i+8]  = v.position.x+12
            vs[i+9]  = v.position.y-12
            vs[i+10] = v.position.x+12
            vs[i+11] = v.position.y+12
            
            ts[i]    = 0
            ts[i+1]  = 0
            ts[i+2]  = 1
            ts[i+3]  = 0
            ts[i+4]  = 0
            ts[i+5]  = 0.5
            ts[i+6]  = 0
            ts[i+7]  = 0.5
            ts[i+8]  = 1
            ts[i+9]  = 0
            ts[i+10] = 1
            ts[i+11] = 0.5
            
            i = i+12
        end
    end
    
    local j = #vs
    for k = i,j do
        vs[k] = nil
        ts[k] = nil
    end
    
    Graphics.glDraw{vertexCoords = vs, textureCoords = ts, texture = h.endsprite.texture, sceneCoords = true, priority = priority}
    local e = h.strand.segments[#h.strand.segments]
    h.endsprite.x = e.position.x
    h.endsprite.y = e.position.y
    h.endsprite.rotation = math.deg(math.asin((-vector.right2)..h.targetdir)) - 90
    h.endsprite:draw{priority = priority, sceneCoords = true, frame = 2}
end

local function makeHair(s, startdir, texture, floory)
    local e = s + startdir:normalize() * 80
    local r = {target = vector(e.x,e.y), targetdir = startdir, strand = verlet.Rope(s, e, 5), endsprite = Sprite{x=e.x, y=e.y, width = 24, height = 24, texture = texture, frames = 2, pivot=Sprite.align.CENTER}}
    
    r.strand.ylimit = floory
    r.strand.constraints = function(l,a,b)
        if (a.oldpos-a.position).sqrlength < 0.005 then
            a.position.x = a.oldpos.x
            a.position.y = a.oldpos.y
        end
        if l.ylimit then
            if a.position.y > l.ylimit then
                local dp = a.oldpos-a.position
                local d = dp:normalise()
                if d.y >= 0 then
                    a.position.y = l.ylimit
                else
                    local dist = (a.position.y-l.ylimit)/d.y
                    local s = dp.length
                    if dist > s then
                        a.position = vector(a.oldpos.x, l.ylimit)
                    else
                        a.position = a.position - d*dist
                    end
                end
            end
        end
    end
    
    r.update = updateHair
    r.draw = drawHair
    
    return setmetatable(r, hair_mt)
end

hair.Hair = makeHair

return hair