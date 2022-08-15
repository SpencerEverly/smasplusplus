--[[

    SMM2 Mario, Luigi, Toad, and Toadette 
    by Cpt. Mono

    SMW Costume code by: MrDoubleA
    Serious tops to the guy for making tons of custom code just for people who prefer SMW sprites, like me! Also for giving me permission to reuse all of that code.
    
    Mario     sprites by: Nintendo, GlacialSiren484, and AwesomeZack
    Luigi      sprites by: Nintendo, GlacialSiren484, AwesomeZack, and MauricioN64
    Toad     sprites by: Nintendo, GlacialSiren484, MauricioN64, Jamestendo64, and LinkStormZ
    Toadette sprites by: Nintendo, GlacialSiren484, Jamestendo64, LinkStormZ, and TheMushRunt
    
    SMW Expanded Sprites (Small, Super, and Fire Forms):                            https://www.spriters-resource.com/custom_edited/mariocustoms/sheet/145359/
    SMW Expanded Sprites (Raccoon, Tanooki, and Hammer Forms):                        https://www.spriters-resource.com/custom_edited/mariocustoms/sheet/149612/
    SMW Expanded Sprites (Ice Luigi, Toad, and Forms):                                https://www.spriters-resource.com/custom_edited/mariocustoms/sheet/161073/
    Toad Map Sprites:                                                                https://www.spriters-resource.com/custom_edited/mariocustoms/sheet/141746/
    Toadette map Sprites:                                                            https://www.spriters-resource.com/custom_edited/mariocustoms/sheet/150676/
    
    And you, for downloading this and giving me a reason to make these!
    
    Original Credits below.

    Mario sprites by: Nintendo, GlacialSiren484, AwesomeZack
    Luigi sprites by: Nintendo, GlacialSiren484, AwesomeZack, MauricioN64
    Toad  sprites by: Nintendo, GlacialSiren484, MauricioN64, Jamestendo64, LinkStormZ

    Super Sheet Part 1:                 https://mfgg.net/index.php?act=resdb&param=02&c=1&id=37883
    Super Sheet Part 2:                 https://mfgg.net/index.php?act=resdb&param=02&c=1&id=38074
    AwesomeZack's Original Mario sheet: https://mfgg.net/index.php?act=resdb&param=02&c=1&id=32929
    AwesomeZack's Original Luigi sheet: https://mfgg.net/index.php?act=resdb&param=02&c=1&id=31073
    Toad map sheet:                     https://mfgg.net/index.php?act=resdb&param=02&c=1&id=37667
    
    
    
    
    
    
    Author's Notes and some Kewl Stuff, I Guess:
    
    If you wanna reuse this, modify it, or do whatever with it, do it! Just make sure to give credit to both me and all of the people listed above.
    
    Whew. This took a lot of work. Like, I spent four or so days straight just making sprites, sprites, and more sprites. But, hey. Toadette's FINALLY playable in a non-janky way!
    I seriously recommend checking out the Tanooki sprite sheet. Not a single frame there is empty! I really learned a lot about how SMBX works doing this.
    
    I plan on making versions for Mario, Luigi, and Toad, too, so be on the lookout for those!
    
    If you catch any bugs, misalignments, or other gaffes, go ahead and tell me immediately! Whether it's through a DM or a reply to the thread, I'll make sure to check!
    
    If there's any "optimize this later" stuff in the code, then I apologize. I really need to get around to cleaning that up.

    Anyways, that's all. I seriously hope that you enjoy playing as these guys as much as I did making them!
    
    By the way, I should probably make something clear. If you wanna reuse literally any of this code, then go for it! If it's a large amount of code, though, don't forget to give credit.
    
    v1.1: Toadette now has a unique animation that plays if you jump while under the effects of a Super Star.
    I figured this would be a good animation to test out, and, given that it works, I'm sure that Toadette and the other characters are going to get a lot of polish as time goes on.
    I'm prooooooobably going to start prioritizing the other characters now, heh.
    
    v1.2: Toad's done! Nice! I'm pretty glad I got him out, since it actually helped me spot a few errors in Toadette's sprites, including a few that I... forgot to document. Oh, well.
    Plus, working on alternate physics was really fun, and I use them all the time now. I might as well give a brief explanation as to why I made them.
    
    You see, SMBX's physics are strange. Instead of making your jump speed relate to the speed you started the jump with, SMBX just polls for your speed every frame and derives your
    jump speed from that. It's super annoying, and has actually gotten me killed while trying to jump onto high ledges quite a few times. Also, bouncing off of an enemy doesn't give
    you max height, and trampolines can give you varying height depending on how fast you're moving. This costume's alternate physics fix these problems, and make jumping in SMBX
    feel more in line with actual Mario games without sacrificing compatibility. At least, I hope.
    
    v1.3: Victory animations! Woot! I've been looking forwards to implementing these into the game, heh. Seeing the victory sprites go unused for so long was a real bummer.
    Thankfully, though, they're finally here. I even got to implement SMA4's World-e victory flip! It looks really smooth, and, to be honest, it's the real reason that the
    star flip frames are here. Also, good lord, getting the SMW animation to work correctly was painful. You see, while I already had animations figured out by now, graphical
    effects weren't really in my domain. In particular, I spent a while trying to get an iris working on my own before just stealing code from warpTransition.lua. From there,
    I had a lot of work to do, like creating an iris effect for the three "magic orb" victory animations, handling victory animations that I'm not supposed to modify, and
    even correcting certain sprites. You see, Toad and Toadette actually received an update to their "failure" sprites in between the SMB3 and NSMB sheets. The problem with
    this is that it meant that I had to manually adjust, like, all of the sprites that weren't already modified. It wasn't really too hard, though, and taught me a little bit
    about how shading works, not that I'll really ever get to use that information. Still, the coding I had to do for this update was preeeeeetty tricky, so I'm glad to have it out.
    Anyways, there's a certain plumber who's been calling my name, so I need to go and update his sprites. More on why I'm saying "update" and not just "set up" after I'm done. ;)
    
    v1.4: Go, Weegee! Luigi's finally made his highly awaited entry into this costume pack! So, I might as well follow up on what I said last update. You see, I actually made Luigi before I even made Toadette.
    Since he didn't have as many extra frames as her, he made for good practice, and helped me ease into the process of managing sprites. Since I already had these sprites, all I needed to do was add a few more
    and I was all set! It's a good thing, too, since it meant that I could get Luigi out as soon as a day after the previous update. Now that I'm done with Luigi, I'm not sure whether I'm going to add Mario
    or focus on giving these characters proper Goomba Shoe sprites, since they'd probably be pretty nice to have. Whatever. I just hope I don't slow down a ton once I'm off of winter break. Oh, and, uh,
    I hope you enjoy the upcoming New Year! Just putting that up there in case I don't get another update out before then.
    
    v1.5: Let's-a go! Mario's here to complete the SMM2 Crew! It feels really nice being able to say that, ha. Now, in case you didn't carefully and deliberately thumb through all of my update posts, this is
    ABSOLUTELY NOT the end of the project. In fact, there is a LOT more that I want to do with it, and that's something that I hope I've been very ***vocal*** about. Regardless, though, seeing all four folders
    just sitting together makes me so happy. Plus, Mario was actually the easiest to do because I did him after finding a paint.net plugin that Enjl made that should REALLY, REALLY be stickied. I have no idea
    why it's not. Basically, it automatically mirrors your sprites for you, meaning that you don't have to worry about doing it manually. This cut down the time it took to implement Mario's sprites by, like,
    two thirds. If it wasn't for all the festivities, chances are, I'd have had him out by the end of New Year's Eve. Unfortunately, it wasn't meant to be. Oh, also, state-dependent death sprites! I've waited for
    so long to implement these, it's not even funny. I've always found it super cool when people made these sprites, since having only Small form death sprites becomes a bit more distracting after you've played
    games like New Super Mario Bros. games. Also, to the four of you besides myself who voted, I sincerely want to say thank you. You guys seriously rock!
    
    v1.6: Spin to win! Update v1.6 is here with subtler improvements to keep your gameplay experience bumpin'! Or, rather, spinning. I know, this isn't what I was alluding to earlier, but I figured that 
    this was pretty important. Anyways, this one's really focused on not only housekeeping and adding gameplay features that I've always wanted to add since day one, but also some features that the people 
    who replied to the thread wanted. PixelHoyte and MECHDRAGON777, this update goes out to the two of you! Oh, and don't worry, TheGameyFireBro105. You'll get your time to shine once I finish the Super Acorn,
    which should be soon, since I finally finished getting this update out. I went ahead and not only added an adjustable blacklist for the custom victory animations that defaultly supports MrDoubleA's custom exits,
    but also made things a little bit less hardcoded, just so that changing the character any of these costumes are applied to is now possible without having to adjust the code. File renaming is still required, but that's
    kind of a given, so it shouldn't be a problem. On a less compatibility-oriented note, Spin Jumping got a major visual overhaul. You now spin at a 50% faster rate, closer to SMM2's animation, and your held item now 
    moves around a lot more. Furthermore, you now bounce off of enemies at your maximum height, so Spin Jumping off of stuff is way more satisfying. Ultimately, Spin Jumping just... feels better. Oh, and I also 
    added Yellow Toad, but I really don't think people care about him. If you do care about him, then please do check out the poll I put up with the release of this update. 
    
    Seriously, thanks for everything, everybody. This project would've never made it so far if it wasn't for your everlasting support, and I'm looking forwards to continuing work on it!
    
    v1.7: I'm still here! This update might be a bit smaller in terms of content, but it's still pretty important. It fixes a lot of bugs that I just sort of... forgot about, most notably the fact that everybody's
    falling animation was misaligned. It wasn't until GlacialSiren484 pointed everything out to me that I fixed it all, actually. I'm a bit upset that I let this go on for so long even though I knew *something* was
    wrong with the falling animation, but I'm just glad that I have it fixed now. Anyways, swimming. Lots of people hate it, and I know why: the lack of control. Okay, I guess the speed at which you move is an important
    factor, too, but that's a crucial part of swimming mechanics. At least, I think. I should really check at some point. Anyways, the point is, that would require levels to be redesigned, so it's not top priority. What
    I *can* do, however, is make movement on the y axis - the axis you're *supposed* to have more control over - feel much better. In other words, SMW swimming *actually* returns! SMBX swimming honestly kind of... sucks.
    The rate at which you can swim is actually capped, making it a very dissatisfying experience. Thankfully, changing that is as easy as constantly setting a value in the player's memory to 0. I also went ahead and
    added an option to bring back the tan that everybody gets in Fire and Hammer form, since Glacial asked me about it over Discord. It looks nice, though it was definitely harder to implement than I thought it would be.
    So, yeah. Just so you guys know, I've been working on the Penguin Suit in the background. I'm going to try my best to get it out before spring (in the nothern hemisphere), since it would be really unfitting if I didn't.
    I'll see you guys in the next update!
]]

