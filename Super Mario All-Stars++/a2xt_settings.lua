local settings = {};

local EP_LIST_PTR = mem(0x00B250FC, FIELD_DWORD)
local currentEpisodeIndex = mem(0x00B2C628, FIELD_WORD)

local savfil = "save"..tostring(mem(0x00B2C62A, FIELD_WORD))..".sav";
local episodePath = tostring(mem(EP_LIST_PTR + ((mem(0x00B2C628, FIELD_WORD) - 1) * 0x18) + 0x4, FIELD_STRING));

function settings.onInitAPI()
	registerEvent(settings, "onStart", "onStart", true);
	registerEvent(settings, "onTick", "onTick", true);
	registerEvent(settings, "onExitLevel", "onExitLevel", false);
end

function settings.onStart()
	if(not SaveData.init) then
		mem(0x00B2C5AC, FIELD_FLOAT, 0);
		--First run of the game init stuff here
		SaveData.introDone = false;
		SaveData.lives = mem(0x00B2C5AC, FIELD_FLOAT)
		SaveData.init = true;
	end
	GLOBAL_LIVES = SaveData.lives;
	if(not isOverworld) then
		mem(0x00B2C5AC, FIELD_FLOAT, 50);
	end
end
	
if(not isOverworld) then
	function settings.onTick()
		if(mem(0x00B2C5AC, FIELD_FLOAT) ~= 50) then
			GLOBAL_LIVES = GLOBAL_LIVES + mem(0x00B2C5AC, FIELD_FLOAT) - 50;
			SaveData.lives = GLOBAL_LIVES
			mem(0x00B2C5AC, FIELD_FLOAT, 50);
		end
	end

	function settings.onExitLevel()
		if(player:mem(0x13C, FIELD_BOOL)) then
			GLOBAL_LIVES = GLOBAL_LIVES - 1;
			SaveData.lives = GLOBAL_LIVES
		end
		mem(0x00B2C5AC, FIELD_FLOAT, GLOBAL_LIVES);
	end
end


return settings;