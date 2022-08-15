local smascharacterchanger = {}

function smascharacterchanger.onInitAPI()
    registerEvent(smascharacterchanger,"onDraw")
    registerEvent(smascharacterchanger,"onInputUpdate")
    registerEvent(smascharacterchanger,"onKeyboardPressDirect")
end

smascharacterchanger.menuActive = false

function smascharacterchanger.startupchanger()
    
end

function smascharacterchanger.onDraw()
    if smascharacterchanger.menuActive then
        
    end
end

return smascharacterchanger