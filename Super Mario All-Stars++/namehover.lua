local namehover = {}

namehover.active = false

local textplus = require("textplus")
local smbxdefault = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus.ini")

local ready = false

function namehover.onInitAPI() --This requires all the libraries that will be used
    registerEvent(namehover, "onDraw")
    registerEvent(namehover, "onExit")
    registerEvent(namehover, "onTick")
    
    ready = true
end

function namehover.onDraw()
    if namehover.active == true then
        local namep1 = "<color white>"..SaveData.playerName.."</color>"
        local name1 = textplus.layout(textplus.parse(namep1, {xscale=1, yscale=1, align="center", color=Color.white..1.0, font=smbxdefault, maxWidth=450}), player.x - camera.x + 16)
        local w = name1.width
        textplus.render{x = player.x - camera.x + 8 - name1.width*0.5, y = player.y - camera.y, layout = name1, priority = -24}
        if Player.count() >= 2 then
            local namep2 = "<color white>Guest</color>"
            local name2 = textplus.layout(textplus.parse(namep2, {xscale=1, yscale=1, align="center", color=Color.white..1.0, font=smbxdefault, maxWidth=450}), Player(2).x - camera.x + 16)
            local w2 = name2.width
            textplus.render{x = Player(2).x - camera.x + 8 - name2.width*0.5, y = Player(2).y - camera.y, layout = name2, priority = -24}
        end
    end
end

return namehover