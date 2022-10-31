local malcmusic = {}

local playerManager = require("playerManager")
local rng = require("base/rng")

local hour = os.date("%H")
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

function malcmusic.onStart()
    weatherControlDay = SaveData.dateplayedweather
    --Daily weather, no rng intended anymore unless the day is tomorrow
    for i = 0,20 do
        local SectionAll = Section(i)
        if Time.month() == 3 and Time.day() == 17 then --St. Patrick's Day
            malcmusic.holiday = true
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Me and Larry City/St. Patrick's Day.ogg"
                triggerEvent("StPatricksDay")
            end
        end
        
        
        if Time.month() == 4 and Time.day() == 4 then --Spencer Everly Day
            malcmusic.holiday = true
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg"
                triggerEvent("SEDay")
            end
        end
        
        
        if Time.month() == SaveData.eastermonth and Time.day() == SaveData.easterday then --Easter Sunday
            malcmusic.holiday = true
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_EVT_EASTER (channels 0 and 1).ogg"
                triggerEvent("Easter")
                for i = 15,19 do
                    if Time.hour() == i then
                        triggerEvent("EasterHunt")
                    end
                end
            end
        end
        
        
        if Time.month() == 4 and Time.day() == 20 then --Weed Day
            malcmusic.holiday = true
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/All Stars Secrets/smok wed everyda.ogg"
                triggerEvent("Weed")
            end
        end
        
        
        if Time.month() == 9 and Time.day() == Time.weekendOrder("Monday", 9)[1] then --Labor Day
            malcmusic.holiday = true
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_EVT_GANTAN.ogg"
                triggerEvent("LaborDay")
            end
        end
        
        
        if Time.month() == 10  and Time.day() == 31 then --Halloween
            malcmusic.holiday = true
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_EVT_GANTAN.ogg"
                triggerEvent("Halloween")
            end
        end
        
        
        if Time.month() == 12 and Time.day() == 25 then --Christmas Day
            malcmusic.holiday = true
            if malcmusic.holiday == true then
                if player.section == 0 then
                    Section(player.section).effects.weather = WEATHER_SNOW
                end
                if player.section == 6 then
                    Section(player.section).effects.weather = WEATHER_SNOW
                end
                if player.section == 10 then
                    Section(player.section).effects.weather = WEATHER_SNOW
                end
                SectionAll.musicPath = "_OST/GoAnimate/Old Songs/We Wish You a Merry Christmas (Jazz Classic).mp3"
                triggerEvent("Christmas")
            end
        end
    end
end

