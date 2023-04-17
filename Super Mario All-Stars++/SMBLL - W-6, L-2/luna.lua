local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
    for _,p in ipairs(Player.get()) do
        if SysManager.getEnteredCheckpointID() == 0 and p:mem(0x15E, FIELD_WORD) == 0 then
            Sound.playSFX(141) --Going Underground (Skies)
        end
    end
end