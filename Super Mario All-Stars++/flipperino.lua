--[[

    flipperino.lua v2.1

    Written by Zeus guy
    A few lines of code taken from MrDoubleA's One-Way Walls and maybe from the default libraries.

    Changelog:
    -Blocks don't need to have a flipped graphic anymore (sizeables do... for now)
    -Backgrounds don't need to have a flipped graphic anymore
        -However, a txt file with the following settings is recommended:
            [BG]
            img="background2-x.png"
            name="BG"
            parallaxX=1
            parallaxY=1
            alignY=CENTRE
            alignX=CENTRE
            repeatX = true
            repeatY = true

]]

local cb = Graphics.CaptureBuffer(800, 600);
local bgcb = Graphics.CaptureBuffer(800, 600);
local blockmanager = require("blockmanager");
local blockutils = require("blocks/blockutils");
local cp = require("blocks/ai/clearpipe");


local flipperino = {}

local cpOdb = cp.onDrawBlock;
function flipperino.cpOdb(b)
    if (not flipperino.flipped) then
        cpOdb(b);
    end
end

cp.onDrawBlock = flipperino.cpOdb;

function flipperino.onInitAPI()
    registerEvent(flipperino, "onStart", "onStart", false);
    registerEvent(flipperino, "onTick", "onTick", false);
    registerEvent(flipperino, "onDraw", "onDraw", false);
    registerEvent(flipperino, "onDrawEnd", "onDrawEnd", false);
    registerEvent(flipperino, "onEvent", "onEvent", false);
    registerEvent(flipperino, "onCameraUpdate", "onCameraUpdate", false);
end


--Init stuff
flipperino.flipped = false;      --If the level is flipped or not.
flipperino.flipNpcs = {};        --Used for when an NPC should turn into another when the level is flipped. Values can be added in your level file if needed.
flipperino.showMirrored = true;  --If set to false, the camera doesn't flip while the level is upside-down.
flipperino.flipBgos = {};        --When the player touches one of these BGOs, the level will turn upside-down.
flipperino.unflipBgos = {};      --When the player touches one of these BGOS, the level will return to normal.
flipperino.flipSound = 13;       --The sound that plays when the level flips.

function flipperino.onStart()

    --Stretch and Ceiling Stretch. There's no situation where you wouldn't want these to turn into each other. Mainly because they'd break.
    flipperino.flipNpcs[323] = 324;
    flipperino.flipNpcs[324] = 323;

    --Search for all blocks in the level and store their flipped graphic, if it exists.
    flipperino.flippedBlocks = {};
    for k,v in ipairs(Block.get()) do
        if (flipperino.flippedBlocks[v.id] == nil) then
            flipperino.flippedBlocks[v.id] = Graphics.loadImage("flipped/block-"..v.id..".png") ;
        end
        --In order to make upside-down sizeables work, all sizeables now have bottom collision as well as top collision.
        if (Block.config[v.id].sizeable) then
            blockmanager.registerEvent(v.id, flipperino, "onTickEndBlock");
        end
    end
    
    --Search for all npcs in the level and store their flipped graphic, if it exists.
    flipperino.flippedNpcs = {};
    for k,v in ipairs(NPC.get()) do
        if (flipperino.flippedNpcs[v.id] == nil) then
            flipperino.flippedNpcs[v.id] = Graphics.loadImage("flipped/npc-"..v.id..".png");
        end
    end
    
    --Search for all bgos in the level and, of course, store their flipped graphic, if it exists.
    flipperino.flippedBgos = {};
    for k,v in ipairs(BGO.get()) do
        if (flipperino.flippedBgos[v.id] == nil) then
            flipperino.flippedBgos[v.id] = Graphics.loadImage("flipped/background-"..v.id..".png");
        end
    end

end

function flipperino.onCameraUpdate(camIdx)
    --Horizontal splitscreen fix
    if (flipperino.flipped and flipperino.showMirrored and camera2 ~= nil and camera2.isSplit and camera.height == 300) then
        if (Player(1).y > Player(2).y) then
            camera.renderY = -0.5;
            camera2.renderY = 301;
        else
            camera2.renderY = -0.5;
            camera.renderY = 301;
        end
    end
