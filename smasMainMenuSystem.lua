--[[smasMainMenuSystem.lua (v1.0)
By Spencer Everly

For more information, please refer to the comments below.
]]

local smasMainMenuSystem = {}

local textplus = require("textplus")

--Fonts and images. The main font, along with the cursor and arrows used for navigating the menus.
smasMainMenuSystem.mainMenuFont = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus-1x.ini")
smasMainMenuSystem.cursorImg = Graphics.loadImageResolved("littleDialogue/bootmenudialog/selector.png")
smasMainMenuSystem.arrowImg = Graphics.loadImageResolved("littleDialogue/bootmenudialog/scrollArrow.png")

function smasMainMenuSystem.onInitAPI()
    registerEvent(smasMainMenuSystem,"onInputUpdate")
    registerEvent(smasMainMenuSystem,"onDraw")
end

--Temporary variable for audio settings, since they're adjustable on pauseplus
local selectionData

if SaveData.pauseplus.selectionData.soundsettings ~= nil then
    selectionData = SaveData.pauseplus.selectionData.soundsettings
end

--Below are types/sections, all episode-specific.
--First, the menu types (For normal menus/dialog menus)
smasMainMenuSystem.menuMainTypes = {
    MENUMAIN_NORMAL = 1,
    MENUMAIN_DIALOG = 2,
}

--Second, the menu types for a specific menu.
smasMainMenuSystem.menuTypes = {
    MENU_SELECTABLE = 1,
    MENU_BOOLEAN = 2,
    MENU_NUMBERVALUE = 3,
    MENU_MULTISELECT = 4,
}

--Finally, the sections for each menu.
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
    DIALOG_SETTINGS_ERASESAVE1 = 12,
    DIALOG_SETTINGS_CHANGENAME = 13,
    DIALOG_SETTINGS_CHANGEPFP = 14,
    DIALOG_SETTINGS_CHANGEPFP_INFO = 15,
    DIALOG_SETTINGS_INPUTCONFIG = 16,
    DIALOG_SETTINGS_INPUTCONFIG2 = 17,
    DIALOG_SETTINGS_SAVESWITCH = 18,
    DIALOG_SETTINGS_EDITORSAVESWITCH = 19,
    DIALOG_CREDITS = 20,
    DIALOG_BATTLEMODE_NEED2NDPLAYER = 21,
    DIALOG_BATTLEMODE_HAVE2NDPLAYER = 22,
    DIALOG_BATTLEMODE_HAVE13MODEON = 23,
    DIALOG_BATTLEMODE_EXIT = 24,
}

smasMainMenuSystem.menuItems = {} --Used for all the menu items.
smasMainMenuSystem.menuOpen = false --True if open, else it's false.
smasMainMenuSystem.onMenu = smasMainMenuSystem.menuSections.SECTION_MAIN --1 is default. If not 1 then the menu will be on another random menu.
smasMainMenuSystem.MenuX = 0 --Used for centering the menu options.
smasMainMenuSystem.MenuY = 0 --Same as above.
smasMainMenuSystem.MenuXCentered = 150 --The main center calculation for the X position.
smasMainMenuSystem.MenuYCentered = 310 --The main center calculation for the Y position.
smasMainMenuSystem.minShow = 1 --The minimum number of menus to show.
smasMainMenuSystem.maxShow = 5 --We're displaying 5 max, so this is 5.
smasMainMenuSystem.worldCurs = 1 --Used for calculating the position for the menu.
smasMainMenuSystem.ScrollDelay = 0 --Used for the mouse when selecting menu items.
smasMainMenuSystem.PressDelay = 10 --Used for the keyboard/controller when pressing jump on menu items.
smasMainMenuSystem.cursorMove = true --True if we can use the cursor on the menu.
smasMainMenuSystem.isCursorOnMenuItem = false --True if the cursor is on a menu item.
smasMainMenuSystem.layoutText = {} --Textplus layout of the text, when using dialog.

smasMainMenuSystem.priority = 3 --The usual drawing priority for the menu.
smasMainMenuSystem.menuLen = 0 --The length of the selected text. Usually used with the mouse.

