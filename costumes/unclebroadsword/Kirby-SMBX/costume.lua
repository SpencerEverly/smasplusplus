local costume = {}

local playerManager = require("playerManager")
local smasFunctions = require("smasFunctions")
local explosions = Particles.Emitter(0, 0, Misc.resolveFile("costumes/unclebroadsword/Kirby-SMBX/ice_attack.ini"))
local kirby = require("costumes/unclebroadsword/Kirby-SMBX/kirby")

local BoomerangLock = 0
local BombLock = 0

function costume.onInit(p)
    unclebroadsword = require("characters/unclebroadswordd")
    unclebroadsword.costumeActive = true
    registerEvent(costume,"onTick")
end

function costume.onCleanup(p)
    unclebroadsword = require("characters/unclebroadswordd")
    unclebroadsword.costumeActive = false
end

function costume.onTick()
    if player.character == CHARACTER_UNCLEBROADSWORD then
        for k,v in ipairs(NPC.get(13, -1)) do
            v.speedY = 0
        end
    end






    if player.powerup == PLAYER_ICE then
        if player.character == CHARACTER_UNCLEBROADSWORD then
            if(player.runKeyPressing) then
                if player:isGroundTouching() then
                    player:mem(0x0a, FIELD_BOOL,1) 
                end
            end
        end
    end

    if player.powerup == PLAYER_ICE then
        if player.character == CHARACTER_UNCLEBROADSWORD then
            if BombLock == 0 then
                if(player.keys.altRun) then
                    for k,v in pairs(NPC.get(265,-1)) do
                        v:kill(3)
                        player.speedX = 0
                        explosions.x = player.x + 0.5 * player.width
                        explosions.y = player.y + 0.5 * player.height
                        explosions:Emit(1)
                        SFX.play("explode.ogg")
                        local circ = Colliders.Circle(player.x + 0.5 * player.width, player.y + 0.5 * player.height, 35)
                        for k,n in ipairs(Colliders.getColliding{
                            atype = Colliders.NPC,
                            b = circ,
                            filter = function(o)
                            if NPC.HITTABLE_MAP[o.id] and not o.friendly and not o.isHidden then
                                return true
                            end
                        end
                        }) do
                            n:harm(HARM_TYPE_EXT_ICE)
                        end
                    end
                end
            end
        end
    end



    if player.powerup == PLAYER_TANOOKIE then
        if player.character == CHARACTER_UNCLEBROADSWORD then
            if BombLock == 0 then
                if(player.keys.altJump) then
                    explosions.x = player.x + 0.5 * player.width
                    explosions.y = player.y + 0.5 * player.height
                    explosions:Emit(1)            local circ = Colliders.Circle(player.x + 0.5 * player.width, player.y + 0.5 * player.height, 40)
                    for k,n in ipairs(Colliders.getColliding{
                        atype = Colliders.NPC,
                        b = circ,
                        filter = function(o)
                        if NPC.HITTABLE_MAP[o.id] and not o.friendly and not o.isHidden then
                            return true
                        end
                    end
                    }) do
                        n:harm(HARM_TYPE_PROJECTILE_USED)
                    end
                end
            end
        end
    end











    if player.powerup == PLAYER_ICE then
        if player.character == CHARACTER_UNCLEBROADSWORD then
            if not(player.keys.altRun) then
                player:mem(0x160, FIELD_WORD,1) 
            end
        end
    end




    if player.powerup == PLAYER_HAMMER then
        if player.character == CHARACTER_UNCLEBROADSWORD then
            if BoomerangLock == 0 then
                if(player.runKeyPressing) then
                    for k,v in pairs(NPC.get(171,-1)) do
                        v.id = 134
                        v.width = 32
                        v.height = 32
                        v:mem(0x110,FIELD_DFLOAT,1)
                        if BoomerangLock == 0 then
                            if player:mem(0x106,FIELD_WORD) ~= -1 then
                                BoomerangLock = 1
                                v.x = v.x + 2
                                v.speedX = 4
                                v.speedY = -5
                            else
                                v.x = v.x - 2
                                v.speedX = -4
                                v.speedY = -5
                                BoomerangLock = 1
                            end
                        end
                    end
                end
            else
                local BoomerangCheck = NPC.get(174,-1)
                if table.getn(BoomerangCheck) == 0 then
                    BoomerangLock = 0
                else
                    player:mem(0x160,FIELD_WORD,2)
                end
            end
        end
    end
end

Misc.storeLatestCostumeData(costume)

return costume