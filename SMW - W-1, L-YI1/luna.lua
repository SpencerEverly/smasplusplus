local level_dependencies_normal = require("level_dependencies_normal")

local slopes = require("slopes")

slopes.jump_through = {752, 753}

local pipeAPI = require("pipecannon")
-- You can set exit speeds for every warp
pipeAPI.exitspeed = {0, 15}
-- Will ignore speeds set for doors/instant warps

-- Firing angles, clockwise from perpendicular
pipeAPI.angle = {}
pipeAPI.angle[2] = 45

-- Sound effect for firing
pipeAPI.SFX = 22 -- default value (bullet bill sfx), set to 0 for silent
-- Visual effect for firing
pipeAPI.effect = 10 -- set to 0 for none