function malcmusic.onTick()
    for i = 0,20 do
        local SectionAll = Section(i)
        if Time.month() == 3 and Time.day() == 17 then --St. Patrick's Day
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Me and Larry City/St. Patrick's Day.ogg"
            end
        end
        
        
        if Time.month() == 4 and Time.day() == 4 then --Spencer Everly Day (Foundation of my YouTube channel)
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg"
            end
        end
        
        
        if Time.month() == SaveData.eastermonth and Time.day() == SaveData.easterday then --Easter Sunday
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_EVT_EASTER (channels 0 and 1).ogg"
            end
        end
        
        
        if Time.month() == 4 and Time.day() == 20 then --Weed day (420)
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/All Stars Secrets/smok wed everyda.ogg"
            end
        end
        
        
        if Time.month() == 9 and Time.day() == Time.weekendOrder("Monday", 9)[1] then --Labor Day
            if malcmusic.holiday == true then
                SectionAll.musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_EVT_GANTAN.ogg"
            end
        end
        
        
        if Time.month() == 12 and Time.day() == 25 then --Christmas
            if malcmusic.holiday == true then
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
                elseif player.section == 3 then
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
                SectionAll.musicPath = "_OST/GoAnimate/Old Songs/We Wish You a Merry Christmas (Jazz Classic).mp3"
            end
        end
        if SaveData.dateplayedweather == "snow" then
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
            elseif player.section == 3 then
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
            if malcmusic.holiday == false then
                if acmusrng == "accf" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am_snow.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am_snow.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am_snow.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am_snow.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am_snow.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am_snow.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am_snow.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am_snow.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am_snow.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am_snow.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am_snow.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am_snow.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm_snow.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm_snow.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm_snow.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm_snow.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm_snow.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm_snow.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm_snow.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm_snow.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm_snow.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm_snow.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm_snow.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm_snow.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm_snow.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm_snow.ogg"
                    end
                end
                if acmusrng == "acnl" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SNOWY.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SNOWY.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SNOWY.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SNOWY.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SNOWY.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SNOWY.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SNOWY.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SNOWY.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SNOWY.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SNOWY.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SNOWY.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SNOWY.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SNOWY.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SNOWY.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SNOWY.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SNOWY.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SNOWY.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SNOWY.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SNOWY.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SNOWY.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SNOWY.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SNOWY.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SNOWY.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SNOWY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SNOWY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SNOWY.ogg"
                    end
                end
                if acmusrng == "acnh" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Snowy.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Snowy.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Snowy.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Snowy.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Snowy.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Snowy.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Snowy.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Snowy.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Snowy.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Snowy.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Snowy.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Snowy.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Snowy.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Snowy.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Snowy.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Snowy.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Snowy.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Snowy.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Snowy.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Snowy.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Snowy.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Snowy.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Snowy.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Snowy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Snowy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Snowy.ogg"
                    end
                end
            end
        end
        if SaveData.dateplayedweather == "rain" then
            Routine.run(rainrefresh)
            if rainactivated == true then
                local rainSections = {[0] = true,[6] = true,[9] = true,[10] = true,[11] = true}
                local insideSections = {[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,[7] = true,[8] = true,[12] = true,[13] = true,[14] = true}
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
            if rainactivated == false then
                if currentSfxInRain then
                    currentSfxInRain:fadeout(50)
                    currentSfxInRain = nil
                end
                if currentSfxOutRain then
                    currentSfxOutRain:fadeout(50)
                    currentSfxOutRain = nil
                end
            end
            if malcmusic.holiday == false then
                if acmusrng == "accf" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am_rain.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am_rain.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am_rain.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am_rain.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am_rain.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am_rain.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am_rain.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am_rain.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am_rain.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am_rain.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am_rain.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am_rain.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm_rain.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm_rain.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm_rain.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm_rain.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm_rain.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm_rain.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm_rain.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm_rain.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm_rain.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm_rain.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm_rain.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm_rain.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm_rain.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm_rain.ogg"
                    end
                end
                if acmusrng == "acnl" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_RAINY.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_RAINY.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_RAINY.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_RAINY.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_RAINY.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_RAINY.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_RAINY.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_RAINY.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_RAINY.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_RAINY.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_RAINY.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_RAINY.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_RAINY.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_RAINY.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_RAINY.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_RAINY.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_RAINY.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_RAINY.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_RAINY.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_RAINY.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_RAINY.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_RAINY.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_RAINY.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_RAINY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_RAINY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_RAINY.ogg"
                    end
                end
                if acmusrng == "acnh" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Rainy.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Rainy.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Rainy.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Rainy.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Rainy.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Rainy.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Rainy.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Rainy.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Rainy.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Rainy.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Rainy.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Rainy.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Rainy.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Rainy.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Rainy.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Rainy.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Rainy.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Rainy.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Rainy.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Rainy.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Rainy.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Rainy.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Rainy.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Rainy.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Rainy.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Rainy.ogg"
                    end
                end
            end
        end
        if SaveData.dateplayedweather == "sunny" then
            if malcmusic.holiday == false then
                if acmusrng == "accf" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/00-00_12_am.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/01-00_1_am.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/02-00_2_am.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/03-00_3_am.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/04-00_4_am.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/05-00_5_am.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/06-00_6_am.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/07-00_7_am.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/08-00_8_am.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/09-00_9_am.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/10-00_10_am.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/11-00_11_am.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/12-00_12_pm.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/13-00_1_pm.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/14-00_2_pm.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/15-00_3_pm.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/16-00_4_pm.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/17-00_5_pm.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/18-00_6_pm.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/19-00_7_pm.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/20-00_8_pm.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/21-00_9_pm.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/22-00_10_pm.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - City Folk/23-00_11_pm.ogg"
                    end
                end
                if acmusrng == "acnl" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR00_SUNNY.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR01_SUNNY.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR02_SUNNY.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR03_SUNNY.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR04_SUNNY.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR05_SUNNY.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR06_SUNNY.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR07_SUNNY.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR09_SUNNY.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR10_SUNNY.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR11_SUNNY.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR12_SUNNY.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR13_SUNNY.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR14_SUNNY.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR15_SUNNY.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR16_SUNNY.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR17_SUNNY.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR18_SUNNY.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR19_SUNNY.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR20_SUNNY.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR21_SUNNY.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR22_SUNNY.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR23_SUNNY.ogg"
                    end
                end
                if acmusrng == "acnh" then
                    if hour == "00" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_00_Sunny.ogg"
                    end
                    if hour == "01" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_01_Sunny.ogg"
                    end
                    if hour == "02" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_02_Sunny.ogg"
                    end
                    if hour == "03" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_03_Sunny.ogg"
                    end
                    if hour == "04" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_04_Sunny.ogg"
                    end
                    if hour == "05" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_05_Sunny.ogg"
                    end
                    if hour == "06" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_06_Sunny.ogg"
                    end
                    if hour == "07" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_07_Sunny.ogg"
                    end
                    if hour == "08" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_08_Sunny.ogg"
                    end
                    if hour == "09" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_09_Sunny.ogg"
                    end
                    if hour == "10" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_10_Sunny.ogg"
                    end
                    if hour == "11" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_11_Sunny.ogg"
                    end
                    if hour == "12" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_12_Sunny.ogg"
                    end
                    if hour == "13" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_13_Sunny.ogg"
                    end
                    if hour == "14" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_14_Sunny.ogg"
                    end
                    if hour == "15" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_15_Sunny.ogg"
                    end
                    if hour == "16" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_16_Sunny.ogg"
                    end
                    if hour == "17" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_17_Sunny.ogg"
                    end
                    if hour == "18" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_18_Sunny.ogg"
                    end
                    if hour == "19" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_19_Sunny.ogg"
                    end
                    if hour == "20" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_20_Sunny.ogg"
                    end
                    if hour == "21" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_21_Sunny.ogg"
                    end
                    if hour == "22" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_22_Sunny.ogg"
                    end
                    if hour == "23" then
                        Section(0).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Sunny.ogg"
                        Section(6).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Sunny.ogg"
                        Section(10).musicPath = "_OST/Animal Crossing - New Horizons/24HourCycle/BGM_24Hour_23_Sunny.ogg"
                    end
                end
            end
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