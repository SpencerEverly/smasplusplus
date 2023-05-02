--- Clear pipes.
-- @module clearpipe
local clearpipe = {}

local pm = require("playermanager")
local redirector = require("redirector")
local megashroom = require("npcs/ai/megashroom")

local cpn

local function loadcpn()
    cpn = require("npcs/ai/clearpipeNPC")
end

function clearpipe.registerNPC(id)
    if cpn == nil then
        loadcpn()
    end
    table.insert(cpn.ids, id)
    cpn.ids_map[id] = true
end

function clearpipe.unregisterNPC(id)
    if cpn == nil then
        loadcpn()
    end
    for k,v in ipairs(cpn.ids) do
        if v == id then
            table.remove(cpn.ids, k)
            break
        end
    end
    cpn.ids_map[id] = false
end

--Per-player variables
local inPipe = {all = 0}
local vPipe = {}
local keys = {}

setmetatable(inPipe, {
    __len = function()
        return inPipe.all
    end
})

--Enums for basic directions
local UP, DOWN, LEFT, RIGHT = 1, 2, 3, 4

clearpipe.speed = 6
clearpipe.exitBoost = 1
clearpipe.cannonBoost = 2
clearpipe.sfx = 17
clearpipe.cannonSFX = 22
clearpipe.priority = -22.5

--Enums for pipe types
local const_names = {
    JUNC = {"UP", "DOWN", "LEFT", "RIGHT", "CROSS", "UP_FULL", "DOWN_FULL", "LEFT_FULL", "RIGHT_FULL"},
    END = {"HORZ", "VERT"},
    STRAIGHT = {"HORZ", "VERT"},
    ELB = {[-1] = "MINUS", [1] = "PLUS"}
}
for prefix, suffixes in pairs(const_names) do
    clearpipe[prefix] = {}
    for index, suffix in pairs(suffixes) do
        clearpipe[prefix][suffix] = index
    end
end

