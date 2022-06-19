local textplus = require("textplus")

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
			Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=0} --What's the day, sir?!
			textplus.print{x=700, y=557, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=0, color=Color.white}	
			
			Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=0} --What time is it...!?
			textplus.print{x=724, y=580, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=0, color=Color.white}
		end
		
		
		if datetime.bottomleft then
			Graphics.drawBox{x=10, y=552, width=100, height=20, color=Color.black..0.2, priority=0} --What's the day, sir?!
			textplus.print{x=15, y=557, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=0, color=Color.white}
			
			
			Graphics.drawBox{x=10, y=575, width=76, height=20, color=Color.black..0.2, priority=0} --What time is it...!?
			textplus.print{x=15, y=580, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=0, color=Color.white}
		end
		
		
		if datetime.topright then
			Graphics.drawBox{x=695, y=5, width=100, height=20, color=Color.black..0.2, priority=0} --What's the day, sir?!
			textplus.print{x=700, y=10, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=0, color=Color.white}	
			
			Graphics.drawBox{x=719, y=27, width=76, height=20, color=Color.black..0.2, priority=0} --What time is it...!?
			textplus.print{x=724, y=32, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=0, color=Color.white}
		end
		
		
		if datetime.topleft then
			Graphics.drawBox{x=10, y=5, width=100, height=20, color=Color.black..0.2, priority=0} --What's the day, sir?!
			textplus.print{x=15, y=10, text = "Date -  "..os.date("%a").." "..os.date("%x"), priority=0, color=Color.white}	
			
			Graphics.drawBox{x=10, y=27, width=76, height=20, color=Color.black..0.2, priority=0} --What time is it...!?
			textplus.print{x=15, y=32, text = "Time - "..os.date("%I")..":"..os.date("%M").." "..os.date("%p"), priority=0, color=Color.white}
		end
	end
	if SaveData.clockTheme == "vintage" then
		
	end
	if SaveData.clockTheme == "homedics" then
		
	end
	if SaveData.clockTheme == "rob" then
		
	end
	if SaveData.clockTheme == "modern" then
		
	end
	if SaveData.clockTheme == "windows98" then
		
	end
	if SaveData.clockTheme == "windowsxp" then
		
	end
	if SaveData.clockTheme == "windows7" then
		
	end
	if SaveData.clockTheme == "windows10" then
		
	end
	if SaveData.clockTheme == "windows11" then
		
	end
	if SaveData.clockTheme == "macosx" then
		
	end
	if SaveData.clockTheme == "ubuntu" then
		
	end
end

return datetime