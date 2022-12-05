local particles = require("particles");
local rng = require("rng");

local trail = {visible=true};

local lastPlayerPos = {};
local spinjump_trail = particles.Ribbon(0,0,Misc.resolveFile("r_trail.ini"));


local col_blue = Color.fromHexRGB(0x1166FF);
local col_green = Color.fromHexRGB(0x11FF66);

local spinjump_colours = {col_blue,col_green,col_green,col_blue,col_blue};

trail.colorOverride = {}

spinjump_colours[CHARACTER_UNCLEBROADSWORD] = Color.brown

function trail.setParam(paramName, value)
    spinjump_trail:setParam(paramName, value)
end

function trail.resetParam(paramName)
    spinjump_trail:setParam(paramName, spinjump_trail:getParamDefault(paramName))
end

function trail.onInitAPI()
    registerEvent(trail, "onStart", "onStart", false);
    registerEvent(trail, "onTick", "onTick", false);
    registerEvent(trail, "onCameraDraw", "onCameraDraw", false);
end

function trail.onStart()
    spinjump_trail:Attach(player);
    spinjump_trail.enabled = false;
    
    lastPlayerPos.x = player.x;
    lastPlayerPos.y = player.y;
end

function trail.onTick()
    if(not spinjump_trail.enabled and player:mem(0x50,FIELD_BOOL) and player.deathTimer == 0) then
        spinjump_trail:Emit();
        spinjump_trail:Emit();
        spinjump_trail.enabled = true;
        local color = trail.colorOverride[player.character]
        if color == nil then
            color = spinjump_colours[player.character]
        end
        spinjump_trail:setParam("col",color);
    elseif(spinjump_trail.enabled and (not player:mem(0x50,FIELD_BOOL) or player.deathTimer > 0)) then
        spinjump_trail.enabled = false;
    end
end

function trail.onCameraDraw()
    if(lastPlayerPos.x == nil) then return end;
    if(math.abs(player.x-lastPlayerPos.x) > 20 or math.abs(player.y-lastPlayerPos.y) > 20) then    
        spinjump_trail:Break();
    end
    
    if  trail.visible  then
        spinjump_trail:Draw(-26);
    end
    
    lastPlayerPos.x = player.x;
    lastPlayerPos.y = player.y;
end

function trail.Break()
    spinjump_trail:Break();
end


return trail;