do --ID tables
    --ELBs are notated by the two directions they are open to
    --JUNCs are notated by the direction in which they branch off
    --STRAIGHTs are notated by the axis along which they allow travel
    --Half-straight STRAIGHTs are notated by the direction in which they allow entry but not passage
    --ENDs are notated like STRAIGHTS
    --GATEs are notated by the direction in which you CAN pass through them
    --CANNONs are notated like ENDS
    local ID = {
        END = {V = 701, H = 702},
        STRAIGHT = {V = 703, H = 704, U = 714, D = 715, R = 716, L = 717},
        ELB = {DR = 705, DL = 706, UR = 707, UL = 708},
        JUNC = {U = 709, D = 710, L = 711, R = 712, X = 713, UF = 1102, DF = 1103, LF = 1104, RF = 1105},
        GATE = {U = 718, D = 719, L = 720, R = 721},
        CANNON = {V = 722, H = 723}
    }
    --Truth tables for a few pipe types that are used multiple times.
    local VERT = {true,  true,  false, false}
    local HORZ = {false, false, true,  true}
    local JUNC = {true,  true,  true,  true}
    --Main ID table
    clearpipe.PIPES = {
        --The values here are whether the player should be allowed to enter the pipe while traveling {up,down,left,right}
        --[[
        [ID.ELB.DL] = {true,  false, false, true},
        [ID.ELB.DR] = {true,  false, true,  false},
        [ID.ELB.UL] = {false, true,  false, true},
        [ID.ELB.UR] = {false, true,  true,  false},
        [ID.END.V] = VERT,
        [ID.END.H] = HORZ,
        [ID.STRAIGHT.V] = VERT,
        [ID.STRAIGHT.H] = HORZ,
        [ID.GATE.R] = {false, false, false, true},
        [ID.GATE.L] = {false, false, true,  false},
        [ID.GATE.D] = {false, true,  false, false},
        [ID.GATE.U] = {true,  false, false, false},
        [ID.STRAIGHT.U] = {true,  false, true,  true},
        [ID.STRAIGHT.R] = {true,  true,  false, true},
        [ID.STRAIGHT.D] = {false, true,  true,  true},
        [ID.STRAIGHT.L] = {true,  true,  true,  false},
        [ID.JUNC.D] = JUNC,
        [ID.JUNC.U] = JUNC,
        [ID.JUNC.L] = JUNC,
        [ID.JUNC.R] = JUNC,
        [ID.JUNC.X] = JUNC,
        [ID.CANNON.V] = VERT,
        [ID.CANNON.H] = HORZ,
        [ID.JUNC.UF] = {false, true,  true,  true},
        [ID.JUNC.DF] = {true,  false, true,  true},
        [ID.JUNC.LF] = {true,  true,  false, true},
        [ID.JUNC.RF] = {true,  true,  true,  false}
        ]]
    }
    --Other ID tables
    --a MINUS elbow opens down/right or up/left. a PLUS elbow opens up/right or down/left.
    --Surprisingly, the code doesn't need to distinguish any more than that, at least not for sane pipe placements.
    clearpipe.ELBS = {
        --[[[ID.ELB.DR] = clearpipe.ELB.MINUS,
        [ID.ELB.DL] = clearpipe.ELB.PLUS,
        [ID.ELB.UL] = clearpipe.ELB.MINUS,
        [ID.ELB.UR] = clearpipe.ELB.PLUS]]
    }
    clearpipe.ENDS = {
        --[[[ID.END.V] = clearpipe.END.VERT,
        [ID.END.H] = clearpipe.END.HORZ]]
    }
    clearpipe.JUNCS = {
        --[[[ID.JUNC.U] = clearpipe.JUNC.UP,
        [ID.JUNC.D] = clearpipe.JUNC.DOWN,
        [ID.JUNC.L] = clearpipe.JUNC.LEFT,
        [ID.JUNC.R] = clearpipe.JUNC.RIGHT,
        [ID.JUNC.X] = clearpipe.JUNC.CROSS,
        [ID.JUNC.UF] = clearpipe.JUNC.UP_FULL,
        [ID.JUNC.DF] = clearpipe.JUNC.DOWN_FULL,
        [ID.JUNC.LF] = clearpipe.JUNC.LEFT_FULL,
        [ID.JUNC.RF] = clearpipe.JUNC.RIGHT_FULL,]]
    }
    --Not actually used at the time of writing, just here for consistency and registerPipe
    clearpipe.STRAIGHTS = {
        --[[[ID.STRAIGHT.V] = clearpipe.STRAIGHT.VERT,
        [ID.STRAIGHT.H] = clearpipe.STRAIGHT.HORZ,
        [ID.STRAIGHT.U] = clearpipe.STRAIGHT.HORZ,
        [ID.STRAIGHT.R] = clearpipe.STRAIGHT.VERT,
        [ID.STRAIGHT.D] = clearpipe.STRAIGHT.HORZ,
        [ID.STRAIGHT.L] = clearpipe.STRAIGHT.VERT,
        [ID.GATE.R] = clearpipe.STRAIGHT.HORZ,
        [ID.GATE.L] = clearpipe.STRAIGHT.HORZ,
        [ID.GATE.D] = clearpipe.STRAIGHT.VERT,
        [ID.GATE.U] = clearpipe.STRAIGHT.VERT,
        [ID.CANNON.H] = clearpipe.STRAIGHT.HORZ,
        [ID.CANNON.V] = clearpipe.STRAIGHT.VERT]]
    }
    clearpipe.CANNONS = {
        --[[[ID.CANNON.H] = true,
        [ID.CANNON.V] = true]]
    }
    -- Redirector BGOs
    clearpipe.REDIRECTS = {
        [redirector.UP] = UP,
        [redirector.DOWN] = DOWN,
        [redirector.LEFT] = LEFT,
        [redirector.RIGHT] = RIGHT
    }