local playerManager = require("playerManager")

local costume = {}

costume.SMM2Settings = {
    starJump = true, --Determines whether or not characters spin if they jump while under the effects of a Super Star/Starman. Default: true
    altPhysics = true, --Determines whether or not characters use an alternate physics engine that makes jumping more consistent with the actual Mario games. Default: true
    customVictoryAnimations = true, --Whether or not your character uses custom victory animations. Default: true
    customVictoryAnimationsBlacklist = {0, LEVEL_END_STATE_KEYHOLE, 4096,}, --A list of EndStates that don't have custom animations. Default: {0, LEVEL_END_STATE_KEYHOLE, 4096,}
    victorySafety = false, --Whether or not it's possible to fall into a pit during your victory animation and the SMB3 animation is cut short. Left off by default to avoid risking incompatibility. Default: false
    kickGuard = true, --Whether or not you're prevented from interrupting the kicking animation by shooting a fire/iceball or throwing a hammer. Default: true
    altSpinJumpMechanics = true, --Whether or not you're prevented from turning around during a Spin Jump. Makes the animation noticeably smoother, too. Default: true
    customFireball = true, --Whether or not fireballs use a custom sprite and rotation method more akin to SMM2. Default: true
    altSwimPhysics = true, --Whether or not your physics are different underwater. Default: true
    fireTan = false, --Whether or not your character's skin becomes tanner upon entering Fire or Hammer form. Default: false
    --altSwimHoldPhysics = true, (This one's happening soon. I need to do it now to make sure that it doesn't destroy the Penguin Suit's custom swimming mechanics.)
    --altScoring = true, (This is happening later. At some point, I hope to make the Super Star actually give the player an enemy chain.)
    
    
    
    minJumpSpeed = 5.3, --Determines the minimum possible Y speed that the player can jump with. Default: 5.3
    maxJumpSpeed = 6.5, --Determines the maximum possible Y speed that the player can jump with. Default: 6.5
    fiveJumpSpeed = 5.9, --Determines the amount of Y speed needed to jump 5 blocks high. Reflects the minimum possible Y speed you can jump with if you're moving. Default: 5.9
    defaultMaxSpeed = 6, --The player's default running speed. Here because Clear Pipes mess with Defines.player_runspeed. Default: 6
    springConstant = 0.8, --A constant that's used to make trampolines bounce you faster than regular jumps. It's here so that levels that might need you to bounce off of trampolines while running don't break with altPhysics. Set to 0 to disable it if you don't need it. Default: 0.8
    downSwimSpeed = 1, --The speed at which the player's Y speed will be capped if they press down while they're underwater. Default: 1
    rouletteAirTime = 57, --The amount of time the player remains in the air during the SMB3 Roulette victory animation. Should be synced up to the music. Default: 57
    rouletteJumpTime = 100, --The time it takes before the player jumps during the SMB3 Roulette victory animation. Default: 100
    roulettePoseTime = 45, --The amount of time the player poses for after landing during the SMB3 Roulette victory animation. Default: 40
    victoryFailsafeTimer = 1000, --The amount of time it takes for the softlock failsafe to kick in. Default: 1000
    victoryFailsafeAnimationDelay = 75, --The amount of time it takes to advance through each stage of the animation associated with this failsafe. Default: 75
    giantGatePoseTime = 472, --The time it takes for your character to pose during the SMW victory animation. Default: 472.
    giantGatePoseDuration = 120, --The time for which your character poses during the SMW victory animation. Default: 120.
    giantGateIrisDuration = 98, --The time for which the iris effect will appear during the SMW victory animation. Default: 98
    giantGateStoppingPoint = 10, --The minimum distance your character needs to be from the right edge of screen during their Giant Gate (SMW Goal) victory animation to stop moving, in blocks. Default: 10
    powerStarJingleLength = 185, --The length of time your character will wait before posing during the Power Star victory animation. Default: 70
    powerStarIrisTimer = 300, --The length of time before the iris effect begins during the Power Star victory animation. Default: 300
    magicBallJingleLength = 164, --The length of time your character will wait before posing during the Magic Ball (SMB3 Orb) victory animation. Default: 164
    magicBallIrisTimer = 400, --The length of time before the iris effect begins during the Magic Ball (SMB3 Orb) victory animation. Default: 400
    crystalBallJingleLength = 88, --The length of time your character will wait before posing during the Crystal Ball (SMB2 Orb) victory animation. Default: 88
    crystalBallIrisTimer = 280, --The length of time before the iris effect begins during the Crystal Ball (SMB2 Orb) victory animation. Default: 280
    staticEndIrisInterval = 100, --The amount of time between the two "stages" of the static victory iris transition (zoomed in and fully closed). Default: 100
    staticEndIrisTransitionTime = 10, --The amount of time it takes for the static victory animation iris to resize to its target radius. Default: 10
    staticEndIrisRadius = 48, --The radius of the static victory animation iris in the "zoomed in" stage. Default: 48
    staticEndIrisHangTime = 20, --The amount of time that the iris "hangs" on the "zoomed in" stage. Default: 20
    bowserDefeatedJingleDelay = 460, --The time it takes between defeating SMB3 Bowser and playing the victory sound effect. Default: 460.
    bowserDefeatedPoseDelay = 845, --The time it takes between defeating SMB3 Bowser and starting to pose. Default: 845
    bowserDefeatedIrisTimer = 1065, --The time it takes between defeating SMB3 Bowser and starting the iris animation. Default: 1065
    yoshiIrisAdjustment = 8, --The amount of pixels by which the iris' center location is adjusted up if it occurs while you're on Yoshi. Default: 8
    yoshiIrisAdjustmentSmall = 4, --Same as the last, just for when you're in Small form. Default: 4
}

local irisOffsets = {
    ["SMM2-MARIO"] = 0,
    ["SMM2-LUIGI"] = -2,
    ["SMM2-TOAD"] = 4,
    ["SMM2-TOADETTE"] = 0,
    ["SMM2-YELLOWTOAD"] = 4,
    ["SMM2-MARIOSMALL"] = 0,
    ["SMM2-LUIGISMALL"] = 0,
    ["SMM2-TOADSMALL"] = -1, --Yes, Toad actually does lean to the side by exactly half a pixel in small form.
    ["SMM2-TOADETTESMALL"] = 0,
    ["SMM2-YELLOWTOADSMALL"] = -1,
}

costume.pSpeedAnimationsEnabled = true
costume.yoshiHitAnimationEnabled = true
costume.kickAnimationEnabled = true

costume.hammerID = 171
costume.hammerConfig = {
    gfxwidth = 32,
    gfxheight = 32,
    frames = 8,
    framespeed = 4,
    framestyle = 1,
}



costume.playersList = {}
costume.playerData = {} 

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

if costume.SMM2Settings.customFireball then
    
    local fireballSettings = {
        id = 13,
    
        gfxwidth=18,
        gfxheight=16,
        frames=1,
        framestyle=1,
        }
    
    npcManager.setNpcSettings(fireballSettings)
end

local eventsRegistered = false

local characterList = {"mario", "luigi", "toad", "peach"}
--Please, don't even try putting this over a character besides those four. It's not worth the effort.

local characterSpeedModifiers = {
    [CHARACTER_PEACH] = 0.93,
    [CHARACTER_TOAD]  = 1.07,
}
local characterNeededPSpeeds = {
    [CHARACTER_MARIO] = 35,
    [CHARACTER_LUIGI] = 40,
    [CHARACTER_PEACH] = 80,
    [CHARACTER_TOAD]  = 60,
}
local characterDeathEffects = {
    [CHARACTER_MARIO] = 3,
    [CHARACTER_LUIGI] = 5,
    [CHARACTER_PEACH] = 129,
    [CHARACTER_TOAD]  = 130,
}

local deathEffectFrames = 2

local leafPowerups = table.map{PLAYER_LEAF,PLAYER_TANOOKIE}
local shootingPowerups = table.map{PLAYER_FIREFLOWER,PLAYER_ICE,PLAYER_HAMMER}

local smb2Characters = table.map{CHARACTER_PEACH,CHARACTER_TOAD}


local hammerPropertiesList = table.unmap(costume.hammerConfig)
local oldHammerConfig = {}
local manualJump = false

-- Detects if the player is on the ground, the redigit way. Sometimes more reliable than just p:isOnGround().
local function isOnGround(p)
    return (
        p.speedY == 0 -- "on a block"
        or p:mem(0x176,FIELD_WORD) ~= 0 -- on an NPC
        or p:mem(0x48,FIELD_WORD) ~= 0 -- on a slope
    )
end


local function isSlidingOnIce(p)
    return (p:mem(0x0A,FIELD_BOOL) and (not p.keys.left and not p.keys.right))
end

local function isSlowFalling(p)
    return (leafPowerups[p.powerup] and p.speedY > 0 and (p.keys.jump or p.keys.altJump))
end


local function canBuildPSpeed(p)
    return (
        costume.pSpeedAnimationsEnabled
        and p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount ~= MOUNT_BOOT and p.mount ~= MOUNT_CLOWNCAR
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and p:mem(0x34,FIELD_WORD) == 0 -- underwater
    )
end

local function canFall(p)
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and not isOnGround(p)
        and p.mount == MOUNT_NONE
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x3C,FIELD_BOOL) -- sliding
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and p:mem(0x34,FIELD_WORD) == 0 -- underwater
    )
