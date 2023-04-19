-------------------------------------------------------------------------
-------------------------------------------------------------------------
--            ____                         .--,-``-.                   --
--          ,'  , `.                      /   /     '.      ,---,      --
--       ,-+-,.' _ |            ,-.----. / ../        ;   .'  .' `\    --
--    ,-+-. ;   , ||            \    /  \\ ``\  .`-    ',---.'     \   --
--   ,--.'|'   |  ;|            |   :    |\___\/   \   :|   |  .`\  |  --
--  |   |  ,', |  ':  ,--.--.   |   | .\ :     \   :   |:   : |  '  |  --
--  |   | /  | |  || /       \  .   : |: |     /  /   / |   ' '  ;  :  --
--  '   | :  | :  |,.--.  .-. | |   |  \ :     \  \   \ '   | ;  .  |  --
--  ;   . |  ; |--'  \__\/: . . |   : .  | ___ /   :   ||   | :  |  '  --
--  |   : |  | ,     ," .--.; | :     |`-'/   /\   /   :'   : | /  ;   --
--  |   : '  |/     /  /  ,.  | :   : :  / ,,/  ',-    .|   | '` ,/    --
--  ;   | |`-'     ;  :   .'   \|   | :  \ ''\        ; ;   :  .'      --
--  |   ;/         |  ,     .-./`---'.|   \   \     .'  |   ,.'        --
--  '---'           `--`---'      `---`    `--`-,,-'    '---'          --
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------------------------Created by Hoeloe - 2017------------------------
--------------------Open-Source 3D Overworld Renderer--------------------
-------------------------For Super Mario Bros X--------------------------
---------------------------------v1.0.0----------------------------------
----------------------NOTE: REQUIRES .PNG GRAPHICS-----------------------
--------------------SMAS++ EDITION BY SPENCER EVERLY---------------------


local map3d = {};
local vectr = require("vectr");

local colliders = require("colliders");

----------------------
--    PRIVATE FIELDS  --
----------------------

local tileBuffers = {}
local pathBuffers = {}
local sceneBuffers = {}
local levelBuffers = {}
local levelUnderBuffers = {}
local sceneBillboardBuffer = {}
local levelBillboardBuffer = {}
    
local pathSceneOverlaps = {}

local billboardBuffers;
local billboardTypes = {"level", "scene", "player"}

local defaultHeightmap = Graphics.CaptureBuffer(1,1,true);

--Since SMAS++ goes beyond the limit the max numbers are increased to the max X2 can handle
local MAX_LEVEL = 100;
local MAX_SCENE = 100;
local MAX_PATH = 100;
local MAX_TILE = 400;
local MAX_PLAYER;

local tableinsert = table.insert;
local tableremove = table.remove;

local mathcos = math.cos;
local mathsin = math.sin;
local mathlerp = math.lerp;
local mathsign = math.sign;
local mathmin = math.min;
local mathfloor = math.floor;
local mathceil = math.ceil;

local glDraw = Graphics.glDraw;

local scene = Graphics.CaptureBuffer(800,600);

function map3d.setTarget(target)
    scene = target
end

function map3d.getTarget()
    return scene
end

map3d.clearScene = true

do
    local pm = require("playerManager");
    MAX_PLAYER = #pm.getCharacters();
    
    function pm.onCostumeChange(characterid)
        map3d.RefreshCharacterSprite(characterid);
    end
end

local billboardMaxTypes = {level = MAX_LEVEL, scene = MAX_SCENE, player = MAX_PLAYER}

--Used to prevent rendering before shaders have compiled
local ready = false;

--Stores shader objects for use by the draw function
local Shaders = 
{};

--Stores the path to vertex shaders
local VertexShaders =
{
    default = nil;
    basic = Misc.resolveFile("shaders/map3d/matrixProject.vert");
    billboard = Misc.resolveFile("shaders/map3d/billboardProject.vert");
    skybox = Misc.resolveFile("shaders/map3d/depthField.vert");
};
    
--Stores the path to fragment shaders
local FragmentShaders =
{
    default = nil;
    basic = Misc.resolveFile("shaders/map3d/depthFog.frag");
    flatSkybox = Misc.resolveFile("shaders/map3d/flatDistanceHeightFog.frag");
    textureSkybox = Misc.resolveFile("shaders/map3d/distanceHeightFog.frag");
    distancePlane = Misc.resolveFile("shaders/map3d/textureTiler.frag");
    mipmap = Misc.resolveFile("shaders/map3d/mipmap.frag");
};

--Capture buffer used to draw vanilla elements
local hudcapture;

--Static list of memory locations for the animation arrays of various object types
local tileAnimArrays = {level = 0x00B2BFD8, tile = 0x00B2BFA0, scene = 0x00B2BEF8};

--List of normal maps loaded
local normalmaps =
{
    level = {},
    scene = {},
    path = {},
    tile = {},
    player = {},
    default = CaptureBuffer(1,1,true)
}

--List of emissive maps loaded
local emissivemaps =
{
    level = {},
    scene = {},
    path = {},
    tile = {},
    player = {},
    default = CaptureBuffer(1,1,true)
}

--Loads a normal map if one is present, returns nil if one isn't
local function loadNormalMap(typ, id)
    local p = Misc.multiResolveFile(typ.."-"..id.."n.png", typ.."/"..typ.."-"..id.."n.png", "graphics/"..typ.."/"..typ.."-"..id.."n.png");
    if(p ~= nil) then
        return Graphics.loadImage(p);
    else
        return nil;
    end
end

local function getNormal(typ, id)
    return normalmaps[typ][id] or normalmaps.default;
end

local createEmissiveMipmap;
local getEmissive;
--Loads an emissive map if one is present, returns nil if one isn't
local function loadEmissiveMap(typ, id)
    local p = Misc.multiResolveFile(typ.."-"..id.."e.png", typ.."/"..typ.."-"..id.."e.png", "graphics/"..typ.."/"..typ.."-"..id.."e.png");
    if(p ~= nil) then
        return Graphics.loadImage(p);
    else
        return nil;
    end
end

--Look through all objects and load any normal maps that are present
for i=1,MAX_LEVEL do
    normalmaps.level[i] = loadNormalMap("level", i);
    emissivemaps.level[i] = loadEmissiveMap("level", i);
end
for i=1,MAX_SCENE do
    normalmaps.scene[i] = loadNormalMap("scene", i);
    emissivemaps.scene[i] = loadEmissiveMap("scene", i);
end
for i=1,MAX_PATH do
    normalmaps.path[i] = loadNormalMap("path", i);
    emissivemaps.path[i] = loadEmissiveMap("path", i);
end
for i=1,MAX_TILE do
    normalmaps.tile[i] = loadNormalMap("tile", i);
    emissivemaps.tile[i] = loadEmissiveMap("tile", i);
end
for i=1,MAX_PLAYER do
    normalmaps.player[i] = loadNormalMap("player", i);
    emissivemaps.player[i] = loadEmissiveMap("player", i);
end

--Level frame numbers are not available, so store them here
local levelFrames = 
{
    [2] = 6,
    [8] = 4,
    [9] = 6,
    [12] = 2,
    [13] = 6,
    [14] = 6,
    [15] = 6,
    [25] = 4,
    [26] = 4,
    [31] = 6,
    [32] = 6,
    [33] = 2,
    [34] = 2,
    [35] = 2,
    [36] = 2,
    [37] = 6,
    [38] = 6,
    [39] = 6,
    [40] = 6
};

for i=0,100,1 do
    if(levelFrames[i] == nil) then
        levelFrames[i] = 1;
    end
end


--Contains mipmaps
local mipmaps = {};

--Heightmap data (for CPU height calculations)
local heightTexture = nil;
local heightData = {};

local function updateHeightmap()
    local idx = 1;
    if(type(heightTexture) == "LuaImageResource") then
        local hdata = Graphics.getBits32(heightTexture);
        for i = 1,hdata.__maxidx do
            
            heightData[idx] = (mathfloor(hdata[i]/(256*256))%256)/255;
            idx = idx + 1;
        end
    end
    
    for i = #heightData,idx,-1 do
        heightData[i] = nil;
    end
end

--Private structure holding the current state of the camera
local CamData =
{
    pos = vectr.v3(0,0,0),
    vf = vectr.v3(0,0,1),
    vu = vectr.v3(0,1,0),
    vr = vectr.v3(1,0,0),
    w2c = nil,
    proj = nil,
    tana = 0,
    rectana = 0,
    mat = nil,
    viewdir = {};
};

--Private structure holding computed lighting values
local LightData =
{
    dir = {0,0,1},
    ambient = Color(0,0,0),
    use = 1
};

---------------------
--    PUBLIC FIELDS  --
---------------------

--TODO: Implement orthographic properly (sort of can already, but it messes some things up)
map3d.MODE_PERSPECTIVE = 0;
map3d.MODE_ORTHOGRAPHIC = 1;
map3d.MODE_ORTHO = map3d.MODE_ORTHOGRAPHIC;

map3d.LIGHT_LAMBERT = Misc.resolveFile("shaders/map3d/light_lambert.glsl");
map3d.LIGHT_CEL = Misc.resolveFile("shaders/map3d/light_cel.glsl");

--The properties of the camera
map3d.CameraSettings = 
{
    --The object the camera should aim at. Must contain fields "x" and "y"
    target = camera,
    --The distance from the target, along the Z axis
    distance = 300,
    --The height above the target, along the Y axis
    height = 340,
    --The angle of the camera. 0 points along the Z axis, 90 points down along the Y axis
    angle = 50,
    --The field of view angle for the camera
    fov = 90,
    --The maximum depth at which to render objects in the scene (the far clipping plane)
    farclip = 1920,--960,
    --The distance from the far clipping plane that objects will begin to fade out
    clipfade = 96,
    --Whether or not the camera should adjust its height based on the heightmap
    heightAdjust = true
};

--The fog settings
map3d.FogSettings =
{    
    --Enable or disable distance fog
    enabled = true,
    --Colour of the fog
    color = {0.8, 0.95, 1},
    --Distance at which fog will be completely opaque
    distance = 2560,
    --Density multiplier for the fog
    density = 1.5,
    --Multiplier to control the blending with the skybox
    skyBlend = 0.6,
    --The height at which to blend with the skybox. Increase for a thicker "band" of fog on the horizon
    skyHeight = 32,
    --The distance at which the fog will begin to appear
    start = map3d.CameraSettings.distance;
};

