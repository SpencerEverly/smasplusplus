-- How to use: Read the comments while having a basic understanding of code.
-- By Enjl, October 2019 - May 2020.
-- 1.3
-- Recent changes:
-- Added blacklist
-- Added whitelist
-- Fixed invisible blocks and hurt blocks being walljumpable.
-- Fixed tail spins

local aw = {}
local registeredCharacters = {}

-- Global slide speed. Can be overridden per-registration.
aw.slideSpeed = 3
-- Global spinjump setting. Can be overridden per-registration. If false, spinjump key triggers regular jump.
aw.allowSpinjump = true
-- Whether to prevent consecutive jumps off the same wall.
aw.preventLastDirection = false
-- Whether to prevent consecutive jumps off the same wall ONLY when the powerup state is one that permits flight.
aw.preventLastDirectionWhenFlying = true
-- Horizontal speed upon leaving the wall.
aw.xForce = 6
-- Frames of rising momentum after jumping off a wall.
aw.yForce = 12
-- Number of frames you need to stop holding toward the wall before the player drops off.
aw.gracePeriod = 12
-- Whether the character can walljump while holding items
aw.canHoldItem = true
-- Whether the character can perform toad's double jump when equipped with a leaf or tanooki suit. More useful in per-id registration.
aw.canDoubleJump = true
-- Whether the character's walljump is enabled. If set after initialization, it must be set through the enable/disable functions below.
aw.enabled = true

-- Wraps frame IDs into a table. Arguments correspond to powerup states. Values correspond to this: http://i.imgur.com/1dnW3g3.png
-- Example: aw.createFrameTable(6, 6, 6, 4, 6, 6, 6) - Uses frame 6 for powerup states 1-7, except for state 4 (leaf).
-- This function is used simply for clarity in the table's purpose. Defining {6, 6, 6, 4, 6, 6, 6} has the same effect.
function aw.createFrameTable(...)
    return {...}
end

local function checkOverride(a, b)
    if a == nil then
        return b
    end
    return a
end

local blockList = Block.SOLID
local whitelist = {}
local blacklist = {}

-- Registers a character ID to the walljump system.
-- The second argument is a frameTable, corresponding to the "wall slide" frames the character should use in each powerup state.
-- The third argument defines further settings overrides. Arguments are: slideSpeed, allowSpinjump, preventLastDirection, xForce, yForce, gracePeriod, canHoldItem, canDoubleJump, enabled
-- To overwrite a character's settings later on, just register them again.
function aw.registerCharacter(id, frameTable, settings)
    settings = settings or {}
    registeredCharacters[id] = {
        frames = frameTable or aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6),
        speed = checkOverride(settings.slideSpeed, aw.slideSpeed),
        spinjump = checkOverride(settings.allowSpinjump, aw.allowSpinjump),
        preventLast = checkOverride(settings.preventLastDirection, aw.preventLastDirection),
        preventLastFly = checkOverride(settings.preventLastDirectionWhenFlying, aw.preventLastDirectionWhenFlying),
        xForce = checkOverride(settings.xForce, aw.xForce),
        yForce = checkOverride(settings.yForce, aw.yForce),
        grace = checkOverride(settings.gracePeriod, aw.gracePeriod),
        item = checkOverride(settings.canHoldItem, aw.canHoldItem),
        canDoubleJump = checkOverride(settings.canDoubleJump, aw.canDoubleJump),
        enabled = checkOverride(settings.enabled, aw.enabled),
    }
end

-- Deregisters a previously registered character. If you wish to only temporarily disable a character, consider using enable/disable below.
function aw.deregisterCharacter(id)
    registeredCharacters[id] = nil
end

