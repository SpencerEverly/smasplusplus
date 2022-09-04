local fastFireballs = {}
--v1.2

local textplus = require("textplus")

function fastFireballs.onInitAPI()
	registerEvent(fastFireballs, "onTick")
	registerEvent(fastFireballs, "onNPCKill")
end
fastFireballs.limit = 2
fastFireballs.showMeDebug = false
local cam = Camera.get()[1] --for debug


local playerBallCount = {0,0}

function fastFireballs.onTick()
	for kp, p in ipairs(Player.get()) do
		if p:mem(0x50, FIELD_BOOL) then return end
		--Assosiate Fireball to Player
		for kn, n in ipairs(NPC.getIntersecting(p.x-3, p.y-3, p.x+p.width+3, p.y+p.height+3)) do
			if (n.id == 13 or n.id == 265 or n.id == 171) and n.ai3 == 0 then --This checks if ai3 is 0, which means it's ownerless.
				n.ai3 = kp
				playerBallCount[kp] = playerBallCount[kp] + 1
			end
		end

		if playerBallCount[kp] < fastFireballs.limit then
			p:mem(0x160,FIELD_WORD,0) -- Allow Shooting
		else
			p:mem(0x160,FIELD_WORD,1) -- Disable Shooting
		end

		--Reset Fireball counting to 0 when there are no fireballs (In case it bugs out)
		if #NPC.get({13,265,171}) == 0 then
			playerBallCount[kp] = 0
		end

		for kn, n in ipairs(NPC.get({13,265,171})) do
			if n.ai3 == kp then
				if n.despawnTimer == 179 then
					playerBallCount[kp] = playerBallCount[kp] - 1
					n.ai3 = 0
				end
			end
		end

-------------------------------------DEBUG-------------------------------------------------------------------------------------------------------------------
		if fastFireballs.showMeDebug then
			function print(line, text, variable,color,x,y)
				debugFont = textplus.loadFont("scripts/textplus/font/11.ini")
				if x == nil or y == nil then
					textplus.print{font=debugFont,xscale=1.5,yscale=1.5,x=20^kp*1.02,y=(6+line)*15,text=text..": "..tostring(variable),color=color}
				else
					textplus.print{font=debugFont,xscale=1.5,yscale=1.5,x=x,y=y,text=tostring(variable),color=color}
				end
			end
			--print(2,	"Pressing Run Button",			(p.keys.run or p.keys.altRun)	)
			
			--print(3,	"0x160 (WORD)",						p:mem(0x160,FIELD_WORD)			)
			--print(4,	"0x160 (BOOL)",						p:mem(0x160,FIELD_BOOL)			)
			print(5,	"Fireball Count (P"..kp..")",	playerBallCount[kp]					)
			print(6,	"Total Fireball Count",			#NPC.get({13,265,171})					)
			for kn, n in ipairs(NPC.get({13,265,171})) do
				print(nil,	nil,		"Owner: P"..(n.ai3)		,nil				,n.x-Camera.get()[kp].x-32,		n.y-Camera.get()[kp].y-12	)
				print(7+kn,		"0x126 (Owner:"..n.ai3..")",			(n.despawnTimer)					)
				print(7+kn,		"0x128 (Owner:"..n.ai3..")",			(n.despawnTimer)					)
			end
		end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
	end
end


function fastFireballs.onNPCKill(eventObj, npc, harmtype)
	for kp, p in ipairs(Player.get()) do
		if npc.ai3 == kp then
			playerBallCount[kp] = playerBallCount[kp] - 1
		end
	end
end

return fastFireballs