map3d.Heightmap =
{
    --Texture containing the heightmap (defined in metatable)
    --texture
    --Scale of the heightmap
    scale = 64,
    --Position of the heightmap
    position = vectr.zero2;
}
setmetatable(map3d.Heightmap, 
{
    __index = function(tbl, key)
        if(key == "texture") then
            return heightTexture;
        end
    end,
    
    __newindex = function(tbl, key, val)
        if(key == "texture") then
            heightTexture = val;
            
            updateHeightmap();
        else
            rawset(tbl, key, val);
        end
    end
});

map3d.Light = 
{
    enabled = true,
    direction = (vectr.forward3-vectr.up3):normalise();
    color = Color.white,
    ambient = Color(0.1,0.1,0.1),
    autoAmbient = true,
    style = map3d.LIGHT_LAMBERT
};

map3d.MipMaps = 
{
    enabled = true,
    levels = 5,
    billboards = true
}

--List of object IDs that should be billboarded. Supports "level" and "scene" objects
map3d.Billboard = 
{
    level = 
    {
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true,
        [7] = true,
        [8] = true,
        [10] = true,
        [11] = true,
        [12] = true,
        [15] = true,
        [16] = true,
        [17] = true,
        [18] = true,
        [19] = true,
        [20] = true,
        [21] = true,
        [22] = true,
        [23] = true,
        [24] = true,
        [27] = true,
        [28] = true,
        [30] = true,
        [33] = true,
        [34] = true,
        [35] = true,
        [36] = true,
        
        rotate =
        {
        }
    },
    scene = 
    {
        rotate = 
        {
            [3] = false,
            [7] = false,
            [10] = false,
            [19] = false,
            [23] = false,
            [26] = false,
            [27] = false,
            [28] = false,
            [29] = false,
            [30] = false,
            [31] = false,
            [32] = false,
            [33] = false,
            [34] = false,
            [40] = false,
            [44] = false
        };
    },
    adjustPlayerFeet = true
};

map3d.Stackables =
{    
    [19] = {[23]=true, [26]=true},
    [26] = {[23]=true, [26]=true},
    [86] = {[87]=true}
}

map3d.SceneryClip =
{
}

--Auto-populate billboard arrays
for i=0,MAX_LEVEL,1 do
    if(map3d.Billboard.level[i] == nil) then
        map3d.Billboard.level[i] = false;
    end
    map3d.Billboard.level.rotate[i] = false;
end

for i=1,MAX_SCENE,1 do
    map3d.Billboard.scene[i] = true;
    if(map3d.Billboard.scene.rotate[i] == nil) then
        map3d.Billboard.scene.rotate[i] = true;
    end
    map3d.SceneryClip[i] = true;
end

--Skybox image
map3d.Skybox = nil;
--Skybox tint. This doubles as background colour if Skybox is nil
map3d.SkyboxTint = Color.white;

--A large plane of tiles drawn at ground level, designed to mask clipping planes
map3d.BGPlane = {
                --Whether or not to draw the "infinite" tile plane
                enabled = true, 
                --Which tile ID to use for the tile plane (supports only "tile-##.png" objects)
                tile = 394,
                --The size of the tile plane. It is recommended to make the plane wider than it is deep, to account for the aspect ratio
                size = vectr.v2(8192,4096)
                };

--Vanilla world map offsets the level "path backgrounds". In 3d, this can look odd, so an option to disable the default behaviour and properly centre "path backgrounds" can be found here
map3d.UseOffsetPathBackgrounds = true;

--Swell tiles to fix projection rounding errors
map3d.TileSwell = 0.05;

map3d.HUD_NONE = 0;
map3d.HUD_DEFAULT = 1;
map3d.HUD_BUBBLE = 2;

--Which HUD style to use (use HUD_NONE to draw your own)
map3d.HUDMode = map3d.HUD_DEFAULT;

--Whether or not to draw the vanilla pause menu (the menu will still operate regardless of this setting)
map3d.DrawPauseMenu = true;

map3d.BucketSize = 1024;


----------------------------------
--  PRIVATE INTERNAL FUNCTIONS  --
----------------------------------

function map3d.onInitAPI()
    registerEvent(map3d, "onDraw");
end

local createMipmap;
do
    local mipdraw = {
                        vertexCoords = {    
                                            0,    0,
                                            1,    0,
                                            1,    1,
                                            0,    1
                                        },
                        textureCoords = {    
                                            0,    0,
                                            1,    0,
                                            1,    1,
                                            0,    1
                                        },
                        priority = -100,
                        primitive = Graphics.GL_TRIANGLE_FAN,
                        uniforms = {texSize = {1,1}}
                    };

    createMipmap = function(typ, id)
        if(mipmaps[typ] == nil) then
            mipmaps[typ] = {};
        end
        local img = Graphics.sprites[typ][id].img
        mipmaps[typ][id] = Graphics.CaptureBuffer(img.width*2, img.height, true);
        
        mipdraw.shader = Shaders.mipmap;
        mipdraw.target = mipmaps[typ][id];
        mipdraw.texture = img;
        mipdraw.uniforms.texSize[1],mipdraw.uniforms.texSize[2] = img.width,img.height;
        mipdraw.vertexCoords[3],mipdraw.vertexCoords[5] = img.width*2,img.width*2;
        mipdraw.vertexCoords[6],mipdraw.vertexCoords[8] = img.height,img.height;
        glDraw(mipdraw);
    end
    
    createEmissiveMipmap = function(typ, id)
        if(mipmaps.emissive == nil) then
            mipmaps.emissive = {};
        end

        if(mipmaps.emissive[typ] == nil) then
            mipmaps.emissive[typ] = {};
        end
        local img = emissivemaps[typ][id]
        if(img == nil) then return; end
        
        mipmaps.emissive[typ][id] = Graphics.CaptureBuffer(img.width*2, img.height, true);
        
        mipdraw.shader = Shaders.mipmap;
        mipdraw.target = mipmaps.emissive[typ][id];
        mipdraw.texture = img;
        mipdraw.uniforms.texSize[1],mipdraw.uniforms.texSize[2] = img.width,img.height;
        mipdraw.vertexCoords[3],mipdraw.vertexCoords[5] = img.width*2,img.width*2;
        mipdraw.vertexCoords[6],mipdraw.vertexCoords[8] = img.height,img.height;
        glDraw(mipdraw);
    end
end

local function getMipmap(typ, id)
    if(map3d.MipMaps.enabled) then
        if(mipmaps[typ] == nil or mipmaps[typ][id] == nil) then
            createMipmap(typ, id);
        end
        return mipmaps[typ][id];
    else
        return Graphics.sprites[typ][id].img;
    end
end

function getEmissive(typ, id)
    if(map3d.MipMaps.enabled) then
        if(mipmaps.emissive == nil or mipmaps.emissive[typ] == nil or mipmaps.emissive[typ][id] == nil) then
            createEmissiveMipmap(typ, id);
        end
        return mipmaps.emissive[typ][id] or emissivemaps.default;
    else
        return emissivemaps[typ][id] or emissivemaps.default;
    end
end

local function refreshCharacter(id)
    if(id == nil) then
        for k=1,MAX_PLAYER do
            createMipmap("player", k);
        end
    else
        createMipmap("player", id);
    end
end


map3d.MipMaps.refresh = createMipmap;
map3d.MipMaps.get = getMipmap;
map3d.RefreshCharacterSprite = refreshCharacter;

local function convertBucketIdx(x,y)
    return x + 65536*y;
end

local function getBucketFromCoords(x,y)
    return mathfloor(x/map3d.BucketSize) +  65536*mathfloor(y/map3d.BucketSize);
end

local function getBucketIdx(v)
    return mathfloor((v.x+v.width*0.5)/map3d.BucketSize) + 65536*mathfloor((v.y+v.height*0.5)/map3d.BucketSize);
end

--Inserts a box-shaped set of vertices into a given pair of vertex/texture buffers
local function insertBox(vlist, tlist, x1, y1, x2, y2, tx1, ty1, tx2, ty2)
        tableinsert(vlist, x1);
        tableinsert(vlist, y1);
        tableinsert(vlist, x2);
        tableinsert(vlist, y1);
        tableinsert(vlist, x1);
        tableinsert(vlist, y2);
        tableinsert(vlist, x1);
        tableinsert(vlist, y2);
        tableinsert(vlist, x2);
        tableinsert(vlist, y1);
        tableinsert(vlist, x2);
        tableinsert(vlist, y2);
        
        tableinsert(tlist, tx1);
        tableinsert(tlist, ty1);
        tableinsert(tlist, tx2);
        tableinsert(tlist, ty1);
        tableinsert(tlist, tx1);
        tableinsert(tlist, ty2);
        tableinsert(tlist, tx1);
        tableinsert(tlist, ty2);
        tableinsert(tlist, tx2);
        tableinsert(tlist, ty1);
        tableinsert(tlist, tx2);
        tableinsert(tlist, ty2);
end

--Generate a vertex buffer for a single tile and insert it into the correct global buffer
local function insertTileObj(v)
        if(tileBuffers[v.id] == nil) then
            tileBuffers[v.id] = {vMax = v.height/Graphics.sprites.tile[v.id].img.height, buckets = {}};
        end
        
        local basebuffer = tileBuffers[v.id];
            
        local wu = mathceil(v.width/32);
        local hv = mathceil(v.height/32);
        
        local vmax = basebuffer.vMax;
        
        local vx1 = v.x;
        local vy1 = v.y;
        local tx1 = 0;
        local ty1 = 0;
        
        for i = 1,wu do
            local vx2 = mathmin(vx1+32,v.x+v.width);
            
            local tx2 = mathmin(tx1+(1/wu),1);
            
            for j = 1,hv do
                local vy2 = mathmin(vy1+32,v.y+v.height);
                
                local ty2 = mathmin(ty1+(vmax/hv),vmax);
                
                
                local bucket = getBucketFromCoords((vx1+vx2)*0.5, (vy1+vy2)*0.5);
                
                if(basebuffer[bucket] == nil) then
                    basebuffer[bucket] = {verts = {}, tx = {}, tiles = {}};
                    tableinsert(basebuffer.buckets, bucket);
                end
                
                local buffer = basebuffer[bucket];
                        
                tableinsert(buffer.tiles, v);
                
                insertBox(buffer.verts, buffer.tx, vx1-map3d.TileSwell, vy1-map3d.TileSwell, vx2+map3d.TileSwell, vy2+map3d.TileSwell, tx1, ty1, tx2, ty2);
    
                vy1 = vy1+32;
                ty1 = ty1+(vmax/hv)
            end
            vy1 = v.y;
            ty1 = 0;
            vx1 = vx1+32;
            tx1 = tx1+(1/wu)
        end
