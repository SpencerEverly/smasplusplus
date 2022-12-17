local textplus = require("textplus")
local keyFont = textplus.loadFont("keyboard/keyboardFont.ini")

local keyboard = {}

keyboard.leastPriority = -0.9

keyboard.activeBoard = {}

keyboard.movement = {}
keyboard.movement.bar     = {type = 0, position = 800,  origin = 800,  goal = 175, speed = -15}
keyboard.movement.board   = {type = 0, position = -450, origin = -450, goal = 175, speed =  15}
keyboard.movement.buttons = {type = 0, position = 600,  origin = 600,  goal = 395, speed = -10}

keyboard.closed = false
keyboard.closedWithoutValues = false
keyboard.timer = 2

-- Image table
keyboard.images = {
    boardLower  = Graphics.loadImageResolved("keyboard/boardLower.png"),
    boardUpper  = Graphics.loadImageResolved("keyboard/boardUpper.png"),
    textBar     = Graphics.loadImageResolved("keyboard/textBar.png"),
    buttons     = Graphics.loadImageResolved("keyboard/buttons.png"),
    selector    = Graphics.loadImageResolved("keyboard/selector.png"),
    caret       = Graphics.loadImageResolved("keyboard/caret.png"),
}

local boards = {}
local keyb = {}
local keybMT = {__index = keyb}
local selection = vector(1, 1)
local buttonSel = 0

local actBoard = keyboard.activeBoard
local mov = keyboard.movement
local images = keyboard.images

local selectorFrame = 0
local blinker = 0
local movementOver = false
local warningText = "You can't exit!"
local warningOpacity = 0

-- Background related
local bgTexture = Graphics.loadImageResolved("keyboard/texture.png")
local bgTX = 0
local bgTY = 0
local bgTopacity = 0
local opacityFadeType = 0 -- 0 = not fading, 1 = fading in and 2 = fading out

local keys = { -- if you are editing this to change the order of keys, make sure to edit the images as well
    [1] = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m"},
    [2] = {"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"},
    [3] = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "+", "="},
    [4] = {"!", "\"", "'", "#", "$", "%", "&", "^", "*", "(", ")", "[", "]"},
    [5] = {",", ".", "\\", "/", ":", ";", "<", ">", "_", "?", "@", "~", "|"},
}

local function getKey(x, y)
    local key = keys[y][x]
    return key
end

local function bgStuff()
    bgTX = bgTX + 0.4
    bgTY = bgTY - 0.4
    if opacityFadeType == 1 then
        bgTopacity = bgTopacity + 0.1
    elseif opacityFadeType == 2 then
        bgTopacity = bgTopacity - 0.1
    end
    if ((bgTopacity > 1) or (bgTopacity < 0)) then
        opacityFadeType = 0
    elseif bgTopacity > 1 then
        bgTopacity = 1
    elseif bgTopacity < 0 then
        bgTopacity = 0
    end
    if bgTX > 32 then bgTX = 0 end
    if bgTY < -32 then bgTY = 0 end
end

local function doMassCalculation() -- the most great part of this script
    if mov.bar.type == 1 then
        mov.bar.position = mov.bar.position + mov.bar.speed
    elseif mov.bar.type == 2 then
        mov.bar.position = mov.bar.position - mov.bar.speed
    end
    if mov.board.type == 1 then
        mov.board.position = mov.board.position + mov.board.speed
    elseif mov.board.type == 2 then
        mov.board.position = mov.board.position - mov.board.speed
    end
    if mov.buttons.type == 1 then
        mov.buttons.position = mov.buttons.position + mov.buttons.speed
    elseif mov.buttons.type == 2 then
        mov.buttons.position = mov.buttons.position - mov.buttons.speed
    end

    if mov.bar.position < mov.bar.goal then
        mov.bar.type = 0
        mov.bar.position = mov.bar.goal
    elseif mov.bar.position > mov.bar.origin then
        mov.bar.type = 0
        mov.bar.position = mov.bar.origin
    end
    if mov.board.position > mov.board.goal then
        mov.board.type = 0
        mov.board.position = mov.board.goal
    elseif mov.board.position < mov.board.origin then
        mov.board.type = 0
        mov.board.position = mov.board.origin
    end
    if mov.buttons.position < mov.buttons.goal then
        mov.buttons.type = 0
        mov.buttons.position = mov.buttons.goal
    elseif mov.buttons.position > mov.buttons.origin then
        mov.buttons.type = 0
        mov.buttons.position = mov.buttons.origin
    end

    -- when the shop is properly opened
    if mov.bar.position == mov.bar.goal
    and mov.board.position == mov.board.goal
    and mov.buttons.position == mov.buttons.goal then
        movementOver = true
    end

    -- when the shop is properly closed
    if mov.bar.position == mov.bar.origin
    and mov.board.position == mov.board.origin
    and mov.buttons.position == mov.buttons.origin then
        actBoard = {}
        Misc.unpause()
    end
