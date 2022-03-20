local yoshis = {}
local npcManager = require 'npcManager'

yoshis.sprites = {
	yoshit = {},
	yoshib = {},
}

--Draws a sprite using mount settings
local function drawMount(self, x, y, args, width, height, frame, img, sceneCoords, p)
	local args = args or {}
	
	--Compute frame y coordinate and height, in texture space
	local fy = (frame*height)/img.height;
	local fh = height/img.height;
	--Draw the sprite
	Graphics.glDraw	{
						vertexCoords = 	{x, y, x + width, y, x + width, y + height, x, y + height},
						textureCoords = {0, fy, 1, fy, 1, fy+fh, 0, fy+fh},
						primitive = Graphics.GL_TRIANGLE_FAN,
						texture = img,
						sceneCoords = sceneCoords,
						priority = args.priority or p,
						shader = args.mountshader,
						uniforms = args.mountuniforms,
						attributes = args.mountattributes,
						color = args.mountcolor or args.color,
						target = args.target
					}
end
	
do
	local player_visible_animstates = 
	{
		[0] = true,
		[1] = true,
		[2] = true,
		[3] = true,
		[4] = true,
		[5] = true,
		[6] = true,
		[7] = true,
		[8] = false,
		[9] = true,
		[10] = false,
		[11] = true,
		[12] = true,
		[41] = true,
		[499] = true, --Mega mode transition
		[500] = true,
	}
	
	local clowncaroffsets =
	{	
		[CHARACTER_MARIO] = { [1] = 24, [2] = 63 },
		[CHARACTER_LUIGI] = { [1] = 24, [2] = 68 },
		[CHARACTER_PEACH] = { [1] = 24, [2] = 30 },
		[CHARACTER_TOAD] =  { [1] = 24, [2] = 30 },
		[CHARACTER_LINK] =  { [1] = 30, [2] = 30 }
	}
	
	local megashroom;
	
	function Player:render(args)
		if(playerManager == nil) then
			playerManager = require("playerManager");
		end
		
		--Initialise frame variables
		local tx1,ty1;
		local f = args.frame;
		local d = args.direction;
		
		--Initialise character variables
		local powerup = args.powerup or self.powerup;
		local character = args.character or self.character;
		
		local oldchar = self.character
		self.character = character
		if character ~= oldchar then
			playerManager.refreshHitbox(character)
		end
		--Initialise ini files
		local basechar = playerManager.getBaseID(character);
		local ps = PlayerSettings.get(basechar, powerup);
		
		--Initialise priority and mount priority
		local p = -25;
		local mountp = -25;
		
		local drawplayer = args.drawplayer;
		if(drawplayer == nil) then
			drawplayer = true;
		end
		
		--Initialise mount variables
		local drawmounts = args.drawmounts;
		if(drawmounts == nil) then
			drawmounts = true;
		end
		local mount = args.mount or self:mem(0x108, FIELD_WORD);
		local mounttype = args.mounttype or self:mem(0x10A, FIELD_WORD)
		
		--Get frame location and offsets
		if(f or d) then
			f = f or self:getFrame()
			d = d or player.direction
			tx1,ty1 = Player.convertFrame(f, d)
		else
			tx1,ty1 = self:getFrame(true)
			d = d or player.direction
		end
		
		if(tx1 < 0 or ty1 < 0) then
			return;
		end
		local xOffset = ps:getSpriteOffsetX(tx1, ty1);
		local yOffset = ps:getSpriteOffsetY(tx1, ty1);
		
		--Adjust offsets for mounts
		if(mount == 3) then --Yoshi
		
			yOffset = yOffset + self:mem(0x10E,FIELD_WORD);
			
		elseif(mount == 2) then --Clown car
		
			xOffset = xOffset + math.floor((math.ceil(self.width) - ps.hitboxWidth)/2);
			
			local h = clowncaroffsets[basechar][math.min(2,powerup)];
			
			--Small characters, and those based on Toad, Link or Peach, use hardcoded offsets - Mario and Luigi adjust offsets to their hitboxes
			if(powerup == 1 or basechar == CHARACTER_LINK or basechar == CHARACTER_PEACH or basechar == CHARACTER_TOAD) then
				yOffset = yOffset-h;
			else
				yOffset = yOffset-h+ps.hitboxHeight*0.5;
			end
			
		--[[elseif(mount == 1) then
			if(basechar == CHARACTER_LINK or basechar == CHARACTER_PEACH or basechar == CHARACTER_TOAD) then
				--xOffset = xOffset-0.45;
			end]]
		end
		
		--Convert frames to texture coordinates (sheets are 10x10 of 100 pixels)
		tx1 = tx1*0.1;
		ty1 = ty1*0.1;
		local tx2,ty2 = tx1+0.1,ty1+0.1;
			
		local rawx = (args.x or self.x);
		local rawy = (args.y or self.y);
			
		--Calculate render position
		local x = rawx+xOffset
		local y = rawy+yOffset;
		
		--Check visibility states
		local forcedAnimState = self.forcedState;
		local flashing = self:mem(0x142, FIELD_BOOL);
		
		--If we want to ignore visibility states, then reset them to visible values
		if(args.ignorestate) then
			forcedAnimState = 0;
			flashing = false;
		elseif(self.deathTimer > 0) then
			return;
		end
		
		--Adjust priority if we're going through a pipe
		if(forcedAnimState == 3) then
			p = -70;
			mountp = -70;
		end
		
		--Hierarchy for mount priority
		mountp = args.mountpriority or args.priority or mountp;
		
		mountp = mountp - 0.1
		p = p - 0.1
		
		--If we should render the sprite, let's DO IT
		if(player_visible_animstates[forcedAnimState] and (not flashing or self.isMega)) then
		
			--Set up scene coordinate values
			local sceneCoords = args.sceneCoords;
			if(sceneCoords == nil) then
				sceneCoords = true;
			end
			
			--Initialise render height (100 is the entire frame)
			local h = 100;
			local mountheight = h;
			
			if(mount == 1) then
				y = y+0.01
				
				--When in a boot, height is equal to height in big state unless you're toad or peach
				--When on yoshi, height is equal to height in big state if in small state, otherwise it's 60
				--Height is sometimes wrong before ducking thanks to the height field not being updated
				--[[
				if basechar == CHARACTER_TOAD or basechar == CHARACTER_PEACH then
					
					if self:mem(0x12E, FIELD_BOOL) then --is ducking
						mountheight = 30
					else
						mountheight = 54
					end
					if powerup == 1 then
						y = y+6
					end
				else
					local mountsettings =  PlayerSettings.get(basechar, 2)
					if self:mem(0x12E, FIELD_BOOL) then --is ducking
						mountheight = mountsettings.hitboxDuckHeight
					else
						mountheight = mountsettings.hitboxHeight
					end
				end]]
				if basechar == CHARACTER_TOAD or basechar == CHARACTER_PEACH then
					if powerup == 1 then
						y = y+6
					end
				end
				mountheight = self.height
			end
			
			--If we should draw mounts, let's try
			if(drawmounts) then
			
				--Get render height if we're in a boot (we only want the head of the character)
				if(mount == 1) then
					h = mountheight-26-yOffset --self.height-26-yOffset --height in a boot is the same as "height while big"
					
					--GDI redigit why is your code so weird
					if(basechar == CHARACTER_MARIO or basechar == CHARACTER_LUIGI or basechar == CHARACTER_TOAD) then
						h = h-self:mem(0x10E, FIELD_WORD);
					else
						h = h-2;
					end
					
					ty2 = ty1+(h/1000);
				end
				
				--If we're in a yoshi, render that first (since it's behind the player)
				if(mount == 3) then --YOSHO
				
					--Ensure mount type is valid
					if(mounttype < 1) then
						mounttype = 1;
					end
					
					--Tongue
					   --  Tongue offset > 0	      or   	  Head offset is correct for one of the "using tongue" frames		   and      	   Head frame is one of the "using tongue" frames
					if(self:mem(0xB4, FIELD_WORD) > 0 or ((self:mem(0x6E, FIELD_WORD) == 28 or  self:mem(0x6E, FIELD_WORD) == -36) and (self:mem(0x72, FIELD_WORD) == 9 or self:mem(0x72, FIELD_WORD) == 4))) then

						local tw = self:mem(0xB4, FIELD_WORD)+2;
						local tx;
						if(d == -1) then
							tx = self:mem(0x80, FIELD_DFLOAT)+16;
						else
							tx = rawx + self:mem(0x6E,FIELD_WORD) + 16;
						end
						local ty = self:mem(0x88, FIELD_DFLOAT);
						
						--Draw tongue body
						Graphics.glDraw {
											vertexCoords = {tx, ty, tx+tw, ty, tx+tw, ty+16, tx, ty+16},
											textureCoords = {0,0,tw/416,0,tw/416,1,0,1},
											primitive = Graphics.GL_TRIANGLE_FAN,
											sceneCoords = sceneCoords,
											texture = Graphics.sprites.hardcoded["21-2"].img,
											priority = mountp,
											shader = args.mountshader,
											uniforms = args.mountuniforms,
											attributes = args.mountattributes,
											color = args.mountcolor or args.color,
											target = args.target
										}
						
						--Draw tongue head
						drawMount(self, self:mem(0x80, FIELD_DFLOAT), self:mem(0x88, FIELD_DFLOAT), args, 16, 16, math.max(0,-d), Graphics.sprites.hardcoded["21-1"].img, sceneCoords, mountp);
					end
					
					local bodyframe = self:mem(0x7A, FIELD_WORD)
					local headframe = self:mem(0x72, FIELD_WORD)
					local headoffset = self:mem(0x6E,FIELD_WORD)
					
					--Flip the direction of yoshi if we need to
					if d == 1 and bodyframe < 7 then
						bodyframe = bodyframe + 7
					elseif d == -1 and bodyframe >= 7 then
						bodyframe = bodyframe - 7
					end
					
					if d == 1 and headframe < 5 then
						headframe = headframe + 5
						headoffset = -headoffset - 8
					elseif d == -1 and headframe >= 5 then
						headframe = headframe - 5
						headoffset = -headoffset - 8
					end
					
					if not Graphics.sprites.yoshib[mounttype].img then
						local body = Graphics.sprites.yoshib
						rawset(body, mounttype, {img = Graphics.loadImageResolved('yoshib-' .. mounttype .. '.png')})
			
						local head = Graphics.sprites.yoshit
						rawset(head, mounttype, {img = Graphics.loadImageResolved('yoshit-' .. mounttype .. '.png')})
					end
					
					--Draw Yoshi body
					drawMount(self, rawx - 4, rawy + self:mem(0x78, FIELD_WORD), args, 32, 32, bodyframe, Graphics.sprites.yoshib[mounttype].img, sceneCoords, mountp);
					--Draw Yoshi head
					drawMount(self, rawx + headoffset, rawy + self:mem(0x70,FIELD_WORD), args, 32, 32, headframe, Graphics.sprites.yoshit[mounttype].img, sceneCoords, mountp);
				end
			end
			
			--If we're ducking in a boot (clap your hands) - don't render the character
			if((mount ~= 1 or not self:mem(0x12E, FIELD_BOOL)) and drawplayer) then
			
				if(self.isMega) then
					if(megashroom == nil) then
						megashroom = require("NPCs/ai/megashroom");
					end
					megashroom.drawPlayer(self, sceneCoords, args.priority or p, args.shader, args.uniforms, args.attributes, args.color, args.target);
				else	
					--Draw the character
					Graphics.glDraw	{	
										vertexCoords = 	{x, y, x + 100, y, x + 100, y + h, x, y + h},
										textureCoords = {tx1, ty1, tx2, ty1, tx2, ty2, tx1, ty2},
										primitive = Graphics.GL_TRIANGLE_FAN,
										texture = args.texture or Graphics.sprites[playerManager.getName(character)][powerup].img,
										sceneCoords = sceneCoords,
										priority = args.priority or p,
										shader = args.shader,
										uniforms = args.uniforms,
										attributes = args.attributes,
										color = args.color or Color.white,
										target = args.target
									}
				end
			end
				
			--If we should draw mounts, try to
			if(drawmounts) then			
					
				local mountframe = self:mem(0x110, FIELD_WORD)
			
				if(mount == 1) then --We're in a boot
				
					--Ensure mount type is valid
					if(mounttype > 3 or mounttype < 1) then
						mounttype = 1;
					end
					
					--Flip the direction of the mount if we need to
					if d == 1 and mountframe < 2 then
						mountframe = mountframe + 2
					elseif d == -1 and mountframe >= 2 then
						mountframe = mountframe - 2
					end
					
					--Draw the boot
					drawMount(self, rawx + ps.hitboxWidth*0.5 - 16, rawy + mountheight--[[self.height]]-30, args, 32, 32, mountframe, Graphics.sprites.hardcoded["25-"..mounttype].img, sceneCoords, mountp);
					
				elseif(mount == 2) then --We're in a clown car
				
					--Flip the direction of the mount if we need to
					if d == 1 and mountframe < 4 then
						mountframe = mountframe + 4
					elseif d == -1 and mountframe >= 4 then
						mountframe = mountframe - 4
					end
					
					--Draw the clown car
					drawMount(self, rawx, rawy, args, 128, 128, mountframe, Graphics.sprites.hardcoded["26-2"].img, sceneCoords, mountp);
					
				end
			end
		end
		
		self.character = oldchar
		if character ~= oldchar then
			playerManager.refreshHitbox(oldchar)
		end
	end