end

function drawFlipped()
    
    --If the level is flipped and showMirrored is true, then draw the camera upside-down.
    if (flipperino.flipped and flipperino.showMirrored) then 
        cb:captureAt(-5);
        bgcb:captureAt(-100);
        
        if (camera2 ~= nil  and camera2.isSplit and camera.height == 300) then
            Graphics.glDraw {
                vertexCoords = {
                    0,   -300,
                    800, -300, 
                    0,   300, 
                    0,   300, 
                    800, 300, 
                    800, -300
                }, 
                texture = cb, 
                textureCoords = {0,1, 1,1, 0,0, 0,0, 1,0, 1,1}, 
                primitive = Graphics.GL_TRIANGLE, 
                priority = -5
            };
            --Not perfect, idk if it's fixable.
            --It's been 7 months since I wrote that comment, not sure what I was referring to.
            Graphics.glDraw {
                vertexCoords = {
                    0,   -300,
                    800, -300, 
                    0,   300, 
                    0,   300, 
                    800, 300, 
                    800, -300
                }, 
                texture = bgcb, 
                textureCoords = {0,1, 1,1, 0,0, 0,0, 1,0, 1,1}, 
                primitive = Graphics.GL_TRIANGLE, 
                priority = -100
            };
        else
            Graphics.glDraw {
                vertexCoords = {
                    0,   0,
                    800, 0, 
                    0,   600, 
                    0,   600, 
                    800, 600, 
                    800, 0
                }, 
                texture = cb, 
                textureCoords = {0,1, 1,1, 0,0, 0,0, 1,0, 1,1}, 
                primitive = Graphics.GL_TRIANGLE, 
                priority = -5
            };

            Graphics.glDraw{
                vertexCoords = {
                    0,   0,
                    800, 0, 
                    0,   600,
                    0,   600, 
                    800, 600, 
                    800, 0
                }, 
                texture = bgcb,
                textureCoords = {0,1, 1,1, 0,0, 0,0, 1,0, 1,1}, 
                primitive = Graphics.GL_TRIANGLE,
                priority = -100;
            };
        end
    end
end

function flipperino.onDraw()

    drawFlipped();

    redrawBlocks();
    
    
end

