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

local rain = false
local snow = false
local sunny = true

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

local possibleWeather = {
	{"sunny", "rain", "snow"}
}

local currentPossibleWeather = possibleWeather[1]
local currentWeather = RNG.irandomEntry(currentPossibleWeather)

local ready = false

function malcmusic.onInitAPI()
	registerEvent(malcmusic, "onStart")
	registerEvent(malcmusic, "onTick")
	registerEvent(malcmusic, "onEvent")
	ready = true
end

function malcmusic.onStart()
	currentWeather = true
end

function malcmusic.onTick()
	for i = 0,20 do
		local SectionAll = Section(i)
		if os.date("*t").month == 03 and os.date("*t").day == 17 then
			if holiday == true then
				SectionAll.musicPath = "_OST/Me and Larry City/St. Patrick's Day.ogg"
				triggerEvent("StPatricksDay")
			end
		end
		
		
		if os.date("*t").month == 04 and os.date("*t").day == 04 then
			if holiday == true then
				SectionAll.musicPath = "_OST/Nintendo Land/BGM_TTL_MAIN_EVENING (channels 0 and 1).ogg"
				triggerEvent("SEDay")
			end
		end
		
		
		if os.date("*t").month == 04 and os.date("*t").day == 20 then
			if holiday == true then
				SectionAll.musicPath = "_OST/All Stars Secrets/smok wed everyda.ogg"
				triggerEvent("Weed")
			end
		end
		
		
		if os.date("*t").month == 12 and os.date("*t").day == 25 then
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
		
		
		if snow == true then
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
					ASection(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SNOWY.ogg"
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
		end
		if rain == true then
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
			elseif player.section == 3 then
				rainState = false
				prevState = true
			end
			if (rainState ~= prevRainState) or (prevSection ~= player.section) then
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
				prevRainState = rainState
				prevPreviousState = prevState
				--prevInsideState = insideState
				--prevRainState = rainState
			end
			if holiday == false then
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
					ASection(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_RAINY.ogg"
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
		end
		if sunny == true then
			if holiday == false then
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
					ASection(0).musicPath = "_OST/Animal Crossing - New Leaf/STRM_BGM_OUTDOOR08_SUNNY.ogg"
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
		end

		currentCostume = player:getCostume()
		character = player.character
		
		if currentCostume == nil then
			if character == "CHARACTER_MARIO" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
			end
			if character == "CHARACTER_LUIGI" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
			end
			if character == "CHARACTER_PEACH" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
			end
			if character == "CHARACTER_TOAD" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
			end
			if character == "CHARACTER_LINK" then
				Audio.MusicChange(1, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(2, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(3, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(7, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(8, "_OST/Legend of Zelda - A Link to the Past/09 Kakariko Village.spc|0;g=2.5")
				Audio.MusicChange(11, "_OST/Legend of Zelda - A Link to the Past/05a Majestic Castle.spc|0;g=2.5")
				Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/08 Hyrule Field Main Theme.spc|0;g=2.5")
			end
			if character == "CHARACTER_WARIO" then
				Audio.MusicChange(1, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(2, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(3, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(7, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(8, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(11, "_OST/Wario Land 3.gbs|3;g=2")
				Audio.MusicChange(12, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
				Audio.MusicChange(13, "_OST/Wario Land - Super Mario Land 3.gbs|3;g=2")
			end
			if character == "CHARACTER_YOSHI" then
				Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
				Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
			end
			if character == "CHARACTER_BOWSER" then
				Audio.MusicChange(1, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(2, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(3, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(7, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(8, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(11, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(12, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
				Audio.MusicChange(13, "_OST/Super Mario Bros 3/Dark Land.spc|0;g=2.3")
			end
			if character == "CHARACTER_NINJABOMBERMAN" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
				Audio.MusicChange(13, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
			end
			if character == "CHARACTER_MEGAMAN" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
				Audio.MusicChange(13, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
			end
			if character == "CHARACTER_KLONOA" then
				Audio.MusicChange(1, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(2, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(3, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(7, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(8, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
				Audio.MusicChange(11, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
				Audio.MusicChange(12, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
				Audio.MusicChange(13, "_OST/Klonoa (Wii)/217 - Hiroshi Okubo - The Ring.ogg")
			end
			if character == "CHARACTER_ZELDA" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
				Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
			end
			if character == "CHARACTER_ROSALINA" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
				Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			end
			if character == "CHARACTER_SAMUS" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Metroid - Zero Mission/Brinstar.ogg")
				Audio.MusicChange(13, "_OST/Metroid - Zero Mission/Brinstar.ogg")
			end
			if character == "CHARACTER_UNCLEBROADSWORD" then
				Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
				Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
				Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
				Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			end
			if character == "CHARACTER_ULTIMATERINKA" then
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
		if currentCostume == "0-SMASPLUSPLUS-BETA" then
			Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(3, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(7, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(8, "_OST/Super Mario All-Stars++ (Beta)/ac_1700.ogg")
			Audio.MusicChange(11, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
			Audio.MusicChange(12, "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg")
			Audio.MusicChange(13, "_OST/Super Mario All-Stars++ (Beta)/BonusSMB3.ogg")
		end
		if currentCostume == "1-SMB1-RETRO" then
			Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		end
		if currentCostume == "2-SMB1-RECOLORED" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "3-SMB1-SMAS" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "4-SMB2-RETRO" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "5-SMB2-SMAS" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "6-SMB3-RETRO" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
		end
		if currentCostume == "9-SMW-PIRATE" then
			Audio.MusicChange(1, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario World (NES, Pirate) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
			Audio.MusicChange(12, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
			Audio.MusicChange(13, "_OST/Super Mario World (NES, Pirate) - OST.nsf|9;g=2")
		end
		if currentCostume == "Z-SMW2-ADULTMARIO" then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 7).spc|0;g=2.0")
			Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 2).spc|0;g=2.0")
			Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/120 Map (part 3).spc|0;g=2.0")
			Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
			Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
			Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/104 Yoshi Start Demo - Prototype Music.spc|0;g=1.7")
		end
		if currentCostume == "11-SMA1" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance/Choose A Player.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance/Choose A Player.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance/Choose A Player.ogg")
		end
		if currentCostume == "12-SMA2" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		end
		if currentCostume == "13-SMA4" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 4/Choose A Game!.ogg")
		end
		if currentCostume == "14-NSMBDS-SMBX" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
			Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		end
		if currentCostume == "15-NSMBDS-ORIGINAL" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
			Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		end
		if currentCostume == "A2XT-DEMO" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "GOOMBA" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "DEMO-XMASPILY" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "GOLDENMARIO" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "MODERN" then
			Audio.MusicChange(1, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(2, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(3, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(7, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(8, "_OST/Modern Mario/SMB2 - Character Select.ogg")
			Audio.MusicChange(11, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
			Audio.MusicChange(12, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
			Audio.MusicChange(13, "_OST/Modern Mario/SM64 - Bob-Omb Battlefield.ogg")
		end
		if currentCostume == "PRINCESSRESCUE" then
			Audio.MusicChange(1, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(2, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(3, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(7, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(8, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(11, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(12, "_OST/Princess Rescue/Overworld.ogg")
			Audio.MusicChange(13, "_OST/Princess Rescue/Overworld.ogg")
		end
		if currentCostume == "SMG4" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
			Audio.MusicChange(12, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
			Audio.MusicChange(13, "_OST/Super Smash Bros. Ultimate/Mario/a70_smm_title.ogg")
		end
		if currentCostume == "SMW-MARIO" then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.3")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.3")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.3")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.3")
		end
		if currentCostume == "SP-1-ERICCARTMAN" then
			Audio.MusicChange(1, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(2, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(3, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(7, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(8, "_OST/South Park (N64)/Insane Toys.ogg")
			Audio.MusicChange(11, "_OST/South Park (N64)/Banjo Barnyard.ogg")
			Audio.MusicChange(12, "_OST/South Park (N64)/Banjo Barnyard.ogg")
			Audio.MusicChange(13, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		end
		if currentCostume == "BOBTHETOMATO" then
			Audio.MusicChange(1, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(2, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(3, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(7, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(8, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(11, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(12, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(13, "_OST/VeggieTales/Theme Song.ogg")
		end
		if currentCostume == "GA-CAILLOU" then
			Audio.MusicChange(1, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(2, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(3, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(7, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(8, "_OST/GoAnimate/Old Songs/Ambient - Peaceful.mp3")
			Audio.MusicChange(11, "_OST/GoAnimate/Very Old Songs/GoAnimate Jingle by the Anime Master.mp3")
			Audio.MusicChange(12, "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3")
			Audio.MusicChange(13, "_OST/GoAnimate/Very Old Songs/GoAnimate Song from YouTube.mp3")
		end
		if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
			Audio.MusicChange(1, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(2, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(3, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(7, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(8, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(11, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(12, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
			Audio.MusicChange(13, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		end
		if currentCostume == "SMB0" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(7, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(8, "_OST/Super Mario Bros 0/Shop.ogg")
			Audio.MusicChange(11, "_OST/Super Mario Bros 0/Intro.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Bros 0/Intro.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Bros 0/Intro.ogg")
		end
		if currentCostume == "MARINK" then
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
		if currentCostume == "0-SPENCEREVERLY" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Super Mario Bros Spencer/Overworld.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Bros Spencer/Athletic.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Bros Spencer/Athletic.ogg")
		end
		if currentCostume == "3-SMB1-RETRO-MODERN" then
			Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		end
		if currentCostume == "4-SMB1-SMAS" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "5-SMB2-RETRO" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "6-SMB2-SMAS" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "7-SMB3-RETRO" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|17;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|16;g=2")
		end
		if currentCostume == "9-SMB3-MARIOCLOTHES" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "10-SMW-ORIGINAL" then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "13-SMBDX" then
			Audio.MusicChange(1, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros Deluxe.gbs|20;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros Deluxe.gbs|18;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros Deluxe.gbs|11;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros Deluxe.gbs|11;g=2")
		end
		if currentCostume == "15-SMA2" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance/Me and Larry City (GBA).ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 2/Choose A Game.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 2/Choose A Game.ogg")
		end
		if currentCostume == "17-NSMBDS-SMBX" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "__OST/New Super Mario Bros. DS/Walking the Plains.ogg")
			Audio.MusicChange(12, "_OST/New Super Mario Bros. DS/Toad House.ogg")
			Audio.MusicChange(13, "_OST/New Super Mario Bros. DS/Toad House.ogg")
		end
		if currentCostume == "A2XT-IRIS" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "LARRYTHECUCUMBER" then
			Audio.MusicChange(1, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(2, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(3, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(7, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(8, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(11, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(12, "_OST/VeggieTales/Theme Song.ogg")
			Audio.MusicChange(13, "_OST/VeggieTales/Theme Song.ogg")
		end
		if currentCostume == "SMW-LUIGI" then
			Audio.MusicChange(1, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(2, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(3, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(7, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(8, "_OST/Super Mario World/Status Screen.spc|0;g=2.6")
			Audio.MusicChange(11, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(12, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
			Audio.MusicChange(13, "_OST/Super Mario World/Choose a Game.spc|0;g=2.6")
		end
		if currentCostume == "UNDERTALE-FRISK" then
			Audio.MusicChange(1, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(2, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(3, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(7, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(8, "_OST/Undertale/mus_town.ogg")
			Audio.MusicChange(11, "_OST/Undertale/mus_dogshrine_1.ogg")
			Audio.MusicChange(12, "_OST/Undertale/mus_zz_megalovania.ogg")
			Audio.MusicChange(13, "_OST/Undertale/mus_zz_megalovania.ogg")
		end
		if currentCostume == "WALUIGI" then
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
		
		
		
		
		
		
		
		
		
		
		--CHARACTER_TOAD
		if currentCostume == "1-SMB1-RETRO" then
			Audio.MusicChange(1, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(12, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
			Audio.MusicChange(13, "_OST/Vs. Super Mario Bros. (NES) - OST.nsf|20;g=2")
		end
		if currentCostume == "2-SMB1-SMAS" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "3-SMB2-RETRO" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "4-SMB2-RETRO-YELLOW" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "5-SMB2-RETRO-RED" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(3, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|5;g=2")
			Audio.MusicChange(11, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(12, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
			Audio.MusicChange(13, "_OST/Super Mario Bros 2 (NES) - OST.nsf|1;g=2")
		end
		if currentCostume == "6-SMB3-BLUE" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "7-SMB3-YELLOW" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "A2XT-RAOCOW" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(2, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(3, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(7, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(8, "_OST/Adventures of Demo/bossa-ing_around.s3m")
			Audio.MusicChange(11, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(12, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
			Audio.MusicChange(13, "_OST/Adventures of Demo/menuet_of_game.spc|0;g=2.0")
		end
		if currentCostume == "SEE-TANGENT" then
			Audio.MusicChange(1, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg")
			Audio.MusicChange(2, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg")
			Audio.MusicChange(3, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_INTERIOR.ogg")
			Audio.MusicChange(7, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_KENNEL_2.ogg")
			Audio.MusicChange(8, "_OST/Nintendogs + Cats/CFR_BGM_SHOP_HOTEL.ogg")
			Audio.MusicChange(11, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
			Audio.MusicChange(12, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
			Audio.MusicChange(13, "_OST/Nintendogs + Cats/CFR_BGM_WALK.ogg")
		end
		if currentCostume == "SONIC" then
			Audio.MusicChange(1, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(2, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(3, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(7, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(8, "_OST/Sonic Mania/MainMenu.ogg")
			Audio.MusicChange(11, "_OST/Sonic Mania/SaveSelect.ogg")
			Audio.MusicChange(12, "_OST/Sonic Mania/SaveSelect.ogg")
			Audio.MusicChange(13, "_OST/Sonic Mania/SaveSelect.ogg")
		end
		if currentCostume == "TOADETTE" then
			Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
			Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
			Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
			Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		end
		if currentCostume == "YOSHI-SMB3" then
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
		if currentCostume == "NESS" then
			Audio.MusicChange(1, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(2, "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3")
			Audio.MusicChange(3, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(7, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(8, "_OST/EarthBound/024 Enjoy Your Stay.spc|0;g=2.3")
			Audio.MusicChange(11, "_OST/EarthBound/021 Home Sweet Home.spc|0;g=2.3")
			Audio.MusicChange(12, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3")
			Audio.MusicChange(13, "_OST/EarthBound/019b Onett Theme.spc|0;g=2.3")
		end
		if currentCostume == "SEE-SHERBERTLUSSIEBACK" then
			Audio.MusicChange(1, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/S!TS! REBOOT (Theme Song).ogg")
		end
		if currentCostume == "TAKESHI" then
			Audio.MusicChange(1, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(2, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(3, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(7, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(8, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(11, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(12, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
			Audio.MusicChange(13, "_OST/Takeshi no Chousenjou - OST.nsf|0;g=2")
		end
		if currentCostume == "TAKESHI-SNES" then
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
		if currentCostume == "YS-GREEN" then
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
		if currentCostume == "DJCTRE-CUBIXTRON" then
			Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		end
		if currentCostume == "DJCTRE-CUBIXTRONDAD" then
			Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		end
		if currentCostume == "DJCTRE-STULTUS" then
			Audio.MusicChange(1, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(2, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(3, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(7, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(8, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(11, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(12, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
			Audio.MusicChange(13, "_OST/Cubix Tron/Cubix! The Show!/Theme Song (Remake, Looping Version).ogg")
		end
		if currentCostume == "DLC-FESTIVE-CHRISTMASTREE" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "EXPLODINGTNT" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "GEORGENOTFOUNDYT" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "HANGOUTYOSHIGUYYT" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "KARLJACOBSYT" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ALEX" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-CAPTAINTOAD" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-FNF-BOYFRIEND" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-FNF-GIRLFRIEND" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-FRISK" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-HEROBRINE" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-IMPOSTOR" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ITSJERRY" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ITSHARRY" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-KERALIS" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-KRIS" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-MARIO" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-NOELLE-DELTARUNE" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-NOTCH" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-PATRICK" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-RALSEI" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SONIC" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SPIDERMAN" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SPONGEBOB" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SQUIDWARD" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-SUSIE-DELTARUNE" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-TAILS" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "MC-ZOMBIE" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "QUACKITYYT" then
			Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
			Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
			Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		end
		if currentCostume == "SEE-MC-EVILME" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-GERANIUM" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-LEWBERTLUSSIEBACK" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-LILIJUCIEBACK" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-MIMIJUCIEBACK" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-RONDAVIS" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SHENICLE" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SHELLEYKIRK" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SHERBERTLUSSIEBACK" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SPENCER2" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-SPENCEREVERLY" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "SEE-MC-TIANELY" then
			Audio.MusicChange(1, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(2, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(3, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(7, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(8, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(11, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(12, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
			Audio.MusicChange(13, "_OST/Spencer Everly/Spencer! The Show!/Theme Song/Theme Song (Looped Version).ogg")
		end
		if currentCostume == "TOMMYINNITYT" then
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
		if currentCostume == "SMA3" then
			Audio.MusicChange(1, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(2, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(3, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(7, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(8, "_OST/Super Mario Advance 3/Overworld.ogg")
			Audio.MusicChange(11, "_OST/Super Mario Advance 3/Flower Garden.ogg")
			Audio.MusicChange(12, "_OST/Super Mario Advance 3/Training Course.ogg")
			Audio.MusicChange(13, "_OST/Super Mario Advance 3/Training Course.ogg")
		end
	end
end

function malcmusic.onEvent(eventName)
	if eventName == "MarioChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Overworld.spc|0;g=2.5")
	end
	if eventName == "LuigiChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if eventName == "PeachChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Subspace.spc|0;g=2.5")
	end
	if eventName == "ToadChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario Bros 2/Overworld.spc|0;g=2.5")
	end
	if eventName == "LinkChar" then
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
	if eventName == "WarioChar" then
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
	if eventName == "BowserChar" then
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
	if eventName == "BombChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
		Audio.MusicChange(13, "_OST/Bomberman GB - OST.gbs|0;g=1.7")
	end
	if eventName == "MegaChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
		Audio.MusicChange(13, "_OST/Mega Man 10 - OST.nsf|7;g=1.7")
	end
	if eventName == "ZeldaChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Legend of Zelda - A Link to the Past/24 Meeting the Maidens.spc|0;g=2.5")
	end
	if eventName == "RosaChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if eventName == "SamusChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Metroid - Zero Mission/Brinstar.ogg")
		Audio.MusicChange(13, "_OST/Metroid - Zero Mission/Brinstar.ogg")
	end
	if eventName == "UncleChar" then
		Audio.MusicChange(1, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(2, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(3, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(7, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(8, "_OST/Me and Larry City/Main Theme.ogg")
		Audio.MusicChange(11, "_OST/Me and Larry City/Overworld (New Super Mario Bros.).spc|0;g=2.7")
		Audio.MusicChange(12, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
		Audio.MusicChange(13, "_OST/Super Mario Bros 3/Bonus Game.spc|0;g=2.7")
	end
	if eventName == "RinkaChar" then
		Audio.MusicChange(1, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(2, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(3, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(7, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(8, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(11, "_OST/Minecraft/mc03_mce_earth.ogg")
		Audio.MusicChange(12, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
		Audio.MusicChange(13, "_OST/Minecraft/mc02_mc_toysonatear.ogg")
	end
	if eventName == "SnakeChar" then
		Audio.MusicChange(1, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(2, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(3, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(7, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(8, "_OST/Metal Gear - OST.nsf|8;g=2")
		Audio.MusicChange(11, "_OST/Metal Gear - OST.nsf|7;g=2")
		Audio.MusicChange(12, "_OST/Metal Gear - OST.nsf|6;g=2")
		Audio.MusicChange(13, "_OST/Metal Gear - OST.nsf|6;g=2")
	end
	if eventName == "YoshiChar" then
		Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(3, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(11, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(12, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
		Audio.MusicChange(13, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
	end
	if eventName == "KlonoaChar" then
		Audio.MusicChange(1, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(2, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(3, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(7, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(8, "_OST/Klonoa (Wii)/113 - Eriko Imura - Melancholy Soldier.ogg")
		Audio.MusicChange(11, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
		Audio.MusicChange(12, "_OST/Klonoa (Wii)/122 - Kanako Kakino - Count Three.ogg")
		Audio.MusicChange(13, "_OST/Klonoa (Wii)/217 - Hiroshi Okubo - The Ring.ogg")
	end
	if eventName == "StageGenoside" then
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