local npcManager = require("npcManager")

local emptytalkbox = {}

local canHarm = {}

local npcID = NPC_ID
--local effectID = 778 --By default shares effectID with npcID. You can change it here.

--***************************************************************************************************
--                                                                                                  *
--              DEFAULTS AND NPC CONFIGURATION                                                      *
--                                                                                                  *
--***************************************************************************************************
local emptytalkboxSettings = {
    id = npcID,
    gfxheight = 32,
    gfxwidth = 32,
    width = 32,
    height = 32,
    gfxoffsetx = 0,
    frames = 4,
    framestyle = 1,
    speed = 1,
    --playerblocktop = true,
    --npcblocktop = true,
    --npcblock = true,
    --playerblock = true,
    
    jumphurt = false,
    
    nohurt = true,
    nogravity = true,
    noblockcollision = true,
    noiceball = true,
    noyoshi = true,
    
    maxLen = 22,
    notcointransformable = true,
    
    boss = false,
    hp = 3,

    --Custom
  dropdistance = 180, --Distance from the player that the emptytalkbox drops its object
  objectoffsetx = -2, --Anchor point for contained NPC. Top center of anchored NPC is here
  objectoffsety = -6,  
}

--Applies NPC settings
local configFile = npcManager.setNpcSettings(emptytalkboxSettings)

npcManager.registerDefines(npcID, {NPC.HITTABLE})

npcManager.registerHarmTypes(npcID,
    {
        HARM_TYPE_NPC,
        HARM_TYPE_PROJECTILE_USED,
        HARM_TYPE_LAVA,
        HARM_TYPE_HELD,
        HARM_TYPE_TAIL,
    }, 
    {
        [HARM_TYPE_JUMP]=effectID,
        [HARM_TYPE_NPC]=effectID,
        [HARM_TYPE_PROJECTILE_USED]=effectID,
        [HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
        [HARM_TYPE_HELD]=effectID,
        [HARM_TYPE_TAIL]=effectID,
    }
);

--Spawn contained NPC function
local function dropNPC(npcID, x, y, section, direction, friendly)
  local spawnedNPC
  if npcID > 0 then
    --Get the spawned NPC's graphics config
    local cfg = NPC.config[npcID];
    --Offset the spawn location appropriately
    x = x + (configFile.objectoffsetx * direction) + (configFile.width * 0.5) + (cfg.width * -0.5);
    y = y + configFile.objectoffsety + configFile.height;
    
    --Spawn it
    spawnedNPC = NPC.spawn(npcID, x, y, section)
    spawnedNPC.direction = direction;
        spawnedNPC.friendly = friendly;
        spawnedNPC.layerName = "Spawned NPCs"
  end
end

--Register events
function emptytalkbox.onInitAPI()
    npcManager.registerEvent(npcID, emptytalkbox, "onTickNPC")
    npcManager.registerEvent(npcID, emptytalkbox, "onDrawNPC")
    registerEvent(emptytalkbox, "onNPCKill")
end

--*********************************************
--                                            *
--                 emptytalkbox                   *
--                                            *
--*********************************************

function emptytalkbox.onTickNPC(v)
    --Don't act during time freeze
    if Defines.levelFreeze then return end
    
    local data = v.data

    --Initialize
    if not data.initialized then
        data.initialized = true
    data.dropped = false
    end
  
  --If the NPC has already been dropped, then prevent respawning with it
  if data.dropped then
    
  end    
    
    --If carrying an NPC, and spawn timer is over
  if (v.ai1 > 0 and v.speedY == 0) then
    for _, p in ipairs(Player.get()) do
      --Get the distance from each player 
      local dist = (p.x + p.width/2) - (v.x + v.width/2)
      
      dist = dist * v.direction --This causes positive values to be in front of emptytalkbox
      
      --If a player is within range, spawn the NPC and stop carrying it
      if (dist > 0 and dist <= configFile.dropdistance) then
        dropNPC(v.ai1, v.x, v.y, v:mem(0x146,FIELD_WORD), v.direction, v.friendly)
        v.ai1 = 0
        data.dropped = true
      end
    end
  end
  
end

function emptytalkbox.onDrawNPC(v)
  
  --Don't draw if despawned
  if v:mem(0x12A, FIELD_WORD) <= 0 then return end
  
  --If empty container, don't draw anything
  if v.ai1 <= 0 then return end
  
  --Draw the sprite of the contained NPC
  local id = v.ai1;
    if(id > 0) then
        local i = Graphics.sprites.npc[id].img;
        local cfg = NPC.config[id];
        local h = cfg.gfxheight;
        local w = cfg.gfxwidth;
        if(h == 0) then
            h = cfg.height;
        end
        if(w == 0) then
            w = cfg.width;
        end
    
    --If we're facing right, flip the texture
    if v.direction == 1 then
      w = -w;
    end
        
        local x,y = v.x + configFile.objectoffsetx * v.direction + v.width * 0.5, v.y + configFile.objectoffsety + v.height;
    
        x = x - w*0.5;
        y = y;
        
        Graphics.drawBox{
                            x = x, y = y, 
                            textureCoords = {0,0,1,0,1,h/i.height,0,h/i.height}, 
                            width = w, height = h, 
                            texture = i, 
                            priority=-45, sceneCoords=true
                        }
    end
  
end

function emptytalkbox.onNPCKill(eventObj,npc,killReason) 
    if npc.id == npcID then
    --If the emptytalkbox dies, spawn its NPC
    dropNPC(npc.ai1, npc.x, npc.y, npc:mem(0x146,FIELD_WORD), npc.direction, npc.friendly)
    end
end

return emptytalkbox