-- Shorthand for automatically registering the five base characters with their default settings.
function aw.registerAllPlayersDefault()
    aw.registerCharacter(CHARACTER_MARIO, aw.createFrameTable(-4, -6, -6, -6, -6, -6, -6)) -- The brothers' skid frames for the small state are in position 4.
    aw.registerCharacter(CHARACTER_LUIGI, aw.createFrameTable(-4, -6, -6, -6, -6, -6, -6))
    aw.registerCharacter(CHARACTER_PEACH, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {allowSpinjump = false, preventLastDirection = true})
    aw.registerCharacter(CHARACTER_TOAD, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {canDoubleJump = true})
    aw.registerCharacter(CHARACTER_LINK, aw.createFrameTable(-5, -5, -5, -5, -5, -5, -5), {allowSpinjump = false}) -- Looks kinda rad.
    aw.registerCharacter(CHARACTER_MEGAMAN, aw.createFrameTable(-5, -5, -5, -5, -5, -5, -5), {allowSpinjump = false})
    aw.registerCharacter(CHARACTER_WARIO, aw.createFrameTable(-4, -6, -6, -6, -6, -6, -6))
    aw.registerCharacter(CHARACTER_BOWSER, aw.createFrameTable(-4, -6, -6, -6, -6, -6, -6), {allowSpinjump = false})
    aw.registerCharacter(CHARACTER_KLONOA, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {canDoubleJump = false})
    aw.registerCharacter(CHARACTER_NINJABOMBERMAN, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {allowSpinjump = false, preventLastDirection = true})
    aw.registerCharacter(CHARACTER_ROSALINA, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {canDoubleJump = false})
    aw.registerCharacter(CHARACTER_SNAKE, aw.createFrameTable(-5, -5, -5, -5, -5, -5, -5), {allowSpinjump = false}) -- Looks kinda rad.
    aw.registerCharacter(CHARACTER_ZELDA, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {canDoubleJump = false})
    aw.registerCharacter(CHARACTER_ULTIMATERINKA, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {canDoubleJump = false})
    aw.registerCharacter(CHARACTER_UNCLEBROADSWORD, aw.createFrameTable(-6, -6, -6, -6, -6, -6, -6), {canDoubleJump = false})
    aw.registerCharacter(CHARACTER_SAMUS, aw.createFrameTable(-3, -3, -3, -3, -3, -3, -3), {canDoubleJump = false})
end

local atWall = {0, 0}
local lastDir = {0, 0}
local cantThisFrame = {false,false}

-- Manually check wall slide status from outside the code
function aw.isWallSliding(p)
    return atWall[p.idx]
end

-- Manually disable wall slide from outside the code. Disables sliding for one frame. To prevent until something happens, call continuously or disable.
function aw.preventWallSlide(p)
    cantThisFrame[p.idx] = true
end

-- Enables a character's walljump.
function aw.enable(p)
    registeredCharacters[p.character].enabled = true
end

-- Disables a character's walljump.
function aw.disable(p)
    registeredCharacters[p.character].enabled = false
end

-- Whitelists a block, making it walljumpable even if it's a lava, hurt, semisolid, nonsolid or sizable block
function aw.whitelist(id)
    if (not whitelist[id]) then
        table.insert(blockList, id)
        whitelist[id] = true
    end
end

-- Blacklists a block, making it unwalljumpable even if it would otherwise qualify
function aw.blacklist(id)
    blacklist[id] = true
end
-- If you want to change the blacklist or whitelist at runtime,
-- I recommend instead switching the ID of the block to one that carries different walljump properties.
-- Make sure to maybe also use different sprites, to ensure players know what's going on.

-- Below here is nothing of interest for those seeking exposed customizability.
-- For those seeking to alter the code, be my guest, but don't @ me.

local directionTable = {
    [-1] = function (p) return p.keys.left end,
    [1] = function (p) return p.keys.right end
}
local collider = Colliders.Box(0,0,1,0)

