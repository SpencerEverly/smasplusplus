local Time = {}

local fiveweekendmonths={"January","March","May","July","August","October","December"}
local daysPerMonth={31+28,31+30,31+30,31,31+30,31+30,0}

--Below are the usual day/month/year counts
function Time.day()
    return os.date("*t").day
end

function Time.month()
    return os.date("*t").month
end

function Time.year()
    return os.date("*t").year
end

function Time.hour()
    return os.date("*t").hour
end

function Time.minute()
    return os.date("*t").min
end

function Time.second()
    return os.date("*t").sec
end

function Time.tomorrow()
    return os.date("*t").day + 1
end

function Time.yesterday()
    return os.date("*t").day - 1
end

function Time.weekend()
    return os.date("%A")
end

function Time.dayJulian() --Converts Gregorian day to the Julian day.
    return (os.date("*t").day - 13)
end

function Time.julianNumber() --A number telling the real Julian time
    return (os.time() / 86400) + 2440587.5
end

function Time.easterDivision(x, y) --This is used for calculating Easter
    return math.floor(x / y)
end

function Time.easterYear(year) --This will calculate Easter Sunday, and show the day and time after saving it to SaveData.
    local G = year % 19
    local C = Time.easterDivision(year, 100)
    local H = (C - Time.easterDivision(C, 4) - Time.easterDivision((8 * C + 13), 25) + 19 * G + 15) % 30
    local I = H - Time.easterDivision(H, 28) * (1 - Time.easterDivision(29, H + 1)) * (Time.easterDivision(21 - G, 11))
    local J = (year + Time.easterDivision(year, 4) + I + 2 - C + Time.easterDivision(C, 4)) % 7
    local L = I - J
    local month = 3 + Time.easterDivision(L + 40, 44)
    SaveData.eastermonth = month
    SaveData.easterday = L + 28 - 31 * Time.easterDivision(month, 4)
    return "Easter Sunday is on "..SaveData.eastermonth.."/"..SaveData.easterday.."."
end

function Time.easterMonth(year) --This will calculate Easter Sunday, and return the month.
    local G = year % 19
    local C = Time.easterDivision(year, 100)
    local H = (C - Time.easterDivision(C, 4) - Time.easterDivision((8 * C + 13), 25) + 19 * G + 15) % 30
    local I = H - Time.easterDivision(H, 28) * (1 - Time.easterDivision(29, H + 1)) * (Time.easterDivision(21 - G, 11))
    local J = (year + Time.easterDivision(year, 4) + I + 2 - C + Time.easterDivision(C, 4)) % 7
    local L = I - J
    return 3 + Time.easterDivision(L + 40, 44)
end

function Time.easterDay(year) --This will calculate Easter Sunday, and return the day.
    local G = year % 19
    local C = Time.easterDivision(year, 100)
    local H = (C - Time.easterDivision(C, 4) - Time.easterDivision((8 * C + 13), 25) + 19 * G + 15) % 30
    local I = H - Time.easterDivision(H, 28) * (1 - Time.easterDivision(29, H + 1)) * (Time.easterDivision(21 - G, 11))
    local J = (year + Time.easterDivision(year, 4) + I + 2 - C + Time.easterDivision(C, 4)) % 7
    local L = I - J
    local month = 3 + Time.easterDivision(L + 40, 44)
    return L + 28 - 31 * Time.easterDivision(month, 4)
end

function Time.leapYear(y) --This detects the Leap Year.
    return y % 4 == 0 and y % 100 ~= 0 or y % 400 == 0
end

function Time.dayOfWeek(m, d, y) --Returns a the day of the week of the specified date.
    local t = os.time({month = m, day = d, year = y})
    return os.date("%A", t)
end

function Time.lastWeekday(wday, month, year) --Returns the last weekday of the month and year.
    local monthLength, day = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    if Time.leapYear(year) then monthLength[2] = 29 end
    day = monthLength[month]
    while Time.dayOfWeek(month, day, year) ~= wday do day = day - 1 end
    return day
end

function Time.findFiveWeekendsOfMonth(year)
    local list={}
    local startday=((year-1)*365+math.floor((year-1)/4)-math.floor((year-1)/100)+math.floor((year-1)/400))%7
 
    for i,v in ipairs(daysPerMonth) do
        if startday==4 then list[#list+1]=fiveweekendmonths[i] end
            if i==1 and year%4==0 and year%100~=0 or year%400==0 then
                startday=startday+1
            end
        startday=(startday+v)%7
    end
    return list
end

return Time