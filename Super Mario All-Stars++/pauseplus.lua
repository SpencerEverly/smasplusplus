--[[

    pauseplus.lua v1.0
    by MrDoubleA

    This library creates an easy way to make a custom pause menu.
    Config settings are at the bottom of the file.

    Documentation: <Not released yet lol, got permission to use, DON'T STEAL OR ELSE MDA WILL LITERALLY COME TO YOUR HOUSE AND->
    
]]
--[[
    TO DO:
    - Write docs
    - Create example level
]]

local textplus = require("textplus")

local pauseplus = {}


pauseplus.SELECTION_CHECKBOX = 0
pauseplus.SELECTION_NUMBERS  = 1
pauseplus.SELECTION_NAMES    = 2


pauseplus.submenus = {}
pauseplus.submenuNames = {}

pauseplus.currentSubmenu = nil
pauseplus.currentOption  = nil
currentOption  = nil

pauseplus.opener = nil -- The player that opened the menu

pauseplus.currentMusicVolume = nil
pauseplus.originalMusicVolume = nil
pauseplus.lowerMusicVolume = nil


-- Used for the resizing transitions
pauseplus.boxDisplaySize = vector.zero2
pauseplus.boxTotalSize = vector.zero2
pauseplus.inResizingTransition = false


pauseplus.history = {}


pauseplus.screenDarkness = {0,0}


-- Use this to disable pausing during a cutscene and whatnot.
pauseplus.canPause = true
-- Use this to disable moving around / choosing options.
pauseplus.canControlMenu = true


SaveData.pauseplus = SaveData.pauseplus or {}


SaveData.pauseplus.selectionData = SaveData.pauseplus.selectionData or {}
local selectionData = SaveData.pauseplus.selectionData

local selectionNames = {}


-- Convenience functions
local function playSFX(sfx)
    if sfx ~= nil then
        SFX.play(sfx)
    end
end
local function loadImage(image)
    if type(image) == "string" then
        image = Graphics.loadImageResolved(image)
    end

    return image
end

local function round(x)
    if x%1 < 0.5 then
        return math.floor(x)
    else
        return math.ceil(x)
    end
end

local function getOptionSaveName(text)
    return (text or ""):lower()
    --return (text or "")
end

local function getPlayerCamera(p)
    for _,p in ipairs(Player.get()) do
        return (camera2.isSplit and Camera(p.idx)) or camera
    end
end