end

do --Other tables
    --Cross junctions should have their center, along both axes, lined up with the pipe's center.
    --Other junctions should only be half a pipe along the axis they're branching off of, so a junction shaped like a ⊥ should be 64 wide and 32 tall.
    local CENTER = {x = .5, y = .5}
    clearpipe.JUNC_OFFSETS = {
        [clearpipe.JUNC.UP]         = {x = 0.5, y = 1.0},
        [clearpipe.JUNC.DOWN]       = {x = 0.5, y = 0.0},
        [clearpipe.JUNC.LEFT]       = {x = 1.0, y = 0.5},
        [clearpipe.JUNC.RIGHT]      = {x = 0.0, y = 0.5},
        [clearpipe.JUNC.CROSS]      = CENTER,
        [clearpipe.JUNC.UP_FULL]    = CENTER,
        [clearpipe.JUNC.DOWN_FULL]  = CENTER,
        [clearpipe.JUNC.LEFT_FULL]  = CENTER,
        [clearpipe.JUNC.RIGHT_FULL] = CENTER
    }
    --Map of junction types to allowed exit directions
    clearpipe.JUNC_FORKS = {
        [clearpipe.JUNC.UP]         = {true,  false, true,  true},
        [clearpipe.JUNC.DOWN]       = {false, true,  true,  true},
        [clearpipe.JUNC.LEFT]       = {true,  true,  true,  false},
        [clearpipe.JUNC.RIGHT]      = {true,  true,  false, true},
        [clearpipe.JUNC.CROSS]      = {true,  true,  true,  true},
        [clearpipe.JUNC.UP_FULL]    = {true,  false, true,  true},
        [clearpipe.JUNC.DOWN_FULL]  = {false, true,  true,  true},
        [clearpipe.JUNC.LEFT_FULL]  = {true,  true,  true,  false},
        [clearpipe.JUNC.RIGHT_FULL] = {true,  true,  false, true}
    }
    --Map of direction enums to xy-based vectors
    clearpipe.DIR_VECTORS = {
        [UP]    = {x =  0, y = -1},
        [DOWN]  = {x =  0, y =  1},
        [LEFT]  = {x = -1, y =  0},
        [RIGHT] = {x =  1, y =  0}
    }
    clearpipe.PIPES_LIST = table.unmap(clearpipe.PIPES)
    clearpipe.ENDS_LIST = table.unmap(clearpipe.ENDS)
end

local filters = {}
do --Set up filter block table
    local charTbl = pm.getCharacters()
    for id, props in pairs(charTbl) do
        filters[id] = props.filterBlock
    end
end

--Gets all blocks colliding with obj, so long as they are relevant to clearpipe.
--Ignores semisolid blocks when p is not above them
--Can also ignore all clear pipes that wouldn't obstruct the player's passage
local function getCollidingBlocks(obj, i, p, dir, excludeValidPipes)
    local blocks = Block.SOLID .. Block.PLAYERSOLID .. Block.PLAYER
    if dir == DOWN then
        blocks = blocks .. Block.SEMISOLID
    end
    local y = p.y + p.height
    if inPipe[i] then
        y = y - clearpipe.speed
    end
    return Colliders.getColliding{
        a = obj,
        b = blocks,
        btype = Colliders.BLOCK,
        filter = function(block)
            if block.isHidden then
                return false
            elseif excludeValidPipes and clearpipe.PIPES[block.id] and clearpipe.PIPES[block.id][dir] then
                return false
            elseif filters[p.character] == block.id then
                return false
            elseif dir == DOWN and Block.SEMISOLID_MAP[block.id] and y > block.y then
                return false
            elseif Block.LAVA_MAP[block.id] then
                return false
            end
            return true
        end
    }
end

--Returns a point representing the center of any object with x, y, width, and height fields
local function getMiddle(obj)
    return {x = obj.x + obj.width / 2, y = obj.y + obj.height / 2}
