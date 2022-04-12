local panim = require("playeranim")

local megaman = {}

local runanim = {2,3,2,4};
local frame = 1;
local timer = 0;

function megaman.onInitAPI()
	--TODO: Register onHUDUpdate when it's implemented
	registerEvent(megaman, "onHUDDraw");
end

local wasmeganman = false;
function megaman.onHUDDraw()
	if(player.character == CHARACTER_MEGAMAN and player:mem(0x108, FIELD_WORD) == 0) then
		timer = timer + 1;
		if(timer == 12) then
			timer = 0;
			frame = (frame%#runanim)+1;
		end
		player:mem(0x114, FIELD_WORD, runanim[frame]);
		wasmeganman = true;
	elseif(player.character ~= CHARACTER_MEGAMAN and wasmeganman) then
		player:mem(0x114, FIELD_WORD, 1);
		wasmeganman = false;
	end
end

return megaman;