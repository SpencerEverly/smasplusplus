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

local rainoutsidesfx = SFX.open("_OST/_Sound Effects/rain_outside.ogg", 1, 0)
local raininsidesfx = SFX.open("_OST/_Sound Effects/rain_inside.ogg", 1, 0)

local prevSection = nil
local rainState = false
local snowState = false
local prevState = false
local prevRainState = false
local prevSnowState = false
local prevPreviousState = false
--local insideMap = table.map{1, 2, 3, 4, 7, 8}
local currentSfx = nil

local holiday = false

local sec0 = Section(0)
local sec6 = Section(6)
local sec10 = Section(10)

local ready = false

function malcmusic.onInitAPI()
	registerEvent(malcmusic, "onStart")
	registerEvent(malcmusic, "onTick")
	registerEvent(malcmusic, "onEvent")
	registerEvent(malcmusic, "onDraw")
	ready = true
end

local animalcrossingrng = {"accf","acnl","acnh"}
local acmusrng = rng.randomEntry(animalcrossingrng)

function malcmusic.onStart()
	weatherControlDay = SaveData.dateplayedweather
	--Daily weather, no rng intended anymore unless the day is tomorrow
	for i = 0,20 do
		local SectionAll = Section(i)
		if os.date("*t").month == 03 and os.date("*t").day == 17 then
			holiday = true
			if holiday == true then
				SectionAll.musicPath = "_OST/Me and Larry City/St. Patrick's Day.ogg"
				triggerEvent("StPatricksDay")
			end
		end
		
		
		if os.date("*t").month == 04 and os.date("*t").day == 04 then
			holiday = true
			if holiday == true then
				SectionAll.musicPath = "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg"
				triggerEvent("SEDay")
			end
		end
		
		
		if os.date("*t").month == 04 and os.date("*t").day == 20 then
			holiday = true
			if holiday == true then
				SectionAll.musicPath = "_OST/All Stars Secrets/smok wed everyda.ogg"
				triggerEvent("Weed")
			end
		end
		
		
		if os.date("*t").month == 12 and os.date("*t").day == 25 then
			holiday = true
			if holiday == true then
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
		if os.date("*t").month == 03 and os.date("*t").day == 17 then --St Patrick's Day
			if holiday == true then
				SectionAll.musicPath = "_OST/Me and Larry City/St. Patrick's Day.ogg"
			end
		end
		
		
		if os.date("*t").month == 04 and os.date("*t").day == 04 then --Spencer Everly Day (Foundation of my YouTube channel)
			if holiday == true then
				SectionAll.musicPath = "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg"
			end
		end
		
		
		if os.date("*t").month == 04 and os.date("*t").day == 20 then --Weed day (420)
			if holiday == true then
				SectionAll.musicPath = "_OST/All Stars Secrets/smok wed everyda.ogg"
			end
		end
		
		
		if os.date("*t").month == 12 and os.date("*t").day == 25 then --Christmas
			if holiday == true then
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
			if holiday == false then
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
			if player.section == 0 then
				rainState = true
				prevState = false
			elseif player.section == 1 then
				rainState = false
				prevState = true
			elseif player.section == 2 then
				rainState = false
				prevState = true
			elseif player.section == 3 then
				rainState = false
				prevState = true
			elseif player.section == 4 then
				rainState = false
				prevState = true
			elseif player.section == 6 then
				rainState = true
				prevState = false
			elseif player.section == 7 then
				rainState = false
				prevState = true
			elseif player.section == 8 then
				rainState = false
				prevState = true
			elseif player.section == 9 then
				rainState = true
				prevState = false
			elseif player.section == 10 then
				rainState = true
				prevState = false
			elseif player.section == 11 then
				rainState = true
				prevState = false
			elseif player.section == 12 then
				rainState = false
				prevState = true
			elseif player.section == 13 then
				rainState = false
				prevState = true
			elseif player.section == 14 then
				rainState = false
				prevState = true
			end
			if (rainState ~= prevRainState) or (prevSection ~= player.section) then
				if rainState == true then
					Section(player.section).effects.weather = WEATHER_RAIN
					currentSfxOutRain = SFX.play(rainoutsidesfx, 1, 0)
					
					if currentSfxInRain then
						currentSfxInRain:fadeout(50)
						currentSfxInRain = nil
					end
				elseif prevState == true then
					currentSfxInRain = SFX.play(raininsidesfx, 1, 0)
					
					if currentSfxOutRain then
						currentSfxOutRain:fadeout(50)
						currentSfxOutRain = nil
					end
				elseif rainState == false then
					if currentSfxOutRain then
						currentSfxOutRain:fadeout(50)
						currentSfxOutRain = nil
					end
				elseif prevState == false then
					if currentSfxInRain then
						currentSfxInRain:fadeout(50)
						currentSfxInRain = nil
					end
				end
				prevSection = player.section
				prevRainState = rainState
				prevPreviousState = prevState
				prevInsideState = insideState
			end
			if holiday == false then
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
			if holiday == false then
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

		currentCostume = player:getCostume()
		character = player.character
		
		if currentCostume == nil then
			if character == "CHARACTER_MARIO" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			end
			if character == "CHARACTER_LUIGI" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
			end
			if character == "CHARACTER_PEACH" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
			end
			if character == "CHARACTER_TOAD" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
			end
			if character == "CHARACTER_LINK" and holiday == false then
				Audio.MusicChange(1, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(2, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(3, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(7, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(8, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(11, "_OST/Legend of Zelda - A Link to the Past/05a Majestic Castle.spc|0;g=2.5")
				Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
			end
			if character == "CHARACTER_WARIO" and holiday == false then
				Audio.MusicChange(1, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(2, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(3, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(7, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(8, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(11, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(12, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
				Audio.MusicChange(13, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
			end
			if character == "CHARACTER_YOSHI" and holiday == false then
				Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
			end
			if character == "CHARACTER_BOWSER" and holiday == false then
				Audio.MusicChange(1, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(2, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(3, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(7, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(8, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(11, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(12, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(13, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
			end
			if character == "CHARACTER_NINJABOMBERMAN" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
				Audio.MusicChange(13, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
			end
			if character == "CHARACTER_MEGAMAN" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
				Audio.MusicChange(13, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
			end
			if character == "CHARACTER_KLONOA" and holiday == false then
				Audio.MusicChange(1, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(2, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(3, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(7, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(8, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(11, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
				Audio.MusicChange(12, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
				Audio.MusicChange(13, "_OST/Klonoa (Wii)/217 - Hiroshi Okubo - The Ring.ogg")
			end
			if character == "CHARACTER_ZELDA" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
			end
			if character == "CHARACTER_ROSALINA" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
				Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			end
			if character == "CHARACTER_SAMUS" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Metroid - Zero Mission/Brinstar.ogg")
				Audio.MusicChange(13, "_OST/Metroid - Zero Mission/Brinstar.ogg")
			end
			if character == "CHARACTER_UNCLEBROADSWORD" and holiday == false then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
				Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			end
			if character == "CHARACTER_ULTIMATERINKA" and holiday == false then
				Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
				Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
				Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
				Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
				Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
				Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
				Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
				Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			end
		end
		
		--CHARACTER_MARIO
		if currentCostume == "0-SMASPLUSPLUS-BETA" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(3, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(7, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(8, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(11, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
			Audio.MusicChange(12, "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg")
			Audio.MusicChange(13, "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg")
		end
		if currentCostume == "1-SMB1-RETRO" and holiday == false then
			Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		end
		if currentCostume == "2-SMB1-RECOLORED" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "3-SMB1-SMAS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "4-SMB2-RETRO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "5-SMB2-SMAS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "6-SMB3-RETRO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
		end
		if currentCostume == "7-SML2" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Land 2 - OST.gbs|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Land 2 - OST.gbs|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Land 2 - OST.gbs|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Land 2 - OST.gbs|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Land 2 - OST.gbs|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Land 2 - OST.gbs|4;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Land 2 - OST.gbs|0;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Land 2 - OST.gbs|0;g=2")
		end
		if currentCostume == "9-SMW-PIRATE" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
			Audio.MusicChange(12, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
			Audio.MusicChange(13, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
		end
		if currentCostume == "Z-SMW2-ADULTMARIO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 7).spc|0;g=2.0")
			Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 3).spc|0;g=2.0")
			Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
			Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
			Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
		end
		if currentCostume == "11-SMA1" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance/Choose A Player.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance/Choose A Player.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance/Choose A Player.ogg")
		end
		if currentCostume == "12-SMA2" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		end
		if currentCostume == "13-SMA4" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
		end
		if currentCostume == "14-NSMBDS-SMBX" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
			Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		end
		if currentCostume == "15-NSMBDS-ORIGINAL" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
			Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		end
		if currentCostume == "A2XT-DEMO" and holiday == false then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "GOOMBA" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "DEMO-XMASPILY" and holiday == false then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "GOLDENMARIO" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "MODERN" and holiday == false then
			Audio.MusicChange(1, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(2, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(3, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(7, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(8, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(11, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
			Audio.MusicChange(12, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
			Audio.MusicChange(13, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
		end
		if currentCostume == "PRINCESSRESCUE" and holiday == false then
			Audio.MusicChange(1, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(2, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(3, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(7, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(8, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(11, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(12, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(13, "_OST/Princess Rescue/Overworld.ogg")
		end
		if currentCostume == "SMG4" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
			Audio.MusicChange(12, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
			Audio.MusicChange(13, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
		end
		if currentCostume == "SMW-MARIO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "SP-1-ERICCARTMAN" and holiday == false then
			Audio.MusicChange(1, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(2, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(3, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(7, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(8, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(11, "_OST/South Park (N64)/Banjo Barnyard.ogg")
			Audio.MusicChange(12, "_OST/South Park (N64)/Banjo Barnyard.ogg")
			Audio.MusicChange(13, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		end
		if currentCostume == "BOBTHETOMATO" and holiday == false then
			Audio.MusicChange(1, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(2, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(3, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(7, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(8, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(11, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(12, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(13, "_OST/VeggieTales/Theme Song.ogg")
		end
		if currentCostume == "GA-CAILLOU" and holiday == false then
			Audio.MusicChange(1, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(2, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(3, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(7, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(8, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(11, "_OST/GoAnimate/Very Old Songs/GoAnimate Jingle by the Anime Master.mp3")
			Audio.MusicChange(12, "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3")
			Audio.MusicChange(13, "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3")
		end
		if currentCostume == "JCFOSTERTAKESITTOTHEMOON" and holiday == false then
			Audio.MusicChange(1, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(7, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(8, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(11, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(12, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(13, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		end
		if currentCostume == "SMB0" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(7, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(8, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(11, "_OST/Super Mario Bros 0/Intro.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Bros 0/Intro.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Bros 0/Intro.ogg")
		end
		if currentCostume == "SMM2-MARIO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "MARINK" and holiday == false then
			Audio.MusicChange(1, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
			Audio.MusicChange(2, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
			Audio.MusicChange(3, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
			Audio.MusicChange(7, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
			Audio.MusicChange(8, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|6;g=1.8")
			Audio.MusicChange(11, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8")
			Audio.MusicChange(12, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8")
			Audio.MusicChange(13, "_OST/Zelda II - The Adventure of Link (NES, VRC6 Remaster by IsabelleChiming) - OST.nsf|2;g=1.8")
		end
		
		
		
		
		
		
		
		
		
		--CHARACTER_LUIGI
		if currentCostume == "0-SPENCEREVERLY" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Super Mario Bros Spencer/Overworld.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Bros Spencer/Athletic.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Bros Spencer/Athletic.ogg")
		end
		if currentCostume == "3-SMB1-RETRO-MODERN" and holiday == false then
			Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		end
		if currentCostume == "4-SMB1-SMAS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "5-SMB2-RETRO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "6-SMB2-SMAS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "7-SMB3-RETRO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
		end
		if currentCostume == "9-SMB3-MARIOCLOTHES" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "10-SMW-ORIGINAL" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "13-SMBDX" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros Deluxe.gbs|18;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros Deluxe.gbs|11;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros Deluxe.gbs|11;g=2")
		end
		if currentCostume == "15-SMA2" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		end
		if currentCostume == "17-NSMBDS-SMBX" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "__OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
			Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		end
		if currentCostume == "A2XT-IRIS" and holiday == false then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "LARRYTHECUCUMBER" and holiday == false then
			Audio.MusicChange(1, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(2, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(3, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(7, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(8, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(11, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(12, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(13, "_OST/VeggieTales/Theme Song.ogg")
		end
		if currentCostume == "SMM2-LUIGI" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "SMW1-YOSHI" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "SMW-LUIGI" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "UNDERTALE-FRISK" and holiday == false then
			Audio.MusicChange(1, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(2, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(3, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(7, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(8, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(11, "_OST/Undertale/mus_dogshrine_1.ogg")
			Audio.MusicChange(12, "_OST/Undertale/mus_zz_megalovania.ogg")
			Audio.MusicChange(13, "_OST/Undertale/mus_zz_megalovania.ogg")
		end
		if currentCostume == "WALUIGI" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "WOHLSTAND" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		
		
		
		
		
		
		
		
		
		
		--CHARACTER_PEACH
		if currentCostume == "2-SMB1-SMAS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "A2XT-KOOD" and holiday == false then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "DAISY" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "KIRBY-SMB3" and holiday == false then
			Audio.MusicChange(1, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(2, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(3, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(7, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(8, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(11, "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7")
		end
		if currentCostume == "PAULINE" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "SMA4" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 4/N-Spade Bonus.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 4/N-Spade Bonus.ogg")
		end
		if currentCostume == "SMW-PEACH" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "TUX" and holiday == false then
			Audio.MusicChange(1, "_OST/Tux Racer/Race 01.mp3")
			Audio.MusicChange(2, "_OST/Tux Racer/Race 01.mp3")
			Audio.MusicChange(3, "_OST/Tux Racer/Race 01.mp3")
			Audio.MusicChange(7, "_OST/Tux Racer/Race 01.mp3")
			Audio.MusicChange(8, "_OST/Tux Racer/Race 01.mp3")
			Audio.MusicChange(11, "_OST/Tux Racer/Race 02.mp3")
			Audio.MusicChange(12, "_OST/Tux Racer/Start Menu.mp3")
			Audio.MusicChange(13, "_OST/Tux Racer/Start Menu.mp3")
		end
		
		
		
		
		
		
		
		
		
		--CHARACTER_TOAD
		if currentCostume == "1-SMB1-RETRO" and holiday == false then
			Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		end
		if currentCostume == "2-SMB1-SMAS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "3-SMB2-RETRO" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "4-SMB2-RETRO-YELLOW" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "5-SMB2-RETRO-RED" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "6-SMB3-BLUE" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "7-SMB3-YELLOW" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "A2XT-RAOCOW" and holiday == false then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "CAPTAINTOAD" and holiday == false then
			Audio.MusicChange(1, "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg")
			Audio.MusicChange(2, "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg")
			Audio.MusicChange(3, "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg")
			Audio.MusicChange(7, "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg")
			Audio.MusicChange(8, "_OST/Captain Toad - Treasure Tracker (Wii U)/Stm_Kp_bgm_Pinball (channels 2 and 3).ogg")
			Audio.MusicChange(11, "_OST/Captain Toad - Treasure Tracker (Wii U)/Kp_bgm_Book02.nk.32.dspadpcm.ogg")
			Audio.MusicChange(12, "_OST/Captain Toad - Treasure Tracker (Wii U)/Kp_bgm_Book01.nk.32.dspadpcm.ogg")
			Audio.MusicChange(13, "_OST/Captain Toad - Treasure Tracker (Wii U)/Kp_bgm_Book01.nk.32.dspadpcm.ogg")
		end
		if currentCostume == "HAMTARO" and holiday == false then
			Audio.MusicChange(1, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
			Audio.MusicChange(12, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
			Audio.MusicChange(13, "_OST/Hamtaro - Ham Ham Heartbreak/Main Theme.ogg")
		end
		if currentCostume == "SEE-TANGENT" and holiday == false then
			Audio.MusicChange(1, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg")
			Audio.MusicChange(2, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg")
			Audio.MusicChange(3, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg")
			Audio.MusicChange(7, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_KENNEL_2.ogg")
			Audio.MusicChange(8, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg")
			Audio.MusicChange(11, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
			Audio.MusicChange(12, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
			Audio.MusicChange(13, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
		end
		if currentCostume == "SMM2-TOAD" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "SMM2-TOADETTE" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "SMM2-YELLOWTOAD" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "SONIC" and holiday == false then
			Audio.MusicChange(1, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(2, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(3, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(7, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(8, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(11, "_OST/Sonic Mania/SaveSelect.ogg")
			Audio.MusicChange(12, "_OST/Sonic Mania/SaveSelect.ogg")
			Audio.MusicChange(13, "_OST/Sonic Mania/SaveSelect.ogg")
		end
		if currentCostume == "TOADETTE" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "YOSHI-SMB3" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		
		
		
		
		
		
		
		
		
		
		
		--CHARACTER_LINK
		if currentCostume == "5-LINKWAKE-SNES" and holiday == false then
			Audio.MusicChange(1, "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg")
			Audio.MusicChange(2, "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg")
			Audio.MusicChange(3, "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg")
			Audio.MusicChange(7, "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg")
			Audio.MusicChange(8, "_OST/Legend of Zelda - Link's Awakening (Switch)/15_Shop.ry.48.dspadpcm.ogg")
			Audio.MusicChange(11, "_OST/Legend of Zelda - Link's Awakening (Switch)/12_StrangeForest.ry.48.dspadpcm.ogg")
			Audio.MusicChange(12, "_OST/Legend of Zelda - Link's Awakening (Switch)/10_Field_Normal.ry.48.dspadpcm.ogg")
			Audio.MusicChange(13, "_OST/Legend of Zelda - Link's Awakening (Switch)/10_Field_Normal.ry.48.dspadpcm.ogg")
		end
		if currentCostume == "A2XT-SHEATH" and holiday == false then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "NESS" and holiday == false then
			Audio.MusicChange(1, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(2, "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3")
			Audio.MusicChange(3, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(7, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(8, "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3")
			Audio.MusicChange(11, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(12, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3")
			Audio.MusicChange(13, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3")
		end
		if currentCostume == "SEE-SHERBERTLUSSIEBACK" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		end
		if currentCostume == "SMB1-SNES" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "SMB2-SNES" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "SMB3-BANDANA-DEE" and holiday == false then
			Audio.MusicChange(1, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(2, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(3, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(7, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(8, "_OST/Kirby Superstar/15 Dynablade Overworld.spc|0;g=2.7")
			Audio.MusicChange(11, "_OST/Kirby Superstar/16 Peanut Plain.spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Kirby Superstar/19 Candy Mountain.spc|0;g=2.7")
		end
		if currentCostume == "TAKESHI" and holiday == false then
			Audio.MusicChange(1, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(12, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(13, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		end
		if currentCostume == "TAKESHI-SNES" and holiday == false then
			Audio.MusicChange(1, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(2, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(3, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(7, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(8, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(11, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(12, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
			Audio.MusicChange(13, "_OST/Takeshi's Challenge (SNES)/Main Theme (SNES).ogg")
		end
		
		
		
		
		--CHARACTER_KLONOA
		if currentCostume == "MARINALITEYEARS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "MISCHEIFMAKERS-MARINA" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "SMW2-YOSHI" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 7).spc|0;g=2.0")
			Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 3).spc|0;g=2.0")
			Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
			Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
			Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
		end
		if currentCostume == "YS-GREEN" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Yoshi's Story/Yoshi's Song.ogg")
			Audio.MusicChange(12, "_OST/Yoshi's Story/Yoshi's Song.ogg")
			Audio.MusicChange(13, "_OST/Yoshi's Story/Yoshi's Song.ogg")
		end
		
		
		
		
		
		--CHARACTER_STEVE (ULTIMATE_RINKA)
		if currentCostume == "DJCTRE-CUBIXTRON" and holiday == false then
			Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		end
		if currentCostume == "DJCTRE-CUBIXTRONDAD" and holiday == false then
			Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		end
		if currentCostume == "DJCTRE-STULTUS" and holiday == false then
			Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		end
		if currentCostume == "DLC-FESTIVE-CHRISTMASTREE" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "ED-EDEDDANDEDDY" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "EXPLODINGTNT" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "GEORGENOTFOUNDYT" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "HANGOUTYOSHIGUYYT" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "KARLJACOBSYT" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "KOOPAPANZER" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ALEX" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-CAPTAINTOAD" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-FNF-BOYFRIEND" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-FNF-GIRLFRIEND" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-FRISK" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-HEROBRINE" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-IMPOSTOR" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ITSJERRY" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ITSHARRY" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-KERALIS" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-KRIS" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-MARIO" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-NOELLE-DELTARUNE" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-NOTCH" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-PATRICK" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-RALSEI" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SONIC" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SPIDERMAN" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SPONGEBOB" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SQUIDWARD" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SUSIE-DELTARUNE" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-TAILS" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ZOMBIE" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "QUACKITYYT" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "SEE-MC-EVILME" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-GERANIUM" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-LEWBERTLUSSIEBACK" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-LILIJUCIEBACK" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-MIMIJUCIEBACK" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-RONDAVIS" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SHENICLE" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SHELLEYKIRK" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SHERBERTLUSSIEBACK" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SPENCER2" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SPENCEREVERLY" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-TIANELY" and holiday == false then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "TOMMYINNITYT" and holiday == false then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "UNOFFICIALSTUDIOSYT" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		
		
		
		
		--CHARACTER_YOSHI (KLONOA)
		if currentCostume == "SMA3" and holiday == false then
			Audio.MusicChange(1, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 3/Flower Garden.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 3/Training Course.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 3/Training Course.ogg")
		end
		
		
		
		
		
		
		
		--CHARACTER_ROSALINA
		if currentCostume == "KING BOO" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "SMB2-SMAS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "UTSUHOREIUJI" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		
		
		
		
		
		
		
		
		--CHARACTER_MEGAMAN
		if currentCostume == "BAD BOX ART MEGA MAN" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "BASS" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "DR. WILY" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "MARISAKIRISAME" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "MEGAMAN-NES" and holiday == false then
			Audio.MusicChange(1, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6")
			Audio.MusicChange(2, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6")
			Audio.MusicChange(3, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6")
			Audio.MusicChange(7, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6")
			Audio.MusicChange(8, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|10;g=1.6")
			Audio.MusicChange(11, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|9;g=1.6")
			Audio.MusicChange(12, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|7;g=1.6")
			Audio.MusicChange(13, "_OST/Mega Man 2 (NES, VRC6 by RushJet1) - OST.nsf|7;g=1.6")
		end
		if currentCostume == "PROTOMAN" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "ROLL" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "MEGAMAN-8BITMM" and holiday == false then
			Audio.MusicChange(1, "_OST/Mega Man 2 - OST.nsf|3;g=1.4")
			Audio.MusicChange(2, "_OST/Mega Man 2 - OST.nsf|3;g=1.4")
			Audio.MusicChange(3, "_OST/Mega Man 2 - OST.nsf|3;g=1.4")
			Audio.MusicChange(7, "_OST/Mega Man 2 - OST.nsf|3;g=1.4")
			Audio.MusicChange(8, "_OST/Mega Man 2 - OST.nsf|3;g=1.4")
			Audio.MusicChange(11, "_OST/Mega Man 2 - OST.nsf|4;g=1.4")
			Audio.MusicChange(12, "_OST/Mega Man 2 - OST.nsf|6;g=1.4")
			Audio.MusicChange(13, "_OST/Mega Man 2 - OST.nsf|6;g=1.4")
		end
		if currentCostume == "MEGAMAN-MARISA" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		
		
		
		
		
		
		--CHARACTER_SAMUS
		if currentCostume == "BILLRIZER" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "SAMUS-NES" and holiday == false then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
	end
end

function malcmusic.onEvent(eventName)
	if eventName == "MarioChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
	end
	if eventName == "LuigiChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if eventName == "PeachChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
	end
	if eventName == "ToadChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
	end
	if eventName == "LinkChar" and holiday == false then
		Audio.MusicChange(0, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(6, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(10, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Legend of Zelda - A Link to the Past/05a Majestic Castle.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
	end
	if eventName == "WarioChar" and holiday == false then
		Audio.MusicChange(0, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(1, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(2, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(3, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(6, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(7, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(8, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(10, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(11, "_OST/Wario Land 3.gbs|3;g=2")
		Audio.MusicChange(12, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
		Audio.MusicChange(13, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
	end
	if eventName == "BowserChar" and holiday == false then
		Audio.MusicChange(0, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(1, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(2, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(3, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(6, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(7, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(8, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(10, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(11, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
	end
	if eventName == "BombChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
		Audio.MusicChange(13, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
	end
	if eventName == "MegaChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
		Audio.MusicChange(13, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
	end
	if eventName == "ZeldaChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
	end
	if eventName == "RosaChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if eventName == "SamusChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Metroid - Zero Mission/Brinstar.ogg")
		Audio.MusicChange(13, "_OST/Metroid - Zero Mission/Brinstar.ogg")
	end
	if eventName == "UncleChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if eventName == "RinkaChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if eventName == "SnakeChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(2, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(3, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(7, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(8, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(11, "_OST/Metal Gear - OST.nsf|7;g=2")
		Audio.MusicChange(12, "_OST/Metal Gear - OST.nsf|6;g=2")
		Audio.MusicChange(13, "_OST/Metal Gear - OST.nsf|6;g=2")
	end
	if eventName == "YoshiChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
	end
	if eventName == "KlonoaChar" and holiday == false then
		Audio.MusicChange(1, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(2, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(3, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(7, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(8, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(11, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
		Audio.MusicChange(12, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
		Audio.MusicChange(13, "_OST/Klonoa (Wii)/217 - Hiroshi Okubo - The Ring.ogg")
	end
	if eventName == "StageGenoside" and holiday == false then
		Audio.MusicChange(0, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(4, "_OST/Me and Larry City/Story Mode Hub Theme 3, Genoside (Super Mario Maker 2).ogg")
		Audio.MusicChange(5, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(6, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(9, "_OST/Undertale/mus_chara.ogg")
		Audio.MusicChange(10, "_OST/Me and Larry City/Main Theme (Genoside).ogg")
		Audio.MusicChange(11, "_OST/Undertale/mus_chara.ogg")
		Audio.MusicChange(12, "_OST/Undertale/mus_chara.ogg")
		Audio.MusicChange(13, "_OST/Undertale/mus_chara.ogg")
	end
end

return malcmusic