function redrawBlocks();
    flipperino.visibleBlocks = {};
    for _,c in ipairs(Camera.get()) do
        c = camera;
        if (flipperino.flipped and flipperino.showMirrored) then 

            for k,v in ipairs(Block.getIntersecting(c.x, c.y, c.x+c.width, c.y+c.height)) do
                if (not v.invisible and not Block.config[v.id].sizeable) then 
                    flipperino.visibleBlocks[#flipperino.visibleBlocks+1] = v;
                    v.invisible = true;

                    frame = blockutils.getBlockFrame(v.id);
                    priority = -65;
                    if (Block.config[v.id].sizeable) then --not working (for now)
                        priority = -90;
                    elseif (Block.config[v.id].lava) then
                        priority = -10;
                    elseif (cp.PIPES[v.id] ~= nil) then
                        priority = -22.5;
                    end

                    x0 = v.x-c.x;
                    x1 = v.x+v.width-c.x;
                    y0 = v.y-c.y;
                    y1 = v.y+v.height-c.y;

                    h0 = v.height * frame / Graphics.sprites.block[v.id].img.height;
                    h1 = h0 + (v.height / Graphics.sprites.block[v.id].img.height);


                    Graphics.glDraw {
                        vertexCoords = {
                            x0, y0,
                            x1, y0, 
                            x0, y1, 
                            x0, y1, 
                            x1, y1, 
                            x1, y0
                        }, 
                        texture = Graphics.sprites.block[v.id].img, 
                        textureCoords = {0,h1, 1,h1, 0,h0, 0,h0, 1,h0, 1,h1}, 
                        primitive = Graphics.GL_TRIANGLE, 
                        priority = priority
                    };

                end
            end
        end
    end
end

function flipperino.onDrawEnd()
    if (flipperino.flipped and flipperino.showMirrored) then 
        for k,v in ipairs(flipperino.visibleBlocks) do
            v.invisible = false;
        end
    end
end

function flipperino.onTick()

    itemCaught = false; --Without this, only the last player can pick up items from the item box.
    fSections = {}; --There is some code that shouldn't run twice if both players are on the same section.

    for _,p in ipairs(Player.get()) do

        if (Camera(p.idx).isSplit) then
            bounds = Camera(p.idx).bounds;
        else
            bounds = camera.bounds;
        end
        
        for k,n in ipairs(NPC.getIntersecting(bounds.left, bounds.top, bounds.right, bounds.bottom)) do

            --This code handles the item box while upside-down.
            --The item is set to friendly until it visually reaches the point where the player should be, and then teleports to the appropriate position.
            --Way easier than trying to modify the item's actual position, trust me.
            if (flipperino.flipped and n:mem(0x138, FIELD_WORD) == 2 and not itemCaught) then

                midpoint = (bounds.top+bounds.bottom)/2 - 16;
                py = midpoint + (midpoint - (p.y + hOffset));

                n.friendly = true;

                pBox = Colliders.Box(p.x, py - p.height / 2, p.width, p.height);
                nBox = Colliders.Box(n.x, n.y, n.width, n.height);

                if (Colliders.collide(pBox, nBox)) then
                    n:mem(0x13C,FIELD_DFLOAT, 2);
                    n.y = p.y;
                    n.friendly = false;
                    itemCaught = true;
                end

            elseif (n.friendly and n:mem(0x138, FIELD_WORD) == 2) then
                n.friendly = false; --You should still be able to collect the item properly if you flip the level while the item is on its way.
            end

            --Items affected by gravity should stick to the ground when the level is flipped.
            --Some vanilla NPCs, like Rippers, have nogravity set to false, so this makes them drop to the floor.
            --This also happens to coins, shockingly. That's why the isCoin check is there.
            if (flipperino.flipped and not NPC.config[n.id].isCoin and not NPC.config[n.id].nogravity and not fSections[p.section] and n.despawnTimer > 0) then
                n.speedY = n.speedY - 0.26;

                if (n.collidesBlockUp) then
                    n:mem(0x136, FIELD_BOOL, false); --This makes thrown items believe they are touching the ground, when they are in fact touching the ceiling.
                end
            end
        end

        for _,b in ipairs(BGO.getIntersecting(p.x, p.y, p.x+p.width, p.y+p.height)) do
            if (flipperino.flipBgos[b.id] and not flipperino.flipped) then
                flipperino.performFlip();
            elseif (flipperino.unflipBgos[b.id] and flipperino.flipped) then
                flipperino.performFlip();
            end
        end

        fSections[p.section] = true;
    end
end

function flipperino.performFlip()

    --Play sound effect.
    SFX.play(flipperino.flipSound);

    --Flip the screen and change npc gravity.
    flipperino.flipped = not flipperino.flipped;
    Defines.npc_grav = flipperino.flipped and 0 or 0.26;

    --Iterate through all sections and flip them. I'm sure this won't be a problem on huge levels.
    for i=0,20,1 do

        sec = Section(i);

        --Switch backgrounds
        if (sec.background ~= nil) then 
            for k,v in ipairs(sec.background:get()) do
                if (v.parallaxY ~= nil) then
                    v.parallaxY = -v.parallaxY;
                end 
            end
        end

        bounds = sec.boundary;
        midpoint = (bounds.top+bounds.bottom)/2 - 16;

        --Change block positions.
        for k,v in ipairs(Block.getIntersecting(bounds.left, bounds.top, bounds.right, bounds.bottom)) do
            hOffset = v.height - 32;
            v.y = midpoint + (midpoint - (v.y + hOffset));
        end

        --Change block sprites.
        for v in pairs(flipperino.flippedBlocks) do
            if (flipperino.flipped) then 
                Graphics.sprites.block[v].img = flipperino.flippedBlocks[v];
            else 
                Graphics.sprites.block[v].img = nil;
            end
            
            --Slopes are flipped here, too.
            temp = -Block.config[v].floorslope;
            Block.config[v].floorslope = -Block.config[v].ceilingslope;
            Block.config[v].ceilingslope = temp;
        end

        --Flip clearpipes.
        for k, v in pairs(cp.PIPES) do
            cp.PIPES[k] = {v[2], v[1], v[3], v[4]};
        end

        for k,v in pairs(cp.JUNCS) do
            if (v == 1 or v == 6) then
                cp.JUNCS[k] = v + 1;
            elseif (v == 2 or v == 7) then
                cp.JUNCS[k] = v - 1;
            end
        end

        for k,v in pairs(cp.ELBS) do
            cp.ELBS[k] = -v;
        end

        --Change NPC sprites.
        for v in pairs(flipperino.flippedNpcs) do
            if (flipperino.flipped) then 
                Graphics.sprites.npc[v].img = flipperino.flippedNpcs[v];
            else 
                Graphics.sprites.npc[v].img = nil;
            end
        end

        --Change BGO positions.
        for k,v in ipairs(BGO.getIntersecting(bounds.left, bounds.top, bounds.right, bounds.bottom)) do 
            hOffset = v.height - 32;
            v.y = midpoint + (midpoint - (v.y + hOffset));
        end

        --Change BGO sprites.
        for v in pairs(flipperino.flippedBgos) do
            if (flipperino.flipped) then 
                Graphics.sprites.background[v].img = flipperino.flippedBgos[v];
            else 
                Graphics.sprites.background[v].img = nil;
            end
        end

        --Hide interaction hardcoded icon when flipped
        if (flipperino.flipped) then
            Graphics.sprites.hardcoded[43].img = Graphics.loadImage("flipped/hardcoded-43.png");
        else
            Graphics.sprites.hardcoded[43].img = nil;
        end

        --Change liquid positions.
        for k,v in ipairs(Liquid.getIntersecting(bounds.left, bounds.top, bounds.right, bounds.bottom)) do 
            hOffset = v.height - 32;
            v.y = midpoint + (midpoint - (v.y + hOffset));
        end
        
        --Change warp positions.
        for k,v in ipairs(Warp.getIntersectingEntrance(bounds.left, bounds.top, bounds.right, bounds.bottom)) do 
            hOffset = v.entranceHeight - 32;
            v.entranceY = midpoint + (midpoint - (v.entranceY + hOffset)) + (32 * ((v.warpType == 2 or (v.entranceDirection == 2 or v.entranceDirection == 4)) and 1 or 0));

            if (v.warpType ~= 2) then
                if     (v.entranceDirection == 1) then v.entranceDirection = 3;
                elseif (v.entranceDirection == 3) then v.entranceDirection = 1;
                end
            end
        end

        for k,v in ipairs(Warp.getIntersectingExit(bounds.left, bounds.top, bounds.right, bounds.bottom)) do 
            hOffset = v.exitHeight - 32;
            v.exitY = midpoint + (midpoint - (v.exitY + hOffset)) + (32 * ((v.warpType == 2 or (v.exitDirection == 2 or v.exitDirection == 4)) and 1 or 0));

            if (v.warpType ~= 2) then
                if     (v.exitDirection == 1) then v.exitDirection = 3;
                elseif (v.exitDirection == 3) then v.exitDirection = 1;
                end
            end
        end

        --Change player position
        for _,p in ipairs(Player.get()) do
            if (p.section == i) then
                hOffset = p.height - 32;
                p.y = midpoint + (midpoint - (p.y + hOffset));
                p.speedY = -p.speedY;
            end
        end

        --Change NPC position.
        for k,v in ipairs(NPC.getIntersecting(bounds.left, bounds.top, bounds.right, bounds.bottom)) do
            if (v:mem(0x138, FIELD_WORD) ~= 2) then

                hOffset = v.height - 32;
                v.y = midpoint + (midpoint - (v.y + hOffset));
                v.speedY = -v.speedY;
                
                if (flipperino.flipNpcs[v.id] ~= nil) then 
                    v.id = flipperino.flipNpcs[v.id];
                    v.spawnId = v.id; --Really important, or else npcs would revert when they respawned.
                end

                spawnY = midpoint + (midpoint - (v.spawnY + hOffset));
                --v:mem(0xB0, FIELD_DFLOAT, spawnY); --Pretty sure this is just v.spawnY? I'll leave this here just in case it's not and something breaks.
                v.spawnY = spawnY;

                --Thwomps.
                if (v.id == 432 or v.id == 435 or v.id == 437) then

                    v.data._basegame.direction = -v.data._basegame.direction;
                    v.data._basegame.previous.speedY = -v.data._basegame.previous.speedY;

                    if (v.data._basegame.state == 3) then v.data._basegame.state = 6;
                    elseif (v.data._basegame.state == 6) then v.data._basegame.state = 3; end

                    if (v.data._basegame.state == 2) then v.data._basegame.state = 5;
                    elseif (v.data._basegame.state == 5) then v.data._basegame.state = 2; end

                    if (v.data._basegame.state == 1) then v.data._basegame.state = 4;
                    elseif (v.data._basegame.state == 4) then v.data._basegame.state = 1; end

                --Wall crawlers. They kinda work but sometimes they don't. Mainly when colliding when quicksand. Or water. Or sizeables. Or slopes.
                elseif ( v.id == 205 or v.id == 206 or v.id == 207) then

                    if (v.ai1 == 1) then v.ai1 = 3;
                    elseif (v.ai1 == 2) then v.ai1 = 4;
                    elseif (v.ai1 == 3) then v.ai1 = 1;
                    elseif (v.ai1 == 4) then v.ai1 = 2;
                    end

                end
            end
        end

    end

end

--In order to flip the level, you call an event with the name "flip". That's it.
function flipperino.onEvent(eventName)
    if (eventName == "flip") then
        flipperino.performFlip();
    elseif (eventName == "flipUpsideDown" and not flipperino.flipped) then
        flipperino.performFlip();
    elseif (eventName == "flipNormal" and flipperino.flipped) then
        flipperino.performFlip();
    end
end

--The following functions have been "borrowed" from MrDoubleA's One-Way Walls. Wanted to rewrite it but I ran out of time, so I'll do that later.

local function objectHasCollision(v) -- Get whether a player/NPC has collision. Obviously not perfect, but I guess it does the job
    if type(v) == "Player" then
        return ((v.forcedState == 0 and v.deathTimer == 0 and not v:mem(0x13C,FIELD_BOOL)) and not Defines.cheat_shadowmario)
    elseif type(v) == "NPC" then
        local config = NPC.config[v.id]
        return ((v.despawnTimer > 0 and not v.isGenerator and not v.isHidden) and not v.noblockcollision and (not config or not config.noblockcollision) and v.id ~= 266 and v:mem(0x12C,FIELD_WORD) == 0 and v:mem(0x138,FIELD_WORD) == 0)
    end
end

local function pushObjectOut(v, w)
    if (w.y-w.speedY) >= (v.y+v.height-v.speedY) and (w.speedY < 0) then
        w.y = v.y+v.height
        w.speedY = 0

        if type(w) == "Player" then
            w:mem(0x11C,FIELD_WORD,0) -- Jump force
            w:mem(0x14A,FIELD_WORD,2)
        elseif type(w) == "NPC" then
            w.collidesBlockUp = true
        end
    end
end

function flipperino.onTickEndBlock(v)
    if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end

    -- Players
    for _,w in ipairs(Player.get()) do
        if objectHasCollision(w) and v:collidesWith(w) > 0 then
            pushObjectOut(v,w)
        end
    end
    -- NPCs
    local hitbox = blockutils.getHitbox(v,0.3)

    for _,w in ipairs(Colliders.getColliding{a = hitbox,btype = Colliders.NPC,filter = objectHasCollision}) do
        pushObjectOut(v,w)
    end

end

return flipperino;