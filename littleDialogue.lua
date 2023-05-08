--[[

    littleDialogue.lua (v1.1)
    Written by MrDoubleA

    Documentation: https://docs.google.com/document/d/1oJUQT6FvgtX7UA26r-JAWcG41Ns6lpe9iIP4qPEm6zw/edit?usp=sharing

    Yoshi's Island font ripped by Nemica (https://www.spriters-resource.com/snes/yoshiisland/sheet/19542/)
    Font for Superstar Saga-styled box by rixithechao (https://www.supermariobrosx.org/forums/viewtopic.php?f=31&t=26204#p376929)

]]

local configFileReader = require("configFileReader")
local textplus = require("textplus")
local tplusUtils = require("textplus/tplusutils")
local cursor = require("cursor")
local handycam = require("handycam")

local littleDialogue = {}

GameData.answersActive = false
littleDialogue.boxenabled = false
littleDialogue.cursorEnabled = false

local cooldown = 0

littleDialogue.answerYUpdatable = 0
littleDialogue.answerWidthUpdatable = 0
littleDialogue.answerHeightUpdatable = 0
littleDialogue.mainTextYUpdatable = 0
littleDialogue.questionGapUpdatable = 0
littleDialogue.iconXUpdatable = 0

littleDialogue.sourceWidthUpdatable = 0
littleDialogue.sourceHeightUpdatable = 0

littleDialogue.answerX = 0
littleDialogue.answerY = 0

pcall(function() smallScreen = require("smallScreen") end)

function littleDialogue.onInitAPI()
    registerEvent(littleDialogue,"onTick")
    registerEvent(littleDialogue,"onDraw")
    registerEvent(littleDialogue,"onMessageBox")
end

local function getBoundaries()
    local b = camera.bounds

    if smallScreen ~= nil and smallScreen.croppingEnabled then
        local widthDifference  = (camera.width  - smallScreen.width ) * 0.5
        local heightDifference = (camera.height - smallScreen.height) * 0.5

        b.left   = b.left   + widthDifference
        b.right  = b.right  - widthDifference
        b.top    = b.top    + heightDifference
        b.bottom = b.bottom - heightDifference
    end

    return b
end

local function getTextPosFromValue(pos) -- takes a number, layout or formatted text and returns the numbers of characters from it
    if type(pos) == "TextplusLayout" then -- pos is a layout: find how long the layout is.
        local lineCount = #pos
        local characterCount = 0

        -- Go through each line
        for lineIndex,line in ipairs(pos) do
            -- Add the length of each segment
            for i = 1,#line,4 do
                local segment = line[i]

                if segment.img ~= nil then
                    characterCount = characterCount + 1
                else
                    characterCount = characterCount + (line[i+2] - line[i+1]) + 1
                end
            end

            -- New lines count too
            if lineIndex < lineCount then
                characterCount = characterCount + 1
            end
        end
        
        return characterCount
    elseif type(pos) == "table" then -- pos is a list of segments: find how long it is
        local characterCount = 0

        for _,segment in ipairs(pos) do
            if segment.img ~= nil then
                characterCount = characterCount + 1
            else
                characterCount = characterCount + #segment
            end
        end

        return characterCount
    elseif type(pos) == "number" then
        return pos
    else
        return error("Invalid value for text position: '".. tostring(pos).. "'")
    end
end


littleDialogue.boxes = {}

local boxInstanceFunctions = {}
local boxMT = {
    __index = boxInstanceFunctions,
}


local STATE = {
    IN     = 0,
    STAY   = 1,
    SCROLL = 2,
    OUT    = 3,
    SCROLL_ANSWERS = 4,

    REMOVE = -1,
}


local customTags = {}
local selfClosingTags = {}

local textEventFuncs = {} -- custom thing, for typewriter effects

littleDialogue.customTags = customTags
littleDialogue.selfClosingTags = selfClosingTags

littleDialogue.textEventFuncs = textEventFuncs


-- Custom tags
local currentlyUpdatingBox,currentlyUpdatingPage

do
    local function setVoice(box,name)
        -- Look for voice file
        if name == nil or name == "" then
            box.voiceSound = nil
        else
            local path = Misc.resolveSoundFile("littleDialogue/portraits/".. name) or Misc.resolveSoundFile("littleDialogue/".. name) or Misc.resolveSoundFile(name)
    
            if path ~= nil then
                box.voiceSound = SFX.open(path)
            else
                box.voiceSound = nil
            end
        end
    end



    local questionsMap = {}

    function littleDialogue.registerAnswer(name,answer)
        questionsMap[name] = questionsMap[name] or {}

        answer.text = answer.text or answer[1] or ""
        answer.chosenFunction = answer.chosenFunction or answer[2]
        answer.addText = answer.addText or answer[3]

        table.insert(questionsMap[name],answer)
    end

    function littleDialogue.deregisterQuestion(name)
        questionsMap[name] = nil
    end


    function customTags.question(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of question tag.")
            return fmt
        end

        local name = args[1]
        local answers = questionsMap[name]

        if answers == nil then
            Misc.warn("Invalid question '".. name.. "'.")
            return fmt
        end


        for _,answer in ipairs(answers) do
            currentlyUpdatingBox:addQuestion(currentlyUpdatingPage,answer)
        end

        return fmt
    end

    table.insert(selfClosingTags,"question")



    local settingsList

    local extraSettingsList = {
        "font","speakerNameFont","boxImage","continueArrowImage","scrollArrowImage","selectorImage","speakerNameBoxImage","lineMarkerImage",
        "openSound","closeSound","scrollSound","typewriterSound","moveSelectionSound","chooseAnswerSound",
        "mainTextShader","speakerNameTextShader",
    }


    local function loadImage(settings,styleName,name,imageFilename)
        local path = Misc.resolveFile("littleDialogue/".. styleName.. "/".. imageFilename) or Misc.resolveFile("littleDialogue/".. imageFilename)

        if path ~= nil then
            settings[name] = Graphics.loadImage(path)
        end
    end
    local function loadSound(settings,styleName,name,soundFilename)
        settings[name] = Misc.resolveSoundFile("littleDialogue/".. styleName.. "/".. soundFilename) or Misc.resolveSoundFile("littleDialogue/".. soundFilename)
    end

    local function findFont(styleName,fontFileName)
        local folderPath = "littleDialogue/".. styleName.. "/".. fontFileName
        if Misc.resolveFile(folderPath) ~= nil then
            return folderPath
        end

        local mainPath = "littleDialogue/".. fontFileName
        if Misc.resolveFile(mainPath) ~= nil then
            return mainPath
        end

        return nil
    end

    local function compileShader(styleName,vertName,fragName)
        local vertPath = Misc.resolveFile("littleDialogue/".. styleName.. "/".. vertName) or Misc.resolveFile("littleDialogue/".. vertName)
        local fragPath = Misc.resolveFile("littleDialogue/".. styleName.. "/".. fragName) or Misc.resolveFile("littleDialogue/".. fragName)

        if vertPath ~= nil or fragPath ~= nil then
            local obj = Shader()
            obj:compileFromFile(vertPath,fragPath)

            return obj
        end

        return nil
    end


    littleDialogue.styles = {}

    function boxInstanceFunctions:setStyle(style)
        if self.styleName == style then
            return
        end


        local styleSettings = littleDialogue.styles[style]

        if styleSettings == nil then
            error("Invalid box style '".. style.. "'.")
            return
        end


        self.styleName = style

        self.settings = {}

        for _,name in ipairs(settingsList) do
            if self.overwriteSettings[name] ~= nil then
                self.settings[name] = self.overwriteSettings[name]
            elseif styleSettings[name] ~= nil then
                self.settings[name] = styleSettings[name]
            else
                self.settings[name] = littleDialogue.defaultBoxSettings[name]
            end
        end

        self.maxWidth = self.settings.textMaxWidth
        self.typewriterFinished = (not self.settings.typewriterEnabled)
        self.priority = self.settings.priority
    end

    function littleDialogue.registerStyle(name,settings)
        if settingsList == nil then
            settingsList = table.append(table.unmap(littleDialogue.defaultBoxSettings),extraSettingsList)
        end

        -- Find images/sounds
        loadImage(settings,name,"boxImage","box.png")
        loadImage(settings,name,"continueArrowImage","continueArrow.png")
        loadImage(settings,name,"scrollArrowImage","scrollArrow.png")
        loadImage(settings,name,"selectorImage","selector.png")
        loadImage(settings,name,"speakerNameBoxImage","speakerNameBox.png")
        loadImage(settings,name,"lineMarkerImage","lineMarker.png")

        loadSound(settings,name,"openSound","open")
        loadSound(settings,name,"closeSound","close")
        loadSound(settings,name,"scrollSound","scroll")
        --loadSound(settings,name,"typewriterSound","typewriter")
        loadSound(settings,name,"moveSelectionSound","scroll")
        loadSound(settings,name,"chooseAnswerSound","choose")

        settings.typewriterSound = SFX.open(Misc.resolveSoundFile("littleDialogue/".. name.. "/typewriter") or Misc.resolveSoundFile("littleDialogue/typewriter"))

        settings.font = settings.font or textplus.loadFont(findFont(name,"font.ini"))

        if settings.speakerNameFont == nil then
            local speakerNameFont = findFont(name,"speakerNameFont.ini")
            if speakerNameFont ~= nil then
                settings.speakerNameFont = textplus.loadFont(speakerNameFont)
            else
                settings.speakerNameFont = settings.font
            end
        end

        -- Load font shader
        settings.mainTextShader = settings.mainTextShader or compileShader(name,"mainText.vert","mainText.frag")
        settings.speakerNameTextShader = settings.speakerNameTextShader or compileShader(name,"speakerNameText.vert","speakerNameText.frag") or settings.mainTextShader


        littleDialogue.styles[name] = settings
    end


    function customTags.boxStyle(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of boxStyle tag.")
            return fmt
        end

        currentlyUpdatingBox._newStyle = args[1] or currentlyUpdatingBox.styleName

        return fmt
    end

    customTags.boxstyle = customTags.boxStyle

    table.insert(selfClosingTags,"boxStyle")


    local keyCodeNames = {
        [VK_MENU] = "key_alt",[VK_SHIFT] = "key_shift",[VK_CONTROL] = "key_control",[VK_TAB] = "key_tab",
        [VK_BACK] = "key_backspace",[VK_PRIOR] = "key_pageUp",[VK_NEXT] = "key_pageDown",[VK_HOME] = "key_home",
        [VK_END] = "key_end",[VK_DELETE] = "key_delete",[VK_SPACE] = "key_space",[VK_RETURN] = "key_enter",
        [VK_UP] = "button_up",[VK_RIGHT] = "button_right",[VK_DOWN] = "button_down",[VK_LEFT] = "button_left",
    }

    function customTags.playerKey(fmt,out,args)
        local keyName = (args[1] or ""):lower()
        local keyCode = inputConfig1[keyName]

        if keyCode == nil then
            return fmt
        end


        local imageName

        if Player.count() > 1 or Misc.GetSelectedControllerName(1) ~= "Keyboard" then
            imageName = "button_".. keyName
        elseif keyCode >= 65 and keyCode <= 90 then
            imageName = string.char(keyCode)
        elseif keyCodeNames[keyCode] then
            imageName = keyCodeNames[keyCode]
        else
            imageName = "button_".. keyName
        end


        local imagePath

        if currentlyUpdatingBox ~= nil then
            imagePath = imagePath or Misc.resolveGraphicsFile("littleDialogue/".. currentlyUpdatingBox.styleName.. "/keys/".. imageName.. ".png")
        end

        imagePath = imagePath or Misc.resolveGraphicsFile("littleDialogue/keys/".. imageName.. ".png")


        if imagePath == nil then
            return fmt
        end

        local imageFmt = table.clone(fmt)
        imageFmt.posFilter = function(x,y, fmt,img, width,height)
            return x,y + height*0.5 - fmt.font.ascent*fmt.yscale*0.5
        end

        out[#out+1] = {img = Graphics.loadImage(imagePath),fmt = imageFmt}

        return fmt
    end

    customTags.playerkey = customTags.playerKey

    table.insert(selfClosingTags,"playerKey")

    -- Portraits
    local portraitData = {}

    function littleDialogue.getPortraitData(name)
        if portraitData[name] == nil then
            local txtPath = Misc.resolveFile("littleDialogue/portraits/".. name.. ".txt")
            local data

            if txtPath ~= nil then
                data = configFileReader.rawParse(txtPath,false)
            else
                data = {}
            end

            data.name = name

            data.idleFrames = data.idleFrames or 1
            data.idleFrameDelay = data.idleFrameDelay or 1
            data.speakingFrames = data.speakingFrames or 0
            data.speakingFrameDelay = data.speakingFrameDelay or 1

            data.variations = data.variations or 1


            local imagePath = Misc.resolveGraphicsFile("littleDialogue/portraits/".. name.. ".png")

            if imagePath ~= nil then
                data.image = Graphics.loadImage(imagePath)
                data.width = data.image.width / data.variations
                data.height = data.image.height / (data.idleFrames + data.speakingFrames)
            else
                data.width = 0
                data.height = 0
            end


            portraitData[name] = data
        end

        return portraitData[name]
    end

    function customTags.portrait(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of portrait tag.")
            return fmt
        end

        currentlyUpdatingBox:addTextEvent(currentlyUpdatingPage,out,"portrait",args)

        return fmt
    end

    function textEventFuncs.portrait(box,page,pos,args)
        local name = args[1]
        local needsToUpdateLayouts = false

        if name == nil or name == "" then
            box._newPortraitData = nil

            box._newSpeakerName = ""
            setVoice(box,nil)
        else
            local portraitData = littleDialogue.getPortraitData(name)

            box._newPortraitData = portraitData
            box.portraitVariation = (args[2] or 1) - 1

            box._newSpeakerName = portraitData.speakerName or box._newSpeakerName
            setVoice(box,portraitData.voice)
        end
    end

    table.insert(selfClosingTags,"portrait")


    -- shake tag
    -- at the time I made this I didn't know tremble existed lol
    --[[function customTags.shake(fmt,out,args)
        fmt = table.clone(fmt)

        fmt.shake = args[1] or 0.75

        fmt.posFilter = function(x,y, fmt,img, width,height)
            return x + RNG.random(-fmt.shake,fmt.shake),y + RNG.random(-fmt.shake,fmt.shake)
        end

        return fmt
    end]]

    -- characterName tag
    littleDialogue.characterNames = {
        [1]  = "Mario",
        [2]  = "Luigi",
        [3]  = "Peach",
        [4]  = "Toad",
        [5]  = "Link",
        [6]  = "Megaman",
        [7]  = "Wario",
        [8]  = "Bowser",
        [9]  = "Klonoa",
        [10] = "Yoshi",
        [11] = "Rosalina",
        [12] = "Snake",
        [13] = "Zelda",
        [14] = "Steve",
        [15] = "Uncle Broadsword",
        [16] = "Samus",
    }

    function customTags.characterName(fmt,out,args)
        local text = ""

        for index,p in ipairs(Player.get()) do
            text = text.. (littleDialogue.characterNames[p.character] or "Player")

            if index < Player.count()-1 then
                text = text.. ", "
            elseif index < Player.count() then
                text = text.. " and "
            end
        end

        local segment = tplusUtils.strToCodes(text)
        segment.fmt = fmt

        out[#out+1] = segment

        return fmt
    end
    
    table.insert(selfClosingTags,"characterName")

    function customTags.speakerName(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of portrait tag.")
            return fmt
        end

        currentlyUpdatingBox:addTextEvent(currentlyUpdatingPage,out,"speakerName",args)
        --currentlyUpdatingBox.speakerName = (args[1] or "")

        return fmt
    end

    function textEventFuncs.speakerName(box,page,pos,args)
        box._newSpeakerName = args[1] or ""
    end

    table.insert(selfClosingTags,"speakerName")


    -- Delay
    function customTags.delay(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of delay tag.")
            return fmt
        end

        currentlyUpdatingBox:addTextEvent(currentlyUpdatingPage,out,"delay",args)

        return fmt
    end

    function textEventFuncs.delay(box,page,pos,args)
        if not box.typewriterFinished then
            box.typewriterDelay = args[1] or box.settings.typewriterDelayLong
            box.typewriterLongDelayWaiting = false
        end
    end

    table.insert(selfClosingTags,"delay")


    -- Voice
    function customTags.voice(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of voice tag.")
            return fmt
        end

        currentlyUpdatingBox:addTextEvent(currentlyUpdatingPage,out,"voice",args)

        return fmt
    end

    function textEventFuncs.voice(box,page,pos,args)
        setVoice(box,args[1])
    end

    table.insert(selfClosingTags,"voice")


    -- setPos
    function customTags.setPos(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of setPos tag.")
            return fmt
        end

        currentlyUpdatingBox:addTextEvent(currentlyUpdatingPage,out,"setPos",args)

        return fmt
    end

    function textEventFuncs.setPos(box,page,pos,args)
        if args[1] ~= nil and args[2] ~= nil then
            box.forcedPosX = args[1]
            box.forcedPosY = args[2]
            box.forcedPosHorizontalPivot = args[3] or 0.5
            box.forcedPosVerticalPivot = args[4] or 0.5
        else
            box.forcedPosX = nil
            box.forcedPosY = nil
            box.forcedPosHorizontalPivot = nil
            box.forcedPosVerticalPivot = nil
        end
    end

    table.insert(selfClosingTags,"setPos")


    -- break with no marker
    function customTags.brNoMarker(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of brNoMarker tag.")
            return fmt
        end

        out[#out+1] = {string.byte("\n"), fmt = fmt}

        local pageData = currentlyUpdatingBox.pageData[currentlyUpdatingPage]

        if pageData ~= nil then
            local pos = getTextPosFromValue(out)
            
            pageData._noMarkerIndices[pos] = true
        end

        return fmt
    end

    table.insert(selfClosingTags,"brNoMarker")

    -- no auto delay
    function customTags.noAutoDelay(fmt,out,args)
        if currentlyUpdatingBox == nil or currentlyUpdatingPage == nil then
            Misc.warn("Invalid use of brNoMarker tag.")
            return fmt
        end

        local pageData = currentlyUpdatingBox.pageData[currentlyUpdatingPage]

        if pageData ~= nil then
            pageData.noAutoDelay = true
        end

        return fmt
    end

    table.insert(selfClosingTags,"noAutoDelay")
end



littleDialogue.BOX_STATE = STATE


function littleDialogue.create(args)
    local box = setmetatable({},boxMT)

    box.isValid = true

    box.text = args.text or ""
    if Player.count() >= 2 then
        box.speakerObj = args.speakerObj or player or player2
    elseif Player.count() == 1 then
        box.speakerObj = args.speakerObj or player
    end
    box.uncontrollable = args.uncontrollable or false
    box.uncloseableByPlayer = args.uncloseableByPlayer or false
    box.silent = args.silent or false

    box.pauses = args.pauses
    if box.pauses == nil then
        box.pauses = true
    end

    box.keepOnScreen = args.keepOnScreen
    if box.keepOnScreen == nil then
        box.keepOnScreen = true
    end

    box.updatesInPause = args.updatesInPause
    if box.updatesInPause == nil then
        box.updatesInPause = box.pauses
    end



    box.openingProgress = 0
    box.state = STATE.IN

    box.page = 1

    box.answersPageIndex = {}
    box.answersPageTarget = 1

    box.selectedAnswer = 1


    box.mainWidth = 0
    box.mainHeight = 0
    
    box.closebox = false

    box.typewriterLimit = 0
    box.typewriterDelay = 0
    box.typewriterLongDelayWaiting = false
    box.typewriterFinished = true

    
    box.portraitData = nil
    box.portraitFrame = 0
    box.portraitTimer = 0
    box.portraitVariation = 0

    box.speakerName = args.speakerName or ""
    box.speakerNameLayout = nil

    box.voiceSound = nil

    box.mainOffsetY = 0


    -- Note: these are for the <setPos> tag/args for creating, not the settings!
    box.forcedPosX = args.forcedPosX
    box.forcedPosY = args.forcedPosY
    box.forcedPosHorizontalPivot = args.forcedPosHorizontalPivot
    box.forcedPosVerticalPivot = args.forcedPosVerticalPivot


    box.overwriteSettings = args.settings or {}
    box:setStyle(args.style or littleDialogue.defaultStyleName)
    
    box.commandexecute = args.chosenFunction

    box:updateLayouts()
    

    if box.pauses then
        Misc.pause(true)
    end

    if not box.silent and box.settings.openSoundEnabled then
        SFX.play(box.settings.openSound)
    end
    
    if box.closebox == true then
        box.state = STATE.OUT
    end

    
    table.insert(littleDialogue.boxes,box)

    return box
end




function boxInstanceFunctions:addQuestion(pageIndex,answer)
    local maxWidth = self.maxWidth
    if self.settings.selectorImage ~= nil and self.settings.selectorImageEnabled then
        maxWidth = maxWidth - self.settings.selectorImage.width
    end
    if self.portraitData ~= nil then
        maxWidth = maxWidth - self.portraitData.width
    end

    local layout = textplus.layout(answer.text,maxWidth,{font = self.settings.font,color = self.settings.textColor,xscale = self.settings.textXScale,yscale = self.settings.textYScale},customTags,selfClosingTags)


    local page = self.pageData[pageIndex]

    local answerPageCount = #page.answerPages
    local answerPage = page.answerPages[answerPageCount]

    if answerPageCount == 0 or answerPage.height+layout.height+self.settings.answerGap >= self.settings.answerPageMaxHeight then
        -- Create new page of answers
        local firstAnswerIndex = 1
        if answerPageCount > 0 then
            firstAnswerIndex = answerPage.firstAnswerIndex + #answerPage.answers
        end

        answerPageCount = answerPageCount + 1

        answerPage = {answers = {},width = 0,height = 0,firstAnswerIndex = firstAnswerIndex}
        page.answerPages[answerPageCount] = answerPage
    else
        answerPage.height = answerPage.height + self.settings.answerGap
    end



    local width = layout.width
    if self.settings.selectorImage ~= nil and self.settings.selectorImageEnabled then
        width = width + self.settings.selectorImage.width
    end

    answerPage.width = math.max(answerPage.width,width)
    answerPage.height = answerPage.height + layout.height

    local answerObj = {
        text = answer.text,layout = layout,
        chosenFunction = answer.chosenFunction,
        addText = answer.addText,
    }
    
    table.insert(answerPage.answers,answerObj)
    table.insert(page.plainAnswerList,answerObj)
    
    GameData.answersActive = true
    page.totalAnswersCount = page.totalAnswersCount + 1
end



function boxInstanceFunctions:addTextEvent(pageIndex,addPos,eventName,eventArgs)
    addPos = getTextPosFromValue(addPos)

    local page = self.pageData[pageIndex]
    local textEventsList = page.textEvents[addPos]

    -- If this character has no events yet, make a list
    if textEventsList == nil then
        textEventsList = {}
        page.textEvents[addPos] = textEventsList
    end

    -- Add this event to the list
    table.insert(textEventsList,{eventName,eventArgs})
end


-- Activates the effects of tags like <portrait>, <speakerName> or <voice> between the characters specified
function boxInstanceFunctions:activateTextEvents(startPos,endPos)
    -- Setup values for the events: these are to let the event funcs say that :updateLayouts needs to be run.
    -- The reason why this isn't done in the events themselves is that that can cause stack overflow and other nonsense
    self._newPortraitData = self.portraitData
    self._newSpeakerName = self.speakerName


    local pageIndex = math.floor(self.page)
    local page = self.pageData[pageIndex]

    for i = (startPos or 0), (endPos or #page.characterList) do
        local events = page.textEvents[i]

        if events ~= nil then
            for _,event in ipairs(events) do
                local func = textEventFuncs[event[1]]

                func(self,pageIndex,i,event[2])
            end
        end
    end


    -- Check those values
    if self._newPortraitData ~= self.portraitData or self._newSpeakerName ~= self.speakerName then
        self.portraitData = self._newPortraitData
        self.speakerName = self._newSpeakerName

        self:updateLayouts()
    end
end


function boxInstanceFunctions:updateLayouts()
    -- Initial setup for pages (rest comes later)
    self.pageData = {}
    self.pageCount = 0

    for index,text in ipairs(string.split(self.text,"<page>",true)) do
        local page = {}

        page.index = index
        page.text = text

        self.pageCount = self.pageCount + 1
        self.pageData[self.pageCount] = page
    end

    self.speakerNameLayout = nil
    self.mainOffsetY = 0


    currentlyUpdatingBox = self


    -- _newStyle is for the <boxStyle> tag. If that tag is parsed, it'll set _newStyle and then things can be re-done.
    self._newStyle = self.styleName


    local totalBorderSize = self.settings.borderSize*2

    local mainTextFmt = {font = self.settings.font,color = self.settings.textColor,xscale = self.settings.textXScale,yscale = self.settings.textYScale}

    local hasLineMarkers = (self.settings.lineMarkerImage ~= nil and self.settings.lineMarkerEnabled)

    for index,page in ipairs(self.pageData) do
        currentlyUpdatingPage = index

        page.answerPages = {}
        page.plainAnswerList = {}
        page.totalAnswersCount = 0
        page.answersPageIndex = page.answersPageIndex or 1

        page.lineMarkers = {}
        page._noMarkerIndices = {}

        page.noAutoDelay = false

        page.textEvents = {}


        page.formattedText = textplus.parse(page.text,mainTextFmt,customTags,selfClosingTags)

        if self._newStyle ~= self.styleName then -- change style
            self:setStyle(self._newStyle)
            self:updateLayouts()
            return
        end


        local arrowWidth = 0
        if index < self.pageCount and page.totalAnswersCount == 0 and not self.uncontrollable
        and self.settings.continueArrowEnabled and self.settings.continueArrowImage ~= nil
        then
            arrowWidth = self.settings.continueArrowImage.width
        end

        local maxWidth = self.maxWidth - arrowWidth
        if self.portraitData ~= nil then
            maxWidth = maxWidth - self.portraitData.width - self.settings.portraitGap
        end

        if hasLineMarkers then
            maxWidth = maxWidth - self.settings.lineMarkerImage.width
        end


        page.layout = textplus.layout(page.formattedText,maxWidth)

        local width = page.layout.width + arrowWidth
        local height = page.layout.height


        -- Question stuff
        local widestAnswerPageWidth = 0

        page.answersHeight = 0

        for answerPageIndex,answerPage in ipairs(page.answerPages) do
            widestAnswerPageWidth = math.max(widestAnswerPageWidth, answerPage.width)
            page.answersHeight = math.max(page.answersHeight, answerPage.height)
        end


        width = math.max(widestAnswerPageWidth,width)
        height = height + page.answersHeight


        local answerPageCount = #page.answerPages

        if answerPageCount > 0 then
            height = height + self.settings.questionGap

            if answerPageCount > 1 and self.settings.scrollArrowEnabled and self.settings.scrollArrowImage ~= nil then
                height = height + self.settings.scrollArrowImage.height*2
            end
        end


        if self.portraitData ~= nil then
            width = width + self.portraitData.width + self.settings.portraitGap
            height = math.max(height,self.portraitData.height)
        end


        self.mainWidth = math.max(self.mainWidth,width)
        self.mainHeight = math.max(self.mainHeight,height)


        -- Find where to place line markers
        local characterCount = 0
        local isForcedLine = {}

        for i,segment in ipairs(page.formattedText) do
            local list = {}

            for _,character in ipairs(segment) do
                characterCount = characterCount + 1
                --table.insert(list,string.char(character))

                if character == 10 and not page._noMarkerIndices[characterCount] then
                    isForcedLine[page.formattedText[i]] = true
                end
            end
        end


        -- Simplify the character list and add line markers
        page.characterList = {}

        local lineCount = #page.layout
        local lineMarkerY = 0

        for lineIndex,line in ipairs(page.layout) do
            -- Add asterisk
            lineMarkerY = lineMarkerY + line.ascent

            if hasLineMarkers and (lineIndex == 1 or isForcedLine[line[1]]) then
                local hasFirstCharacterFromSeg = true

                if lineIndex > 1 then
                    -- Find if this is the start of the segment
                    for i = 1,line[2]-1 do
                        local character = line[1][i]

                        if character ~= 10 then
                            hasFirstCharacterFromSeg = false
                            break
                        end
                    end
                end

                if hasFirstCharacterFromSeg then
                    table.insert(page.lineMarkers,{y = lineMarkerY,limit = #page.characterList})
                end
            end

            lineMarkerY = lineMarkerY + line.descent

            -- Add characters
            for i = 1,#line,4 do
                local segment = line[i]

                if segment.img ~= nil then
                    table.insert(page.characterList,-2)
                else
                    local startIdx = line[i+1]
                    local endIdx = line[i+2]

                    for charIdx = startIdx,endIdx do
                        table.insert(page.characterList,segment[charIdx])
                    end
                end
            end

            if lineIndex < lineCount then
                table.insert(page.characterList,-1)
            end
        end
    end

    currentlyUpdatingBox = nil
    currentlyUpdatingPage = nil


    -- Speaker name
    if self.speakerName ~= "" then
        local speakerNameFmt = {font = self.settings.speakerNameFont,color = self.settings.speakerNameColor,xscale = self.settings.speakerNameXScale,yscale = self.settings.speakerNameYScale}
        local speakerNameExtraWidth = math.abs(self.settings.speakerNameOffsetX)*2

        if self.settings.speakerNameOnTop then
            speakerNameExtraWidth = speakerNameExtraWidth - totalBorderSize

            if self.settings.speakerNameBoxImage ~= nil then
                speakerNameExtraWidth = speakerNameExtraWidth + self.settings.speakerNameBoxImage.width/3*2
            end
        end

        self.speakerNameLayout = textplus.layout(self.speakerName,self.maxWidth - speakerNameExtraWidth,speakerNameFmt,customTags,selfClosingTags)

        if not self.settings.speakerNameOnTop then
            self.mainOffsetY = self.mainOffsetY + self.speakerNameLayout.height + self.settings.speakerNameGap
        end

        self.mainWidth = math.max(self.mainWidth,self.speakerNameLayout.width + speakerNameExtraWidth)
    end


    -- Make the box a bit bigger if below min size
    if self.settings.useMaxWidthAsBoxWidth then
        self.mainWidth = math.max(self.mainWidth,self.settings.textMaxWidth)
    end

    self.mainHeight = math.max(self.mainHeight,self.settings.minBoxMainHeight)


    self.totalWidth  = self.mainWidth  + totalBorderSize
    self.totalHeight = self.mainHeight + totalBorderSize + self.mainOffsetY


    if self.settings.typewriterEnabled then
        self:activateTextEvents(0,0)
    else
        self:activateTextEvents()
    end
end


function boxInstanceFunctions:addDialogue(text,deleteFurtherText)
    if deleteFurtherText == nil or deleteFurtherText then
        -- Delete any text after this page
        local searchStart = 1
        local pageIndex = 1

        while (true) do
            local foundStart,foundEnd = self.text:find("<page>",searchStart,true)

            if foundStart == nil then
                break
            end

            pageIndex = pageIndex + 1

            if pageIndex <= math.ceil(self.page) then
                searchStart = foundEnd + 1
            else
                self.text = self.text:sub(1,foundStart-1)
                break
            end
        end
    end


    self.maxWidth = self.mainWidth


    if self.text == "" or self.text:sub(-1) == "<page>" then
        self.text = self.text.. text
    else
        self.text = self.text.. "<page>".. text
    end

    self:updateLayouts()
end

function boxInstanceFunctions:close()
    self.state = STATE.OUT

    if not self.silent and self.settings.closeSoundEnabled and answer == nil then
        SFX.play(self.settings.closeSound)
    end
end


function boxInstanceFunctions:progress(isFromPlayer)
    local page = self.pageData[self.page]
    local answer = page.plainAnswerList[self.selectedAnswer]

    if answer ~= nil then
        if answer.addText ~= nil then
            self:addDialogue(answer.addText,true)
        end

        if answer.chosenFunction ~= nil then
            answer.chosenFunction(self)
        end

        if not self.silent and self.settings.chooseAnswerSoundEnabled then
            SFX.play(self.settings.chooseAnswerSound)
        end
    end

    if self.page < self.pageCount then
        self.state = STATE.SCROLL
        GameData.answersActive = false

        self.selectedAnswer = 1

        self.typewriterLimit = 0
        self.typewriterFinished = (not self.settings.typewriterEnabled)

        if not self.silent and self.settings.scrollSoundEnabled and answer == nil then
            SFX.play(self.settings.scrollSound)
        end
    elseif not self.uncloseableByPlayer or not isFromPlayer then
        self:close()

        player:mem(0x11E,FIELD_BOOL,false)
    end
end

function boxInstanceFunctions:update()
    if self.state == STATE.STAY then
        local page = self.pageData[self.page]

        local characterCount = #page.characterList

        if not self.typewriterFinished then
            self.typewriterDelay = self.typewriterDelay - 1
            
            if self.typewriterDelay <= 0 then
                self.typewriterLimit = self.typewriterLimit + 1

                if self.typewriterLimit < characterCount then
                    local character = page.characterList[self.typewriterLimit]

                    if not page.noAutoDelay and (self.settings.typewriterDelayCharacters[character] or self.typewriterLongDelayWaiting) then -- extra delaying character
                        local nextCharacter = page.characterList[self.typewriterLimit + 1]

                        if self.settings.typewriterClosingCharacters[nextCharacter] or self.settings.typewriterDelayCharacters[nextCharacter] then
                            self.typewriterDelay = self.settings.typewriterDelayNormal
                            self.typewriterLongDelayWaiting = true
                        else
                            self.typewriterDelay = self.settings.typewriterDelayLong
                            self.typewriterLongDelayWaiting = false
                        end
                    else
                        self.typewriterDelay = self.settings.typewriterDelayNormal
                    end
                else
                    self.typewriterFinished = true
                    self.typewriterLongDelayWaiting = false
                    self.portraitTimer = 0
                end

                self:activateTextEvents(self.typewriterLimit,self.typewriterLimit)

                if not self.silent then
                    if self.voiceSound ~= nil then
                        SFX.play{sound = self.voiceSound,delay = self.settings.typewriterSoundDelay}
                    elseif self.settings.typewriterSoundEnabled then
                        SFX.play{sound = self.settings.typewriterSound,delay = self.settings.typewriterSoundDelay}
                    end
                end
            end
        end


        if not self.uncontrollable then
            if self.typewriterFinished then
                if page.totalAnswersCount > 0 then
                    GameData.answersActive = true
                    local answerPage = page.answerPages[page.answersPageIndex]
                    
                    if player.keys.up == KEYS_PRESSED and self.selectedAnswer > 1 then
                        self.selectedAnswer = self.selectedAnswer - 1

                        if not self.silent and self.settings.moveSelectionSoundEnabled then
                            SFX.play(self.settings.moveSelectionSound)
                        end
                    elseif player.keys.down == KEYS_PRESSED and self.selectedAnswer < page.totalAnswersCount then
                        self.selectedAnswer = self.selectedAnswer + 1
                        
                        if not self.silent and self.settings.moveSelectionSoundEnabled then
                            SFX.play(self.settings.moveSelectionSound)
                        end
                    end
                    
                    if Player.count() >= 2 then
                        if player2.keys.up == KEYS_PRESSED and self.selectedAnswer > 1 then
                            self.selectedAnswer = self.selectedAnswer - 1

                            if not self.silent and self.settings.moveSelectionSoundEnabled then
                                SFX.play(self.settings.moveSelectionSound)
                            end
                        end
                        if player2.keys.down == KEYS_PRESSED and self.selectedAnswer < page.totalAnswersCount then
                            self.selectedAnswer = self.selectedAnswer + 1
                        
                            if not self.silent and self.settings.moveSelectionSoundEnabled then
                                SFX.play(self.settings.moveSelectionSound)
                            end
                        end
                    end
                    
                    if littleDialogue.cursorEnabled then
                        Text.printWP(littleDialogue.answerX, 100, 120, 0)
                        Text.printWP(littleDialogue.answerY, 100, 140, 0)
                        Text.printWP(littleDialogue.sourceWidthUpdatable, 100, 160, 0)
                        Text.printWP(littleDialogue.sourceHeightUpdatable, 100, 180, 0)
                        Text.printWP(littleDialogue.answerYUpdatable, 100, 200, 0)
                        Text.printWP(littleDialogue.answerWidthUpdatable, 100, 220, 0)
                        Text.printWP(littleDialogue.answerHeightUpdatable, 100, 240, 0)
                        Text.printWP(littleDialogue.mainTextYUpdatable, 100, 260, 0)
                        Text.printWP(littleDialogue.questionGapUpdatable, 100, 280, 0)
                        Text.printWP(littleDialogue.iconXUpdatable, 100, 300, 0)
                        for i = 1,page.totalAnswersCount do
                            if cursor.y >= littleDialogue.answerHeightUpdatable + i * littleDialogue.questionGapUpdatable + 16 and cursor.y <= littleDialogue.answerWidthUpdatable + i * littleDialogue.questionGapUpdatable + 16 then
                                Text.printWP("On selection "..self.selectedAnswer, 100, 100, 0)
                                if i == 1 then
                                    self.selectedAnswer = 1
                                elseif i == 2 then
                                    self.selectedAnswer = 2
                                elseif i == 3 then
                                    self.selectedAnswer = 3
                                elseif i == 4 then
                                    self.selectedAnswer = 4
                                elseif i == 5 then
                                    self.selectedAnswer = 5
                                end
                                if cursor.click then
                                    self:progress(true)
                                end
                            end
                        end
                    end

                    if self.selectedAnswer < answerPage.firstAnswerIndex then
                        GameData.answersActive = false
                        self.state = STATE.SCROLL_ANSWERS
                        self.answersPageTarget = page.answersPageIndex - 1
                    elseif self.selectedAnswer > answerPage.firstAnswerIndex+(#answerPage.answers - 1) then
                        GameData.answersActive = false
                        self.state = STATE.SCROLL_ANSWERS
                        self.answersPageTarget = page.answersPageIndex + 1
                    end
                end

                if player.keys.jump == KEYS_PRESSED then
                    self:progress(true)
                end
                
                if Player.count() >= 2 then
                    if player2.keys.jump == KEYS_PRESSED then
                        self:progress(true)
                    end
                end
            else
                if player.keys.jump == KEYS_PRESSED then
                    self.typewriterFinished = true

                    self:activateTextEvents(self.typewriterLimit+1,nil)

                    self.typewriterLimit = characterCount
                    self.portraitTimer = 0
                end
                if GameData.answersActive == false then
                    if player.keys.run == KEYS_DOWN then
                        player.keys.run = KEYS_UP
                        player.keys.jump = false
                        player.keys.run = KEYS_UNPRESSED
                        player.keys.jump = true
                        Sound.playSFX("fastscroll.ogg")
                        if not self.typewriterFinished then
                            self.typewriterDelay = self.typewriterDelay or 0
                        end
                        self.typewriterFinished = true
                        self.typewriterLongDelayWaiting = false
                        self.typewriterDelay = 0
                        self:activateTextEvents(self.typewriterLimit+0,nil)
                        self.typewriterLimit = 0
                        self.portraitTimer = 0
                        self:progress(true)
                        player.keys.jump = KEYS_PRESSED
                    end
                end
                
                if Player.count() >= 2 then
                    if GameData.answersActive == false then
                        if player2.keys.run == KEYS_DOWN then
                            player2.keys.run = KEYS_UP
                            player2.keys.jump = false
                            player2.keys.run = KEYS_UNPRESSED
                            player2.keys.jump = true
                            Sound.playSFX("fastscroll.ogg")
                            if not self.typewriterFinished then
                                self.typewriterDelay = self.typewriterDelay or 0
                            end
                            self.typewriterFinished = true
                            self.typewriterLongDelayWaiting = false
                            self.typewriterDelay = 0
                            self:activateTextEvents(self.typewriterLimit+0,nil)
                            self.typewriterLimit = 0
                            self.portraitTimer = 0
                            self:progress(true)
                            player2.keys.jump = KEYS_PRESSED
                        end
                    end
                end
            end
        end
    elseif self.state == STATE.SCROLL then
        local target = math.floor(self.page)+1

        self.page = math.min(target,self.page + self.settings.pageScrollSpeed)

        if self.page == target then
            self.state = STATE.STAY

            if self.settings.typewriterEnabled then
                self:activateTextEvents(0,0)
            else
                self:activateTextEvents()
            end
        end
    elseif self.state == STATE.SCROLL_ANSWERS then
        local page = self.pageData[self.page]

        local current = page.answersPageIndex
        local target = self.answersPageTarget

        if current < target then
            page.answersPageIndex = math.min(target,current + self.settings.answerPageScrollSpeed)
        elseif current > target then
            page.answersPageIndex = math.max(target,current - self.settings.answerPageScrollSpeed)
        else
            self.state = STATE.STAY
        end
    elseif self.state == STATE.IN then
        self.openingProgress = math.min(1,self.openingProgress + self.settings.openSpeed)
        
        if self.openingProgress == 1 then
            self.state = STATE.STAY
        end
    elseif self.state == STATE.OUT then
        self.openingProgress = math.max(0,self.openingProgress - self.settings.openSpeed)

        if self.openingProgress == 0 then
            self.state = STATE.REMOVE
            if self.pauses then
                Misc.unpause()
            end
        end
    end

    -- Profile animation
    local portraitData = self.portraitData

    if portraitData ~= nil then
        if self.typewriterFinished or self.state ~= STATE.STAY or portraitData.speakingFrames <= 0 then
            self.portraitFrame = (math.floor(self.portraitTimer / portraitData.idleFrameDelay) % portraitData.idleFrames)
        else
            self.portraitFrame = (math.floor(self.portraitTimer / portraitData.speakingFrameDelay) % portraitData.speakingFrames) + portraitData.idleFrames
        end

        self.portraitTimer = self.portraitTimer + 1
    end
end


local mainBuffer = Graphics.CaptureBuffer(800,600)
local fullBuffer = Graphics.CaptureBuffer(800,600)
local answerBuffer = Graphics.CaptureBuffer(800,600)

local function drawBufferDebug(buffer,priority,x,y,usedWidth,usedHeight)
    Graphics.drawBox{x = x,y = y,width = usedWidth,height = usedHeight,priority = priority,color = Color.black}

    Graphics.drawBox{x = x + usedWidth,y = y,width = buffer.width - usedWidth,height = usedHeight,color = Color.darkred,priority = priority}
    Graphics.drawBox{x = x,y = y + usedHeight,width = buffer.width,height = buffer.height - usedHeight,color = Color.darkred,priority = priority}

    Graphics.drawBox{texture = buffer,priority = priority,x = x,y = y}
end


local function getFirstFontInLayout(layout)
    for _,line in ipairs(layout) do
        for _,seg in ipairs(line) do
            if seg.fmt ~= nil and seg.fmt.font ~= nil then
                return seg.fmt.font
            end
        end
    end

    return nil
end

local function getTextShaderUniforms(layout)
    local uniforms = {time = lunatime.tick()}

    -- Uniforms pass some info about the font: however, it's always the first found in the layout
    local font = getFirstFontInLayout(layout)

    if font ~= nil then
        uniforms.imageSize = vector(font.imageWidth,font.imageHeight)
        uniforms.cellSize = vector(font.cellWidth,font.cellHeight)

        uniforms.ascent = font.ascent
        uniforms.descent = font.descent
    else
        uniforms.imageSize = vector(1,1)
        uniforms.cellSize = vector(1,1)

        uniforms.ascent = 0
        uniforms.descent = 0
    end

    return uniforms
end


local function drawAnswers(self,page,textX,mainTextY)
    answerBuffer:clear(self.priority)

    for answersPageIndex = math.floor(page.answersPageIndex), math.ceil(page.answersPageIndex) do
        local answerPage = page.answerPages[answersPageIndex]

        if answerPage ~= nil then
            littleDialogue.answerX = textX
            littleDialogue.answerY = math.floor((-(page.answersPageIndex - 1) + (answersPageIndex - 1)) * (page.answersHeight + self.settings.answerGap))

            if self.settings.selectorImage ~= nil and self.settings.selectorImageEnabled then
                littleDialogue.answerX = littleDialogue.answerX + self.settings.selectorImage.width
            end

            for answerIndex,answer in ipairs(answerPage.answers) do
                local totalIndex = (answerPage.firstAnswerIndex + (answerIndex - 1))
                local answerColor

                if page.index == self.page and totalIndex == self.selectedAnswer and self.typewriterFinished and self.state ~= STATE.SCROLL then
                    answerColor = self.settings.answerSelectedColor

                    if self.settings.selectorImage ~= nil and self.settings.selectorImageEnabled then
                        Graphics.drawBox{
                            texture = self.settings.selectorImage,target = answerBuffer,priority = self.priority,
                            x = textX,y = littleDialogue.answerY + answer.layout.height*0.5 - self.settings.selectorImage.height*0.5,
                        }
                    end
                else
                    answerColor = self.settings.answerUnselectedColor
                end

                textplus.render{
                    layout = answer.layout,x = littleDialogue.answerX,y = littleDialogue.answerY,color = answerColor,priority = self.priority,target = answerBuffer,
                    shader = self.settings.mainTextShader,uniforms = getTextShaderUniforms(answer.layout),
                }

                littleDialogue.answerY = littleDialogue.answerY + answer.layout.height + self.settings.answerGap
            end
        end
    end

    -- Draw those answers to the text buffer
    local answersY = mainTextY + page.layout.height + self.settings.questionGap

    local answerPageCount = #page.answerPages
    local scrollArrow = self.settings.scrollArrowImage

    if answerPageCount > 1 and scrollArrow ~= nil and self.settings.scrollArrowEnabled then
        local offset = (math.floor(lunatime.drawtick()/32)%2)*2

        local iconHeight = scrollArrow.height

        local answerPageIndex = page.answersPageIndex

        if math.floor(self.page) == self.page --[[and math.floor(answerPageIndex) == answerPageIndex]] and self.typewriterFinished then
            local iconWidth = scrollArrow.width*0.5
            local iconX = self.mainWidth*0.5 - iconWidth*0.5

            if self.portraitData ~= nil then
                iconX = iconX + (self.portraitData.width + self.settings.portraitGap)*0.5
            end

            if answerPageIndex >= 2 then
                Graphics.drawBox{
                    texture = scrollArrow,target = mainBuffer,priority = self.priority,
                    x = iconX,y = answersY + offset,sourceX = 0,sourceY = 0,
                    sourceWidth = iconWidth,sourceHeight = iconHeight,
                }
            end

            if answerPageIndex <= answerPageCount-1 then
                Graphics.drawBox{
                    texture = scrollArrow,target = mainBuffer,priority = self.priority,
                    x = iconX,y = answersY + iconHeight + page.answersHeight - offset,sourceX = iconWidth,sourceY = 0,
                    sourceWidth = iconWidth,sourceHeight = iconHeight,
                }
            end
            littleDialogue.iconXUpdatable = iconX
        end
        if answerPageIndex >= 2 then
            littleDialogue.answerYUpdatable = answersY + offset
        elseif answerPageIndex <= answerPageCount-1 then
            littleDialogue.answerYUpdatable = answersY + iconHeight + page.answersHeight - offset
        end
        
        littleDialogue.sourceWidthUpdatable = iconWidth
        littleDialogue.sourceHeightUpdatable = iconHeight

        answersY = answersY + iconHeight
    end

    Graphics.drawBox{
        texture = answerBuffer,target = mainBuffer,priority = self.priority,
        x = 0,y = answersY,width = self.mainWidth,height = page.answersHeight,
        sourceWidth = self.mainWidth,sourceHeight = page.answersHeight,
    }
    littleDialogue.answerWidthUpdatable = self.mainWidth
    littleDialogue.answerHeightUpdatable = page.answersHeight
    littleDialogue.mainTextYUpdatable = mainTextY
    littleDialogue.questionGapUpdatable = self.settings.questionGap
end


local function drawSegmentedBox(image,priority,sceneCoords,color,x,y,width,height,cutoffWidth,cutoffHeight)
    local vertexCoords = {}
    local textureCoords = {}

    local vertexCount = 0

    local segmentWidth = image.width / 3
    local segmentHeight = image.height / 3

    local segmentCountX = math.max(2,math.ceil(width / segmentWidth))
    local segmentCountY = math.max(2,math.ceil(height / segmentHeight))

    x = math.floor(x)
    y = math.floor(y)

    for segmentIndexX = 1, segmentCountX do
        for segmentIndexY = 1, segmentCountY do
            local thisX = x
            local thisY = y
            local thisWidth = math.min(width * 0.5,segmentWidth)
            local thisHeight = math.min(height * 0.5,segmentHeight)
            local thisSourceX = 0
            local thisSourceY = 0

            if segmentIndexX == segmentCountX then
                thisX = thisX + width - thisWidth
                thisSourceX = image.width - thisWidth
            elseif segmentIndexX > 1 then
                thisX = thisX + thisWidth + (segmentIndexX-2)*segmentWidth
                thisWidth = math.min(segmentWidth,width - segmentWidth - (thisX - x))
                thisSourceX = segmentWidth
            end

            if segmentIndexY == segmentCountY then
                thisY = thisY + height - thisHeight
                thisSourceY = image.height - thisHeight
            elseif segmentIndexY > 1 then
                thisY = thisY + thisHeight + (segmentIndexY-2)*segmentHeight
                thisHeight = math.min(segmentHeight,height - segmentHeight - (thisY - y))
                thisSourceY = segmentHeight
            end
            

            -- Handle cutoff
            if cutoffWidth ~= nil and cutoffHeight ~= nil then
                local cutoffLeft = x + width*0.5 - cutoffWidth*0.5
                local cutoffRight = cutoffLeft + cutoffWidth
                local cutoffTop = y + height*0.5 - cutoffHeight*0.5
                local cutoffBottom = cutoffTop + cutoffHeight

                -- Handle X
                local offset = math.max(0,cutoffLeft - thisX)

                thisWidth = thisWidth - offset
                thisSourceX = thisSourceX + offset
                thisX = thisX + offset

                thisWidth = math.min(thisWidth,cutoffRight - thisX)

                -- Handle Y
                local offset = math.max(0,cutoffTop - thisY)

                thisHeight = thisHeight - offset
                thisSourceY = thisSourceY + offset
                thisY = thisY + offset

                thisHeight = math.min(thisHeight,cutoffBottom - thisY)
            end

            -- Add vertices
            if thisWidth > 0 and thisHeight > 0 then
                local x1 = thisX
                local y1 = thisY
                local x2 = x1 + thisWidth
                local y2 = y1 + thisHeight

                vertexCoords[vertexCount+1 ] = x1 -- top left
                vertexCoords[vertexCount+2 ] = y1
                vertexCoords[vertexCount+3 ] = x1 -- bottom left
                vertexCoords[vertexCount+4 ] = y2
                vertexCoords[vertexCount+5 ] = x2 -- top right
                vertexCoords[vertexCount+6 ] = y1
                vertexCoords[vertexCount+7 ] = x1 -- bottom left
                vertexCoords[vertexCount+8 ] = y2
                vertexCoords[vertexCount+9 ] = x2 -- top right
                vertexCoords[vertexCount+10] = y1
                vertexCoords[vertexCount+11] = x2 -- bottom right
                vertexCoords[vertexCount+12] = y2

                local x1 = thisSourceX / image.width
                local y1 = thisSourceY / image.height
                local x2 = (thisSourceX + thisWidth) / image.width
                local y2 = (thisSourceY + thisHeight) / image.height

                textureCoords[vertexCount+1 ] = x1 -- top left
                textureCoords[vertexCount+2 ] = y1
                textureCoords[vertexCount+3 ] = x1 -- bottom left
                textureCoords[vertexCount+4 ] = y2
                textureCoords[vertexCount+5 ] = x2 -- top right
                textureCoords[vertexCount+6 ] = y1
                textureCoords[vertexCount+7 ] = x1 -- bottom left
                textureCoords[vertexCount+8 ] = y2
                textureCoords[vertexCount+9 ] = x2 -- top right
                textureCoords[vertexCount+10] = y1
                textureCoords[vertexCount+11] = x2 -- bottom right
                textureCoords[vertexCount+12] = y2

                vertexCount = vertexCount + 12
            end
        end
    end

    --Text.print(#vertexCoords,32,96)

    Graphics.glDraw{
        texture = image,
        priority = priority,
        color = color,
        sceneCoords = sceneCoords,
        vertexCoords = vertexCoords,
        textureCoords = textureCoords,
    }
end


function boxInstanceFunctions:getDrawPosition()
    -- Handle forced pos
    local forcedPosX = self.forcedPosX
    local forcedPosY = self.forcedPosY
    local forcedPosHorizontalPivot = self.forcedPosHorizontalPivot or 0.5
    local forcedPosVerticalPivot = self.forcedPosVerticalPivot or 0.5
    
    if (forcedPosX == nil and forcedPosY == nil) and self.settings.forcedPosEnabled then
        forcedPosX = self.settings.forcedPosX
        forcedPosY = self.settings.forcedPosY
        forcedPosHorizontalPivot = self.settings.forcedPosHorizontalPivot
        forcedPosVerticalPivot = self.settings.forcedPosVerticalPivot
    end

    if forcedPosX ~= nil and forcedPosY ~= nil then
        return forcedPosX - (forcedPosHorizontalPivot - 0.5)*self.totalWidth,forcedPosY - (forcedPosVerticalPivot - 0.5)*self.totalHeight,false
    end

    -- Handle coming from the speaker
    local obj = self.speakerObj

    if obj ~= nil and obj.isValid ~= false then
        local x = obj.x + self.settings.offsetFromSpeakerX
        local y = obj.y + self.settings.offsetFromSpeakerY - self.totalHeight*0.5

        if obj.width ~= nil then
            x = x + obj.width*0.5
        end

        return x,y,true
    end

    -- No position so
    return 0,0,false
end


function boxInstanceFunctions:draw()
    local x,y,sceneCoords = self:getDrawPosition()

    -- Apply handycam zoom
    if self.priority > 0 and sceneCoords then
        local handycamObj = rawget(handycam,1)

        if handycamObj ~= nil then
            local cameraX = camera.x + camera.width*0.5
            local cameraY = camera.y + camera.height*0.5

            x = (x - cameraX)*handycamObj.zoom + cameraX
            y = (y - cameraY)*handycamObj.zoom + cameraY
        end
    end

    -- Apply bounds to make sure it's not off screen
    if self.keepOnScreen and sceneCoords then
        local minDistance = self.settings.minDistanceFromEdge
        local b = getBoundaries()

        x = math.clamp(x,b.left + self.totalWidth *0.5 + minDistance,b.right  - self.totalWidth *0.5 - minDistance)
        y = math.clamp(y,b.top  + self.totalHeight*0.5 + minDistance,b.bottom - self.totalHeight*0.5 - minDistance)
    end


    local scaleX  = math.lerp(self.settings.openStartScaleX ,1,self.openingProgress)
    local scaleY  = math.lerp(self.settings.openStartScaleY ,1,self.openingProgress)
    local opacity = math.lerp(self.settings.openStartOpacity,1,self.openingProgress)

    local topNameDarkening = 0

    local boxWidth = self.totalWidth * scaleX
    local boxHeight = self.totalHeight * scaleY

    local boxCutoffWidth
    local boxCutoffHeight


    if self.settings.windowingOpeningEffectEnabled and self.openingProgress < 1 then
        local blackProgress = math.min(1,self.openingProgress*2)
        local mainProgress = math.max(0,self.openingProgress*2 - 1)

        scaleX  = math.lerp(self.settings.openStartScaleX ,1,blackProgress)
        scaleY  = math.lerp(self.settings.openStartScaleY ,1,blackProgress)
        opacity = math.lerp(self.settings.openStartOpacity,1,blackProgress)

        boxCutoffWidth  = math.lerp(self.settings.openStartScaleX,1,mainProgress) * self.totalWidth
        boxCutoffHeight = math.lerp(self.settings.openStartScaleY,1,mainProgress) * self.totalHeight

        topNameDarkening = math.clamp((1 - mainProgress)*3.5)

        boxWidth = self.totalWidth
        boxHeight = self.totalHeight

        Graphics.drawBox{
            color = Color.black.. opacity,sceneCoords = sceneCoords,priority = self.priority,centred = true,
            x = x,y = y,width = self.totalWidth * scaleX,height = self.totalHeight * scaleY,
        }
    end
    if self.settings.boxImage ~= nil then
        drawSegmentedBox(self.settings.boxImage,self.priority,sceneCoords,Color.white.. opacity,x - boxWidth*0.5,y - boxHeight*0.5,boxWidth,boxHeight,boxCutoffWidth,boxCutoffHeight)
    end


    fullBuffer:clear(self.priority)
    --Graphics.drawBox{color = Color.red.. 0.25,priority = self.priority,target = fullBuffer,x = 0,y = 0,width = fullBuffer.width,height = fullBuffer.height}

    -- Speaker name
    if self.speakerNameLayout ~= nil then
        local nameX,nameY,nameTarget,nameSceneCoords,nameColor

        if self.settings.speakerNameOnTop then
            local boxImage = self.settings.speakerNameBoxImage
            local boxColor = Color.white:lerp(Color.black,topNameDarkening)
            local boxOpacity = (opacity*scaleX*scaleY)

            nameX = x + (-self.totalWidth*0.5 + self.settings.speakerNameOffsetX + (self.totalWidth - self.speakerNameLayout.width)*self.settings.speakerNamePivot)*scaleX
            nameY = y - (self.totalHeight*0.5 + self.speakerNameLayout.height)*scaleY
            nameSceneCoords = sceneCoords

            nameColor = boxColor*boxOpacity

            if boxImage ~= nil then
                nameX = nameX - boxImage.width/3*2*self.settings.speakerNamePivot*scaleX

                local boxWidth = (self.speakerNameLayout.width + boxImage.width/3*2)*scaleX
                local boxHeight = self.speakerNameLayout.height + boxImage.height/3
                local boxX = nameX
                local boxY = nameY

                nameX = nameX + boxWidth*0.5 - self.speakerNameLayout.width*0.5

                drawSegmentedBox(boxImage,self.priority,sceneCoords,boxColor.. boxOpacity,boxX,boxY,boxWidth,boxHeight)
            end

            nameY = nameY + self.settings.speakerNameOffsetY
        else
            nameX = (self.mainWidth - self.speakerNameLayout.width)*self.settings.speakerNamePivot + self.settings.speakerNameOffsetX
            nameY = self.settings.speakerNameOffsetY
            nameTarget = fullBuffer
            nameColor = Color.white*opacity
        end
        textplus.render{
            layout = self.speakerNameLayout,priority = self.priority,color = nameColor,target = nameTarget,sceneCoords = nameSceneCoords,x = nameX,y = nameY,
            shader = self.settings.speakerNameTextShader,uniforms = getTextShaderUniforms(self.speakerNameLayout),
        }
    end


    if self.openingProgress >= 1 or self.settings.showTextWhileOpening then
        mainBuffer:clear(self.priority)

        -- Character portrait
        local portraitData = self.portraitData
        local textX = 0

        if portraitData ~= nil and portraitData.image ~= nil then
            Graphics.drawBox{
                texture = portraitData.image,target = mainBuffer,priority = self.priority,

                x = 0,y = math.floor((self.mainHeight - portraitData.height)*self.settings.portraitVerticalPivot + 0.5),

                width = portraitData.width,height = portraitData.height,
                sourceWidth = portraitData.width,sourceHeight = portraitData.height,
                sourceX = self.portraitVariation * portraitData.width,sourceY = self.portraitFrame * portraitData.height,
            }

            textX = textX + portraitData.width + self.settings.portraitGap
        end


        -- Line markers
        local lineMarkerImage = self.settings.lineMarkerImage
        if lineMarkerImage ~= nil and self.settings.lineMarkerEnabled then
            textX = textX + lineMarkerImage.width
        end


        -- Text
        for index = math.floor(self.page), math.ceil(self.page) do
            local page = self.pageData[index]

            local y = math.floor((-(self.page - 1) + (index - 1))*self.mainHeight)
            local limit

            if self.settings.typewriterEnabled then
                if index > self.page then
                    limit = 0
                    --break
                elseif index == self.page and self.state ~= STATE.SCROLL then
                    limit = self.typewriterLimit
                end
            end

            -- Draw line markers
            for _,lineMarker in ipairs(page.lineMarkers) do
                if limit == nil or limit > lineMarker.limit or lineMarker.limit == 0 then
                    Graphics.drawBox{
                        texture = lineMarkerImage,target = mainBuffer,priority = self.priority,
                        x = textX - lineMarkerImage.width,y = y + lineMarker.y - lineMarkerImage.height,
                    }
                end
            end

            textplus.render{
                layout = page.layout,limit = limit,x = textX,y = y,priority = self.priority,target = mainBuffer,
                shader = self.settings.mainTextShader,uniforms = getTextShaderUniforms(page.layout),
            }

            drawAnswers(self,page,textX,y)
        end


        -- Continue arrow
        if math.floor(self.page) == self.page and self.page < self.pageCount and self.pageData[self.page].totalAnswersCount == 0
        and not self.uncontrollable and self.typewriterFinished
        and self.settings.continueArrowEnabled and self.settings.continueArrowImage ~= nil
        then
            local offset = (math.floor(lunatime.drawtick()/32)%2)*2

            Graphics.drawBox{
                texture = self.settings.continueArrowImage,target = mainBuffer,priority = self.priority,
                x = self.mainWidth - self.settings.continueArrowImage.width,y = self.mainHeight - self.settings.continueArrowImage.height + offset,
            }
        end


        local drawWidth  = math.max(0,self.totalWidth *scaleX - self.settings.borderSize*2)
        local drawHeight = math.max(0,self.totalHeight*scaleY - self.settings.borderSize*2)

        if boxCutoffWidth ~= nil then
            drawWidth = math.min(drawWidth,boxCutoffWidth)
        end
        if boxCutoffHeight ~= nil then
            drawHeight = math.min(drawHeight,boxCutoffHeight)
        end

        Graphics.drawBox{
            texture = mainBuffer,target = fullBuffer,priority = self.priority,
            x = 0,y = self.mainOffsetY,
        }

        Graphics.drawBox{
            texture = fullBuffer,priority = self.priority,
            sceneCoords = sceneCoords,
            color = Color.white.. opacity,

            x = math.floor(x - drawWidth*0.5 + 0.5),y = math.floor(y - drawHeight*0.5 + 0.5),
            width = drawWidth,height = drawHeight,
            sourceWidth = drawWidth,sourceHeight = drawHeight,
            sourceX = self.mainWidth*0.5 - drawWidth*0.5,sourceY = (self.mainHeight + self.mainOffsetY)*0.5 - drawHeight*0.5,
        }


        --drawBufferDebug(fullBuffer,self.priority,0,0,self.mainWidth,self.mainHeight + self.mainOffsetY)
        --drawBufferDebug(answerBuffer,self.priority,mainBuffer.width,0,self.mainWidth,self.answersHeight)
    end
end



function littleDialogue.onTick()
    for k=#littleDialogue.boxes,1,-1 do
        local box = littleDialogue.boxes[k]

        if box.state ~= STATE.REMOVE then
            if not box.updatesInPause then
                box:update()
                littleDialogue.boxenabled = true
            end
        else
            table.remove(littleDialogue.boxes,k)
            box.isValid = false
        end
        if box.state == STATE.IN then
            littleDialogue.boxenabled = false
        end
    end
end

function littleDialogue.onDraw()
    for k=#littleDialogue.boxes,1,-1 do
        local box = littleDialogue.boxes[k]

        if box.state ~= STATE.REMOVE then
            if box.updatesInPause then
                box:update()
            end
            box:draw()
        else
            table.remove(littleDialogue.boxes,k)
            box.isValid = false
        end
    end
end

function littleDialogue.onMessageBox(eventObj,text,playerObj,npcObj)
    eventObj.cancelled = true
    
    if Player.count() >= 2 then
        littleDialogue.create{
            text = text,
            speakerObj = npcObj or playerObj or player or player2
        }
    else
        littleDialogue.create{
            text = text,
            speakerObj = npcObj or playerObj or player
        }
    end
    
    Misc.pause()
end



littleDialogue.defaultBoxSettings = {
    -- Text formatting related
    textXScale = 2,          -- X scale of text.
    textYScale = 2,          -- Y scale of text.
    textMaxWidth = 384,      -- The maximum text width before it goes to a new line.
    textColor = Color.white, -- The tint of the text.


    -- Speaker name related
    speakerNameXScale = 2.5,        -- X scale of the speaker's name.
    speakerNameYScale = 2.5,        -- X scale of the speaker's name.
    speakerNameColor = Color.white, -- The tint of the speaker's name.
    speakerNameGap = 4,             -- The gap between the speaker's name and the text of the box.
    speakerNamePivot = 0.5,         -- The pivot for where the speaker's name is.
    speakerNameOffsetX = 0,
    speakerNameOffsetY = 0,
    speakerNameOnTop = false,       -- If true, the speaker's name will go on top of the box with its own 'protrusion'.

    
    -- Question related
    questionGap = 16, -- The gap between each a question and all of its answers.
    answerGap = 0,    -- The gap between each answer for a question.

    answerPageMaxHeight = 160, -- The maximum height of an answers list before it splits off into another page.

    answerUnselectedColor = Color.white,   -- The color of an answer when it's not being hovered over.
    answerSelectedColor = Color(1,1,0.25), -- The color of an answer when it is being hovered over.


    -- Typewriter effect related
    typewriterEnabled = true, -- If the typewriter effect is enabled.
    typewriterDelayNormal = 0.5, -- The usual delay between each character.
    typewriterDelayLong = 4,  -- The extended delay after any of the special delaying characters, listed below.
    typewriterSoundDelay = 3.3,  -- How long there must between each sound.

    -- Characters that, when hit by the typewriter effects, causes a slightly longer delay.
    typewriterDelayCharacters = table.map{string.byte("."),string.byte(","),string.byte("!"),string.byte("?")},
    -- Characters that stop the above character from causing a delay until the get printed as well.
    typewriterClosingCharacters = table.map{string.byte("\""),string.byte("'"),string.byte(")"),string.byte("}"),string.byte("]")},


    -- Other
    borderSize = 8, -- How much is added around the text to get the full size (pixels).
    priority = 6.5,   -- The render priority of boxes.

    minDistanceFromEdge = 16, -- The minimum distance away from the borders of the screen that the box can be while 'keepOnScreen' is enabled.

    useMaxWidthAsBoxWidth = false, -- If true, textMaxWidth gets used as the minimum width for the main part of the box.
    minBoxMainHeight = 0, -- The minimum height for the box's main section.

    offsetFromSpeakerX = 0,   -- How horizontally far away the box is from the NPC saying it.
    offsetFromSpeakerY = -40, -- How vertically far away the box is from the NPC saying it.

    pageOffset = 0, -- How far away each text page is from each other.

    openSpeed = 0.09, -- How much the scale increases per frame while opening/closing.
    pageScrollSpeed = 0.09, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 0.09, -- How fast it scrolls when switching answer pages.

    portraitGap = 8, -- The space between a portrait's image and the text of the box.
    portraitVerticalPivot = 0, -- The pivot of the portrait. At 0, it goes at the top, 1 puts it at the bottom, and 0.5 puts it in the middle.

    windowingOpeningEffectEnabled = false, -- If true, the box will have a black "window" over before opening/closing.
    showTextWhileOpening = true,          -- If true, the text won't disappear during the box's opening/closing animations.

    openStartScaleX = 0,  -- The X scale that the box starts at when opening/ends at when closing.
    openStartScaleY = 0,  -- The Y scale that the box starts at when opening/ends at when closing.
    openStartOpacity = 1, -- The opacity that the box starts at when opening/ends at when closing.

    forcedPosEnabled = false,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 32,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.


    -- Sound effect related
    openSoundEnabled          = true, -- If a sound is played when the box opens.
    closeSoundEnabled         = true, -- If a sound is played when the box closes.
    scrollSoundEnabled        = true, -- If a sound is played when the box scrolls between pages.
    moveSelectionSoundEnabled = true, -- If a sound is played when the option selector moves.
    chooseAnswerSoundEnabled  = true, -- If a sound is played when an answer to a question is chosen.
    typewriterSoundEnabled    = true, -- If a sound is played when a letter appears with the typewriter effect.

    -- Image related
    continueArrowEnabled = true, -- Whether or not an image shows up in the bottom right to show that there's another page.
    selectorImageEnabled = true, -- Whether or not an image shows up next to where your chosen answer is.
    scrollArrowEnabled   = true, -- Whether or not arrows show up to indicate that there's more pages of options.
    lineMarkerEnabled    = true, -- Whether or not to have a maker on a new line.
}



-- Register each style.

-- SMW styled: uses all the default settings, so nothing is needed.
littleDialogue.registerStyle("smw",{
    
})

-- Yoshi's Island styled: has a few custom settings.
littleDialogue.registerStyle("yi",{
    borderSize = 32,

    openSpeed = 0.025,

    windowingOpeningEffectEnabled = true,
    showTextWhileOpening = true,

    speakerNameOnTop = true,
    speakerNameOffsetY = 24,
})

-- Mario & Luigi Superstar Saga styled: a bunch of custom settings!
-- Not meant to be particularly accurate to the game.
littleDialogue.registerStyle("ml",{
    textColor = Color.fromHexRGB(0x303030),
    speakerNameColor = Color.fromHexRGB(0x303030),
    typewriterEnabled = true,
    borderSize = 12,
    showTextWhileOpening = true,

    openStartScaleX = 0,
    openStartScaleY = 0,
    openStartOpacity = 0.5,

    speakerNameOnTop = true,
    speakerNameOffsetX = 24,
    speakerNameOffsetY = 4,
    speakerNamePivot = 0,
    speakerNameXScale = 2,
    speakerNameYScale = 2,

    openSpeed = 0.06,
    pageScrollSpeed = 0.075,
})

-- Deltarune styled: very different from the rest! Also uses a shader for text to add an extra effect.
littleDialogue.registerStyle("dr",{
    textXScale = 1,
    textYScale = 1,
    textMaxWidth = 600,

    speakerNameXScale = 1,
    speakerNameYScale = 1,
    speakerNameOffsetX = 0,
    speakerNameColor = Color.yellow,

    borderSize = 32,

    openSpeed = 1,
    pageScrollSpeed = 1,

    portraitGap = 32,
    portraitVerticalPivot = 0.5,

    useMaxWidthAsBoxWidth = true,
    minBoxMainHeight = 104,

    forcedPosEnabled = true,
    forcedPosX = 400,
    forcedPosY = 32,
    forcedPosHorizontalPivot = 0.5,
    forcedPosVerticalPivot = 0,

    answerSelectedColor = Color.yellow,

    typewriterEnabled = true,
    typewriterSoundDelay = 2,

    openSoundEnabled = false,
    closeSoundEnabled = false,
    scrollSoundEnabled = false,
    moveSelectionSoundEnabled = false,
    chooseAnswerSoundEnabled = false,

    continueArrowEnabled = false,
})


-- Small deltarune styled: very different from the rest!
littleDialogue.registerStyle("drSmall",{
    textXScale = 1,
    textYScale = 1,
    textMaxWidth = 174,
    textColor = Color.black,

    speakerNameXScale = 1,
    speakerNameYScale = 1,
    speakerNameOffsetX = 0,
    speakerNameColor = Color.yellow,

    borderSize = 10,

    openSpeed = 1,
    pageScrollSpeed = 1,

    portraitGap = 32,
    portraitVerticalPivot = 0.5,

    answerSelectedColor = Color.yellow,

    typewriterEnabled = true,
    typewriterSoundDelay = 2,

    openSoundEnabled = false,
    closeSoundEnabled = false,
    scrollSoundEnabled = false,
    moveSelectionSoundEnabled = false,
    chooseAnswerSoundEnabled = false,

    continueArrowEnabled = false,
})

littleDialogue.registerStyle("smwwide",{
    textXScale = 1.4,
    textYScale = 1.4,
    speakerNameXScale = 1.6,
    speakerNameYScale = 1.6,
})

littleDialogue.registerStyle("smbx13og",{
    textXScale = 1,
    textYScale = 1,
    borderSize = 36,
    textMaxWidth = 500,
    speakerNameGap = 6,
    speakerNameXScale = 1.2,        -- X scale of the speaker's name.
    speakerNameYScale = 1.2,
    
    openSpeed = 5,
    pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
    borderSize = 8,
    
    forcedPosEnabled = true,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 150,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

    windowingOpeningEffectEnabled = false,

    typewriterEnabled = true,
    typewriterDelayNormal = 0.5, -- The usual delay between each character.
    typewriterDelayLong = 4,  -- The extended delay after any of the special delaying characters, listed below.
    typewriterSoundDelay = 4.1,
    showTextWhileOpening = true,

    closeSoundEnabled = false,
    continueArrowEnabled = false,
    scrollArrowEnabled   = false,
    selectorImageEnabled = true,
    
})

littleDialogue.registerStyle("smbx13",{
    textXScale = 1,
    textYScale = 1,
    borderSize = 36,
    textMaxWidth = 500,
    speakerNameGap = 6,
    speakerNameXScale = 1.2,        -- X scale of the speaker's name.
    speakerNameYScale = 1.2,
    
    openSpeed = 5,
    pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
    borderSize = 8,
    
    forcedPosEnabled = true,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 150,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

    windowingOpeningEffectEnabled = false,

    typewriterEnabled = false,
    showTextWhileOpening = true,

    closeSoundEnabled = false,
    continueArrowEnabled = false,
    scrollArrowEnabled   = false,
    selectorImageEnabled = true,
    
})

littleDialogue.registerStyle("infobooth",{
    borderSize = 32,

    openSpeed = 0.025,

    windowingOpeningEffectEnabled = true,
    showTextWhileOpening = true,

    speakerNameOnTop = true,
    speakerNameOffsetY = 24,
})

littleDialogue.registerStyle("bootmenudialog",{
    textXScale = 2,
    textYScale = 2,
    borderSize = 36,
    textMaxWidth = 500,
    speakerNameGap = 6,
    speakerNameXScale = 2.2,        -- X scale of the speaker's name.
    speakerNameYScale = 2.2,
    
    openSpeed = 5,
    pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
    borderSize = 8,
    
    forcedPosEnabled = false,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 150,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

    windowingOpeningEffectEnabled = false,

    typewriterEnabled = false,
    showTextWhileOpening = true,

    closeSoundEnabled = false,
    continueArrowEnabled = false,
    scrollArrowEnabled   = true,
    selectorImageEnabled = true,
    
    answerSelectedColor = Color.white, -- The color of an answer when it is being hovered over.
    
})

littleDialogue.registerStyle("gameoverdialog",{
    textXScale = 1,
    textYScale = 1,
    borderSize = 36,
    textMaxWidth = 500,
    speakerNameGap = 6,
    speakerNameXScale = 1.2,        -- X scale of the speaker's name.
    speakerNameYScale = 1.2,
    
    openSpeed = 5,
    pageScrollSpeed = 5, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 5, -- How fast it scrolls when switching answer pages.
    borderSize = 8,
    
    forcedPosEnabled = true,       -- If true, the box will be forced into a certain screen position, rather than floating over the speaker's head.
    forcedPosX = 400,               -- The X position the box will appear at on screen, if forced positioning is enabled.
    forcedPosY = 450,                -- The Y position the box will appear at on screen, if forced positioning is enabled.
    forcedPosHorizontalPivot = 0.5, -- How the box is positioned using its X coordinate. If 0, the X means the left, 1 means right, and 0.5 means the middle.
    forcedPosVerticalPivot = 0,     -- How the box is positioned using its Y coordinate. If 0, the Y means the top, 1 means bottom, and 0.5 means the middle.

    windowingOpeningEffectEnabled = false,

    typewriterEnabled = false,
    showTextWhileOpening = true,

    openSoundEnabled = false,
    closeSoundEnabled = false,
    scrollSoundEnabled = false,
    moveSelectionSoundEnabled = true,
    chooseAnswerSoundEnabled = false,

    continueArrowEnabled = false,
})

littleDialogue.registerStyle("ut",{
	textXScale = 2,
	textYScale = 2,
	textMaxWidth = 600,
	textColor = Color.white,
	
	speakerNameXScale = 1,
	speakerNameYScale = 1,
	speakerNameOffsetX = 0,
	speakerNameColor = Color.yellow,
	
	borderSize = 32,
	
	openSpeed = 1,
	pageScrollSpeed = 1,
	
	portraitGap = 32,
	portraitVerticalPivot = 0.5,
	
	useMaxWidthAsBoxWidth = true,
	minBoxMainHeight = 104,
	
	forcedPosEnabled = true,
	forcedPosX = 400,
	forcedPosY = 32,
	forcedPosHorizontalPivot = 0.5,
	forcedPosVerticalPivot = 0,
	
	answerSelectedColor = Color.yellow,
	
	typewriterEnabled = true,
	typewriterSoundDelay = 2,
	
	openSoundEnabled = false,
	closeSoundEnabled = false,
	scrollSoundEnabled = false,
	moveSelectionSoundEnabled = false,
	chooseAnswerSoundEnabled = false,
	
	continueArrowEnabled = false,
})



-- Note that you can setup your own styles from luna.lua files.


-- Default box style.
littleDialogue.defaultStyleName = "smw"


return littleDialogue