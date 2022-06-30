--[[~~~~~~     ~~ ~~~~~~~ ~~          ~~~ ~~~        ~~ ~~~~~~~~ ~~~
																				
___________       .__       .__        	
\__    ___/_  _  _|__|______|  |       	
  |    |  \ \/ \/ /  \_  __ \  |       	
  |    |   \     /|  ||  | \/  |__     	
  |____|    \/\_/ |__||__|  |____/     	
                                       	
  _________            .__        __   	
 /   _____/ ___________|__|______/  |_ 	
 \_____  \_/ ___\_  __ \  \____ \   __\	
 /        \  \___|  | \/  |  |_> >  |  	
/_______  /\___  >__|  |__|   __/|__|  	
        \/     \/         |__|									   by Mego.
														Follow me on Twitter: @MegoZ_
																1.5.0 (for SMBX2 b4)
~~~~~~  ~~~~~~      ~~~~~~~~~~~~~    ~~~~~~~~~~~~~~~~       ~~~~~~~~

you don't need to read this this is just fun to write

Description:

	This script makes the player able to twirl in mid-air like in New Super Mario Bros. Wii/U with a slight change, you can gain extra height if you twirl at the peak of a jump!
		Press the Alt-Jump/Spin in mid-air to do so. Variables and their uses are in line 110.
	
	Warning: This is my first script project and I'm trying to learn with it, I accept any feedback to improve and optimize this script!
		Use this freely in your level/episode, but do not delete the credits off the file. You can delete the changelog.

Changelog:
-- 1.1.0 --
	-You can no longer twirl while standoing on NPCs.
	-Improved frames in animation.

-- 1.2.0 --
	-You can no longer twirl while spinning.
	-You can no longer twirl while in a forced animation.


-- 1.3.0 --
	-Code completly rewritten because it sucked.
	-Removed debug mode.
	-You won't be able to twirl for 12 ticks after interacting with certain objects. (can be changed with twirl.mountCooldown = number)
	-Added 2 player support through indexes and keys.
	-Removed twirling support from characters that are not Mario, Luigi or Toad.

-- 1.3.1 --
	-Fixed audio directory.
	-Added Peach support. Alongside with Wario, Zelda, Rosalina, and Uncle Broadsword.
	-Animation framerate adjusted from 4 ticks per frame down to 3 ticks per frame (can be changed with twirl.animFrameSpeed = number)
	-Readded and improved debug mode
	-Organized a bit the comments in the code.

-- 1.4.0 --
	-Rewrote the whole code, again...
	-Shortened the code and simplifed some stuff.
	-Twirling cooldown was reduced to 30 ticks.
	-Changed directory name to TwirlAssets. Sound file name is now called "twirl.mp3" as well.
	-Removed debug mode.
	-You can no longer duck while or after doing a twirl. (Thoughts on this one? It didn't bother me.)

--1.4.1 --
	-You can now duck after doing a twirl again.
	-Debug mode re-implemented (Can be shown with twirl.debug == false/true)
	-Increased the time you cannot twirl after jumping out of a yoshi/other mounts from 12 to 25 ticks. (Can be changed with twirl.mountCooldown = number)
	-You can only twirl once when you have the leaf or a tanookie suit powerup.
	-You can no longer twirl when falling having the leaf or a tanookie suit powerup.
	-You can no longer twirl after respawning.
	-You can no longer twirl after taking the mega mushroom.

--1.5.0 -- (Current)
	-You can no longer twirl after clearing a level.
	-Added "twirl.descent" and "twirl.impulsePercent".
	-Twirling when having negative Y speed will descent you .5 upwards more than the previous update (can be changed with twirl.descent = number)
	-Twirling when having positive Y speed will reset your impulsePercent to 1.5% of your impulsePercent speed (can be changed with twirl.impulsePercent = number)
	-You can no longer twirl when you are in a forced state.
	-Fixed a bug in which you couldn't twirl again after you twirl and instantly grab a vine.
	-Fixed a bug in which you are able to twirl after death.
	-Fixed a bug in which you couldn't twirl after exiting Yoshi (Related to the forced state field. Accidentally put 122 instead of 0x122 with player.mem function, ended up changing to v.forcedState since it's better for the eye ^^ )
	NOTE: I think this might be polished enough, no bugs should appear from now on, please report any bug you see.
	
TOPROCRASTINATE ~~~~   ~  ~~~~ ~~ 
-Rosalina do luma wahoo spin.
~~~~~~  ~~~~~~ ~~~~  ~ ~  ~~~  ~~    

Enjoy!
....
...

]]