end

--Returns an estimate of a player's previous hitbox, based on their current velocity.
function projectLastPos(i, p)
    local box = Colliders.getHitbox(p)
    box.x = box.x - vPipe[i].x * clearpipe.speed
    box.y = box.y - vPipe[i].y * clearpipe.speed
    return box
end

--Returns an estimate of a player's next hitbox, based on their current velocity.
function projectNextPos(i, p)
    local box = Colliders.getHitbox(p)
    box.x = box.x + vPipe[i].x * clearpipe.speed
    box.y = box.y + vPipe[i].y * clearpipe.speed
    return box
end

--Attempts to enter any nearby valid pipe entrances, given a direction of entry and a player.
local function enterPipe(dir, i, p)
    -- pbox is a box used to find pipes, it's the player's hitbox but extended 1 pixel in the direction being pressed.
    -- This code could really use some woop magic.

    local pBox = Colliders.getHitbox(p)
    local endtype

    if dir <= DOWN then
        endtype = clearpipe.END.VERT
        pBox.height = pBox.height + 1
        if dir == UP then
            pBox.y = pBox.y - 1
        end
    else
        endtype = clearpipe.END.HORZ
        pBox.width = pBox.width + 1
        if dir == LEFT then
            pBox.x = pBox.x - 1
        end
    end
    local blocks =
        Colliders.getColliding{
        a = pBox,
        b = clearpipe.ENDS_LIST,
        btype = Colliders.BLOCK
    }
    for _,v in ipairs(blocks) do
        if clearpipe.ENDS[v.id] == endtype and clearpipe.PIPES[v.id][dir] and #getCollidingBlocks(v, i, p, dir, true) == 0 then
            local warpOffset = {}
            if dir <= DOWN then
                warpOffset.x = v.width / 2 - 16
                if dir == UP then
                    warpOffset.y = v.height
                else
                    warpOffset.y = -32
                end
            else
                warpOffset.y = v.height / 2 - 16
                if dir == LEFT then
                    warpOffset.x = v.width
                else
                    warpOffset.x = -32
                end
            end
            local warpBox = Colliders.Box(v.x + warpOffset.x, v.y + warpOffset.y, 32, 32)
            if Colliders.collide(warpBox, p) then
                local ps = PlayerSettings.get(pm.getCharacters()[p.character].base, p.powerup)
                p.height = ps.hitboxHeight
                --p.height = p:getCurrentPlayerSetting().hitboxHeight
                p.IsAFairy = 0
                p.InDuckingPosition = 0
                p.downKeyPressing = false

                local pOffset = {}
                if dir <= DOWN then
                    pOffset.x = v.width / 2 - p.width / 2
                    if dir == UP then
                        pOffset.y = v.height
                    else
                        pOffset.y = -p.height
                    end
                else
                    pOffset.y = v.height / 2 - p.height / 2
                    if dir == LEFT then
                        pOffset.x = v.width
                    else
                        pOffset.x = -p.width
                    end
                end

                p.x = v.x + pOffset.x
                p.y = v.y + pOffset.y
                vPipe[i] = vector.v2(clearpipe.DIR_VECTORS[dir].x, clearpipe.DIR_VECTORS[dir].y)
                inPipe[i] = true
                inPipe.all = #inPipe + 1
                SFX.play(clearpipe.sfx)
                p.UpwardJumpingForce = 0
                p.forcedState = 7
                p.forcedTimer = 1

                break
            end
        end
    end
end

--Turns the player based on the elbow through which the turn is being taken
local function turnElbow(pipe, i, p)
    local elbFactor = clearpipe.ELBS[pipe.id]
    vPipe[i].x, vPipe[i].y = vPipe[i].y * elbFactor, vPipe[i].x * elbFactor --multiple assignment is cool
    p.x = pipe.x + pipe.width / 2 - p.width / 2
    p.y = pipe.y + pipe.height / 2 - p.height / 2