end

yoshis.allowedChars = {
	[CHARACTER_MARIO] = true,
	[CHARACTER_LUIGI] = true,
}

local idList  = {}
local colors = {}

local defaultSettings = {
	nohurt = true,
	jumphurt = true,
	noiceball = true,
	noyoshi = true,
	
	gfxwidth = 72,
	gfxheight = 56,
}

function yoshis.registerColor(t)
	colors[t.id] = t
	colors[t.id].npcId = colors[t.id].npcId or 95
	
	if t.name then
		_G['YOSHICOLOR_' .. t.name] = t.id
	end
end

function yoshis.register(config)
	idList[config.id] = config.color
	
	local config = table.join(config, defaultSettings)
	npcManager.setNpcSettings(config)
	
	npcManager.registerHarmTypes(config.id, {HARM_TYPE_LAVA}, {
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5}
	})
	
	npcManager.registerEvent(config.id, yoshis, 'onTickEndNPC')
	npcManager.registerEvent(config.id, yoshis, 'onCameraDrawNPC')
end

local COLLISION_SIDE_TOP = 1

local function side(Loc1, Loc2, leniencyForTop)
    leniencyForTop = leniencyForTop or 0
    
	local right = (Loc1.x + Loc1.width) - Loc2.x - Loc2.speedX
	local left = (Loc2.x + Loc2.width) - Loc1.x - Loc1.speedX
	local bottom = (Loc1.y + Loc1.height) - Loc2.y - Loc2.speedY
	local top = (Loc2.y + Loc2.height) - Loc1.y - Loc1.speedY
	
	if right < left and right < top and right < bottom then
		return COLLISION_SIDE_RIGHT
	elseif left < top and left < bottom then
		return COLLISION_SIDE_LEFT
	elseif top < bottom then
		return COLLISION_SIDE_TOP
	else
		return COLLISION_SIDE_BOTTOM
	end
