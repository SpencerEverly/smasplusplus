local cursor = {}

----------------------
-- cursor.lua v0.1 BETA
-- By SetaYoshi

-- A succesor library to click.lua
-- Helper library to read cusor values
----------------------


-- Settings
cursor.defaultcam1 = true
cursor.debug = false

-- Position and speed of the cursor
cursor.x, cursor.y, cursor.onscreen = 0, 0, false
cursor.sceneX, cursor.sceneY, cursor.onscene, cursor.camera = 0, 0, false, 0
cursor.speedX, cursor.speedY = 0, 0

-- State of the buttons
cursor.left = KEYS_UP
cursor.right = KEYS_UP

-- Collider objects
cursor.screenpos = Colliders.Point(0, 0)
cursor.scenepos = Colliders.Point(0, 0)
cursor.leftDragBox = Colliders.Box(0, 0, 0, 0)
cursor.leftDragBoxScene = Colliders.Box(0, 0, 0, 0)
local screenpos, scenepos, leftDragBox, leftDragBoxScene = cursor.screenpos, cursor.scenepos, cursor.leftDragBox, cursor.leftDragBoxScene
leftDragBox.timer, leftDragBoxScene.timer = 0, 0

-- Shotcuts!
cursor.click = false  -- Checks if the left button was "clicked"
cursor.released = false  -- Checks if the left button was "released"

local hist = {}
hist.left = false
hist.right = false
hist.x = 0
hist.y = 0

-- Tools for drawing a cursor
local defaultImg = Graphics.sprites.hardcoded["42-2"].img
local default = {image = defaultImg, frames = 1, animationFrame = 0, framespeed = 8, offsetX = 0, offsetY = 0, priority = 9, angle = 0, color = Color.white}
cursor.imgCur = {frame = 0, frames = 1, framespeed = 8, offsetX = 0, offsetY = 0, animationTimer = 0, angle = 0}
imgCur = cursor.imgCur
local imgData = {}
local imgID = 0

local function resetCursor()
  imgCur = table.clone(imgData[imgID])
  imgCur.frame = 0
  imgCur.animationTimer = 0
  cursor.imgCur = imgCur
end

function cursor.create(t, notset)
  local id = #imgData + 1
  t = t or {}
  -- Set default values
  for k, v in pairs(default) do
    if not t[k] then
      t[k] = v
    end
  end

  t.width = t.width or t.image.width
  t.height = t.height or math.floor(t.image.height/t.frames)

  -- Add data to data table
  table.insert(imgData, t)
  if not notset then
    cursor.setID(id)
  end

  return id
end

function cursor.setID(id)
  imgID = id
  resetCursor()
end

function cursor.getID()
  return imgID
end


function cursor.update()
  -- Gather data
  local left_state = mem(0x00B2D6CC, FIELD_BOOL)
  local right_state = mem(0x00B2D6CE, FIELD_BOOL)
  mem(0x00B2D6CE, FIELD_BOOL, false)

  cursor.x = mem(0x00B2D6BC, FIELD_DFLOAT)
  cursor.y = mem(0x00B2D6C4, FIELD_DFLOAT)
  screenpos.x, screenpos.y = cursor.x, cursor.y
  if cursor.x >= 0 and cursor.x <= 800 and cursor.y >= 0 and cursor.y <= 600 then
    cursor.onscreen = true
  else
    cursor.onscreen = false
  end

  -- Update the scene positions
  if player2 and camera2 and Colliders.collide(Colliders.Box(camera2.renderX, camera2.renderY, camera2.width, camera2.height), screenpos) then
    cursor.sceneX = camera2.x + (cursor.x - camera2.renderX)
    cursor.sceneY = camera2.y + (cursor.y - camera2.renderY)
    cursor.onscene = true
    cursor.camera = 2
  else
    local d = Colliders.collide(Colliders.Box(camera.renderX, camera.renderY, camera.width, camera.height), screenpos)
    cursor.camera = 0
    if cursor.defaultcam1 or d then
      cursor.sceneX = camera.x + (cursor.x - camera.renderX)
      cursor.sceneY = camera.y + (cursor.y - camera.renderY)
      cursor.camera = 1
    end
    cursor.onscene = d
  end
  scenepos.x, scenepos.y = cursor.sceneX, cursor.sceneY

  -- Calculate the speed
  cursor.speedX = cursor.x - hist.x
  cursor.speedY = cursor.y - hist.y

  -- Reset the shotcut variables
  cursor.click, cursor.released = false, false

  -- Update the left button
  if not cursor.left and left_state then
    cursor.left = KEYS_PRESSED
    cursor.click = true

    leftDragBox.x, leftDragBox.y, leftDragBox.width, leftDragBox.height, leftDragBox.timer = cursor.x, cursor.y, 0, 0, 0
    leftDragBoxScene.x, leftDragBoxScene.y, leftDragBoxScene.width, leftDragBoxScene.height, leftDragBoxScene.timer = cursor.sceneX, cursor.sceneY, 0, 0, 0
  elseif cursor.left and not left_state then
    cursor.left = KEYS_RELEASED
    cursor.released = true
  elseif left_state then
    cursor.left = KEYS_DOWN

    leftDragBox.width, leftDragBox.height = cursor.x - leftDragBox.x, cursor.y - leftDragBox.y
    leftDragBoxScene.width, leftDragBoxScene.height = cursor.sceneX - leftDragBoxScene.x, cursor.sceneY - leftDragBoxScene.y
    leftDragBox.timer = leftDragBox.timer + 1
    leftDragBoxScene.timer = leftDragBoxScene.timer + 1
  else
    cursor.left = KEYS_UP
  end

  -- Update the right button
  if not cursor.right and right_state then
    cursor.right = KEYS_PRESSED
  elseif cursor.right and not right_state then
    cursor.right = KEYS_RELEASED
  elseif right_state then
    cursor.right = KEYS_DOWN
  else
    cursor.right = KEYS_UP
  end

  -- Save values to hist
  hist.left, hist.right = left_state, right_state
  hist.x, hist.y = cursor.x, cursor.y
