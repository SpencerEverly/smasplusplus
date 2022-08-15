local warphub = {}

-- warphub.lua v1.1
-- Created by SetaYoshi

-- SFX list
local sfx_openmenu = 13
local sfx_closemenu = 35
local sfx_warpmenu = 12
local sfx_scrollmenu = 29

local npcID = NPC_ID

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")
local textplus = require("textplus")

local cps = require("checkpoints")
local cpai = require("npcs/AI/checkpoints")
cps.registerNPC(npcID)
cpai.addID(npcID, true)

SaveData.warphub = SaveData.warphub or {}
SaveData.warphub[Level.filename()] = SaveData.warphub[Level.filename()] or {}
local SD = SaveData.warphub[Level.filename()]

local config = npcManager.setNpcSettings({
    id = npcID,
    gfxwidth = 56,
    gfxheight = 64,
    width = 56,
    height = 64,
    frames = 3,
    framespeed = 8,
    score = 0,
    speed = 0,
    playerblock = false,
    npcblock = false,
    nogravity = true,
    noblockcollision = true,
    nofireball = true,
    noiceball = true,
    noyoshi = true,
    grabside = false,
    isshoe = false,
    isyoshi = false,
    nohurt = true,
    iscoin = false,
    jumphurt = true,
    spinjumpsafe = false,
    notcointransformable = true,

  -- The title in the list
  title = "- Warp List -",
    boxwidth = 200,

    -- Change this to true, and you can warp to any warp at any time without having it to be activated
    unlockwarps = false,

    -- Change this to true and the player can hold drop item + down to open the warp menu anytime
    pocketwarp = false,

    -- Change this to true and the warphubs will stop behaving like checkpoints
    disablecheckpoint = false,

    -- Always show the screen where the checkpoint is at
    allowpreview = false
})

-- Get npc object based on warp ID
local function getNPCbyID(idx)
  for _, n in ipairs(NPC.get(npcID)) do
    if n.data.id == idx then
            return n
        end
    end
end

-- Save a collected warp
local function updateWarp(n)
    SD[n.data.id] = true
    if not config.disablecheckpoint then
        -- Misc.dialog("A")
        n.data._basegame.checkpoint:reset()
        n.data._basegame.checkpoint:collect(playerinput)
    end
end

-- Initialize a warp npc
local totalWarps = 0
local iniNPC = function(n)
  if not n.data.ini then
    n.data.ini = true
    totalWarps = totalWarps + 1
    n.data.id = totalWarps
        n.data.state = SD[n.data.id]
        n.data._basegame.checkpoint.powerup = nil
        n.data._basegame.checkpoint.sound = nil
    n.data.name = n.data._settings.name
    if n.data.name == "" then
      n.data.name = "Warp - "..n.data.id
    end
  end
end

-- Menu variables
local activated = false
local playerinput = player
local playersection = 0
local playervalidinput = false

local exclamation = Graphics.sprites.hardcoded[43].img

local mx = 400
local my = 100

