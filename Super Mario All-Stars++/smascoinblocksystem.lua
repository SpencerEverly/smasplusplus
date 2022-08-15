local smascoinblocksystem = {}

smascoinblocksystem.countdownmarker = 50 --Set this to any number that you want it to subtract coins from.

local blockcountdown = 0
local activateblockcountdown = false
local subtractblockcontentid = false

local blocklistwithcoins = {}

function smascoinblocksystem.onInitAPI()
    registerEvent(smascoinblocksystem,"onPostBlockHit")
    registerEvent(smascoinblocksystem,"onTick")
end

function smascoinblocksystem.onPostBlockHit(block, fromUpper, playerornil)
    if not SaveData.disableX2char then
        if block.contentID >= 2 and block.contentID <= 99 and block.isValid and not activateblockcountdown then
            activateblockcountdown = true
            table.insert(blocklistwithcoins, block)
        elseif block.contentID <= 1 or block.contentID == 1000 or not block.isValid then
            activateblockcountdown = false
            blockcountdown = 0
            subtractblockcontentid = false
        end
    end
end

function smascoinblocksystem.onTick()
    if activateblockcountdown then
        blockcountdown = blockcountdown + 1
        if blockcountdown % smascoinblocksystem.countdownmarker == smascoinblocksystem.countdownmarker - 1 then
            subtractblockcontentid = true
        elseif blockcountdown % smascoinblocksystem.countdownmarker == 0 then
            subtractblockcontentid = false
        end
        if subtractblockcontentid then
            for i=#blocklistwithcoins, 1, -1 do
                local v = blocklistwithcoins[i]
                if v.isValid and v.contentID > 1 and v.contentID < 100 then
                    v.contentID = v.contentID - 1
                else
                    table.remove(blocklistwithcoins, i)
                end
            end
        end
    end
    if not activateblockcountdown then
        subtractblockcontentid = false
    end
end

return smascoinblocksystem