end

function yoshis.onTickEndNPC(v)
	local data = v.data._basegame

	v.animationFrame = -1
	
	if v.collidesBlockBottom and v.ai1 == 0 then
		v.speedY = -2
		v.y = v.y - 1
	end
	
	if v.ai1 ~= 0 then
		v.speedX = 3 * v.direction
		
		local turnaround = v:mem(0x120, FIELD_BOOL)
		
		if turnaround and ((v.direction == -1 and not v.collidesBlockLeft) or (v.direction == 1 and not v.collidesBlockRight)) then
			v.speedX = -v.speedX
		end
	end
	
	if not data.init then
		data.head_frame = 0
		data.body_frame = 6
		
		data.head_frametimer = 0
		data.body_frametimer = 0
		
		data.init = true
	end
	
	for k,p in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
		if p.speedY > 0 and p:mem(0xBC, FIELD_WORD) <= 0 and yoshis.allowedChars[p.character] and p.mount == 0 and not p.isMega then
			local s = side(v, p)
			
			if s == 1 then
				SFX.play(48)
				
				v:kill(9)
				p.mountColor = idList[v.id]
				p.mount = MOUNT_YOSHI
				p:mem(0x80, FIELD_DFLOAT, 0)
				p:mem(0x88, FIELD_DFLOAT, 0)
				p:mem(0xB0, FIELD_DFLOAT, 0)
				p:mem(0xB4, FIELD_DFLOAT, 0)
			end
		end
	end
