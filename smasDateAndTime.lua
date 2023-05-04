local textplus = require("textplus")

local segoeui = textplus.loadFont("littleDialogue/font/segoeui.ini")
local verdana = textplus.loadFont("littleDialogue/font/verdana.ini")
local alarmclockfont = textplus.loadFont("littleDialogue/font/alarmclock.ini")

local homedicsamimg = Graphics.loadImageResolved("graphics/datetime/time-homedics-am.png")
local homedicspmimg = Graphics.loadImageResolved("graphics/datetime/time-homedics-pm.png")

local winxpimg = Graphics.loadImageResolved("graphics/datetime/time-winxp.png")
local win10img = Graphics.loadImageResolved("graphics/datetime/time-win10.png")

local smasDateAndTime = {}

smasDateAndTime.enabled = true

smasDateAndTime.positionTable = {
    BOTTOM_RIGHT  = 1,
    BOTTOM_LEFT   = 2,
    TOP_LEFT      = 3,
    TOP_RIGHT     = 4,
}

--1 means bottom-right, 2 means bottom-left, 3 means top-left, and 4 means top-right respectively.
smasDateAndTime.position = smasDateAndTime.positionTable.BOTTOM_RIGHT
smasDateAndTime.priority = 5

function smasDateAndTime.onInitAPI()
    registerEvent(smasDateAndTime, "onDraw")
end

function smasDateAndTime.onDraw()
    if smasDateAndTime.enabled then
        if SaveData.SMASPlusPlus.options.clockTheme == "normal" then
            if smasDateAndTime.position == smasDateAndTime.positionTable.BOTTOM_RIGHT then
                Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - .1} --What's the day, sir?!
                textplus.print{x=700, y=557, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=smasDateAndTime.priority, color=Color.white}
                
                Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - .1} --What time is it...!?
                textplus.print{x=724, y=580, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=smasDateAndTime.priority, color=Color.white}
            elseif smasDateAndTime.position == smasDateAndTime.positionTable.BOTTOM_LEFT then
                Graphics.drawBox{x=10, y=552, width=100, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - 1} --What's the day, sir?!
                textplus.print{x=15, y=557, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=smasDateAndTime.priority, color=Color.white}
                
                Graphics.drawBox{x=10, y=575, width=76, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - 1} --What time is it...!?
                textplus.print{x=15, y=580, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=smasDateAndTime.priority, color=Color.white}
            elseif smasDateAndTime.position == smasDateAndTime.positionTable.TOP_LEFT then
                Graphics.drawBox{x=10, y=5, width=100, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - 1} --What's the day, sir?!
                textplus.print{x=15, y=10, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=smasDateAndTime.priority, color=Color.white}
                
                Graphics.drawBox{x=10, y=27, width=76, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - 1} --What time is it...!?
                textplus.print{x=15, y=32, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=smasDateAndTime.priority, color=Color.white}
            elseif smasDateAndTime.position == smasDateAndTime.positionTable.TOP_RIGHT then
                Graphics.drawBox{x=695, y=5, width=100, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - 1} --What's the day, sir?!
                textplus.print{x=700, y=10, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=smasDateAndTime.priority, color=Color.white}
                
                Graphics.drawBox{x=719, y=27, width=76, height=20, color=Color.black..0.2, priority=smasDateAndTime.priority - 1} --What time is it...!?
                textplus.print{x=724, y=32, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=smasDateAndTime.priority, color=Color.white}
            end
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "vintage" then
            
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "homedics" then
            if smasDateAndTime.position == smasDateAndTime.positionTable.BOTTOM_RIGHT then
                if Time.meridiem() == "AM" then
                    Graphics.drawImageWP(homedicsamimg, 0, 0, smasDateAndTime.priority - 1)
                else
                    Graphics.drawImageWP(homedicspmimg, 0, 0, smasDateAndTime.priority - 1)
                end
                textplus.print{x=717, y=563, text = os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=smasDateAndTime.priority, color=Color.green, font=alarmclockfont, xscale=0.8, yscale=0.8} --What time is it...!?
            end
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "rob" then
            
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "modern" then
            
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "windows98" then
            
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "windowsxp" then
            if smasDateAndTime.position == smasDateAndTime.positionTable.BOTTOM_RIGHT then
                Graphics.drawImageWP(winxpimg, 615, 570, smasDateAndTime.priority - 1)
                textplus.print{x=745, y=581, text = os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=smasDateAndTime.priority, color=Color.white, font=verdana} --What time is it...!?
            end
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "windows7" then
            
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "windows10" then
            if smasDateAndTime.position == smasDateAndTime.positionTable.BOTTOM_RIGHT then
                Graphics.drawImageWP(win10img, 661, 560, smasDateAndTime.priority - 1)
                textplus.print{x=726, y=564, text = os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=smasDateAndTime.priority, color=Color.white, font=segoeui} --What time is it...!?
                textplus.print{x=722, y=582, text = os.date("%m").."/"..os.date("%d").."/"..os.date("%Y"), priority=smasDateAndTime.priority, color=Color.white, font=segoeui} --What's the day, sir?!
            end
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "windows11" then
            
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "macosx" then
            
        end
        if SaveData.SMASPlusPlus.options.clockTheme == "ubuntu" then
            
        end
    end
end

return smasDateAndTime