end

local function canDuck(p)
    return (
        p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount == MOUNT_NONE
        and not p.climbing
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
        and not p:mem(0x3C,FIELD_BOOL) -- sliding
        and not p:mem(0x44,FIELD_BOOL) -- surfing on a rainbow shell
        and not p:mem(0x4A,FIELD_BOOL) -- statue
        and not p:mem(0x50,FIELD_BOOL) -- spin jumping
        and p:mem(0x26,FIELD_WORD) == 0 -- picking up something from the top
        and (p:mem(0x34,FIELD_WORD) == 0 or isOnGround(p)) -- underwater or on ground
        and Level.endState() == 0

        and (
            p:mem(0x48,FIELD_WORD) == 0 -- not on a slope (ducking on a slope is weird due to sliding)
            or (p.holdingNPC ~= nil and p.powerup == PLAYER_SMALL) -- small and holding an NPC
            or p:mem(0x34,FIELD_WORD) > 0 -- underwater
        )
    )
end

local function canHitYoshi(p)
    return (
        costume.yoshiHitAnimationEnabled
        and p.forcedState == FORCEDSTATE_NONE
        and p.deathTimer == 0 and not p:mem(0x13C,FIELD_BOOL) -- not dead
        and p.mount == MOUNT_YOSHI
        and not p:mem(0x0C,FIELD_BOOL) -- fairy
    )
end


local clearPipeHorizontalFrames = table.map{2,42,44}
local clearPipeVerticalFrames = table.map{15}

local function isInClearPipe(p)
    local frame = costume.playerData[p].frameInOnDraw

    return (
        p.forcedState == FORCEDSTATE_DOOR
        and (clearPipeHorizontalFrames[frame] or clearPipeVerticalFrames[frame])
    )
end


local function setHeldNPCPosition(p,x,y)
    local holdingNPC = p.holdingNPC

    holdingNPC.x = x
    holdingNPC.y = y


    if holdingNPC.id == 49 and holdingNPC.ai2 > 0 then -- toothy pipe
        -- You'd think that redigit's pointers work, but nope! this has to be done instead
        for _,toothy in NPC.iterate(50,p.section) do
            if toothy.ai1 == p.idx then
                if p.direction == DIR_LEFT then
                    toothy.x = holdingNPC.x - toothy.width
                else
                    toothy.x = holdingNPC.x + holdingNPC.width
                end

                toothy.y = holdingNPC.y
            end
        end
    end
end

local function handleDucking(p)
    if p.keys.down and not smb2Characters[p.character] and (p.holdingNPC ~= nil or p.powerup == PLAYER_SMALL) and canDuck(p) then
        p:mem(0x12E,FIELD_BOOL,true)

        if isOnGround(p) then
            if p.keys.left then
                p.direction = DIR_LEFT
            elseif p.keys.right then
                p.direction = DIR_RIGHT
            end

            p.keys.left = false
            p.keys.right = false
        end


        if p.holdingNPC ~= nil and p.holdingNPC.isValid then
            local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

            local heldNPCY = (p.y + p.height - p.holdingNPC.height)
            local heldNPCX

            if p.direction == DIR_RIGHT then
                heldNPCX = p.x + settings.grabOffsetX
            else
                heldNPCX = p.x + p.width - settings.grabOffsetX - p.holdingNPC.width
            end

            setHeldNPCPosition(p,heldNPCX,heldNPCY)
        end
    end

    if smb2Characters[p.character] and p.holdingNPC ~= nil and p.holdingNPC.isValid and not isInClearPipe(p) then
        -- Change the held NPC's position for toad
        local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)

        local heldNPCX = p.x + p.width*0.5 - p.holdingNPC.width*0.5 + settings.grabOffsetX
        local heldNPCY = p.y - p.holdingNPC.height + settings.grabOffsetY

        setHeldNPCPosition(p,heldNPCX,heldNPCY)
    end
end

local function handleClimbing(p)
    if p.climbing == true then
        if p.keys.right then
            p.direction = DIR_RIGHT
        elseif p.keys.left then
            p.direction = DIR_LEFT
        end
    end
end

    -- What P-Speed values gets used is dependent on if the player has a leaf powerup
    -- It's also no longer dependent on whether you're holding an item or not.
    -- Oh, and atPSpeed is a function now.
    
local function atPSpeed(p)
    local data = costume.playerData[p]
    if (leafPowerups[p.powerup] and p:mem(0x16C,FIELD_BOOL) or p:mem(0x16E,FIELD_BOOL)) or (data.pSpeed >= characterNeededPSpeeds[p.character] and not leafPowerups[p.powerup]) then
        return true
    else
        return false
    end
end
    
local function handleManualJump(p)
    if p:mem(0x11C, FIELD_WORD) >= 19 and p.hasStarman and not atPSpeed(p) then
        manualJump = true
    elseif p:isOnGround() or not p.hasStarman or isSlowFalling(p) then
        manualJump = false
    end
end

local pulling = {}

local function handlePullAnimation(p)
    pulling.p = pulling.p or 0
    if p:mem(0x26, FIELD_WORD) > 0 then
        pulling.p = 2
    elseif pulling.p > 0 then
        pulling.p = pulling.p - 1 
    end
end
--I should really find a way to merge these two functions at some point.

local lastGroundX = {}
local lastJumpChain = {}
local jumpHang = {}
local canJumpAltPhysics = {}

--Default minimum Y speed is 5.3
--Default max Y speed is 6.5
--Minimum needed Y speed to get over 5-block jump is 5.9
--Keep in mind that these should be negative, since upwards is the negative Y direction.
--I also literally just realized that I'm probably just writing to stuff like "altPhysicsJumpTimer.p" and stuff instead of an index per-player. 
--It's a good thing these costumes all go over Mario for now assuming you haven't modified them.
local function checkBlockHit(p,speed)
    local boxHeight = (speed)
    if Block.iterateIntersecting(p.x, p.y-boxHeight, p.x+p.width, p.y) ~= nil then
        for _,currentBlock in Block.iterateIntersecting(p.x, p.y-boxHeight, p.x+p.width, p.y) do
            if table.icontains(Block.SOLID, currentBlock.id) then
                return true
            end
        end
    end
    for _,currentNPC in NPC.iterateIntersecting(p.x, p.y-boxHeight, p.x+p.width, p.y) do
        if NPC.config[currentNPC.id].playerblock and currentNPC ~= p.holdingNPC then
            return true
        end
    end
    return false
