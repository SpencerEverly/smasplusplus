local textplus = require("textplus")

local ready = false

local datetime = {}

datetime.bottomright = true
datetime.bottomleft = false
datetime.topright = false

function datetime.onInitAPI()
	registerEvent(datetime, "onDraw")
	ready = true
end

function datetime.onDraw()
	if datetime.bottomright then
		Graphics.drawBox{x=695, y=552, width=100, height=20, color=Color.black..0.2, priority=0} --What's the day, sir?!
		textplus.print{x=700, y=557, text = "Date - ", priority=0, color=Color.white}
		textplus.print{x=733, y=557, text = os.date("%a"), priority=0, color=Color.white}
		textplus.print{x=754, y=557, text = os.date("%x"), priority=0, color=Color.white}
		
		
		Graphics.drawBox{x=719, y=575, width=76, height=20, color=Color.black..0.2, priority=0} --What time is it...!?
		textplus.print{x=724, y=580, text = "Time - ", priority=0, color=Color.white}
		textplus.print{x=755, y=580, text = os.date("%I"), priority=0, color=Color.white}
		textplus.print{x=765, y=580, text = ":", priority=0, color=Color.white}
		textplus.print{x=768, y=580, text = os.date("%M"), priority=0, color=Color.white}
		textplus.print{x=780, y=580, text = os.date("%p"), priority=0, color=Color.white}
	end
	
	
	if datetime.bottomleft then
		Graphics.drawBox{x=10, y=552, width=100, height=20, color=Color.black..0.2, priority=8} --What's the day, sir?!
		textplus.print{x=15, y=557, text = "Date - ", priority=8, color=Color.white}
		textplus.print{x=48, y=557, text = os.date("%a"), priority=8, color=Color.white}
		textplus.print{x=69, y=557, text = os.date("%x"), priority=8, color=Color.white}
		
		
		Graphics.drawBox{x=10, y=575, width=76, height=20, color=Color.black..0.2, priority=8} --What time is it...!?
		textplus.print{x=15, y=580, text = "Time - ", priority=8, color=Color.white}
		textplus.print{x=46, y=580, text = os.date("%I"), priority=8, color=Color.white}
		textplus.print{x=56, y=580, text = ":", priority=8, color=Color.white}
		textplus.print{x=59, y=580, text = os.date("%M"), priority=8, color=Color.white}
		textplus.print{x=71, y=580, text = os.date("%p"), priority=8, color=Color.white}
	end
	
	
	if datetime.topright then
		Graphics.drawBox{x=695, y=27, width=100, height=20, color=Color.black..0.2, priority=0} --What's the day, sir?!
		textplus.print{x=700, y=32, text = "Date - ", priority=0, color=Color.white}
		textplus.print{x=733, y=32, text = os.date("%a"), priority=0, color=Color.white}
		textplus.print{x=752, y=32, text = os.date("%x"), priority=0, color=Color.white}
		
		
		Graphics.drawBox{x=719, y=5, width=76, height=20, color=Color.black..0.2, priority=0} --What time is it...!?
		textplus.print{x=724, y=10, text = "Time - ", priority=0, color=Color.white}
		textplus.print{x=755, y=10, text = os.date("%I"), priority=0, color=Color.white}
		textplus.print{x=765, y=10, text = ":", priority=0, color=Color.white}
		textplus.print{x=768, y=10, text = os.date("%M"), priority=0, color=Color.white}
		textplus.print{x=780, y=10, text = os.date("%p"), priority=0, color=Color.white}
	end
end

return datetime