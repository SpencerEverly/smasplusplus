--***************************************************************************************
--                                                                                      *
--     textblox.lua                                                                        *
--  v0.2.2                                                                              *
--  Documentation: ___                                                                      *
--                                                                                      *
--***************************************************************************************

local textblox = {} --Package table
local graphX = loadSharedAPI("graphX");
local rng = loadSharedAPI("rng")


function textblox.onInitAPI() --Is called when the api is loaded by loadAPI.
    --register event handler
    --registerEvent(string apiName, string internalEventName, string functionToCall, boolean callBeforeMain)
    
    registerEvent(textblox, "onHUDDraw", "update", true) --Register the loop event
    registerEvent(textblox, "onMessageBox", "onMessageBox", true) --Register the loop event
end


textblox.textBlockRegister = {}
--textblox.textBlockGarbageQueue = {}
textblox.resourcePath = "textblox\\"
textblox.resourcePathOver = "textblox\\"


textblox.useGlForFonts = false
textblox.overrideMessageBox = false

textblox.currentMessage = nil

textblox.active = false


    
        

--***************************************************************************************************
--                                                                                                  *
--              FILE MANAGEMENT                                                                        *
--                                                                                                  *
--***************************************************************************************************

    function textblox.getPath (filename)        
        --windowDebug ("TEST")
        
        local localPath = Misc.resolveFile(filename)  
                        
        if  localPath  ~=  nil  then
            return localPath
        end
        
        if isOverworld == true  then
            return textblox.resourcePathOver..filename
        end
        
        return textblox.resourcePath..filename
    end






--***************************************************************************************************
--                                                                                                  *
--              FONT CLASS                                                                            *
--                                                                                                  *
--***************************************************************************************************

local Font = {}
Font.__index = Font
    
do
    
    textblox.FONTTYPE_DEFAULT = 0
    textblox.FONTTYPE_SPRITE = 1
    textblox.FONTTYPE_TTF = 2   --NOT SUPPORTED YET


    function Font.create (fontType, properties)
        local thisFont = {}
        setmetatable (thisFont, Font)
        
        thisFont.fontType = fontType
        
        thisFont.imagePath = ""
        thisFont.imageRef = nil
            
        thisFont.charWidth = 16
        thisFont.charHeight = 16
        thisFont.kerning = 0
        
        thisFont.fontIndex = 4
        
        thisFont.verts = {}
        thisFont.uvs = {}
        
        
        -- Default font
        if  fontType == textblox.FONTTYPE_DEFAULT    then
            thisFont.fontIndex = properties
            if      thisFont.fontIndex == 1  then
                
            elseif  thisFont.fontIndex == 2  then 
            
            elseif  thisFont.fontIndex == 3  then 
            
            elseif  thisFont.fontIndex == 4  then 
            
            end
        end
        
        -- Sprite font
        if  fontType == textblox.FONTTYPE_SPRITE  then
            if  properties["image"] ~= nil  then
                thisFont.imageRef = properties["image"]
            else
                thisFont.imagePath = properties["imagePath"]  or  ""
                thisFont.imageRef = Graphics.loadImage(Misc.resolveGraphicsFile(thisFont.imagePath))
            end
            
            thisFont.charWidth = properties["charWidth"]  or  16
            thisFont.charHeight = properties["charHeight"]  or  16
            thisFont.kerning = properties["kerning"]  or  1
        end
            
        return thisFont
    end    

    function textblox.Font (fontType, properties)
        return Font.create (fontType, properties)
    end

    
    function Font:drawCharImage (character, x,y, opacity, color)
        
        if  color == nil  then
            color = 0xFFFFFFFF
        end
        
        local alpha = opacity or 1.00
        local index = string.byte(character,1)-33
        local w = self.charWidth
        local h = self.charHeight
        local sourceX = (index%16) * w
        local sourceY = math.floor(index/16) * h

    
        -- Draw character based on font type
        if  self.fontType == textblox.FONTTYPE_DEFAULT  then        
            Text.print (character, self.fontIndex, x, y)
        elseif  self.fontType == textblox.FONTTYPE_SPRITE  then    
            
            --if  textblox.useGlForFonts == true  then
                --[[
                local percentX1 = sourceX/16
                local percentY1 = sourceY/8
                local percentX2 = (sourceX+1)/16
                local percentY2 = (sourceY+1)/8
                
                if  self.verts[color] == nil  then
                    self.verts[color] = {}
                end
                
                if  self.uvs[color] == nil  then
                    self.uvs[color] = {}
                end
            
                pts[1] = x1;     pts[2] = y1;
                pts[3] = x1+w;    pts[4] = y1;
                pts[5] = x1;    pts[6] = y1+h;
                pts[7] = x1;    pts[8] = y1+h;
                pts[9] = x1+w;    pts[10] = y1+h;
                pts[11] = x1+w; pts[12] = y1;
            
                table.insert (self.verts[color], x);        table.insert (self.verts[color], y);
                table.insert (self.verts[color], x+w);        table.insert (self.verts[color], y);
                table.insert (self.verts[color], x);        table.insert (self.verts[color], y+h);
                table.insert (self.verts[color], x);        table.insert (self.verts[color], y+h);
                table.insert (self.verts[color], x);        table.insert (self.verts[color], y+h);
                table.insert (self.verts[color], x+w);        table.insert (self.verts[color], y);
                ]]
            --else
                Graphics.drawImageWP (self.imageRef, x, y, sourceX, sourceY, w, h, alpha, 3.495)
            --end
        end        
    end
    
        
    function Font:drawTris ()
        --graphX.
    end    
end







--***************************************************************************************************
--                                                                                                  *
--              DEFAULT FONTS AND RESOURCES                                                            *
--                                                                                                  *
--***************************************************************************************************

