--[[

    kindHurtBlock.lua
    by MrDoubleA

]]

local blockutils = require("blocks/blockutils")

local kindHurtBlock = {}


kindHurtBlock.lavaReduceSize = 12
kindHurtBlock.normalReduceSize = 6


kindHurtBlock.debug = false


-- Table of blocks to reduce the size of and in which directions.
kindHurtBlock.directions = {
    --ID     top bottom left right
    --[404]  = {0,  0,  0,  0 },

    [371]  = {1,  0,  0,  0 }, -- SMB lava top

    [511]  = {1,  0,  0,  0 }, -- SMB2 spikes

    [30]   = {1,  0,  0,  0 }, -- SMB3 lava top
    [1268] = {0,  1,  0,  0 }, -- SMB3 lava bottom
    [109]  = {1,  1,  1,  1 }, -- SMB3 muncher
    [598]  = {1,  1,  1,  1 }, -- SMB3 jelectro
    [110]  = {1,  0,  0,  0 }, -- SMB3 spikes top
    [267]  = {0,  0,  0,  1 }, -- SMB3 spikes right
    [268]  = {0,  1,  0,  0 }, -- SMB3 spikes bottom
    [269]  = {0,  0,  1,  0 }, -- SMB3 spikes left

    [408]  = {1,  0,  0,  0 }, -- SMW pencil top
    [407]  = {0,  1,  0,  0 }, -- SMW pencil bottom
    [404]  = {1,  0,  0,  0 }, -- SMW castle lava top
    [430]  = {1,  0,  0,  0 }, -- SMW spike top
    [428]  = {0,  0,  0,  1 }, -- SMW spike right
    [431]  = {0,  1,  0,  0 }, -- SMW spike bottom
    [429]  = {0,  0,  1,  0 }, -- SMW spike left
    [741]  = {1,  0,  0,  0 }, -- semisolid spike
    [673]  = {1,  1,  1,  1 }, -- insta-kill block

    [466]  = {1,  0,  1,  0 }, -- SMW lava top left
    [459]  = {1,  0,  0,  0 }, -- SMW lava top
    [460]  = {1,  0,  0,  1 }, -- SMW lava top right
    [463]  = {0,  0,  1,  0 }, -- SMW lava left
    [461]  = {0,  0,  0,  1 }, -- SMW lava right
    [465]  = {0,  1,  1,  0 }, -- SMW lava bottom left
    [462]  = {0,  1,  0,  0 }, -- SMW lava bottom
    [464]  = {0,  1,  0,  1 }, -- SMW lava bottom right
    [471]  = {1,  0,  1,  0 }, -- SMW lava corner top left
    [468]  = {1,  0,  0,  1 }, -- SMW lava corner top right
    [470]  = {0,  1,  1,  0 }, -- SMW lava corner bottom left
    [469]  = {0,  1,  0,  1 }, -- SMW lava corner bottom right
    [480]  = {1,  -1, 0,  0 }, -- SMW lava slope top left
    [482]  = {1,  -1, 0,  0 }, -- SMW lava slope top right
    [486]  = {-1, 1,  0,  0 }, -- SMW lava slope bottom left
    [485]  = {-1, 1,  0,  0 }, -- SMW lava slope bottom right
    [481]  = {1,  0,  0,  0 }, -- SMW lava slope top left corner
    [483]  = {1,  0,  0,  0 }, -- SMW lava slope top right corner
    [487]  = {0,  1,  0,  0 }, -- SMW lava slope bottom left corner
    [484]  = {0,  1,  0,  0 }, -- SMW lava slope bottom right corner
    [472]  = {1,  -1, 0,  0 }, -- SMW lava steep slope top left
    [474]  = {1,  -1, 0,  0 }, -- SMW lava steep slope top right
    [476]  = {-1, 1,  0,  0 }, -- SMW lava steep slope bottom left
    [479]  = {-1, 1,  0,  0 }, -- SMW lava steep slope bottom right
    [473]  = {1,  0,  0,  0 }, -- SMW lava steep slope top left corner
    [475]  = {1,  0,  0,  0 }, -- SMW lava steep slope top right corner
    [477]  = {0,  1,  0,  0 }, -- SMW lava steep slope bottom left corner
    [478]  = {0,  1,  0,  0 }, -- SMW lava steep slope bottom right corner
}


