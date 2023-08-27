--[[

smasFireballs.lua v1.0
By SpencerlyEverly

fastFireballs.lua code was also based off of, so credits goes to MegoZ_ for that.

]]

local smasFireballs = {}

function smasFireballs.onInitAPI()
    registerEvent(smasFireballs,"onTick")
    registerEvent(smasFireballs,"onNPCKill")
    registerEvent(smasFireballs,"onPostNPCHarm")
    registerEvent(smasFireballs,"onDrawEnd")
end

smasFireballs.enableClassicShooting = true

smasFireballs.fireballCooldown = 64
smasFireballs.fireballCooldownTimer = {}
smasFireballs.playerFireballCount = {}
for i = 1,200 do
    smasFireballs.playerFireballCount[i] = 0
    smasFireballs.fireballCooldownTimer[i] = smasFireballs.fireballCooldown
end
smasFireballs.fireballLimit = 2

local fireballtimer = 0
local iceballtimer = 0

function smasFireballs.onTick()
    if smasFireballs.enableClassicShooting and not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        for k,p in ipairs(Player.get()) do
            if not p:mem(0x50, FIELD_BOOL) and (p.powerup == 3) then
                --Assosiate Fireball to Player
                for kn, n in ipairs(NPC.getIntersecting(p.x-6, p.y-6, p.x+p.width+6, p.y+p.height+6)) do
                    if n.id == 13 and n.ai3 == 0 then --This checks if ai3 is 0, which means it's ownerless.
                        n.ai3 = k
                        smasFireballs.playerFireballCount[k] = smasFireballs.playerFireballCount[k] + 1
                    end
                end
                
                if smasFireballs.playerFireballCount[k] < smasFireballs.fireballLimit and smasFireballs.fireballCooldownTimer[k] >= smasFireballs.fireballCooldown then
                    p:mem(0x160,FIELD_WORD,0) -- Allow Shooting
                else
                    smasFireballs.fireballCooldownTimer[k] = smasFireballs.fireballCooldownTimer[k] - 1
                    p:mem(0x160,FIELD_WORD,10) -- Disable Shooting
                    if smasFireballs.fireballCooldownTimer[k] <= 0 then
                        smasFireballs.fireballCooldownTimer[k] = smasFireballs.fireballCooldown
                        smasFireballs.playerFireballCount[k] = 0
                    end
                end

                --Reset Fireball counting to 0 when there are no fireballs (In case it bugs out)
                if #NPC.get(13) == 0 then
                    smasFireballs.playerFireballCount[k] = 0
                end
            else
                smasFireballs.fireballCooldownTimer[k] = smasFireballs.fireballCooldown
            end
        end
    end
end

function smasFireballs.onNPCKill(eventObj, npc, harmtype)
    --[[if smasFireballs.enableClassicShooting and not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
        for k, p in ipairs(Player.get()) do
            if npc.ai3 == k then
                smasFireballs.playerFireballCount[k] = smasFireballs.playerFireballCount[k] - 1
            end
        end
    end]]
end

function smasFireballs.onPostNPCHarm(npc, harmType)
    if SaveData.SMASPlusPlus.player[1].currentCostume == "MODERN2" then
        if npc.id == 13 then
            if harmType == HARM_TYPE_PROJECTILE_USED then
                Audio.sounds[3].muted = true
                fireballtimer = 2
            end
        end
        if npc.id == 265 then
            if harmType == HARM_TYPE_NPC then
                Audio.sounds[3].muted = true
                iceballtimer = 2
            end
            if harmType == HARM_TYPE_PROJECTILE_USED then
                Audio.sounds[3].muted = true
                iceballtimer = 2
            end
        end
    end
end

function smasFireballs.onDrawEnd()
    if SaveData.SMASPlusPlus.player[1].currentCostume == "MODERN2" then
        if fireballtimer > 0 then
            fireballtimer = fireballtimer - 1
            if fireballtimer == 0 then
                Audio.sounds[3].muted = false
            end
        end
        if iceballtimer > 0 then
            iceballtimer = iceballtimer - 1
            if iceballtimer == 1 then
                SFX.play("costumes/mario/Modern2/iceball-hit.ogg")
            end
            if iceballtimer == 0 then
                Audio.sounds[3].muted = false
            end
        end
    end
end

return smasFireballs