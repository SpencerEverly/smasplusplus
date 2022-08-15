--[[

.---. .----.  .----. .-. .-..-. .-..----.
/   __}| {}  }/  {}  \| { } ||  `| || {}  \
\  {_ }| .-. \\      /| {_} || |\  ||     /
`---' `-' `-' `----' `-----'`-' `-'`----'
.----.  .----. .-. .-..-. .-..----.
| {}  }/  {}  \| { } ||  `| || {}  \
| .--' \      /| {_} || |\  ||     /
`-'     `----' `-----'`-' `-'`----'
_ _  ___ _  _ ___
| ' \/ -_| || / -_)
|_||_\___|\_,_\___|

    Allows character to go down fast and hit blocks below them.
    groundPoundNeue is library name.
    ( i want die)
    ]]
local inputs = API.load("inputs2");
local playeranim = API.load("playerAnim");
local groundPoundNeue = {}

groundPoundNeue.delayUntilPound = 20;
groundPoundNeue.fancyAnim = false;
local registeredCharacters = {};
local footContact = {};
local players = {player, player2};
local isBannedCharacter = {};
local isInSomething = {};
local isDoingBannedStuff = {};
local isHoldingSomething = {};
local isRunning = {};
local    inGroundNow = {};
local    inSlopeNow = {};
local    inStandNPC = {};
local    isInVine = {};
local    pressedAltJump = {};
local    isInMount =    {};
local isInWater = {};
local spriteHeld =  {};
local characterId =  {};
local isStatue = {};
local isInRainbowShell =  {};
local isLeft =  {};
local playerZoomFactor = {};
local times = {};
local timer = 0;
local alreadyTriedToPound = {};
local delayTimer = {groundPoundNeue.delayUntilPound + 120, groundPoundNeue.delayUntilPound + 120};
local shouldBeStill = {};
local stillAtY = {};
local stillAtX = {};
local isUnderwater = {};

local defaultGravityValues = {12, 12, 12, 12, 12, 16, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12};
groundPoundNeue.preventPoundForTime = 30;
local isPounding = {};
local timeSinceLastPound = {groundPoundNeue.preventPoundForTime, groundPoundNeue.preventPoundForTime};
local instantKillables = {408, 135, 136, 578, 588, 23, 372, 382, 383, 539, 374, 165, 407, 176, 76, 177, 161, 121, 122, 123, 124, 173, 4, 175, 6, 111, 109, 110, 112, 77, 25, 243, 167, 244, 3, 162, 20, 19, 130, 131, 132, 470, 471, 129, 587, 163, 166, 241, 159};
local poundStoppers = {311, 312, 315, 314, 313, 318, 316, 317, 106, 154, 155, 156, 157, 40, 58, 21, 79, 80, 81, 82, 83, 67, 68, 69, 70, 160, 78, 37, 84, 57, 476, 212, 46, 45, 570, 419, 418, 263, 437, 295, 435, 432, 301, 355, 357, 485, 486, 487, 26, 457, 458, 364, 477, 478, 479, 480, 481, 482, 484, 387, 591, 592, 391, 105, 367, 339, 344, 190, 582, 583, 584, 585, 594, 595, 596, 597, 598, 599};
local exemptBlocks = {8, 25, 26, 27, 28, 30, 38, 69, 79, 108, 121, 122, 123,130, 161, 168, 172, 175, 178, 181, 240, 241, 242, 243, 244, 245, 259, 260, 261, 287, 288, 289, 290, 370, 371, 372, 373, 374, 375, 379, 380, 381, 382, 389, 391, 392, 404, 405, 406, 420, 437, 438, 439, 440 ,441, 442, 443, 444, 445, 446, 447, 448, 459, 460 ,461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 506, 507, 508, 568, 572, 575, 579, 727, 725, 729, 731, 172, 175, 178, 181, 1269, 1171, 1172, 1173, 1262, 1263, 1264, 1265, 1266, 1267, 1270, 1273, 1272, 1278, 1272, 690, 1150, 1144, 1145, 1146, 1147, 1148, 1149, 1142, 1143, 626, 627, 628, 629, 632, 640, 642, 644, 646, 648, 650, 652, 654, 660, 664, 656, 687};
local breakables = {226, 188, 60, 4, 457};
Defines.gravity =  69; -- nice.
local function checkOverride(a, b)
    if a == nil then
        return b
    end
    return a
end
-- please please please plug in the animation or else it will be ultra janky
function groundPoundNeue.registerCharacter(id, prepare, pound, settings)
    settings = settings or {}
    registeredCharacters[id] = {
        prepareAnim = prepare or playeranim.Anim(24),
        poundAnim = pound or playeranim.Anim(24),
        gravityValue = checkOverride(settings.normalGravity, defaultGravityValues[id]),
        beginPoundSpeed = checkOverride(settings.beginPoundSpeed, 12),
        maximumPoundSpeed = checkOverride(settings.maximumPoundSpeed, 16),
        enabled = checkOverride(settings.enabled, true),
        canKill = checkOverride(settings.canKill, true)
    }
end


-- expose playeranim.Anim() so you can create the animation
function groundPoundNeue.createAnimation(...)
    return playeranim.Anim({...});
end
function groundPoundNeue.registerAsDummies()
      groundPoundNeue.registerCharacter(CHARACTER_MARIO, groundPoundNeue.createAnimation(43),  groundPoundNeue.createAnimation(24), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_LUIGI, groundPoundNeue.createAnimation(43),  groundPoundNeue.createAnimation(24), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_PEACH, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_TOAD, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7), {enabled = false})
    groundPoundNeue.registerCharacter(CHARACTER_LINK, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_MEGAMAN, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(16), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_WARIO, groundPoundNeue.createAnimation(43),  groundPoundNeue.createAnimation(24), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_BOWSER, groundPoundNeue.createAnimation(30),  groundPoundNeue.createAnimation(24), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_KLONOA, groundPoundNeue.createAnimation(34),  groundPoundNeue.createAnimation(36), {enabled = false})
    groundPoundNeue.registerCharacter(10, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_ROSALINA, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_SNAKE, groundPoundNeue.createAnimation(3),  groundPoundNeue.createAnimation(5), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_ZELDA, groundPoundNeue.createAnimation(31),  groundPoundNeue.createAnimation(23), {enabled = false})
      groundPoundNeue.registerCharacter(CHARACTER_ULTIMATERINKA, groundPoundNeue.createAnimation(7),  groundPoundNeue.createAnimation(27), {enabled = false})
    groundPoundNeue.registerCharacter(15, groundPoundNeue.createAnimation(7),  groundPoundNeue.createAnimation(27), {enabled = false})
    groundPoundNeue.registerCharacter(16, groundPoundNeue.createAnimation(7),  groundPoundNeue.createAnimation(27), {enabled = false})
end
--register everything to what I intended it to be
function groundPoundNeue.registerAllPlayersDefault()
    groundPoundNeue.registerCharacter(CHARACTER_MARIO, groundPoundNeue.createAnimation(43),  groundPoundNeue.createAnimation(24))
    groundPoundNeue.registerCharacter(CHARACTER_LUIGI, groundPoundNeue.createAnimation(43),  groundPoundNeue.createAnimation(24))
    groundPoundNeue.registerCharacter(CHARACTER_PEACH, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7))
    groundPoundNeue.registerCharacter(CHARACTER_TOAD, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7))
    groundPoundNeue.registerCharacter(CHARACTER_MEGAMAN, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(16), {beginPoundSpeed = 14, maximumPoundSpeed = 18})
    groundPoundNeue.registerCharacter(CHARACTER_WARIO, groundPoundNeue.createAnimation(43),  groundPoundNeue.createAnimation(24))
    groundPoundNeue.registerCharacter(CHARACTER_BOWSER, groundPoundNeue.createAnimation(30),  groundPoundNeue.createAnimation(24), {canKill = false})
    groundPoundNeue.registerCharacter(CHARACTER_KLONOA, groundPoundNeue.createAnimation(34),  groundPoundNeue.createAnimation(36))
    groundPoundNeue.registerCharacter(CHARACTER_ROSALINA, groundPoundNeue.createAnimation(27),  groundPoundNeue.createAnimation(7))
    groundPoundNeue.registerCharacter(CHARACTER_SNAKE, groundPoundNeue.createAnimation(3),  groundPoundNeue.createAnimation(5))
    groundPoundNeue.registerCharacter(CHARACTER_ZELDA, groundPoundNeue.createAnimation(31),  groundPoundNeue.createAnimation(23))
    groundPoundNeue.registerCharacter(CHARACTER_ULTIMATERINKA, groundPoundNeue.createAnimation(7),  groundPoundNeue.createAnimation(27))
end
-- turn on fancy animations (probably doesn't work)
function groundPoundNeue.registerAllPlayersFancyAnim()
    groundPoundNeue.registerAllPlayersDefault();
    groundPoundNeue.registerCharacter(CHARACTER_MARIO, playeranim.Anim({32, 33, 34, 35, 36, 37, 38, 39}, 2),  groundPoundNeue.createAnimation(24))
    groundPoundNeue.registerCharacter(CHARACTER_LUIGI, playeranim.Anim({32, 33, 34, 35, 36, 37, 38, 39}, 2),  groundPoundNeue.createAnimation(24))
    groundPoundNeue.fancyAnim = true;

end
function groundPoundNeue.onInitAPI()
    registerEvent(groundPoundNeue, "onTick");
    registerEvent(groundPoundNeue, "onDraw");
    registerEvent(groundPoundNeue, "onInputUpdate");
  groundPoundNeue.registerAsDummies();
    --for _, v in pairs (Player.get()) do
    --    registerCustomPlayer(v);
    --end
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function hitBlocks(o)
    if isPounding[o] then
        for k,v in pairs(Block.getIntersecting(players[o].x + (players[o].width/2) - 5, players[o].y + players[o].height, players[o].x + (players[o].width/2) + 5, players[o].y + players[o].height + 32)) do
            if not has_value(exemptBlocks, v.id) then
            if players[o].powerup == 1 then
                if v.contentID == 0 then
                    v:hit(true, players[o]);
                    isPounding[o] = false;
                    Sound.playSFX("sound/smb2-hit.ogg");
                    Effect.spawn(10, players[o].x, players[o].height + players[o].y)
                    Defines.earthquake = 10;
                else
                    v:hit(true, players[o]);
                    players[o].y = players[o].y -5
                    if timer % 2 == 0 then
                        Sound.playSFX("sound/stomped.ogg");
                    end
                end
            else
                v:hit(true, players[o]);
                if has_value(breakables, v.id) and
                v.contentID == 0 then
                    v:remove(true);
                    players[o].speedY = 5;
                    isPounding[o] = true;
                    Defines.earthquake = 3;
                elseif v.contentID ~= 0 then
                    players[o].speedY = 5;
                    players[o].y = players[o].y - 15;
                    if timer % 2 == 0 then
                        Sound.playSFX("sound/stomped.ogg");
                    end
                    isPounding[o] = true;
                elseif v.contentID == 0 then
                    isPounding[o] = false;
                    Sound.playSFX("sound/smb2-hit.ogg");
                    Effect.spawn(10, players[o].x, players[o].height + players[o].y)
                    Defines.earthquake = 10;
                end
            end
        end
    end
    end
end

local function hitNPCs(o)
    if isPounding[o] and not footContact[o]  and registeredCharacters[players[o].character] then
        for k,v in pairs(NPC.getIntersecting(players[o].x, players[o].y + players[o].height, players[o].x + players[o].width, players[o].y + players[o].height + 32)) do
            if has_value(instantKillables, v.id) then
                v:kill();
            elseif has_value(poundStoppers, v.id) then
                isPounding[o] = false;
                return nil;
            end
        end
    end
end
local function thePound(i)
    if not isPounding[i]  and timeSinceLastPound[i] >= groundPoundNeue.preventPoundForTime then
    registeredCharacters[players[i].character].prepareAnim:play(players[i]);
    Sound.playSFX("sound/zelda-stab.ogg");
    isPounding[i] = true;
    alreadyTriedToPound[i] = true;
    timeSinceLastPound[i] = 0;
    stillAtY[i] = players[i].y;
    stillAtX[i] = players[i].x;
    players[i].speedX = 0
    if inputs.state[i].down == inputs.PRESS then
        delayTimer[i] = 0;
        players[i]:mem(0xE8,FIELD_DFLOAT, 0);
    end
end
end
local function inputUpdateRun(o)
    if not isDoingBannedStuff[o] and registeredCharacters[players[o].character].enabled and Player.count() == 1 or SaveData.disableX2char == false then
        if inputs.state[o].down == inputs.PRESS then
            thePound(o);
        end
        if isPounding[o] and
        (inputs.state[o].up == inputs.PRESS) then
            isPounding[o] = false;
            alreadyTriedToPound[o] = false;
            Sound.playSFX("sound/hammer.ogg");
        end
    end
end
local function memRecognitionFunction(i)
    inGroundNow[i] = players[i]:mem(0x146, FIELD_BOOL)
    inSlopeNow[i] = players[i]:mem(0x48, FIELD_BOOL)
    inStandNPC[i] = players[i]:mem(0x176, FIELD_BOOL)
    isInVine[i] = players[i]:mem(0x40, FIELD_BOOL)
    pressedAltJump[i] = players[i].altJumpKeyPressing
    isInMount[i] =    players[i]:mem(0x108, FIELD_BOOL)
    --customPlayers[i].isInWater = customPlayers[i].constant:mem(0x36, FIELD_BOOL)
    spriteHeld[i] =  players[i]:mem(0x154, FIELD_WORD)
    --characterId[i] =  players[i]:mem(0xF0, FIELD_WORD)
    isStatue[i] = players[i]:mem(0x4A, FIELD_BOOL)
    isInRainbowShell[i] =  players[i]:mem(0x44, FIELD_BOOL)
    isLeft[i] =  players[i]:mem(0x106, FIELD_WORD) < 0
    playerZoomFactor[i] = players[i]:mem(0xE0, FIELD_DFLOAT)
    isUnderwater[i] = players[i]:mem(0x36, FIELD_BOOL)
end
local function memFusions(e)
    isRunning[e] = math.abs(players[e].speedX) >= 4.5;
    footContact[e] = inSlopeNow[e] or inGroundNow[e] or inStandNPC[e];
    isHoldingSomething[e] = spriteHeld[e] >= 1;
    isInSomething[e] = isInVine[e] or isInMount[e] or isInRainbowShell[e] or isStatue[e];
end

local function doingBannedStuff(i)
    isDoingBannedStuff[i] = footContact[i] or isInSomething[i] or isUnderwater[i] or isHoldingSomething[i];
end
local function preventFast(l)
    if not footContact[l] and
    not isPounding[l] then
        if players[l].speedY > registeredCharacters[players[l].character].gravityValue then
            players[l].speedY = registeredCharacters[players[l].character].gravityValue
        end
    elseif not footContact[l] and
    isPounding[l] and delayTimer[l] < groundPoundNeue.delayUntilPound then
        players[l].y = stillAtY[l];
        players[l].x = stillAtX[l];
    elseif not footContact[l] and
    isPounding[l] and delayTimer[l] == groundPoundNeue.delayUntilPound then
        players[l].speedY = registeredCharacters[players[l].character].beginPoundSpeed;
        registeredCharacters[players[l].character].prepareAnim:stop(players[l]);
        registeredCharacters[players[l].character].poundAnim:play(players[l]);
    elseif not footContact[l] and
    isPounding[l] and delayTimer[l] >= groundPoundNeue.delayUntilPound then
        if players[l].speedY > registeredCharacters[players[l].character].maximumPoundSpeed then
            players[l].speedY = registeredCharacters[players[l].character].maximumPoundSpeed;
        end
    end
    if isPounding[l] then
        players[l].speedY = math.clamp(players[l].speedY, -10, registeredCharacters[players[l].character].maximumPoundSpeed);
    end
end

function groundPoundNeue.onInputUpdate()
    inputUpdateRun(1);
    if Player.count() == 2 then
        inputUpdateRun(2);
    end
end



local function tests(o)
  isBannedCharacter[o] = not registeredCharacters[players[o].character].enabled;
    if not isPounding[o] and not isBannedCharacter[o] then
        registeredCharacters[players[o].character].prepareAnim:stop(players[o]);
        registeredCharacters[players[o].character].poundAnim:stop(players[o]);
    end
    if isDoingBannedStuff[o] then
        isPounding[o] = false;
    end
    if registeredCharacters[players[o].character].enabled then
        memRecognitionFunction(o);
        memFusions(o);
        doingBannedStuff(o);
    end
    hitBlocks(o);
    hitNPCs(o);
    if footContact[o] then
        alreadyTriedToPound[o] = false;
        timeSinceLastPound[o] = groundPoundNeue.preventPoundForTime;
    end
    if groundPoundNeue.fancyAnim then
        if players[o].character == 1 then
            players[o].setCostume(1, "SPIN-Mario");
        end
        if players[o].character == 2 then
            players[o].setCostume(2, "SPIN-Luigi");
        end
    end
end

function groundPoundNeue.onTick()
    if not Misc.isPaused() then
        tests(1);
        if Player.count() == 2 then
            tests(2);
        end
        timer = timer + 1;
        if timer % 1 == 0 then
            preventFast(1);
            if Player.count() == 2 then
                preventFast(2);
            end
        end
        delayTimer[1] = delayTimer[1] + 1;
        timeSinceLastPound[1] = timeSinceLastPound[1] + 1;

        if Player.count() == 2 then
            delayTimer[2] = delayTimer[2] + 1;
            timeSinceLastPound[2] = timeSinceLastPound[2] + 1;
        end
    end
end



return groundPoundNeue;
