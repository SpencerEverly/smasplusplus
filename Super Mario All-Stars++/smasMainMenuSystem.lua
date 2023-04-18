local smasMainMenuSystem = {}

local textplus = require("textplus")

smasMainMenuSystem.mainMenuFont = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus-1x.ini")
smasMainMenuSystem.cursorImg = Graphics.loadImageResolved("littleDialogue/bootmenudialog/selector.png")
smasMainMenuSystem.arrowImg = Graphics.loadImageResolved("littleDialogue/bootmenudialog/scrollArrow.png")

function smasMainMenuSystem.onInitAPI()
    registerEvent(smasMainMenuSystem,"onInputUpdate")
    registerEvent(smasMainMenuSystem,"onDraw")
end

local selectionData

if SaveData.pauseplus.selectionData.soundsettings ~= nil then
    selectionData = SaveData.pauseplus.selectionData.soundsettings
end

smasMainMenuSystem.menuTypes = {
    MENU_SELECTABLE = 1,
    MENU_BOOLEAN = 2,
    MENU_NUMBERVALUE = 3,
    MENU_MULTISELECT = 4,
    MENU_DIALOG = 5,
}

smasMainMenuSystem.menuSections = {
    SECTION_MAIN = 1,
    SECTION_MINIGAMES = 2,
    SECTION_SETTINGS_MAIN = 3,
    SECTION_SETTINGS_MANAGE = 4,
    SECTION_SETTINGS_ACCESSIBILITY = 5,
    SECTION_THEMESELECTION = 6,
    SECTION_CLOCKTHEMING = 7,
    SECTION_BATTLEMODELEVELSELECT = 8,
    SECTION_SETTINGS_SAVEDATA = 9,
    SECTION_SETTINGS_MUSICANDSOUNDS = 10,
    DIALOG_SETTINGS_ERASESAVE2 = 11,
}

smasMainMenuSystem.menuItems = {}
smasMainMenuSystem.menuOpen = false
smasMainMenuSystem.onMenu = 1
smasMainMenuSystem.MenuX = 0
smasMainMenuSystem.MenuY = 0
smasMainMenuSystem.MenuXCentered = 150
smasMainMenuSystem.MenuYCentered = 310
smasMainMenuSystem.minShow = 1
smasMainMenuSystem.maxShow = 5
smasMainMenuSystem.worldCurs = 1
smasMainMenuSystem.ScrollDelay = 0
smasMainMenuSystem.PressDelay = 10
smasMainMenuSystem.cursorMove = true
smasMainMenuSystem.isCursorOnMenuItem = false
smasMainMenuSystem.layoutText = {}
smasMainMenuSystem.noBooleanValue = false
smasMainMenuSystem.previousMenuCursor = {}
smasMainMenuSystem.rememberedMenuCursorPositions = {}

smasMainMenuSystem.priority = 3
smasMainMenuSystem.menuLen = 0

smasMainMenuSystem.isOnDialog = false
smasMainMenuSystem.hideMenuOptions = false
smasMainMenuSystem.hideArrows = false
smasMainMenuSystem.hideCursor = false
smasMainMenuSystem.hideTitle = false

--[[smasMainMenuSystem.addSection(args):
section = The menu section, basically where this should be added to.
sectionItem = Which slot this should take place in the menu.
xCenter = Where to center the menu (In X) if needed.
yCenter = Where to center the menu (In Y) if needed.
cantGoBack = Whether to not go back on the section or not.
dialogMessage = Used for the dialog menu type. Can be a message.
]]
function smasMainMenuSystem.addSection(args)
    if args.section == nil then
        error("Must have a section!")
        return
    end
    args.title = args.title or ""
    args.menuBackTo = args.menuBackTo or 1
    args.xCenter = args.xCenter or smasMainMenuSystem.MenuXCentered
    args.yCenter = args.yCenter or smasMainMenuSystem.MenuYCentered
    args.dialogMessage = args.dialogMessage or ""
    if args.cantGoBack == nil then
        args.cantGoBack = false
    end
    if smasMainMenuSystem.menuItems[args.section] == nil then
        smasMainMenuSystem.menuItems[args.section] = {}
    end
    smasMainMenuSystem.menuItems[args.section] = {
        title = args.title,
        menuBackTo = args.menuBackTo,
        xCenter = args.xCenter,
        yCenter = args.yCenter,
        cantGoBack = args.cantGoBack,
    }