end

function yoshis.onCameraDrawNPC(v)
	if v.despawnTimer <= 0 then return end
	
	local data = v.data._basegame
	if not data.init then return end
	
	local y = (v.ai1 == 0 and 10) or 0
	
	local body_y = 0
	local head_y = 0
	
	--animation
	if v.ai1 == 0 then
		data.head_frametimer = data.head_frametimer + 1
		
		if data.head_frametimer == 50 then
			data.head_frame = 3
		elseif data.head_frametimer >= 70 then
			data.head_frame = 0
			data.head_frametimer = 0
		end
	else
		-- head
		data.head_frametimer = data.head_frametimer + 1
		
		if data.head_frametimer == 10 then
			data.head_frame = 2
		elseif data.head_frametimer >= 30 then
			data.head_frame = 0
			data.head_frametimer = 0
		end
		
		-- body
		data.body_frametimer = data.body_frametimer + 1
		
		if data.body_frametimer == 2 then
			data.body_frame = 1
			body_y = body_y + 1
			head_y = head_y + 2
		elseif data.body_frametimer == 4 then
			data.body_frame = 2
			body_y = body_y + 2
			head_y = head_y + 4
		elseif data.body_frametimer	== 6 then
			data.body_frame = 1
			body_y = body_y + 1
			head_y = head_y + 2
		elseif data.body_frametimer == 8 then
			data.body_frame = 0
			data.body_frametimer = 0
		end
	end
	
	--render
	
	if not Graphics.sprites.yoshib[idList[v.id]].img then
		local body = Graphics.sprites.yoshib
		rawset(body, idList[v.id], {img = Graphics.loadImageResolved('yoshib-' .. idList[v.id] .. '.png')})

		local head = Graphics.sprites.yoshit
		rawset(head, idList[v.id], {img = Graphics.loadImageResolved('yoshit-' .. idList[v.id] .. '.png')})
	end
	
	local head = Graphics.sprites.yoshit[idList[v.id]].img
	local body = Graphics.sprites.yoshib[idList[v.id]].img
	
	local head_h = head.height / 10
	local body_h = body.height / 14
	
	local body_f = (v.direction == 1 and data.body_frame + 7) or data.body_frame
	local head_f = (v.direction == 1 and data.head_frame + 5) or data.head_frame
	
	local head_x = ((head.width / 2) + 4) * v.direction
	
	Graphics.drawImageToSceneWP(head, v.x + head_x, v.y - head_h + y + head_y, 0, head_h * head_f, head.width, head_h, -45)
	Graphics.drawImageToSceneWP(body, v.x, v.y + y + body_y, 0, body_h * body_f, body.width, body_h, -45)