end



local function handleJumpPhysics(p)
    --previousY.p = previousY.p or p.y
    --lastGroundX.p = lastGroundX.p or 0
    lastJumpChain.p = lastJumpChain.p or 0
    lastGroundX.p = lastGroundX.p or 0
    local canJump = true
    local dynamicJumpSpeed = math.min(-costume.SMM2Settings.fiveJumpSpeed,-((costume.SMM2Settings.maxJumpSpeed - costume.SMM2Settings.minJumpSpeed)*(math.abs(lastGroundX.p)+math.max(0,p:mem(0x11C, FIELD_WORD)-20)*costume.SMM2Settings.springConstant)/costume.SMM2Settings.defaultMaxSpeed + costume.SMM2Settings.minJumpSpeed))
    
    if p.forcedState ~= 0 or Defines.player_runspeed == 0 then
        jumpHang.p = false
    elseif p:isOnGround() == true or p:mem(0x34, FIELD_BOOL) or p.climbing then
        if p:mem(0x148, FIELD_WORD) == 2 or p:mem(0x14A, FIELD_WORD) == 2 then
            lastGroundX.p = 0
        else
            lastGroundX.p = math.min(math.abs(p.speedX),Defines.player_runspeed)*math.sign(p.speedX)
        end
    elseif p:mem(0x11C, FIELD_WORD) > 0 or jumpHang.p and not checkBlockHit(p, -dynamicJumpSpeed) then
        if p:mem(0x14A, FIELD_WORD) == 0 and p.speedY < 0 and p.forcedState == 0 then
            jumpHang.p = true
            if not checkBlockHit(p, -dynamicJumpSpeed) then
                if p:mem(0x11C, FIELD_WORD) == 0 and not p:isOnGround() then
                    jumpHang.p = false
                    if p.speedY >= -costume.SMM2Settings.maxJumpSpeed then
                        if lastGroundX.p == 0 then
                            p.speedY = -costume.SMM2Settings.minJumpSpeed
                        else
                            p.speedY = dynamicJumpSpeed
                        end
                    end
                    lastGroundX.p = costume.SMM2Settings.defaultMaxSpeed
                elseif lastGroundX.p == 0 then
                    p.y = p.y - p.speedY - (costume.SMM2Settings.minJumpSpeed)
                else
                    p.y = p.y - p.speedY + dynamicJumpSpeed
                end
            end
        else
            jumpHang.p = false
        end
        --[[if lastJumpChain.p ~= p:mem(0x56, FIELD_WORD) or p:mem(0x11C, FIELD_WORD) > 20 then
            lastGroundX.p = costume.SMM2Settings.defaultMaxSpeed
        end]]
    end
    lastJumpChain.p = p:mem(0x56, FIELD_WORD)
end

local levelEndAnimationTimer = 0
local levelEndAnimationState = 0
local levelEndHitGround = false

local function handleVictoryLeniency(p) --I literally just stole this function from the Mario Challenge and removed the line that plays a sound effect. 
    if (storedEndState ~= 0 or Level.endState() ~= 0) and p.y > Section(player.section).boundary.bottom then
        player.speedY = -player.speedY - 3;
        player.y = player.y - 4;
    end
end

--Something tells me that I can just use regular variables for this because only one player is ever present after the level ends. However, for now, I'll just leave things as-is.
local previousX = {}
local goalX = {}
local SMB3Jump = {}
local storedEndState = 0 --Negative end states are static (don't involve player movement); positives, dynamic (require player to move off screen).
local overrideDefaultEndState = true
local staticVictoryDurations = {costume.SMM2Settings.magicBallJingleLength, costume.SMM2Settings.crystalBallJingleLength, costume.SMM2Settings.powerStarJingleLength}


local function handleVictoryAnimation(p)
    previousX.p = previousX.p or p.x
    
    if levelEndAnimationTimer >= 1 then
        levelEndAnimationTimer = levelEndAnimationTimer + 1
        local keyList = {"up", "right", "left", "down", "run", "altRun", "jump", "altJump", "dropItem", "pause"}
        --Something tells me that there's a way of just going straight through player.keys, but I've been here for far too long, and this solution is elegant enough.
        for _,n in ipairs(keyList) do
            p.keys[tostring(n)] = KEYS_UP
        end
        p:mem(0x140, FIELD_WORD, 2)
    end
    
    
    if not table.contains(costume.SMM2Settings.customVictoryAnimationsBlacklist, Level.endState()) and overrideDefaultEndState then
        levelEndAnimationTimer = 1
        storedEndState = Level.endState()
        Level.endState(0)
        goalX.p = p.x
        p.speedY = 0
        p.speedX = 0
        local staticEnds = {2, 4, 6}
        if table.contains(staticEnds, storedEndState) then
            storedEndState = storedEndState/-2
        end
    end

    
    if storedEndState == LEVEL_END_STATE_TAPE then --Giant Gate
        local rightEdge = Section(p.section).boundary.right
        local stoppingPoint = math.max((rightEdge + goalX.p)/2, rightEdge - costume.SMM2Settings.giantGateStoppingPoint * 32)
        if (levelEndAnimationTimer <= costume.SMM2Settings.victoryFailsafeTimer and levelEndAnimationTimer > costume.SMM2Settings.giantGatePoseTime + costume.SMM2Settings.giantGatePoseDuration) or levelEndAnimationTimer < costume.SMM2Settings.giantGatePoseTime then
            levelEndAnimationState = 0
            p.keys.right = KEYS_DOWN
        end
        if p.x >= stoppingPoint and levelEndAnimationTimer < costume.SMM2Settings.giantGatePoseTime then
            levelEndAnimationState = 0
            p.direction = DIR_LEFT
            p.speedX = 0
            p.keys.right = KEYS_UP
        elseif levelEndAnimationTimer >= costume.SMM2Settings.giantGatePoseTime and levelEndAnimationTimer <= costume.SMM2Settings.giantGatePoseTime + costume.SMM2Settings.giantGatePoseDuration then --Pose!
            levelEndAnimationState = 2
            p.speedX = 0
            p.keys.right = KEYS_UP
        elseif levelEndAnimationTimer > costume.SMM2Settings.giantGatePoseTime + costume.SMM2Settings.giantGatePoseDuration then
            
            overrideDefaultEndState = false
            Level.finish(7, true)
        end

        
        
        
    elseif storedEndState == LEVEL_END_STATE_ROULETTE then --SMB3 Goal
        local landingTime = costume.SMM2Settings.rouletteJumpTime + costume.SMM2Settings.rouletteAirTime
        if levelEndAnimationTimer <= costume.SMM2Settings.victoryFailsafeTimer then
            p.keys.right = KEYS_DOWN
        end
        if player:isOnGround() or player.mount == MOUNT_BOOT then
            if levelEndAnimationTimer == costume.SMM2Settings.rouletteJumpTime then
                levelEndAnimationState = 5
                p.speedY = -Defines.player_grav*costume.SMM2Settings.rouletteAirTime/2
            elseif levelEndAnimationTimer >= landingTime and levelEndAnimationTimer <= landingTime + costume.SMM2Settings.roulettePoseTime then
                levelEndAnimationState = 2
                p.speedX = 0
                p.keys.right = KEYS_UP
            end
        end
        if levelEndAnimationTimer > landingTime + costume.SMM2Settings.roulettePoseTime then
            levelEndAnimationState = 0
            overrideDefaultEndState = false
            Level.finish(1, true)
        end
        
        
        
    elseif storedEndState == LEVEL_END_STATE_GAMEEND then
        if levelEndAnimationTimer == 310 then
            p.speedY = -5
        end
        if levelEndAnimationTimer == costume.SMM2Settings.bowserDefeatedJingleDelay then
            SFX.play(45)
        end
        if levelEndAnimationTimer >= costume.SMM2Settings.bowserDefeatedPoseDelay then
            levelEndAnimationState = 2
        end
    end

    
    if storedEndState ~= 0 and storedEndState ~= LEVEL_END_STATE_GAMEEND then
        if p:isOnGround() then
            levelEndHitGround = true
            if levelEndAnimationTimer > costume.SMM2Settings.victoryFailsafeTimer then
                if levelEndAnimationTimer > costume.SMM2Settings.victoryFailsafeTimer + costume.SMM2Settings.victoryFailsafeAnimationDelay then
                    levelEndAnimationState = 3
                else
                    levelEndAnimationState = 0
                    p.direction = DIR_LEFT
                end
                Level.endState(0)
            end
        elseif not levelEndHitGround then
            p.speedX = 0
            p.x = previousX.p
            p:mem(0x50, FIELD_BOOL, 0)
        end
    end
    if storedEndState < 0 then --Static victory animations
        if levelEndAnimationTimer > staticVictoryDurations[-storedEndState] then
            if p.speedX == 0 then
                levelEndAnimationState = 2
            else
                levelEndAnimationState = 0
            end
        elseif levelEndAnimationTimer == staticVictoryDurations[-storedEndState] then
            if p.mount == MOUNT_NONE then
                p.direction = DIR_RIGHT
            end
            levelEndAnimationState = 2
        end
    end
    previousX.p = p.x
    
    if levelEndAnimationTimer > costume.SMM2Settings.victoryFailsafeTimer + costume.SMM2Settings.victoryFailsafeAnimationDelay*2 and p.deathTimer == 0 and storedEndState ~= LEVEL_END_STATE_GAMEEND then
        Level.finish(storedEndState)
        overrideDefaultEndState = false
    end
end

local function handleVictoryTransition(p)
    if p.deathTimer == 0 then
        if storedEndState == 7 and levelEndAnimationTimer >= costume.SMM2Settings.giantGatePoseTime + costume.SMM2Settings.giantGatePoseDuration then --Temporary condition
            GIANTGATE_IRIS_OUT(p)
        elseif storedEndState < 0 or storedEndState == LEVEL_END_STATE_GAMEEND then
            STATICEND_IRIS_OUT(p)
        end
    end
end

local spinJumpDirection = {}
local hasSpinJumped = {}
local storedDirection = {}
local spinJumpTimer = {}

local function handleSpinJumping(p)
    hasSpinJumped[p] = hasSpinJumped[p] or 0
    storedDirection[p] = storedDirection[p] or p.direction
    spinJumpTimer[p] = spinJumpTimer[p] or 0
    if p:mem(0x50, FIELD_BOOL) then
        hasSpinJumped[p] = 2
    end
    if hasSpinJumped[p] > 0 then
        if spinJumpTimer[p] == 16 then
            spinJumpTimer[p] = 1
        else
            spinJumpTimer[p] = spinJumpTimer[p] + 1
        end
        --p:mem(0x52, FIELD_WORD, 0)
        if p.keys.left and not p.keys.right then
            storedDirection[p] = DIR_LEFT
        elseif p.keys.right and not p.keys.left then
            storedDirection[p] = DIR_RIGHT
        end
        p.direction = storedDirection[p]
        if p.holdingNPC ~= nil and p.holdingNPC.isValid then
            local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)
            local heldNPCY = p.y + settings.grabOffsetY - (p.holdingNPC.height - 32)
            --local heldNPCY = (p.y + settings.grabOffsetY)
            local heldNPCX
            if spinJumpTimer[p] >= 13 then
                heldNPCX = p.x + p.width/2 - p.holdingNPC.width/2
            elseif spinJumpTimer[p] >= 9 then
                if p.direction == DIR_LEFT then
                    heldNPCX = p.x + settings.grabOffsetX
                else
                    heldNPCX = p.x + p.width - settings.grabOffsetX - p.holdingNPC.width
                end
            elseif spinJumpTimer[p] >= 5 then
                heldNPCX = p.x + p.width/2 - p.holdingNPC.width/2
            else
                if p.direction == DIR_RIGHT then
                    heldNPCX = p.x + settings.grabOffsetX
                else
                    heldNPCX = p.x + p.width - settings.grabOffsetX - p.holdingNPC.width
                end
            end
            setHeldNPCPosition(p,heldNPCX,heldNPCY)
        end
    else
        spinJumpTimer[p] = 0
    end
    hasSpinJumped[p] = hasSpinJumped[p] - 1
    storedDirection[p] = p.direction
