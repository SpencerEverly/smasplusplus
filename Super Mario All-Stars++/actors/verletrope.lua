local verlet = {}

local function constrain(rope)
    for i = 1,#rope.segments-1 do
        local a = rope.segments[i]
        local b = rope.segments[i+1]
        
        if not a.fixed or not b.fixed then
            
            local dv = (a.position - b.position)
            local dist = dv.length
            local err = math.abs(dist - rope.segmentLength)
            local delta = vector.zero2
            
            if dist > rope.segmentLength then
                delta = err/dist * dv
            elseif dist < rope.segmentLength then
                delta = -err/dist * dv
            end
            
            if not a.fixed then
                if not b.fixed then
                    a.position = a.position - delta * 0.5
                    b.position = b.position + delta * 0.5
                else
                    a.position = a.position - delta
                end
            else
                b.position = b.position + delta
            end
            
            if rope.constraints then
                rope:constraints(a,b)
            end
        end
    end
    
            
    if rope.constraints then
        rope:constraints(rope.segments[#rope.segments], nil)
    end
end

local function updateRope(rope)
    local sleep = true
    for _,v in ipairs(rope.segments) do
        if not v.fixed then
            local vel = v.position-v.oldpos
            v.oldpos = v.position
            vel = vel + vector.down2*Defines.npc_grav
            v.position = v.position + vel
        end
    end
    
    for i = 1,rope.iterations do
        constrain(rope)
    end
end


local function makeSegment(pos)
    local t = {position = pos, oldpos = pos, fixed = false}
    return t
end

local function makeRope(startPos, endPos, segments, iterations)
    local v = startPos
    local d = (endPos-startPos)/segments
    
    local r = {startPos = startPos, endPos = endPos, segmentLength = d.length, segments = {}, iterations = iterations or 10}
    
    r.update = updateRope
    
    for i=1,segments do
        table.insert(r.segments, makeSegment(v))
        v = v + d
    end
    
    r.segments[1].fixed = true
    
    return r
end

verlet.Rope = makeRope

return verlet