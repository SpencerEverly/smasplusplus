--------------------------------------------------
--===========Example LunaLua Library============--
--    Copypaste and edit this to make your      --
--                 own library!                 --
--    Load in a level with something like:      --
--     local example = API.load("example")      --
--------------------------------------------------

-- Declare our library table
local bridge = {}

bridge.bridgetick = 0

local bridgeaftermovement = 0
local playerPos = 0

bridge.active = false
bridge.collapseHitboxX = 0
bridge.collapseHitboxY = 0
bridge.collapseHitboxWidth = 0
bridge.collapseHitboxHeight = 0
bridge.collapseHitboxDirection = -1
bridge.cameraX = 0
bridge.cameraY = 0
bridge.collapseBox = Colliders.Box(-1, -1, -1, -1)

local cameradirection = -bridge.collapseHitboxDirection


function bridge.onInitAPI()
	registerEvent(bridge, "onTick")
	registerEvent(bridge, "onDraw")
	registerEvent(bridge, "onCameraUpdate")
	-- Put stuff that should happen when the library is loaded here.
end

function bridge.onDraw()
	if bridge.active then
		Misc.pause(true)
	
		if bridge.bridgetick < 1 then
			bridge.collapseBox = Colliders.Box(bridge.collapseHitboxX, bridge.collapseHitboxY, bridge.collapseHitboxWidth, bridge.collapseHitboxHeight)
			bridge.bridgetick = 1
			
			local spawnedNPCs = Layer.get("Spawned NPCs")
			spawnedNPCs:hide(true)
			cameradirection = -bridge.collapseHitboxDirection
		end
		
		
		if bridge.collapseBox.x > camera.x and bridge.collapseBox.x < camera.x + 800 then
			bridge.collapseBox.x = bridge.collapseBox.x + (5 * bridge.collapseHitboxDirection)
		else
			bridge.bridgetick = bridge.bridgetick + 1
			if bridge.bridgetick == 30 then
				bridge.active = false
				bridgeaftermovement = bridge.cameraX
				Misc.unpause()
			end
		end
	end
end

function bridge.onCameraUpdate()
	if bridge.bridgetick >= 30 then
		bridge.bridgetick = bridge.bridgetick + 1
	end
	if bridge.active or bridge.bridgetick >= 30 and bridge.bridgetick < 50 then
		camera.x = bridge.cameraX
		camera.y = bridge.cameraY
		playerPos = player.x
	end
	
	if bridge.bridgetick >= 50 then
		camera.x = bridgeaftermovement
		bridgeaftermovement = bridgeaftermovement + (2 * cameradirection)
		local sec = Section(player.section)
		local sectionBounds = sec.boundary
		
		Misc.pause()
		
		if bridgeaftermovement <= playerPos - 388 and cameradirection == -1 then
			bridge.bridgetick = 0
		elseif bridgeaftermovement >= playerPos - 388 then
			bridge.bridgetick = 0
			Misc.unpause()
		elseif camera.x < sectionBounds.left or camera.x + 800 > sectionBounds.right then
			bridge.bridgetick = 0
			Misc.unpause()
		end
	end
	
	if player.x >= camera.x + 775 then
		player.speedX = 0
		player.x = camera.x + 775
	elseif player.x <= camera.x then
		player.speedX = 0
		player.x = camera.x
	end
end

function bridge.onTick()
	if bridge.bridgetick >= 30 then
		--Text.print("Testing", 100, 100)
	
		player.keys.jump = false
		player.keys.altJump = false
		player.keys.run = false
		player.keys.altRun = false
		player.keys.left = false
		player.keys.right = false
		player.keys.up = false
		player.keys.down = false
		player.keys.pause = true
		player.keys.dropItem = false
	end
end

return bridge