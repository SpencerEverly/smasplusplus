---Standardised timer library, used for displaying a countdown timer in the corner of the screen if active.
--@module timer
--@author Enjl

----------------------timer----------------------                                   
-------------Created by Enjl  - 2018-------------
------------Modded by Spencer Everly-------------
---------Simplistic Mario Timer Library----------
--------------For Super Mario Bros X-------------
----------------------v1.2-----------------------

local timer = {}

local oldtimer = require("timer")

timer.audio_hurryup = Audio.SfxOpen(Misc.resolveSoundFile("hurry-up"))

local second = 2500/39

local timer_deathTimer = second * 500
local timer_hurry = false
local timer_hurry_unmutemusic = false

local timer_paused = true
local timer_visible = false

timer.hurryTime = 100
timer.hurryTimeToUnmute = 98

function timer.onEnd()
	if Level.settings.timer.result == LEVEL_TIMER_RESULT_KILL then
		player:kill()
		if Player.count() == 2 then
			player2:kill()
		elseif Player.count() >= 3 then
            for _,p in ipairs(Player.get()) do
                p:kill()
            end
        end
	elseif Level.settings.timer.result == LEVEL_TIMER_RESULT_EVENT then
		triggerEvent("Level Timer - End")
	end
end

--- Retrieves the current value of the timer.
--@treturn number The current value of the timer.
function timer.get()
	return timer_deathTimer;
end

--- Retrieves the current display value of the timer.
--@treturn number The current value of the timer.
function timer.getValue()
	return math.ceil(timer_deathTimer/second)
end

--- Sets the timer to a specific value.
-- @tparam number seconds The value to be saved to the timer (in seconds).
--@tparam[opt=false] bool isFrames Whether the value is specified in frames or seconds.
function timer.set(newValue, isFrames)
	local m = second
	if isFrames then m = 1 end
	timer_deathTimer = (newValue * m)
end

--- Adds a number of seconds or frames to the timer.
-- @tparam number seconds The number of seconds to be added to the timer.
--@tparam[opt=false] bool isFrames Whether the value is specified in frames or seconds.
function timer.add(newValue, isFrames)
	local m = second
	if isFrames then m = 1 end
	timer_deathTimer = timer_deathTimer + (newValue * m)
end

--- Returns the length of a second.
--@treturn number The length of a second.
function timer.getSecondLength()
	return second
end

--- Redefines the length of a second and automatically adjusts the timer to prevent it from skipping.
-- @tparam number value The new length of a second.
function timer.setSecondLength(newValue)
	local oldSecond = second
	second = newValue
	timer_deathTimer = timer_deathTimer * (second / oldSecond)
end

--- Activates the timer. It has two optional arguments.
-- @tparam[opt=500] number time The start value of the timer.
-- @tparam[opt=false] bool isFrames Is it frames or seconds?
function timer.activate(newValue, isFrames)
	timer_paused = false
	timer_visible = true
	if newValue ~= nil then
		timer.set(newValue, isFrames)
	end
end

--- Returns whether the timer is currently counting down.
--@treturn bool The timer's active state.
function timer.isActive()
	return not timer_paused
end

--- Returns whether the timer is currently displayed on-screen.
--@treturn bool Whether the timer is currently visible.
function timer.isVisible()
	return timer_visible
end

--- Hides and pauses the timer.
function timer.deactivate()
	timer_visible = false
	timer_paused = true
end

--- Toggles the timer's paused state.
--@function toggle

--- Sets the timer's paused state.
--@tparam bool pausedState Whether the timer should be paused or not.
function timer.toggle(newValue)
	if newValue then
		timer_paused = newValue
	else
		timer_paused = not timer_paused
	end
end

function timer.onTick()
	if timer_deathTimer > 0 and not timer_paused and not Misc.isPaused() and player:mem(0x13E,FIELD_WORD) == 0 and winState() == 0 and not GameData.winStateActive then
		
		if timer_deathTimer > 0 and player:mem(0x13E,FIELD_WORD) == 0 then
			timer_deathTimer = timer_deathTimer - 1
		end
		
		if timer_deathTimer <= 0 then
			timer.onEnd()
		end
		
        if SMBX_VERSION == VER_SEE_MOD then
            if timer.getValue() <= 100 and timer.getValue() >= 1 and not smasBooleans.inFuzzyMode then
                if smasBooleans.canSpeedUpMusicWhenTimerIsLessThan100 then
                    Audio.MusicSetTempo(1.5)
                    Audio.MusicSetSpeed(1.5)
                end
            end
        end
        
	end
	
	if timer_deathTimer <= timer.hurryTime * second and not timer_hurry then
		SFX.play(timer.audio_hurryup)
		timer_hurry = true
	end
end

function timer.onInitAPI()
	registerEvent(timer, "onTick")
	registerEvent(timer, "onStart")
    
    unregisterEvent(oldtimer, "onStart")
    unregisterEvent(oldtimer, "onTick")
end

function timer.onStart()
	if not isOverworld then
		if(Level.settings.timer and Level.settings.timer.enable) then
			timer.activate(Level.settings.timer.time)
		end
	end
end

return timer