end

--[[smasMainMenuSystem.addMenuItem(args):
name = The name of the menu item.
section = The menu section, basically where this should be added to.
sectionItem = Which slot this should take place in the menu.
menuType = The type of the menu.
isFunction = Should this run as a function when hitting jump?
functionToRun = The function to run when isFunction is set.
booleanToUse = The boolean variable to use for toggling this option. This must be a string, and can be set with either SaveData or GameData (See below)
isSaveData = If the boolean takes in SaveData.
isGameData = If the boolean takes in GameData.
numberValue = The number variable to use for toggling this option.
maxNumber = The maximum the numberValue can go when changing the setting.
]]
function smasMainMenuSystem.addMenuItem(args)
    args.name = args.name or "nil"
    if args.section == nil then
        error("Must have a section!")
        return
    end
    if args.sectionItem == nil then
        error("Must have a section item!")
        return
    end
    args.menuType = args.menuType or 1
    if args.isFunction == nil then
        args.isFunction = true
    end
    args.functionToRun = args.functionToRun or (function() end)
    if args.booleanToUse == nil then
        args.booleanToUse = ""
    end
    if args.isSaveData == nil then
        args.isSaveData = false
    end
    if args.isGameData == nil then
        args.isGameData = false
    end
    if args.isPauseplusValue == nil then
        args.isPauseplusValue = false
    end
    args.numberToUse = args.numberToUse or ""
    args.minimumNumber = args.minimumNumber or 1
    args.maxNumber = args.maxNumber or 1
    args.numberStep = args.numberStep or 1
    args.multiSelectValueToUse = args.multiSelectValueToUse or ""
    args.multiSelectValueToSet = args.multiSelectValueToSet or ""

    if smasMainMenuSystem.menuItems[args.section][args.sectionItem] == nil then
        smasMainMenuSystem.menuItems[args.section][args.sectionItem] = {}
    end
    smasMainMenuSystem.menuItems[args.section][args.sectionItem] = {
        name = args.name,
        menuType = args.menuType,
        menuBackTo = args.menuBackTo,
        canRunAsFunction = args.isFunction,
        functionIfPossible = args.functionToRun,
        booleanToUse = args.booleanToUse,
        numberToUse = args.numberToUse,
        minimumNumber = args.minimumNumber,
        maxNumber = args.maxNumber,
        numberStep = args.numberStep,
        multiSelectValueToUse = args.multiSelectValueToUse,
        multiSelectValueToSet = args.multiSelectValueToSet,
        sectionItem = args.sectionItem,
        isSaveData = args.isSaveData,
        isGameData = args.isGameData,
        isPauseplusValue = args.isPauseplusValue
    }
end

function smasMainMenuSystem.getMenuPosition()
    smasMainMenuSystem.MenuX = ScreenW / 2 - smasMainMenuSystem.MenuXCentered
    smasMainMenuSystem.MenuY = ScreenH - smasMainMenuSystem.MenuYCentered
end

function smasMainMenuSystem.handleMouseMove(items,x,y,maxWidth,itemHeight)
    for i = 0,items do
        if (cursor.y >= y + i * itemHeight and cursor.y <= y + 16 + A * itemHeight) then
            if (cursor.x >= x and cursor.x <= x + maxWidth) then
                if (MenuCursor ~= i) then
                    Sound.playSFX(26)
                    MenuCursor = i
                    break
                end
            end
        end
    end
end

