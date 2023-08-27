local malcmusic = {}

local playerManager = require("playerManager")
local rng = require("base/rng")

local hourChanger = {}

local day = os.date("%d")
local month = os.date("%m")
local exacttime = os.date("%X")
local minute = os.date("%M")
local second = os.date("%S")

local character = player.character;
local costumes = playerManager.getCostumes(player.character)
local currentCostume = player:getCostume()
local costumes

local rain
local snow
local sunny

local rainoutsidesfx = SFX.open("_OST/_Sound Effects/rain_outside.ogg")
local raininsidesfx = SFX.open("_OST/_Sound Effects/rain_inside.ogg")

local prevSection = nil
local rainState = false
local snowState = false
local prevState = false
local prevRainState = false
local prevSnowState = false
local prevPreviousState = false
--local insideMap = table.map{1, 2, 3, 4, 7, 8}
local currentSfx = nil

malcmusic.holiday = false

local sec0 = Section(0)
local sec6 = Section(6)
local sec10 = Section(10)

local ready = false

function malcmusic.onInitAPI()
    registerEvent(malcmusic, "onStart")
    registerEvent(malcmusic, "onTick")
    registerEvent(malcmusic, "onEvent")
    registerEvent(malcmusic, "onDraw")
    registerEvent(malcmusic, "onExit")
    ready = true
end

malcmusic.outsideSections = {
    [1] = 0,
    [2] = 6,
    [3] = 10,
}

