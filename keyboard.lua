local keyboard = {}

local textplus = require("textplus")
local rng = require("base/rng")

local blinker = 0

keyboard.buffer = ""
keyboard.cursorPos = 0

keyboard.active = false
keyboard.settingName = false

local function split(str, idx)
    return str:sub(1, idx), str:sub(idx + 1)
end

local function printString(str)
    if str == nil then
        str = ""
    end
    if str:find("\n") then
        for k,v in ipairs(str:split("\n")) do
            
        end
    elseif str then
        
    end
end

function keyboard.cmd()
    printString("" .. keyboard.buffer:gsub("\n", "\n "))
    if GameData.playernameenter then
        if keyboard.buffer ~= "" then
            SaveData.playerName = keyboard.buffer
            keyboard.buffer = ""
            keyboard.cursorPos = 0
            Sound.playSFX("console/console_success.ogg")
            keyboard.active = false
            GameData.enablekeyboard = false
            GameData.reopenmenu = true
            GameData.toggleoffkeys = false
            smasBooleans.toggleOffInventory = false
            GameData.playernameenter = false
            GameData.firstbootkeyboardconfig = false
        end
    end
    if GameData.playerpfpenter then
        if keyboard.buffer ~= "" then
            if SaveData.playerPfp == nil then
                SaveData.playerPfp = keyboard.buffer
            else
                SaveData.playerPfp = keyboard.buffer
            end
            keyboard.buffer = ""
            keyboard.cursorPos = 0
            Sound.playSFX("console/console_success.ogg")
            keyboard.active = false
            GameData.enablekeyboard = false
            GameData.reopenmenu = true
            GameData.toggleoffkeys = false
            smasBooleans.toggleOffInventory = false
            GameData.playernameenter = false
            GameData.firstbootkeyboardconfig = false
        end
    end
    if GameData.playernameenterfirstboot then
        if keyboard.buffer ~= "" then
            SaveData.playerName = keyboard.buffer
            keyboard.buffer = ""
            keyboard.cursorPos = 0
            Sound.playSFX("console/console_success.ogg")
            keyboard.active = false
            GameData.enablekeyboard = false
            GameData.firstbootkeyboardconfig = true
            GameData.toggleoffkeys = false
            smasBooleans.toggleOffInventory = false
            GameData.playernameenter = false
        end
    end
    if GameData.saveslotswitchenter then
        if keyboard.buffer ~= "" then
            if keyboard.buffer >= "1" or keyboard.buffer <= "32767" then
                Misc.moveSaveSlot(Misc.saveSlot(), tonumber(keyboard.buffer))
                Misc.saveGame()
                keyboard.buffer = ""
                keyboard.cursorPos = 0
                Sound.playSFX("console/console_success.ogg")
                keyboard.active = false
                GameData.enablekeyboard = false
                GameData.reopenmenu = true
                GameData.toggleoffkeys = false
                smasBooleans.toggleOffInventory = false
                GameData.saveslotswitchenter = false
                GameData.firstbootkeyboardconfig = false
            elseif keyboard.buffer ~= "" then
                keyboard.buffer = ""
                keyboard.cursorPos = 0
                Sound.playSFX("console/console_error.ogg")
                keyboard.active = false
                GameData.enablekeyboard = false
                GameData.reopenmenu = true
                GameData.toggleoffkeys = false
                smasBooleans.toggleOffInventory = false
                GameData.saveslotswitchenter = false
                GameData.firstbootkeyboardconfig = false
            end
        end
    end
end

function keyboard.onInitAPI()
    registerEvent(keyboard, "onKeyboardPressDirect")
    registerEvent(keyboard, "onControllerButtonPress")
    registerEvent(keyboard, "onDraw")
    registerEvent(keyboard, "onPasteText")
    registerEvent(keyboard, "onInputUpdate")
    registerEvent(keyboard, "onTick")
end

function keyboard.onTick()
    if GameData.enablekeyboard == true then
        smasBooleans.toggleOffInventory = true
        GameData.toggleoffkeys = true
        keyboard.active = true
    end
    if GameData.enablekeyboard == false then
        
    end
end

function keyboard.onInputUpdate()
    if not keyboard.active then
        if player.keys.dropItem == KEYS_PRESSED then

        end
    end
    if keyboard.active then
        if player.keys.dropItem == KEYS_PRESSED then
            player.keys.dropItem = KEYS_UNPRESSED
        end
    end
    if GameData.toggleoffkeys == true then
        for k,v in pairs(player.keys) do
            player.keys[k] = false
        end
    end
    if GameData.toggleoffkeys == false or GameData.toggleoffkeys == nil then
        
    end
end

function keyboard.onControllerButtonPress(button)
    if not keyboard.active then
        return
    end
    
    if (button == inputConfig1.jump) then
        if GameData.playernameenterfirstboot == false then
            Sound.playSFX("console/console_resetfont.ogg")
            smasBooleans.toggleOffInventory = false
            GameData.toggleoffkeys = false
            keyboard.active = false
            GameData.enablekeyboard = false
            GameData.reopenmenu = true
        elseif GameData.playernameenterfirstboot == true or GameData.playernameenterfirstboot == nil then
            Sound.playSFX("console/console_resetfont.ogg")
            SaveData.playerName = "Player"
            keyboard.active = false
            GameData.enablekeyboard = false
            GameData.firstbootkeyboardconfig = true
            GameData.toggleoffkeys = false
            smasBooleans.toggleOffInventory = false
            GameData.playernameenter = false
        end
    end
end