do 
    textblox.FONT_DEFAULT = textblox.Font (textblox.FONTTYPE_DEFAULT, 4)  

    textblox.IMGNAME_DEFAULTSPRITEFONT         = textblox.getPath ("textblox/font_default.png")
    textblox.IMGNAME_DEFAULTSPRITEFONTX2     = textblox.getPath ("textblox/font_default_x2.png")
    textblox.IMGNAME_DEFAULTSPRITEFONT2     = textblox.getPath ("textblox/font_default2.png")
    textblox.IMGNAME_DEFAULTSPRITEFONT2X2     = textblox.getPath ("textblox/font_default2_x2.png")
    textblox.IMGNAME_DEFAULTSPRITEFONT3     = textblox.getPath ("textblox/font_default3.png")
    textblox.IMGNAME_DEFAULTSPRITEFONT3X2     = textblox.getPath ("textblox/font_default3_x2.png")

    textblox.IMGNAME_BUBBLE_BORDER_U         = textblox.getPath ("textblox/bubbleBorderU.png")
    textblox.IMGNAME_BUBBLE_BORDER_D         = textblox.getPath ("textblox/bubbleBorderD.png")
    textblox.IMGNAME_BUBBLE_BORDER_L         = textblox.getPath ("textblox/bubbleBorderL.png")
    textblox.IMGNAME_BUBBLE_BORDER_R         = textblox.getPath ("textblox/bubbleBorderR.png")
    textblox.IMGNAME_BUBBLE_BORDER_UL         = textblox.getPath ("textblox/bubbleBorderUL.png")
    textblox.IMGNAME_BUBBLE_BORDER_UR         = textblox.getPath ("textblox/bubbleBorderUR.png")
    textblox.IMGNAME_BUBBLE_BORDER_DL         = textblox.getPath ("textblox/bubbleBorderDL.png")
    textblox.IMGNAME_BUBBLE_BORDER_DR         = textblox.getPath ("textblox/bubbleBorderDR.png")


    textblox.IMGREF_DEFAULTSPRITEFONT         = Graphics.loadImage (textblox.IMGNAME_DEFAULTSPRITEFONT)
    textblox.IMGREF_DEFAULTSPRITEFONTX2     = Graphics.loadImage (textblox.IMGNAME_DEFAULTSPRITEFONTX2)
    textblox.IMGREF_DEFAULTSPRITEFONT2         = Graphics.loadImage (textblox.IMGNAME_DEFAULTSPRITEFONT2)
    textblox.IMGREF_DEFAULTSPRITEFONT2X2     = Graphics.loadImage (textblox.IMGNAME_DEFAULTSPRITEFONT2X2)
    textblox.IMGREF_DEFAULTSPRITEFONT3        = Graphics.loadImage (textblox.IMGNAME_DEFAULTSPRITEFONT3)
    textblox.IMGREF_DEFAULTSPRITEFONT3X2    = Graphics.loadImage (textblox.IMGNAME_DEFAULTSPRITEFONT3X2)
    
    textblox.IMGREF_BUBBLE_BORDER_U          = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_U)
    textblox.IMGREF_BUBBLE_BORDER_D         = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_D)
    textblox.IMGREF_BUBBLE_BORDER_L         = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_L)
    textblox.IMGREF_BUBBLE_BORDER_R             = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_R)
    textblox.IMGREF_BUBBLE_BORDER_UL         = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_UL)
    textblox.IMGREF_BUBBLE_BORDER_UR         = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_UR)
    textblox.IMGREF_BUBBLE_BORDER_DL         = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_DL)
    textblox.IMGREF_BUBBLE_BORDER_DR         = Graphics.loadImage (textblox.IMGNAME_BUBBLE_BORDER_DR)
    
    
    textblox.FONT_SPRITEDEFAULT     = textblox.Font (textblox.FONTTYPE_SPRITE, {charWidth = 8,         charHeight = 8,     image = textblox.IMGREF_DEFAULTSPRITEFONT,         kerning = 0})
    textblox.FONT_SPRITEDEFAULTX2     = textblox.Font (textblox.FONTTYPE_SPRITE, {charWidth = 16,     charHeight = 16,     image = textblox.IMGREF_DEFAULTSPRITEFONTX2,     kerning = 0})
    textblox.FONT_SPRITEDEFAULT2     = textblox.Font (textblox.FONTTYPE_SPRITE, {charWidth = 8,         charHeight = 8,     image = textblox.IMGREF_DEFAULTSPRITEFONT2,     kerning = 0})
    textblox.FONT_SPRITEDEFAULT2X2     = textblox.Font (textblox.FONTTYPE_SPRITE, {charWidth = 16,     charHeight = 16,     image = textblox.IMGREF_DEFAULTSPRITEFONT2X2,     kerning = 0})
    textblox.FONT_SPRITEDEFAULT3     = textblox.Font (textblox.FONTTYPE_SPRITE, {charWidth = 9,         charHeight = 9,     image = textblox.IMGREF_DEFAULTSPRITEFONT3,     kerning = 0})
    textblox.FONT_SPRITEDEFAULT3X2     = textblox.Font (textblox.FONTTYPE_SPRITE, {charWidth = 18,     charHeight = 18,     image = textblox.IMGREF_DEFAULTSPRITEFONT3X2,     kerning = -2})
end


    


--***************************************************************************************************
--                                                                                                  *
--              PRINT FUNCTIONS                                                                        *
--                                                                                                  *
--***************************************************************************************************

