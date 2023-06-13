local kamikazeKoopa = {}

local npcutils = require("npcs/npcutils")
local smasFunctions = require("smasFunctions")
local npcID = NPC_ID

function kamikazeKoopa.onInitAPI()
    NPC.registerEvent(kamikazeKoopa, "onTickNPC")
end

function kamikazeKoopa.onTickNPC(v)
    --[[for k,j in ipairs(Block.get(90)) do
        if Colliders.collide(v, j) and Collisionz.FindCollision(v, j) == Collisionz.CollisionSpot.COLLISION_LEFT then --Dumb bug when hitting the shell via the left of a turn block
            Sound.playSFX(3)
            j:hit()
        end
    end]]
end

return kamikazeKoopa