end

--Generate a vertex buffer for a single path and insert it into the correct global buffer
local function insertPathObj(v)
        if(pathBuffers[v.id] == nil) then
            pathBuffers[v.id] = {buckets = {}};
        end
        
        local bucket = getBucketIdx(v);
        
        if(pathBuffers[v.id][bucket] == nil) then
            pathBuffers[v.id][bucket] = {verts = {}, tx = {}, tiles = {}};
            tableinsert(pathBuffers[v.id].buckets, bucket);
        end
        
        local buffer = pathBuffers[v.id][bucket];
        
        tableinsert(buffer.tiles, v);
        
        insertBox(buffer.verts, buffer.tx, v.x-map3d.TileSwell, v.y-map3d.TileSwell, v.x+v.width+map3d.TileSwell, v.y+v.height+map3d.TileSwell, 0, 0, 1, 1);
end

--Generate a vertex buffer for a single scenery object and insert it into the correct global buffer
local function insertSceneObj(v)
    if(map3d.Billboard.scene[v.id] == nil or map3d.Billboard.scene[v.id] == false) then
        if(sceneBuffers[v.id] == nil) then
            sceneBuffers[v.id] = {vMax = v.height/Graphics.sprites.scene[v.id].img.height, buckets = {}}
        end
        
        local bucket = getBucketIdx(v);
        
        if(sceneBuffers[v.id][bucket] == nil) then
            sceneBuffers[v.id][bucket] = {verts = {}, tx = {}, tiles = {}};
            tableinsert(sceneBuffers[v.id].buckets, bucket);
        end
        
        local buffer = sceneBuffers[v.id][bucket];
        
        tableinsert(buffer.tiles, v);
        
        insertBox(buffer.verts, buffer.tx, v.x-map3d.TileSwell, v.y-map3d.TileSwell, v.x+v.width+map3d.TileSwell, v.y+v.height+map3d.TileSwell, 0, 0, 1, sceneBuffers[v.id].vMax);

    end
end

--Generate a vertex buffer for a single level tile "path background" and insert it into the correct global buffer
local function insertLevelUnder(v)
            if(levelUnderBuffers.tiles == nil) then
                levelUnderBuffers.tiles = {}
                levelUnderBuffers.small = {verts = {}, tx = {}};
                levelUnderBuffers.big = {verts = {}, tx = {}};
            end
            
            local height = mem(mem(0xB2D3E0,FIELD_DWORD) + 2*(0), FIELD_WORD);
            local width = mem(mem(0xB2D3FC,FIELD_DWORD) + 2*(0), FIELD_WORD);
            
            local cx = v.x;
            local cy = v.y;
            
            levelUnderBuffers.tiles[v] = #levelUnderBuffers.small.verts;
            
            insertBox(levelUnderBuffers.small.verts, levelUnderBuffers.small.tx, cx-map3d.TileSwell, cy-map3d.TileSwell, cx+width+map3d.TileSwell, cy+height+map3d.TileSwell, 0, 0, 1, 1);
            
            cx = cx + width*0.5;
            cy = cy + height*0.5;
            height = mem(mem(0xB2D3E0,FIELD_DWORD) + 2*(29), FIELD_WORD);
            width = mem(mem(0xB2D3FC,FIELD_DWORD) + 2*(29), FIELD_WORD);
            cx = cx - width*0.5;
            cy = cy - height*0.5;
            
            if(map3d.UseOffsetPathBackgrounds) then
                cy = cy + 8;
            end
            
            insertBox(levelUnderBuffers.big.verts, levelUnderBuffers.big.tx, cx-map3d.TileSwell, cy-map3d.TileSwell, cx+width+map3d.TileSwell, cy+height+map3d.TileSwell, 0, 0, 1, 1);
end

--Generate a vertex buffer for a single level tile and insert it into the correct global buffer
local function insertLevelObj(v)
        local id = v:mem(0x30,FIELD_WORD);
        if(map3d.Billboard.level[id] == nil or map3d.Billboard.level[id] == false) then
            local height = mem(mem(0xB2D3E0,FIELD_DWORD) + 2*(id), FIELD_WORD)/levelFrames[id];
            local width = mem(mem(0xB2D3FC,FIELD_DWORD) + 2*(id), FIELD_WORD);
            if(levelBuffers[id] == nil) then
                levelBuffers[id] = {vMax = height/Graphics.sprites.level[id].img.height, buckets = {}};
            end
            local bucket = getBucketFromCoords(v.x+width*0.5, v.y+height*0.5);
        
            if(levelBuffers[id][bucket] == nil) then
                levelBuffers[id][bucket] = {verts = {}, tx = {}, tiles = {}};
                tableinsert(levelBuffers[id].buckets, bucket);
            end
            
            local buffer = levelBuffers[id][bucket];
            
            local cx = v.x + 16 - width*0.5;
            local cy = v.y + 32 - height;
            
            tableinsert(buffer.tiles, v);
            
            insertBox(buffer.verts, buffer.tx, cx-map3d.TileSwell, cy-map3d.TileSwell, cx+width+map3d.TileSwell, cy+height+map3d.TileSwell, 0, 0, 1, levelBuffers[id].vMax);
        end
end
    
--Generate a vertex buffer for a single billboard and insert it into the correct global buffer
local function insertBillboard(objType, x, y, id, width, height, depthOffset, yoffset, bend)
        depthOffset = depthOffset or 0;
        yoffset = yoffset or 0;
        
        local objsOfType = billboardBuffers.objs[objType];
        if(objsOfType == nil) then
            objsOfType = {};
            billboardBuffers.objs[objType] = objsOfType;
        end
        
        local objsOfTypeAndId = objsOfType[id];
        if(objsOfTypeAndId == nil) then
            objsOfTypeAndId = {verts = {}, tx = {}, y = {}, x = {}, width = width, vMax = height/Graphics.sprites[objType][id].img.height, depthOffset = depthOffset};
            objsOfType[id] = objsOfTypeAndId
        end
        
        local objsOfTypeAndId_verts = objsOfTypeAndId.verts
        tableinsert(objsOfTypeAndId_verts, x-width);
        tableinsert(objsOfTypeAndId_verts, y-height-yoffset);
        tableinsert(objsOfTypeAndId_verts, x+width);
        tableinsert(objsOfTypeAndId_verts, y-height-yoffset);
        tableinsert(objsOfTypeAndId_verts, x-width);
        tableinsert(objsOfTypeAndId_verts, y-yoffset);
        tableinsert(objsOfTypeAndId_verts, x-width);
        tableinsert(objsOfTypeAndId_verts, y-yoffset);
        tableinsert(objsOfTypeAndId_verts, x+width);
        tableinsert(objsOfTypeAndId_verts, y-height-yoffset);
        tableinsert(objsOfTypeAndId_verts, x+width);
        tableinsert(objsOfTypeAndId_verts, y-yoffset);
        
        local objsOfTypeAndId_y = objsOfTypeAndId.y
        tableinsert(objsOfTypeAndId_y, y);
        tableinsert(objsOfTypeAndId_y, y);
        tableinsert(objsOfTypeAndId_y, y);
        tableinsert(objsOfTypeAndId_y, y);
        tableinsert(objsOfTypeAndId_y, y);
        tableinsert(objsOfTypeAndId_y, y);
        
        local objsOfTypeAndId_x = objsOfTypeAndId.x
        if(bend) then
            tableinsert(objsOfTypeAndId_x, x-width);
            tableinsert(objsOfTypeAndId_x, x+width);
            tableinsert(objsOfTypeAndId_x, x-width);
            tableinsert(objsOfTypeAndId_x, x-width);
            tableinsert(objsOfTypeAndId_x, x+width);
            tableinsert(objsOfTypeAndId_x, x+width);
        else
            tableinsert(objsOfTypeAndId_x, x);
            tableinsert(objsOfTypeAndId_x, x);
            tableinsert(objsOfTypeAndId_x, x);
            tableinsert(objsOfTypeAndId_x, x);
            tableinsert(objsOfTypeAndId_x, x);
            tableinsert(objsOfTypeAndId_x, x);
        end
        
        local objsOfTypeAndId_tx = objsOfTypeAndId.tx
        local objsOfTypeAndId_vMax = objsOfTypeAndId.vMax
        tableinsert(objsOfTypeAndId_tx, 0);
        tableinsert(objsOfTypeAndId_tx, 0);
        tableinsert(objsOfTypeAndId_tx, 1);
        tableinsert(objsOfTypeAndId_tx, 0);
        tableinsert(objsOfTypeAndId_tx, 0);
        tableinsert(objsOfTypeAndId_tx, objsOfTypeAndId_vMax);
        tableinsert(objsOfTypeAndId_tx, 0);
        tableinsert(objsOfTypeAndId_tx, objsOfTypeAndId_vMax);
        tableinsert(objsOfTypeAndId_tx, 1);
        tableinsert(objsOfTypeAndId_tx, 0);
        tableinsert(objsOfTypeAndId_tx, 1);
        tableinsert(objsOfTypeAndId_tx, objsOfTypeAndId_vMax);
end

local initTextures;
do
    local defdraw = {
                        vertexCoords = {0,0,1,0,1,1,0,1},
                        primitive = GL_TRIANGLE_FAN,
                        priority = -100,
                        color = {0,0,0,1}
                    };
    initTextures = function()
        --Render default normal map
        defdraw.color[1],defdraw.color[2],defdraw.color[3] = 0.5,0.5,1;
        defdraw.target = normalmaps.default;
        glDraw(defdraw);
        
        --Render default height map
        defdraw.color[1],defdraw.color[2],defdraw.color[3] = 0,0,0;
        defdraw.target = defaultHeightmap;
        glDraw(defdraw);
        
        --Render default emissive map
        defdraw.target = emissivemaps.default;
        glDraw(defdraw);
    end
end

local cliptest;

