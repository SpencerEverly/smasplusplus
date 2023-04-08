--megaluavania2.lua (v1.0)
--By Spencer Everly

local megaluavania2 = {}

local textplus = require("textplus")

--**NORMAL SETTINGS**
megaluavania2.enabled = true --Whether the system is enabled or not.
megaluavania2.nameOfCharacter = "Frisk" --The name of the character.
megaluavania2.battleEnemies = {} --For putting together enemies to start battles with
--For setting the battle themes, we will conduct a table below.
megaluavania2.battleThemes = {
    [1] = "megaluavania/mus_battlemain.ogg", --Normal battle theme for most enemies
    [2] = "megaluavania/mus_battle1.ogg", --Undertale battle theme, original
    [3] = "megaluavania/mus_boss1.ogg" --Undertale Toriel battle theme
}
megaluavania2.inBattle = false --True if in battle
megaluavania2.blackScreenActive = false --Black screen boolean
megaluavania2.battleScreenBGActive = false --Battle screen background boolean
megaluavania2.isHeartBlinking = false --Whether the heart is blinking or not
megaluavania2.heartOpacity = 1 --For the heart blinking thing
megaluavania2.heartBlinkRate = lunatime.toTicks(0.06) --The blink rate for the heart
megaluavania2.heartBlinkTimer = 0 --Timer for heart blinking
megaluavania2.heartBlinkChanger = 1 --Time changer for heart blinking

megaluavania2.exitFadeOut = 1 --For the exit fade out screen
megaluavania2.battleFadeOut = 1 --For the battle fade out sequence

local enemyInVersusWith --NPC to verse with

megaluavania2.battleStartHeartCoordinateX = 0 --Coordinates for the heart in the starting animation.
megaluavania2.battleStartHeartCoordinateY = 0

megaluavania2.phase = {
    BATTLE_NONE = 0,
    BATTLE_INTRO = 1,
    BATTLE_INTRO2 = 2,
    BATTLE_ACTIVE = 3,
    BATTLE_LOST = 4,
    BATTLE_RAN = 5,
    BATTLE_FADEOUTEXIT = 6,
}

megaluavania2.choiceMarker = {
    CHOICE_FIGHT = 1,
    CHOICE_ACT = 2,
    CHOICE_ITEM = 3,
    CHOICE_MERCY = 4,
}

megaluavania2.phaseInitated = megaluavania2.phase.BATTLE_NONE --Phase initated for several things
megaluavania2.timer1 = 0 --Timer for events=
megaluavania2.minimalPriority = -3 --Minimum priority for drawing stuff

--**FONTS**

megaluavania2.font = {}

megaluavania2.font.determination = textplus.loadFont("littleDialogue/font/determination.ini")
megaluavania2.font.determinationYellow = textplus.loadFont("littleDialogue/font/determinationYellow.ini")
megaluavania2.font.dotumChe = textplus.loadFont("littleDialogue/font/dotumChe.ini")
megaluavania2.font.damage = textplus.loadFont("littleDialogue/font/damage.ini")
megaluavania2.font.name = textplus.loadFont("littleDialogue/font/name.ini")

--**GRAPHICS**
megaluavania2.graphics = {} --To let graphics be in it's own table

--Act Button
megaluavania2.graphics.actButton = {}
megaluavania2.graphics.actButton[1] = Graphics.loadImageResolved("megaluavania/act.png")
megaluavania2.graphics.actButton[2] = Graphics.loadImageResolved("megaluavania/act2.png")

--BG
megaluavania2.graphics.background = Graphics.loadImageResolved("megaluavania/background.png")

--Bars
megaluavania2.graphics.bar = {}
megaluavania2.graphics.bar[1] = Graphics.loadImageResolved("megaluavania/bar.png")
megaluavania2.graphics.bar[2] = Graphics.loadImageResolved("megaluavania/bar2.png")

--Fight Button
megaluavania2.graphics.fight = {}
megaluavania2.graphics.fight[1] = Graphics.loadImageResolved("megaluavania/fight.png")
megaluavania2.graphics.fight[2] = Graphics.loadImageResolved("megaluavania/fight2.png")

