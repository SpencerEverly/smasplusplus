local smasWeather = {}

function smasWeather.doWeatherUpdate()
    if GameData.SMASPlusPlus.misc.weatherIsSet then --This'll be better in the future. For now, it just loads the weather when restarting the game to the start preboot screen, or starting it up every time
        possibleWeather = {"sunny","rain","snow"}
        weatherControl = rng.randomEntry(possibleWeather)
        SaveData.dateplayedweather = weatherControl --Write in a better onetime day function for this
        GameData.SMASPlusPlus.misc.weatherIsSet = false
    end
end

return smasWeather