do
    function textblox.getStringWidth (text, font)
        local strLen = text:len() 
        return  (strLen * font.charWidth) + (math.max(0, strLen-1) * font.kerning)
    end
    
    
    function textblox.print (text, xPos,yPos, fontObj, t_halign, t_valign, w, alpha)
        return textblox.printExt (text, {x=xPos, y=yPos, font=fontObj, halign=t_halign, valign=t_valign, width, opacity=alpha})
    end
    
    
    function textblox.printExt (text, properties)
        -- Setup
        local x = properties["x"] or 400
        local y = properties["y"] or 300
        
        local bind = properties["bind"] or textblox.BIND_SCREEN
        
        if  bind == textblox.BIND_LEVEL  then
            x,y = graphX.worldToScreen(x,y)
        end
        
        local t_halign = properties["halign"] or textblox.HALIGN_LEFT
        local t_valign = properties["valign"] or textblox.VALIGN_TOP
        local alpha = properties["opacity"] or 1.00
        
        local font = properties["font"] or textblox.FONT_DEFAULT
        local width = properties["width"] or math.huge
        
        
        local lineBreaks = 0
        local charsOnLine = 0
        local totalShownChars = 0
        local currentLineWidth = 0
        
            
        local totalWidth = 1
        local totalHeight = 1
        
        
        local startOfLine = 1
        local fullLineWidth = 0
        local charEndWidth = 0
        local markupCount = 0
        local i = 1
                
        local topmostY = 10000
        local leftmostX = 10000
        
        -- Effects
        local shakeMode = false
        local waveMode = false
        local currentColor = 0xFFFFFFFF
        
        
        -- Determine number of characters per line
        local numCharsPerLine = math.floor((width)/(font.charWidth + font.kerning))
        local mostCharsLine = 0
        
        
        -- Positioning loop
        local lineWidths = {}
        local totalLineBreaks = 0
        
        for textChunk in string.gmatch(text, "<*[^<>]+>*")    do
        
            local processPlaintext  = false
        
            -- Is a command
            if  string.find(textChunk, "<.*>") ~= nil  then
            
                local commandStr, amountStr = string.match (textChunk, "([^<>%s]+) ([^<>%s]+)")
                if  commandStr == nil  then
                    commandStr = string.match (textChunk, "[^<>%s]+")
                end
                                
                -- Line break
                if  commandStr == "br"  then
                    lineWidths [lineBreaks] = charsOnLine*font.charWidth + math.max(0, charsOnLine-1)*font.kerning
                    lineBreaks = lineBreaks + 1
                    totalLineBreaks = totalLineBreaks + 1
                    charsOnLine = 0
                end
                
                if  commandStr == "gt"  then
                    textChunk = ">"
                    processPlaintext = true
                end        
                
                if  commandStr == "lt"  then
                    textChunk = "<"
                    processPlaintext = true

                end
                
                if  commandStr == "butt"  then
                    textChunk = "rockythechao"
                    processPlaintext = true
                end
                
            -- Is plaintext
            else
                processPlaintext = true
            end
                

            -- PROCESS PLAINTEXT
            if  processPlaintext == true  then
                string.gsub (textChunk, ".", function(c)
                    -- Increment position counters
                    charsOnLine = charsOnLine + 1
                    totalShownChars = totalShownChars + 1

                    
                    if  charsOnLine > numCharsPerLine + 1  then
                        lineWidths[lineBreaks] = (charsOnLine-1)*font.charWidth + math.max(0, charsOnLine-2)*font.kerning
                        lineBreaks = lineBreaks + 1
                        totalLineBreaks = totalLineBreaks + 1
                        charsOnLine = 0
                    end
                    
                    -- Get widest line
                    if  mostCharsLine < charsOnLine then
                        mostCharsLine = charsOnLine
                    end

                    return c
                end)
            end
        end
        lineWidths[lineBreaks] = (charsOnLine)*font.charWidth + math.max(0, charsOnLine-1)*font.kerning

        -- fix spacing issue on single-line prints
        --if  totalLineBreaks == 0  then
            mostCharsLine = mostCharsLine + 1
            --lineWidths[0] = lineWidths[0] + font.charWidth + font.kerning
        --end
        
        
        -- Display loop
        lineBreaks = 0
        charsOnLine = 0
        
        for textChunk in string.gmatch(text, "<*[^<>]+>*")    do
            
            -- Is a command
            local processPlaintext = false
            
            if  string.find(textChunk, "<.*>") ~= nil  then
                local commandStr, amountStr = string.match (textChunk, "([^<>%s]+) ([^<>%s]+)")
                if  commandStr == nil  then
                    commandStr = string.match (textChunk, "[^<>%s]+")
                end
                
                --[[
                if  commandStr ~= nil  then
                    if  amountStr ~= nil then
                        Text.windowDebug (commandStr..", "..tostring(amountStr))
                    else
                        Text.windowDebug (commandStr)
                    end
                end
                ]]
                
                -- Line break
                if  commandStr == "br"  then
                    lineBreaks = lineBreaks + 1
                    charsOnLine = 0
                end

                -- Greater than
                if  commandStr == "gt"  then
                    textChunk = ">"
                    processPlaintext = true
                end
                
                -- Greater than
                if  commandStr == "lt"  then
                    textChunk = "<"
                    processPlaintext = true
                end
                
                -- BUTT
                if  commandStr == "butt"  then
                    textChunk = "rockythechao"
                    processPlaintext = true
                end
    
    
                -- Shake text
                if  commandStr == "tremble"  then
                    shakeMode = true
                end
                if  commandStr == "/tremble"  then
                    shakeMode = false
                end
                
                -- Wave text
                if  commandStr == "wave"  then
                    waveMode = true
                end
                if  commandStr == "/wave"  then
                    waveMode = false
                end
            
                -- Colored text
                if  commandStr == "color"  then
                    currentColor = tonumber(amountStr)
                end
                
                
            -- Is plaintext
            else
                processPlaintext = true
            end
            
            
            -- Process the plaintext
            if  processPlaintext == true  then
                string.gsub (textChunk, ".", function(c)
                    
                    -- Increment position counters
                    charsOnLine = charsOnLine + 1
                    totalShownChars = totalShownChars + 1

                    
                    if  charsOnLine > numCharsPerLine + 1  then
                        lineBreaks = lineBreaks + 1
                        charsOnLine = 0
                    end
                    
                    -- Get widest line
                    if  mostCharsLine < charsOnLine then
                        mostCharsLine = charsOnLine
                    end

                    -- Ignore spaces
                    if  c ~= " " then

                        -- Determine position
                        currentLineWidth = math.max(0, charsOnLine-1) * font.charWidth    +   math.max(0, charsOnLine-2) * font.kerning
                        local xPos = x + currentLineWidth
                        local yPos = y + font.charHeight*lineBreaks
                        
                        
                        -- if different alignments, change those values
                        if    t_halign == textblox.HALIGN_RIGHT  then
                            xPos = x - lineWidths[lineBreaks] + currentLineWidth

                        elseif    t_halign == textblox.HALIGN_MID  then
                            xPos = x - 0.5*(lineWidths[lineBreaks]) + currentLineWidth
                        end


                        if    t_valign == textblox.VALIGN_BOTTOM  then
                            yPos = y + (lineBreaks - totalLineBreaks - 1)*font.charHeight

                        elseif t_valign == textblox.VALIGN_MID  then
                            yPos = y + (lineBreaks*font.charHeight)    - ((totalLineBreaks+1)*font.charHeight*0.5)
                        end

                        
                        -- Process visual effects
                        local xAffected = xPos
                        local yAffected = yPos
                                            
                        if  waveMode == true  then
                            yAffected = yAffected + math.cos(totalShownChars*0.5 + textblox.waveModeCycle)
                        end
                        
                        if  shakeMode == true  then
                            local shakeX = math.max(0.5, font.charWidth * 0.125)
                            local shakeY = math.max(0.5, font.charHeight * 0.125)
                            
                            xAffected = xAffected + rng.random(-1*shakeX, shakeX)
                            yAffected = yAffected + rng.random(-1*shakeY, shakeY)
                        end
                        
                        -- Finally, draw the image
                        font:drawCharImage (c, xAffected, yAffected, alpha)
                    end
                    
                    return c
                end)
            end
            --windowDebug (textChunk)
        end
        
        totalWidth = mostCharsLine * (font.kerning + font.charWidth) - font.kerning
        totalHeight = font.charHeight * lineBreaks
        
        return totalWidth, totalHeight, lineBreaks, lineWidths
    end