--Initialise the buffers and shaders
local function init()
    cliptest = map3d.TestClip;
    
    map3d.RefreshBuffers();

    Shaders.basic = Shader();
    Shaders.billboard = Shader();
    Shaders.flatSkybox = Shader();
    Shaders.textureSkybox = Shader();
    Shaders.distancePlane = Shader();
    Shaders.mipmap = Shader();
    
    Shaders.basic:compileFromFile(VertexShaders.basic, FragmentShaders.basic, {LIGHTING = map3d.Light.style});
    Shaders.billboard:compileFromFile(VertexShaders.billboard, FragmentShaders.basic, {LIGHTING = map3d.Light.style});
    Shaders.distancePlane:compileFromFile(VertexShaders.basic, FragmentShaders.distancePlane, {LIGHTING = map3d.Light.style});
    
    Shaders.flatSkybox:compileFromFile(VertexShaders.skybox, FragmentShaders.flatSkybox);
    Shaders.textureSkybox:compileFromFile(VertexShaders.skybox, FragmentShaders.textureSkybox);
    
    Shaders.mipmap:compileFromFile(nil, FragmentShaders.mipmap, {MIPLEVELS = map3d.MipMaps.levels} );
    
    initTextures();
    
    updateHeightmap();
        
    refreshCharacter();
    
    ready = true;
end

--Generates a clipped subset of the full buffer for use in rendering
local function clipVertsFromBuffer(list, visibleCheck, frustum, aabb)
        local list_tempVerts = list.tempVerts
        local list_tempTx = list.tempTx
        if(list_tempVerts == nil) then
            list_tempVerts = {};
            list_tempTx = {};
            list.tempVerts = list_tempVerts
            list.tempTx = list_tempTx
        end
        
        local idx = 0;
        local size = map3d.BucketSize;
        
        for x = aabb.bl,aabb.br do
            for y = aabb.bt,aabb.bb do
                local lst = list[convertBucketIdx(x,y)];
                if(lst ~= nil and cliptest(x*size, y*size, (x+1)*size, (y+1)*size, frustum, aabb)) then
                    local list_verts = lst.verts
                    local list_tx = lst.tx
                    for k,v in ipairs(lst.tiles) do
                        local base = (k-1)*12;
                        if((not visibleCheck or v.visible) and cliptest(list_verts[base + 1], list_verts[base + 2], list_verts[base + 11], list_verts[base + 12], frustum, aabb)) then
                            for i = 1,12,1 do
                                list_tempVerts[idx] = list_verts[base + i];
                                list_tempTx[idx] = list_tx[base + i];
                                idx = idx + 1;
                            end
                        end
                    end
                end
            end
        end
        
        for i = #list_tempVerts,idx,-1 do
            tableremove(list_tempVerts,i);
            tableremove(list_tempTx,i);
        end
end

--Checks if a scene object is overlapped by a path
local function CheckSceneVisible(v)
    local visible = true;
    if(map3d.SceneryClip[v.id]) then
        if(pathSceneOverlaps[v]) then
            for l,m in ipairs(pathSceneOverlaps[v]) do
                if(m.visible) then
                    visible = false;
                    break;
                end
            end
        end
    end
    return visible;
end

--Generates a clipped subset of the full buffer for use in rendering, specifically used to generate scenery objects
local function clipVertsFromSceneBuffer(list, frustum, aabb)
        local list_tempVerts = list.tempVerts
        local list_tempTx = list.tempTx
        if(list_tempVerts == nil) then
            list_tempVerts = {};
            list_tempTx = {};
            list.tempVerts = list_tempVerts
            list.tempTx = list_tempTx
        end
        
        local idx = 0;
        local size = map3d.BucketSize;
        
        for x = aabb.bl,aabb.br do
            for y = aabb.bt,aabb.bb do
                local lst = list[convertBucketIdx(x,y)];
                if(lst ~= nil and cliptest(x*size, y*size, (x+1)*size, (y+1)*size, frustum, aabb)) then
                    local list_verts = lst.verts
                    local list_tx = lst.tx
                    for k,v in ipairs(lst.tiles) do
                        local base = (k-1)*12;
                        
                        if(cliptest(list_verts[base + 1], list_verts[base + 2], list_verts[base + 11], list_verts[base + 12], frustum, aabb)) then
                            if(CheckSceneVisible(v)) then
                                for i = 1,12,1 do
                                    list_tempVerts[idx] = list_verts[base + i];
                                    list_tempTx[idx] = list_tx[base + i];
                                    idx = idx + 1;
                                end
                            end
                        end
                    end
                end
            end
        end
        
        for i = #list.tempVerts,idx,-1 do
            tableremove(list.tempVerts,i);
            tableremove(list.tempTx,i);
        end
end

--Generates a clipped subset of the full buffer for use in rendering, specifically used to generate level tile "path backgrounds"
local function clipLevelUnderBuffer(v, underBuffers)
    if(v.isPathBackground) then
        for i = 1,12,1 do
            tableinsert(underBuffers.small.verts, levelUnderBuffers.small.verts[levelUnderBuffers.tiles[v] + i]);
            tableinsert(underBuffers.small.tx, levelUnderBuffers.small.tx[levelUnderBuffers.tiles[v] + i]);
        end
    end
    if(v.isBigBackground) then
        for i = 1,12,1 do
            tableinsert(underBuffers.big.verts, levelUnderBuffers.big.verts[levelUnderBuffers.tiles[v] + i]);
            tableinsert(underBuffers.big.tx, levelUnderBuffers.big.tx[levelUnderBuffers.tiles[v] + i]);
        end
    end
end

--Generates a clipped subset of the full buffer for use in rendering, specifically used to generate level tiles (as it also generates their "path backgrounds")
local function clipVertsFromLevelBuffer(list, underBuffers, visibleCheck, frustum, aabb)
        local list_tempVerts = list.tempVerts
        local list_tempTx = list.tempTx
        if(list_tempVerts == nil) then
            list_tempVerts = {};
            list_tempTx = {};
            list.tempVerts = list_tempVerts
            list.tempTx = list_tempTx
        end
        
        local idx = 0;
        local size = map3d.BucketSize;
        
        for x = aabb.bl,aabb.br do
            for y = aabb.bt,aabb.bb do
                local lst = list[convertBucketIdx(x,y)];
                if(lst ~= nil and cliptest(x*size, y*size, (x+1)*size, (y+1)*size, frustum, aabb)) then
                    local list_verts = lst.verts
                    local list_tx = lst.tx
                    for k,v in ipairs(lst.tiles) do
                        local base = (k-1)*12;
                        
                        if(cliptest(list_verts[base + 1], list_verts[base + 2], list_verts[base + 11], list_verts[base + 12], frustum, aabb) and (not visibleCheck or (v.visible or v.isAlwaysVisible))) then
                            for i = 1,12,1 do
                                list_tempVerts[idx] = list_verts[base + i];
                                list_tempTx[idx] = list_tx[base + i];
                                idx = idx + 1;
                            end
                            clipLevelUnderBuffer(v, underBuffers);
                        end
                    end
                end
            end
        end
        
        for i = #list.tempVerts,idx,-1 do
            tableremove(list.tempVerts,i);
            tableremove(list.tempTx,i);
        end
end

local drawInfiniPlane;
do
    local infdraw = {     
                        vertexCoords = {}, 
                        textureCoords = {0,0,0,0,0,0,0,0}, 
                        primitive = Graphics.GL_TRIANGLE_FAN,
                        priority = 0, 
                        target = scene, 
                        uniforms = {heightmap = defaultHeightmap, heightmapScale = 0, heightmapPosition = {0,0}, heightmapSize = {1,1}}
                        --depthTest = true
                    };
    --Draw the background tile plane
    function drawInfiniPlane(planeHei, planeWid, planeBase, tileID, tileHeight, fogDensity)
            local tileImg = Graphics.sprites.tile[tileID].img;
            local tileWidth = tileImg.width;
            local frameHeight = tileHeight/tileImg.height;
            local tileWid = planeWid/tileWidth;
            local tileHei = planeHei/tileHeight;
            
            local planex = mathfloor((CamData.pos.x)/tileWidth)*tileWidth;
            local planey = mathfloor((planeBase+tileHeight)/tileHeight)*tileHeight;
            
            local t = getMipmap("tile",tileID);
            
            infdraw.uniforms.w2c = CamData.w2c;
            infdraw.uniforms.proj = CamData.proj;
            infdraw.uniforms.frameNum = map3d.GetAnimationFrame("tile", tileID)*frameHeight;
            infdraw.uniforms.frameHeight = frameHeight;
            infdraw.uniforms.fogDistance = map3d.FogSettings.distance;
            infdraw.uniforms.fogDensity = fogDensity;
            infdraw.uniforms.fogColour = map3d.FogSettings.color;
            infdraw.uniforms.fogStart = map3d.FogSettings.start;
            infdraw.uniforms.lightDir = LightData.dir;
            infdraw.uniforms.lightCol = map3d.Light.color;
            infdraw.uniforms.ambient = LightData.ambient;
            infdraw.uniforms.useLighting = LightData.use;
            infdraw.uniforms.normalMap = getNormal("tile",tileID);
            infdraw.uniforms.emissiveMap = getEmissive("tile",tileID);
            infdraw.uniforms.mipLevels = map3d.MipMaps.levels;
            if(map3d.MipMaps.enabled) then
                infdraw.uniforms.useMip = 1;
            else
                infdraw.uniforms.useMip = 0;
            end
            infdraw.uniforms.view = CamData.viewdir;
            infdraw.uniforms.rectana = CamData.rectana;
            infdraw.uniforms.frame = 0.0;
            infdraw.uniforms.yoffset = 0.0;
            
            infdraw.vertexCoords[1],infdraw.vertexCoords[2] = planex - planeWid*0.5, planey - planeHei;
            infdraw.vertexCoords[3],infdraw.vertexCoords[4] = planex + planeWid*0.5, planey - planeHei;
            infdraw.vertexCoords[5],infdraw.vertexCoords[6] = planex + planeWid*0.5, planey;
            infdraw.vertexCoords[7],infdraw.vertexCoords[8] = planex - planeWid*0.5, planey;
            
            
            infdraw.textureCoords[3],infdraw.textureCoords[5] = tileWid,tileWid;
            infdraw.textureCoords[6],infdraw.textureCoords[8] = tileHei,tileHei;
            
            infdraw.texture = t;
            infdraw.shader = Shaders.distancePlane;
            
            glDraw(infdraw);
        
    end
end

