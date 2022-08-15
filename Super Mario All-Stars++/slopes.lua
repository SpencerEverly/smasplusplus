slopes = {}
-- Forward slope: [332,326,341,600,305,358,635,299,316,452]
-- Backward slope: [333,327,343,601,307,359,637,300,315,451]
-- Low incline slopes: {324,325 ,340,342 ,604,605 ,306,308 ,357,360 ,636,638 ,616,617 ,365,366,  321,319}

slopes.forward = {332,326,341,600,305,358,635,299,316,452}
slopes.backward = {333,327,343,601,307,359,637,300,315,451}
slopes.steep = {}
slopes.jump_through = {}
slopes.position = {}
slopes.slippery = {}
slopes.jumped = false
slopes.on_steep = false
slopes.physics = true
slopes.y = 0

function slopes.onInitAPI()
    registerEvent(slopes,"onTick")
    registerEvent(slopes,"onStart")
end

function slopes.onStart()
    for _,v in pairs(slopes.jump_through) do
        for _,v2 in pairs(Block.get(v)) do
            table.insert(slopes.position,{v2.x,v2.y,v2.id})
        end
        for _,v2 in pairs(Block.get(v)) do
            for i = 0,32,4 do
                if slopes.in_table(slopes.forward,v) then
                    NPC.spawn(92,v2.x+(i),v2.y+(32-i),0,true).friendly = true
                elseif slopes.in_table(slopes.backward,v) then
                    NPC.spawn(92,v2.x+(i),v2.y+(i),0,true).friendly = true
                end
            end
        end
    end
end

function slopes.onTick()
    for k,v in pairs(NPC.get(1,0)) do
        Text.print(v.direction,0,0)
    end
    for k,v in pairs(slopes.position) do
        Graphics.drawImageToSceneWP(Graphics.loadImage("block-"..tostring(v[3])..".png"),v[1],v[2],-95)
    end
    if player.powerup == PLAYER_SMALL and player:mem(0x108,FIELD_WORD) == 0 then
        slopes.y = player.y
    elseif player:mem(0x12E,FIELD_WORD) == 0 then
        slopes.y = player.y+32
    end
    slopes.on_steep = false
    slopes.jumped = false
    for k,v in pairs(slopes.jump_through) do
        if slopes.jumped then
            break
        end
        for k2,v2 in pairs(slopes.position) do
            if math.abs(v2[1] - player.x) <= 48 or math.abs(v2[2] - player.y) <= 48 then
                if ((slopes.in_table(slopes.forward,v2[3]) and (v2[1] - player.x) + (v2[2]-slopes.y) >= 0) or (slopes.in_table(slopes.backward,v2[3]) and (player.x - v2[1]) + (v2[2]-slopes.y) >= 0)) or (slopes.isGroundTouching() and ((slopes.y-v2[2]) > 70 or (slopes.y-v2[2]) < 0)) then
                    for _,v3 in pairs(Block.getIntersecting(player.x-48,slopes.y-48,player.x+48,player.y+48)) do
                        if v3.id == v2[3] then
                            v3.isHidden = false
                        end
                    end
                elseif math.abs(v2[1]-player.x) < 100 and math.abs(v2[2]-slopes.y) < 100 and player.speedY < 0 then
                    for _,v3 in pairs(Block.getIntersecting(player.x-48,slopes.y-48,player.x+48,player.y+48)) do
                        if v3.id == v2[3] then
                            v3.isHidden = true
                            slopes.jumped = true
                        end
                    end
                    break
                elseif math.abs(v2[1]-player.x) > 64 and math.abs(v2[1]-slopes.y) > 64 then
                    for _,v3 in pairs(Block.getIntersecting(player.x-48,slopes.y-48,player.x+48,player.y+48)) do
                        if v3.id == v2[3] then
                            v3.isHidden = false
                        end
                    end
                elseif player.speedY <= 0 then
                    for _,v3 in pairs(Block.getIntersecting(player.x-48,slopes.y-48,player.x+48,player.y+48)) do
                        if v3.id == v2[3] then
                            v3.isHidden = true
                            slopes.jumped = true
                        end
                    end
                end
            end
            for k3,v3 in pairs(Block.get(v2[3])) do
                if math.abs(player.x - v3.x) > 100 and math.abs(player.y - v3.y) > 100 then
                    v3.isHidden = false
                end
            end
        end
    end
    if slopes.physics then
        for _,v in pairs(slopes.forward) do
            if not slopes.in_table(slopes.steep,v) then
                for _,v2 in pairs(Block.get(v)) do
                    if    (v2:collidesWith(player) == 5 or v2:collidesWith(player) == 1) and player.speedX <= 2 and player.speedX >= -1 and player.speedY >= 0 and (v2.x-player.x) + (v2.y-slopes.y) > 5 and slopes.isGroundTouching() then
                        if not(player.rightKeyPressing or player.leftKeyPressing or player.downKeyPressing) then
                            player.speedX = - 1
                            break
                        end
                    end
                end
            else 
                for k,v2 in pairs(Block.get(v)) do
                    if    (v2:collidesWith(player) == 5 or v2:collidesWith(player) == 1) and player.speedY >= 0 and slopes.isGroundTouching() then
                        if not player.downKeyPressing and player:mem(0x114,FIELD_WORD) ~= 24 and player.speedX > -2 and slopes.on_steep == false then
                            player.speedX = -2
                            player.speedY = 10
                            slopes.on_steep = true
                            break
                        end
                    end
                end
            end
        end
        for _,v in pairs(slopes.backward) do
            if not slopes.in_table(slopes.steep,v) then
                for _,v2 in pairs(Block.get(v)) do
                    if    (v2:collidesWith(player) == 5 or v2:collidesWith(player) == 1) and player.speedX >= -2 and player.speedX <= 1 and player.speedY >= 0 and (player.x - v2.x) + (v2.y-slopes.y) > 5 and slopes.isGroundTouching() then
                        if not(player.rightKeyPressing or player.leftKeyPressing or player.downKeyPressing) then
                            player.speedX = 1
                            break
                        end
                    end
                end
            else 
                for k,v2 in pairs(Block.get(v)) do
                    if    (v2:collidesWith(player) == 5 or v2:collidesWith(player) == 1) and player.speedY >= 0 and slopes.isGroundTouching() then
                        if not player.downKeyPressing and player:mem(0x114,FIELD_WORD) ~= 24 and player.speedX < 2 and not slopes.on_steep then
                            player.speedX = 2
                            player.speedY = 10
                            slopes.on_steep = true
                            break
                        end
                    end
                end
            end
        end
    end
end

function slopes.in_table(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function slopes.isGroundTouching()
    return player:mem(0x146, FIELD_WORD) ~= 0 or player:mem(0x48, FIELD_WORD) ~= 0 or player:mem(0x176, FIELD_WORD) ~= 0
end

return slopes

-- API made by TheDinoKing