end

--Gets a player's direction based on their idx
local function getDirection(i)
    if vPipe[i].y < 0 then
        return UP
    elseif vPipe[i].y > 0 then
        return DOWN
    elseif vPipe[i].x < 0 then
        return LEFT
    elseif vPipe[i].x > 0 then
        return RIGHT
    end
end

-- Turns the player as appropriate through a provided junction
local function turnJunction(pipe, i, p)
    local dir = getDirection(i)
    local forks = clearpipe.JUNC_FORKS[clearpipe.JUNCS[pipe.id]]
    local offsets = clearpipe.JUNC_OFFSETS[clearpipe.JUNCS[pipe.id]]

    -- Represent the direction the player's presing as 1, 2, 3, or 4.
    -- Ignore keys that are opposite to dir.
    local keyTable = {keys[i].up, keys[i].down, keys[i].left, keys[i].right}
    local key = 0
    for k, v in ipairs(keyTable) do
        -- if the key's pressed and it's not backwards then
        if v and (k + k % 2 ~= dir + dir % 2 or k == dir) and forks[k] then
            key = k
        end
    end

    -- If there's no valid player input, look for reasons to override.
    if key == 0 then
        -- First, check for redirector BGOs with a valid direction.
        for _,bgo in ipairs(BGO.getIntersecting(pipe.x, pipe.y, pipe.x + pipe.width, pipe.y + pipe.height)) do
            local re_dir = clearpipe.REDIRECTS[bgo.id]
            if re_dir ~= nil and re_dir + re_dir % 2 ~= dir + dir % 2 and forks[re_dir] then
                key = re_dir
                break
            end
        end

        -- If the current bearing is invalid, find the first allowed+valid direction in `forks`.
        if key == 0 and not forks[dir] then
            for re_dir, v in ipairs(forks) do
                if v and re_dir + re_dir % 2 ~= dir + dir % 2 then
                    key = re_dir
                    break
                end
            end
        end
    end

    if key > 0 and forks[key] then
        vPipe[i].x = clearpipe.DIR_VECTORS[key].x
        vPipe[i].y = clearpipe.DIR_VECTORS[key].y

        p.x = pipe.x + pipe.width * offsets.x - p.width / 2
        p.y = pipe.y + pipe.height * offsets.y - p.height / 2
    end
end

--Returns whether a player is traveling into another object.
--In other words:
--If the player's center is approaching the object's center, return true
local function isEntering(pipe, i, p)
    return (p.x < pipe.x and vPipe[i].x > 0) or
           (p.y < pipe.y and vPipe[i].y > 0) or
           (p.x + p.width  > pipe.x + pipe.width  and vPipe[i].x < 0) or
           (p.y + p.height > pipe.y + pipe.height and vPipe[i].y < 0)
end

--Returns which frame a player should be displalyed as having, based on the state of their movement through pipes.
--2.0b3's characters and costumes make this a nightmare. Help.
local function getSprite(i, p)
    if vPipe[i].y ~= 0 then
        if p.character == CHARACTER_LINK then
            if vPipe[i].y > 0 then
                return 9
            elseif vPipe[i].y < 0 then
                return 10
            end
        else
            return 15
        end
    elseif vPipe[i].x then
        if p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI then
            if p.powerup ~= PLAYER_SMALL then
                return 44
            else
                return 42
            end
        elseif p.character == CHARACTER_LINK then
            return 8
        else
            return 2
        end
    end
end

--Allows the player to maintain their current speed after exiting a cannon, even if holding run.
--Big hack.
local function cor_goFast(p)
    local origMax = Defines.player_runspeed
    Defines.player_runspeed = clearpipe.speed * clearpipe.cannonBoost * clearpipe.exitBoost
    repeat
        Defines.player_runspeed = math.min(Defines.player_runspeed, math.abs(p.speedX))
        Routine.skip()
    until Defines.player_runspeed <= origMax
    Defines.player_runspeed = origMax
