local smasKeySystem = {}

smasKeySystem.disableAllKeys = false --Whether to disable all keys or not.

_G.KEYS_UP = false
_G.KEYS_RELEASED = nil
_G.KEYS_PRESSED = 1
_G.KEYS_DOWN = true

smasKeySystem.keysList = {
	"up",
	"down",
	"left",
	"right",
	"jump",
	"altJump",
	"run",
	"altRun",
	"dropItem",
	"pause",
    "special",
}

SaveData.controls = SaveData.controls or {}
SaveData.controls.keyboard = SaveData.controls.keyboard or {}
SaveData.controls.controller = SaveData.controls.controller or {}
for i = 1,8 do
    SaveData.controls.keyboard[i] = SaveData.controls.keyboard[i] or {}
    SaveData.controls.controller[i] = SaveData.controls.controller[i] or {}
end

smasKeySystem.keys = {}
for i = 1,8 do
    smasKeySystem.keys[i] = {}
    smasKeySystem.keys[i].jump = false
    smasKeySystem.keys[i].run = false
    smasKeySystem.keys[i].altJump = false
    smasKeySystem.keys[i].altRun = false
    smasKeySystem.keys[i].dropItem = false
    smasKeySystem.keys[i].pause = false
    smasKeySystem.keys[i].up = false
    smasKeySystem.keys[i].down = false
    smasKeySystem.keys[i].left = false
    smasKeySystem.keys[i].right = false
    smasKeySystem.keys[i].special = false
end

function smasKeySystem.onInitAPI()
    registerEvent(smasKeySystem,"onKeyboardPressDirect")
    registerEvent(smasKeySystem,"onDraw")
    registerEvent(smasKeySystem,"onControllerButtonPress")
end

function smasKeySystem.onKeyboardPressDirect(key, repeated)
    for i = 1,8 do
        for k,v in ipairs(smasKeySystem.keysList) do
            if key == SaveData.controls.keyboard[i][v] then
                if not repeated then
                    smasKeySystem.keys[i][v] = KEYS_PRESSED
                elseif repeated then
                    smasKeySystem.keys[i][v] = KEYS_DOWN
                else
                    smasKeySystem.keys[i][v] = KEYS_UP
                end
            end
        end
    end
end

function smasKeySystem.onDraw()
    for i = 1,8 do
        if inputConfig1.inputType == 0 then
            SaveData.controls.keyboard[i].jump = SaveData.controls.keyboard[1].jump or inputConfig1.jump
            SaveData.controls.keyboard[i].run = SaveData.controls.keyboard[1].run or inputConfig1.run
            SaveData.controls.keyboard[i].altJump = SaveData.controls.keyboard[1].altJump or inputConfig1.altjump
            SaveData.controls.keyboard[i].altRun = SaveData.controls.keyboard[1].altRun or inputConfig1.altrun
            SaveData.controls.keyboard[i].dropItem = SaveData.controls.keyboard[1].dropItem or inputConfig1.dropitem
            SaveData.controls.keyboard[i].pause = SaveData.controls.keyboard[1].pause or inputConfig1.pause
            SaveData.controls.keyboard[i].up = SaveData.controls.keyboard[1].up or inputConfig1.up
            SaveData.controls.keyboard[i].down = SaveData.controls.keyboard[1].down or inputConfig1.down
            SaveData.controls.keyboard[i].left = SaveData.controls.keyboard[1].left or inputConfig1.left
            SaveData.controls.keyboard[i].right = SaveData.controls.keyboard[1].right or inputConfig1.right
            SaveData.controls.keyboard[i].special = SaveData.controls.keyboard[1].special or VK_D
        elseif inputConfig1.inputType == 1 then
            SaveData.controls.controller[i].jump = SaveData.controls.controller[1].jump or inputConfig1.jump
            SaveData.controls.controller[i].run = SaveData.controls.controller[1].run or inputConfig1.run
            SaveData.controls.controller[i].altJump = SaveData.controls.controller[1].altJump or inputConfig1.altjump
            SaveData.controls.controller[i].altRun = SaveData.controls.controller[1].altRun or inputConfig1.altrun
            SaveData.controls.controller[i].dropItem = SaveData.controls.controller[1].dropItem or inputConfig1.dropitem
            SaveData.controls.controller[i].pause = SaveData.controls.controller[1].pause or inputConfig1.pause
            SaveData.controls.controller[i].up = SaveData.controls.controller[1].up or inputConfig1.up
            SaveData.controls.controller[i].down = SaveData.controls.controller[1].down or inputConfig1.down
            SaveData.controls.controller[i].left = SaveData.controls.controller[1].left or inputConfig1.left
            SaveData.controls.controller[i].right = SaveData.controls.controller[1].right or inputConfig1.right
            SaveData.controls.controller[i].special = SaveData.controls.controller[1].special or SaveData.specialbutton1stplayer
        end
        for k,v in ipairs(smasKeySystem.keysList) do
            if Misc.GetKeyState(SaveData.controls.keyboard[i][v]) then
                smasKeySystem.keys[i][v] = KEYS_DOWN
            else
                smasKeySystem.keys[i][v] = KEYS_UP
            end
        end
    end
end

return smasKeySystem