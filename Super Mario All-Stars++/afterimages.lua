-- afterimages by enjl
-- 1.0 from may 2020
local afterimages = {}

local activeAfterImages = {}

local maskShader = Shader()
maskShader:compileFromFile(nil,  Misc.resolveFile("afterimages_shader.frag"))

--[[
This library uses only the addAfterImage call and some helpers for npcs and players, and acts much like a glDraw call in every other way.
There are technically no mandatory arguments, but you might want to set stuff like...
texture, coordinates and dimensions

Convenience function (supports mario luigi peach toad link and any npc):
    afterimages.create(obj, lifetime, color, animWhilePaused, priority)
    obj = player or npc
    the rest: see below

defaults:

afterimages.addAfterImage{
	texture = nil,
	x = 0,
	y = 0,
	width = 32,
	height = 32,
	texWidth = width, -- in case texture doesn't cleanly map onto vertex coordinates
	texHeight = height,
	vertexCoords = nil, -- optional alternative way of providing position 
	textureCoords = nil, -- optional alternative to texOffsets
	texOffsetX = 0, -- 0-1 left edge along horizontal axis of spritesheet
	texOffsetY = 0, -- 0-1 bottom edge along vertical axis of spritesheet
	lifetime = 65, -- fadeout duration
	priority = -49,
	color = nil, -- optional, defaults to white
	angle = 0, -- you can rotate
	primitive = Graphics.GL_TRIANGLE_FAN,
	sceneCoords = true,
	animWhilePaused = false -- lifetime decreases while paused?

}

]]

function afterimages.addAfterImage(args)
	local e = {}
	e.texture = args.texture
	e.x = args.x or 0
	e.y = args.y or 0
	e.vertexCoords = args.vertexCoords or {
		0, 0,
		args.width, 0,
		args.width, args.height,
		0, args.height
	}
	
	e.sceneCoords = args.sceneCoords
	if e.sceneCoords == nil then
		e.sceneCoords = true
	end
	e.textureCoords = args.textureCoords 
	
	if e.textureCoords == nil then 

		local tw, th = args.texwidth or args.width, args.texheight or args.height
	
		local txW = tw / e.texture.width
		local txH = th / e.texture.height
		e.textureCoords = {
			args.texOffsetX, args.texOffsetY,
			args.texOffsetX + txW, args.texOffsetY,
			args.texOffsetX + txW, args.texOffsetY + txH,
			args.texOffsetX, args.texOffsetY + txH
		}
	end
	
	e.lifetime = args.lifetime or 65
	e.priority = args.priority or -49
	e.color = args.color or (Color.white .. 0)
	e.angle = args.angle or 0
	e.primitive = args.primitive
	e.animWhilePaused = args.animWhilePaused
	table.insert(activeAfterImages, e)
	return e
end

function afterimages.onInitAPI()
	registerEvent(afterimages, "onTickEnd")
	registerEvent(afterimages, "onDraw")
end

function afterimages.onTickEnd()
	for i=#activeAfterImages, 1, -1 do
		local v = activeAfterImages[i]
		if not v.animWhilePaused then
			v.lifetime = v.lifetime - 1
			if v.lifetime <= 0 then
				table.remove(activeAfterImages, i)
			end
		end
	end
end

local function rotateObj(v, angle)
	local s = table.deepclone(sprite)
	for k,v in ipairs(s) do
		s[k] = v:rotate(angle);
	end
	return s
end

function afterimages.onDraw()
	for i=#activeAfterImages, 1, -1 do
		local v = activeAfterImages[i]
		local vx = v.vertexCoords
		local vt = {}
		if type(vx[1]) == "number" then
			for i=1, #vx, 2 do
				table.insert(vt, v.x + vx[i])
				table.insert(vt, v.y + vx[i+1])
			end
		else
			if (v.angle ~= 0) then
				vx = rotateObj(vx, v.angle)
			end
			for i=1, #vx do
				table.insert(vt, v.x + vx[i].x)
				table.insert(vt, v.y + vx[i].y)
			end
		end
		Graphics.glDraw{
			texture = v.texture,
			vertexCoords = vt,
			textureCoords = v.textureCoords, 
			priority = v.priority,
			shader = maskShader,
			sceneCoords = v.sceneCoords,
			primitive = v.primitive or Graphics.GL_TRIANGLE_FAN,
			uniforms = {
				iCol = v.color;
				iAlpha = v.lifetime/65;
			}
		}
		if v.animWhilePaused then
			v.lifetime = v.lifetime - 1
			if v.lifetime <= 0 then
				table.remove(activeAfterImages, i)
			end
		end
	end
end

-- This should be using playerManager...
local playerNames = {"mario", "luigi", "peach", "toad", "link"}

function afterimages.create(obj, lifetime, color, animWhilePaused, priority)
	if (not Misc.isPausedByLua()) or animWhilePaused then
		if obj.__type == "Player" then
		
			local playerIdxStr = playerNames[obj.character]
			local settings = obj:getCurrentPlayerSetting()
			local pX, pY = obj:getCurrentSpriteIndex()
			local offsetX = settings:getSpriteOffsetX(pX, pY)
            local offsetY = settings:getSpriteOffsetY(pX, pY)

			local sheet = Graphics.sprites[playerIdxStr][obj.powerup].img
			local angle = 0

			local xval = obj.x + offsetX
			local yval = obj.y + offsetY

			local vt 
			local tx 

			local scale = 2

			local p = priority or -26
			afterimages.addAfterImage{
				x = xval,
				y = yval,
				texture = sheet,
				vertexCoords = vt,
				textureCoords = tx,
				priority = p,
				lifetime = lifetime or 65,
				width = 50 * scale,
				height = 50 * scale,
				angle = angle,
				texOffsetX = pX * 0.1,
				texOffsetY = pY * 0.1,
				color = color or (Color.white .. 0),
				animWhilePaused = animWhilePaused
			}
			
		elseif obj.__type == "NPC" then
			local gfxw = NPC.config[obj.id].gfxwidth
			local gfxh = NPC.config[obj.id].gfxheight
			if gfxw == 0 then gfxw = obj.width end
			if gfxh == 0 then gfxh = obj.height end
			local frames = Graphics.sprites.npc[obj.id].img.height / gfxh
			local framestyle = NPC.config[obj.id].framestyle
			local frame = obj.animationFrame
			local framesPerSection = frames
			if framestyle == 1 then
				framesPerSection = framesPerSection * 0.5
				if direction == 1 then
					frame = frame + frames
				end
				frames = frames * 2
			elseif framestyle == 2 then
				framesPerSection = framesPerSection * 0.25
				if direction == 1 then
					frame = frame + frames
				end
				frame = frame + 2 * frames
			end
			local p = priority or -46
			afterimages.addAfterImage{
				x = obj.x + 0.5 * obj.width - 0.5 * gfxw + NPC.config[obj.id].gfxoffsetx,
				y = obj.y + 0.5 * obj.height - 0.5 * gfxh + NPC.config[obj.id].gfxoffsety,
				texture = Graphics.sprites.npc[obj.id].img,
				priority = p,
				lifetime = lifetime or 65,
				width = gfxw,
				height = gfxh,
				texOffsetX = 0,
				texOffsetY = frame / frames,
				animWhilePaused = animWhilePaused,
				color = color or (Color.white .. 0)
			}
		end
	end
end

return afterimages