end

local function handleSwimPhysics(p)
    if p:mem(0x38, FIELD_WORD) > 1 then
        p:mem(0x38, FIELD_WORD, 1)
    end
    if (p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0) and p.keys.down and p.speedY < -costume.SMM2Settings.downSwimSpeed then
        p.speedY = -costume.SMM2Settings.downSwimSpeed
    end
end

--[[local function handleSpinItem(p)
    if p:mem(0x50, FIELD_BOOL) and p.holdingNPC ~= nil and p.holdingNPC.isValid then
        local settings = PlayerSettings.get(playerManager.getBaseID(p.character),p.powerup)
    
        local heldNPCY = (p.y + p.height - p.holdingNPC.height)
        local heldNPCX

        if p.keys.right then
            heldNPCX = p.x + settings.grabOffsetX
        else
            heldNPCX = p.x + p.width - settings.grabOffsetX - p.holdingNPC.width
        end
        setHeldNPCPosition(p,heldNPCX,p.y + p.height - p.holdingNPC.height)
    end
end]]
local victoryAnimations = {nil, "pose", "failure", nil, "jumpStar"}



-- This table contains all the custom animations that this costume has.
-- Properties are: frameDelay, loops, setFrameInOnDraw
local animations = {
    -- Big only animations
    walk = {3,2,26, frameDelay = 6},
    run  = {18,17,16, frameDelay = 6},
    walkHolding = {10,9,47, frameDelay = 6},
    fall = {5},
    duckSmall = {8},
    jump = {4},

    -- Small only animation
    walkSmall = {2,10,44, frameDelay = 6},
    runSmall  = {16,9,17, frameDelay = 6},
    walkHoldingSmall = {6,14,47, frameDelay = 6},

    fallSmall = {7},
    jumpSmall = {3},

    -- SMB2 characters (like toad)
    walkSmallSMB2 = {2,10,44, frameDelay = 6},
    runSmallSMB2  = {16,9,17, frameDelay = 6},
    walkHoldingSmallSMB2 = {8,9, frameDelay = 6},


    -- Some other animations
    lookUp = {32},
    lookUpHolding = {33},

    duckHolding = {27},

    yoshiHit = {35,45, frameDelay = 6,loops = false},

    kick = {34, frameDelay = 12,loops = false},

    runJump = {19},

    clearPipeHorizontal = {19, setFrameInOnDraw = true},
    clearPipeVertical = {38, setFrameInOnDraw = true},


    -- Fire/ice/hammer things
    shootGround = {11,11,11, frameDelay = 6,loops = false},
    shootAir    = {11,11,11, frameDelay = 6,loops = false},
    shootWater  = {11,11,11, frameDelay = 6,loops = false},


    -- Leaf things
    slowFall = {11,39,5, frameDelay = 5},
    runSlowFall = {19,20,21, frameDelay = 5},
    fallLeafUp = {11},
    runJumpLeafDown = {21},    --Adjust code to remove this later.
    tailExtend = {-14}, --Learned this trick while combing through the Cape Feather's code. Frame -x is essentially Frame x, just facing the opposite direction.
    tailSwing = {15, 14, 13, frameDelay = 5},


    -- Swimming
    swimIdle = {40},
    swimStroke = {43,44,44, frameDelay = 4,loops = false},
    swimStrokeSmall = {42,43,43, frameDelay = 4,loops = false},


    -- To fix a dumb bug with toad's spinjump while holding an item
    spinjumpSidwaysToad = {8},
    
    
    --Extra frames for necessary animations
    normalPipeVertical = {38},
    jumpHolding = {48},
    fallHolding = {37},
    doorEntry = {50},
    spinJump = {14, 15, -14, 13, frameDelay = 2},
    spinJumpSmall = {46, 15, -46, 13, frameDelay = 2},
    runJumpDown = {21},
    duckDown = {49},
    climb = {25, -25, frameDelay = 8},
    climbIdle = {41},
    runHolding = {36, 42, 46, frameDelay = 6},
    runHoldingSmall = {6,14,47, frameDelay = 6},
    pull = {23,22, frameDelay = 6},
    pose = {-28},
    turnCrouch = {-7},
    turnCrouchSmall = {-8},
    failure = {55},
    failureShoe = {55},
    failureYoshi = {80},
    poseYoshi = {29},
    jumpStar = {51, 52, 53, 54, frameDelay = 2},
    turnCrouchYoshi = {-31},
    poseShoe = {28},
    poseYoshi = {29},
    jumpStarYoshi = {30},
    jumpStarShoe = {1},
    
    --I promise you that I'll find a way to add in unique sprites for characters while they're in Goomba Shoes. For now, though, the victory animations on their own have taken long enough.
}

local function handleVanillaPowerup(p) --Yes, this does imply that I'm going to be making custom powerups for these costumes. :D
    local powerupList = {9, 184, 185, 34, 169, 170, 0} --anotherpowerup.lua basically always sets this value to something, so I *should* be able to get away with including 0 in this list for the sake of preventing checkpoints from breaking it.
    if table.contains(powerupList, p:mem(0x46, FIELD_WORD)) or p.powerup == PLAYER_SMALL then
        return true
    else
        return false
    end