local twirl = {}

local playeranim = require("playerAnim")
local extrasounds = require("extrasounds")
local smasbooleans = require("smasbooleans")
local smastables = require("smastables")

function twirl.onInitAPI()
	registerEvent(twirl, "onTick", "onTick")
end

local twirlSfx = extrasounds.id[154]

function countTable(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

twirl.frames = {15,-1,13, 1} -- Player's animation frames in order, negative numbers represent the player's opposite facing direction, see theses charts:		i.imgur.com/1dnW3g3.png		/or/	 i.imgur.com/PBBLe0y.png
twirl.animFrameSpeed = 3 -- How many onDraw frames for each animation frame
twirl.cooldown = 28 -- Cooldown after making a twirl
twirl.mountCooldown = 20 -- Cooldown after exiting a mount or an illegal move.
twirl.descent = 1.5 -- Adds impulse when twirling while falling, negative would impulse you upwards
twirl.impulsePercent = 1.5 --Takes a percent of your current Y speed and adds it
twirl.extraImpulse = 1.45 --Adds impulse when twirling while ascending
twirl.showMeDebug = false --Show live variables on screen

howManyFrames = countTable(twirl.frames)
twirlAnim = playeranim.Anim (twirl.frames, twirl.animFrameSpeed)
onPressTimer = {0, 0}
postCantTwirl = {1, 1}--bruh
cantTwirl = {false, false}
theyProlyDed = {false,nil}

function twirl.onTick()
	for k,v in ipairs(Player.get()) do
		if v.count() == 2 then
			--New Boolean
			if v.deathTimer > 0 then
				theyProlyDed[k] = true
			end
			if v.forcedState == 6 then
				theyProlyDed[k] = false
			end
		else
			--New Boolean
			if v.deathTimer > 0 then
				theyProlyDed[1] = true
			end
			if v.forcedState == 6 then
				theyProlyDed[k] = false
			end
		end
		--Can't do these while attempting to input a twirl.

		if postCantTwirl[k] > 0 or
		v:mem(0x50, FIELD_BOOL) or --spinjumping
		v.mount ~= 0 or
		v:mem(0x34, FIELD_BOOL) or -- water/quicksand
		v:mem(0x44, FIELD_BOOL) or -- riding rainbow shell
	  (v.character == 3 and v:mem(0x1C, FIELD_WORD) ~= 0) or -- peach and hover timer
		v.character == 5 or
		v.character == 6 or
		v.character == 8 or
		v.character == 9 or
		v.character == 10 or
		v.character == 12 or
		v.character == 16 or
		v.character == 14 or 
		v.forcedState ~= 0 or -- forced state
		(v:mem(0x146, FIELD_WORD) ~= 0) or -- bottom collision
		(v:mem(0x48, FIELD_WORD) ~= 0) or -- slope collison
		v.deathTimer > 0 or
		v.isMega or
		v.speedY > 0 and (v.powerup == 4 or v.powerup == 5) or --fall with leaf/tanookie
		v.holdingNPC ~= nil or -- holding npc
		v.standingNPC ~= nil or
		Level.winState() ~= 0 or --won the level
		theyProlyDed[k] or
		v.climbing or
        smasbooleans.cantTwirl == true or
        table.icontains(smastables._noLevelPlaces,Level.filename()) == true then
			cantTwirl[k] = true
		end

		--jumping out of mount/something cooldown thingy (postCantTwirl/mountCooldown)
		if v:mem(0x50, FIELD_BOOL) or -- spinjumping
		v.climbing or
		v:mem(0x34, FIELD_BOOL) or -- on water/quicksand
		v:mem(0x44, FIELD_BOOL) or -- riding rainbow shell
		v.mount > 0 or
		v:mem(0x146, FIELD_WORD) < 0 then
			postCantTwirl[k] = 0
		end
		if postCantTwirl[k] > -1 and postCantTwirl[k] <= twirl.mountCooldown+1 then --aaaand reset back to -1, maybe 1 if you wanna too why not, idc, it works
			postCantTwirl[k] = postCantTwirl[k] + 1
		else
			postCantTwirl[k] = -1
		end

		--the twirl™
		if v.keys.altJump and not cantTwirl[k] and onPressTimer[k] < twirl.cooldown or
		((v.powerup == 4 or v.powerup == 5) and v.keys.altJump and not cantTwirl[k]) then
			onPressTimer[k] = onPressTimer[k] + 1
			v:mem(0x04, FIELD_WORD, 1)
			if onPressTimer[k] == 1 then
				twirlAnim:play(v) --animation
				Audio.playSFX(twirlSfx) --sound
				if v.speedY > 0 then
					v.speedY = twirl.descent
				end
				if v.speedY <= 0 then
					v.speedY = v.speedY - (v.speedY % twirl.impulsePercent)-twirl.extraImpulse
				end
			end
			
			if onPressTimer[k] >= twirl.animFrameSpeed*howManyFrames then
				twirlAnim:stop(v)
				v:mem(0x04, FIELD_WORD, 0)
			end

		elseif not v.keys.altJump and onPressTimer[k] > 0 and not cantTwirl[k] then
			onPressTimer[k] = onPressTimer[k] + 1
			if onPressTimer[k] >= twirl.animFrameSpeed*howManyFrames then
				twirlAnim:stop(v)
				v:mem(0x04, FIELD_WORD, 0)
			end
		else
			onPressTimer[k] = 0
			cantTwirl[k] = false
			twirlAnim:stop(v)
			v:mem(0x04, FIELD_WORD, 0)
		end
		if v.deathTimer ~= 0 then
			onPressTimer[k] = 2
		end

--Peach
		if v:mem(0xF0, FIELD_WORD) == 3 or v:mem(0xF0, FIELD_WORD) == 11 then
			if player.altJumpKeyPressing then
				player.altJumpKeyPressing = false -- it causes her to hover, we don't want that, she can hover with regular jump. temporary solution, may break other movement related scripts.
			end
		end

		if twirl.showMeDebug then
			Text.print("On Press Timer: "..onPressTimer[1], 10, 100)
			Text.print("Post Cant Twirl: "..postCantTwirl[1], 10, 125)
			Text.print("Can't Twirl: "..tostring(cantTwirl[1]), 10, 150)
			Text.print("0x04 (Disable Ducking): "..v:mem(0x04, FIELD_WORD), 10, 175)
			Text.print("AltJump: "..tostring(v.keys.altJump), 10, 200)
			Text.print("Y speed: "..v.speedY, 10, 225)
			Text.print("Forced State: "..v.forcedState, 10, 250)
			Text.print("P1 Proly Dead: "..tostring(theyProlyDed[1]), 10, 275)
			Text.print("P2 Proly Dead: "..tostring(theyProlyDed[2]), 10, 300)

			Text.print("Counted Table: "..tostring(howManyFrames), 10, 350)
		end
	end
end

--(v:mem(122, FIELD_WORD) > 0) or -- forced state
--(v:mem(0x124, FIELD_DFLOAT) > 0) or -- forced state timer
--so this is how adhd looks likes
return twirl