-- Functions for outside use
do
    local function submenuExistanceCheck(name)
        if pauseplus.submenus[name] == nil then
            error("Submenu '".. name.. "' does not exist.")
        end
    end


    function pauseplus.open(submenu,option,opener,isSilent)
        if pauseplus.currentSubmenu == nil and not isSilent then
            playSFX(pauseplus.openSFX)
            smasbooleans.toggleOffInventory = true
        end

        submenuExistanceCheck(submenu or "main")


        pauseplus.currentSubmenu = submenu or "main"
        pauseplus.currentOption  = option  or 1
        currentOption = option  or 1

        pauseplus.opener = opener or pauseplus.opener or Player(1)


        pauseplus.refreshAssets()

        if pauseplus.doResizing then
            pauseplus.inResizingTransition = true
        else
            pauseplus.inResizingTransition = false
            pauseplus.boxDisplaySize = vector(pauseplus.boxTotalSize.x,pauseplus.boxTotalSize.y)
        end

        Misc.pause()
    end

    function pauseplus.close(isSilent)
        if pauseplus.currentSubmenu ~= nil and not isSilent then
            playSFX(pauseplus.closeSFX)
            smasbooleans.toggleOffInventory = false
        end
        
        if not isOverworld then
            for k,p in ipairs(Player.get()) do
                p:mem(0x11E,FIELD_BOOL,false) -- stop the player jumping
                p:mem(0x172,FIELD_BOOL,false) -- stop the player using fire flower
            end
        else
            pauseplus.opener:mem(0x17A,FIELD_BOOL,false) -- stop the player starting a level
        end


        pauseplus.currentSubmenu = nil
        pauseplus.currentOption  = nil
        currentOption = nil

        pauseplus.opener = nil


        pauseplus.history = {}


        pauseplus.boxTotalSize = vector.zero2

        if pauseplus.doResizing then
            pauseplus.inResizingTransition = true
        else
            Misc.unpause()
        end
    end


    function pauseplus.createSubmenu(name,settings)
        name     = name     or "main"
        settings = settings or {}

        local alreadyExisted = (pauseplus.submenus[name] ~= nil)

        pauseplus.submenus[name] = settings
        local submenuObj = pauseplus.submenus[name]


        submenuObj.headerImage = loadImage(submenuObj.headerImage)

        submenuObj.options = submenuObj.options or {}
        submenuObj.name = name


        if not alreadyExisted then
            table.insert(pauseplus.submenuNames,name)
        end
    end

    local selectionDefaults = {[pauseplus.SELECTION_CHECKBOX] = false,[pauseplus.SELECTION_NUMBERS] = 0,[pauseplus.SELECTION_NAMES] = 1}
    function pauseplus.createOption(submenu,settings,insertPosition)
        submenu  = submenu  or "main"

        submenuExistanceCheck(submenu)


        local submenuObj = pauseplus.submenus[submenu]


        -- Create the selection option
        if settings.selectionType ~= nil then
            local name = getOptionSaveName(settings.text)

            selectionData[submenu] = selectionData[submenu] or {}

            if selectionData[submenu][name] == nil then
                selectionData[submenu][name] = settings.selectionDefault or settings.selectionMin or selectionDefaults[settings.selectionType]
            end

            if settings.selectionType == pauseplus.SELECTION_NAMES then
                selectionNames[submenu] = selectionNames[submenu] or {}
                selectionNames[submenu][name] = settings.selectionNames
            end
        end

        
        table.insert(submenuObj.options,insertPosition or #submenuObj.options+1,settings)
    end
    
    
    function pauseplus.removeOption(submenu,option)
        submenu  = submenu  or "main"

        submenuExistanceCheck(submenu)

        local submenuObj = pauseplus.submenus[submenu]

        if option == nil then -- Search every menu
            option = submenu

            for _,submenuName in ipairs(pauseplus.submenuNames) do
                local value = pauseplus.getSelectionValue(submenuName,option)

                if value ~= nil then
                    return value
                end
            end

            return nil
        end
        

        if selectionData[submenu] == nil then
            return
        end

        local name = getOptionSaveName(option)
        local value = selectionData[submenu][name]

        if value == nil then
            return
        end
        
        
        if selectionNames[submenu] ~= nil and selectionNames[submenu][name] ~= nil then
            value = selectionNames[submenu][name][value]
        end
        
        table.remove(submenuObj.options,option or #submenuObj.options-1,settings)
    end


    function pauseplus.getSelectionValue(submenu,option)
        if option == nil then -- Search every menu
            option = submenu

            for _,submenuName in ipairs(pauseplus.submenuNames) do
                local value = pauseplus.getSelectionValue(submenuName,option)

                if value ~= nil then
                    return value
                end
            end

            return nil
        end
        

        if selectionData[submenu] == nil then
            return
        end

        local name = getOptionSaveName(option)
        local value = selectionData[submenu][name]

        if value == nil then
            return
        end
        
        
        if selectionNames[submenu] ~= nil and selectionNames[submenu][name] ~= nil then
            value = selectionNames[submenu][name][value]
        end

        return value
    end



    function pauseplus.quit()
        playSFX(pauseplus.quitgameSFX)
        if Misc.inEditor() and not isOverworld then
            Level.load("map.lvlx")
        else
            Misc.exitEngine()
            
            --Graphics.drawScreen{color = Color.black,priority = 100} -- If this isn't done, you can see the title screen text on the level for a bit
            --Misc.exitGame()
        end

        Misc.unpause()
    end
    function pauseplus.save()
        Misc.saveGame()
        SFX.play(pauseplus.saveSFX)
    end

    function pauseplus.exitLevel()
        Level.load("map.lvlx")

        Misc.unpause()
    end    

    local START_LEVEL_ADDR = 0x00B25724
    local HUB_WORLD_ADDR   = 0x00B25728
    function pauseplus.defaultCanSave()
        return (
            not Defines.player_hasCheated
            and (
                isOverworld
                or mem(START_LEVEL_ADDR,FIELD_STRING) == Level.filename() and mem(HUB_WORLD_ADDR,FIELD_BOOL) -- In the HUB world
            )
        )
    end


    function pauseplus.createDefaultMenu(canSave,saveSFX) -- Creates a copy of the default menu.
        if canSave == nil then
            -- If canSave is not set, default to true if the player is on the overworld or in the HUB.
            canSave = pauseplus.defaultCanSave()
        end
        if saveSFX == nil then
            -- If saveSFX is not set, use the checkpoint sound. While this isn't accurate, no sound effect can be confusing.
            -- If you really want to remove it, just make it 'false'.
            saveSFX = 58
        else
            saveSFX = saveSFX or nil
        end


        pauseplus.createSubmenu("main",{})

        pauseplus.createOption("main",{text = "Continue",closeMenu = true})

        if canSave then
            pauseplus.createOption("main",{text = "Save & Continue",action = pauseplus.save,sfx = saveSFX,closeMenu = true})
            pauseplus.createOption("main",{text = "Save & Quit Game",actions = {pauseplus.save,pauseplus.quit}})
        else
            pauseplus.createOption("main",{text = "Quit Game",action = pauseplus.quit})
        end
    end
end


-- Menu rendering
do
    local selectionTypesWithText = table.map{pauseplus.SELECTION_NUMBERS,pauseplus.SELECTION_NAMES}

    local function getBaseSize()
        return vector(pauseplus.horizontalSpace,pauseplus.verticalSpace)*2*pauseplus.scale
    end
    local function getBaseFormat(font,color,scale)
        return {font = font or pauseplus.font,color = color,xscale = (scale or 1)*pauseplus.scale,yscale = (scale or 1)*pauseplus.scale}
    end

    local nilLayout
    local function getNilLayout() -- Failsafe
        nilLayout = nilLayout or textplus.layout("INVALID",nil,getBaseFormat(nil,Color.lightred,nil))
        return nilLayout
    end


    local headerTextLayout
    local largestOptionWidth

    function pauseplus.refreshAssets(c)
        c = c or getPlayerCamera(pauseplus.opener)


        local submenuObj = pauseplus.submenus[pauseplus.currentSubmenu]

        headerTextLayout = nil
        largestOptionWidth = 0

        pauseplus.boxTotalSize = vector(0,0)


        local maxWidth = (c.width-(getBaseSize().x*2))
        local gapHeight = (pauseplus.optionGap*pauseplus.scale)


        local noOptions = (#submenuObj.options == 0)


        if submenuObj.headerImage ~= nil then
            local image = submenuObj.headerImage

            pauseplus.boxTotalSize.x = math.max(pauseplus.boxTotalSize.x,image.width)
            pauseplus.boxTotalSize.y = pauseplus.boxTotalSize.y + image.height

            if not noOptions or submenuObj.headerText ~= nil then
                pauseplus.boxTotalSize.y = pauseplus.boxTotalSize.y + gapHeight
            end

            maxWidth = math.max(maxWidth,image.width)
        end


        if submenuObj.headerText ~= nil then
            local fmt = getBaseFormat(submenuObj.headerTextFont,submenuObj.headerTextColor,submenuObj.headerTextScale)
            headerTextLayout = textplus.layout(submenuObj.headerText,maxWidth,fmt)

            pauseplus.boxTotalSize.x = math.max(pauseplus.boxTotalSize.x,headerTextLayout.width)
            pauseplus.boxTotalSize.y = pauseplus.boxTotalSize.y + headerTextLayout.height

            if not noOptions then
                pauseplus.boxTotalSize.y = pauseplus.boxTotalSize.y + gapHeight
            end
        end


        local tallestDescriptionHeight = 0

        for index,optionObj in ipairs(submenuObj.options) do
            local fmt = getBaseFormat(optionObj.font,optionObj.color,optionObj.scale)
            optionObj.layout = textplus.layout(optionObj.text or "",maxWidth,fmt)

            optionObj.size = vector(optionObj.layout.width,optionObj.layout.height)

            if optionObj.selectionType == pauseplus.SELECTION_CHECKBOX then
                optionObj.size.x = optionObj.size.x + (pauseplus.checkboxImage.width*2*pauseplus.scale)
                optionObj.size.y = math.max(optionObj.size.y,pauseplus.checkboxImage.height)
            elseif selectionTypesWithText[optionObj.selectionType] then
                optionObj.selectionHighestWidth = 0
                optionObj.selectionLayouts = {}

                if optionObj.selectionType == pauseplus.SELECTION_NUMBERS then
                    local step = (optionObj.selectionStep or 1)

                    if step == 0 then
                        error("Cannot use a step size of 0.")
                    end

                    for index=optionObj.selectionMin,optionObj.selectionMax,step do
                        index = round(index/step)*step -- oh, floating point imprecision


                        local layout = textplus.layout(tostring(index),nil,fmt)
                        
                        optionObj.selectionHighestWidth = math.max(optionObj.selectionHighestWidth,layout.width)
                        optionObj.size.y = math.max(optionObj.size.y,layout.height)

                        optionObj.selectionLayouts[index] = layout
                    end
                elseif optionObj.selectionType == pauseplus.SELECTION_NAMES then
                    for i,name in ipairs(optionObj.selectionNames) do
                        local layout = textplus.layout(tostring(name),nil,fmt)
                        
                        optionObj.selectionHighestWidth = math.max(optionObj.selectionHighestWidth,layout.width)
                        optionObj.size.y = math.max(optionObj.size.y,layout.height)

                        optionObj.selectionLayouts[i] = layout
                    end
                end

                optionObj.size.x = optionObj.size.x + optionObj.selectionHighestWidth + (pauseplus.cursorImage.width*2*pauseplus.scale)
            end


            if optionObj.description ~= nil then
                local fmt = getBaseFormat(optionObj.descriptionFont,optionObj.descriptionColor,optionObj.descriptionScale)
                optionObj.descriptionLayout = textplus.layout(optionObj.description or "",maxWidth,fmt)

                pauseplus.boxTotalSize.x = math.max(pauseplus.boxTotalSize.x,optionObj.size.x)
                optionObj.size.x = math.max(optionObj.size.x,optionObj.descriptionLayout.width)

                tallestDescriptionHeight = math.max(tallestDescriptionHeight,optionObj.descriptionLayout.height)
            end


            pauseplus.boxTotalSize.x = math.max(pauseplus.boxTotalSize.x,optionObj.size.x)
            pauseplus.boxTotalSize.y = pauseplus.boxTotalSize.y + optionObj.size.y

            largestOptionWidth = math.max(largestOptionWidth,optionObj.size.x)

            if index < #submenuObj.options then
                pauseplus.boxTotalSize.y = pauseplus.boxTotalSize.y + gapHeight
            end
        end



        if tallestDescriptionHeight ~= 0 then
            pauseplus.boxTotalSize.y = pauseplus.boxTotalSize.y + tallestDescriptionHeight
        end


        pauseplus.boxTotalSize = pauseplus.boxTotalSize + getBaseSize()


        return pauseplus.boxTotalSize,headerTextLayout,largestOptionWidth
    end


    local function addQuadToGlDraw(vertexCoords,textureCoords,x,y,width,height,sourceX,sourceY,sourceWidth,sourceHeight)
        local count = #vertexCoords

        local x1 = x
        local y1 = y
        local x2 = x1 + width
        local y2 = y1 + height

        vertexCoords[count + 1] = x1
        vertexCoords[count + 2] = y1
        vertexCoords[count + 3] = x1
        vertexCoords[count + 4] = y2
        vertexCoords[count + 5] = x2
        vertexCoords[count + 6] = y1
        vertexCoords[count + 7] = x1
        vertexCoords[count + 8] = y2
        vertexCoords[count + 9] = x2
        vertexCoords[count + 10] = y1
        vertexCoords[count + 11] = x2
        vertexCoords[count + 12] = y2


        local x1 = sourceX
        local y1 = sourceY
        local x2 = sourceX + sourceWidth
        local y2 = sourceY + sourceHeight

        textureCoords[count + 1] = x1
        textureCoords[count + 2] = y1
        textureCoords[count + 3] = x1
        textureCoords[count + 4] = y2
        textureCoords[count + 5] = x2
        textureCoords[count + 6] = y1
        textureCoords[count + 7] = x1
        textureCoords[count + 8] = y2
        textureCoords[count + 9] = x2
        textureCoords[count + 10] = y1
        textureCoords[count + 11] = x2
        textureCoords[count + 12] = y2
    end

    local function drawBox(image,priority,x,y,width,height)
        local segmentWidth  = (image.width /3)*pauseplus.scale
        local segmentHeight = (image.height/3)*pauseplus.scale

        local vertexCoords = {}
        local textureCoords = {}


        local segmentCountX = math.max(2,math.ceil(width  / segmentWidth ))
        local segmentCountY = math.max(2,math.ceil(height / segmentHeight))

        local cornerWidth  = math.min(width *0.5,segmentWidth )
        local cornerHeight = math.min(height*0.5,segmentHeight)

        for segmentX = 1,segmentCountX do
            for segmentY = 1,segmentCountY do
                local offsetX = 0
                local offsetY = 0
                local thisWidth = segmentWidth
                local thisHeight = segmentHeight
                local thisSourceX = 0
                local thisSourceY = 0

                if segmentX == 1 then
                    thisWidth = cornerWidth
                elseif segmentX == segmentCountX then
                    thisWidth = cornerWidth
                    offsetX = width - thisWidth
                    thisSourceX = 1 - thisWidth/pauseplus.scale/image.width
                else
                    offsetX = (segmentX-1) * segmentWidth
                    thisWidth = math.clamp(segmentWidth,0,width-offsetX-segmentWidth)
                    thisSourceX = 1/3
                end

                if segmentY == 1 then
                    thisHeight = cornerHeight
                elseif segmentY == segmentCountY then
                    thisHeight = cornerHeight
                    offsetY = height - thisHeight
                    thisSourceY = 1 - thisHeight/pauseplus.scale/image.height
                else
                    offsetY = (segmentY-1) * segmentHeight
                    thisHeight = math.clamp(segmentHeight,0,height-offsetY-segmentHeight)
                    thisSourceY = 1/3
                end

                if thisWidth > 0 and thisHeight > 0 then
                    addQuadToGlDraw(vertexCoords,textureCoords,x + offsetX,y + offsetY,thisWidth,thisHeight,thisSourceX,thisSourceY,thisWidth/image.width/pauseplus.scale,thisHeight/image.height/pauseplus.scale)
                end
            end
        end

        Graphics.glDraw{
            texture = image,priority = priority,
            vertexCoords = vertexCoords,textureCoords = textureCoords,
        }
    end


    local checkboxSprite
    local cursorSprite

    function pauseplus.renderMenu(c)
        local submenuObj = pauseplus.submenus[pauseplus.currentSubmenu]

        
        if pauseplus.currentSubmenu == nil and not pauseplus.inResizingTransition then
            return
        end

        local menuPosition = vector(c.width,c.height)*0.5 + pauseplus.offset - pauseplus.boxDisplaySize*0.5

        drawBox(pauseplus.boxImage,pauseplus.priority,menuPosition.x,menuPosition.y,pauseplus.boxDisplaySize.x,pauseplus.boxDisplaySize.y)

        if pauseplus.inResizingTransition then
            return
        end
        

        -- Render options and the header
        local gapHeight = (pauseplus.optionGap*pauseplus.scale)
        local headerOffset = gapHeight

        local noOptions = (#submenuObj.options == 0)

        local y = (menuPosition.y +(pauseplus.verticalSpace*pauseplus.scale))
        local cursorPosition
        local texthighlight


        if submenuObj.headerImage ~= nil then
            local image = submenuObj.headerImage

            local drawX = menuPosition.x+(pauseplus.boxTotalSize.x*0.5)-(image.width*0.5)
            local drawY = y
            
            if not noOptions or submenuObj.headerText ~= nil then
                drawY = drawY - headerOffset
            end

            Graphics.drawImageWP(image,drawX,drawY,pauseplus.priority)


            y = y + image.height + gapHeight
        end

        if submenuObj.headerText ~= nil then
            local drawX = menuPosition.x+(pauseplus.boxTotalSize.x*0.5)-(headerTextLayout.width*0.5)
            local drawY = y

            if not noOptions then
                drawY = drawY - headerOffset
            end

            textplus.render{
                layout = headerTextLayout,priority = pauseplus.priority,
                x = drawX,y = drawY,
            }

            y = y + headerTextLayout.height + gapHeight
        end



        for index,optionObj in ipairs(submenuObj.options) do
            local layout = optionObj.layout
            

            -- Selection stuff
            if optionObj.selectionType == pauseplus.SELECTION_CHECKBOX then
                checkboxSprite = checkboxSprite or Sprite{texture = pauseplus.checkboxImage,frames = 2,pivot = vector(1,0.5)}

                checkboxSprite.position = vector(menuPosition.x+pauseplus.boxTotalSize.x-(pauseplus.horizontalSpace*pauseplus.scale),y+(optionObj.size.y*0.5))
                checkboxSprite.scale = vector(pauseplus.scale)

                checkboxSprite:draw{frame = (selectionData[pauseplus.currentSubmenu][getOptionSaveName(optionObj.text)] and 2) or 1,priority = pauseplus.priority}
            elseif selectionTypesWithText[optionObj.selectionType] then
                local step = (optionObj.selectionStep or 1)
                local layoutIndex = round(selectionData[pauseplus.currentSubmenu][getOptionSaveName(optionObj.text)]/step)*step

                local selectionLayout = optionObj.selectionLayouts[layoutIndex] or getNilLayout()

                --local selectionTextX = (menuPosition.x+pauseplus.boxTotalSize.x-(pauseplus.horizontalSpace*pauseplus.scale)-optionObj.selectionHighestWidth)
                local selectionTextX = (menuPosition.x+pauseplus.boxTotalSize.x-(pauseplus.horizontalSpace*pauseplus.scale)-selectionLayout.width)

                textplus.render{
                    layout = selectionLayout,priority = pauseplus.priority,
                    x = selectionTextX,y = y+(optionObj.size.y*0.5)-(selectionLayout.height*0.5),
                }
            end

            local drawX = menuPosition.x + pauseplus.boxTotalSize.x*0.5 - largestOptionWidth*0.5
            local drawY = y + optionObj.size.y*0.5 - layout.height*0.5

            -- Position cursor if necessary
            if pauseplus.currentOption == index then
                --index = "<color rainbow><wave 1>"..index.."</wave></color>"
                cursorPosition = vector(drawX - pauseplus.cursorImage.width,y + optionObj.size.y*0.5)

                -- Description
                if optionObj.descriptionLayout ~= nil then
                    local descriptionX = menuPosition.x + pauseplus.boxTotalSize.x*0.5 - optionObj.descriptionLayout.width*0.5
                    local descriptionY = menuPosition.y + pauseplus.boxTotalSize.y - pauseplus.verticalSpace*pauseplus.scale - optionObj.descriptionLayout.height + gapHeight*1.5

                    textplus.render{
                        layout = optionObj.descriptionLayout,priority = pauseplus.priority,
                        x = descriptionX,y = descriptionY,
                    }
                end
            end


            textplus.render{
                layout = layout,priority = pauseplus.priority,
                x = drawX,y = drawY,
            }

            y = y + optionObj.size.y + gapHeight
        end


        if cursorPosition ~= nil then
            cursorSprite = cursorSprite or Sprite{texture = pauseplus.cursorImage,pivot = vector(0.5,0.5)}

            cursorSprite.position = cursorPosition
            cursorSprite.scale = vector(pauseplus.scale)

            cursorSprite:draw{priority = pauseplus.priority}
        end
    end
end

-- Menu logic
do
    local function getMovementDirection(back,forward,currentOption,minOption,maxOption,step)
        step = step or 1
        
        
        if player.rawKeys[back] == KEYS_PRESSED and (currentOption-step) >= minOption then
            return -1*step
        elseif player.rawKeys[forward] == KEYS_PRESSED and (currentOption+step) <= maxOption then
            return 1*step
        end
    end

    
    local function callActions(optionObj)
        local actions = optionObj.actions or {optionObj.action}

        for _,func in ipairs(actions) do
            func(optionObj)
        end
    end


    function pauseplus.menuLogic(c)
        local submenuObj = pauseplus.submenus[pauseplus.currentSubmenu]

        if pauseplus.inResizingTransition then
            local difference = (pauseplus.boxTotalSize - pauseplus.boxDisplaySize)

            pauseplus.boxDisplaySize = pauseplus.boxDisplaySize + difference:normalise() * math.min(75,difference.length)

            if math.abs(pauseplus.boxTotalSize.x-pauseplus.boxDisplaySize.x) <= 1 and math.abs(pauseplus.boxTotalSize.y-pauseplus.boxDisplaySize.y) <= 1 then
                pauseplus.boxDisplaySize = vector(pauseplus.boxTotalSize.x,pauseplus.boxTotalSize.y)
                pauseplus.inResizingTransition = false

                if pauseplus.currentSubmenu == nil then
                    Misc.unpause()
                end
            end

            return
        elseif pauseplus.currentSubmenu == nil then
            return
        end


        if not pauseplus.canControlMenu then
            return
        end


        if player.rawKeys.run == KEYS_PRESSED then
            -- Go back
            local count = #pauseplus.history
            
            if count == 0 then
                pauseplus.close()
                smasbooleans.toggleOffInventory = false
            else
                local entry = pauseplus.history[count]

                pauseplus.open(entry[1],entry[2])

                SFX.play(pauseplus.backSFX)

                pauseplus.history[count] = nil -- remove top entry
            end

            return
        end


        local optionObj = submenuObj.options[pauseplus.currentOption]


        if optionObj == nil then
            return
        end


        local submenuSelectionData = selectionData[pauseplus.currentSubmenu]
        local saveName = getOptionSaveName(optionObj.text)


        local verticalMovementDirection = getMovementDirection("up","down",pauseplus.currentOption,1,#submenuObj.options)

        if verticalMovementDirection ~= nil then
            pauseplus.currentOption = pauseplus.currentOption + verticalMovementDirection
            playSFX(pauseplus.moveSFX)
        elseif optionObj.selectionType ~= nil and optionObj.selectionType ~= pauseplus.SELECTION_CHECKBOX then
            local min,max
            if optionObj.selectionType == pauseplus.SELECTION_NUMBERS then
                min = optionObj.selectionMin
                max = optionObj.selectionMax
            elseif optionObj.selectionType == pauseplus.SELECTION_NAMES then
                min = 1
                max = #optionObj.selectionNames
            end

            local horizontalMovementDirection = getMovementDirection("left","right",submenuSelectionData[saveName],min,max,optionObj.selectionStep)

            if horizontalMovementDirection ~= nil then
                local step = (optionObj.selectionStep or 1)

                submenuSelectionData[saveName] = round((submenuSelectionData[saveName] + horizontalMovementDirection)/step)*step
                playSFX(pauseplus.moveSFX)

                callActions(optionObj)
            end
        elseif player.rawKeys.jump == KEYS_PRESSED then
            -- Checkboxes
            if optionObj.selectionType == pauseplus.SELECTION_CHECKBOX then
                if optionObj.sfx == nil then
                    playSFX(pauseplus.checkboxSFX)
                end
                submenuSelectionData[saveName] = not submenuSelectionData[saveName]
                if submenuSelectionData[saveName] then
                    if optionObj.sfx == nil then
                        playSFX(pauseplus.checkboxSFX)
                    end
                end
            elseif optionObj.selectionType ~= nil then
                return
            end


            -- Run actions
            callActions(optionObj)


            -- Handle goToSubmenu/goToOption
            if optionObj.goToSubmenu ~= nil or optionObj.goToOption ~= nil then
                table.insert(pauseplus.history,{pauseplus.currentSubmenu,pauseplus.currentOption})

                pauseplus.open(optionObj.goToSubmenu or pauseplus.currentSubmenu,optionObj.goToOption or 1)

                if optionObj.sfx == nil then
                    playSFX(pauseplus.actionSFX)
                end
            end


            if optionObj.closeMenu then
                pauseplus.close(true)
                smasbooleans.toggleOffInventory = false
            end


            -- Run later actions
            local lateActions = optionObj.lateActions or {optionObj.lateAction}

            for _,func in ipairs(lateActions) do
                func(optionObj)
            end


            playSFX(optionObj.sfx)
        end
    end
end


function pauseplus.onInitAPI()
    if not isOverworld then
        registerEvent(pauseplus,"onCameraDraw")
    else
        registerEvent(pauseplus,"onDraw","onDrawOverworld")
    end

    registerEvent(pauseplus,"onDraw")

    registerEvent(pauseplus,"onStart")

    registerEvent(pauseplus,"onPause")
    registerEvent(pauseplus,"onKeyboardPressDirect")
    registerEvent(pauseplus,"onTick")
    registerEvent(pauseplus,"onInputUpdate")
end


function pauseplus.onCameraDraw(camIdx)
    Graphics.drawScreen{priority = pauseplus.priority,color = Color.black.. pauseplus.screenDarkness[camIdx]}

    if getPlayerCamera(pauseplus.opener).idx ~= camIdx then
        return
    end

    local c = Camera(camIdx)
    
    pauseplus.menuLogic(c)
    pauseplus.renderMenu(c)
end

function pauseplus.onDrawOverworld()
    Graphics.drawScreen{priority = pauseplus.priority,color = Color.black.. pauseplus.screenDarkness[1]}

    pauseplus.menuLogic(camera)
    pauseplus.renderMenu(camera)
end


function pauseplus.onDraw()
    if pauseplus.currentSubmenu ~= nil then
        -- Decrease volume if menu is open
        if pauseplus.lowerMusicVolume == nil then
            pauseplus.currentMusicVolume = pauseplus.currentMusicVolume or Audio.MusicVolume()
            pauseplus.originalMusicVolume = pauseplus.originalMusicVolume or pauseplus.currentMusicVolume
            pauseplus.lowerMusicVolume = math.floor(pauseplus.currentMusicVolume * pauseplus.musicVolumeDecrease)
        end

        pauseplus.currentMusicVolume = math.max(pauseplus.lowerMusicVolume,pauseplus.currentMusicVolume - 1)
        Audio.MusicVolume(pauseplus.currentMusicVolume)
    elseif pauseplus.currentMusicVolume ~= nil then
        pauseplus.lowerMusicVolume = nil

        pauseplus.currentMusicVolume = math.min(pauseplus.originalMusicVolume,pauseplus.currentMusicVolume + 1)

        Audio.MusicVolume(pauseplus.currentMusicVolume)

        if pauseplus.currentMusicVolume == pauseplus.originalMusicVolume then
            pauseplus.currentMusicVolume = nil
        end
    end

    local openerCamera = getPlayerCamera(pauseplus.opener)

    for idx,cam in ipairs(Camera.get()) do
        if pauseplus.currentSubmenu ~= nil and idx == openerCamera.idx then
            pauseplus.screenDarkness[idx] = math.min(pauseplus.backgroundDarkness,pauseplus.screenDarkness[idx] + 0.05)
        else
            pauseplus.screenDarkness[idx] = math.max(0,pauseplus.screenDarkness[idx] - 0.05)
        end
    end
end

function pauseplus.onStart()
    Audio.MusicVolume(64) -- reset music volume
end


function pauseplus.onPause(eventObj,playerObj)
    eventObj.cancelled = true

    if pauseplus.canPause and (isOverworld or (Level.winState() == 0 and playerObj.deathTimer == 0 and not playerObj:mem(0x13C,FIELD_BOOL))) and not smasbooleans.mainMenuActive and not smasbooleans.disablePauseMenu then
        pauseplus.open(nil,nil,playerObj)
    end
end

function pauseplus.onKeyboardPressDirect(keycode,repeated,character) -- for shift+P shortcut
    if not Misc.inEditor() or pauseplus.currentSubmenu ~= nil then return end
    
    if not repeated and (keycode == VK_P) and Misc.GetKeyState(VK_RETURN) and pauseplus.canPause and not bootmenu.active and not smasbooleans.disablePauseMenu then
        pauseplus.open()
    end
end



-- Default settings --

local folder = "pause/"
-- The textplus font used for displaying text in the menu.
pauseplus.font = textplus.loadFont("textplus/font/11.ini")

-- The graphic used for the box. It's split into 9 pieces.
pauseplus.boxImage = Graphics.loadImageResolved(folder.."pauseplus_box.png")
-- The image used for the cursor.
pauseplus.cursorImage = Graphics.loadImageResolved(folder.."pauseplus_cursor.png")
-- The image used for checkboxes.
pauseplus.checkboxImage = Graphics.loadImageResolved(folder.."pauseplus_checkbox.png")


-- How much the music volume is multiplied by while the menu is open.
pauseplus.musicVolumeDecrease = 1
-- How much the background is darkened while the menu is open.
pauseplus.backgroundDarkness = 0


-- The priority that the menu is drawn at.
pauseplus.priority = 6

-- The sound effects used when opening the menu, moving around it, changing submenus, or toggling a checkbox.
pauseplus.openSFX = "_OST/_Sound Effects/pausemenu.ogg"
pauseplus.closeSFX = "_OST/_Sound Effects/pausemenu-closed.ogg"
pauseplus.moveSFX = "_OST/_Sound Effects/pausemenu_cursor.ogg"
pauseplus.actionSFX = "_OST/_Sound Effects/quitmenu.ogg"
pauseplus.saveSFX = "_OST/_Sound Effects/save_dismiss.ogg"
pauseplus.checkboxSFX = "_OST/_Sound Effects/paused_on.ogg"
pauseplus.quitgameSFX = "_OST/_Sound Effects/savequit.ogg"
pauseplus.checkbox2SFX = "_OST/_Sound Effects/paused_off.ogg"
pauseplus.backSFX = "_OST/_Sound Effects/quitmenu_close.ogg"

-- How much space there is on any side of the "box". To mimic the default box, use 59 and 37
pauseplus.horizontalSpace = 30
pauseplus.verticalSpace   = 15

-- How much vertical space there is between each option.
pauseplus.optionGap = 8

-- The scale of the menu.
pauseplus.scale = 2

-- If the menu uses resizing transitions.
pauseplus.doResizing = true

-- How far the menu is offset from the centre of the screen.
pauseplus.offset = vector(0,0)



return pauseplus