--megaluavania2.lua (v1.0)
--By Spencer Everly

local megaluavania2 = {}

--**NORMAL SETTINGS**
megaluavania2.battleEnemies = {} --For putting together enemies to start battles with

--For setting the battle themes, we will conduct a table below.
megaluavania2.battleThemes = {
    [1] = "megaluavania/mus_battlemain.ogg", --Normal battle theme for most enemies
    [2] = "megaluavania/mus_battle1.ogg", --Undertale battle theme, original
    [3] = "megaluavania/mus_boss1.ogg" --Undertale Toriel battle theme
}

--**GRAPHICS**
megaluavania2.graphics = {} --To let graphics be in it's own table

--Act Button
megaluavania2.graphics.actButton[1] = Graphics.loadImageResolved("megaluavania/act.png")
megaluavania2.graphics.actButton[2] = Graphics.loadImageResolved("megaluavania/act2.png")

--BG
megaluavania2.graphics.background = Graphics.loadImageResolved("megaluavania/background.png")

--Bars
megaluavania2.graphics.bar[1] = Graphics.loadImageResolved("megaluavania/bar.png")
megaluavania2.graphics.bar[2] = Graphics.loadImageResolved("megaluavania/bar2.png")

--Fight Button
megaluavania2.graphics.fight[1] = Graphics.loadImageResolved("megaluavania/fight.png")
megaluavania2.graphics.fight[2] = Graphics.loadImageResolved("megaluavania/fight2.png")

--Fight target
megaluavania2.graphics.fightTarget = Graphics.loadImageResolved("megaluavania/fighttarget.png")

--Game Over
megaluavania2.graphics.gameOverText = Graphics.loadImageResolved("megaluavania/gameover.png")

--Green Circle
megaluavania2.graphics.greenCircle = Graphics.loadImageResolved("megaluavania/greencircle.png")

--Hearts
for i = 0,6 do
    megaluavania2.graphics.heart = {}
    megaluavania2.graphics.heart[i] = Graphics.loadImageResolved("megaluavania/heart"..tostring(i)..".png") --Heart graphics, normal
end
megaluavania2.graphics.heartBreak = Graphics.loadImageResolved("megaluavania/heartbreak.png")
for i = 0,1 do
    megaluavania2.graphics.heartGTFO = {}
    megaluavania2.graphics.heartGTFO[i] = Graphics.loadImageResolved("megaluavania/heartGTFO"..tostring(i)..".png") --Heart graphics, normal
end
for i = 0,3 do
    megaluavania2.graphics.heartShards = {}
    megaluavania2.graphics.heartShards[i] = Graphics.loadImageResolved("megaluavania/heartshard"..tostring(i)..".png") --Heart graphics, normal
end

--HP Text
megaluavania2.graphics.HPText = Graphics.loadImageResolved("megaluavania/HP.png")

--Item Button
megaluavania2.graphics.item[1] = Graphics.loadImageResolved("megaluavania/item.png")
megaluavania2.graphics.item[2] = Graphics.loadImageResolved("megaluavania/item2.png")

--Mercy Button
megaluavania2.graphics.mercy[1] = Graphics.loadImageResolved("megaluavania/mercy.png")
megaluavania2.graphics.mercy[2] = Graphics.loadImageResolved("megaluavania/mercy2.png")

--Miss Text
megaluavania2.graphics.missText = Graphics.loadImageResolved("megaluavania/miss.png")

for i = 0,1 do
    megaluavania2.graphics.playerShield = {}
    megaluavania2.graphics.playerShield[i] = Graphics.loadImageResolved("megaluavania/shield"..tostring(i)..".png") --Player's shield
end

for i = 0,5 do
    megaluavania2.graphics.playerSwing = {}
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
for i = 1,2 do
    megaluavania2.soundFX.menu[i] = SFX.open("megaluavania/menu"..tostring(i)..".ogg")
end
megaluavania2.soundFX.swing = SFX.open("megaluavania/swing.ogg")
megaluavania2.soundFX.typeWriter = SFX.open("megaluavania/typewriter.ogg")

return megaluavania2