end

--Does whatever visual effect a clear pipe cannon should do.
function clearpipe.cannonEffect(obj)
    local a = Animation.spawn(10, obj.x + obj.width / 2, obj.y + obj.height / 2)
    a.x = a.x - a.width / 2
    SFX.play(clearpipe.cannonSFX)
    a.y = a.y - a.height / 2
end

function clearpipe.onInputUpdate()
    --Basically just store whatever the player's really pressing because some other 2.0 stuff overrides it
    --Used in onTick and turnJunction
    --I really wish I didn't have to do this but to my knowledge I do
    for i, p in ipairs(Player.get()) do
        keys[i] = keys[i] or {}
        for k, v in pairs(p.keys) do
            keys[i][k] = v
        end
    end
end

function clearpipe.onTick()
    for i, p in ipairs(Player.get()) do
        --If the player would be able to enter a noyoshi pipe warp:
        --If the player's pushing against a surface:
        --run enterPipe at that surface.
        if not inPipe[i] and
           p.WarpTimer == 0 and
           p.mount == 0 and
           p.forcedState == 0 and
           p.TanookiStatueActive == 0 and
           p.powerup == 1 and
           not p.isMega then
            if keys[i].down and p.LayerStateStanding == 2 then
                enterPipe(DOWN, i, p)
            elseif keys[i].up and p.LayerStateTopContact == 2 then
                enterPipe(UP, i, p)
            elseif keys[i].right and p.LayerStateRightContact == 2 then
                enterPipe(RIGHT, i, p)
            elseif keys[i].left and p.LayerStateLeftContact == 2 then
                enterPipe(LEFT, i, p)
            end
        end
        if inPipe[i] then --TODO: Collect coins while in pipes
            --[[local _,_,coins = Colliders.collideNPC(p,{10,33,88,103,138,258})
            for _,v in ipairs(coins) do
                v:harm()
            end]]
            if p.deathTimer > 0 then
                inPipe[i] = false
                inPipe.all = inPipe.all - 1
            else
                local bounce = false
                local dir = getDirection(i)
                local blocks = getCollidingBlocks(p, i, p, dir, false)
                local foundCannon = false
                for _,v in ipairs(blocks) do
                    if clearpipe.PIPES[v.id] and (clearpipe.PIPES[v.id][dir] or not isEntering(v, i, p)) then
                        if clearpipe.ELBS[v.id] or clearpipe.JUNCS[v.id] or clearpipe.CANNONS[v.id] then
                            local axis = "x"
                            if dir <= DOWN then
                                axis = "y"
                            end
                            lastPos = getMiddle(projectLastPos(i, p))[axis]
                            currPos = getMiddle(p)[axis]
                            nextPos = getMiddle(projectNextPos(i, p))[axis]
                            pipePos = getMiddle(v)
                            if clearpipe.JUNCS[v.id] then
                                pipePos.x = v.x + v.width * clearpipe.JUNC_OFFSETS[clearpipe.JUNCS[v.id]].x
                                pipePos.y = v.y + v.height * clearpipe.JUNC_OFFSETS[clearpipe.JUNCS[v.id]].y
                            end
                            pipePos = pipePos[axis]
                            --if, in the course of this frame's movement, the player would pass through the pipe's midpoint, then
                            if math.sign(currPos - pipePos) ~= math.sign(nextPos - pipePos)    then
                                if clearpipe.ELBS[v.id] then
                                    turnElbow(v, i, p)
                                elseif clearpipe.JUNCS[v.id] then
                                    turnJunction(v, i, p)
                                elseif clearpipe.CANNONS[v.id] and inPipe[i] ~= 4 then
                                    inPipe[i] = 3
                                    if dir == UP or dir == DOWN then
                                        p.y = pipePos - p.height / 2
                                    else
                                        p.x = pipePos - p.width / 2
                                    end
                                end
                            end
                        end
                    else
                        bounce = true
                    end
                end

                --Bounce if the player touches an unregistered block, or enters a pipe in an invalid direction
                if bounce then
                    vPipe[i].x = -vPipe[i].x
                    vPipe[i].y = -vPipe[i].y
                end

                --Give the reins back to vanilla for one tick if the player's on top of a warp.
                for _,warp in ipairs(
                    Warp.getIntersectingEntrance(
                        p.x - 1 + p.width  / 2,
                        p.y - 1 + p.height / 2,
                        p.x + 1 + p.width  / 2,
                        p.y + 1 + p.height / 2
                    )
                ) do
                    if warp.warpType == 0 and p.WarpTimer == 0 and not warp.isHidden then
                        inPipe[i] = 2
                        p.forcedState = 0
                        p.forcedTimer = 1
                        p.keys.run = false
                        p.keys.jump = false
                        p.keys.altRun = false
                        p.keys.altJump = false
                        break
                    end
                end
                if inPipe[i] == 3 and (keys[i].jump == KEYS_PRESSED or keys[i].altJump == KEYS_PRESSED) then
                    inPipe[i] = 4
                    vPipe[i].x = vPipe[i].x * clearpipe.cannonBoost
                    vPipe[i].y = vPipe[i].y * clearpipe.cannonBoost
                    clearpipe.cannonEffect(p)
                end
                if inPipe[i] ~= 3 then
                    p.x = p.x + vPipe[i].x * clearpipe.speed
                    p.y = p.y + vPipe[i].y * clearpipe.speed

                    local sect = p.sectionObj
                    if sect.isLevelWarp then
                        if p.x + p.width < sect.boundary.left then
                            p.x = sect.boundary.right
                        elseif p.x > sect.boundary.right then
                            p.x = sect.boundary.left - p.width
                        end
                    elseif sect.hasOffscreenExit then
                        if p.x + p.width < sect.boundary.left or p.x > sect.boundary.right then
                            Level.exit()
                        end
                    end

                    --If the player's not intersecting with a pipe:
                    --Set the player's exit speed
                    --Play a sound
                    --Reset a few variables
                    --Make sure the player can't jump.
                    blocks = Colliders.getColliding{
                        a = p,
                        b = clearpipe.PIPES_LIST,
                        btype = Colliders.BLOCK
                    }
                    if #blocks == 0 then
                        inPipe[i] = false
                        inPipe.all = #inPipe - 1
                        p.speedX = clearpipe.exitBoost * vPipe[i].x * clearpipe.speed
                        p.speedY = clearpipe.exitBoost * vPipe[i].y * clearpipe.speed
                        vPipe[i] = nil
                        SFX.play(clearpipe.sfx)
                        p.forcedState = 0
                        p.forcedTimer = 0
                        p.keys.jump = false
                        p.keys.altJump = false
                        p.WarpTimer = 10
                        p.HasJumped = -1
                        Routine.run(cor_goFast, p)
                    end
                end
            end
        end
    end
