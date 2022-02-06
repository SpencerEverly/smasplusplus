local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

npcManager.setNpcSettings{
	id = id,
	
	width = 32,
	gfxwidth = 32,
	gfxheight = 28,
	height = 28,
	
	isshell = true,
}


function npc.onTickEndNPC(v)
	-- local config = NPC.config[id]

end

local THROWN_NPC_COOLDOWN    = 0x00B2C85C
local SHELL_HORIZONTAL_SPEED = 0x00B2C860
local SHELL_VERTICAL_SPEED   = 0x00B2C864

function npc.onNPCHarm(eventObj, v, reason, culprit)
	--Adopted from MDA's code!!
    if v.id ~= id then return end
 
    local config = NPC.config[v.id]

    local culpritIsPlayer = (type(culprit) == "Player")
    local culpritIsNPC = (type(culprit) == "NPC")
 
    if reason == HARM_TYPE_JUMP then
        if v:mem(0x138,FIELD_WORD) == 2 then -- dropping out of the item box
            v:mem(0x138,FIELD_WORD,0)
        end
 
 
        if not culpritIsPlayer or (culprit:mem(0xBC,FIELD_WORD) <= 0 and culprit.mount ~= MOUNT_CLOWNCAR) then -- I have no CLUE what this check is for but it's in redigit's code!
            local playerIsCantHurtPlayer = (culpritIsPlayer and v:mem(0x130,FIELD_WORD) == culprit.idx)
            
            if v.speedX == 0 and not playerIsCantHurtPlayer then
                -- Kick it
                SFX.play(9)
 
                if culpritIsPlayer then
                    v.direction = culprit.direction
 
                    -- Set don't hurt player and timer
                    v:mem(0x12E,FIELD_WORD, mem(THROWN_NPC_COOLDOWN,FIELD_WORD))
                    v:mem(0x130,FIELD_WORD, culprit.idx)
                end
 
                v.speedX = mem(SHELL_HORIZONTAL_SPEED,FIELD_FLOAT) * v.direction
                v.speedY = 0
 
                v:mem(0x136,FIELD_BOOL,true) -- set projectile flag
            elseif not playerIsCantHurtPlayer or (culpritIsPlayer and v:mem(0x22,FIELD_WORD) == 0 and not culprit.climbing) then
                -- Stop it
                SFX.play(2)
 
                v.speedX = 0
                v.speedY = 0
 
                v:mem(0x18,FIELD_FLOAT,0) -- "real speed x"
                v:mem(0x136,FIELD_BOOL,false) -- projectile flag
            end
        end
 
        eventObj.cancelled = true
        return
    elseif reason == HARM_TYPE_PROJECTILE_USED then
        -- Shells won't die when hitting an NPC UNLESS the NPC it hit is a projectile and is not a beach koopa
        if not culpritIsNPC or not culprit:mem(0x136,FIELD_BOOL) then
            eventObj.cancelled = true
            return
        end
    elseif reason == 7 then
		SFX.play(9)
		v.speedY = -5
		
		eventObj.cancelled = true
	elseif reason == 2 then
		SFX.play(9)
		v.speedY = -5
		
		eventObj.cancelled = true
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	npcManager.registerHarmTypes(id,
		{
			HARM_TYPE_SPINJUMP,
			1,
			2,
			4,
			6,
			7,
			10,
		}, 
		{
			[HARM_TYPE_LAVA]=10,
		}
	);
	
	registerEvent(npc, 'onNPCHarm')
end


return npc