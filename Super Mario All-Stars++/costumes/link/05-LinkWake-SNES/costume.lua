---------------------------------------------------------------
-- ▄█          ▄████████  ▄█        ▄█  ███▄▄▄▄      ▄█   ▄█▄-- 
--███         ███    ███ ███       ███  ███▀▀▀██▄   ███ ▄███▀-- 
--███         ███    ███ ███       ███▌ ███   ███   ███▐██▀  -- 
--███         ███    ███ ███       ███▌ ███   ███  ▄█████▀   -- 
--███       ▀███████████ ███       ███▌ ███   ███ ▀▀█████▄   -- 
--███         ███    ███ ███       ███  ███   ███   ███▐██▄  -- 
--███▌    ▄   ███    ███ ███▌    ▄ ███  ███   ███   ███ ▀███▄-- 
--█████▄▄██   ███    █▀  █████▄▄██ █▀    ▀█   █▀    ███   ▀█▀-- 
---------------------------------------------------------------
------------Link's Awakening/ Zelda GBC-Style Link-------------
------------------------FOR SMBX2 β3---------------------------





local costume = {}

local playerAnim = require("playeranim")
local smasFunctions = require("smasFunctions")

local linkAttack = playerAnim.Anim({8,7,6,6,6,6,6,6,6}, 3)
local linkJump = playerAnim.Anim({14,15,16,17}, 4)
local linkIdleSwim = playerAnim.Anim({12}, 0)
local linkSwim = playerAnim.Anim({13,12}, 6)
local linkUnderwaterHurt = playerAnim.Anim({11}, 0)

function onTick()

    if player.downKeyPressing then
        Defines.player_link_shieldEnabled = true
    elseif not player.downKeyPressing then
        Defines.player_link_shieldEnabled = false
    end


    if (player:mem(0x160, FIELD_BOOL))
    and (not player.downKeyPressing) then
        player:mem(0x12E, FIELD_BOOL, true)
    end



local forcedState = (player:mem(0x122, FIELD_WORD) == 3)



--linkJump
    if (player.character == CHARACTER_LINK)
        and (player.speedY <= 0)
        and (not player.upKeyPressing)
        and (player:mem(0x124,FIELD_DFLOAT) == 0)
        and (not forcedState)
        and (player:mem(0x122, FIELD_WORD) ~= 7)
        and (player:mem(0x114, FIELD_WORD) ~= 10)
        and (not player:isGroundTouching())
        and (not player:mem(0x160, FIELD_BOOL))
        and (not player:mem(0x36, FIELD_BOOL))
        and (not linkJump:isPlaying(player)) then
            linkJump:play(player)
    elseif ((player.character ~= CHARACTER_LINK)
        or (player:isGroundTouching())
        or (player:mem(0x124,FIELD_DFLOAT) ~= 0)
        or (forcedState)
        or (player:mem(0x122, FIELD_WORD) == 7)
        or (player:mem(0x160, FIELD_BOOL))
        or (player:mem(0x36, FIELD_BOOL))
        or ((player.downKeyPressing) and (player.speedY > 0))
        or ((player.upKeyPressing) and (player:mem(0x114, FIELD_WORD) == 10)))
        and (linkJump:isPlaying(player)) then
            linkJump:stop(player)
    end

--linkAttack
    if (player.character == CHARACTER_LINK)
        and (player:mem(0x160, FIELD_BOOL))
        and (player:mem(0x140, FIELD_WORD) == 0)
        and (not linkAttack:isPlaying(player)) then
            linkAttack:play(player)
    elseif ((player.character ~= CHARACTER_LINK)
        or (player:mem(0x140, FIELD_WORD) ~= 0)
        or (not player:mem(0x160, FIELD_BOOL)))
        and (linkAttack:isPlaying(player)) then
            linkAttack:stop(player)
    end

--linkIdleSwim
    if (player.character == CHARACTER_LINK)
        and (player:mem(0x36, FIELD_BOOL))
        and (not player:mem(0x160, FIELD_BOOL))
        and (player:mem(0x38,FIELD_WORD) == 0)
        and (not linkIdleSwim:isPlaying(player)) then
            linkIdleSwim:play(player)
    elseif ((player.character ~= CHARACTER_LINK)
        or (not player:mem(0x36, FIELD_BOOL))
        or (player:mem(0x160, FIELD_BOOL))
        or (player:mem(0x38,FIELD_WORD) ~= 0))
        and (linkIdleSwim:isPlaying(player)) then
            linkIdleSwim:stop(player)
    end

--linkSwim
    if (player.character == CHARACTER_LINK)
        and (player:mem(0x36, FIELD_BOOL))
        and (not player:mem(0x160, FIELD_BOOL))
        and (player:mem(0x38,FIELD_WORD) ~= 0)
        and (not linkSwim:isPlaying(player)) then
            linkSwim:play(player)
    elseif ((player.character ~= CHARACTER_LINK)
        or (not player:mem(0x36, FIELD_BOOL))
        or (player:mem(0x160, FIELD_BOOL)))
        and (linkSwim:isPlaying(player)) then
            linkSwim:stop(player)
    end

--linkUnderwaterHurt
    if (player.character == CHARACTER_LINK)
        and (player:mem(0x36, FIELD_BOOL))
        and (player:mem(0x140, FIELD_WORD) ~= 0)
        and (not linkUnderwaterHurt:isPlaying(player)) then
            linkUnderwaterHurt:play(player)
    elseif ((player.character ~= CHARACTER_LINK)
        or (not player:mem(0x36, FIELD_BOOL))
        or (player:mem(0x140, FIELD_WORD) == 0))
        and (linkUnderwaterHurt:isPlaying(player)) then
            linkUnderwaterHurt:stop(player)
    end 

end

Misc.storeLatestCostumeData(costume)

Misc.storeLatestCostumeData(costume)

return costume