end

function clearpipe.onTickEnd()
    if #inPipe > 0 then
        for i, p in ipairs(Player.get()) do
            if inPipe[i] == 2 then
                inPipe[i] = true
                p.forcedState = 7
                p.forcedTimer = 1
                for _,warp in ipairs(Warp.getIntersectingExit(p.x, p.y, p.x + p.width, p.y + p.height)) do
                    if warp.warpType == 0 and not warp.isHidden then
                        p.y = warp.exitX + 16 - p.width / 2
                        p.y = warp.exitY + 16 - p.height / 2
                        break
                    end
                end
                for _,bgo in ipairs(BGO.getIntersecting(p.x, p.y, p.x + p.width, p.y + p.height)) do
                    local vec = clearpipe.REDIRECTS[bgo.id]
                    if vec ~= nil then
                        vPipe[i].x = clearpipe.DIR_VECTORS[vec].x
                        vPipe[i].y = clearpipe.DIR_VECTORS[vec].y
                        break
                    end
                end
            end
        end
    end
end

function clearpipe.onDraw()
--[[
    local hasPipes = false
    
    local cameras = {}
    for k,v in ipairs(Camera.get()) do
        cameras[k] = {}
        cameras[k].x = v.x
        cameras[k].y = v.y
        cameras[k].width = v.width
        cameras[k].height = v.height
    end
    
    local sprites = {}
    for _,b in Block.iterateByFilterMap(clearpipe.PIPES) do
        hasPipes = true
        for _,c in ipairs(cameras) do
            local bx,by = b.x,b.y
            local cx,cy = c.x,c.y
            if bx + b.width >= cx and bx <= cx + c.width and by + b.height >= cy and by <= cy + c.height then
                if (not b.isHidden) and b:mem(0x5A, FIELD_WORD) == 0 then
                    local bid = b.id
                    if sprites[bid] == nil then
                        sprites[bid] = Graphics.sprites.block[bid].img
                    end
                    Graphics.drawImageToSceneWP(sprites[bid], b.x, b.y, clearpipe.priority) --red pls
                end
                break
            end
        end
    end
    
    if not hasPipes then
        return
    end
    ]]
    if #inPipe > 0 then
        for i, p in ipairs(Player.get()) do
            if inPipe[i] then
                if vPipe[i].x > 0 then
                    p.direction = 1
                elseif vPipe[i].x < 0 then
                    p.direction = -1
                end
                p.forcedTimer = 1
                p.frame = getSprite(i, p)
                if p.holdingNPC then
                    local npc = p.holdingNPC
                    if vPipe[i].x > 0 then
                        npc.x = p.x + p.width
                    elseif vPipe[i].x < 0 then
                        npc.x = p.x - npc.width
                    end
                end
            end
        end
    end
