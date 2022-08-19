local level_dependencies_normal= require("level_dependencies_normal")

function doorRegeneration()
    Routine.waitFrames(50, true)
    Npc.restoreClass("NPC")
end

function onDraw()
    for _,p in ipairs(Player.get()) do
        if p.forcedState == FORCEDSTATE_DOOR then
            if p.forcedTimer == 1 then
                Routine.run(doorRegeneration)
            end
        end
    end
end