function keyboard.onKeyboardPressDirect(vk, repeated, char)
    if not keyboard.active then
        return
    end
    
    if (vk == VK_NEXT) then
        if (not repeated) then
            if GameData.playernameenterfirstboot == false then
                Sound.playSFX("console/console_resetfont.ogg")
                smasBooleans.toggleOffInventory = false
                GameData.toggleoffkeys = false
                keyboard.active = false
                GameData.enablekeyboard = false
                GameData.reopenmenu = true
            elseif GameData.playernameenterfirstboot == true or GameData.playernameenterfirstboot == nil then
                Sound.playSFX("console/console_resetfont.ogg")
                SaveData.playerName = "Player"
                keyboard.active = false
                GameData.enablekeyboard = false
                GameData.firstbootkeyboardconfig = true
                GameData.toggleoffkeys = false
                smasBooleans.toggleOffInventory = false
                GameData.playernameenter = false
            end
        end
    end
    
    local rngkey = rng.randomInt(1,7)
    if (not repeated) then
        Sound.playSFX("console/console_keypress"..rngkey..".ogg")
    end
    
    if vk == VK_RETURN then
        Sound.playSFX("console/console_keypressenter.ogg")
        keyboard.cmd()
    elseif vk == VK_BACK then
        local left, right = split(keyboard.buffer, keyboard.cursorPos)
        keyboard.buffer = left:sub(1, -2) .. right
        keyboard.cursorPos = math.max(0, keyboard.cursorPos - 1)
        Sound.playSFX("console/console_keypressbackspace.ogg")
        blinker = 1
    elseif vk == VK_DELETE then
        local left, right = split(keyboard.buffer, keyboard.cursorPos)
        keyboard.buffer = left .. right:sub(2)
        Sound.playSFX("console/console_keypress7.ogg")
        blinker = 1
    elseif vk == VK_LEFT then
        keyboard.cursorPos = math.max(0, keyboard.cursorPos - 1)
        blinker = 1
        Sound.playSFX("console/console_keypress"..rngkey..".ogg")
    elseif vk == VK_RIGHT then
        keyboard.cursorPos = math.min(keyboard.cursorPos + 1, #keyboard.buffer)
        blinker = 1
        Sound.playSFX("console/console_keypress"..rngkey..".ogg")
    elseif char ~= nil then
        local left, right = split(keyboard.buffer, keyboard.cursorPos)
        keyboard.buffer = left .. char .. right
        keyboard.cursorPos = keyboard.cursorPos + #char
        blinker = 1
    end
    Misc.cheatBuffer("")
end

function keyboard.onPasteText(pastedText)
    local left, right = split(keyboard.buffer, keyboard.cursorPos)
    keyboard.buffer = left .. pastedText .. right
    keyboard.cursorPos = keyboard.cursorPos + #pastedText
    Sound.playSFX("console/console_paste.ogg")
    blinker = 1
end

do
    local gtltrepllace = {["<"] = "<lt>", [">"] = "<gt>", ["\n"] = "<br>"}
    local msgfont = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus.ini")
    local doprint = {font=textplus.loadFont("littleDialogue/font/hardcoded-45-3-textplus.ini"), color=Color.red, plaintext=true}
    doprint.xscale = 1
    doprint.yscale = 1
        
    local glyphwid = (doprint.font.cellWidth + doprint.font.spacing)*doprint.xscale
    local gsub = string.gsub
    local sub = string.sub
    local split = string.split
    local find = string.find
    local function _print(str, x, y)
        local textLayout = textplus.layout(str, nil, doprint)
        y = y - textLayout.height
        textplus.render{x = x, y = y, layout = textLayout, priority = -1}
    end
    
    local printlist = {}
    local listidx = 1
    local function addprint(v)
        printlist[listidx] = v
        listidx = listidx + 1
    end
    local baseX, baseY = 60, 500
    
    function keyboard.onDraw()
        if not keyboard.active then
            return
        end
        if GameData.playernameenterfirstboot == false or GameData.playernameenterfirstboot == nil then
            textplus.print{x = 60, y = 310, text = "To cancel, press the PAGE DOWN key,", priority = -1, font = msgfont}
            textplus.print{x = 15, y = 330, text = "or use the JUMP key on your controller.", priority = -1, font = msgfont}
        elseif GameData.playernameenterfirstboot == true then
            textplus.print{x = 65, y = 310, text = "To skip, press the PAGE DOWN key,", priority = -1, font = msgfont}
            textplus.print{x = 15, y = 330, text = "or use the JUMP key on your controller.", priority = -1, font = msgfont}
        end
        
        local buffer
        if find(keyboard.buffer, "\n") then
            buffer = split(keyboard.buffer, "\n")
        else
            buffer = {keyboard.buffer}
        end

        local y = baseY
        for i = #buffer, 1, -1 do
            if (i ~= #buffer) then
                y = y + 9*doprint.yscale
                addprint("\n")
            end
            if y < 0 then
                break
            end
            addprint(buffer[i])
            if i == 1 then
                addprint("")
            else
                addprint(" ")
            end
        end
        
        if blinker > 0 then
            local x = baseX + glyphwid/2
            local y = y
            if #buffer > 1 then
                local t = 0
                for i = 1, #buffer do
                    local nt = t + #(buffer[i]) + 1
                    if nt > keyboard.cursorPos then
                        x = x + (glyphwid * (keyboard.cursorPos - t))
                        break
                    elseif nt == keyboard.cursorPos then
                        x = baseX + 4*doprint.xscale
                        y = y + 9*doprint.yscale
                        break
                    end
                    y = y + 9*doprint.yscale
                    t = nt
                end
            else
                x = x + (glyphwid * keyboard.cursorPos)
            end
            _print("|", x, y)
        end
        blinker = blinker + 1
        if blinker > 32 then
            blinker = -32
        end
        printlist[listidx] = nil
        listidx = 1
        
        _print(table.concat(table.reverse(printlist)), baseX, baseY)
    end
end

return keyboard