end


    


--***************************************************************************************************
--                                                                                                  *
--              TEXT BLOCK CLASS                                                                    *
--                                                                                                  *
--***************************************************************************************************


local TextBlock = {}
TextBlock.__index = TextBlock

do
    textblox.BOXTYPE_NONE = 1
    textblox.BOXTYPE_MENU = 2
    textblox.BOXTYPE_WORDBUBBLE = 3
    textblox.BOXTYPE_CUSTOM = 4
    
    textblox.BIND_SCREEN = 1
    textblox.BIND_LEVEL = 2

    textblox.SCALE_FIXED = 1
    textblox.SCALE_AUTO = 2
    
    textblox.HALIGN_LEFT = 1
    textblox.HALIGN_MID = 2
    textblox.HALIGN_RIGHT = 3
    
    textblox.VALIGN_TOP = 1
    textblox.VALIGN_MID = 2
    textblox.VALIGN_BOTTOM = 3
    
    
    
    function TextBlock.create(x,y, textStr, properties)
        
        local thisTextBlock = {}                            -- our new object
        setmetatable (thisTextBlock, TextBlock)                -- make TextBlock handle lookup
        
        
        -- Properties
        thisTextBlock.x = x
        thisTextBlock.y = y
        thisTextBlock.text = textStr
        
        thisTextBlock.z = properties["z"] or 2
        
        thisTextBlock.boxType = properties["boxType"] or textblox.BOXTYPE_MENU
        thisTextBlock.boxTex = properties["boxTex"]
        thisTextBlock.boxColor = properties["boxColor"] or 0x00AA0099             -- transparent green
        thisTextBlock.borderTable = properties["borderTable"]
        
        
        if  thisTextBlock.borderTable == nil  then
        
            if          thisTextBlock.boxType == textblox.BOXTYPE_MENU  then
                thisTextBlock.borderTable = graphX.getDefBorderTable ()
                
                thisTextBlock.borderTable["thick"] = 8
                thisTextBlock.borderTable["col"] = 0xFF9900FF
            
            elseif      thisTextBlock.boxType == textblox.BOXTYPE_WORDBUBBLE  then
                thisTextBlock.borderTable = {}
                thisTextBlock.borderTable["ulImg"]     = textblox.IMGREF_BUBBLE_BORDER_UL
                thisTextBlock.borderTable["uImg"]     = textblox.IMGREF_BUBBLE_BORDER_U
                thisTextBlock.borderTable["urImg"]     = textblox.IMGREF_BUBBLE_BORDER_UR
                thisTextBlock.borderTable["rImg"]     = textblox.IMGREF_BUBBLE_BORDER_R
                thisTextBlock.borderTable["drImg"]     = textblox.IMGREF_BUBBLE_BORDER_DR
                thisTextBlock.borderTable["dImg"]     = textblox.IMGREF_BUBBLE_BORDER_D
                thisTextBlock.borderTable["dlImg"]     = textblox.IMGREF_BUBBLE_BORDER_DL
                thisTextBlock.borderTable["lImg"]     = textblox.IMGREF_BUBBLE_BORDER_L
                
                thisTextBlock.borderTable["thick"] = 8
                thisTextBlock.borderTable["col"] = 0xFFFFFFFF
            end
        end
        
        
        thisTextBlock.scaleMode = properties["scaleMode"]
        if  thisTextBlock.scaleMode == nil  then
            thisTextBlock.scaleMode = textblox.SCALE_FIXED
        end
        
        thisTextBlock.width = properties["width"] or 200
        thisTextBlock.height = properties["height"] or 200
        
        thisTextBlock.bind = properties["bind"] or textblox.BIND_SCREEN
        
        thisTextBlock.halign = properties["textAnchorX"] or textblox.HALIGN_LEFT
        thisTextBlock.valign = properties["textAnchorY"] or textblox.VALIGN_TOP
        
        thisTextBlock.textAlpha = properties["textAlpha"] or 1

        thisTextBlock.mappedFilters = properties["mappedWordFilters"] or {}
        thisTextBlock.unmappedReplacements = properties["replaceWords"] or {}
        thisTextBlock.madlibsWords = properties["madlibWords"] or {}
        
        thisTextBlock.autoClose = properties["autoClose"]
        if  thisTextBlock.autoClose == nil  then
            thisTextBlock.autoClose = false
        end
        
        thisTextBlock.speed = properties["speed"] or 0.5
        thisTextBlock.defaultSpeed = thisTextBlock.speed
        
        thisTextBlock.autoTime = properties["autoTime"]
        if  (thisTextBlock.autoTime == nil)  then
            thisTextBlock.autoTime = false
        end
        
        thisTextBlock.inputClose = properties["inputClose"]
        if  (thisTextBlock.inputClose == nil)  then
            thisTextBlock.inputClose = false
        end
        
        
        thisTextBlock.endMarkDelay = properties["endMarkDelay"] or 8
        thisTextBlock.midMarkDelay = properties["midMarkDelay"] or 4

        
        thisTextBlock.finishDelay = properties["finishDelay"] or 10
        
        thisTextBlock.boxhalign = properties["boxAnchorX"] or textblox.HALIGN_LEFT
        thisTextBlock.boxvalign = properties["boxAnchorY"] or textblox.VALIGN_TOP
        
        thisTextBlock.typeSounds = properties["typeSounds"] or {}
        thisTextBlock.startSound = properties["startSound"] or ""
        thisTextBlock.finishSound = properties["finishSound"] or ""
        thisTextBlock.closeSound = properties["closeSound"] or ""
        
        if  (thisTextBlock.startSound ~= "")  then
            SFX.play (textblox.getPath (thisTextBlock.startSound))
        end
        
        thisTextBlock.typeSoundChunks = {}
        if  #thisTextBlock.typeSounds > 0  then
            for  k,v in pairs (thisTextBlock.typeSounds)  do
                thisTextBlock.typeSoundChunks[k] = SFX.open(textblox.getPath(v))
            end
        end
        thisTextBlock.typeUsedChannel = 12
        
        
        thisTextBlock.font = properties["font"] or textblox.FONT_DEFAULT
        
        thisTextBlock.xMargin = properties["marginX"] or 4
        thisTextBlock.yMargin = properties["marginY"] or 4

        thisTextBlock.visible = properties["visible"]
        if  thisTextBlock.visible == nil  then
            thisTextBlock.visible = true
        end
        
        thisTextBlock.pauseGame = properties["pauseGame"]
        if  thisTextBlock.pauseGame == nil  then
            thisTextBlock.pauseGame = false
        end
        
        
        
        -- Control vars
        thisTextBlock.pauseFrames = 0
        thisTextBlock.shakeFrames = 0

        thisTextBlock.autoWidth = 1
        thisTextBlock.autoHeight = 1
        
        thisTextBlock.updatingChars = true
        thisTextBlock.finished = false
        thisTextBlock.finishSoundPlayed = false
        thisTextBlock.deleteMe = false
        thisTextBlock.index = -1
        
        if  (thisTextBlock.autoTime == true)  then
            thisTextBlock:insertTiming ()
        end
        
        thisTextBlock.filteredText = textStr
        thisTextBlock.length = string.len(textStr)
        
        thisTextBlock.lastCharCounted = nil
        thisTextBlock.charsShown = 0
        if (thisTextBlock.speed <= 0) then
            thisTextBlock.charsShown = thisTextBlock.length
        end
        
        if  (thisTextBlock.pauseGame == true)  then
            Misc.pause ()
            --[[
            thisTextBlock.playerX = player.x
            thisTextBlock.playerY = player.y
            thisTextBlock.playerSpeedX = player.speedX
            thisTextBlock.playerSpeedY = player.speedY
            Defines.levelFreeze = true
            ]]
        end
        
        
        table.insert(textblox.textBlockRegister, thisTextBlock)
        
        return thisTextBlock
    end

    function textblox.Block (x,y, textStr, properties)
        return TextBlock.create (x,y, textStr, properties)
    end
    
    
    function TextBlock:getCharsPerLine ()
        local numCharsPerLine = math.floor((self.width)/(self.font.charWidth + self.font.kerning))
        return numCharsPerLine
    end
    
    
    function TextBlock:getTextWrapped (addSlashN)
        if  addSlashN == nil  then
            addSlashN = false
        end
        
        local wrappedText = textblox.formatDialogForWrapping (self.text, self:getCharsPerLine (), addSlashN)
        return wrappedText
    end
    
    
    function TextBlock:draw ()
        -- Get width and height
        local textToShow = string.sub(self:getTextWrapped (), 1, self.charsShown)
        local textForWidth = self:getTextWrapped ()
        
        --[[
        self.autoWidth = textblox.getStringWidth (self.text, self.font)
        self.autoHeight = self.font.charHeight + self.font.kerning
        
        while (self.autoWidth/self.autoHeight > 4/3)  do
            self.autoWidth = self.autoWidth*0.5
            self.autoHeight = self.autoHeight*2
        end
        --]]
        
        --self.autoWidth = 4
        --self.autoHeight = 4
        ---[[
        self.autoWidth, self.autoHeight = textblox.print   (textForWidth, 
                                                            9999, 
                                                            9999,
                                                            self.font,
                                                            self.halign,
                                                            self.valign,
                                                            math.huge,--self.width,
                                                            0.0)
        --]]
        
    
        -- Get shake offset
        local shakeX = rng.random (-12, 12) * (self.shakeFrames/8)
        local shakeY = rng.random (-12, 12) * (self.shakeFrames/8)        
        
        
        -- Get alignment and width based on scale mode
        local boxAlignX = self.boxhalign
        local boxAlignY = self.boxvalign
        local boxWidth = self.width
        local boxHeight = self.height 
        
        if  self.scaleMode == textblox.SCALE_AUTO  then
            --boxAlignX = self.halign
            --boxAlignY = self.valign
            boxWidth = self.autoWidth
            boxHeight = self.autoHeight 
            --windowDebug ("TEST\n\n" .. tostring(self.autoWidth) .. "," .. tostring(self.autoHeight))
        end

        --[[
        if  self.autoWidth == nil  then
            boxWidth = 4
        end
        if  self.autoHeight == nil  then
            boxHeight = 4
        end
        --]]
        
        -- Get box positioning based on anchors
        local boxX = nil
        local boxY = nil
        
        if        boxAlignX == textblox.HALIGN_LEFT  then
            boxX = self.x + shakeX
        
        elseif    boxAlignX == textblox.HALIGN_RIGHT  then
            boxX = self.x - boxWidth + shakeX
        
        else
            boxX = self.x - (0.5*boxWidth) + shakeX
        end

        
        if        boxAlignY == textblox.VALIGN_TOP  then
            boxY = self.y + shakeY
        
        elseif    boxAlignY == textblox.VALIGN_BOTTOM  then
            boxY = self.y - boxHeight + shakeY
        
        else
            boxY = self.y - (0.5*boxHeight) + shakeY
        end

        
        
        -- Draw box        
        if  self.boxType == textblox.BOXTYPE_MENU  then
            if  self.bind == textblox.BIND_SCREEN  then
                graphX.menuBoxScreen (boxX-self.xMargin,
                                      boxY-self.yMargin,
                                      boxWidth + 2*self.xMargin, 
                                      boxHeight + 2*self.yMargin,
                                      self.boxColor, self.boxTex, self.borderTable)
            else
                graphX.menuBoxLevel  (boxX-self.xMargin,
                                      boxY-self.yMargin,
                                      boxWidth + 2*self.xMargin, 
                                      boxHeight + 2*self.yMargin,
                                      self.boxColor, self.boxTex, self.borderTable)
            end
        end
        

        -- Get text positioning based on anchors
        local textX = nil
        local textY = nil
        
        ---[[
        if        self.halign == textblox.HALIGN_LEFT  then
            textX = boxX
        
        elseif    self.halign == textblox.HALIGN_RIGHT  then
            textX = boxX + boxWidth
        
        else
            textX = boxX + 0.5*boxWidth
        end

        
        if        self.valign == textblox.VALIGN_TOP  then
            textY = boxY
        
        elseif    self.valign == textblox.VALIGN_BOTTOM  then
            textY = boxY + boxHeight
        
        else
            textY = boxY + 0.5*boxHeight
        end
        --]]
        

        -- Display text
        self.autoWidth, self.autoHeight = textblox.print   (textToShow, 
                                                            textX + self.font.charWidth*0.5, 
                                                            textY - self.font.charHeight*0.5,
                                                            self.font,
                                                            self.halign,
                                                            self.valign,
                                                            self.width,
                                                            self.textAlpha)
    end

    
    function TextBlock:resetText (textStr)
        self:setText (textStr)
        self.charsShown = 0
        self.finished = false
        self.finishSoundPlayed = false
        self.updatingChars = true
        self.pauseFrames = -1
        self.speed = self.defaultSpeed
    
        if  self.autoTime == true  then
            self:insertTiming ()
        end        
        
        self.filteredText = textStr
        self.length = string.len(textStr)
    end
    
    
    function TextBlock:insertTiming ()
        
        local newText = ""
        local insertTimingMode = true
        
        for textChunk in string.gmatch(self.text, "<*[^<>]+>*")    do
            
            -- Is a command
            if  string.find(textChunk, "<.*>") ~= nil  then
                local commandStr, amountStr = string.match (textChunk, "([^<>%s]+) ([^<>%s]+)")
                if  commandStr == nil  then
                    commandStr = string.match (textChunk, "[^<>%s]+")
                end
                
                -- notiming tags
                if  commandStr == "notiming"  then
                    insertTimingMode = false
                end
                if  commandStr == "/notiming"  then
                    insertTimingMode = true
                end
                
                
            -- Is plaintext
            elseif  insertTimingMode == true  then
                -- Commas
                textChunk = textChunk:gsub('%, ', ',<pause '..tostring(self.midMarkDelay)..'> ')
                
                
                -- Colons and semicolons
                textChunk = textChunk:gsub('%: ', ':<pause '..tostring(self.endMarkDelay)..'> ')
                textChunk = textChunk:gsub('%; ', ';<pause '..tostring(self.endMarkDelay)..'> ')

                
                -- Ellipses
                textChunk = textChunk:gsub("%.%.%. ",     ".<pause "..tostring(self.midMarkDelay)..">"..
                                                        ".<pause "..tostring(self.midMarkDelay)..">"..
                                                        ". ")
            
                
                
                -- End punctuation
                textChunk = textChunk:gsub('%? ', '%?<pause '..tostring(self.endMarkDelay)..'> ')
                textChunk = textChunk:gsub('%?" ', '%?"<pause '..tostring(self.endMarkDelay)..'> ')
                textChunk = textChunk:gsub("%?' ", "%?'<pause "..tostring(self.endMarkDelay)..'> ')
                
                textChunk = textChunk:gsub('%! ', '%!<pause '..tostring(self.endMarkDelay)..'> ')
                textChunk = textChunk:gsub('%!" ', '%!"<pause '..tostring(self.endMarkDelay)..'> ')
                textChunk = textChunk:gsub("%!' ", "%!'<pause "..tostring(self.endMarkDelay)..'> ')
                
                textChunk = textChunk:gsub('%. ', '%.<pause '..tostring(self.endMarkDelay)..'> ')
                textChunk = textChunk:gsub('%." ', '%."<pause '..tostring(self.endMarkDelay)..'> ')
                textChunk = textChunk:gsub("%.' ", "%.'<pause "..tostring(self.endMarkDelay)..'> ')
            end
            
            
            -- Append the string to the end of newText
            newText = newText..textChunk
        end

        
        self.text = newText
    end
    
    
    function TextBlock:setText (textStr)
        self.text = textStr
    end
    
    function TextBlock:getLength ()
        return string.len (self:getTextWrapped ())
    end
    
    function TextBlock:getLengthFiltered ()
        return string.len (self.textFiltered)
    end

    
    function TextBlock:playTypeSound ()
        if  Audio.SfxIsPlaying(self.typeUsedChannel) == 0  and  #self.typeSounds > 0  then
            local sndIndex = rng.randomInt( #self.typeSounds )
            self.typeUsedChannel = Audio.SfxPlayCh (-1, self.typeSoundChunks [sndIndex], 0)
        end
    end
    
    
    
    function  TextBlock:getFinished ()
        return self:isFinished ()
    end
    
    function TextBlock:isFinished ()
        return     self.finished
    end
    
    function TextBlock:playFinishSound ()
        if  self.finishSoundPlayed == false  then
            self.finishSoundPlayed = true
            if  (self.finishSound ~= "")  then
                SFX.play (textblox.getPath(self.finishSound))
            end
        end
    end
    
    function TextBlock:finish ()
        self.pauseFrames = -1
        self.shakeFrames = 0
        self.charsShown = self:getLength()
        self.updatingChars = false
        self.finished = true
    
        self:playFinishSound ()    
        self:onFinish ()
    end
    
    function TextBlock:onFinish ()    
        if  self.autoClose == true  then
            self:closeSelf ()
        end
    end
    
    function TextBlock:closeSelf ()
        -- Undo game pausing
        if  self.pauseGame == true  then
            Misc.unpause ();
        end
        
        -- Play close sound
        if  (self.closeSound ~= "")  then
            SFX.play(textblox.getPath (self.closeSound))
        end
        
        -- Delete
        self:delete ()
    end
    
    function TextBlock:delete ()
        self.deleteMe = true
    end
    
    
    function TextBlock:update ()
        self:updateTiming ()
        
        if  self.pauseGame == true  then
            --player.x = self.playerX
            --player.y = self.playerY
            --player.speedX = 0
            --player.speedY = 0
        end
        
        if  self.inputClose == true            and  
            (player.rawKeys.jump == KEYS_PRESSED or player.rawKeys.run == KEYS_PRESSED or player.rawKeys.altRun == KEYS_PRESSED) then
            
            if  self:getFinished () == true     then
                self:closeSelf ()
            else
                self:finish ()
            end
        end
        
        if  self.visible == true  then
            self.autoWidth,self.autoHeight = self:draw ()
            --Text.print("finished="..tostring(self.finished), 4, 400,300)
        end
    end
    
    
    function TextBlock:updateTiming ()

        -- Subtract from the pause and shake timers
        self.pauseFrames = math.max(self.pauseFrames - 1, 0)
        self.shakeFrames = math.max(self.shakeFrames - 1, 0)
    

        -- Increment typewriter effect once the pause delay is over
        if  (self.pauseFrames <= 0)  then
            
            -- If all characters have been shown, clamp the typewriter effect to full text length and stop updating
            if     self.charsShown > self:getLength ()  then
                self.charsShown = self:getLength ()
                
                -- If hasn't started finishing, stop updating the characters and pause for the finish delay
                if  self.updatingChars == true  then
                    self.updatingChars = false
                    self:playFinishSound ()
                    self.pauseFrames = self.finishDelay
                
                -- Once the finish delay is done, finish the block
                elseif  self.finished == false  then
                    self:finish ()
                end
                
            -- Update the typewriter effect
            else            
                self.charsShown = self.charsShown + 1
                
                local text = self:getTextWrapped ()
                
                local currentChar = text:sub (self.charsShown, self.charsShown)
                if (self:getFinished() == false  and  self.charsShown < self:getLength ()  --[[and  currentChar:match("%w") == true]]) then
                    --Text.print(currentChar, 4, 20, 100)
                    self:playTypeSound ()
                end
                
                -- Skip and process commands
                local continueSkipping = true
                
                while  (continueSkipping == true)  do
                    
                    -- Get current character
                    currentChar = text:sub (self.charsShown, self.charsShown)
                    local currentEscapeChar = text:sub (self.charsShown, self.charsShown+1)
                    
                    -- if it's an escape character
                    --if  currentEscapeChar ~= '/<'  then
                    --    self.charsShown = self.charsShown + 2
                    
                    -- if it's the start of a command...
                    if  currentChar == '<'  then
                        
                        -- ...First parse the command...
                        local commandEnd = text:find ('>', self.charsShown)
                        local fullCommand = text:sub (self.charsShown, commandEnd)
                        local commandName = fullCommand:match ('%a+', 1)
                        local commandArgsPlusEnd = nil
                        local commandArgs = nil
                        local abortNow = false
                        
                        if commandName ~= nil  then
                            commandArgsPlusEnd = fullCommand:match ('%s.+>', 1)--commandName:len())                        
                            --windowDebug ("Name: " .. commandName .. "\nArgs plus end: " .. tostring(commandArgsPlusEnd))

                        end
                        
                        if  commandArgsPlusEnd ~= nil  then                        
                            commandArgs = commandArgsPlusEnd:sub (2, commandArgsPlusEnd:len() - 1)
                        end

                        
                        -- ...then perform behavior based on the command...
                        -- Pause:  if no arguments, assume a full second
                        if  commandName == 'pause' then
                            --windowDebug (tostring(commandArgs))
                            
                            if  commandArgs == nil then
                                commandArgs = 60
                            end
                            
                            if  commandArgs == "mid"  then
                                commandArgs = midMarkDelay
                            end
                            if  commandArgs == "end"  then
                                commandArgs = endMarkDelay
                            end
                            
                            --windowDebug (tostring(commandArgs))
                            
                            self.pauseFrames = self.pauseFrames + commandArgs
                            abortNow = true
                        
                        
                        -- change speed
                        elseif  commandName == 'speed' then
                            if  commandArgs == nil then
                                commandArgs = 0.5
                            end
                            
                            self.speed = commandArgs
                            abortNow = true
                        
                        
                        -- Play sound effect
                        elseif  commandName == 'sound' then
                            if  commandArgs ~= nil then
                                local sound = Misc.resolveSoundFile (commandArgs)
                                
                                if sound ~= nil  then
                                    SFX.play(textblox.getPath (sound))
                                end
                            end
                            
                            self.pauseFrames = self.pauseFrames + commandArgs
                    
                    
                        -- Shake
                        elseif  commandName == 'shake' then
                            if  commandArgs == 'screen' or commandArgs == '0' or commandArgs == nil  then
                                earthquake(8)
                                
                            elseif  commandArgs == 'box' or commandArgs == '1'  then
                                self.shakeFrames = 8
                            end
                        
                        end                    
                    
                    
                        -- ...then add the length of the command to the displayed characters to skip the command
                        if  abortNow == true  then
                            continueSkipping = false
                            self.charsShown = self.charsShown - 1
                        end
                        
                        self.charsShown = self.charsShown + fullCommand:len()
                    
                    
                    -- Otherwise, stop processing
                    else
                        continueSkipping = false            
                    end
                end
                
                
                
                -- Pause for X frames
                local framesToPause = (1/self.speed)
                self.pauseFrames = self.pauseFrames + framesToPause
            end
            
        end    
        
    end
    
    
    function textblox.formatDialogForWrapping (text, wrapChars, addSlashN)
        
        -- Setup
        local newString = text
        local strLength = text:len()
        local currentLineWidth = 0
        local markupMode = 0
        
        local oldPos = 1
        local newOffset = 0
        local newOffsetDebug = 0
        
        local lineStart = 1
        local charsOnLine = 0
        local totalShownChars = 0
        
        local currentSpace = 1
        local prevSpace = 1
        local currentSpaceVisChars  = 0
        local prevSpaceVisChars  = 0
        
        local currentDash = 1
        local prevDash = 1
        local currentDashVisChars  = 0
        local prevDashVisChars  = 0
        
        
        while (oldPos <= strLength) do 
        
            -- Get character
            local lastNum = math.max(1, oldPos-1)
            
            local lastChar = text:sub(lastNum, lastNum)
            local thisChar = text:sub(oldPos,oldPos)
            local nextChar = text:sub(oldPos+1, oldPos+1)
            local continue = false
                                
            
            -- Wrap words when necessary
            if  charsOnLine > wrapChars  then
            
                
                local firstHalf = nil
                local secondHalf = nil
                local breakPoint = nil
            
            
                -- Add a break command + \n for debugging purposes
                local breakStr = "<br>"
                if  addSlashN == true  then
                    breakStr =     "_\n" 
                                .. tostring(prevSpace-lineStart) .. "," .. tostring(currentSpace-lineStart) .. ", " .. tostring(oldPos-lineStart) 
                                .. "   " .. tostring(newOffsetDebug) .. ", " .. tostring(oldPos+newOffsetDebug) .. ", " .. tostring(oldPos+newOffsetDebug-lineStart)
                                .. "   " .. tostring(prevSpaceVisChars) .. "/" .. tostring(currentSpaceVisChars) .. ", " .. tostring(charsOnLine).. "\n\n"
                end
                
            
                -- If a line break can be inserted between words, do so
                if  currentSpace ~= lineStart  then
                    breakPoint = currentSpace
                    
                    firstHalf = newString:sub (1, breakPoint + newOffset)
                    secondHalf = newString:sub (breakPoint + 1 + newOffset, strLength + newOffset)
                
                    newString = firstHalf .. breakStr .. secondHalf
                    newOffset = newOffset + breakStr:len()
                    newOffsetDebug = newOffsetDebug + 4 - 1
                
                
                -- Otherwise, if the word already has a dash, break the line there
                elseif  currentDash ~= lineStart  then
                    breakPoint = currentDash

                    firstHalf = newString:sub (1, breakPoint + newOffset)
                    secondHalf = newString:sub (breakPoint + 1 + newOffset, strLength + newOffset)                    
                    
                    newString = firstHalf .. breakStr .. secondHalf
                    newOffset = newOffset + breakStr:len()
                    newOffsetDebug = newOffsetDebug + 4
                
                
                -- Otherwise, insert a dash and a break
                else
                    breakPoint = oldPos - 3
                    
                    firstHalf = newString:sub (1, breakPoint + newOffset)
                    secondHalf = newString:sub (breakPoint + 1 + newOffset, strLength + newOffset)
                    
                    newString = firstHalf .. "-" .. breakStr .. secondHalf
                    newOffset = newOffset + 1 + breakStr:len()
                    newOffsetDebug = newOffsetDebug + 4 + 1            
                end
                
                
                -- Set up new line
                local newLineString = text:sub(breakPoint, oldPos)
                newLineString = newLineString:gsub ('<.*>', '')
                
                newLineChars = newLineString:len()
                
                charsOnLine = newLineChars
                lineStart = oldPos
                
                currentSpace = oldPos
                prevSpace = oldPos
                currentDash = oldPos
                prevDash = oldPos

                currentSpaceVisChars = 0
                prevSpaceVisChars = 0
                currentDashVisChars = 0
                prevDashVisChars = 0
            end

            
            -- Store space position
            if  thisChar == ' '  and  markupMode <= 0   then
                prevSpace = currentSpace
                currentSpace = oldPos
                prevSpaceVisChars = currentSpaceVisChars
                currentSpaceVisChars = charsOnLine
                
            
            -- Store dash position
            elseif  thisChar == '-'  and  markupMode <= 0   then
                prevDash = currentDash
                currentDash = oldPos
                prevSpaceVisChars = currentDashVisChars
                currentDashVisChars = charsOnLine
            
            -- Skip tags
            elseif  thisChar == '<'        then        
                markupMode = markupMode + 1
                continue = true
                
                -- But catch pre-existing breaks
                if  text:sub (oldPos, oldPos+3) == '<br>'  then
                    charsOnLine = 0
                    lineStart = oldPos
                    
                    currentSpace = oldPos
                    prevSpace = oldPos
                    currentDash = oldPos
                    prevDash = oldPos
                end
                
            elseif  thisChar == ">"      then
                markupMode = markupMode - 1
                continue = true
            end
            
            
            
            
            -- Count the current character                
            if  continue == false  and  markupMode <= 0  then            
                charsOnLine = charsOnLine + 1
                totalShownChars = totalShownChars + 1
            end
            
            
            -- Increment i
            oldPos = oldPos+1
        end
        
        return newString
    end
