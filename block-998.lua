--Blockmanager is required for setting basic Block properties
local blockManager = require("blockManager")

--Create the library table
local sampleBlock = {}

local lavaSystem = require("scripts/lava/lavaSystem")
--BLOCK_ID is dynamic based on the name of the library file
local blockID = BLOCK_ID

--Defines Block config for our Block. You can remove superfluous definitions.
local sampleBlockSettings = {
	id = blockID,
	--Frameloop-related
	frames = 8,
	framespeed = 12, --# frames between frame change

	--Identity-related flags:
	--semisolid = false, --top-only collision
	--sizable = false, --sizable block
	--passthrough = false, --no collision
	--bumpable = false, --can be hit from below
	--lava = true, --instakill
	--pswitchable = false, --turn into coins when pswitch is hit
	--smashable = 0, --interaction with smashing NPCs. 1 = destroyed but stops smasher, 2 = hit, not destroyed, 3 = destroyed like butter

	--floorslope = 0, -1 = left, 1 = right
	--ceilingslope = 0,

	--Emits light if the Darkness feature is active:
	--lightradius = 100,
	--lightbrightness = 1,
	--lightoffsetx = 0,
	--lightoffsety = 0,
	--lightcolor = Color.white,

	--Define custom properties below
    setLavaKill = true,
}

--Applies blockID settings
blockManager.setBlockSettings(sampleBlockSettings)

--Register the vulnerable harm types for this Block. The first table defines the harm types the Block should be affected by, while the second maps an effect to each, if desired.

--Custom local definitions below


--Register events
function sampleBlock.onInitAPI()
	blockManager.registerEvent(blockID, sampleBlock, "onTickEndBlock")
    blockManager.registerEvent(blockID, sampleBlock, "onCollideBlock")
    lavaSystem.register(blockID)
end

function sampleBlock.onTickEndBlock(v)
    -- Don't run code for invisible entities
	if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end
	
	local data = v.data
	
	--Execute main AI here.
    
end

function sampleBlock.onCollideBlock(v,n)
    if Block.config[blockID].setLavaKill then
        if(n.__type == "Player") then
            if n.deathTimer == 0 --[[already dead]] and not Defines.cheat_donthurtme then
                n:kill()
            end
        end
	end
    if(n.__type == "NPC") then
        n:kill(HARM_TYPE_LAVA)
    end
end

--Gotta return the library table!
return sampleBlock