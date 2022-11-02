local transplate = {}

local path = "transplate"

--[[settings]]
    -- main 
    local preCache = false
    local preLoad = true
    local saveLanguage = false

    -- littleDialogue
    local littleDialogue_loadFonts = true
    
    -- restmenu
    -- local restmenu_loadFont = true
--]]

local currentLanguage = nil
local langs = {}
local fonts = {}
local fontsCache = {}

local textplus = require("textplus")

local littleDialogue
pcall(function() littleDialogue = require("littleDialogue") end)

-- local restmenuGUI
-- pcall(function() restmenuGUI = require("restmenuGUI") end)

do
    local function unpackTabledStrings(langFile)
        for original, new in pairs(langFile) do
            if type(original) == 'table' then
                for _, original in ipairs(original) do
                    langFile[original] = new
                end
                
                langFile[original] = nil
            end
        end
    end
    
    local littleDialogueFonts
    
    do
        local function loadFont(langName, _dir, style)
            fonts[langName][style] = textplus.loadFont(_dir)
        end
        
        littleDialogueFonts = function(langName)
            if not littleDialogue or not littleDialogue_loadFonts then return end
            
            fonts[langName] = {}
            
            local _dir = path .. [[/]] .. langName .. [[/littleDialogue]]
            local _path = Misc.resolveDirectory(_dir)
            -- Misc.dialog(_path)
            
            if not _path then return end
            
            local dirs = Misc.listDirectories(_path)
            
            for _, style in ipairs(dirs) do
                fonts[langName][style] = textplus.loadFont(_dir .. [[/]] .. style .. [[/font.ini]])
            end
            
            local mainFontPath = _dir .. [[/font.ini]]
            
            if Misc.resolveFile(mainFontPath) then
                fonts[langName][1] = textplus.loadFont(mainFontPath)
            end
        end
    end
    
    function transplate.loadLanguage(langName)
        langs[langName] = {}
        
        local langFile = require(path .. [[/]] .. langName .. [[/lang]])
        unpackTabledStrings(langFile)
        littleDialogueFonts(langName)
        
        langs[langName].strings = langFile

        if preCache then
            SaveData._transplateCache = langs
        end
    end
end

function transplate.getLanguage()
    return currentLanguage
end

do
    local function littleDialogue_changeFonts(new)
        if not littleDialogue_loadFonts then return end
        
        if littleDialogue and currentLanguage and fonts[currentLanguage] then -- updating ld style fonts
            for name, settings in pairs(littleDialogue.styles) do
                local font = fonts[currentLanguage][name]
                
                if not fontsCache[name] then
                    fontsCache[name] = settings.font
                end
                
                if font then
                    settings.font = font
                else
                    settings.font = fonts[currentLanguage][1] or settings.font
                end
            end
        elseif littleDialogue and not currentLanguage then
            for name, settings in pairs(littleDialogue.styles) do
                settings.font = fontsCache[name] or settings.font
            end
        end
    end
    
    function transplate.setLanguage(new)
        currentLanguage = new
        
        littleDialogue_changeFonts(new)
        
        if saveLanguage then
            SaveData._transplateLang = currentLanguage
        end
    end
end

function transplate.getTranslation(text, lang)
    if not currentLanguage then return text end

    return langs[lang or currentLanguage].strings[text] or text
end

function transplate.setTranslation(text, new, lang)
    if not currentLanguage then return end

    langs[lang or currentLanguage].strings[text] = new
end

function transplate.onInitAPI()
    if saveLanguage then
        transplate.setLanguage(SaveData._transplateLang)
    end
    
    if preCache and SaveData._transplateCache then
        langs = SaveData._transplateCache
        return
    end
    
    if not preLoad then return end
    
    local _path = Misc.resolveDirectory(path)
    
    if not _path then return end
    
    local dirs = Misc.listDirectories(_path)
    
    for _, langName in ipairs(dirs) do
        transplate.loadLanguage(langName)
    end
end

-- littleDialogue implementation
if littleDialogue then
    local onMessageBox = littleDialogue.onMessageBox
    
    littleDialogue.onMessageBox = function(e, msg, p, v)
        return onMessageBox(e, transplate.getTranslation(msg), p, v)
    end
end

return transplate