end


        


--***************************************************************************************************
--                                                                                                  *
--              UPDATE                                                                                *
--                                                                                                  *
--***************************************************************************************************


textblox.waveModeCycle = 0

do
    function textblox.update ()
        textblox.waveModeCycle = (textblox.waveModeCycle + 0.25)%360
    
    
        -- Loop through and update/delete the text blocks
        local k = 1;
        while  k <= #textblox.textBlockRegister  do
            
            local v = textblox.textBlockRegister [k]
            if  (v.deleteMe == true)  then
                table.remove (textblox.textBlockRegister, k);
            
            else
                v.index = k;
                v:update ()
                k = k+1;
            end
        end
        
        -- Run garbage collection        
        --collectgarbage("collect")
    end    
    
    
    textblox.overrideProps =   {scaleMode = textblox.SCALE_AUTO, 
                                startSound = "sound\\message.ogg",
                                typeSounds = {"bwip.ogg","bwip2.ogg","bwip3.ogg"},
                                finishSound = "sound\\zelda-dash.ogg",   --has-item
                                closeSound = "sound\\zelda-fairy.ogg",  --zelda-dash, zelda-stab, zelda-fairy
                                width = 400,
                                height = 350,
                                bind = textblox.BIND_SCREEN,
                                font = textblox.FONT_SPRITEDEFAULT3X2,
                                speed = 0.75,
                                boxType = textblox.BOXTYPE_MENU,
                                boxColor = 0x0000FFBB,
                                autoTime = true, 
                                pauseGame = true, 
                                inputClose = true, 
                                boxAnchorX = textblox.HALIGN_MID, 
                                boxAnchorY = textblox.VALIGN_MID, 
                                textAnchorX = textblox.HALIGN_TOP, 
                                textAnchorY = textblox.VALIGN_LEFT,
                                marginX = 4,
                                marginY = 16}
    
    
    function textblox.onMessageBox(eventObj, message)
        if textblox.active == false then
            --Nothing
        end
        if textblox.overrideMessageBox == true and textblox.active == true then
            eventObj.cancelled = true
            mem(0x00B250E4, FIELD_STRING, "")
            textblox.currentMessage = TextBlock.create (400,192, message, textblox.overrideProps)
            Misc.pause ()
        end
    end
end    



    


--***************************************************************************************************
--                                                                                                  *
--              UPDATE                                                                                *
--                                                                                                  *
--***************************************************************************************************

    
return textblox