function smasMainMenuSystem.runMenuFunction(isMouse)
    local currentOption = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1]
    if currentOption.canRunAsFunction then
        currentOption.functionIfPossible()
        if isMouse then
            smasMainMenuSystem.ScrollDelay = 10
        else
            smasMainMenuSystem.PressDelay = 10
        end
    end
    if currentOption.booleanToUse ~= "" then
        if currentOption.isSaveData then
            SaveData[currentOption.booleanToUse] = not SaveData[currentOption.booleanToUse]
        end
        if currentOption.isGameData then
            GameData[currentOption.booleanToUse] = not GameData[currentOption.booleanToUse]
        end
        if currentOption.isPauseplusValue then
            selectionData[currentOption.booleanToUse] = not selectionData[currentOption.booleanToUse]
        end
        Sound.playSFX(32)
        if isMouse then
            smasMainMenuSystem.ScrollDelay = 10
        else
            smasMainMenuSystem.PressDelay = 10
        end
    end
    if currentOption.multiSelectValueToUse ~= "" then
        if currentOption.isSaveData then
            if SaveData[currentOption.multiSelectValueToUse] ~= currentOption.multiSelectValueToSet then
                Sound.playSFX(32)
            end
            SaveData[currentOption.multiSelectValueToUse] = currentOption.multiSelectValueToSet
        end
        if currentOption.isGameData then
            if GameData[currentOption.multiSelectValueToUse] ~= currentOption.multiSelectValueToSet then
                Sound.playSFX(32)
            end
            GameData[currentOption.multiSelectValueToUse] = currentOption.multiSelectValueToSet
        end
        if currentOption.isPauseplusValue then
            if selectionData[currentOption.multiSelectValueToUse] ~= currentOption.multiSelectValueToSet then
                Sound.playSFX(32)
            end
            selectionData[currentOption.multiSelectValueToUse] = currentOption.multiSelectValueToSet
        end
        if isMouse then
            smasMainMenuSystem.ScrollDelay = 10
        else
            smasMainMenuSystem.PressDelay = 10
        end
    end
end

function smasMainMenuSystem.goToMenuSection(sectionNumber, menuCursor, isGoingBack)
    isGoingBack = isGoingBack or false
    if isGoingBack then
        Sound.playSFX(26)
    else
        Sound.playSFX(29)
    end
    smasMainMenuSystem.onMenu = sectionNumber
    smasMainMenuSystem.PressDelay = 10
    MenuCursor = menuCursor
end

function smasMainMenuSystem.onInputUpdate()
    if smasMainMenuSystem.menuOpen then
        if smasMainMenuSystem.onMenu > 0 then
            if smasMainMenuSystem.PressDelay == 0 then
                for _,p in ipairs(Player.get()) do
                    local currentOption = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1]
                    if p.keys.up == KEYS_PRESSED then
                        if MenuCursor > 0 then
                            MenuCursor = MenuCursor - 1
                            Sound.playSFX(26)
                        else
                            Sound.playSFX(26)
                            MenuCursor = #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu] - 1
                        end
                    elseif p.keys.down == KEYS_PRESSED then
                        if MenuCursor < #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu] - 1 then
                            MenuCursor = MenuCursor + 1
                            Sound.playSFX(26)
                        else
                            Sound.playSFX(26)
                            MenuCursor = 0
                        end
                    elseif p.keys.left == KEYS_PRESSED then
                        if currentOption.numberToUse ~= "" then
                            if currentOption.isSaveData then
                                if SaveData[currentOption.numberToUse] > currentOption.minimumNumber then
                                    Sound.playSFX(26)
                                    SaveData[currentOption.numberToUse] = SaveData[currentOption.numberToUse] - currentOption.numberStep
                                end
                            elseif currentOption.isGameData then
                                if GameData[currentOption.numberToUse] > currentOption.minimumNumber then
                                    Sound.playSFX(26)
                                    GameData[currentOption.numberToUse] = GameData[currentOption.numberToUse] - currentOption.numberStep
                                end
                            elseif currentOption.isPauseplusValue then
                                if selectionData[currentOption.numberToUse] > currentOption.minimumNumber then
                                    Sound.playSFX(26)
                                    selectionData[currentOption.numberToUse] = selectionData[currentOption.numberToUse] - currentOption.numberStep
                                end
                            end
                        end
                    elseif p.keys.right == KEYS_PRESSED then
                        if currentOption.numberToUse ~= "" then
                            if currentOption.isSaveData then
                                if SaveData[currentOption.numberToUse] < currentOption.maxNumber then
                                    Sound.playSFX(26)
                                    SaveData[currentOption.numberToUse] = SaveData[currentOption.numberToUse] + currentOption.numberStep
                                end
                            elseif currentOption.isGameData then
                                if GameData[currentOption.numberToUse] < currentOption.maxNumber then
                                    Sound.playSFX(26)
                                    GameData[currentOption.numberToUse] = GameData[currentOption.numberToUse] + currentOption.numberStep
                                end
                            elseif currentOption.isPauseplusValue then
                                if selectionData[currentOption.numberToUse] < currentOption.maxNumber then
                                    Sound.playSFX(26)
                                    selectionData[currentOption.numberToUse] = selectionData[currentOption.numberToUse] + currentOption.numberStep
                                end
                            end
                        end
                    elseif p.keys.jump == KEYS_PRESSED then
                        smasMainMenuSystem.runMenuFunction(false)
                    elseif p.keys.run == KEYS_PRESSED then
                        if smasMainMenuSystem.onMenu > 1 and not smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].cantGoBack then
                            smasMainMenuSystem.goToMenuSection(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].menuBackTo, 0, true)
                        elseif smasMainMenuSystem.onMenu == 1 then
                            Sound.playSFX(26)
                            MenuCursor = #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu] - 1
                        end
                    end
                end
            end
        end
    end
