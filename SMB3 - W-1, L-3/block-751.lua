--Version 2, for Pre-Final Build

local blockManager = require("blockManager")

local SuperSpringboard = Misc.resolveFile("red_spring.ogg")

local rednoteblock = {}
local blockID = BLOCK_ID

--Defines Block config for our Block. You can remove superfluous definitions.
local RNBSettings = {
    id = blockID,
    frames = 4,
    framespeed = 8,
    bumpable = true
}

blockManager.setBlockSettings(RNBSettings)

function rednoteblock.onInitAPI()
    blockManager.registerEvent(blockID, rednoteblock, "onTickEndBlock")
end

function rednoteblock.onTickEndBlock(v)
    if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end
    --local data = v.data
    --v:hit()

    if v:collidesWith(player) == 1 then
        v:hit(true)
        SFX.play(3)
        if player.keys.jump == KEYS_DOWN or player.keys.altJump == KEYS_DOWN then
            player.speedY = -29
            SFX.play(SuperSpringboard)
        else
            player.speedY = -6
        end
    end
    if Player.count() >= 2 then
        if v:collidesWith(player2) == 1 then
            v:hit(true)
            SFX.play(3)
            if player2.keys.jump == KEYS_DOWN or player2.keys.altJump == KEYS_DOWN then
                player2.speedY = -29
                SFX.play(SuperSpringboard)
            else
                player2.speedY = -6
            end
        end
    end
end
return rednoteblock