end

local function method(col, name, ...)
	if col[name] then
		col[name](...)
	end
end

local function defineMethod(name)
	return function()
		for k,v in ipairs(Player.get()) do
			if v.mount == MOUNT_YOSHI and colors[v.mountColor] then
				method(colors[v.mountColor], name, v)
			end
		end
	end
end

yoshis.onTick = defineMethod 'onTick'
yoshis.onTickEnd = defineMethod 'onTickEnd'

local function unmount(v)
	v:mem(0x60, FIELD_BOOL, false)
	v:mem(0x5C, FIELD_BOOL, false)
	v:mem(0x5E, FIELD_BOOL, false)
	v:mem(0x64, FIELD_BOOL, false)
	v:mem(0x66, FIELD_BOOL, false)
	v:mem(0x68, FIELD_BOOL, false)
	v:mem(0x68, FIELD_BOOL, false)
	v:mem(0xB6, FIELD_BOOL, false)
	
	v:mem(0x6E, FIELD_WORD, 0)
	v:mem(0x70, FIELD_WORD, 0)
	v:mem(0x72, FIELD_WORD, 0)
	v:mem(0x7C, FIELD_WORD, 0)
	v:mem(0x7A, FIELD_WORD, 0)
	v:mem(0x74, FIELD_WORD, 0)

	v:mem(0x10C, FIELD_WORD, 0)
end

function yoshis.onInputUpdate()
	for k,v in ipairs(Player.get()) do
		if v.mount == MOUNT_YOSHI and colors[v.mountColor] then
			if v.keys.altJump == KEYS_PRESSED then
				unmount(v)
				
				local n = NPC.spawn(colors[v.mountColor].npcId, (v.x + v.width / 2) - 16, v.y + v.height - 32)
				n.despawnTimer = 100
				n.speedY = 0.5
				n.direction = v.direction
			end
			
			method(colors[v.mountColor], 'onInputUpdate', v)
		end
	end
end

function yoshis.onPlayerHarm(_, v)
	if v.mount == MOUNT_YOSHI and colors[v.mountColor] then
		local n = NPC.spawn(colors[v.mountColor].npcId, (v.x + v.width / 2) - 16, v.y + v.height - 32)
		n.despawnTimer = 100
		n.speedY = 0.5
		n.direction = v.direction
		n.ai1 = 1
	
		unmount(v)
		
		v:mem(0x11C, FIELD_WORD, 0)	
		v.speedX = 0
		
		if v.speedY > Defines.player_grav then
			v.speedY = Defines.player_grav
		end
		
		v:mem(0xBC, FIELD_WORD, 100)
	end
end

function yoshis.onCameraDraw()
	for k,v in ipairs(Player.get()) do
		if v.mount == MOUNT_YOSHI and colors[v.mountColor] and colors[v.mountColor].id > 10 then
			v:render{
				drawplayer = false,
			}
		end
	end
end

function yoshis.onInitAPI()
	registerEvent(yoshis, 'onPlayerHarm')
	registerEvent(yoshis, 'onInputUpdate')
	registerEvent(yoshis, 'onTick')
	registerEvent(yoshis, 'onTickEnd')
	registerEvent(yoshis, 'onCameraDraw')
end

return yoshis