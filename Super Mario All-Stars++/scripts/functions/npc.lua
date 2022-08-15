local Npc = {}

function Npc.harmAll(npc,...) -- npc:harm but it harms all NPCs with a specified HARM_TYPE
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

function Npc.harmSpecified(npcid,...) -- npc:harm but it harms all of a specific NPC and not everything with a specified HARM_TYPE
    if npcid == nil then
        return
    end
    for k,v in ipairs(NPC.get(npcid)) do
        local oldKilled     = v:mem(0x122,FIELD_WORD)
        local oldProjectile = v:mem(0x136,FIELD_BOOL)
        local oldHitCount   = v:mem(0x148,FIELD_FLOAT)
        local oldImmune     = v:mem(0x156,FIELD_WORD)
        local oldID         = v.id
        local oldSpeedX     = v.speedX
        local oldSpeedY     = v.speedY

        v:harm(...)

        return (
               oldKilled     ~= v:mem(0x122,FIELD_WORD)
            or oldProjectile ~= v:mem(0x136,FIELD_BOOL)
            or oldHitCount   ~= v:mem(0x148,FIELD_FLOAT)
            or oldImmune     ~= v:mem(0x156,FIELD_WORD)
            or oldID         ~= v.id
            or oldSpeedX     ~= v.speedX
            or oldSpeedY     ~= v.speedY
        )
    end
end

return Npc