kindHurtBlock.affectedBlocks = {}


local function getReduceSides(v,directions)
    local reduceSize

    if Block.LAVA_MAP[v.id] then
        reduceSize = kindHurtBlock.lavaReduceSize
    else
        reduceSize = kindHurtBlock.normalReduceSize
    end

    --     top                      bottom                   left                     right
    return directions[1]*reduceSize,directions[2]*reduceSize,directions[3]*reduceSize,directions[4]*reduceSize
end


local function checkBlocks(changeSize)
    kindHurtBlock.affectedBlocks = {}

    for _,v in Block.iterate() do
        local directions = kindHurtBlock.directions[v.id]

        if directions ~= nil then
            if changeSize then
                local top,bottom,left,right = getReduceSides(v,directions)

                v.x = v.x + left
                v.y = v.y + top
                v.width = v.width - left - right
                v.height = v.height - top - bottom
            end

            table.insert(kindHurtBlock.affectedBlocks,v)
        end
    end
end


function kindHurtBlock.onStart()
    checkBlocks(true)
end

function kindHurtBlock.onReset(fromRespawn)
    checkBlocks(false)
end


local hiddenBlocks = {}
local hiddenBlockMap = {}


local function getBlockPriority(v)
    if Block.LAVA_MAP[v.id] then
        return -10
    elseif Block.SIZEABLE_MAP[v.id] then
        return -90
    else
        return -65
    end
end

local function drawBlock(v,directions,cx1,cy1,cx2,cy2)
    local top,bottom,left,right = getReduceSides(v,directions)

    -- culling stuff
    local x = v.x - left
    if x > cx2 then
        return
    end

    local y = v.y - top
    if y > cy2 then
        return
    end

    local width = v.width + left + right
    if x+width < cx1 then
        return
    end

    local height = v.height + top + bottom
    if y+height < cy1 then
        return
    end

    -- Invisiblity check + hide if necessary
    if not hiddenBlockMap[v] then
        if v.isHidden or v:mem(0x5A,FIELD_BOOL) then
            return
        end

        v.isHidden = true

        table.insert(hiddenBlocks,v)
        hiddenBlockMap[v] = true
    end

    -- Drawing time!
    local image = Graphics.sprites.block[v.id].img
    local config = Block.config[v.id]

    if image == nil or config == nil then
        return
    end

    local priority = getBlockPriority(v) + math.clamp((v.x + 400000)/600000)*0.05

    local sourceY = blockutils.getBlockFrame(v.id)*config.height

    Graphics.drawImageToSceneWP(image,x,y,0,sourceY,width,height,priority)

    if kindHurtBlock.debug then
        Graphics.drawBox{color = Color.blue.. 0.5,x = v.x,y = v.y,width = v.width,height = v.height,priority = -1,sceneCoords = true}
    end
end


function kindHurtBlock.onCameraDraw(camIdx)
    local c = Camera(camIdx)

    local cx1 = c.x
    local cy1 = c.y
    local cx2 = cx1 + c.width
    local cy2 = cy1 + c.height

    local i = 1

    while (true) do
        local v = kindHurtBlock.affectedBlocks[i]
        if v == nil then
            break
        end

        local remove = false

        if v.isValid then
            local directions = kindHurtBlock.directions[v.id]

            if directions ~= nil then
                drawBlock(v,directions,cx1,cy1,cx2,cy2)
            else
                remove = true
            end
        else
            remove = true
        end

        if remove then
            table.remove(kindHurtBlock.affectedBlocks,i)
        else
            i = i + 1
        end
    end
end


function kindHurtBlock.onDrawEnd()
    -- Undo hidden blocks now that drawing's done
    for i = 1,#hiddenBlocks do
        local v = hiddenBlocks[i]

        if v.isValid then
            v.isHidden = false
        end

        hiddenBlockMap[v] = nil
        hiddenBlocks[i] = nil
    end
end


function kindHurtBlock.onInitAPI()
    registerEvent(kindHurtBlock,"onStart")
    registerEvent(kindHurtBlock,"onReset")
    registerEvent(kindHurtBlock,"onCameraDraw")
    registerEvent(kindHurtBlock,"onDrawEnd")
end


return kindHurtBlock