end
-- This function returns the name of the custom animation currently playing.
local function findAnimation(p)
    local data = costume.playerData[p]
    
    if levelEndAnimationState ~= 0 then
        if p.mount == MOUNT_YOSHI then
            return victoryAnimations[levelEndAnimationState] .. "Yoshi"
        elseif p.mount == MOUNT_BOOT then
            return victoryAnimations[levelEndAnimationState] .. "Shoe"
        else
            return victoryAnimations[levelEndAnimationState]
        end
    end
    
    if pulling.p == 2 then
        return "pull"
    elseif pulling.p == 1 then
        return nil --Let's just see if this works out...
    end
    
    if p:mem(0x164, FIELD_WORD) >= 1 and not p:mem(0x50, FIELD_BOOL) then
        if p:mem(0x164, FIELD_WORD) >= 5 and p:mem(0x164, FIELD_WORD) <= 19 then
            return "tailSwing"
        else
            return "tailExtend"
        end
    end
    
    if p:mem(0x12E, FIELD_BOOL) and p.speedY > 0 and not p:isOnGround() and p.holdingNPC == nil and p.mount == MOUNT_NONE then
     return "duckDown"
    end


    if p.deathTimer > 0 then
        return nil
    end


    if p.mount == MOUNT_YOSHI then
        if canHitYoshi(p) then
            -- Moving your arm to direct Yoshi to extend his tongue
            -- I really wish that Nintendo redid the animation in SMM2. Even though Yoshi doesn't "flinch" as much, it still looks a bit like your character is hitting Yoshi. Plus, Yoshi abuse is out of character for literally anybody here.
            if data.yoshiHitTimer == 1 then
                return "yoshiHit"
            elseif (data.currentAnimation == "yoshiHit" and not data.animationFinished) then
                return data.currentAnimation
            end
        end

        return nil
    elseif p.mount ~= MOUNT_NONE then
        return nil
    end


    if p.forcedState == FORCEDSTATE_PIPE then
        local warp = Warp(p:mem(0x15E,FIELD_WORD) - 1)

        local direction
        if p.forcedTimer == 0 then
            direction = warp.entranceDirection
        else
            direction = warp.exitDirection
        end

        if direction == 2 or direction == 4 then
            if p.powerup == PLAYER_SMALL then
                return "walkSmall",0.5
            else
                return "walk",0.5
            end
        else
            return "normalPipeVertical"
        end

        return nil
    elseif p.forcedState == FORCEDSTATE_DOOR then
        -- Clear pipe stuff (it's weird)
        local frame = data.frameInOnDraw

        if clearPipeHorizontalFrames[frame] then
            return "clearPipeHorizontal"
        elseif clearPipeVerticalFrames[frame] then
            return "clearPipeVertical"
        else
            return "doorEntry"
        end


        return nil
    elseif p.forcedState ~= FORCEDSTATE_NONE then
        return nil
    end

    if p:mem(0x50,FIELD_BOOL) then
        if p.powerup == PLAYER_SMALL then
            return "spinJumpSmall"
        else
            return "spinJump"
        end
    end

    if p:mem(0x26,FIELD_WORD) > 0 then
        return nil
    end


    if p:mem(0x12E,FIELD_BOOL) then
        if smb2Characters[p.character] then
            return nil
        elseif p.holdingNPC ~= nil then
            return "duckHolding"
        elseif p.powerup == PLAYER_SMALL then
            return "duckSmall"
        else
            return nil
        end
    end


    
    if p:mem(0x3C,FIELD_BOOL) -- sliding
    or p:mem(0x44,FIELD_BOOL) -- shell surfing
    or p:mem(0x4A,FIELD_BOOL) -- statue
    or p:mem(0x164,FIELD_WORD) ~= 0 -- tail attack
    then
        return nil
    end


    if p:mem(0x50,FIELD_BOOL) then -- spin jumping
        if smb2Characters[p.character] and p.frame == 5 then -- dumb bug
            return "spinjumpSidwaysToad"
        else
            return nil
        end
    end

    local isShooting = (p:mem(0x118,FIELD_FLOAT) >= 100 and p:mem(0x118,FIELD_FLOAT) <= 118 and shootingPowerups[p.powerup])

    if p.climbing then
        if p.keys.down or p.keys.left or p.keys.right or p.keys.up then
            return "climb"
        else
            return "climbIdle"
        end
    end

    -- Kicking
    if data.currentAnimation == "kick" and not data.animationFinished then
        return data.currentAnimation
    elseif p.holdingNPC == nil and data.wasHoldingNPC and costume.kickAnimationEnabled then -- stopped holding an NPC
        if not smb2Characters[p.character] then
            local e = Effect.spawn(75, p.x + p.width*0.5 + p.width*0.5*p.direction,p.y + p.height*0.5)

            e.x = e.x - e.width *0.5
            e.y = e.y - e.height*0.5
        end

        return "kick"
    end


    if isOnGround(p) then
        -- GROUNDED ANIMATIONS --


        if isShooting then
            return "shootGround"
        end


        -- Skidding
        if (p.speedX < 0 and p.keys.right) or (p.speedX > 0 and p.keys.left) or p:mem(0x136,FIELD_BOOL) then
            return nil
        end


        -- Walking
        if p.speedX ~= 0 and not isSlidingOnIce(p) then
            local walkSpeed = math.max(0.35,math.abs(p.speedX)/Defines.player_walkspeed)

            local animationName

            if atPSpeed(p) then
                animationName = "run"
            else
                animationName = "walk"
            end
            
            if p.holdingNPC ~= nil then
                    animationName = animationName.. "Holding"
            end
            
            if p.powerup == PLAYER_SMALL then
                animationName = animationName.. "Small"

                if smb2Characters[p.character] then
                    animationName = animationName.. "SMB2"
                end
            end


            return animationName,walkSpeed
        end

        -- Looking up
        if p.keys.up then
            if p.holdingNPC == nil then
                return "lookUp"
            else
                return "lookUpHolding"
            end
        end

        return nil
    elseif (p:mem(0x34,FIELD_WORD) > 0 and p:mem(0x06,FIELD_WORD) == 0) and p.holdingNPC == nil then -- swimming
        -- SWIMMING ANIMATIONS --


        if isShooting then
            return "shootWater"
        end
        

        if p:mem(0x38,FIELD_WORD) == 1 then
            if p.powerup == PLAYER_SMALL then
                return "swimStrokeSmall"
            else
                return "swimStroke"
            end
        elseif ((data.currentAnimation == "swimStroke" and p.powerup ~= PLAYER_SMALL) or (data.currentAnimation == "swimStrokeSmall" and p.powerup == PLAYER_SMALL)) and not data.animationFinished then
            return data.currentAnimation
        end

        return "swimIdle"
    else
        -- AIR ANIMATIONS --
        
        if p.hasStarman and p.holdingNPC == nil and manualJump and costume.SMM2Settings.starJump then
            return "jumpStar"
        end
        
        if isShooting then
            return "shootAir"
        end
        

        if p:mem(0x16E,FIELD_BOOL) then -- flying with leaf
            return nil
        end

        
        if atPSpeed(p) and p.holdingNPC == nil then
            if isSlowFalling(p) then
                return "runSlowFall"
            elseif p.speedY > 0 then
                if leafPowerups[p.powerup] then
                    return "runJumpLeafDown"
                else 
                    return "runJumpDown"
                end
            else
                return "runJump"
            end
        end

        if p.speedY <= 0 then
            if p.holdingNPC ~= nil then
                return "jumpHolding"
            else
                return nil
            end
        end
        
        if isSlowFalling(p) then --Blah, blah, blah, optimize this at some point.
            if p.holdingNPC == nil then
                return "slowFall"
            else
                return "fallHolding"
            end
        elseif data.useFallingFrame then
                if p.holdingNPC ~= nil then
                    return "fallHolding"
                elseif p.powerup == PLAYER_SMALL and not smb2Characters[p.character] then
                    return "fallSmall"
                else
                    return "fall"
                end
        end

        return nil
    end
end


function costume.onInit(p)
    -- If events have not been registered yet, do so
    if not eventsRegistered then
        registerEvent(costume,"onTick")
        registerEvent(costume,"onTickEnd")
        registerEvent(costume,"onDraw")
        registerEvent(costume,"onPlayerKill")
        registerEvent(costume,"onPostNPCHarm")
        
        Audio.sounds[30].sfx = Audio.SfxOpen("costumes/mario/SMM2-YellowToad/pause.ogg")
        Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SMM2-YellowToad/got-star.ogg")
        
        eventsRegistered = true
    end


    -- Add this player to the list
    if costume.playerData[p] == nil then
        costume.playerData[p] = {
            currentAnimation = "",
            animationTimer = 0,
            animationSpeed = 1,
            animationFinished = false,

            forcedFrame = nil,

            frameInOnDraw = p.frame,


            pSpeed = 0,
            useFallingFrame = false,
            wasHoldingNPC = false,
            yoshiHitTimer = 0,
        }

        table.insert(costume.playersList,p)
    end

    --Modify the default death effect
    --Definitely gotta make this costume more friendly to swapping over to another character at some point...
    local deathEffect = characterDeathEffects[p.character]
    Graphics.sprites.effect[deathEffect].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/misseffect.png"))
    if costume.SMM2Settings.fireTan then
        Graphics.sprites.mario[3].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-3tan.png"))
        Graphics.sprites.mario[6].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-6tan.png"))
    end
    
    -- Edit the hammer a little
    if costume.hammerID ~= nil and (p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI) then
        local config = NPC.config[costume.hammerID]

        for _,name in ipairs(hammerPropertiesList) do
            oldHammerConfig[name] = config[name]
            config[name] = costume.hammerConfig[name]
        end
    end
end

function costume.onCleanup(p)
    -- Remove the player from the list
    if costume.playerData[p] ~= nil then
        costume.playerData[p] = nil

        local spot = table.ifind(costume.playersList,p)

        if spot ~= nil then
            table.remove(costume.playersList,spot)
        end
    end

    -- Clean up the hammer edit
    if costume.hammerID ~= nil and (p.character == CHARACTER_MARIO or p.character == CHARACTER_LUIGI) then
        local config = NPC.config[costume.hammerID]

        for _,name in ipairs(hammerPropertiesList) do
            config[name] = oldHammerConfig[name] or config[name]
            oldHammerConfig[name] = nil
        end
    end
end

local hasStompedNPC = {}

local function handleSpinBounce(p)
    if hasStompedNPC[p] and costume.SMM2Settings.altSpinJumpMechanics then
        p:mem(0x11C, FIELD_WORD, Defines.jumpheight_bounce)
        hasStompedNPC[p] = nil
    end
end

function costume.onTick()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]

        handleDucking(p)
        if costume.SMM2Settings.customVictoryAnimations then
            handleVictoryAnimation(p)
            if costume.SMM2Settings.victorySafety then
                handleVictoryLeniency(p)
            end
        end
        handleSpinBounce(p)
        handleSpinJumping(p)
        
        -- Yoshi hitting (creates a small delay between hitting the run button and yoshi actually sticking his tongue out)
        if canHitYoshi(p) then
            if data.yoshiHitTimer > 0 then
                data.yoshiHitTimer = data.yoshiHitTimer + 1

                if data.yoshiHitTimer >= 8 then
                    -- Force yoshi's tongue out
                    p:mem(0x10C,FIELD_WORD,1) -- set tongue out
                    p:mem(0xB4,FIELD_WORD,0) -- set tongue length
                    p:mem(0xB6,FIELD_BOOL,false) -- set tongue retracting

                    SFX.play(50)

                    data.yoshiHitTimer = 0
                else
                    p:mem(0x172,FIELD_BOOL,false)
                end
            elseif p.keys.run and p:mem(0x172,FIELD_BOOL) and (p:mem(0x10C,FIELD_WORD) == 0 and p:mem(0xB8,FIELD_WORD) == 0 and p:mem(0xBA,FIELD_WORD) == 0) then
                p:mem(0x172,FIELD_BOOL,false)
                data.yoshiHitTimer = 1
            end
        else
            data.yoshiHitTimer = 0
        end
        
        --Kicking (prevents the player from firing fireballs or throwing hammers or boomerangs during the kick animation.) -Cpt. Mono
        if data.currentAnimation == "kick" and costume.SMM2Settings.kickGuard then
        p:mem(0x160, FIELD_WORD, 2)
        end
        
        --Warp Entry (makes the player face right if they're entering a door or a pipe. Retains accuracy to SMM2 and lets me use frame 50 for door entry.) -Cpt. Mono
        if data.currentAnimation == "doorEntry" or data.currentAnimation == "normalPipeVertical" then
        p.direction = DIR_RIGHT
        p:mem(0x50, FIELD_BOOL, false)
        end
    end
end

function costume.onTickEnd()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]

        handleClimbing(p)
        handleDucking(p)
        handleManualJump(p)
        if storedEndState == 0 then
            if costume.SMM2Settings.altPhysics then
                handleJumpPhysics(p)
            end
            if costume.SMM2Settings.altSwimPhysics then
                handleSwimPhysics(p)
            end
        end
        handlePullAnimation(p)
        handleSpinJumping(p)
        --freezeCamera()
        
        -- P-Speed
        if canBuildPSpeed(p) then
            if isOnGround(p) then
                if math.abs(p.speedX) >= Defines.player_runspeed*(characterSpeedModifiers[p.character] or 1) then
                    data.pSpeed = math.min(characterNeededPSpeeds[p.character] or 0,data.pSpeed + 1)
                else
                    data.pSpeed = math.max(0,data.pSpeed - 0.3)
                end
            end
        else
            data.pSpeed = 0
        end

        -- Falling
        if canFall(p) then
            data.useFallingFrame = (data.useFallingFrame or p.speedY > 0)
        else
            data.useFallingFrame = false
        end

        -- Yoshi hit (change yoshi's head frame)
        if data.yoshiHitTimer >= 3 and canHitYoshi(p) then
            local yoshiHeadFrame = p:mem(0x72,FIELD_WORD)

            if yoshiHeadFrame == 0 or yoshiHeadFrame == 5 then
                p:mem(0x72,FIELD_WORD, yoshiHeadFrame + 2)
            end
        end



        -- Find and start the new animation
        local newAnimation,newSpeed,forceRestart = findAnimation(p)

        if data.currentAnimation ~= newAnimation or forceRestart then
            data.currentAnimation = newAnimation
            data.animationTimer = 0
            data.animationFinished = false

            if newAnimation ~= nil and animations[newAnimation] == nil then
                error("Animation '".. newAnimation.. "' does not exist")
            end
        end

        data.animationSpeed = newSpeed or 1

        -- Progress the animation
        local animationData = animations[data.currentAnimation]

        if animationData ~= nil then
            local frameCount = #animationData

            local frameIndex = math.floor(data.animationTimer / (animationData.frameDelay or 1))

            if frameIndex >= frameCount then -- the animation is finished
                if animationData.loops ~= false then -- this animation loops
                    frameIndex = frameIndex % frameCount
                else -- this animation doesn't loop
                    frameIndex = frameCount - 1
                end

                data.animationFinished = true
            end

            p.frame = animationData[frameIndex + 1]
            data.forcedFrame = p.frame

            data.animationTimer = data.animationTimer + data.animationSpeed
        else
            data.forcedFrame = nil
        end


        -- For kicking
        data.wasHoldingNPC = (p.holdingNPC ~= nil)
        
        --[[ Handle Spin Jump stuff
        if p:mem(0x50, FIELD_BOOL) then
            p.frame = p.frame*(storedDirection[p])*p.direction
        end]]
        
    end
end

local altFrames = false

local fireflowers = {14, 182, 183}
local iceflowers = {264, 277}

local function initialize(v,data)
    data.initialized = true
    data.rotation = 0
end

local tanPowerups = {3, 6}
local tanReserveIDs = {14, 182, 183, 170}

local function handleTanPowerup(p)
    if not costume.SMM2Settings.fireTan then return ".png" end
    if p:mem(0x46, FIELD_WORD) == 0 then
        if table.contains(tanPowerups, p.powerup) then return "tan.png"
        else return ".png" end
    elseif table.contains(tanReserveIDs, p:mem(0x46, FIELD_WORD)) then return "tan.png"
    else return ".png" end
end

function costume.onPlayerKill(o,p)
    for _,p in ipairs(costume.playersList) do
        local deathEffect = characterDeathEffects[p.character]
        local fileEnding = handleTanPowerup(p)
        
        if handleVanillaPowerup(p) then
            Graphics.sprites.effect[deathEffect].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/miss"..tostring(p.powerup)..fileEnding))
        elseif table.contains(iceflowers, p:mem(0x46, FIELD_WORD)) then --These extra checks are necessary because of some plans I mentioned over by the handleVanillaPowerup function.
            Graphics.sprites.effect[deathEffect].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/miss7.png"))
        elseif table.contains(fireflowers, p:mem(0x46, FIELD_WORD)) then
            Graphics.sprites.effect[deathEffect].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/miss3"..fileEnding))
        end
    end
end

--Powerup state 7 (Ice Form) is in there because the Ice Flower ignores the tan setting.

function costume.onDraw()
    for _,p in ipairs(costume.playersList) do
        local data = costume.playerData[p]
        data.frameInOnDraw = p.frame


        local animationData = animations[data.currentAnimation]

        if (animationData ~= nil and animationData.setFrameInOnDraw) and data.forcedFrame ~= nil then
            p.frame = data.forcedFrame
        end
        
        if costume.SMM2Settings.customVictoryAnimations then
            handleVictoryTransition(p)
        end
        
        
        if math.abs(p.frame) >= 51 then
            --if handleVanillaPowerup(p) or table.contains(iceflowers, p:mem(0x46, FIELD_WORD)) or table.contains(fireflowers, p:mem(0x46, FIELD_WORD)) then
            p.frame = p.frame - 50*math.sign(p.frame)
            --end
            --local v = {}
            --v.texture = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/mario-"..tostring(p.powerup).."b.png"))
            --v.frame = p.frame - 50
            --p:render(v)
            if altFrames == false then
                local fileEnding
                
                fileEnding = handleTanPowerup(p)
                
                if handleVanillaPowerup(p) then
                    Graphics.sprites.mario[p.powerup].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..tostring(p.powerup)..fileEnding))
                elseif table.contains(iceflowers, p:mem(0x46, FIELD_WORD)) then --These extra checks are necessary because of some plans I mentioned over by the handleVanillaPowerup function.
                    Graphics.sprites.mario[p.powerup].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-7b.png"))
                elseif table.contains(fireflowers, p:mem(0x46, FIELD_WORD)) then
                    Graphics.sprites.mario[p.powerup].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-3"..fileEnding))
                end
                altFrames = true
            end
        elseif altFrames == true then
                local fileEnding
                
                fileEnding = handleTanPowerup(p)
                
                if handleVanillaPowerup(p) then
                    Graphics.sprites.mario[p.powerup].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-"..tostring(p.powerup)..fileEnding))
                elseif table.contains(iceflowers, p:mem(0x46, FIELD_WORD)) then
                    Graphics.sprites.mario[p.powerup].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-7.png"))
                elseif table.contains(fireflowers, p:mem(0x46, FIELD_WORD)) then
                    Graphics.sprites.mario[p.powerup].img = Graphics.loadImage(Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/"..characterList[p.character].."-3"..fileEnding))
                end
            altFrames = false
        end
    end

    --Handle custom fireballs
    for k,v in ipairs(NPC.get(13)) do
        if not Defines.levelFreeze then
    
            if v.despawnTimer <= 0 then
                v.data.initialized = false
                return
            end
    
            if not v.data.initialized then
                initialize(v,v.data)
            end
    
            v.data.rotation = v.data.rotation + 36*v.direction
        end
        if not (v.despawnTimer <= 0 or v.isHidden or v:mem(0x138, FIELD_WORD)) ~= 0 then
    
            local data = v.data
    
            if not data.initialized then
                initialize(v,data)
            end
    
            local texture = Graphics.sprites.npc[v.id].img
    
            if data.sprite == nil or data.sprite.texture ~= texture then
                data.sprite = Sprite{texture = texture,frames = npcutils.getTotalFramesByFramestyle(v),pivot = Sprite.align.CENTRE} --European spelling, but I'm not gonna question it.
            end
    
            local config = NPC.config[v.id]
    
            data.sprite.x = v.x + v.width*0.5 + config.gfxoffsetx
            data.sprite.y = v.y + v.height - config.gfxheight*0.5 + config.gfxoffsety
            data.sprite.rotation = data.rotation % 360
    
            data.sprite:draw{frame = v.animationFrame+1,priority = -45,sceneCoords = true}
            npcutils.hideNPC(v)
        end
    end
    
    
    -- Change death effects
    if costume.playersList[1] ~= nil then
        local deathEffectID = characterDeathEffects[costume.playersList[1].character]

        for _,e in ipairs(Effect.get(deathEffectID)) do
            e.animationFrame = -999

            local image = Graphics.sprites.effect[e.id].img

            local width = image.width
            local height = image.height / deathEffectFrames

            local frame = math.floor((150 - e.timer) / 8) % deathEffectFrames

            Graphics.drawImageToSceneWP(image, e.x + e.width*0.5 - width*0.5,e.y + e.height*0.5 - height*0.5, 0,frame*height, width,height, -5)
        end
    end
end

function costume.onPostNPCHarm(killedNPC,harmType,culprit)
    if harmType == HARM_TYPE_SPINJUMP and table.ifind(costume.playersList,culprit) then
        hasStompedNPC[culprit] = true
    end
end

local irisOutShader = Shader()
function GIANTGATE_IRIS_OUT(p) --Credit to MrDoubleA for this function. It's based on his iris out function, if it wasn't obvious.
        irisOutShader:compileFromFile(nil,Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/warpTransition_irisOut.frag"))
        local startRadius = math.sqrt(camera.width^2+camera.height^2)
        local irisOutStart = costume.SMM2Settings.giantGatePoseTime + costume.SMM2Settings.giantGatePoseDuration
        local radius = math.max(0,startRadius*((irisOutStart+costume.SMM2Settings.giantGateIrisDuration)-levelEndAnimationTimer)/costume.SMM2Settings.giantGateIrisDuration)
        
        if radius <= 0 then
            Level.finish(7)
        end

        local playerY
        if p.mount == MOUNT_YOSHI then
            if p.powerup == PLAYER_SMALL then
                playerY = p.y - costume.SMM2Settings.yoshiIrisAdjustmentSmall
            else
                playerY = p.y - costume.SMM2Settings.yoshiIrisAdjustment
            end
        else
            playerY = p.y
        end

        applyShader(0,irisOutShader,{center = vector(p.x+(p.width/2)-camera.x,playerY+(p.height/2)-camera.y),radius = radius})

    end

local irisOutStartTimes = {costume.SMM2Settings.magicBallIrisTimer, costume.SMM2Settings.crystalBallIrisTimer, costume.SMM2Settings.powerStarIrisTimer}
function STATICEND_IRIS_OUT(p)
    irisOutShader:compileFromFile(nil,Misc.resolveFile("costumes/"..characterList[p.character].."/"..p:getCostume().."/warpTransition_irisOut.frag"))
    local startRadius = math.sqrt(camera.width^2+camera.height^2)
    local irisOutStart
    if storedEndState < 0 then
        irisOutStart = irisOutStartTimes[-storedEndState]
    else
        irisOutStart = costume.SMM2Settings.bowserDefeatedIrisTimer
    end
    local radius = math.max(0,startRadius*((irisOutStart+costume.SMM2Settings.giantGateIrisDuration)-levelEndAnimationTimer)/costume.SMM2Settings.giantGateIrisDuration)
    local peekIn = SFX.open("costumes/"..characterList[p.character].."/"..p:getCostume().."/smw-peekin.ogg")
    local peekOut = SFX.open("costumes/"..characterList[p.character].."/"..p:getCostume().."/smw-peekout.ogg")
    if levelEndAnimationTimer < irisOutStart then
        radius = startRadius
    elseif levelEndAnimationTimer < irisOutStart + costume.SMM2Settings.staticEndIrisInterval then
        if levelEndAnimationTimer == irisOutStart then
            SFX.play(peekIn)
        end
        radius = math.max(costume.SMM2Settings.staticEndIrisRadius,startRadius*((irisOutStart+costume.SMM2Settings.staticEndIrisTransitionTime)-levelEndAnimationTimer)/costume.SMM2Settings.staticEndIrisTransitionTime)
    else
        if levelEndAnimationTimer == irisOutStart + costume.SMM2Settings.staticEndIrisInterval then
                SFX.play(peekOut)
        end
        radius = math.max(0,costume.SMM2Settings.staticEndIrisRadius*((irisOutStart + costume.SMM2Settings.staticEndIrisInterval + costume.SMM2Settings.staticEndIrisTransitionTime)-levelEndAnimationTimer)/costume.SMM2Settings.staticEndIrisTransitionTime)
    end
        
    if levelEndAnimationTimer > irisOutStart + costume.SMM2Settings.staticEndIrisInterval + costume.SMM2Settings.staticEndIrisTransitionTime + costume.SMM2Settings.staticEndIrisHangTime then
        overrideDefaultEndState = false
        if storedEndState < 0 then
            Level.finish(storedEndState*-2)
        else
            Level.finish(storedEndState)
        end
    end
        
    local playerY
    if p.mount == MOUNT_YOSHI then
        if p.powerup == PLAYER_SMALL then
            playerY = p.y - costume.SMM2Settings.yoshiIrisAdjustmentSmall
        else
            playerY = p.y - costume.SMM2Settings.yoshiIrisAdjustment
        end
    else
        playerY = p.y
    end
    
    local irisOffset
    if p.mount ~= PLAYER_YOSHI then
        if p.powerup == PLAYER_SMALL then
            irisOffset = irisOffsets[p:getCostume().."SMALL"]
        else
            irisOffset = irisOffsets[p:getCostume()]
        end
    else
        irisOffset = 0
    end
    
    applyShader(0,irisOutShader,{center = vector(p.x+(p.width/2)+irisOffset-camera.x,playerY+(p.height/2)-camera.y),radius = radius})


end

local buffer = Graphics.CaptureBuffer(800,600)
local irisOutShader = Shader()
    
function applyShader(priority,shader,uniforms) --Taken from warpTransition.lua with credit for the code going to MrDoubleA and credit for the shader going to Hoeloe.
    buffer:captureAt(priority or 0)
    Graphics.drawScreen{texture = buffer,priority = priority or 0,shader = shader,uniforms = uniforms}
end
    
return costume