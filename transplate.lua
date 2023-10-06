local transplate = {}

if SaveData.SMASPlusPlus.options.currentLanguage == nil then
    SaveData.SMASPlusPlus.options.currentLanguage = "english"
end

local path = "transplate"

transplate.languages = {
    "english",
    "japanese",
}

--[[settings]]
    -- main 
    local preCache = false
    local preLoad = true
    local saveLanguage = true

    -- littleDialogue
    local littleDialogue_loadFonts = false
    
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
            
            local _dir = path..[[/littleDialogue]]
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
        
        local langFile = require(path.."/"..langName.."/lang")
        
        unpackTabledStrings(langFile)
        --littleDialogueFonts(langName)
        
        langs[langName].strings = langFile

        if preCache then
            SaveData.currentLanguageCache = langs
        end
    end
end

function transplate.getLanguage()
    return SaveData.SMASPlusPlus.options.currentLanguage
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
        
        --littleDialogue_changeFonts(new)
        
        if saveLanguage then
            SaveData.SMASPlusPlus.options.currentLanguage = currentLanguage
        end
    end
end

function transplate.getTranslation(text, lang)
    if SaveData.SMASPlusPlus.options.currentLanguage == nil then return text end

    return langs[SaveData.SMASPlusPlus.options.currentLanguage or lang].strings[text] or text
end

function transplate.setTranslation(text, new, lang)
    if not currentLanguage then return end

    langs[lang or SaveData.SMASPlusPlus.options.currentLanguage].strings[text] = new
end

function transplate.onInitAPI()
    if saveLanguage then
        transplate.setLanguage(SaveData.SMASPlusPlus.options.currentLanguage)
        transplate.loadLanguage(SaveData.SMASPlusPlus.options.currentLanguage)
    end
    
    if preCache and SaveData.currentLanguageCache then
        langs = SaveData.currentLanguageCache
        return
    end
    
    if not preLoad then return end
    
    local dirs = Misc.listDirectories(Misc.resolveDirectory("transplate"))
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