local drawBubbleHUD;
do
    
    local huddraw = {type = RTYPE_IMAGE}
    
    local bubbledraw = {vertexCoords={}, primitive = Graphics.GL_TRIANGLE_FAN, color = {1,1,1,0.75}};
    
    --Draws the "Bubble" style HUD
    function drawBubbleHUD(priority)
        huddraw.priority = priority;
        local x = 20;
        local y = 560;
        huddraw.x, huddraw.y = x,y;
        huddraw.image = Graphics.sprites.hardcoded["33-2"].img;
        Graphics.draw(huddraw);
        
        huddraw.x, huddraw.y = x+22,y+2;
        huddraw.image = Graphics.sprites.hardcoded["33-1"].img;
        Graphics.draw(huddraw);
        
        Text.printWP(mem(0x00B2C5A8, FIELD_WORD), 1, x+44, y+2, priority);
        
        y = y+20;
        
        huddraw.x, huddraw.y = x-16,y;
        huddraw.image = Graphics.sprites.hardcoded["33-3"].img;
        Graphics.draw(huddraw);
        huddraw.x, huddraw.y = x+22,y+2;
        huddraw.image = Graphics.sprites.hardcoded["33-1"].img;
        Graphics.draw(huddraw);
        
        Text.printWP(SaveData.SMASPlusPlus.hud.lives, 1, x+44, y+2, priority);
        
        
        local starcount = mem(0x00B251E0, FIELD_WORD);
        if(starcount > 0) then
            y = y-40;
            huddraw.x, huddraw.y = x,y;
            huddraw.image = Graphics.sprites.hardcoded["33-5"].img;
            Graphics.draw(huddraw);
            
            huddraw.x, huddraw.y = x+22,y+2;
            huddraw.image = Graphics.sprites.hardcoded["33-1"].img;
            Graphics.draw(huddraw);
            
            Text.printWP(starcount, 1, x+44, y+2, priority);
        end
        
        
        if(world.levelTitle ~= nil and world.levelTitle ~= "") then
            local p = map3d.project(vectr.v4(world.playerX + 16, map3d.GetHeight(world.playerX + 16, world.playerY + 16) + 48, world.playerY + 16, 1));
            
            local wid = #world.levelTitle * 8
            x = p.x + 400 - wid;
            wid = wid*2;
            y = p.y + 300 - 32;
            
            bubbledraw.priority = priority;
            bubbledraw.vertexCoords[1],bubbledraw.vertexCoords[2] = x - 4, y - 4;
            bubbledraw.vertexCoords[3],bubbledraw.vertexCoords[4] = x + wid + 4, y - 4;
            bubbledraw.vertexCoords[5],bubbledraw.vertexCoords[6] = x + wid + 4, y + 16 + 4;
            bubbledraw.vertexCoords[7],bubbledraw.vertexCoords[8] = x - 4, y + 16 + 4;
            
            Graphics.glDraw(bubbledraw);
            --Graphics.glDraw{vertexCoords={, x+wid + 4,y+16+4, x - 4, y+16 + 4}, primitive = Graphics.GL_TRIANGLE_FAN, color = {1,1,1,0.75}, priority = 5};
            Text.printWP(world.levelTitle, 2, x, y, priority);
        end
    end
end

--Computes intersections between a set of path tiles and scene objects, caching the result in a buffer
local function ComputePathIntersections(tiles)
        for k,v in ipairs(tiles) do
            for sid = 1,MAX_SCENE do
                stiles = sceneBuffers[sid];
                if(stiles ~= nil) then
                    for l,m in ipairs(stiles.tiles) do
                        if (v.x < m.x+m.width and v.x+v.width > m.x and v.y < m.y+m.height and v.y + v.height > m.y) then
                            if(pathSceneOverlaps[m] == nil) then
                                pathSceneOverlaps[m] = {};
                            end
                            tableinsert(pathSceneOverlaps[m], v);
                        end
                    end
                end
            end
            for l,m in ipairs(sceneBillboardBuffer) do
                if (v.x < m.obj.x+m.obj.width and v.x+v.width > m.obj.x and v.y < m.obj.y+m.obj.height and v.y + v.height > m.obj.y) then
                    if(pathSceneOverlaps[m.obj] == nil) then
                        pathSceneOverlaps[m.obj] = {};
                    end
                    tableinsert(pathSceneOverlaps[m.obj], v);
                end
            end
        end
end

--Computes intersections between a set of level tiles and scene objects, caching the result in a buffer
local function ComputeLevelIntersections(tiles)
        for k,v in ipairs(tiles) do
            local id = v:mem(0x30,FIELD_WORD);
            local height = mem(mem(0xB2D3E0,FIELD_DWORD) + 2*(id), FIELD_WORD)/levelFrames[id];
            local width = mem(mem(0xB2D3FC,FIELD_DWORD) + 2*(id), FIELD_WORD);
            
            for sid = 1,MAX_SCENE do
                stiles = sceneBuffers[sid];
                if(stiles ~= nil) then
                    for l,m in ipairs(stiles.tiles) do
                        if (v.x < m.x+m.width and v.x+width > m.x and v.y < m.y+m.height and v.y + height > m.y) then
                            if(pathSceneOverlaps[m] == nil) then
                                pathSceneOverlaps[m] = {};
                            end
                            tableinsert(pathSceneOverlaps[m], v);
                        end
                    end
                end
            end
            for l,m in ipairs(sceneBillboardBuffer) do
                if (v.x < m.obj.x+m.obj.width and v.x+width > m.obj.x and v.y < m.obj.y+m.obj.height and v.y + height > m.obj.y) then
                    if(pathSceneOverlaps[m.obj] == nil) then
                        pathSceneOverlaps[m.obj] = {};
                    end
                    tableinsert(pathSceneOverlaps[m.obj], v);
                end
            end
        end
end


-- <0 when to the LEFT side, >0 when to the RIGHT side, 0 when on the line
local function isLeft(ax, ay, p0x, p0y, p1x, p1y)
    return mathsign(((p1x - p0x) * (ay - p0y)) - ((p1y - p0y) * (ax - p0x)));
end

------------------------
--  PUBLIC FUNCTIONS  --
------------------------

--Cubic interpolation
local function cubic(v)
    local sx,sy,sz,sw = 1.0-v, 2.0-v, 3.0-v, 4.0-v;
    sx,sy,sz,sw = sx*sx*sx, sy*sy*sy, sz*sz*sz, sw*sw*sw;
    local x = sx/6.0;
    local y = (sy - 4.0 * sx)/6.0;
    local z = (sz - 4.0 * sy + 6.0 * sx)/6.0;
    local w = 1.0 - x - y - z;
    return x, y, z, w;
end

--Read a value from the heightmap directly
local function readHeight(x,y,w)
    return heightData[mathfloor(y)*w + mathfloor(x)] or 0;
end

--Read a value from the heightmap (with bicubic interpolation)
function map3d.GetHeight(x,y)
    if(heightTexture == nil) then return 0 end
    x = ((x-map3d.Heightmap.position.x)/32) - 0.5;
    y = ((y-map3d.Heightmap.position.y)/32) - 0.5;
    
    local w = heightTexture.width;
    
    local fx,fy = x-mathfloor(x), y-mathfloor(y);
    x,y = x-fx,y-fy;
    
    local xcubicx,xcubicy,xcubicz,xcubicw = cubic(fx);
    local ycubicx,ycubicy,ycubicz,ycubicw = cubic(fy);
    
    local sx,sy,sz,sw = xcubicx + xcubicy, xcubicz + xcubicw, ycubicx + ycubicy, ycubicz + ycubicw;
    local offsetx,offsety,offsetz,offsetw = x-0.5+(xcubicy/sx),x+1.5+(xcubicw/sy),y-0.5+(ycubicy/sz),y+1.5+(ycubicw/sw);
    
    local sample0 = readHeight(offsetx,offsetz,w);
    local sample1 = readHeight(offsety,offsetz,w);
    local sample2 = readHeight(offsetx,offsetw,w);
    local sample3 = readHeight(offsety,offsetz,w);
    
    sx = sx/(sx+sy);
    sy = sz/(sz+sw);
    
    local h = mathlerp(mathlerp(sample3,sample2,sx), mathlerp(sample1,sample0,sx), sy);

    return map3d.Heightmap.scale*h;
end

--After changing certain parameters such as which tiles are billboarded, this must be called to regenerate the buffers
--THIS IS EXTREMELY EXPENSIVE AND SHOULD BE USED SPARINGLY
function map3d.RefreshBuffers()
    tileBuffers = {};
    pathBuffers = {};
    levelBuffers = {};
    sceneBuffers = {};
    
    sceneBillboardBuffer = {};
    levelBillboardBuffer = {};
    
    pathSceneOverlaps = {};
    
    --Gen Tile Buffers
    for k,v in ipairs(Tile.get()) do
        insertTileObj(v);
    end
    
    --Gen Path Buffers
    for k,v in ipairs(Path.get()) do
        insertPathObj(v);
    end
    
    --Gen Scenery Buffers
    for k,v in ipairs(Scenery.get()) do
        insertSceneObj(v);
        if(map3d.Billboard.scene[v.id] == true) then
            tableinsert(sceneBillboardBuffer, {obj = v, offset = 0});
        end
    end
    
    --Gen Level Buffers
    for k,v in ipairs(Level.get()) do
        insertLevelObj(v);
        insertLevelUnder(v);
        local id = v:mem(0x30,FIELD_WORD);
        if(map3d.Billboard.level[id] == true) then
            tableinsert(levelBillboardBuffer, v);
        end
    end
    
    for id = 1,MAX_PATH do
        local tiles = pathBuffers[id];
        if(tiles ~= nil) then
            for _,v in ipairs(tiles.buckets) do
                ComputePathIntersections(tiles[v].tiles);
            end
        end
    end
    
    for id = 1,MAX_LEVEL do
        local tiles = levelBuffers[id];
        if(tiles ~= nil) then
            for _,v in ipairs(tiles.buckets) do
                ComputeLevelIntersections(tiles[v].tiles);
            end
        end
    end
    
    ComputeLevelIntersections(levelBillboardBuffer);
    
    for k,v in ipairs(sceneBillboardBuffer) do
        if(map3d.Stackables[v.obj.id]) then
            local lastID = v.obj.id;
            local lasty = v.obj.y+v.obj.height;
            local searchStack = v.obj.height;
            local foundTile = true;
            while(foundTile) do
                foundTile = false;
                for l,m in ipairs(Scenery.getIntersecting(v.obj.x+v.obj.width*0.5-1, v.obj.y+searchStack, v.obj.x+v.obj.width*0.5+1, v.obj.y + searchStack + 1)) do
                    if(map3d.Stackables[lastID][m.id]) then
                        foundTile = true;
                        local hgt = (m.y+m.height - lasty);
                        v.offset = v.offset + hgt;
                        lasty = m.y + m.height;
                        lastID = m.id;
                        if(map3d.Stackables[lastID]) then
                            searchStack = searchStack + hgt;
                            break;
                        else
                            foundTile = false;
                            break;
                        end
                    end
                end
            end
        end
    end
