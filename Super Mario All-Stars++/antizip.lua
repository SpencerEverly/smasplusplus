local az = {}

az.enabled = true

local stuckTimer = 0
local stuckx
local lastPlayerX = 0
local hasPressedDown = false
local wasOnSlope = false
local unduckCollider = Colliders.Box(0,0,0,0)
local regularPlayerHeight = 0
local duckingPlayerHeight = 0
local lastCharacter = nil
local lastPowerup = nil
local lastForcedState = 0
local isDuckPowering = false
local previousY = 0
local freezeState = {
    [1] = true,
    [2] = true,
    [4] = true,
    [5] = true,
    [11] = true,
    [12] = true,
    [41] = true,
}

local function blockcheck(offset)
	local y = player.y
	local blocks = Block.getIntersecting(player.x, y + offset, player.x + player.width, y + offset + player.height)
	local goodblocks = {}
	for k,v in ipairs(blocks) do
		if (Block.SOLID_MAP[v.id] or Block.PLAYERSOLID_MAP[v.id]) and (not v.isHidden) and v:mem(0x5C, FIELD_WORD) == 0 then
			if Colliders.collide(player, v) then
				table.insert(goodblocks, v)
			end
		end
	end
	return #goodblocks > 0, goodblocks
end

local function miniBlockCheck(x1, y1, blocks)
	local collisionZone = Colliders.Box(x1, y1, player.width, player.height)

	for k,v in ipairs(blocks) do
		if (not Block.SLOPE_MAP[v.id]) and Colliders.collide(collisionZone, v) then
			return true
		end
	end
	return false
end

local function expandBlockChecks()
    if wasOnSlope ~= 0 then return false end

    local x1 = player.x - 8
    local y1 = player.y - 8
    local x2 = player.x + player.width + 8
    local y2 = player.y + player.height + 8
    local blocks = Colliders.getColliding{
        a = Colliders.Box(x1, y1, player.width + 16, player.height + 16),
        b = Block.SOLID .. Block.PLAYERSOLID,
        btype = Colliders.BLOCK,
        filter = function(other)
            if other.isHidden then return false end
            if other:mem(0x5A, FIELD_WORD) == -1 then return false end
            if other:mem(0x1C, FIELD_WORD) == -1 then return false end
            if other:mem(0x1C, FIELD_WORD) == -1 then return false end
            return true
        end
    }
    x1 = x1 - player.width
    y1 = y1 - player.height
    local dodged = false
    for i=x1, x2, 2 do
        for j=y1, y2, 2 do
            if not miniBlockCheck(i, j, blocks) then
                if dodged then
                    local xw, yh = player.x, player.y
                    local vec = vector(i-xw, j-yh)
                    if vec.sqrlength < vector(dodged.x-xw, dodged.y-yh).sqrlength then
                        dodged = vector(i,j)
                    end
                else
                    dodged = vector(i,j)
                end
            end
        end
    end
    if not dodged then
        player:kill()
        return true
    else
        if vector(dodged.x-player.x, dodged.y-player.y).length > 16 then
            player:harm()
        end
        player.x = dodged.x
        player.y = dodged.y
        isStuckAtAll = false
        return true
    end
	return false
end

local function unstuck(px)
	local isStuckAtAll, defaults = blockcheck(0)
	if not isStuckAtAll and player.deathTimer == 0 then
		stuckx = nil
		return false
	end
	return expandBlockChecks()
end

function az.onInitAPI()
    registerEvent(az, "onTick")
    registerEvent(az, "onDrawEnd")
end
function az.onDrawEnd()
    previousY = player.y
    if isDuckPowering then
        previousY = previousY - duckingPlayerHeight
    end
end

function az.onTick()
    if not az.enabled then return end
    if freezeState[player.forcedState] then
        if hasPressedDown then
            player.y = previousY + duckingPlayerHeight
            player:mem(0xD0, FIELD_DFLOAT, 14)
            hasPressedDown = true
            isDuckPowering = true
        end
        player.downKeyPressing = hasPressedDown
    end

    if player.character ~= lastCharacter or (player.powerup ~= lastPowerup and lastForcedState ~= player.forcedState) then
        local ps = player:getCurrentPlayerSetting()
        lastCharacter = player.character
        lastPowerup = player.powerup
        regularPlayerHeight = ps.hitboxHeight
        unduckCollider.width = player.width
        unduckCollider.height = ps.hitboxDuckHeight
    end

    lastForcedState = player.forcedState
    if hasPressedDown and player.forcedState == 0 then
        unduckCollider.x = player.x
        unduckCollider.y = player.y + player.height - regularPlayerHeight
        local _, _, blocks = Colliders.collideBlock(unduckCollider, Colliders.BLOCK_SOLID)
        local cancel = false
        for k,v in ipairs (blocks) do
            if not v.isHidden then
                cancel = true
                break
            end
        end
        if cancel then
            player.keys.down = true
            player:mem(0x12E, FIELD_WORD, -1)
        end
    end
    if (not Defines.cheat_shadowmario) and player.deathTimer == 0 and player.forcedState == 0 and #Colliders.getColliding{
		a = player,
		b = Block.SOLID,
		btype = Colliders.BLOCK,
		filter = function(other)
			if other.isHidden then return false end
			if other:mem(0x5A, FIELD_WORD) == -1 then return false end
			if other:mem(0x1C, FIELD_WORD) == -1 then return false end
			if other:mem(0x5C, FIELD_WORD) == -1 then return false end
			return true
		end
    } > 0 then
		if stuckx == nil then
			stuckx = lastPlayerX
		end
		stuckTimer = stuckTimer + 1
		local px = player.x
		player.x = stuckx
		if stuckTimer >= 1 then
			if not unstuck(px) then
				player.x = px
			end
		end
	else
		stuckTimer = 0
		stuckx = nil
	end
	lastPlayerX = player.x
    wasOnSlope = player:mem(0x48, FIELD_WORD)
		
    if player.forcedState == 0 then
        if isDuckPowering then
            player.y = player.y - duckingPlayerHeight
        end
        isDuckPowering = false
        hasPressedDown = player.downKeyPressing
    end
end

return az