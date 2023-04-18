--Costume music change v3.0
function Sound.changeMusic(character, costume)
    Audio.MusicChange(player.section, -- derive new music based on char and costume
end

local lastCharacter
local lastCostume

function onStart()
    lastCharacter = player.character
    lastCostume = player:getCostume()
end

function onLoadSection()
    Sound.changeMusic(lastCharacter, lastCostume)
end

function onTick()
    local newCharacter, newCostume = player.character, player:getCostume()
    if lastCharacter ~= newCharacter or lastCostume ~= newCostume then
        Sound.changeMusic(newCharacter, newCostume)
    end
    
    lastCharacter = newCharacter
    lastCostume = newCostume 
end

--Moving images on a loop
local x = 0
function onDraw()
    x = x + 1
    Graphics.drawImage(MYIMG, x, 0)
end

--smasExtraSounds ipairs
for k,v in ipairs({
    "player-jump",
    "stomped",
    "block-hit",
    "block-smash",
    "player-shrink",
    "player-grow",
    "mushroom",
    "player-died",
    "shell-hit",
    "player-slide",
    "item-dropped",
    "has-item",
    "camera-change",
    "coin",
    "1up",
    "lava",
    "warp",
    "fireball",
    "level-win",
    "boss-beat",
    "dungeon-win",
    "bullet-bill",
    "grab",
    "spring",
    "hammer",
    "slide",
    "newpath",
    "level-select",
    "do",
    "pause",
    "key",
    "pswitch",
    "tail",
    "racoon",
    "boot",
    "smash",
    "thwomp",
    "birdo-spit",
    "birdo-hit",
    "smb2-exit",
    "birdo-beat",
    "npc-fireball",
    "fireworks",
    "bowser-killed",
    "game-beat",
    "door",
    "message",
    "yoshi",
    "yoshi-hurt",
    "yoshi-tongue",
    "yoshi-egg",
    "got-star",
    "zelda-kill",
    "player-died2",
    "yoshi-swallow",
    "ring",
    "dry-bones",
    "smw-checkpoint",
    "dragon-coin",
    "smw-exit",
    "smw-blaarg",
    "wart-bubble",
    "wart-die",
    "sm-block-hit",
    "sm-killed",
    "sm-glass",
    "sm-hurt",
    "sm-boss-hit",
    "sm-cry",
    "sm-explosion",
    "climbing",
    "swim",
    "grab2",
    "smw-saw",
    "smb2-throw",
    "smb2-hit",
    "zelda-stab",
    "zelda-hurt",
    "zelda-heart",
    "zelda-died",
    "zelda-rupee",
    "zelda-fire",
    "zelda-item",
    "zelda-key",
    "zelda-shield",
    "zelda-dash",
    "zelda-fairy",
    "zelda-grass",
    "zelda-hit",
    "zelda-sword-beam",
    "bubble",
    "sprout-vine",
    "iceball",
    "yi_freeze",
    "yi_icebreak",
    "2up",
    "3up",
    "5up",
    "dragon-coin-get2",
    "dragon-coin-get3",
    "dragon-coin-get4",
    "dragon-coin-get5",
    "cherry",
    "explode",
    "hammerthrow",
    "combo1",
    "combo2",
    "combo3",
    "combo4",
    "combo5", --110
    "combo6", --111
    "combo7", --112
}) do
    smasExtraSounds.sounds[k].sfx = Audio.SfxOpen(Misc.resolveSoundFile(v))
end