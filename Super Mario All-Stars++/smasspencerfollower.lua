local smasspencerfollower = {}

if table.icontains(smastables.__smbspencerLevels,Level.filename()) == false then return end

function smasspencerfollower.onInitAPI()
    registerEvent(smasspencerfollower,"onDraw")
end

function smasspencerfollower.onDraw()
    if not SaveData.disableX2char then
        if player.direction == 1 then
            Img.draw("costumes/luigi/00-SpencerEverly/luigi-2.png", player.x - 50, player.y, true, true, -25, 1)
        else
            Img.draw("costumes/luigi/00-SpencerEverly/luigi-2.png", player.x + 50, player.y, true, true, -25, 1)
        end
    end
end

return smasspencerfollower