end

function smasMainMenuSystem.onDraw()
    smasMainMenuSystem.getMenuPosition()
    smasMainMenuSystem.MenuXCentered = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].xCenter
    smasMainMenuSystem.MenuYCentered = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].yCenter
    local currentOption = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1]
    local C = 0
    local original_maxShow = smasMainMenuSystem.maxShow
    
    if smasMainMenuSystem.menuOpen then
        if smasMainMenuSystem.onMenu > 0 then
            smasMainMenuSystem.minShow = 1
            smasMainMenuSystem.maxShow = #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu]
            
            original_maxShow = smasMainMenuSystem.maxShow
            
            if smasMainMenuSystem.PressDelay > 0 then
                smasMainMenuSystem.PressDelay = smasMainMenuSystem.PressDelay - 1
            end
            
            if #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu] > 5 then
                smasMainMenuSystem.minShow = smasMainMenuSystem.worldCurs
                smasMainMenuSystem.maxShow = smasMainMenuSystem.minShow + 4
                
                if (MenuCursor - 1 <= smasMainMenuSystem.minShow - 1) then
                    smasMainMenuSystem.worldCurs = smasMainMenuSystem.worldCurs - 1
                end
                
                if (MenuCursor - 1 >= smasMainMenuSystem.minShow - 1) then
                    smasMainMenuSystem.worldCurs = smasMainMenuSystem.worldCurs + 1
                end
                
                if (smasMainMenuSystem.worldCurs < 1) then
                    smasMainMenuSystem.worldCurs = 1
                end
                
                if (smasMainMenuSystem.worldCurs > original_maxShow - 4) then
                    smasMainMenuSystem.worldCurs = original_maxShow - 4
                end
                
                smasMainMenuSystem.minShow = smasMainMenuSystem.worldCurs
                smasMainMenuSystem.maxShow = smasMainMenuSystem.minShow + 4
            end
            
            if not smasMainMenuSystem.hideTitle then
                textplus.print({pivot = vector.v2(0.5,0.5), x = 400, y = 310, text = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].title, priority = smasMainMenuSystem.priority, font = smasMainMenuSystem.mainMenuFont, xscale = 2, yscale = 2})
            end
            
            for k = smasMainMenuSystem.minShow, smasMainMenuSystem.maxShow do
                local B = k - smasMainMenuSystem.minShow + 1
                local i = 0
                local named = {}
                
                smasMainMenuSystem.layoutText[k] = textplus.layout(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name, 10)
                local namedNum = MenuCursor - smasMainMenuSystem.minShow + 2
                
                named[k] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name
                local naming = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1]
                
                if currentOption.menuType == smasMainMenuSystem.menuTypes.MENU_BOOLEAN then
                    if currentOption.isSaveData then
                        if SaveData[naming.booleanToUse] then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (ON)"
                        elseif not SaveData[naming.booleanToUse] then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (OFF)"
                        end
                    elseif currentOption.isGameData then
                        if GameData[naming.booleanToUse] then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (ON)"
                        elseif not GameData[naming.booleanToUse] then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (OFF)"
                        end
                    elseif currentOption.isPauseplusValue then
                        if selectionData[naming.booleanToUse] then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (ON)"
                        elseif not selectionData[naming.booleanToUse] then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (OFF)"
                        end
                    end
                    
                elseif currentOption.menuType == smasMainMenuSystem.menuTypes.MENU_NUMBERVALUE then
                    if currentOption.isSaveData then
                        named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." ("..tostring(SaveData[smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].numberToUse])..")"
                    elseif currentOption.isGameData then
                        named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." ("..tostring(GameData[smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].numberToUse])..")"
                    elseif currentOption.isPauseplusValue then
                        named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." ("..tostring(selectionData[smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].numberToUse])..")"
                    end
                
                elseif currentOption.menuType == smasMainMenuSystem.menuTypes.MENU_MULTISELECT then
                    if currentOption.isSaveData then
                        if SaveData[naming.multiSelectValueToUse] == naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (ON)"
                        elseif SaveData[naming.multiSelectValueToUse] ~= naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (OFF)"
                        end
                    elseif currentOption.isGameData then
                        if GameData[naming.multiSelectValueToUse] == naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (ON)"
                        elseif GameData[naming.multiSelectValueToUse] ~= naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (OFF)"
                        end
                    elseif currentOption.isPauseplusValue then
                        if selectionData[naming.multiSelectValueToUse] == naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (ON)"
                        elseif selectionData[naming.multiSelectValueToUse] ~= naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (OFF)"
                        end
                    end
                end
                if not smasMainMenuSystem.hideMenuOptions then
                    textplus.print({x = smasMainMenuSystem.MenuX, y = smasMainMenuSystem.MenuY + 30 + (B * 30), text = named[k], priority = smasMainMenuSystem.priority, color = Color.white, font = smasMainMenuSystem.mainMenuFont, xscale = 2, yscale = 2})
                end
                
            end
            
            if smasMainMenuSystem.minShow > 1 then
                if not smasMainMenuSystem.hideArrows then
                    Graphics.drawImageWP(smasMainMenuSystem.arrowImg, ScreenW / 2 - 8, smasMainMenuSystem.MenuY + 44, 0, 0, smasMainMenuSystem.arrowImg.width / 2, smasMainMenuSystem.arrowImg.height, smasMainMenuSystem.priority)
                end
            end
            
            if smasMainMenuSystem.maxShow < original_maxShow then
                if not smasMainMenuSystem.hideArrows then
                    Graphics.drawImageWP(smasMainMenuSystem.arrowImg, ScreenW / 2 - 8, smasMainMenuSystem.MenuY + 204, smasMainMenuSystem.arrowImg.width / 2, 0, 20, smasMainMenuSystem.arrowImg.height, smasMainMenuSystem.priority)
                end
            end
            
            local B = MenuCursor - smasMainMenuSystem.minShow + 1
            
            if(B >= 0 and B < 5) then
                if not smasMainMenuSystem.hideCursor then
                    Graphics.drawImageWP(smasMainMenuSystem.cursorImg, smasMainMenuSystem.MenuX - 20, smasMainMenuSystem.MenuY + 64 + (B * 30), smasMainMenuSystem.priority)
                end
            end
            
            if smasMainMenuSystem.ScrollDelay > 0 then
                smasMainMenuSystem.cursorMove = true
                smasMainMenuSystem.ScrollDelay = smasMainMenuSystem.ScrollDelay - 1
            end
            
            --Cursor stuff
            if smasMainMenuSystem.cursorMove and not Misc.isPaused() then
                C = 0
                for A = smasMainMenuSystem.minShow - 1, smasMainMenuSystem.maxShow - 1 do
                    if (cursor.y >= (smasMainMenuSystem.MenuY + 65) + C * 30 and cursor.y <= (smasMainMenuSystem.MenuY + 65) + C * 30 + 16) then
                        smasMainMenuSystem.menuLen = 19 * (smasMainMenuSystem.layoutText[A + 1].width)
                        
                        if (cursor.x >= smasMainMenuSystem.MenuX and cursor.x <= smasMainMenuSystem.MenuX + smasMainMenuSystem.menuLen) then
                            if (MenuCursor ~= A and smasMainMenuSystem.ScrollDelay == 0) then
                                smasMainMenuSystem.ScrollDelay = 10
                                Sound.playSFX(26)
                                MenuCursor = A
                            end
                            smasMainMenuSystem.isCursorOnMenuItem = true
                            if cursor.left == KEYS_PRESSED then
                                smasMainMenuSystem.runMenuFunction(true)
                            end
                        end
                    else
                        smasMainMenuSystem.isCursorOnMenuItem = false
                    end
                    C = C + 1
                end
            end
        end
    end
end

return smasMainMenuSystem