--Fight target
megaluavania2.graphics.fightTarget = Graphics.loadImageResolved("megaluavania/fighttarget.png")

--Game Over
megaluavania2.graphics.gameOverText = Graphics.loadImageResolved("megaluavania/gameover.png")

--Green Circle
megaluavania2.graphics.greenCircle = Graphics.loadImageResolved("megaluavania/greencircle.png")

megaluavania2.graphics.heart = {}
megaluavania2.graphics.heartGTFO = {}
megaluavania2.graphics.heartShards = {}

--Hearts
for i = 0,6 do
    megaluavania2.graphics.heart[i] = Graphics.loadImageResolved("megaluavania/heart"..tostring(i)..".png") --Heart graphics, normal
end
megaluavania2.graphics.heartBreak = Graphics.loadImageResolved("megaluavania/heartbreak.png")
for i = 0,1 do
    megaluavania2.graphics.heartGTFO[i] = Graphics.loadImageResolved("megaluavania/heartGTFO"..tostring(i)..".png") --Heart graphics, normal
end
for i = 0,3 do
    megaluavania2.graphics.heartShards[i] = Graphics.loadImageResolved("megaluavania/heartshard"..tostring(i)..".png") --Heart graphics, normal
end

--HP Text
megaluavania2.graphics.HPText = Graphics.loadImageResolved("megaluavania/HP.png")

--Item Button
megaluavania2.graphics.item = {}
megaluavania2.graphics.item[1] = Graphics.loadImageResolved("megaluavania/item.png")
megaluavania2.graphics.item[2] = Graphics.loadImageResolved("megaluavania/item2.png")

--Mercy Button
megaluavania2.graphics.mercy = {}
megaluavania2.graphics.mercy[1] = Graphics.loadImageResolved("megaluavania/mercy.png")
megaluavania2.graphics.mercy[2] = Graphics.loadImageResolved("megaluavania/mercy2.png")

--Miss Text
megaluavania2.graphics.missText = Graphics.loadImageResolved("megaluavania/miss.png")

megaluavania2.graphics.playerShield = {}
for i = 0,1 do
    megaluavania2.graphics.playerShield[i] = Graphics.loadImageResolved("megaluavania/shield"..tostring(i)..".png") --Player's shield
end

megaluavania2.graphics.playerSwing = {}
for i = 0,5 do
    megaluavania2.graphics.playerSwing[i] = Graphics.loadImageResolved("megaluavania/swing"..tostring(i)..".png") --Player swing
end

--**SOUNDS**
megaluavania2.soundFX = {} --To let sounds be in it's own table

megaluavania2.soundFX.battleStart = SFX.open("megaluavania/battlestart.ogg")
megaluavania2.soundFX.block = SFX.open("megaluavania/block.ogg")
megaluavania2.soundFX.defaultVoice = SFX.open("megaluavania/defaultvoice.ogg")
megaluavania2.soundFX.dust = SFX.open("megaluavania/dust.ogg")
megaluavania2.soundFX.flee = SFX.open("megaluavania/flee.ogg")
megaluavania2.soundFX.heal = SFX.open("megaluavania/heal.ogg")
megaluavania2.soundFX.heartBoom = SFX.open("megaluavania/heartboom.ogg")
megaluavania2.soundFX.heartBreak = SFX.open("megaluavania/heartbreak.ogg")
megaluavania2.soundFX.hit = SFX.open("megaluavania/hit.ogg")
megaluavania2.soundFX.hurt = SFX.open("megaluavania/hurt.ogg")
megaluavania2.soundFX.love = SFX.open("megaluavania/love.ogg")
megaluavania2.soundFX.menu = {}
for i = 1,2 do
    megaluavania2.soundFX.menu[i] = SFX.open("megaluavania/menu"..tostring(i)..".ogg")
end
megaluavania2.soundFX.swing = SFX.open("megaluavania/swing.ogg")
megaluavania2.soundFX.typeWriter = SFX.open("megaluavania/typewriter.ogg")
megaluavania2.soundFX.beginBattle = SFX.open("_OST/_Sound Effects/snd_tensionhorn_all.ogg")