local function walljump(p)
    local idx = p.idx
    local cfg = registeredCharacters[p.character]
    local i = math.sign(atWall[idx])

    local dir = i
    if dir == 0 then dir = p.direction end

    if dir == lastDir[idx] and (cfg.preventLast or (cfg.preventLastFly and (p.powerup == 4 or p.powerup == 5))) then return end

    local xCoord = p.x + p.width * 0.5 + dir * (p.width * 0.5)
    
    collider.x = xCoord + (dir - 1) * 0.5
    collider.y = p.y
    collider.height = p.height * 0.75

    local b = Colliders.getColliding{
        a = collider,
        b = blockList,
        btype = Colliders.BLOCK,
        filter = function(o)
            if o.invisible or o:mem(0x5A, FIELD_BOOL) or o:mem(0x5C, FIELD_BOOL) then
                return false
            end

            if (not whitelist[o.id]) and (blacklist[o.id] or Block.LAVA_MAP[o.id] or Block.HURT_MAP[o.id]) then
                return false
            end

            return true
        end
    }
    for k,v in ipairs(b) do
        if directionTable[-dir](p) and atWall[idx] ~= 0 then --letting go of the wall
            atWall[idx] = atWall[idx] - dir
            if atWall[idx] == 0 then
                p.speedX = -dir
                return
            end
        elseif not directionTable[-dir](p) then --latching onto a wall
            atWall[idx] = math.abs(cfg.grace) * dir
            p.direction = dir
            p:mem(0x50, FIELD_WORD, 0) --spinjump
        end
        break
        if k == #b then
            atWall[idx] = 0
            if p:mem(0x164, FIELD_WORD) == -1 then
                p:mem(0x164, FIELD_WORD, 0)
            end
        end
    end
    if #b == 0 then
        atWall[idx] = 0
        if p:mem(0x164, FIELD_WORD) == -1 then
            p:mem(0x164, FIELD_WORD, 0)
        end
    end
    
    if atWall[idx] ~= 0 then --movement handling while at a wall
        p.keys.down = false
        p.keys.right = false
        p.keys.left = false
        p:mem(0x160, FIELD_WORD, 2) -- Projectile timer
        p:mem(0x164, FIELD_WORD, -1) -- Tail timer
        local absspeed = math.abs(registeredCharacters[p.character].speed)
        p.speedY = math.clamp(p.speedY, -absspeed, absspeed) -- If you somehow make the player rise in your own code... :)
        if RNG.randomInt(0, 2) == 2 then
            Animation.spawn(74, xCoord + 8 * ((dir - 1) * 0.5), p.y + 0.75 * p.height)
        end
        if p.keys.jump == KEYS_PRESSED or p.keys.altJump == KEYS_PRESSED then
            p.speedX = -math.abs(cfg.xForce) * dir
            p:mem(0x11C, FIELD_WORD, cfg.yForce)
            p:mem(0x00, FIELD_BOOL, cfg.canDoubleJump) -- Toad Jump
            p:mem(0x18, FIELD_BOOL, true) -- Peach Hover
            Animation.spawn(75, xCoord - 16 , p.y + 0.25 * p.height)
            p.direction = -dir
            lastDir[idx] = dir
            atWall[idx] = 0
            p:mem(0x164, FIELD_WORD, 0) -- Tail timer
            if p.keys.altJump == KEYS_PRESSED and cfg.spinjump then
                p:mem(0x50, FIELD_WORD, -1) -- spinjump
                SFX.play(33)
            end
            SFX.play(2)
        end
    end
end

function aw.onTick()
    if Level.winState() > 0 then return end
    for k,p in ipairs(Player.get()) do
        if registeredCharacters[p.character] and registeredCharacters[p.character].enabled then
            if p.deathTimer == 0
            and p.mount == 0
            and p.forcedState == 0
            and not cantThisFrame[p.idx]
            and p:mem(0x36, FIELD_BOOL) == false -- Underwater
            and p:isGroundTouching() == false
            and p:mem(0x0C, FIELD_BOOL) == false -- Fairy
            and p:mem(0x40,    FIELD_WORD) == 0 -- Climbing
            and p:mem(0x4A, FIELD_BOOL) == false -- Tanooki Statue
            and (registeredCharacters[p.character].item or ((not registeredCharacters[p.character].item) and p:mem(0x154, FIELD_WORD) == 0)) then
                walljump(p)
            else
                lastDir[p.idx] = 0
                atWall[p.idx] = 0
                if p:mem(0x164, FIELD_WORD) == -1 then
                    p:mem(0x164, FIELD_WORD, 0)
                end
            end
        else
            lastDir[p.idx] = 0
            atWall[p.idx] = 0
            if p:mem(0x164, FIELD_WORD) == -1 then
                p:mem(0x164, FIELD_WORD, 0)
            end
        end
        cantThisFrame[p.idx] = false
    end
end

function aw.onDraw()
    for k,p in ipairs(Player.get()) do
        if registeredCharacters[p.character] then
            if atWall[k] ~= 0 then
                p:mem(0x114, FIELD_WORD, registeredCharacters[p.character].frames[p.powerup])
            end
        end
    end
end

function aw.onInitAPI()
    registerEvent(aw, "onTick")
    registerEvent(aw, "onDraw")
end

return aw