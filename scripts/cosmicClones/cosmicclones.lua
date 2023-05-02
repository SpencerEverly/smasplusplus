local cc = {}

local ccTable = {}

local playerStateBuffer = {}

local tableinsert = table.insert

local dustEmitter = Particles.Emitter(0, 0, Misc.episodePath().."scripts/cosmicClones/p_clonesmoke.ini")

local pm = require("playermanager")
local chars = pm.getCharacters()

-- Access from your lua file if you wanna change the tint of the player sprite clone!
cc.tint = Color(1, 1, 1, 1)

local recording = false

local recordingStartTick = 0

function cc.addClone()
    local t = playerStateBuffer[1]
    table.insert(ccTable, {
        startTick = recordingStartTick,
        timer = -1
    })
end

local function recordPlayerState()
    if playerStateBuffer[lunatime.tick()] then return end
    local settings = player:getCurrentPlayerSetting()
    local pX, pY = player:getCurrentSpriteIndex()
    local offsetX = settings:getSpriteOffsetX(pX, pY)
    local offsetY = settings:getSpriteOffsetY(pX, pY)
    playerStateBuffer[lunatime.tick()] = {
        x = player.x,
        y = player.y,
        texX = pX,
        texY = pY,
        drawX = player.x + offsetX,
        drawY = player.y + offsetY,
        width = player.width,
        height = player.height,
        char = CHARACTER_LUIGI,
        powerup = player.powerup
    }
end

local function dieRoutine(args)
    dustEmitter.x = args[1]
    dustEmitter.y = args[2]
    for i=1, 12 do
        dustEmitter:Emit(1)
        Routine.waitFrames(1)
    end
end

local function activationRoutine(args)
    --SFX.play("scripts/cosmicClones/sfx_clones_announce.wav")
    for i=1, args[1] do
        --[[local remainder = math.max(args[2] - 64, 1)
        local rest = args[2] - remainder]]
        Routine.waitFrames(15)
        --[[dustEmitter.x = args[3][1]
        dustEmitter.y = args[3][2]
        for i=1, rest do
            dustEmitter:Emit(1)
            Routine.waitFrames(1)
        end
        if args[4] ~= recordingStartTick then
            return
        end]]
        --SFX.play("scripts/cosmicClones/sfx_clones_spawn.wav")
        cc.addClone()
    end
end

function cc.activate(cloneAmount, cloneInterval)
    if (not recording) then
        recording = true
        recordingStartTick = lunatime.tick()
        recordPlayerState()
        Routine.run(activationRoutine, {cloneAmount, cloneInterval, {player.x + 0.5 * player.width, player.y + 0.5 * player.height}, recordingStartTick})
    end
end

function cc.deactivate()
    recording = false
end

function cc.onInitAPI()
    registerEvent(cc, "onTickEnd")
    registerEvent(cc, "onDraw")
end

local function deleteClone(i, t)
    table.remove(ccTable, i)
    --SFX.play("scripts/cosmicClones/sfx_clones_kill.wav")
    if #ccTable == 0 and not recording then
        playerStateBuffer = {}
    end
    if t ~= nil then
        Routine.run(dieRoutine, {t.x + 0.5 * t.width, t.y + 0.5 * t.height})
    end
end

function cc.onTickEnd()
    if recording then
        recordPlayerState()
    end
    for i=#ccTable, 1, -1 do
        ccTable[i].timer = ccTable[i].timer + 1
        local state = playerStateBuffer[ccTable[i].startTick + ccTable[i].timer]
        if state == nil then
            deleteClone(i, playerStateBuffer[ccTable[i].startTick + ccTable[i].timer - 1])
        elseif player.deathTimer == 0 and player:mem(0x140, FIELD_WORD) == 0 then
            if #Player.getIntersecting(state.x, state.y, state.x + state.width, state.y + state.height) > 0 then
                --player:harm()
                --deleteClone(i, playerStateBuffer[ccTable[i].startTick + ccTable[i].timer - 1])
            end
        end
    end
end

function cc.onDraw()
    local indices = {}
    local verts = {}
    local pidx = {}
    local texes = {}
    for k,v in ipairs(ccTable) do
        local s = playerStateBuffer[v.startTick + v.timer]
        if verts[s.char] == nil then
            table.insert(indices, s.char)
            verts[s.char] = {}
            texes[s.char] = {}
            pidx[s.char] = {}
        end

        if verts[s.char][s.powerup] == nil then
            verts[s.char][s.powerup] = {}
            texes[s.char][s.powerup] = {}
            table.insert(pidx[s.char], s.powerup)
        end
        local vt = verts[s.char][s.powerup]
        local tx = texes[s.char][s.powerup]

        tableinsert(vt, s.drawX)
        tableinsert(vt, s.drawY)
        tableinsert(tx, s.texX * 0.1)
        tableinsert(tx, s.texY * 0.1)

        for i=1, 2 do
            tableinsert(vt, s.drawX + 100)
            tableinsert(tx, s.texX * 0.1 + 0.1)
            tableinsert(tx, s.texY * 0.1)
            tableinsert(vt, s.drawY)
            tableinsert(vt, s.drawX)
            tableinsert(vt, s.drawY + 100)
            tableinsert(tx, s.texX * 0.1)
            tableinsert(tx, s.texY * 0.1 + 0.1)
        end

        tableinsert(tx, s.texX * 0.1 + 0.1)
        tableinsert(tx, s.texY * 0.1 + 0.1)
        tableinsert(vt, s.drawX + 100)
        tableinsert(vt, s.drawY + 100)
    end

    for _,c in ipairs(indices) do
        for _,p in ipairs(pidx[c]) do
            Graphics.glDraw{
                vertexCoords = verts[c][p],
                textureCoords = texes[c][p],
                priority = -25,
                sceneCoords = true,
                texture = Graphics.sprites[chars[c].name][p].img,
                primitive = Graphics.GL_TRIANGLES,
                color = cc.tint
            }
        end
    end
    dustEmitter:Draw(-12, true)
end

return cc