function megaluavania2.onInitAPI()
    registerEvent(megaluavania2,"onStart")
    registerEvent(megaluavania2,"onTick")
    registerEvent(megaluavania2,"onDraw")
    registerEvent(megaluavania2,"onInputUpdate")
    registerEvent(megaluavania2,"onPlayerHarm")
    registerEvent(megaluavania2,"onNPCHarm")
end

--[[createBattle:

- enemyID = The ID used to for the enemy. This is how you detect which enemy is being used.
- enemyImage = The image used for the enemy, shown in the middle of the screen.
- battleTheme = The theme used for the battle.

]]
function megaluavania2.createBattle(args)
    args.enemyID = args.enemyID or 1
    args.enemyImage = args.enemyImage or "graphics/stock-0.png"
    args.battleTheme = args.battleTheme or megaluavania2.battleThemes[1]
    megaluavania2.battleEnemies[args.enemyID] = {}
    table.insert(megaluavania2.battleEnemies[args.enemyID], {enemyImage = Graphics.loadImageResolved(args.enemyImage)})
    table.insert(megaluavania2.battleEnemies[args.enemyID], {battleTheme = args.battleTheme})
end

function megaluavania2.startBattle(v)
    enemyInVersusWith = v
    megaluavania2.phaseInitated = megaluavania2.phase.BATTLE_INTRO
end

function megaluavania2.endBattle(killedEnemy)
    if killedEnemy == nil then
        killedEnemy = false
    end
    megaluavania2.timer1 = 0
    megaluavania2.phaseInitated = megaluavania2.phase.BATTLE_FADEOUTEXIT
    Misc.unpause()
    megaluavania2.inBattle = false
    megaluavania2.isHeartBlinking = false
    megaluavania2.blackScreenActive = false
    megaluavania2.battleFadeOut = 1
    megaluavania2.exitFadeOut = 1
    if killedEnemy then
        enemyInVersusWith:kill(HARM_TYPE_VANISH)
        --SaveData.frisk.killCount = SaveData.frisk.killCount + 1
    end
    enemyInVersusWith = nil
    Sound.restoreMusic(-1)
    player:mem(0x140, FIELD_WORD, 150)
end

function megaluavania2.drawUI()
    Graphics.drawImageWP(megaluavania2.graphics.background,0,0,1,megaluavania2.minimalPriority + .005) --Background
    textplus.print{text = megaluavania2.nameOfCharacter, x = 63, y = 523, font = megaluavania2.font.name, priority = megaluavania2.minimalPriority + .010} --Character name
    textplus.print{text = SaveData.frisk.hp.." / "..SaveData.frisk.hpMax, x = 369, y = 523, font = megaluavania2.font.name, priority = megaluavania2.minimalPriority + .010} --HP Counter
    textplus.print{text = "LV "..SaveData.frisk.LV, x = 169, y = 523, font = megaluavania2.font.name, priority = megaluavania2.minimalPriority + .010} --LV Counter
end

function megaluavania2.onPlayerHarm(eventObj)
    if megaluavania2.enabled then
        eventObj.cancelled = true
    end
end

function megaluavania2.onNPCHarm(eventObj)
    if megaluavania2.enabled then
        eventObj.cancelled = true
    end
end

function megaluavania2.onTick()
    if megaluavania2.enabled then
        for k,v in ipairs(NPC.get(89)) do
            if Colliders.collide(player, v) and player:mem(0x140, FIELD_WORD) == 0 then
                megaluavania2.startBattle(v)
            end
        end
    end
end

