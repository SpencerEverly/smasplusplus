local level_dependencies_normal= require("level_dependencies_normal")

--Copy these, they'll be important for changing music throughout rooms. Not copying these WILL throw an "overload" error
local section0 = 0
local section1 = 1
local section2 = 2
local section3 = 3
local section4 = 4
local section5 = 5
local section6 = 6
local section7 = 7
local section8 = 8
local section9 = 9
local section10 = 10
local section11 = 11
local section12 = 12
local section13 = 13
local section14 = 14
local section15 = 15
local section16 = 16
local section17 = 17
local section18 = 18
local section19 = 19
local section20 = 20

function onEvent(eventName)
    if eventName == "BossBeginPart 2" then
        Audio.MusicChange(section5, "_OST/Super Mario Bros 2/King Wart.ogg")
    end
end