malcmusic.hubMusicList = {
    ["accf"] = {
        ["00"] = {
            snow = "_OST/Animal Crossing - City Folk/00-00_12_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/00-00_12_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/00-00_12_am.ogg",
        },
        ["01"] = {
            snow = "_OST/Animal Crossing - City Folk/01-00_1_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/01-00_1_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/01-00_1_am.ogg",
        },
        ["02"] = {
            snow = "_OST/Animal Crossing - City Folk/02-00_2_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/02-00_2_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/02-00_2_am.ogg",
        },
        ["03"] = {
            snow = "_OST/Animal Crossing - City Folk/03-00_3_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/03-00_3_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/03-00_3_am.ogg",
        },
        ["04"] = {
            snow = "_OST/Animal Crossing - City Folk/04-00_4_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/04-00_4_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/04-00_4_am.ogg",
        },
        ["05"] = {
            snow = "_OST/Animal Crossing - City Folk/05-00_5_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/05-00_5_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/05-00_5_am.ogg",
        },
        ["06"] = {
            snow = "_OST/Animal Crossing - City Folk/06-00_6_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/06-00_6_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/06-00_6_am.ogg",
        },
        ["07"] = {
            snow = "_OST/Animal Crossing - City Folk/07-00_7_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/07-00_7_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/07-00_7_am.ogg",
        },
        ["08"] = {
            snow = "_OST/Animal Crossing - City Folk/08-00_8_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/08-00_8_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/08-00_8_am.ogg",
        },
        ["09"] = {
            snow = "_OST/Animal Crossing - City Folk/09-00_9_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/09-00_9_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/09-00_9_am.ogg",
        },
        ["10"] = {
            snow = "_OST/Animal Crossing - City Folk/10-00_10_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/10-00_10_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/10-00_10_am.ogg",
        },
        ["11"] = {
            snow = "_OST/Animal Crossing - City Folk/11-00_11_am_snow.ogg", rain = "_OST/Animal Crossing - City Folk/11-00_11_am_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/11-00_11_am.ogg",
        },
        ["12"] = {
            snow = "_OST/Animal Crossing - City Folk/12-00_12_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/12-00_12_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/12-00_12_pm.ogg",
        },
        ["13"] = {
            snow = "_OST/Animal Crossing - City Folk/13-00_1_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/13-00_1_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/13-00_1_pm.ogg",
        },
        ["14"] = {
            snow = "_OST/Animal Crossing - City Folk/14-00_2_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/14-00_2_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/14-00_2_pm.ogg",
        },
        ["15"] = {
            snow = "_OST/Animal Crossing - City Folk/15-00_3_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/15-00_3_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/15-00_3_pm.ogg",
        },
        ["16"] = {
            snow = "_OST/Animal Crossing - City Folk/16-00_4_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/16-00_4_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/16-00_4_pm.ogg",
        },
        ["17"] = {
            snow = "_OST/Animal Crossing - City Folk/17-00_5_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/17-00_5_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/17-00_5_pm.ogg",
        },
        ["18"] = {
            snow = "_OST/Animal Crossing - City Folk/18-00_6_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/18-00_6_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/18-00_6_pm.ogg",
        },
        ["19"] = {
            snow = "_OST/Animal Crossing - City Folk/19-00_7_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/19-00_7_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/19-00_7_pm.ogg",
        },
        ["20"] = {
            snow = "_OST/Animal Crossing - City Folk/20-00_8_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/20-00_8_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/20-00_8_pm.ogg",
        },
        ["21"] = {
            snow = "_OST/Animal Crossing - City Folk/21-00_9_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/21-00_9_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/21-00_9_pm.ogg",
        },
        ["22"] = {
            snow = "_OST/Animal Crossing - City Folk/22-00_10_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/22-00_10_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/22-00_10_pm.ogg",
        },
        ["23"] = {
            snow = "_OST/Animal Crossing - City Folk/23-00_11_pm_snow.ogg", rain = "_OST/Animal Crossing - City Folk/23-00_11_pm_rain.ogg", sunny = "_OST/Animal Crossing - City Folk/23-00_11_pm.ogg",
        },
    },
    ["acnl"] = {
        ["00"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg",
        },
        ["01"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg",
        },
        ["02"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg",
        },
        ["03"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg",
        },
        ["04"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg",
        },
        ["05"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg",
        },
        ["06"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg",
        },
        ["07"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg",
        },
        ["08"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg",
        },
        ["09"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg",
        },
        ["10"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg",
        },
        ["11"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg",
        },
        ["12"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg",
        },
        ["13"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg",
        },
        ["14"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg",
        },
        ["15"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg",
        },
        ["16"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg",
        },
        ["17"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg",
        },
        ["18"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg",
        },
        ["19"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg",
        },
        ["20"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg",
        },
        ["21"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg",
        },
        ["22"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg",
        },
        ["23"] = {
            snow = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SNOWY.ogg", rain = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_RAINY.ogg", sunny = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg",
        },
    },
    ["acnh"] = {
        ["00"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Sunny.ogg",
        },
        ["01"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Sunny.ogg",
        },
        ["02"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Sunny.ogg",
        },
        ["03"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Sunny.ogg",
        },
        ["04"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Sunny.ogg",
        },
        ["05"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Sunny.ogg",
        },
        ["06"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Sunny.ogg",
        },
        ["07"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Sunny.ogg",
        },
        ["08"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Sunny.ogg",
        },
        ["09"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Sunny.ogg",
        },
        ["10"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Sunny.ogg",
        },
        ["11"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Sunny.ogg",
        },
        ["12"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Sunny.ogg",
        },
        ["13"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Sunny.ogg",
        },
        ["14"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Sunny.ogg",
        },
        ["15"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Sunny.ogg",
        },
        ["16"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Sunny.ogg",
        },
        ["17"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Sunny.ogg",
        },
        ["18"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Sunny.ogg",
        },
        ["19"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Sunny.ogg",
        },
        ["20"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Sunny.ogg",
        },
        ["21"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Sunny.ogg",
        },
        ["22"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Sunny.ogg",
        },
        ["23"] = {
            snow = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Snowy.ogg", rain = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Rainy.ogg", sunny = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Sunny.ogg",
        },
    },
}

local animalcrossingrng = {"accf","acnl","acnh"}
local acmusrng = rng.randomEntry(animalcrossingrng)

