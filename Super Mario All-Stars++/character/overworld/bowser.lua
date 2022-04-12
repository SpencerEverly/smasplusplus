--TODO: remove this when we can actually customise animations properly

local bowser = {}

local powerup = nil;

local lastpower = nil;

function bowser.onInitAPI()
	registerEvent(bowser, "onDraw");
	registerEvent(bowser, "onExit");
	registerEvent(bowser, "onSave");
end

function bowser.onDraw()
	if(player.character == CHARACTER_BOWSER) then
		if(player.powerup ~= lastpower) then
			power = player.powerup;
		end

		if (player.powerup == 1) then
			powerup = 1;
			player.powerup = 2;
		end
		
		lastpower = player.powerup;
	else
		local t = Player.getTemplate(CHARACTER_BOWSER);
		t.powerup = powerup or t.powerup;
	end
end

function bowser.onSave()
	if(player.character == CHARACTER_BOWSER) then
		player.powerup = powerup or player.powerup;
	end
end

function bowser.onExit()
	if(player.character == CHARACTER_BOWSER) then
		player.powerup = powerup or player.powerup;
	end
end

return bowser;