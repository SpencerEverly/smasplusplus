local smasMainMenuSystem = {}

local textplus = require("textplus")

smasMainMenuSystem.mainMenuFont = textplus.loadFont("littleDialogue/font/hardcoded-45-2-textplus-1x.ini")
smasMainMenuSystem.cursorImg = Graphics.loadImageResolved("littleDialogue/bootmenudialog/selector.png")

function smasMainMenuSystem.onInitAPI()
    registerEvent(smasMainMenuSystem,"onInputUpdate")
    registerEvent(smasMainMenuSystem,"onDraw")
end

smasMainMenuSystem.menuTypes = {
    MENU_SELECTABLE = 1,
    MENU_BOOLEAN = 2,
    MENU_NUMBERVALUE = 3,
}

smasMainMenuSystem.menuSections = {
    SECTION_MAIN = 1,
    SECTION_MINIGAMES = 2,
    SECTION_SETTINGS_MAIN = 3,
}

smasMainMenuSystem.menuItems = {}
smasMainMenuSystem.menuOpen = false
smasMainMenuSystem.onMenu = 1
smasMainMenuSystem.MenuX = 0
smasMainMenuSystem.MenuY = 0
smasMainMenuSystem.minShow = 1
smasMainMenuSystem.maxShow = 5
smasMainMenuSystem.worldCurs = 1
smasMainMenuSystem.ScrollDelay = 0
smasMainMenuSystem.PressDelay = 10
smasMainMenuSystem.cursorMove = true
smasMainMenuSystem.layoutText = {}
smasMainMenuSystem.noBooleanValue = false
smasMainMenuSystem.previousMenuCursor = {}

smasMainMenuSystem.priority = 3
smasMainMenuSystem.menuLen = 0

--[[smasMainMenuSystem.addSection(args):
section = The menu section, basically where this should be added to.
sectionItem = Which slot this should take place in the menu.
]]
function smasMainMenuSystem.addSection(args)
    if args.section == nil then
        error("Must have a section!")
        return
    end
    args.title = args.title or ""
    args.menuBackTo = args.menuBackTo or 1
    if smasMainMenuSystem.menuItems[args.section] == nil then
        smasMainMenuSystem.menuItems[args.section] = {}
    end
    smasMainMenuSystem.menuItems[args.section] = {
        title = args.title,
        menuBackTo = args.menuBackTo
    }
end