local list = {}
local maxlines = 8
local arrowoffset = 0
local listoffset = 0
local scrolltimerup = 0
local scrolltimerdown = 0
local maxarrowoffset = math.min(maxlines, #list) - 1
local maxlistoffset = math.max(0, #list - maxlines)
local option = 1

-- Move the list
local move = function(n, allowloop, nosound)
  if arrowoffset == 0 and listoffset == 0 and  n < 0 then
    if not allowloop then return end
    arrowoffset = maxarrowoffset
    listoffset = maxlistoffset
  elseif arrowoffset == maxarrowoffset and listoffset == maxlistoffset and n > 0 then
    if not allowloop then return end
    arrowoffset = 0
    listoffset = 0
  else
    local newarrowoffset = arrowoffset + n
    arrowoffset = math.clamp(newarrowoffset, 0, maxarrowoffset)
    if newarrowoffset ~= arrowoffset then
      listoffset = math.clamp(listoffset + newarrowoffset - arrowoffset, 0, maxlistoffset)
    end
  end

  if not nosound then
    SFX.play(sfx_scrollmenu)
  end

  option = arrowoffset + listoffset + 1
end

-- Temporarily deactivate a input
local function deactiveCon(name)
  return function()
    while true do
      if not playerinput[name] then
        return
      end
      playerinput[name] = false
      Routine.waitFrames(1)
    end
  end
end

-- Open and close the menu
local function toggle()
  activated = not activated
  if activated then
    SFX.play(sfx_openmenu)
    Misc.pause()
    playersection = player.section
    playervalidinput = false

    list = {}
    arrowoffset = 0
    listoffset = 0
    option = 1
    for _, n in ipairs(NPC.get(npcID)) do
            list[n.data.id] = n.data.name
    end
    maxarrowoffset = math.min(maxlines, #list) - 1
    maxlistoffset = math.max(0, #list - maxlines)
  else
        player.section = playersection
    Misc.unpause()
  end
end

function warphub.onTick()
  if not activated then
    for _, p in ipairs(Player.get()) do
            -- Activate menu when player presses up and hold item if pocketwarp option is on
            if config.pocketwarp and p.keys.up and p.keys.dropItem then
        toggle()
            end

            -- Activate menu when a player presses up on an NPC
      for _, n in ipairs(Colliders.getColliding{a = p, b = npcID, atypec= Colliders.PLAYER, btype = Colliders.NPC, filter = function() return true end}) do
        Graphics.drawImageToSceneWP(exclamation, n.x + n.width*0.5 - 0.5*exclamation.width, n.y - exclamation.height - 4, -40)
        if p.rawKeys.up == KEYS_PRESSED and n.data.ini then
                    playerinput = p
          updateWarp(n)
          toggle()
                    move(n.data.id - 1, false, true)
        end
      end
    end
  end
end

local colorbox = Color(0.1, 0.1, 0.1, 0.8)
local colorlock = Color(0.6, 0.6, 0.6, 1)
local drawMenu = function()
    -- Draw list
    Graphics.drawBox{x = mx - 100, y = my, width = config.boxwidth, height = (maxarrowoffset + 2)*32, color = colorbox, pivot = {0.5, 0}}
    textplus.print{text = config.title, x = mx, y = my + 8, priority = 5, xscale = 2, yscale = 2, pivot = {0.5, 0}, plaintext = true}
    for k = 1, maxarrowoffset + 1 do
      local pre = " "
      if k == arrowoffset + 1 then
        pre = "> "
      end
            local color
      if not config.unlockwarps and not SD[k + listoffset] then
        color = colorlock
      end
      textplus.print{text = pre..list[k + listoffset], x = mx + 8, y = my + k*32 + 8, priority = 5, color = color, xscale = 2, yscale = 2, pivot = {0.5, 0}, plaintext = true}
    end
end

local function readInput()
    -- Listen to inputs
    if playerinput.keys.run == KEYS_PRESSED then
        toggle()
        SFX.play(sfx_closemenu)
        Routine.run(deactiveCon("runKeyPressing"))
    elseif playerinput.keys.jump == KEYS_PRESSED and (SD[option] or config.unlockwarps) then
        local n = getNPCbyID(option)
        if n then
            toggle()
            updateWarp(n)
            SFX.play(sfx_warpmenu)
            playerinput.section = playersection
            playerinput:teleport(n.x + 0.5*(n.width - playerinput.width), n.y + n.height - playerinput.height)
            playerinput.speedX = 0
            playerinput.speedY = 0
            playerinput:mem(0x140,    FIELD_WORD, 50)
            local e = Animation.spawn(10, playerinput.x + 0.5*player.width, playerinput.y + 0.5*player.height)
            e.x, e.y = e.x - 0.5*e.width, e.y - 0.5*e.height
            Routine.run(deactiveCon("jumpKeyPressing"))
        end
    end
    if playerinput.keys.up then
        scrolltimerup = scrolltimerup + 1
        if playervalidinput then
            if scrolltimerup == 1 then
                move(-1, true)
            elseif scrolltimerup > 20 and scrolltimerup%5 == 0 then
                move(-1, false)
            end
        end
    else
        playervalidinput = true
        scrolltimerup = 0
    end
    if playerinput.keys.down then
        scrolltimerdown = scrolltimerdown + 1
        if playervalidinput then
            if scrolltimerdown == 1 then
                move(1, true)
            elseif scrolltimerdown > 20 and scrolltimerdown%5 == 0 then
                move(1, false)
            end
        end
    else
        scrolltimerdown = 0
    end
end

local function getSection(x,y,w,h)
    for k, v in ipairs(Section.get()) do
        local b = v.boundary
        if (x + w >= b.left and x <= b.right) and (y + h >= b.top and y <= b.bottom) then
            return k - 1
        end
    end
    return -1
end

-- Disable split-screen when menu is activated
function warphub.onCameraUpdate(idx)
  if activated then
    if idx == 1 then
      local n = getNPCbyID(option)
      camera.renderX, camera.renderY, camera.width, camera.height = 0, 0, 800, 600
            drawMenu()
            readInput()

            if n then
                if SD[n.data.id] or config.allowpreview or config.unlockwarps then
                    camera.x = n.x + 0.5*n.width - 400
                    camera.y = n.y + n.height - 300
                end

        local s = getSection(camera.x + 2, camera.y + 2, 800, 600)
        if s == -1 then s = playerinput.section end
                if activated then
                  player.section = s
              end

        sec = Section(s).boundary
        camera.x, camera.y = math.clamp(sec.left, camera.x, sec.right - 800), math.clamp(sec.top, camera.y, sec.bottom - 600)
      end
    else
      camera2.renderY = 800
    end
  end
end

function warphub.onTickNPC(n)
  iniNPC(n)
end

function warphub.onDrawNPC(n)
    if not config.nospecialanimation then
        local frames = math.floor(config.frames/3)
        local offset = frames
        if n.data._basegame.checkpoint.id == GameData.__checkpoints[Level.filename()].current then
            offset = 0
        elseif not SD[n.data.id] then
      offset = frames*2
        end
        n.animationFrame = npcutils.getFrameByFramestyle(n, {frames = frames, offset = offset})
    end
end


function warphub.onInitAPI()
  npcManager.registerEvent(npcID, warphub, "onTickNPC")
    npcManager.registerEvent(npcID, warphub, "onDrawNPC")

  registerEvent(warphub, "onTick", "onTick")
  registerEvent(warphub, "onCameraUpdate", "onCameraUpdate", true)
end

return warphub
