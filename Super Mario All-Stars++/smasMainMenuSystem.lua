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
smasMainMenuSystem.cursorMove = true
smasMainMenuSystem.layoutText = {}

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
    if smasMainMenuSystem.menuItems[args.section] == nil then
        smasMainMenuSystem.menuItems[args.section] = {}
    end
end

--[[smasMainMenuSystem.addMenuItem(args):
name = The name of the menu item.
section = The menu section, basically where this should be added to.
sectionItem = Which slot this should take place in the menu.
menuType = The type of the menu.
isFunction = Should this run as a function when hitting jump?
functionToRun = The function to run when isFunction is set.
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
    args.menuType = menuType or 1
    args.isFunction = isFunction or true
    args.functionToRun = functionToRun or (function() end)
    if smasMainMenuSystem.menuItems[args.section][args.sectionItem] == nil then
        smasMainMenuSystem.menuItems[args.section][args.sectionItem] = {}
    end
    smasMainMenuSystem.menuItems[args.section][args.sectionItem] = {
        name = args.name,
        menuType = args.menuType,
        canRunAsFunction = args.isFunction,
        functionIfPossible = args.functionToRun,
    }
end

function smasMainMenuSystem.getMenuPosition()
    smasMainMenuSystem.MenuX = ScreenW / 2 - 150
    smasMainMenuSystem.MenuY = ScreenH - 310
end

function smasMainMenuSystem.handleMouseMove(items,x,y,maxWidth,itemHeight)
    for i = 0,items do
        if (cursor.sceneY >= y + i * itemHeight and cursor.sceneY <= y + 16 + A * itemHeight) then
            if (cursor.sceneX >= x and cursor.sceneY <= x + maxWidth) then
                if (MenuCursor ~= i) then
                    Sound.playSFX(26)
                    MenuCursor = i
                    break
                end
            end
        end
    end
end

function smasMainMenuSystem.onInputUpdate()
    if smasMainMenuSystem.menuOpen then
        if smasMainMenuSystem.onMenu > 0 then
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
                    
                elseif p.keys.right == KEYS_PRESSED then
                    
                end
                if p.keys.jump == KEYS_PRESSED then
                    if smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].canRunAsFunction then
                        smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][MenuCursor + 1].functionIfPossible()
                    end
                end
            end
        end
    end
end

function smasMainMenuSystem.onDraw()
    smasMainMenuSystem.getMenuPosition()
    
    if smasMainMenuSystem.menuOpen then
        if smasMainMenuSystem.onMenu > 0 then
            smasMainMenuSystem.minShow = 1
            smasMainMenuSystem.maxShow = #smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu]
            
            local original_maxShow = smasMainMenuSystem.maxShow
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
            for k = smasMainMenuSystem.minShow, smasMainMenuSystem.maxShow do
                --for j = 1,#smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu] do
                local B = k - smasMainMenuSystem.minShow + 1
                local i = 0 --smasMainMenuSystem.MenuY + 30 * (i + j)
                
                smasMainMenuSystem.layoutText[k] = textplus.layout(smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name, 10)
                
                textplus.print({x = smasMainMenuSystem.MenuX, y = smasMainMenuSystem.MenuY + 30 + (B * 30), text = smasMainMenuSystem.menuItems[smasMainMenuSystem.onMenu][k].name, priority = smasMainMenuSystem.priority, color = Color.white, font = smasMainMenuSystem.mainMenuFont, xscale = 2, yscale = 2})
                
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
            if smasMainMenuSystem.cursorMove then
                local B = 0
                
                for A = smasMainMenuSystem.minShow - 1, smasMainMenuSystem.maxShow - 1 do
                    if (cursor.y >= smasMainMenuSystem.MenuY + B * 30 and cursor.y <= smasMainMenuSystem.MenuY + B * 30) then
                        smasMainMenuSystem.menuLen = 19 * smasMainMenuSystem.layoutText[A + 1].width
                        
                        if (cursor.x >= smasMainMenuSystem.MenuX and cursor.x <= smasMainMenuSystem.MenuX + smasMainMenuSystem.menuLen) then
                            Graphics.drawBox{
                                color = Color.brown..0.5,
                                x = smasMainMenuSystem.MenuX,
                                y = smasMainMenuSystem.MenuY + B * 30,
                                width = smasMainMenuSystem.MenuX + smasMainMenuSystem.menuLen,
                                height = smasMainMenuSystem.MenuY + B * 30 + 16,
                            }
                            if (MenuCursor ~= A and smasMainMenuSystem.ScrollDelay == 0) then
                                smasMainMenuSystem.ScrollDelay = 10
                                Sound.playSFX(26)
                                MenuCursor = A
                            end
                        end
                    end
                    B = B + 1
                end
                if cursor.left == KEYS_PRESSED then
                    
                end
            end
        end
    end
end

return smasMainMenuSystem