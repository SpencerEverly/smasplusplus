local textplus = require("textplus")

local segoeui = textplus.loadFont("littleDialogue/font/segoeui.ini")
local verdana = textplus.loadFont("littleDialogue/font/verdana.ini")
local alarmclockfont = textplus.loadFont("littleDialogue/font/alarmclock.ini")

local homedicsamimg = Graphics.loadImageResolved("graphics/datetime/time-homedics-am.png")
local homedicspmimg = Graphics.loadImageResolved("graphics/datetime/time-homedics-pm.png")

local winxpimg = Graphics.loadImageResolved("graphics/datetime/time-winxp.png")
local win10img = Graphics.loadImageResolved("graphics/datetime/time-win10.png")

local ready = false

local datetime = {}

datetime.bottomright = true
datetime.bottomleft = false
datetime.topright = false
datetime.topleft = false

function datetime.onInitAPI()
    registerEvent(datetime, "onDraw")
    ready = true
end

function datetime.onDraw()
    if SaveData.clockTheme == "normal" then
        if datetime.bottomright then
            Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=-1.1} --What's the day, sir?!
            textplus.print{x=700, y=557, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=-1, color=Color.white}    
            
            Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=-1.1} --What time is it...!?
            textplus.print{x=724, y=580, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=-1, color=Color.white}
        end
        
        
        if datetime.bottomleft then
            Graphics.drawBox{x=10, y=552, width=100, height=20, color=Color.black..0.2, priority=-1.1} --What's the day, sir?!
            textplus.print{x=15, y=557, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=-1, color=Color.white}
            
            
            Graphics.drawBox{x=10, y=575, width=76, height=20, color=Color.black..0.2, priority=-1.1} --What time is it...!?
            textplus.print{x=15, y=580, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=-1, color=Color.white}
        end
        
        
        if datetime.topright then
            Graphics.drawBox{x=695, y=5, width=100, height=20, color=Color.black..0.2, priority=-1.1} --What's the day, sir?!
            textplus.print{x=700, y=10, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=-1, color=Color.white}    
            
            Graphics.drawBox{x=719, y=27, width=76, height=20, color=Color.black..0.2, priority=-1.1} --What time is it...!?
            textplus.print{x=724, y=32, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=-1, color=Color.white}
        end
        
        
        if datetime.topleft then
            Graphics.drawBox{x=10, y=5, width=100, height=20, color=Color.black..0.2, priority=-1.1} --What's the day, sir?!
            textplus.print{x=15, y=10, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=-1, color=Color.white}
            
            Graphics.drawBox{x=10, y=27, width=76, height=20, color=Color.black..0.2, priority=-1.1} --What time is it...!?
            textplus.print{x=15, y=32, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=-1, color=Color.white}
        end
    end
    if SaveData.clockTheme == "vintage" then
        
    end
    if SaveData.clockTheme == "homedics" then
        if datetime.bottomright then
            if os.date("%p") == "am" then
                Graphics.drawImageWP(homedicsamimg, 0, 0, -1.1)
            else
                Graphics.drawImageWP(homedicspmimg, 0, 0, -1.1)
            end
            textplus.print{x=717, y=563, text = os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=-1, color=Color.green, font=alarmclockfont, xscale=0.8, yscale=0.8} --What time is it...!?
        end
    end
    if SaveData.clockTheme == "rob" then
        
    end
    if SaveData.clockTheme == "modern" then
        
    end
    if SaveData.clockTheme == "windows98" then
        
    end
    if SaveData.clockTheme == "windowsxp" then
        if datetime.bottomright then
            Graphics.drawImageWP(winxpimg, 615, 570, -1.1)
            textplus.print{x=745, y=581, text = os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=-1, color=Color.white, font=verdana} --What time is it...!?
        end
    end
    if SaveData.clockTheme == "windows7" then
        
    end
    if SaveData.clockTheme == "windows10" then
        if datetime.bottomright then
            Graphics.drawImageWP(win10img, 661, 560, -1.1)
            textplus.print{x=726, y=564, text = os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=-1, color=Color.white, font=segoeui} --What time is it...!?
            textplus.print{x=722, y=582, text = os.date("%m").."/"..os.date("%d").."/"..os.date("%Y"), priority=-1, color=Color.white, font=segoeui} --What's the day, sir?!
        end
    end
    if SaveData.clockTheme == "windows11" then
        
    end
    if SaveData.clockTheme == "macosx" then
        
    end
    if SaveData.clockTheme == "ubuntu" then
        
    end
end

return datetime