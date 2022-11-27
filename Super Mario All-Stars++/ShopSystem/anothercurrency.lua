-- Currency system that streamlines currency creation and tracking.
-- By Enjl, October 2019

-- How it works:
-- When a registered NPC is collected, the respective currency counter goes up by the specified value.

local npcManager = require("npcManager")

local ac = {}
local currencies = {}

-- Money saves by default into a subtable in SaveData, so that it can be carried around between levels.
if SaveData.totalCoins == nil then
    SaveData.totalCoins = 0
end
local sd = SaveData.totalCoins
local atLeastOneHijack = false

-- Registration instructions below the local functions.

local function registerCoinInternal(counter, id, value)
    counter._cointypes[id] = value
end

local function registerLimitInternal(counter, limit, func)
    if func == nil or type(func) ~= "function" then
        error("Second argument to registerLimit must be a function reference.")
    end
    if limit <= 0 then
        error("Limit must be greater than 0.")
    end
    counter._limit = {value = limit, func = func}
end

local function checkLimit(counter)
    if counter._limit == nil then return end
    while counter._value > counter._limit.value do
        local diff = (counter._value - counter._limit.value)
        counter._value = counter._value - diff 
        counter._limit.func(diff)
    end
end

local function addMoneyInternal(counter, value)
    counter._value = math.max(counter._value + value, 0)
    checkLimit(counter)
    SaveData.totalCoins = counter._value
end

local function setMoneyInternal(counter, value)
    counter._value = math.max(value, 0)
    checkLimit(counter)
    SaveData.totalCoins = counter._value
end

local function getMoneyInternal(counter)
    return counter._value
end

local function compareMoneyInternal(counter, value)
    return counter._value >= value, counter._value - value
end

local function drawInternal(counter)
    Text.printWP(counter.name .. " " .. tostring(counter._value), 4, 16, -4 + 20 * counter._id, 5)
end

-- Registers a new currency and returns it. Save a reference of it to keep track of it. Name is for savedata.
function ac.registerCurrency(name, hijackDefaultCounter)
    -- In the currency table you get back, all the functions accessible for a currency are saved.
    local currency = {
        registerCoin = registerCoinInternal, -- Registers a new NPC as a "coin". myCurrency:registerCoin(id, value)
        registerLimit = registerLimitInternal, -- Registers the limit of the currency. By default, there is no limit. When a limit is reached, the coin counter is emptied and a function is executed. myCurrency:registerLimit(value, functionToExecute)
        addMoney = addMoneyInternal, -- Adds value to the coin counter manually. myCurrency:addMoney(value) (value can be negative to subtract)
        setMoney = setMoneyInternal, -- Sets the absolute value of the coin counter. myCurrency:setMoney(value)
        getMoney = getMoneyInternal, -- Gets the absolute value of the coin counter. Can be used for drawing, for example. myCurrency:getMoney()
        compareMoney = compareMoneyInternal, -- Compares coin counter value to some other value. Useful for shops. myCurrency:compareMoney(valueToCompareTo). Returns whether counter is greater or equal to comparison value, and the difference as 2nd arg.
        draw = drawInternal, -- Draws the coin counter. The function can be overridden and is not called internally. Default implementation is for debug purposes. myCurrency:draw()

        hijackDefaultCounter = hijackDefaultCounter, -- If set to true, this counter will derive its value from the default coin counter and won't register the deaths of default coin types. If at least one currency is registered to hijack the default counter, the default counter is automatically re-routed into this counter and will be permanently empty.
        _cointypes = {},
        _limit = nil,
        _value = 0,
        name = name,
        _id = #currencies + 1
    }
    if SaveData.totalCoins then
        currency._value = SaveData.totalCoins
    end
    atLeastOneHijack = atLeastOneHijack or currency.hijackDefaultCounter
    table.insert(currencies, currency)
    return currency
end

-- Below is just code.

function ac.onInitAPI()
    registerEvent(ac, "onTickEnd")
    registerEvent(ac, "onNPCKill")
end

local defaultCoinIDMap = {
    [10] = true,
    [33] = true,
    [88] = true,
    [102] = true,
    [138] = true,
    [152] = true,
    [251] = true,
    [252] = true,
    [253] = true,
    [258] = true,
    [274] = true,
    [411] = true,
}

function ac.onTickEnd()
    if atLeastOneHijack then
        local hijackedValue = mem(0x00B2C5A8, FIELD_WORD)
        if hijackedValue > 101 then
            mem(0x00B2C5A8, FIELD_WORD, 0)
            for k,v in ipairs(currencies) do
                if v.hijackDefaultCounter then
                    v:addMoney(SaveData.totalCoins)
                end
            end
        end
    end
end

function ac.onNPCKill(killObj, v, killReason)
    if killReason ~= 9 then return end
    if not npcManager.collected(v, killReason) then return end

    for k,c in ipairs(currencies) do
        if c._cointypes[v.id] then
            if not (c.hijackDefaultCounter and defaultCoinIDMap[v.id]) then
                c:addMoney(c._cointypes[v.id])
            end
        end
    end
end


return ac