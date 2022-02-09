--------------------------------------------------
-- Level code
-- Created 16:29 2022-2-8
--------------------------------------------------

Graphics.activateHud(false)

-- Run code on level start
function onStart()
    --Your code here
end

-- Run code every frame (~1/65 second)
-- (code will be executed before game logic will be processed)
function onTick()
    --Your code here
end

-- Run code when internal event of the SMBX Engine has been triggered
-- eventName - name of triggered event
function onEvent(eventName)
    if eventName == "RebootSMASPlusPlus" then
		Misc.loadEpisode("Super Mario All-Stars++")
	end
end