end

function clearpipe.onInitAPI()
    for _,v in ipairs{"onInputUpdate", "onTick", "onTickEnd", "onDraw"} do
        registerEvent(clearpipe, v)
    end
end

function clearpipe.onDrawBlock(b)
    for _,c in ipairs(Camera.get()) do
        local bx,by = b.x,b.y
        local cx,cy = c.x,c.y
        if bx + b.width >= cx and bx <= cx + c.width and by + b.height >= cy and by <= cy + c.height then
            if (not b.isHidden) and b:mem(0x5A, FIELD_WORD) == 0 then
                Graphics.drawImageToSceneWP( Graphics.sprites.block[b.id].img, b.x, b.y, clearpipe.priority) --red pls
            end
            break
        end
    end
end

--- clearpipe.registerPipe registers a block ID as a clear pipe.
-- @tparam int id the block ID being registered as a clear pipe
-- @tparam string group the category of pipes this block will fall under
-- @tparam string shape the shape the block will have within the category
-- @tparam table allowedEntrances the directions along which entry into the pipe is allowed, {up, down, left, right}
-- @usage clearpipe.registerPipe(1, "STRAIGHT", "VERT", {true, true, false, false})
function clearpipe.registerPipe(id, group, shape, allowedEntrances)
    clearpipe.PIPES[id] = allowedEntrances
    table.insert(clearpipe.PIPES_LIST, id)
    if group == "CANNON" then
        clearpipe.CANNONS[id] = true
        group = "STRAIGHT"
    end
    if group == "GATE" then -- And I would have gotten away with it, too if it wasn't for you pesky plumbers!
        group = "STRAIGHT"
    end
    clearpipe[group .. "S"][id] = clearpipe[group][shape]
    if group == "END" then
        table.insert(clearpipe.ENDS_LIST, id)
    end
    
    Block.registerEvent(id, clearpipe, "onDrawBlock")
end

return clearpipe