end

--Gets an animation frame for a given tile type and ID
function map3d.GetAnimationFrame(tileType, id)
    return mem(mem(tileAnimArrays[tileType], FIELD_DWORD) + 2*(id-1), FIELD_WORD);
end

--Computes a screen space coordinate given a vectr.v4 object of the form (x,y,z,1)
function map3d.project(v)
    if(CamData.mat == nil) then
        CamData.mat = CamData.proj*CamData.w2c;
    end
    local v2 =  CamData.mat*v;
    
    v2.x = v2.x/v2.w;
    v2.y = v2.y/v2.w;
    
    return v2;
end

do
    local cliptestxs = {}
    local cliptestys = {}

    --Tests the clipping volumes to see if the rectangle defined by the two extents is visible
    function map3d.TestClip(px, py, p2x, p2y, polygon, aabb)
        if(p2x > aabb.minx and px < aabb.maxx and p2y > aabb.miny and py < aabb.maxy) then
            local lft;
            
            cliptestxs[1] = px;
            cliptestxs[2] = px;
            cliptestxs[3] = p2x;
            cliptestxs[4] = p2x;
            local pxs = cliptestxs;
            
            cliptestys[1] = py;
            cliptestys[2] = p2y;
            cliptestys[3] = py;
            cliptestys[4] = p2y;
            local pys = cliptestys;
            local test = 0;
            for i = 1,4 do
                local inside = true;
                local xi,yi = pxs[i],pys[i];
                for k = 1,#polygon,2 do
                    local k2 = k+2;
                    if(k2 > #polygon) then
                        k2 = 1;
                    end
                    
                    if(lft == nil) then
                        lft = isLeft(xi, yi, polygon[k], polygon[k+1], polygon[k2], polygon[k2+1]);
                        if(lft == 0) then
                            lft = nil;
                        end
                    elseif(isLeft(xi, yi, polygon[k], polygon[k+1], polygon[k2], polygon[k2+1]) ~= lft) then
                        inside = false;
                        break;
                    end
                end
                test = test or inside;
            end
            return test;
        else
            return false;
        end
    end
end

do
    local intersectionList = {};
    local cornerList = {};
    local hullpts = {};
    
    local function orient(px, py, qx, qy, rx, ry)
        return ((qy - py) * (rx - qx) - (qx - px) * (ry - qy));
    end

    --Grab the convex hull of a set of interleaved points
    local function hull(pts)
        if(#pts < 6) then
            return nil;
        end
        
        local pt = 1;
        
        for k=1,#pts,2 do
            if(pts[k] < pts[pt]) then
                pt = k;
            end
        end
        
        local startpt = pt;
        local endpt;
        local idx = 1;
        
        repeat
            hullpts[idx] = pt;
            hullpts[idx+1] = pt+1;
            idx = idx + 2;
            
            endpt = pt + 2;
            if(endpt > #pts) then
                endpt = 1;
            end
            
            local px,pz = pts[pt],pts[pt+1];
            
            for k=1,#pts,2 do
                local qx,qz = pts[endpt],pts[endpt+1];
                if(orient(px, pz, pts[k], pts[k+1], qx, qz) < 0) then
                    endpt = k;
                end
            end
            
            pt = endpt;
        
        until(pt == startpt);
        
        for i = #hullpts,1,-1 do
            if(i >= idx) then
                hullpts[i] = nil;
            else
                hullpts[i] = pts[hullpts[i]];
            end
        end
        
        return hullpts;
    end
    
    --Computes the polygon that intersects the ground plane and contains all objects that can be seen by the camera, and the AABB surrounding the intersecting polygon
    function map3d.GetClippingFrustum()
        local farclip = map3d.CameraSettings.farclip
        local tana = CamData.tana
        local posx,posy,posz = CamData.pos.x,CamData.pos.y,CamData.pos.z;
        
        local cx,cy,cz = posx+CamData.vf.x*farclip, posy+CamData.vf.y*farclip, posz+CamData.vf.z*farclip;
        local rx,ry,rz = CamData.vr.x*farclip * tana, CamData.vr.y*farclip * tana, CamData.vr.z*farclip * tana;
        local ux,uy,uz = CamData.vu.x*farclip * tana * 0.75, CamData.vu.y*farclip * tana * 0.75, CamData.vu.z*farclip * tana * 0.75;
        
        --Compute the corners of the far clipping plane
        cornerList[1],cornerList[2],cornerList[3] = cx + rx - ux, cy + ry - uy, cz + rz - uz;
        cornerList[4],cornerList[5],cornerList[6] = cx + rx + ux, cy + ry + uy, cz + rz + uz;
        cornerList[7],cornerList[8],cornerList[9] = cx - rx + ux, cy - ry + uy, cz - rz + uz;
        cornerList[10],cornerList[11],cornerList[12] = cx - rx - ux, cy - ry - uy, cz - rz - uz;
        
        local maxh = 0;
        if(heightTexture ~= nil) then
            maxh = map3d.Heightmap.scale;
        end

        local intidx = 1;
        
        local minZero;
        
        --Compute the intersection of each edge of the camera view prism with both the height plane and the 0 plane
        for k=1,#cornerList,3 do
            local k2 = k+3;
            if(k2 > #cornerList) then
                k2 = 1;
            end
            
            --Check intersection of the line v->w
            local vx,vy,vz = cornerList[k],cornerList[k+1],cornerList[k+2];
            local wx,wy,wz = cornerList[k2],cornerList[k2+1],cornerList[k2+2];
            
            --Check the line connecting this corner to the next one, and this corner to the camera's location
            for i = 0,1,1 do
            
                --Don't bother checking the height plane if we have no height, since it's identical to the below caclulation
                if(maxh ~= 0) then
                    --If v and w are on opposite sides of the height plane, compute the intersection point and add it to the list
                    if((vy-maxh) * (wy-maxh) < 0) then
                        local gx,gy,gz = wx-vx,wy-vy,wz-vz;
                        intersectionList[intidx] = vx + (gx*((maxh-vy)/gy));
                        intersectionList[intidx+1] = vz + (gz*((maxh-vy)/gy));
                        intidx = intidx + 2;
                    end
                end
                --If v and w are on opposite sides of the zero plane, compute the intersection point and add it to the list
                if(vy * wy < 0) then
                    local gx,gy,gz = wx-vx,wy-vy,wz-vz;
                    local px,pz = vx - gx*(vy/gy), vz - gz*(vy/gy);
                    if(minZero == nil or pz > minZero) then
                        minZero = pz;
                    end
                    intersectionList[intidx] = px;
                    intersectionList[intidx+1] = pz;
                    intidx = intidx + 2;
                end
                --Update w to point to the camera, so we can get the corner->camera edge intersection
                wx,wy,wz = posx,posy,posz;
            end
        end
        
                
        --Add the far clipping plane to the intersection list (helps deal with edge cases)
        intersectionList[intidx],intersectionList[intidx+1] = cornerList[4],cornerList[6];
        intersectionList[intidx+2],intersectionList[intidx+3] = cornerList[7],cornerList[9];
            
        intersectionList[intidx+4],intersectionList[intidx+5] = cornerList[1],cornerList[3];
        intersectionList[intidx+6],intersectionList[intidx+7] = cornerList[10],cornerList[12];
        intidx = intidx+8;
        
        --Include camera location in convex hull for the edge case where camera height = 0
        if(posy == 0) then
            intersectionList[intidx] = posx;
            intersectionList[intidx+1] = posz;
            intidx = intidx + 2;
        end
        
        --Clear unused intersection points
        for i = #intersectionList,intidx,-1 do
            intersectionList[i] = nil;
        end
        
        --If we have fewer than 3 sets of x,y in the intersection list, we have no visible objects, so return nil
        if(#intersectionList < 6) then
            return nil, nil, minZero;
        end
        
        --Giftwrap intersections to give a convex hull
        hull(intersectionList);
        
        --Clear unused hull points
        if(#hullpts < 6) then
            return nil, nil, minZero;
        end
        
        --Compute AABB
        local aabb = {};
        for k=1,#hullpts,2 do
            local vx,vz = hullpts[k],hullpts[k+1];
            if(aabb.minx == nil or vx < aabb.minx) then
                aabb.minx = vx;
            end
            if(aabb.maxx == nil or vx > aabb.maxx) then
                aabb.maxx = vx;
            end
            if(aabb.miny == nil or vz < aabb.miny) then
                aabb.miny = vz;
            end
            if(aabb.maxy == nil or vz > aabb.maxy) then
                aabb.maxy = vz;
            end
        end
        
        if(aabb.minx >= aabb.maxx or aabb.miny >= aabb.maxy) then
            aabb = nil;
        end
        
        return hullpts, aabb, minZero;
            
    end

end

do

    local shaderParams = { rot = {}, pos = {0.0, 0.0} };
    local attributes = {};
    local tan = math.tan;
    local halfrad = 0.5*0.0174533;
    
    local screenBox = {verts = {0,0,800,0,800,600,0,600}, tex = {0,0,1,0,1,1,0,1} }
    local pauseDraw = {    vertexCoords =     { 210, 200, 590, 200, 590, 400, 210, 400 },
                        textureCoords = { 0.2625, 0.333333, 0.7375, 0.333333, 0.7375, 0.666667, 0.2625, 0.666667 },
                        primitive = Graphics.GL_TRIANGLE_FAN, priority = 5 };
                        
    local internalVerts = {66, 130-48, 668+66, 130-48, 668+66, 130-48+501, 66, 130-48+501};
                        
    local sceneDraw = { textureCoords = screenBox.tex,
                        primitive = Graphics.GL_TRIANGLE_FAN,
                        texture = scene, priority = 0 };
    
    local skyboxdat = {camPos = {}, groundDir = {0, 0, 0}}
    local _00 = {0,0};
    local _11 = {1,1};
    
    local skyboxDraw = {vertexCoords = screenBox.verts, textureCoords = screenBox.tex, primitive = Graphics.GL_TRIANGLE_FAN, priority = 0, shader = bgShader, uniforms = {}, target = scene};
    
    local tileDraw = {priority = 0, target = scene, uniforms = shaderParams};
    
    local function doTileDraw(verts, txs, img)
        tileDraw.vertexCoords = verts;
        tileDraw.textureCoords = txs;
        tileDraw.texture = img;
        glDraw(tileDraw);
    end
    
    local function cross(ax,ay,az,bx,by,bz)
        return ay*bz - az*by, az*bx - ax*bz, ax*by - ay*bx;
    end
    
    local function dot(ax,ay,az,bx,by,bz)
        return ax*bx + ay*by + az*bz;
    end
    
    local getclippingfrustum = map3d.GetClippingFrustum;
    
    local currentHeight = 0;
    
    
    local function drawHUD()
        --HUD stuff
        --TODO: Port this to HUDOverride properly
        if(map3d.HUDMode == map3d.HUD_DEFAULT) then
            sceneDraw.vertexCoords = internalVerts;
        else
            sceneDraw.vertexCoords = screenBox.verts;
        end
        glDraw(sceneDraw);
        
        if(map3d.HUDMode == map3d.HUD_NONE) then
            Graphics.activateOverworldHud(WHUD_NONE);
        else
            Graphics.activateOverworldHud(WHUD_ALL);
        end
        
        --Using capture buffer, render default HUD
        if(map3d.HUDMode == map3d.HUD_DEFAULT) then
            Graphics.overrideOverworldHUD(nil);
        elseif(map3d.HUDMode == map3d.HUD_BUBBLE) then
            Graphics.overrideOverworldHUD(drawBubbleHUD);
        end
        
        --Using capture buffer, render default pause menu
        if(map3d.DrawPauseMenu and mem(0x00B250E2, FIELD_BOOL)) then
            pauseDraw.texture = hudcapture;
            glDraw(pauseDraw);
        end
    end
    
    --Main draw function
    function map3d.onDraw()
        if(not ready) then
            init();
            if(map3d.CameraSettings.heightAdjust) then
                currentHeight = map3d.GetHeight(map3d.CameraSettings.target.x + 400, map3d.CameraSettings.target.y + 332);
            else
                currentHeight = 0;
            end
        end
        
        -- Clear the scene framebuffer.
        -- This will clear it's depth buffer.
        if map3d.clearScene then
            scene:clear(0)
        end
        
        --Ready capture for rendering of vanilla elements
        if(map3d.HUDMode > 0 or map3d.DrawPauseMenu) then
            if(hudcapture == nil) then
                hudcapture = Graphics.CaptureBuffer(800,600);
            end
            hudcapture:captureAt(0);
        end
        
        --Compute camera data for this frame
        CamData.tana = tan(map3d.CameraSettings.fov*halfrad);
        CamData.rectana = 1/CamData.tana;
        
        local targetheight = 0;
        if(map3d.CameraSettings.heightAdjust) then
            targetheight = map3d.GetHeight(map3d.CameraSettings.target.x + 400, map3d.CameraSettings.target.y + 332);
        end
        currentHeight = math.lerp(currentHeight, targetheight, 0.2);
        CamData.pos.x,CamData.pos.y,CamData.pos.z = map3d.CameraSettings.target.x+400, map3d.CameraSettings.height + currentHeight, map3d.CameraSettings.target.y+300+map3d.CameraSettings.distance;
        
        
        local rx,ry,rz = CamData.vr.x,CamData.vr.y,CamData.vr.z;
        --Compute camera forward position by rotating from 0,0,-1 around the camera's right vector. Equivalent to:
        --CamData.vf = (-vectr.forward3):rotate(-map3d.CameraSettings.angle, CamData.vr);
        do
            local x = -0.0174534*map3d.CameraSettings.angle; --deg2rad
            local cosx = mathcos(x);
            local sinx = mathsin(x);
            local cpx,cpy,cpz = cross(rx,ry,rz,0,0,-1);
            local dp = (1-cosx)*dot(rx,ry,rz,0,0,-1);
            
            
            CamData.vf.x,CamData.vf.y,CamData.vf.z = sinx*cpx + dp*CamData.vr.x, sinx*cpy + dp*CamData.vr.y, -cosx + sinx*cpz + dp*CamData.vr.z;
        
        end
        
        local fx,fy,fz = CamData.vf.x,CamData.vf.y,CamData.vf.z;
        
        CamData.viewdir[1],CamData.viewdir[2],CamData.viewdir[3] = fx, fy, fz;
        
        CamData.vu.x,CamData.vu.y,CamData.vu.z = cross(rx,ry,rz,fx,fy,fz);
        
        local ux,uy,uz = CamData.vu.x,CamData.vu.y,CamData.vu.z;
        
        local posx,posy,posz = CamData.pos.x,CamData.pos.y,CamData.pos.z;
        
        if(CamData.w2c == nil) then
            CamData.w2c = vectr.empty4;
        end
        
        local w2c = CamData.w2c;
        
        w2c[1],w2c[2],w2c[3],w2c[4]     = rx, ry, rz, 0;
        w2c[5],w2c[6],w2c[7],w2c[8]     = ux, uy, uz, 0;
        w2c[9],w2c[10],w2c[11],w2c[12]     = fx, fy, fz, 0;
        w2c[13],w2c[14],w2c[15],w2c[16] = -(rx*posx + ux*posy + fx*posz), -(ry*posx + uy*posy + fy*posz), -(rz*posx + uz*posy + fz*posz), 1;

        if(CamData.proj == nil) then
            CamData.proj = vectr.empty4;
        end
        
        local proj = CamData.proj;
        
        --TODO: Fix errors with orthographic projection on the inifinite plane (other things work fine)
        if(true) then--map3d.CameraSettings.renderMode == map3d.MODE_PERSPECTIVE) then
            proj[1],proj[2],proj[3],proj[4]     =     CamData.rectana,    0,                    0,        0;
            proj[5],proj[6],proj[7],proj[8]     =     0,                    -CamData.rectana,    0,        0;
            proj[9],proj[10],proj[11],proj[12]     =     0,                    0,                    1,        1/400;
            proj[13],proj[14],proj[15],proj[16] =     0,                    0,                    0,        0;
        else--if(map3d.CameraSettings.renderMode == map3d.MODE_ORTHOGRAPHIC) then
            proj[1],proj[2],proj[3],proj[4]     =     1,    0,    0,    0;
            proj[5],proj[6],proj[7],proj[8]     =     0,    -1,    0,    0;
            proj[9],proj[10],proj[11],proj[12]     =     0,    0,    1,    0;
            proj[13],proj[14],proj[15],proj[16] =     0,    0,    0,    1;
        end
        
        
        CamData.mat = nil; --For software projection - matrix needs recalculating
        
        
        --Get a vector pointing along the camera direction, along the ground
        local groundDir = vectr.v2(CamData.vf.x, CamData.vf.z):normalise();
        
        --Prepare shader for the skybox
        local bgShader = Shaders.textureSkybox;
        if(map3d.Skybox == nil) then
            bgShader = Shaders.flatSkybox;
        end
        
        --Disable fog if necessary
        local fogDensity;
        if(map3d.FogSettings.enabled) then
            fogDensity = map3d.FogSettings.density;
        else
            bgShader = nil;
            fogDensity = -1;
        end
        
        --Update lighting
        local ld = map3d.Light.direction:normalise();
        LightData.dir[1],LightData.dir[2],LightData.dir[3] = -ld.x, -ld.y, ld.z;
        if(map3d.Light.enabled) then
            LightData.use = 1;
        else
            LightData.use = 0;
        end
        if(map3d.Light.autoAmbient) then
            local t = 0.5;
            LightData.ambient.r = map3d.FogSettings.color[1]*t;
            LightData.ambient.g = map3d.FogSettings.color[2]*t;
            LightData.ambient.b = map3d.FogSettings.color[3]*t;
        else
            LightData.ambient = map3d.Light.ambient;
        end
        
        skyboxdat.camPos[1],skyboxdat.camPos[2],skyboxdat.camPos[3] = posx, map3d.FogSettings.skyHeight, posz;
        skyboxdat.groundDir[1],skyboxdat.groundDir[3] = groundDir.x, groundDir.y;
        
        
        skyboxDraw.texture = map3d.Skybox;
        skyboxDraw.color = map3d.SkyboxTint;
        skyboxDraw.shader = bgShader;
        
        skyboxDraw.uniforms.fogDensity = fogDensity*map3d.FogSettings.skyBlend;
        skyboxDraw.uniforms.fogColour = map3d.FogSettings.color;
        skyboxDraw.uniforms.camPos = skyboxdat.camPos;
        skyboxDraw.uniforms.groundDir = skyboxdat.groundDir;
        skyboxDraw.uniforms.w2c = w2c;
        skyboxDraw.uniforms.proj = proj;
        skyboxDraw.uniforms.fieldDistance = map3d.FogSettings.distance;
        skyboxDraw.uniforms.view = CamData.viewdir;
        skyboxDraw.uniforms.lightDir = LightData.dir;
        skyboxDraw.uniforms.lightCol = map3d.Light.color;
        skyboxDraw.uniforms.rectana = CamData.rectana;
        skyboxDraw.uniforms.frame = 0;
        
        --Draw skybox
        glDraw(skyboxDraw);
        
        --Get clipping bounds
        local frustum, aabb, planePos = getclippingfrustum();
        
        if(aabb ~= nil) then
            aabb.bl = mathfloor(((aabb.minx - 32)/map3d.BucketSize) - 0.5);
            aabb.br = mathfloor(((aabb.maxx + 32)/map3d.BucketSize) + 0.5);
            aabb.bt = mathfloor(((aabb.miny - 32)/map3d.BucketSize) - 0.5);
            aabb.bb = mathfloor(((aabb.maxy + 32)/map3d.BucketSize) + 0.5);
        end
        
        --Draw "infinite" background plane if necesary
        if(map3d.BGPlane.enabled and aabb ~= nil and planePos ~= nil) then
            drawInfiniPlane(map3d.BGPlane.size.y, map3d.BGPlane.size.x, planePos, map3d.BGPlane.tile, 32, fogDensity);
        end
        
        --Main drawing steps
        --Only draw if something is actually visible
        if(frustum ~= nil and aabb ~= nil) then
                    --Clip tiles
                    for id = 1,MAX_TILE do
                        local list = tileBuffers[id];
                        if(list ~= nil) then
                            clipVertsFromBuffer(list, false, frustum, aabb);
                        end
                    end
                    
                    --Clip paths
                    for id = 1,MAX_PATH do
                        local list = pathBuffers[id];
                        if(list ~= nil) then
                            clipVertsFromBuffer(list, true, frustum, aabb);
                        end
                    end
                    
                    --Clip levels and create the buffers for their "background paths"
                    local tempLevelUnderBuffers = {small = {verts = {}, tx = {}}, big = {verts = {}, tx = {}}};
                    
                    for id = 1,MAX_LEVEL do
                        local list = levelBuffers[id];
                        if(list ~= nil) then
                            clipVertsFromLevelBuffer(list, tempLevelUnderBuffers, true, frustum, aabb);
                        end
                    end
                    
                    --Clip scenery
                    for id = 1,MAX_SCENE do
                        local list = sceneBuffers[id];
                        if(list ~= nil) then
                            clipVertsFromSceneBuffer(list, frustum, aabb);
                        end
                    end
                    
                    tileDraw.shader = Shaders.basic; 
                    tileDraw.attributes = nil;
                    
                    --Construct shader parameters
                    shaderParams.fogDistance = map3d.FogSettings.distance;
                    shaderParams.fogDensity = fogDensity;
                    shaderParams.fogColour = map3d.FogSettings.color;
                    shaderParams.fogStart = map3d.FogSettings.start;
                    shaderParams.farclip = map3d.CameraSettings.farclip;
                    shaderParams.farFade = 1/map3d.CameraSettings.clipfade;
                    shaderParams.w2c = w2c;
                    shaderParams.proj = proj;
                    shaderParams.lightDir = LightData.dir;
                    shaderParams.lightCol = map3d.Light.color;
                    shaderParams.ambient = LightData.ambient;
                    shaderParams.useLighting = LightData.use;
                    shaderParams.view = CamData.viewdir;
                    shaderParams.mipLevels = map3d.MipMaps.levels;
                    if(map3d.MipMaps.enabled) then
                        shaderParams.useMip = 1;
                    else
                        shaderParams.useMip = 0;
                    end
                    shaderParams.rectana = CamData.rectana;
                    
                    shaderParams.heightmap = heightTexture;
                    if(shaderParams.heightmap ~= nil) then
                        shaderParams.heightmapPosition = {map3d.Heightmap.position.x, map3d.Heightmap.position.y};
                        shaderParams.heightmapSize = {shaderParams.heightmap.width, shaderParams.heightmap.height};
                        shaderParams.heightmapScale = map3d.Heightmap.scale;
                    else
                        shaderParams.heightmapPosition = _00;
                        shaderParams.heightmapSize = _11;
                        shaderParams.heightmapScale = 0;
                        shaderParams.heightmap = defaultHeightmap;
                    end
        
            
                    shaderParams.zoffset = 4;
                    shaderParams.yoffset = 0;
                    --Render tiles
                    for id = 1,MAX_TILE do
                        local v = tileBuffers[id];
                        if(v ~= nil) then
                            shaderParams.frame = v.vMax*map3d.GetAnimationFrame("tile", id);
                            shaderParams.normalMap = getNormal("tile",id);
                            shaderParams.emissiveMap = getEmissive("tile",id);
                            
                            doTileDraw(v.tempVerts, v.tempTx, getMipmap("tile",id));
                        end
                    end
                    
                    --Render paths
                    shaderParams.frame = 0;
                    shaderParams.zoffset = 2;
                    shaderParams.yoffset = 0.25;
                    for id = 1,MAX_PATH do
                        local v = pathBuffers[id];
                        if(v ~= nil) then
                            shaderParams.normalMap = getNormal("path",id);
                            shaderParams.emissiveMap = getEmissive("path",id);
                            doTileDraw(v.tempVerts, v.tempTx, getMipmap("path",id));
                        end
                    end
                    
                    --Generate billboard buffers
                    billboardBuffers = {indices = {}, objs = {}}
                    
                    --Compute billboard offset based on camera angle
                    local offset = 16*(mathcos(map3d.CameraSettings.angle * 0.0174533));
                    
                    --Construct level billboards
                    for k,v in ipairs(levelBillboardBuffer) do
                        local id = v:mem(0x30,FIELD_WORD);
                        local height = mem(mem(0xB2D3E0,FIELD_DWORD) + 2*(id), FIELD_WORD)/levelFrames[id];
                        local width = mem(mem(0xB2D3FC,FIELD_DWORD) + 2*(id), FIELD_WORD);
                        local x = v.x;
                        local y = v.y;
                        
                        if(cliptest(x + 16 - width*0.5, y + 32 - offset - height, x + 16 + width*0.5, y + 32, frustum, aabb) and (v.visible or v.isAlwaysVisible)) then
                            width = width * 0.5;
                            insertBillboard("level", x + 16, y + 32 - offset, id, width, height, map3d.Billboard.level.rotate[id]);
                            clipLevelUnderBuffer(v, tempLevelUnderBuffers);
                        end
                    end
                    
                    
                    --If necessary, render level "background paths"
                    if(#tempLevelUnderBuffers.small.verts > 3) then
                        shaderParams.normalMap = getNormal("level",0);
                        shaderParams.emissiveMap = getEmissive("level",0);
                        doTileDraw(tempLevelUnderBuffers.small.verts, tempLevelUnderBuffers.small.tx, getMipmap("level",0));
                    end
                    if(#tempLevelUnderBuffers.big.verts > 3) then
                        shaderParams.normalMap = getNormal("level",29);
                        shaderParams.emissiveMap = getEmissive("level",29);
                        doTileDraw(tempLevelUnderBuffers.big.verts, tempLevelUnderBuffers.big.tx, getMipmap("level",29));
                    end
                    
                    shaderParams.yoffset = 0.5;
                    --Render level tiles
                    for id = 1,MAX_LEVEL do
                        local v = levelBuffers[id];
                        if(v ~= nil) then
                            shaderParams.frame = v.vMax*map3d.GetAnimationFrame("level", id);
                            shaderParams.normalMap = getNormal("level",id);
                            shaderParams.emissiveMap = getEmissive("level",id);
                            doTileDraw(v.tempVerts, v.tempTx, getMipmap("level",id));
                        end
                    end
                    
                    --Render scenery
                    for id = 1,MAX_SCENE do
                        local v = sceneBuffers[id];
                        if(v ~= nil) then
                            shaderParams.frame = v.vMax*map3d.GetAnimationFrame("scene", id);
                            shaderParams.normalMap = getNormal("scene",id);
                            shaderParams.emissiveMap = getEmissive("scene",id);
                            doTileDraw(v.tempVerts, v.tempTx, getMipmap("scene",id));
                        end
                    end
                    
                    --Construct scene billboards
                    for k,v in ipairs(sceneBillboardBuffer) do
                        local id = v.obj.id;
                        local height = v.obj.height;
                        local width = v.obj.width;
                        local x = v.obj.x;
                        local y = v.obj.y;
                        
                        if(cliptest(x, y - offset - v.offset - height, x + width, y + v.offset + height, frustum, aabb))then
                            if(v.offset >= 16 or CheckSceneVisible(v.obj)) then
                                width = width * 0.5;
                                insertBillboard("scene", x + width, y + height - offset + v.offset, id, width, height, 0, v.offset, map3d.Billboard.scene.rotate[id]);
                            end
                        end
                    end
                    
                    if map3d.Billboard.adjustPlayerFeet then
                        --Compute billboard offset based on camera angle
                        offset = mathlerp(10,16, (mathcos(map3d.CameraSettings.angle * 0.0174533)));
                    end
                    
                    --Construct player billboard
                    do
                        local chara = player.character;
                        local charimg = Graphics.sprites.player[chara].img;
                        insertBillboard("player", world.playerX+16, world.playerY+32 - offset, chara, charimg.width*0.5, charimg.height*0.125, false);
                    end
                    
                    --Construct the billboard rotation matrix
                    shaderParams.rot[1],shaderParams.rot[2],shaderParams.rot[3] = CamData.vr.x, CamData.vu.x, CamData.vf.x;
                    shaderParams.rot[4],shaderParams.rot[5],shaderParams.rot[6] = CamData.vr.y, CamData.vu.y, CamData.vf.y;
                    shaderParams.rot[7],shaderParams.rot[8],shaderParams.rot[9] = CamData.vr.z, CamData.vu.z, CamData.vf.z;
                                        
                    attributes.zCoords = nil;
                    attributes.xCoords = nil;
                    
                    if(not map3d.MipMaps.billboards) then
                        shaderParams.useMip = 0;
                    end
                    
                    tileDraw.shader = Shaders.billboard;
                                        
                    shaderParams.yoffset = 0;
                    --Render the billboard objects
                    for _,listType in ipairs(billboardTypes) do
                        local list = billboardBuffers.objs[listType];
                        if(list ~= nil) then
                            for id = 1,billboardMaxTypes[listType] do
                                local v = list[id];
                                if(v ~= nil) then
                                    if(tileAnimArrays[listType] ~= nil) then
                                        shaderParams.frame = v.vMax * map3d.GetAnimationFrame(listType, id);
                                        shaderParams.frameHeight = v.vMax;
                                        shaderParams.zoffset = -2;
                                    elseif(listType == "player") then
                                        shaderParams.frame = v.vMax * world.playerWalkingFrame;
                                        shaderParams.frameHeight = v.vMax;
                                        shaderParams.zoffset = -12;
                                    end
                                    
                                    attributes.zCoords = v.y;
                                    attributes.xCoords = v.x;
                                    shaderParams.normalMap = getNormal(listType, id); 
                                    shaderParams.emissiveMap = getEmissive(listType,id);
                                    tileDraw.attributes = attributes;
                                    if(map3d.MipMaps.billboards) then
                                        doTileDraw(v.verts, v.tx, getMipmap(listType,id));
                                    else
                                        doTileDraw(v.verts, v.tx, Graphics.sprites[listType][id].img);
                                    end
                                end
                            end
                        end
                    end
        end
        --End of main drawing
        drawHUD();
        
    end
end

return map3d;