end

local function drawBoard(v) -- v is the kboard
    local boardIMG
    local buttonSourceX = 0
    local buttonSourceY = 0
    selectorFrame = math.floor(lunatime.drawtick() / 6) % 2

    bgStuff()
    doMassCalculation()

    blinker = blinker + 1
    if blinker > 0 then
        Graphics.drawImageWP(images.caret, mov.bar.position+18 + (#v.text * 18), 153+17, keyboard.leastPriority + 0.2)
    end
    if blinker > 32 then blinker = -32 end

    if v.upper then
        boardIMG = images.boardUpper
    else
        boardIMG = images.boardLower
    end

    if warningOpacity > 0 then
        warningOpacity = warningOpacity - 0.1
        textplus.print{text = warningText, x = 400, y = 570, plaintext = true, font = keyFont, pivot = vector(0.5, 0.5), color = Color(warningOpacity,warningOpacity,warningOpacity,warningOpacity), priority = keyboard.leastPriority + 0.1}
    else
        warningOpacity = 0
    end

    Graphics.drawImageWP(bgTexture, bgTX - 32, bgTY - 32, bgTopacity, keyboard.leastPriority)
    Graphics.drawImageWP(images.textBar, mov.bar.position, 153, keyboard.leastPriority + 0.1)
    Graphics.drawImageWP(boardIMG, mov.board.position, 203, keyboard.leastPriority + 0.1)
    Graphics.drawImageWP(images.buttons, 175, mov.buttons.position, 0, 0, 326, 52, keyboard.leastPriority + 0.1)

    if actBoard.text then
        textplus.print{text = actBoard.text, x = mov.bar.position+18, y = 153+17, plaintext = true, font = keyFont, priority = keyboard.leastPriority + 0.2}
    end

    if selection.x > 0 and selection.y > 0 then
        Graphics.drawImageWP(images.selector, mov.board.position+16+(selection.x-1)*32, 203+16+(selection.y-1)*32, 0, selectorFrame * 32, 32, 32, keyboard.leastPriority + 0.2)
    end

    if v.upper then
        Graphics.drawImageWP(images.buttons, 175+110, mov.buttons.position+2, 110, 106, 52, 48, keyboard.leastPriority + 0.15)
    end

    buttonSourceX = 54 * (buttonSel - 1)

    if buttonSel > 0 then
        if buttonSel ~= 6 then
            buttonSourceY = 54
        else
            if not v.isImportant then
                buttonSourceY = 54
            else
                buttonSourceY = 106
            end
        end
        Graphics.drawImageWP(images.buttons, 175+2+buttonSourceX, mov.buttons.position+2, buttonSourceX+2, buttonSourceY, 52, 48, keyboard.leastPriority + 0.2)
    end
end

local function setButtonSel()
    if selection.x == 1 then
        buttonSel = 1
    elseif selection.x == 2 or selection.x == 3 then
        buttonSel = 2
    elseif selection.x == 4 or selection.x == 5 then
        buttonSel = 3
    elseif selection.x == 6 then
        buttonSel = 4
    elseif selection.x == 7 or selection.x == 8 then
        buttonSel = 5
    elseif selection.x == 9 or selection.x == 10 then
        buttonSel = 6
    end
    selection.x = 0
    selection.y = 0
end

local function setkeySel(y)
    if buttonSel == 1 then
        selection.x = 1
    elseif buttonSel == 2 then
        selection.x = 2
    elseif buttonSel == 3 then
        selection.x = 4
    elseif buttonSel == 4 then
        selection.x = 6
    elseif buttonSel == 5 then
        selection.x = 7
    elseif buttonSel == 6 then
        selection.x = 9
    end
    selection.y = y
    buttonSel = 0
end

function keyboard.create(args)
    local kboard = {
        draw = args.draw or drawBoard,                        -- function that draw this kboard
        limit = args.limit or 22,                             -- how many characters of text can be typed
        isImportant = args.isImportant,                       -- if set to true, players will not be able to close it without putting something
        isImportantButCanBeCancelled = args.isImportantButCanBeCancelled, --If true, the keyboard can be closed without saving changes if it's important
        clear = args.clear,                                   -- some things will be cleared if set to true
        setVariable = args.setVariable or SaveData.savedText, -- set variable for where the text gets entered, e.g. SaveData can be used
        pause = args.pause,                                   -- whether to pause when typing or not
        
        -- don't touch
        text = "",
        upper = false,
        id = #boards + 1,
    }

    table.insert(boards, kboard)
    setmetatable(kboard, keybMT)
    return kboard
end

function keyb:open()
    if self.clear then
        self.text = ""
        self.upper = false
    end 
    actBoard = self
    selection.x = 1
    selection.y = 1
    buttonSel = 0
    if self.pause then
        Misc.pause()
    end
    mov.bar.type = 1
    mov.board.type = 1
    mov.buttons.type = 1
    opacityFadeType = 1
    movementOver = false
end

function keyb:close()    
    mov.bar.type = 2
    mov.board.type = 2
    mov.buttons.type = 2
    opacityFadeType = 2
    movementOver = false
    if not keyboard.closedWithoutValues then
        keyboard.closed = true
    end
end

registerEvent(keyboard, "onInputUpdate")
registerEvent(keyboard, "onDraw")
registerEvent(keyboard, "onPasteText")

function keyboard.onPasteText(pastedText)
    if actBoard.id ~= nil and movementOver then
        actBoard.text = actBoard.text .. pastedText
        Sound.playSFX("console/console_paste.ogg")
        blinker = 1
    end
end

function keyboard.onInputUpdate()
    if actBoard.id ~= nil and movementOver then
        if selection.x > 0 and selection.y > 0 then
            local rngkey = rng.randomInt(1,7)
            if player.keys.up == KEYS_PRESSED or player.keys.down == KEYS_PRESSED or player.keys.left == KEYS_PRESSED or player.keys.right == KEYS_PRESSED then
                Sound.playSFX("console/console_keypress"..rngkey..".ogg")
            end
            if player.keys.up == KEYS_PRESSED then
                if selection.y == 1 then
                    if selection.x == 11 or selection.x == 12 or selection.x == 13 then
                        selection.y = 5
                    else
                        setButtonSel()
                    end
                else
                    selection.y = selection.y - 1
                end
            elseif player.keys.down == KEYS_PRESSED then
                if selection.y == 5 then
                    if selection.x == 11 or selection.x == 12 or selection.x == 13 then
                        selection.y = 1
                    else
                        setButtonSel()
                    end
                else
                    selection.y = selection.y + 1
                end
            elseif player.keys.left == KEYS_PRESSED then
                if selection.x == 1 then
                    selection.x = 13
                else
                    selection.x = selection.x - 1
                end
            elseif player.keys.right == KEYS_PRESSED then
                if selection.x == 13 then
                    selection.x = 1
                else
                    selection.x = selection.x + 1
                end
            elseif player.keys.jump == KEYS_PRESSED then
                Sound.playSFX("console/console_keypressenter.ogg")
                if #actBoard.text < actBoard.limit then
                    if actBoard.upper then
                        actBoard.text = actBoard.text .. getKey(selection.x, selection.y):upper()
                    else
                        actBoard.text = actBoard.text .. getKey(selection.x, selection.y)
                    end
                    blinker = 1
                end
            end
        elseif buttonSel > 0 then
            local rngkey = rng.randomInt(1,7)
            if player.keys.up == KEYS_PRESSED or player.keys.down == KEYS_PRESSED or player.keys.left == KEYS_PRESSED or player.keys.right == KEYS_PRESSED then
                Sound.playSFX("console/console_keypress"..rngkey..".ogg")
            end
            if player.keys.left == KEYS_PRESSED then
                if buttonSel == 1 then
                    buttonSel = 6
                else
                    buttonSel = buttonSel - 1
                end
            elseif player.keys.right == KEYS_PRESSED then
                if buttonSel == 6 then
                    buttonSel = 1
                else
                    buttonSel = buttonSel + 1
                end
            elseif player.keys.up == KEYS_PRESSED then
                setkeySel(5)
            elseif player.keys.down == KEYS_PRESSED then
                setkeySel(1)
            elseif player.keys.jump == KEYS_PRESSED then
                if buttonSel == 1 then --Space bar
                    actBoard.text = actBoard.text .. " "
                    Sound.playSFX("console/console_keypressenter.ogg")
                    blinker = 1
                elseif buttonSel == 2 then --Back space
                    Sound.playSFX("console/console_keypressbackspace.ogg")
                    actBoard.text = actBoard.text:sub(1, -2)
                elseif buttonSel == 3 then --Caps Lock
                    actBoard.upper = not actBoard.upper
                    Sound.playSFX("console/console_keypressenter.ogg")
                elseif buttonSel == 4 then --Clear
                    actBoard.text = ""
                    Sound.playSFX("console/console_resetfont.ogg")
                elseif buttonSel == 5 then --Done!
                    if actBoard.isImportant and actBoard.text:find("[^ ]") then
                        actBoard.setVariable = actBoard.text
                        Sound.playSFX("console/console_success.ogg")
                        actBoard:close()
                    else
                        Sound.playSFX("console/console_error.ogg")
                        warningText = "Please enter something!"
                        warningOpacity = 5
                    end
                elseif buttonSel == 6 then --Exit
                    if (not actBoard.isImportant or actBoard.isImportantButCanBeCancelled) then
                        actBoard.text = ""
                        actBoard.setVariable = actBoard.text
                        Sound.playSFX("console/console_success.ogg")
                        keyboard.closedWithoutValues = true
                        actBoard:close()
                    elseif actBoard.isImportant and not actBoard.isImportantButCanBeCancelled then
                        warningText = "You can't exit!"
                        Sound.playSFX("console/console_error.ogg")
                        warningOpacity = 5
                    end
                end
            end
        end

        if player.keys.altJump == KEYS_PRESSED then
            if #actBoard.text < actBoard.limit then
                actBoard.text = actBoard.text .. " "
                blinker = 1
            end
        elseif player.keys.run == KEYS_PRESSED then
            actBoard.text = actBoard.text:sub(1, -2)
        elseif player.keys.dropItem == KEYS_PRESSED then
            actBoard.upper = not actBoard.upper
        end
    end
end

function keyboard.onDraw()
    if actBoard.id ~= nil then
        actBoard:draw()
    end
    if keyboard.closed then
        keyboard.timer = keyboard.timer - 1
        if keyboard.timer <= 0 then
            if GameData.playernameenter then
                SaveData.playerName = actBoard.text
                if smasbooleans.mainMenuActive then
                    GameData.reopenmenu = true
                end
            end
            if GameData.playerpfpenter then
                SaveData.playerPfp = actBoard.text
                if smasbooleans.mainMenuActive then
                    GameData.reopenmenu = true
                end
            end
            if GameData.playernameenterfirstboot then
                SaveData.playerName = actBoard.text
                if smasbooleans.mainMenuActive then
                    GameData.firstbootkeyboardconfig = true
                end
            end
            keyboard.timer = 2
            keyboard.closed = false
        end
    end
    if keyboard.closedWithoutValues then
        keyboard.timer = keyboard.timer - 1
        if keyboard.timer <= 0 then
            if GameData.playernameenter then
                if smasbooleans.mainMenuActive then
                    GameData.reopenmenu = true
                end
            end
            if GameData.playerpfpenter then
                if smasbooleans.mainMenuActive then
                    GameData.reopenmenu = true
                end
            end
            if GameData.playernameenterfirstboot then
                if smasbooleans.mainMenuActive then
                    GameData.firstbootkeyboardconfig = true
                end
            end
            keyboard.timer = 2
            keyboard.closedWithoutValues = false
        end
    end
end

return keyboard