smasMainMenuSystem.isOnDialog = false --Usually true if the menu type is a dialog and is active
smasMainMenuSystem.atEndOfDialog = false --Usually true when the dialog text is at the end of the page
smasMainMenuSystem.currentPageMarker = 1 --The current page marker, for the dialog system
smasMainMenuSystem.currentPageCount = 0 --The total pages used for the dialog system.

--Below are settings for hiding certain things and other stuff
smasMainMenuSystem.hideMenuOptions = false --Hides the options. Usually used when the dialog system is active.
smasMainMenuSystem.hideArrows = false --Hides the up/down arrows. Usually used when the dialog system is active.
smasMainMenuSystem.hideCursor = false --Hides the cursor at the left. Usually used when the dialog system is active.
smasMainMenuSystem.hideTitle = false --Hides the title of the menu page. Usually used when the dialog system is active.
smasMainMenuSystem.dontControlMenu = false  --True when the menu can't be controlled.
smasMainMenuSystem.dontRunFunctions = false --True if the functions on a specific menu item can't be ran as a function. Usually used when the dialog system is active.

--[[smasMainMenuSystem.addSection(args):
section = The menu section, basically where this should be added to.
sectionItem = Which slot this should take place in the menu.
xCenter = Where to center the menu (In X) if needed.
yCenter = Where to center the menu (In Y) if needed.
cantGoBack = Whether to not go back on the section or not.
dialogMessage = Used for the dialog menu type. Can be a message.
dialogMessageX = The X position for the dialog message.
dialogMessageY = The Y position for the dialog message.
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
    args.menuMainType = args.menuMainType or smasMainMenuSystem.menuMainTypes.MENUMAIN_NORMAL
    args.dialogMessageX = args.dialogMessageX or 180
    args.dialogMessageY = args.dialogMessageY or 310
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
        menuMainType = args.menuMainType,
        dialogMessage = args.dialogMessage,
        dialogMessageX = args.dialogMessageX,
        dialogMessageY = args.dialogMessageY,
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

local customTags = {}
function customTags.page(fmt, out, args)
    out[#out+1] = {page=true} -- Add page tag to stream
    return fmt
end

function smasMainMenuSystem.parseTextForDialogMessage(text, args)
	local formattedText = textplus.parse(text, {font = smasMainMenuSystem.mainMenuFont, xscale=2, yscale=2, color=Color.white}, customTags, {"page"})

	local pages = {}
	local page = {}
	for _,seg in ipairs(formattedText) do
		if seg.page then
			pages[#pages+1] = page
			page = {}
		else
			page[#page+1] = seg
		end
	end
	pages[#pages+1] = page
	
	return pages
end

function smasMainMenuSystem.getDialogMessage(args)
    args.text = args.text or ""
    args.maxWidth = args.maxWidth or 460
    --Create page list
    local pages = smasMainMenuSystem.parseTextForDialogMessage(args.text)

    --Layout the pages
    for i=1,#pages do
        pages[i] = textplus.layout(pages[i], args.maxWidth)
    end
    
    return pages
end

function smasMainMenuSystem.getMenuPosition()
    smasMainMenuSystem.MenuX = camera.width / 2 - smasMainMenuSystem.MenuXCentered
    smasMainMenuSystem.MenuY = camera.height - smasMainMenuSystem.MenuYCentered
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
    smasMainMenuSystem.currentPageMarker = 1
    local currentOption = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1]
    if currentOption.canRunAsFunction then
        if isMouse then
            smasMainMenuSystem.ScrollDelay = 10
        else
            smasMainMenuSystem.PressDelay = 10
        end
        currentOption.functionIfPossible()
    end
    if currentOption.booleanToUse ~= "" then
        if isMouse then
            smasMainMenuSystem.ScrollDelay = 10
        else
            smasMainMenuSystem.PressDelay = 10
        end
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
    end
    if currentOption.multiSelectValueToUse ~= "" then
        if isMouse then
            smasMainMenuSystem.ScrollDelay = 10
        else
            smasMainMenuSystem.PressDelay = 10
        end
        if currentOption.isSaveData then
            if SaveData[currentOption.multiSelectValueToUse] ~= currentOption.multiSelectValueToSet then
                Sound.playSFX(32)
            end
            SaveData.SMASPlusPlus.options[currentOption.multiSelectValueToUse] = currentOption.multiSelectValueToSet
        end
        if currentOption.isGameData then
            if SaveData.SMASPlusPlus.options[currentOption.multiSelectValueToUse] ~= currentOption.multiSelectValueToSet then
                Sound.playSFX(32)
            end
            SaveData.SMASPlusPlus.options[currentOption.multiSelectValueToUse] = currentOption.multiSelectValueToSet
        end
        if currentOption.isPauseplusValue then
            if selectionData[currentOption.multiSelectValueToUse] ~= currentOption.multiSelectValueToSet then
                Sound.playSFX(32)
            end
            selectionData[currentOption.multiSelectValueToUse] = currentOption.multiSelectValueToSet
        end
    end
end

function smasMainMenuSystem.goToMenuSection(sectionNumber, menuCursor, isGoingBack)
    if isGoingBack == nil then
        isGoingBack = false
    end
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
            local currentSection = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu]
            local currentDialog = smasMainMenuSystem.getDialogMessage{text = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].dialogMessage)}
            if smasMainMenuSystem.PressDelay == 0 then
                for _,p in ipairs(Player.get()) do
                    if not smasMainMenuSystem.dontControlMenu then
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
                            if not smasMainMenuSystem.dontRunFunctions then
                                smasMainMenuSystem.runMenuFunction(false)
                            end
                            if smasMainMenuSystem.isOnDialog then
                                if not smasMainMenuSystem.atEndOfDialog then
                                    smasMainMenuSystem.currentPageMarker = smasMainMenuSystem.currentPageMarker + 1
                                    Sound.playSFX(26)
                                    smasMainMenuSystem.PressDelay = 10
                                end
                            end
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
end

function smasMainMenuSystem.onDraw()
    smasMainMenuSystem.getMenuPosition()
    smasMainMenuSystem.MenuXCentered = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].xCenter
    smasMainMenuSystem.MenuYCentered = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].yCenter
    local currentOption = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1]
    local currentSection = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu]
    local C = 0
    local original_maxShow = smasMainMenuSystem.maxShow
    local currentDialog = smasMainMenuSystem.getDialogMessage{text = transplate.getTranslation(currentSection.dialogMessage)}
    
    if smasMainMenuSystem.PressDelay > 0 then
        smasMainMenuSystem.PressDelay = smasMainMenuSystem.PressDelay - 1
    end
    
    if currentSection.menuMainType == smasMainMenuSystem.menuMainTypes.MENUMAIN_DIALOG then
        smasMainMenuSystem.isOnDialog = true
        if smasMainMenuSystem.isOnDialog and smasMainMenuSystem.currentPageMarker < #currentDialog then
            smasMainMenuSystem.atEndOfDialog = false
            smasMainMenuSystem.hideMenuOptions = true
            smasMainMenuSystem.hideArrows = true
            smasMainMenuSystem.hideCursor = true
            smasMainMenuSystem.dontRunFunctions = true
        elseif smasMainMenuSystem.currentPageMarker >= #currentDialog then
            smasMainMenuSystem.atEndOfDialog = true
            smasMainMenuSystem.hideMenuOptions = false
            smasMainMenuSystem.hideArrows = false
            smasMainMenuSystem.hideCursor = false
            smasMainMenuSystem.dontRunFunctions = false
        end
    else
        smasMainMenuSystem.isOnDialog = false
        smasMainMenuSystem.atEndOfDialog = false
    end
    
    if smasMainMenuSystem.menuOpen then
        if smasMainMenuSystem.onMenu > 0 then
            smasMainMenuSystem.minShow = 1
            smasMainMenuSystem.maxShow = #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu]
            
            original_maxShow = smasMainMenuSystem.maxShow
            
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
                textplus.print({pivot = vector.v2(0.5,0.5), x = Screen.calculateCameraDimensions(400, 1), y = Screen.calculateCameraDimensions(310, 2), text = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].title), priority = smasMainMenuSystem.priority, font = smasMainMenuSystem.mainMenuFont, xscale = 2, yscale = 2})
            end
            
            if smasMainMenuSystem.isOnDialog then
                textplus.render{x = Screen.calculateCameraDimensions(currentSection.dialogMessageX, 1), y = Screen.calculateCameraDimensions(currentSection.dialogMessageY, 2), layout = currentDialog[smasMainMenuSystem.currentPageMarker], priority = smasMainMenuSystem.priority}
            end
            
            for k = smasMainMenuSystem.minShow, smasMainMenuSystem.maxShow do
                local B = k - smasMainMenuSystem.minShow + 1
                local i = 0
                local named = {}
                
                smasMainMenuSystem.layoutText[k] = textplus.layout(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name, 10)
                local namedNum = MenuCursor - smasMainMenuSystem.minShow + 2
                
                named[k] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name)
                local naming = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1]
                
                if currentOption.menuType == smasMainMenuSystem.menuTypes.MENU_BOOLEAN then
                    if currentOption.isSaveData then
                        if SaveData[naming.booleanToUse] then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (ON)"
                        elseif not SaveData[naming.booleanToUse] then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (OFF)"
                        end
                    elseif currentOption.isGameData then
                        if GameData[naming.booleanToUse] then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (ON)"
                        elseif not GameData[naming.booleanToUse] then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (OFF)"
                        end
                    elseif currentOption.isPauseplusValue then
                        if selectionData[naming.booleanToUse] then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (ON)"
                        elseif not selectionData[naming.booleanToUse] then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (OFF)"
                        end
                    end
                    
                elseif currentOption.menuType == smasMainMenuSystem.menuTypes.MENU_NUMBERVALUE then
                    if currentOption.isSaveData then
                        named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." ("..tostring(SaveData[smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].numberToUse])..")"
                    elseif currentOption.isGameData then
                        named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." ("..tostring(GameData[smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].numberToUse])..")"
                    elseif currentOption.isPauseplusValue then
                        named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." ("..tostring(selectionData[smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].numberToUse])..")"
                    end
                
                elseif currentOption.menuType == smasMainMenuSystem.menuTypes.MENU_MULTISELECT then
                    if currentOption.isSaveData then
                        if SaveData.SMASPlusPlus.options[naming.multiSelectValueToUse] == naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (ON)"
                        elseif SaveData.SMASPlusPlus.options[naming.multiSelectValueToUse] ~= naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (OFF)"
                        end
                    elseif currentOption.isGameData then
                        if GameData.SMASPlusPlus.options[naming.multiSelectValueToUse] == naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (ON)"
                        elseif GameData.SMASPlusPlus.options[naming.multiSelectValueToUse] ~= naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (OFF)"
                        end
                    elseif currentOption.isPauseplusValue then
                        if selectionData[naming.multiSelectValueToUse] == naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (ON)"
                        elseif selectionData[naming.multiSelectValueToUse] ~= naming.multiSelectValueToSet then
                            named[MenuCursor + 1] = transplate.getTranslation(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name).." (OFF)"
                        end
                    end
                end
                if not smasMainMenuSystem.hideMenuOptions then
                    textplus.print({x = smasMainMenuSystem.MenuX, y = smasMainMenuSystem.MenuY + 30 + (B * 30), text = named[k], priority = smasMainMenuSystem.priority, color = Color.white, font = smasMainMenuSystem.mainMenuFont, xscale = 2, yscale = 2})
                end
                
            end
            
            if smasMainMenuSystem.minShow > 1 then
                if not smasMainMenuSystem.hideArrows then
                    Graphics.drawImageWP(smasMainMenuSystem.arrowImg, camera.width / 2 - 8, smasMainMenuSystem.MenuY + 44, 0, 0, smasMainMenuSystem.arrowImg.width / 2, smasMainMenuSystem.arrowImg.height, smasMainMenuSystem.priority)
                end
            end
            
            if smasMainMenuSystem.maxShow < original_maxShow then
                if not smasMainMenuSystem.hideArrows then
                    Graphics.drawImageWP(smasMainMenuSystem.arrowImg, camera.width / 2 - 8, smasMainMenuSystem.MenuY + 204, smasMainMenuSystem.arrowImg.width / 2, 0, 20, smasMainMenuSystem.arrowImg.height, smasMainMenuSystem.priority)
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