local rainSections = {[0] = true,[6] = true,[9] = true,[10] = true,[11] = true}
local insideSections = {[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,[7] = true,[8] = true,[12] = true,[13] = true,[14] = true}

function rainrefresh()
    rainState = false
    prevState = false
    Routine.wait(0.1, true)
    rainactivated = true
end

function malcmusic.doRainWeather()
    Routine.run(rainrefresh)
    if rainactivated then
        if rainSections[player.section] then
            rainState = true
            prevState = false
        elseif insideSections[player.section] then
            rainState = false
            prevState = true
        end
        if (rainState ~= prevRainState) or (prevSection ~= newSection) then
            if rainState then
                Section(player.section).effects.weather = WEATHER_RAIN
                currentSfxOutRain = SFX.play(rainoutsidesfx, 1, 0)
                
                if currentSfxInRain then
                    currentSfxInRain:fadeout(50)
                    currentSfxInRain = nil
                end
            elseif prevState then
                currentSfxInRain = SFX.play(raininsidesfx, 1, 0)
                
                if currentSfxOutRain then
                    currentSfxOutRain:fadeout(50)
                    currentSfxOutRain = nil
                end
            end
            prevSection = player.section
            newSection = Section.getIdxFromCoords(player.x, player.y)
            prevRainState = rainState
            prevPreviousState = prevState
            prevInsideState = insideState
        end
    end
    if not rainactivated then
        if currentSfxInRain then
            currentSfxInRain:fadeout(50)
            currentSfxInRain = nil
        end
        if currentSfxOutRain then
            currentSfxOutRain:fadeout(50)
            currentSfxOutRain = nil
        end
    end
end

function malcmusic.doSnowWeather()
    if player.section == 0 then
        snowState = true
        prevState = false
    elseif player.section == 1 then
        snowState = false
        prevState = true
    elseif player.section == 2 then
        snowState = false
        prevState = true
    elseif player.section == 3 then
        snowState = false
        prevState = true
    elseif player.section == 4 then
        snowState = false
        prevState = true
    elseif player.section == 6 then
        snowState = true
        prevState = false
    elseif player.section == 7 then
        snowState = false
        prevState = true
    elseif player.section == 8 then
        snowState = false
        prevState = true
    elseif player.section == 9 then
        snowState = true
        prevState = false
    elseif player.section == 10 then
        snowState = true
        prevState = false
    elseif player.section == 11 then
        snowState = true
        prevState = false
    elseif player.section == 12 then
        snowState = false
        prevState = true
    elseif player.section == 13 then
        snowState = false
        prevState = true
    elseif player.section == 14 then
        snowState = false
        prevState = true
    end
    if (snowState ~= prevSnowState) or (prevSection ~= player.section) then
        if snowState then
            Section(player.section).effects.weather = WEATHER_SNOW
        elseif prevState then
            --Nothing
        end
        prevSection = player.section
        prevSnowState = snowState
        prevPreviousState = prevState
    end
end

function malcmusic.onStart()
    
end

function malcmusic.onTick()
    for i = 0,20 do
        local SectionAll = Section(i)
        
        if Time.hour() ~= hourChanger[Time.hour()] then
            Sound.playSFX("hour-change.ogg")
            hourChanger[Time.hour()] = Time.hour()
            if SaveData.dateplayedweather == "snow" then
                if not malcmusic.holiday then
                    for k,v in ipairs(malcmusic.outsideSections) do
                        if not smasBooleans.musicMuted or not smasBooleans.musicMutedTemporary then
                            Section(v).music = malcmusic.hubMusicList[acmusrng][os.date("%H")].snow
                        end
                    end
                end
            elseif SaveData.dateplayedweather == "rain" then
                if not malcmusic.holiday then
                    for k,v in ipairs(malcmusic.outsideSections) do
                        if not smasBooleans.musicMuted or not smasBooleans.musicMutedTemporary then
                            Section(v).music = malcmusic.hubMusicList[acmusrng][os.date("%H")].rain
                        end
                    end
                end
            elseif SaveData.dateplayedweather == "sunny" then
                if not malcmusic.holiday then
                    for k,v in ipairs(malcmusic.outsideSections) do
                        if not smasBooleans.musicMuted or not smasBooleans.musicMutedTemporary then
                            Section(v).music = malcmusic.hubMusicList[acmusrng][os.date("%H")].sunny
                        end
                    end
                end
            end
        end
        
        
        if Time.month() == 12 and Time.day() == 25 then --Christmas
            if malcmusic.holiday and not (SaveData.dateplayedweather == "snow") then
                malcmusic.doSnowWeather()
            end
        end
        
        if SaveData.dateplayedweather == "snow" then
            malcmusic.doSnowWeather()
            
        end
        if SaveData.dateplayedweather == "rain" then
            malcmusic.doRainWeather()
        end
    end
end

function malcmusic.onExit()
    if currentSfxInRain then
        currentSfxInRain:fadeout(50)
        currentSfxInRain = nil
    end
    if currentSfxOutRain then
        currentSfxOutRain:fadeout(50)
        currentSfxOutRain = nil
    end
end

return malcmusic