function megaluavania2.onDraw()
    if megaluavania2.enabled then
        if megaluavania2.phaseInitated == megaluavania2.phase.BATTLE_INTRO then
            megaluavania2.timer1 = megaluavania2.timer1 + 1
            if megaluavania2.timer1 == 1 then
                Misc.pause()
                SFX.play(megaluavania2.soundFX.beginBattle)
            end
            if megaluavania2.timer1 >= 64 then
                megaluavania2.timer1 = 0
                megaluavania2.phaseInitated = megaluavania2.phase.BATTLE_INTRO2
            end
        end
        if megaluavania2.phaseInitated == megaluavania2.phase.BATTLE_INTRO2 then
            megaluavania2.blackScreenActive = true
            megaluavania2.timer1 = megaluavania2.timer1 + 1
            if megaluavania2.timer1 == 1 then
                Sound.muteMusic(-1)
                megaluavania2.inBattle = true
                megaluavania2.isHeartBlinking = true
                SFX.play(megaluavania2.soundFX.battleStart)
                megaluavania2.battleStartHeartCoordinateX = (player.x + player.width * 0.5) + camera.x
                megaluavania2.battleStartHeartCoordinateY = (player.y + player.height * 0.5) + camera.y
            end
            if megaluavania2.timer1 <= 45 then
                Graphics.drawImageWP(megaluavania2.graphics.heart[0], megaluavania2.battleStartHeartCoordinateX, megaluavania2.battleStartHeartCoordinateY, megaluavania2.heartOpacity, megaluavania2.minimalPriority + .001)
            end
            if megaluavania2.timer1 >= 64 then
                megaluavania2.phaseInitated = megaluavania2.phase.BATTLE_ACTIVE
                megaluavania2.timer1 = 0
            end
        end
        if megaluavania2.phaseInitated == megaluavania2.phase.BATTLE_ACTIVE then
            megaluavania2.drawUI()
            megaluavania2.timer1 = megaluavania2.timer1 + 1
            if megaluavania2.timer1 == 1 then
                Sound.changeMusic(megaluavania2.battleThemes[1], -1, false)
            end
            if megaluavania2.timer1 <= 20 then
                megaluavania2.battleFadeOut = math.max(0, megaluavania2.battleFadeOut - 0.05)
                Graphics.drawScreen{color = Color.black.. megaluavania2.battleFadeOut,priority = megaluavania2.minimalPriority + .500}
            end
            if megaluavania2.timer1 >= 21 then
                megaluavania2.timer1 = 21
            end
        end
        if megaluavania2.phaseInitated == megaluavania2.phase.BATTLE_FADEOUTEXIT then
            megaluavania2.timer1 = megaluavania2.timer1 + 1
            if megaluavania2.timer1 <= 25 then
                megaluavania2.exitFadeOut = math.max(0, megaluavania2.exitFadeOut - 0.05)
                Graphics.drawScreen{color = Color.black.. megaluavania2.exitFadeOut,priority = megaluavania2.minimalPriority + .500}
            end
            if megaluavania2.timer1 >= 26 then
                megaluavania2.timer1 = 0
                megaluavania2.exitFadeOut = 1
                megaluavania2.phaseInitated = megaluavania2.phase.BATTLE_NONE
            end
        end
        if megaluavania2.blackScreenActive then
            Graphics.drawScreen{color = Color.black, priority = megaluavania2.minimalPriority}
        end
        if megaluavania2.isHeartBlinking then
            megaluavania2.heartBlinkTimer = megaluavania2.heartBlinkTimer + 1
            if megaluavania2.heartBlinkTimer >= megaluavania2.heartBlinkRate then
                megaluavania2.heartBlinkChanger = megaluavania2.heartBlinkChanger + 1
                megaluavania2.heartBlinkTimer = 0
                if megaluavania2.heartBlinkChanger == 1 then
                    megaluavania2.heartOpacity = 1
                elseif megaluavania2.heartBlinkChanger == 2 then
                    megaluavania2.heartOpacity = 0
                elseif megaluavania2.heartBlinkChanger >= 3 then
                    megaluavania2.heartBlinkChanger = 1
                end
            end
        else
            megaluavania2.heartOpacity = 1
            megaluavania2.heartBlinkTimer = 0
        end
    end
end

function megaluavania2.onInputUpdate()
    if megaluavania2.enabled then
        if megaluavania2.phaseInitated == megaluavania2.phase.BATTLE_ACTIVE then
            if player.keys.down == KEYS_PRESSED then
                megaluavania2.endBattle(true)
            end
        end
    end
end

return megaluavania2