end

function cursor.onCameraDraw(x)
  if x ~= 1 then return end
  cursor.update()

  if imgID > 0 then
    local d = cursor.imgCur
    d.animationTimer = d.animationTimer + 1
    if d.animationTimer >= d.framespeed then
      d.animationTimer = 0
      d.animationFrame = d.animationFrame + 1
      if d.animationFrame >= d.frames then
        d.animationFrame = 0
      end
    end

    local v = vector.v2(cursor.sceneX, cursor.sceneY)
    local w, h = vector.v2(d.width, 0):rotate(d.angle), vector.v2(0, d.height):rotate(d.angle)
    local z1, z2, z3, z4 = v, v + w, v + w + h, v + h

    local r = vector.v2(0, d.animationFrame*d.height/d.image.height)
    local b, l = vector.v2(1, 0), vector.v2(0, d.height/d.image.height)
    local p1, p2, p3, p4 = r, r + b, r + b + l, r + l

    Graphics.glDraw{color = d.color, texture = d.image, vertexCoords = {z1.x, z1.y, z2.x, z2.y, z4.x, z4.y, z2.x, z2.y, z3.x, z3.y, z4.x, z4.y}, textureCoords = {p1.x, p1.y, p2.x, p2.y, p4.x, p4.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y}, priority = d.priority, sceneCoords = true}
  end

  if cursor.debug then
    Text.printWP("BUTTON "..": "..tostring(cursor.left)..", "..tostring(cursor.right), 8, 8 + 18*0, 9)
    Text.printWP("SCRNPOS"..": "..cursor.x..", "..cursor.y, 8, 8 + 18*1, 9)
    Text.printWP("SCNEPOS"..": "..cursor.sceneX..", "..cursor.sceneY, 8, 8 + 18*2, 9)
    Text.printWP("SPEED  "..": "..cursor.speedX..", "..cursor.speedY, 8, 8 + 18*3, 9)
    Text.printWP("LDRAGBX"..": "..cursor.leftDragBox.x..", "..cursor.leftDragBox.y..", "..cursor.leftDragBox.width..", "..cursor.leftDragBox.height..", "..cursor.leftDragBox.timer, 8, 8 + 18*4, 9)
    Text.printWP("LSCNEBX"..": "..cursor.leftDragBoxScene.x..", "..cursor.leftDragBoxScene.y..", "..cursor.leftDragBoxScene.width..", "..cursor.leftDragBoxScene.height..", "..cursor.leftDragBoxScene.timer, 8, 8 + 18*5, 9)
    Text.printWP("IMG    "..": "..cursor.getID()..", "..imgCur.animationFrame..", "..imgCur.animationTimer..", "..math.floor(imgCur.angle)..", "..tostring(imgCur.color), 8, 8 + 18*6, 9)
    Text.printWP("MISC   "..": "..tostring(cursor.onscreen)..", "..tostring(cursor.onscene)..", "..cursor.camera..", "..cursor.imgCur.animationTimer, 8, 8 + 18*7, 9)
  end
end

function cursor.onInitAPI()
  registerEvent(cursor, "onCameraDraw", "onCameraDraw")
end

return cursor