--[[smasMainMenuSystem.addMenuItem(args):
name = The name of the menu item.
section = The menu section, basically where this should be added to.
sectionItem = Which slot this should take place in the menu.
menuType = The type of the menu.
isFunction = Should this run as a function when hitting jump?
functionToRun = The function to run when isFunction is set.
booleanValue = The boolean variable to use for toggling this option.
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
    args.booleanValue = args.booleanValue or smasMainMenuSystem.noBooleanValue
    args.numberValue = args.numberValue or 1
    args.maxNumber = args.maxNumber or 1
    if smasMainMenuSystem.menuItems[args.section][args.sectionItem] == nil then
        smasMainMenuSystem.menuItems[args.section][args.sectionItem] = {}
    end
    smasMainMenuSystem.menuItems[args.section][args.sectionItem] = {
        name = args.name,
        menuType = args.menuType,
        menuBackTo = args.menuBackTo,
        canRunAsFunction = args.isFunction,
        functionIfPossible = args.functionToRun,
        booleanToUse = args.booleanValue,
        numberToUse = args.numberValue,
        maxNumber = args.maxNumber,
        sectionItem = args.sectionItem,
    }
end

function smasMainMenuSystem.getMenuPosition()
    smasMainMenuSystem.MenuX = ScreenW / 2 - 150
    smasMainMenuSystem.MenuY = ScreenH - 310
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
                    if p.keys.up == KEYS_PRESSED then
                        if MenuCursor > 0 then
                            MenuCursor = MenuCursor - 1
                            Sound.playSFX(26)
                        end
                    elseif p.keys.down == KEYS_PRESSED then
                        if MenuCursor < #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu] - 1 then
                            MenuCursor = MenuCursor + 1
                            Sound.playSFX(26)
                        end
                    elseif p.keys.left == KEYS_PRESSED then
                        if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse ~= nil then
                            if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].maxNumber ~= nil then
                                if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse > -1 then
                                    smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse - 1
                                end
                            end
                        end
                    elseif p.keys.right == KEYS_PRESSED then
                        if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse ~= nil then
                            if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].maxNumber ~= nil then
                                if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse < smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].maxNumber then
                                    smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].numberToUse + 1
                                end
                            end
                        end
                    elseif p.keys.jump == KEYS_PRESSED then
                        if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].canRunAsFunction then
                            smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].functionIfPossible()
                            smasMainMenuSystem.PressDelay = 10
                        end
                        if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].booleanToUse ~= nil and not smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].canRunAsFunction then
                            smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].booleanToUse = not smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].booleanToUse
                            Sound.playSFX(32)
                            smasMainMenuSystem.PressDelay = 10
                        end
                    elseif p.keys.run == KEYS_PRESSED then
                        if smasMainMenuSystem.onMenu > 1 then
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
    local C = 0
    
    if smasMainMenuSystem.menuOpen then
        if smasMainMenuSystem.onMenu > 0 then
            smasMainMenuSystem.minShow = 1
            smasMainMenuSystem.maxShow = #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu]
            
            local original_maxShow = smasMainMenuSystem.maxShow
            
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
            
            textplus.print({pivot = vector.v2(0.5,0.5), x = 400, y = 310, text = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu].title, priority = smasMainMenuSystem.priority, font = smasMainMenuSystem.mainMenuFont, xscale = 2, yscale = 2})
            
            for k = smasMainMenuSystem.minShow, smasMainMenuSystem.maxShow do
                --for j = 1,#smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu] do
                local B = k - smasMainMenuSystem.minShow + 1
                local i = 0 --smasMainMenuSystem.MenuY + 30 * (i + j)
                local named = {}
                
                smasMainMenuSystem.layoutText[k] = textplus.layout(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name, 10)
                local named2 = MenuCursor + 1
                
                if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].menuType == smasMainMenuSystem.menuTypes.MENU_SELECTABLE then
                    named[k] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name
                elseif smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].menuType == smasMainMenuSystem.menuTypes.MENU_BOOLEAN then
                    if not smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].booleanToUse then
                        named[k] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (ON)"
                    elseif smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].booleanToUse then
                        named[k] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." (OFF)"
                    end
                elseif smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].menuType == smasMainMenuSystem.menuTypes.MENU_NUMBERVALUE then
                    named[k] = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name.." ("..tostring(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].numberToUse)..")"
                end
                textplus.print({x = smasMainMenuSystem.MenuX, y = smasMainMenuSystem.MenuY + 30 + (B * 30), text = named[k], priority = smasMainMenuSystem.priority, color = Color.white, font = smasMainMenuSystem.mainMenuFont, xscale = 2, yscale = 2})
                
            end
            
            if smasMainMenuSystem.minShow > 1 then
                --Graphics.drawImageWP(smasMainMenuSystem.cursorImg, smasMainMenuSystem.MenuX - 20, smasMainMenuSystem.MenuY - 20, smasMainMenuSystem.priority)
            end
            
            if smasMainMenuSystem.maxShow < smasMainMenuSystem.maxShow then
                --Graphics.drawImageWP(smasMainMenuSystem.cursorImg, smasMainMenuSystem.MenuX - 20, smasMainMenuSystem.MenuY + 140, smasMainMenuSystem.priority)
            end
            
            local B = MenuCursor - smasMainMenuSystem.minShow + 1
            
            if(B >= 0 and B < 5) then
                Graphics.drawImageWP(smasMainMenuSystem.cursorImg, smasMainMenuSystem.MenuX - 20, smasMainMenuSystem.MenuY + 64 + (B * 30), smasMainMenuSystem.priority)
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
                            if cursor.left == KEYS_PRESSED then
                                if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].canRunAsFunction then
                                    smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].functionIfPossible()
                                    smasMainMenuSystem.ScrollDelay = 10
                                end
                                if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].booleanToUse ~= nil and not smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].canRunAsFunction then
                                    smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].booleanToUse = not smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].booleanToUse
                                    Sound.playSFX(32)
                                    smasMainMenuSystem.ScrollDelay = 10
                                end
                            end
                        end
                    end
                    C = C + 1
                end
            end
        end
    end
end

return smasMainMenuSystem