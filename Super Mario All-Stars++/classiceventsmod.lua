local classicEvents = {}
local playerData = {}
local playerKeymapProperties = {}
playerKeymapProperties[KEY_UP] = "upKeyPressing"
playerKeymapProperties[KEY_DOWN] = "downKeyPressing"
playerKeymapProperties[KEY_LEFT] = "leftKeyPressing"
playerKeymapProperties[KEY_RIGHT] = "rightKeyPressing"
playerKeymapProperties[KEY_JUMP] = "jumpKeyPressing"
playerKeymapProperties[KEY_SPINJUMP] = "altJumpKeyPressing"
playerKeymapProperties[KEY_X] = "runKeyPressing" -- Maybe use a better name?
playerKeymapProperties[KEY_RUN] = "altRunKeyPressing" -- Maybe use a better name?
playerKeymapProperties[KEY_SEL] = "dropItemKeyPressing"
playerKeymapProperties[KEY_STR] = "pauseKeyPressing"

local playerKeymapKeys = {}
for playerKeymapKey,_ in pairs(playerKeymapProperties) do
    table.insert(playerKeymapKeys, playerKeymapKey)
end

function classicEvents.onInitAPI()
    if(not isOverworld)then
        playerData[1] = {}
        if Player.count() >= 2 then
            playerData[2] = {}
        end
    end
    
    for plIndex, plData in ipairs(playerData) do
        for _,keymapPropertyName in pairs(playerKeymapProperties) do
            plData[keymapPropertyName] = false
        end
        
        plData.playerJumping = false
        
        plData.currentSection = -1
    end
end


local function checkKeyboardEvent(plObject, plIndex, plData, plFieldName, plFieldID)
    local plObjectValue = plObject[plFieldName]
    local plDataValue = plData[plFieldName]
    if(plDataValue == false and plObjectValue == true)then
        EventManager.callEventInternal("onKeyDown", {plFieldID, plIndex})
        return
    end
    if(plDataValue == true and plObjectValue == false)then
        EventManager.callEventInternal("onKeyUp", {plFieldID, plIndex})
        return
    end
    if plObjectValue == nil or plDataValue == nil then --Put this under line 52 of scripts/base/engine/classevents.lua
        return
    end
end


-- FIXME: MusicManager::setCurrentSection((int)player->CurrentSection);
function classicEvents.doEvents()
    local players = Player.get()
    for plIndex, plData in ipairs(playerData) do
        local plObject = players[plIndex]
        if plObject == nil then --Let's prevent the plObject a nil value error
            players[plIndex] = players[Player.count()]
        end
        for _,keymapEnumValue in ipairs(playerKeymapKeys) do
            local keymapPropertyName = playerKeymapProperties[keymapEnumValue]
            checkKeyboardEvent(plObject, plIndex, plData, keymapPropertyName, keymapEnumValue)
        end
        
        if(plObject:mem(0x60, FIELD_WORD) == -1 and plData.playerJumping == false)then
            EventManager.callEventInternal("onJump", {plIndex})
        elseif(plObject:mem(0x60, FIELD_WORD) == 0 and plData.playerJumping == true)then
            EventManager.callEventInternal("onJumpEnd", {plIndex})
        end
        
        local section = plObject.section
        if(section ~= plData.currentSection)then
            local evLoadSecitionName = "onLoadSection"
            EventManager.callEventInternal(evLoadSecitionName, {plIndex})
            EventManager.callEventInternal(evLoadSecitionName .. section, {plIndex})
        end
        EventManager.callEventInternal("onLoopSection" .. section, {plIndex})
        
        -- Copy new data here to plData
        for _,keymapEnumValue in ipairs(playerKeymapKeys) do
            local keymapPropertyName = playerKeymapProperties[keymapEnumValue]
            plData[keymapPropertyName] = plObject[keymapPropertyName]
        end
        
        plData.playerJumping = plObject:mem(0x60, FIELD_WORD) == -1
        
        plData.currentSection = section
    end
end

return classicEvents
