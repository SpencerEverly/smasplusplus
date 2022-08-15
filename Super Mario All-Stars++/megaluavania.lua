-- megaluavania.lua 2.1
-- By Spinda
-- drawImageRotated by Rednaxela
-- Ported to Beta 4 by Spencer Everly

local megaluavania = {}
local colliders = API.load("colliders")
local rng = API.load("rng")
local playerAnim = API.load("playerAnim")
local textblox = API.load("textblox")
local particles = API.load("particles")
local pausemenu = require("pauseplus")
if not Misc.inMarioChallenge() then
    datetime = require("datetime")
end
local inventory = require("furyinventory")

local cooldown = 0

megaluavania.resourcePath = "megaluavania/"
megaluavania.HCOLOR_RED = 0
megaluavania.HCOLOR_BLUETOP = 1
megaluavania.HCOLOR_BLUE = 1
megaluavania.HCOLOR_BLUETOP = 2
megaluavania.HCOLOR_BLUELEFT = 3
megaluavania.HCOLOR_BLUERIGHT = 4
megaluavania.HCOLOR_GREEN = 5
megaluavania.HCOLOR_PURPLE = 6
megaluavania.HCOLOR_YELLOW = 7
megaluavania.BCOLOR_WHITE = 0
megaluavania.BCOLOR_CYAN = 1
megaluavania.BCOLOR_ORANGE = 2
megaluavania.BCOLOR_GREEN = 3
megaluavania.BULLET_NORMAL = 0
megaluavania.BULLET_ARROW = 1
megaluavania.BULLET_REVARROW = 2
megaluavania.BULLET_BONE = 3
megaluavania.PHASE_ATTACKCHOICE = 0
megaluavania.PHASE_RESULT = 1
megaluavania.PHASE_ENEMYDIALOGUE = 2
megaluavania.PHASE_ENEMYATTACK = 3
megaluavania.CHOICE_FIGHT = 0
megaluavania.CHOICE_ACT = 1
megaluavania.CHOICE_ITEM = 2
megaluavania.CHOICE_MERCY = 3
megaluavania.CHOICELV_MAINSELECTION = 0
megaluavania.CHOICELV_ENEMYSELECTION = 0.5
megaluavania.CHOICELV_ACTIONSELECTION = 1
megaluavania.BATTLE_NONE = 0
megaluavania.BATTLE_INTRO = 1
megaluavania.BATTLE_ACTIVE = 2
megaluavania.BATTLE_LOST = 3
megaluavania.BATTLE_EXIT = 4
megaluavania.BATTLE_SPARED = 5
megaluavania.BATTLE_RAN = 6
megaluavania.CENTER_X = 400
megaluavania.CENTER_Y = 380
megaluavania.DIRECTION_UP = 0
megaluavania.DIRECTION_RIGHT = 1
megaluavania.DIRECTION_DOWN = 2
megaluavania.DIRECTION_LEFT = 3
megaluavania.BOUNDS_BOTH = 0
megaluavania.BOUNDS_NONE = 1

megaluavania.transitionTimer = 0

local blackscreenshow = false
local mainblackscreenshow = false
local hudshow = true

local determinationGFX = Graphics.loadImage(Misc.episodePath().."megaluavania/determination.png")
local determinationYGFX = Graphics.loadImage(Misc.episodePath().."megaluavania/determinationYellow.png")
local dotumCheGFX = Graphics.loadImage(Misc.episodePath().."megaluavania/dotumChe.png")
local damageGFX = Graphics.loadImage(Misc.episodePath().."megaluavania/damage.png")
local nameGFX = Graphics.loadImage(Misc.episodePath().."megaluavania/name.png")

local determinationFProps = {charWidth = 16,charHeight = 32,image = determinationGFX,kerning = 0}
megaluavania.determination = textblox.Font(textblox.FONTTYPE_SPRITE,determinationFProps)

local determinationYFProps = {charWidth = 16,charHeight = 32,image = determinationYGFX,kerning = 0}
megaluavania.determinationY = textblox.Font(textblox.FONTTYPE_SPRITE,determinationYFProps)

local dotumCheFProps = {charWidth = 12,charHeight = 20,image = dotumCheGFX,kerning = 0}
megaluavania.dotumChe = textblox.Font(textblox.FONTTYPE_SPRITE,dotumCheFProps)

local damageFProps = {charWidth = 38,charHeight = 28,image = damageGFX,kerning = 0}
megaluavania.damageF = textblox.Font(textblox.FONTTYPE_SPRITE,damageFProps) 

local nameFProps = {charWidth = 18,charHeight = 24,image = nameGFX,kerning = -3}
megaluavania.nameF = textblox.Font(textblox.FONTTYPE_SPRITE,nameFProps)

megaluavania.determinationProps = {    width = 560,
                                    height = 130,
                                    scaleMode = textblox.SCALE_AUTO,
                                    boxType = textblox.BOXTYPE_NONE,
                                    font = megaluavania.determination,
                                    visible = true}

--32 chars per line, excluding "* "

megaluavania.determinationYProps = {width = 560,
                                    height = 130,
                                    scaleMode = textblox.SCALE_AUTO,
                                    boxType = textblox.BOXTYPE_NONE,
                                    font = megaluavania.determinationY,
                                    visible = true}
                            
--32 chars per line, excluding "* "

megaluavania.dotumCheProps = {    width = 160,
                                height = 180,
                                scaleMode = textblox.SCALE_AUTO,
                                boxType = textblox.BOXTYPE_NONE,
                                font = megaluavania.dotumChe,
                                visible = true}
                        
--14 chars per line

megaluavania.damageProps = {width = 300,
                            height = 30,
                            scaleMode = textblox.SCALE_AUTO,
                            boxType = textblox.BOXTYPE_NONE,
                            font = megaluavania.damageF,
                            visible = true,
                            boxAnchorX = textblox.HALIGN_MID}

local fight = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/fight.png"))
local act = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/act.png"))
local item = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/item.png"))
local mercy = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/mercy.png"))
local fight2 = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/fight2.png"))
local act2 = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/act2.png"))
local item2 = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/item2.png"))
local mercy2 = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/mercy2.png"))
local heartGFX = {}
for i = 0,6 do
    heartGFX[i] = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/heart"..tostring(i)..".png"))
end
local shield = {image = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/shield0.png")),image1 = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/shield1.png")),col = colliders.Box(0,0,60,3)}
local greenCircle = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/greencircle.png"))
local bubble = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/speechbubble.png"))
local background = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/background.png"))
local backgroundB = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/backgroundB.png"))
local target = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/fighttarget.png"))
local bar = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/bar.png"))
local bar2 = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/bar2.png"))
local swing = {}
for i = 0,5 do
    swing[i] = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/swing"..tostring(i)..".png"))
end
local miss = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/miss.png"))
local heartbreak = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/heartbreak.png"))
local heartshardGFX = {}
for i = 0,3 do
    heartshardGFX[i] = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/heartshard"..tostring(i)..".png"))
end
local heartshards = {}
for i = 0,6 do
    heartshards[i] = {}
    heartshards[i].sprite = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/heartshard"..tostring(i % 4)..".png"))
end
local gameover = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/gameover.png"))
local cloudGFX = {}
for i = 0,2 do
    cloudGFX[i] = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/cloud"..tostring(i)..".png"))
end
local heartFlee = {}
heartFlee[0] = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/heartGTFO0.png"))
heartFlee[1] = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/heartGTFO1.png"))
local border = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/border.png"))
--local stringGFX = Graphics.loadImage(Misc.resolveGraphicsFile("megaluavania/string.png"))

local battlestartSFX = Audio.SfxOpen(megaluavania.resourcePath.."battlestart.ogg") -- channel 1
local blockSFX = Audio.SfxOpen(megaluavania.resourcePath.."block.ogg") -- channel 2
local dustSFX = Audio.SfxOpen(megaluavania.resourcePath.."dust.ogg") -- channel 13
local fleeSFX = Audio.SfxOpen(megaluavania.resourcePath.."flee.ogg") -- channel 3
local healSFX = Audio.SfxOpen(megaluavania.resourcePath.."heal.ogg") -- channel 4
local heartboomSFX = Audio.SfxOpen(megaluavania.resourcePath.."heartboom.ogg") -- space channel 5
local heartbreakSFX = Audio.SfxOpen(megaluavania.resourcePath.."heartbreak.ogg") -- channel 6
local hitSFX = Audio.SfxOpen(megaluavania.resourcePath.."hit.ogg") -- channel 7
local hurtSFX = Audio.SfxOpen(megaluavania.resourcePath.."hurt.ogg") -- channel 8
local loveSFX = Audio.SfxOpen(megaluavania.resourcePath.."love.ogg") -- channel 9
local menu1SFX = Audio.SfxOpen(megaluavania.resourcePath.."menu1.ogg") -- channel 10
local menu2SFX = Audio.SfxOpen(megaluavania.resourcePath.."menu2.ogg") -- channel 11
local swingSFX = Audio.SfxOpen(megaluavania.resourcePath.."swing.ogg") -- channel 12

megaluavania.encounter = {}
megaluavania.phase = megaluavania.PHASE_ATTACKCHOICE
megaluavania.choice = megaluavania.CHOICE_FIGHT
megaluavania.choiceLV = megaluavania.CHOICELV_MAINSELECTION
megaluavania.centerX = megaluavania.CENTER_X
megaluavania.centerY = megaluavania.CENTER_Y
megaluavania.heart = {    x = megaluavania.centerX - 8,
                        y = megaluavania.centerY - 8,
                        speedX = 0,
                        speedY = 0,
                        width = 16,
                        height = 16,
                        isMoving = false,
                        invincibility = 0,
                        color = megaluavania.HCOLOR_RED,
                        string = 1,
                        move = true}
megaluavania.heart.col = colliders.Box(megaluavania.heart.x + 2,megaluavania.heart.y + 2,megaluavania.heart.width - 4,megaluavania.heart.height - 4)    
megaluavania.bullets = {}
megaluavania.dmg = 0
megaluavania.expPerLV = function(LV)
    return 30 + 10 * LV * LV
end
megaluavania.HPPerLV = function(LV)
    if LV ~= 20 then
        return 16 + 4 * LV
    else
        return 99
    end    
end
megaluavania.atkPerLV = function(LV)
    if LV ~= 20 then
        return 5 + 2 * LV
    else
        return 50
    end
end
megaluavania.displayText = {}
megaluavania.dialogue = {}
megaluavania.increaseText = ""
megaluavania.textCounter = 1
megaluavania.saveNPC = 102
megaluavania.saveEvent = "UTSave"
megaluavania.blank = Graphics.loadImage(megaluavania.resourcePath.."blank.png")

textblox.overrideMessageBox = true
textblox.overrideProps =   {scaleMode = textblox.SCALE_FIXED, 
                            startSound = nil,
                            typeSounds = {"uttypewriter.ogg"},
                            finishSound = nil,
                            closeSound = nil,
                            width = 548,
                            height = 40,
                            bind = textblox.BIND_SCREEN,
                            font = megaluavania.determination,
                            speed = 0.75,
                            boxType = textblox.BOXTYPE_MENU,
                            boxColor = 0x000000FF,
                            autoTime = true, 
                            pauseGame = true, 
                            inputClose = true, 
                            boxAnchorX = textblox.HALIGN_MID, 
                            boxAnchorY = textblox.VALIGN_MID, 
                            textAnchorX = textblox.HALIGN_TOP, 
                            textAnchorY = textblox.VALIGN_LEFT,
                            marginX = 6,
                            marginY = 40}
                            
textblox.overrideProps.borderTable = {}
textblox.overrideProps.borderTable = {}
textblox.overrideProps.borderTable["ulImg"] = border
textblox.overrideProps.borderTable["uImg"] = border
textblox.overrideProps.borderTable["urImg"] = border
textblox.overrideProps.borderTable["rImg"] = border
textblox.overrideProps.borderTable["drImg"] = border
textblox.overrideProps.borderTable["dImg"] = border
textblox.overrideProps.borderTable["dlImg"] = border
textblox.overrideProps.borderTable["lImg"] = border
textblox.overrideProps.borderTable["thick"] = 5
textblox.overrideProps.borderTable["col"] = 0xFFFFFFFF

local set = false
local indexX = 0
local indexY = 0
local defaultL,cameras
local playerX = 0
local playerY = 0
local monsterX = 0
local monsterY = 0
local set = false
local HBCounter = 0
local isGrounded = false
local moving = 0
local shakeCounter = 0
local dummyBlocks = {}
local actSelection = 1
local actsTB = {}
local actsOT = {}
local rec = ""
local itemSelection = 1
local itemsTB = {}
local itemsOT = {}
local HPSet = false
local page = 1
local mercySelection = 1 --1: spare, 2: flee
local mercyTB = {}
local mercyOT = {}
local tX = 110
local tY = 310
local bX = 500
local bY = 50
local boxWidth = 580
local OBW = 580
local BWd = 580.0
local boxHeight = 140
local OBH = 140
local BHd = 140.0
local pressedFight = false
local pressedAct = false
local pressedItem = false
local pressedMercy = false
local font = megaluavania.determinationProps
local boxCounter = 0
local attack
local doAttack = false
local textBox
local resizeCounter = 0            
local newheartX = megaluavania.heart.x
local newHeartY = megaluavania.heart.y
local attackCounter = 0
local speed = 4
local defaultVoice = {megaluavania.resourcePath.."defaultvoice.ogg"}
local turnSet = false
local funcSet = false
local dir
local fightCounter = 0
local barX = -100
local dmgSet = false
local newEnemyHP
local displayEnemyHP
local fightBox
local speed
local nameBox
local GOCounter
local killCounter
local pxTable = {}
local encounterSprite
local clouds = {}
local LVIncrease = false
local EMOld
local newX
local newY
local attacks = {}
local flavorText = ""
local shieldDir = megaluavania.DIRECTION_UP
local shieldDirNew = megaluavania.DIRECTION_UP
local shieldCounter = 0
local angle = 0
local rotCounter = 0
local nStrings
local strings = {}
local stringsCol = {}
local bound
local webDir
local boxWhite = colliders.Box(0,0,0,0)
local boxBlack = colliders.Box(0,0,0,0)
local HPC = colliders.Box(353,520,0,20)
local HPCRed = colliders.Box(0,520,0,20)
local monsterHP = colliders.Box(0,0,0,18)
local monsterHPR = colliders.Box(0,0,0,18)
local boxGrey = colliders.Box(0,0,0,13)
local box = colliders.Box(0,0,0,13)
local savepoint
local savedEncounters = {}
local nameText = "Chara"
local HPShow = 0
local maxHPShow = 0
local spaceX = 0
local spaceY = 0
local boxY
local ESPXOld
local minDelay = {}
local data = Data(Data.DATA_LEVEL, "save", true)


local dummyAttack = {    boxWidth = 580,
                        boxHeight = 140,
                        time = 0}
               
dummyAttack.func = function(counter)
end

attacks.mt = {__index = dummyAttack}

local function glDrawFromCol(color,c,p)
    local col = particles.ColFromHexRGBA(color)
    Graphics.glDraw{primitive = Graphics.GL_TRIANGLE_STRIP,
                    priority = p or 1,
                    color = {col.r,col.g,col.b,col.a},
                    vertexCoords = {c.x,c.y,
                                    c.x,c.y + c.height,
                                    c.x + c.width,c.y,
                                    c.x + c.width,c.y + c.height}}
end

local function _rot1(x, y, s1, c1)
    local x2 = (x*c1) - (y*s1)
    local y2 = (y*c1) + (x*s1)
    return x2, y2
end

local function drawImageRotated(img, x, y, w, h, rotate)
    rotate = rotate*math.pi/180
    local s1 = math.sin(rotate)
    local c1 = math.cos(rotate)
    w = w * 0.5
    h = h * 0.5
    local x1 = (-w*c1) - (-h*s1)
    local y1 = (-h*c1) + (-w*s1)
    local x2 = (w*c1) - (h*s1)
    local y2 = (h*c1) + (w*s1)
    local vertCoords = {}
    vertCoords[0], vertCoords[1] = _rot1(-w, -h, s1, c1);
    vertCoords[2], vertCoords[3] = _rot1(-w, h, s1, c1);
    vertCoords[4], vertCoords[5] = _rot1(w, -h, s1, c1);
    vertCoords[6], vertCoords[7] = _rot1(w, h, s1, c1);
    vertCoords[8], vertCoords[9] = _rot1(-w, h, s1, c1);
    vertCoords[10], vertCoords[11] = _rot1(w, -h, s1, c1);
    for i = 0,11,2 do
        vertCoords[i] = vertCoords[i] + x + w
        vertCoords[i+1] = vertCoords[i+1] + y + h
    end
    local textCoords = {}
    textCoords[0]  = 0; textCoords[1]  = 0;
    textCoords[2]  = 0; textCoords[3]  = 1;
    textCoords[4]  = 1; textCoords[5]  = 0;
    textCoords[6]  = 1; textCoords[7]  = 1;
    textCoords[8]  = 0; textCoords[9]  = 1;
    textCoords[10] = 1; textCoords[11] = 0;
    Graphics.glDraw{texture = img,vertexCoords = vertCoords,textureCoords = textCoords}
end

function megaluavania.onInitAPI()
    registerEvent(megaluavania,"onStart","onStart",false)
    registerEvent(megaluavania,"onHUDDraw","onHUDDraw",false)
    registerEvent(megaluavania,"onTick","onTick",false)
    registerEvent(megaluavania,"onCameraUpdate","onCameraUpdate",false)
    registerEvent(megaluavania,"onInputUpdate","onInputUpdate",false)
    registerEvent(megaluavania,"onDraw","onDraw",false)
    registerEvent(megaluavania,"onNPCHarm","onNPCHarm",false)
    registerEvent(megaluavania,"onPlayerHarm","onPlayerHarm",false)
    registerEvent(megaluavania,"onEvent","onEvent",false)
    
    registerCustomEvent(megaluavania,"battle")
    registerCustomEvent(megaluavania,"battleStart")
    registerCustomEvent(megaluavania,"choose")
    registerCustomEvent(megaluavania,"result")
    registerCustomEvent(megaluavania,"enemyDialogue")
    registerCustomEvent(megaluavania,"enemyAttack")
    registerCustomEvent(megaluavania,"gameOver")
    registerCustomEvent(megaluavania,"flee")
    registerCustomEvent(megaluavania,"kill")
    registerCustomEvent(megaluavania,"spare")
    registerCustomEvent(megaluavania,"shake")
    registerCustomEvent(megaluavania,"tableShake")
    registerCustomEvent(megaluavania,"damage")
    registerCustomEvent(megaluavania,"heal")
    registerCustomEvent(megaluavania,"createBullet")
    registerCustomEvent(megaluavania,"assignText")
    registerCustomEvent(megaluavania,"remove")
    registerCustomEvent(megaluavania,"createBone")
    registerCustomEvent(megaluavania,"setBoneHeight")
    registerCustomEvent(megaluavania,"onLoopBattle")
    registerCustomEvent(megaluavania,"onAttack")
    registerCustomEvent(megaluavania,"onSpareDialogue")
    registerCustomEvent(megaluavania,"onKill")
    registerCustomEvent(megaluavania,"onSpare")
    registerCustomEvent(megaluavania,"onDrawBattle")
    registerCustomEvent(megaluavania,"onDrawBattleEnd")
end

function megaluavania.onStart()
    cameras = Camera.get()
    megaluavania.cameraX = cameras[1].x
    megaluavania.cameraY = cameras[1].y
    --savepoint = savestate.save()
end

function megaluavania.onHUDDraw()
    cameras = Camera.get()
    megaluavania.cameraX = cameras[1].x
    megaluavania.cameraY = cameras[1].y
end

function megaluavania.onTick()
    for _,v in pairs(megaluavania.encounter) do
        if v.initiated == megaluavania.BATTLE_ACTIVE or moving == 1 then
            player:setFrame(50)
        end
        if v.initiated == false then
            player:mem(0x122,FIELD_WORD,0)
        end
    end
    for _,v in pairs(NPC.get(megaluavania.saveNPC,player.section)) do
        v.talkEventName = megaluavania.saveEvent
        v.msg = "* You saved your game."
    end
    for _,v in pairs(megaluavania.encounter) do
        if v.initiated == megaluavania.BATTLE_EXIT then
            megaluavania.refreshEncounters()
        end
    end
end

function megaluavania.onPlayerHarm()
    
end

function megaluavania.onCameraUpdate()
    for _,v in pairs(megaluavania.encounter) do
        if v.initiated == megaluavania.BATTLE_INTRO then
            player.x = playerX
            player.y = playerY
            playerAnim.setFrame(player,indexX,indexY)
            if v.NPCID ~= nil and NPC.get(v.NPCID,player.section)[1] ~= nil then
                NPC.get(v.NPCID,player.section)[1].x = monsterX
                NPC.get(v.NPCID,player.section)[1].y = monsterY
            end
        end
    end
    if cameras ~= nil then
        megaluavania.cameraX = cameras[1].x
        megaluavania.cameraY = cameras[1].y
    end
end

function drawUI(v)
    --Graphics.draw{type = RTYPE_IMAGE,image = v.background,x = 0,y = 0,priority = 0,opacity = megaluavania.HUDOpacity or 1}
    Graphics.drawImageWP(v.background or background,0,0,megaluavania.HUDOpacity or 1,0)
    textblox.print(nameText,63,523,megaluavania.nameF,nil,nil,nil,megaluavania.HUDOpacity)
    textblox.print(megaluavania.playerHP.." / "..megaluavania.playerHPMax,369 + maxHPShow,523,megaluavania.nameF,nil,nil,nil,megaluavania.HUDOpacity)
    textblox.print("LV "..megaluavania.LV or 1,169,523,megaluavania.nameF,nil,nil,nil,megaluavania.HUDOpacity)
    glDrawFromCol(0xFFFFFF00 + math.ceil((megaluavania.HUDOpacity or 1)*255),boxWhite,0.4)
    glDrawFromCol(0x000000FF,boxBlack,0.4)
    glDrawFromCol(0xFF000000 + math.ceil((megaluavania.HUDOpacity or 1)*255),HPCRed)
    glDrawFromCol(0xFFFF0000 + math.ceil((megaluavania.HUDOpacity or 1)*255),HPC)
    if megaluavania.choice == megaluavania.CHOICE_FIGHT then
        Graphics.draw{type = RTYPE_IMAGE,image = fight,x = 63,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = act2,x = 248,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = item2,x = 440,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = mercy2,x = 627,y = 552}
    elseif megaluavania.choice == megaluavania.CHOICE_ACT then
        Graphics.draw{type = RTYPE_IMAGE,image = fight2,x = 63,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = act,x = 248,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = item2,x = 440,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = mercy2,x = 627,y = 552}
    elseif megaluavania.choice == megaluavania.CHOICE_ITEM then
        Graphics.draw{type = RTYPE_IMAGE,image = fight2,x = 63,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = act2,x = 248,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = item,x = 440,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = mercy2,x = 627,y = 552}
    elseif megaluavania.choice == megaluavania.CHOICE_MERCY then
        Graphics.draw{type = RTYPE_IMAGE,image = fight2,x = 63,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = act2,x = 248,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = item2,x = 440,y = 552}
        Graphics.draw{type = RTYPE_IMAGE,image = mercy,x = 627,y = 552}
    end
    --Graphics.draw{type = RTYPE_IMAGE,image = encounterSprite,x = v.spriteX,y = v.spriteY + v.sourceY,sourceY = v.sourceY,sourceHeight = encounterSprite.height - v.sourceY,opacity = v.opacity or 1,priority = 0.6}
    Graphics.drawImageWP(encounterSprite,v.spriteX,v.spriteY + v.sourceY,0,v.sourceY,encounterSprite.width,encounterSprite.height - v.sourceY,v.opacity or 1,0.1)
end

function drawBattle(v)
    if attackCounter ~= attack.time and not attack.stop then
        if megaluavania.heart.color == megaluavania.HCOLOR_GREEN then
            Graphics.draw{type = RTYPE_IMAGE,image = greenCircle,x = megaluavania.heart.x - 22,y = megaluavania.heart.y - 22}
            if shieldCounter > 0 then
                drawImageRotated(shield.image1,megaluavania.heart.x - 25,megaluavania.heart.y - 25,62,62,angle)
            else
                drawImageRotated(shield.image,megaluavania.heart.x - 25,megaluavania.heart.y - 25,62,62,angle)
            end
        elseif megaluavania.heart.color == megaluavania.HCOLOR_PURPLE then
            for k,v in pairs(strings) do
                if v >= megaluavania.centerY - spaceY/2 and v < megaluavania.centerY + spaceY/2 then
                    glDrawFromCol(0x6A1A6CFF,stringsCol[k],0.5)
                end
            end
        end
        if (megaluavania.heart.invincibility == 0 or attackCounter % 4 ~= 0) and (doAttack or resizeCounter > 0) then
            Graphics.draw{type = RTYPE_IMAGE,image = heartGFX[megaluavania.heart.color],x = megaluavania.heart.x,y = megaluavania.heart.y}
        end    
    end
    if doAttack and not ((attackCounter == attack.time or attack.stop) and (attack.boxWidth ~= OBW or attack.boxHeight ~= OBH)) and attackCounter > 0 then
        for i = #megaluavania.bullets,1,-1 do
            local v = megaluavania.bullets[i]
            if not v.hidden and v.sprite ~= nil then
                if v.type ~= megaluavania.BULLET_ARROW or #attack.arrowGFXTable == 0 then
                    --Graphics.draw{type = RTYPE_IMAGE,image = v.sprite,x = v.x,y = v.y,sourceX = v.GFXOffsetX or v.offsetX,sourceY = v.GFXOffsetY or v.offsetY + (v.frame - 1)*v.GFXHeight,sourceWidth = v.GFXWidth,sourceHeight = v.GFXHeight}
                    Graphics.drawImageWP(v.sprite,v.x,v.y,v.GFXOffsetX or v.offsetX,v.GFXOffsetY or v.offsetY + (v.frame - 1)*v.GFXHeight,v.GFXWidth,v.GFXHeight,v.opacity,v.priority)
                end
            end
        end
        for i = #megaluavania.bullets,1,-1 do
            local v = megaluavania.bullets[i]
            if v.type == megaluavania.BULLET_ARROW then
                if v == minDelay.bullet then
                    --Graphics.draw{type = RTYPE_IMAGE,image = attack.arrowGFXTableR[v.direction],x = v.x,y = v.y,sourceX = v.GFXOffsetX or v.offsetX,sourceY = v.GFXOffsetY or v.offsetY + (v.frame - 1)*v.GFXHeight,sourceWidth = v.GFXWidth,sourceHeight = v.GFXHeight}
                    Graphics.drawImageWP(attack.arrowGFXTableR[v.direction] or v.sprite,v.x,v.y,v.GFXOffsetX or v.offsetX,v.GFXOffsetY or v.offsetY + (v.frame - 1)*v.GFXHeight,v.GFXWidth,v.GFXHeight,v.opacity,v.priority)
                else
                    --Graphics.draw{type = RTYPE_IMAGE,image = v.sprite,x = v.x,y = v.y,sourceX = v.GFXOffsetX or v.offsetX,sourceY = v.GFXOffsetY or v.offsetY + (v.frame - 1)*v.GFXHeight,sourceWidth = v.GFXWidth,sourceHeight = v.GFXHeight}
                    Graphics.drawImageWP(v.sprite,v.x,v.y,v.GFXOffsetX or v.offsetX,v.GFXOffsetY or v.offsetY + (v.frame - 1)*v.GFXHeight,v.GFXWidth,v.GFXHeight,v.opacity,v.priority)
                end
            end
        end
    end
end

function megaluavania.onDraw(v)
    for _,v in pairs(megaluavania.encounter) do
        if v.initiated == megaluavania.BATTLE_INTRO then
            if (HBCounter < 25 and HBCounter % 2 == 0) or HBCounter < 47 then
                Graphics.draw{type = RTYPE_IMAGE,image = heartGFX[megaluavania.heart.color],x = megaluavania.heart.x,y = megaluavania.heart.y}
            end
        end
        if v.initiated == megaluavania.BATTLE_ACTIVE or v.initiated == megaluavania.BATTLE_SPARED or v.initiated == megaluavania.BATTLE_RAN then
            megaluavania.onDrawBattle(v)
            drawUI(v)
            if v.initiated == megaluavania.BATTLE_RAN then
                if killCounter % 10 < 5 then
                    Graphics.draw{type = RTYPE_IMAGE,image = heartFlee[0],x = tX + 24 - 1.5*killCounter,y = tY + 62}
                else
                    Graphics.draw{type = RTYPE_IMAGE,image = heartFlee[1],x = tX + 24 - 1.5*killCounter,y = tY + 62}
                end
            elseif megaluavania.phase == megaluavania.PHASE_ATTACKCHOICE then
                if megaluavania.heart.x ~= nil and megaluavania.heart.y ~= nil then
                    Graphics.draw{type = RTYPE_IMAGE,image = heartGFX[megaluavania.heart.color],x = megaluavania.heart.x,y = megaluavania.heart.y}
                end
                if megaluavania.choiceLV == megaluavania.CHOICELV_ENEMYSELECTION then
                    if megaluavania.choice == megaluavania.CHOICE_FIGHT then
                        glDrawFromCol(0xFF0000FF,monsterHPR)
                        glDrawFromCol(0x00FF00FF,monsterHP)
                    end
                elseif megaluavania.choiceLV == megaluavania.CHOICELV_ACTIONSELECTION then
                    if megaluavania.choice == megaluavania.CHOICE_FIGHT then
                        Graphics.draw{type = RTYPE_IMAGE,image = target,x = 127,y = 323}
                        Graphics.draw{type = RTYPE_IMAGE,image = bar,x = barX - 6,y = 315}    
                    end
                end
            elseif megaluavania.phase == megaluavania.PHASE_RESULT then
                if pressedFight then
                    Graphics.draw{type = RTYPE_IMAGE,image = target,x = 127,y = 323}
                    if fightCounter % 6 < 3 and not (barX > megaluavania.centerX + 287 or barX < megaluavania.centerX - 287) then
                        Graphics.draw{type = RTYPE_IMAGE,image = bar2,x = barX - 6,y = 315}
                    elseif not (barX > megaluavania.centerX + 287 or barX < megaluavania.centerX - 287) then
                        Graphics.draw{type = RTYPE_IMAGE,image = bar,x = barX - 6,y = 315}
                    end
                    if fightCounter == 40 then
                        if megaluavania.dmg == 0 then
                            Graphics.draw{type = RTYPE_IMAGE,image = miss,x = megaluavania.centerX - 58,y = boxY - 48}
                        end
                    elseif fightCounter > 40 then
                        if fightBox == nil then
                            Graphics.draw{type = RTYPE_IMAGE,image = miss,x = megaluavania.centerX - 58,y = math.min(boxY - 32,boxY - 49 + (fightCounter - 42)*(fightCounter - 42)/4)}
                        elseif megaluavania.dmg > 0 then
                            glDrawFromCol(0x404040FF,boxGrey)
                            glDrawFromCol(0x00FF00FF,box)
                        end
                    end
                    if megaluavania.dmg > 0 then
                        for i = 0,5 do
                            if fightCounter < 6*(i + 1) then
                                Graphics.draw{type = RTYPE_IMAGE,image = swing[i],x = megaluavania.centerX - 7,y = 182 - v.sprite.height/2}
                                break
                            end
                        end
                    end    
                end
            elseif megaluavania.phase == megaluavania.PHASE_ENEMYDIALOGUE then
                if megaluavania.dialogue[megaluavania.textCounter].text ~= "" then
                    Graphics.draw{type = RTYPE_IMAGE,image = bubble,x = bX,y = bY}
                end
            elseif megaluavania.phase == megaluavania.PHASE_ENEMYATTACK and attack ~= nil then
                drawBattle(v)
            end
        elseif v.initiated == megaluavania.BATTLE_LOST and GOCounter ~= nil then
            if GOCounter < 30 then
                Graphics.draw{type = RTYPE_IMAGE,image = heartGFX[0],x = megaluavania.heart.x,y = megaluavania.heart.y}
            elseif GOCounter == 30 then
                Graphics.draw{type = RTYPE_IMAGE,image = heartbreak,x = megaluavania.heart.x - 2,y = megaluavania.heart.y}
            elseif GOCounter <= 55 then
                Graphics.draw{type = RTYPE_IMAGE,image = heartbreak,x = megaluavania.heart.x - 2,y = megaluavania.heart.y}
            elseif GOCounter > 55 then
                for _,v in pairs(heartshards) do
                    Graphics.draw{type = RTYPE_IMAGE,image = v.sprite,x = v.x,y = v.y}
                end
            end
            if GOCounter > 200 then
                Graphics.draw{type = RTYPE_IMAGE,image = gameover,x = 192,y = 33}
            end
        end
        megaluavania.onDrawBattleEnd(v)
    end
    if blackscreenshow then
        Graphics.drawScreen{color = Color.black, priority = -5}
    end
    if mainblackscreenshow then
        Graphics.drawScreen{color = Color.black, priority = -21}
    end
end

function megaluavania.onInputUpdate()
    for _,v in pairs(megaluavania.encounter) do
        if v.initiated == megaluavania.BATTLE_INTRO then
            Graphics.activateHud(false)
            Misc.pause()
            megaluavania.battleStart(v)
            HBCounter = HBCounter + 1
        end
        if v.initiated == megaluavania.BATTLE_ACTIVE or v.initiated == megaluavania.BATTLE_SPARED or v.initiated == megaluavania.BATTLE_RAN then
            Graphics.activateHud(false)
            megaluavania.battle(v)
            inventory.activateinventory = false
            pausemenu.canPause = false
            inventory.activated = false
            mainblackscreenshow = false
            if not Misc.inMarioChallenge() then
                datetime.topright = true
                datetime.bottomright = false
            end
            textblox.active = true
            hudshow = false
        elseif v.initiated == megaluavania.BATTLE_LOST then
            Graphics.activateHud(false)
            megaluavania.gameOver(v)
        elseif v.initiated == megaluavania.BATTLE_EXIT then
            Graphics.activateHud(true)
            v.initiated = megaluavania.BATTLE_NONE
            Misc.unpause()
            inventory.activateinventory = true
            pausemenu.canPause = true
            inventory.activated = true
            textblox.active = false
            if not Misc.inMarioChallenge() then
                datetime.topright = false
                datetime.bottomright = true
            end
            hudshow = true
            player:mem(0x122,FIELD_WORD,0)
            Audio.ReleaseStream(-1)
            player.rawKeys.up,down,left,right,jump,altJump,altRun,run,dropItem,pause = false
            Graphics.activateHud(true)
            megaluavania.choiceLV = megaluavania.CHOICELV_MAINSELECTION
            megaluavania.phase = megaluavania.PHASE_ATTACKCHOICE
            megaluavania.choice = megaluavania.CHOICE_FIGHT
            actSelection = 1
            itemSelection = 1
            mercySelection = 1
            killCounter = nil
            HBCounter = 0
            GOCounter = nil
            moving = 0
        end
    end
end

function megaluavania.onEvent(eventName)
    for _,v in pairs(megaluavania.encounter) do
        if eventName == v.event then
            if v.NPCID ~= nil then
                local monsters = NPC.get(465,player.section)
                monsterX = monsters[1].x
                monsterY = monsters[1].y
            end    
            playerX = player.x
            playerY = player.y
            local relX = player.x - megaluavania.cameraX
            local relY = player.y - megaluavania.cameraY
            if player.powerup == PLAYER_SMALL then
                megaluavania.heart.x = relX + 4
                megaluavania.heart.y = relY + 10
            else
                megaluavania.heart.x = relX + 10
                megaluavania.heart.y = relY + 22
            end
            Graphics.draw{type = RTYPE_IMAGE,image = heartGFX[megaluavania.heart.color],x = megaluavania.heart.x,y = megaluavania.heart.y}
            indexX,indexY = player:getCurrentSpriteIndex()
            v.initiated = megaluavania.BATTLE_INTRO
            Audio.SeizeStream(-1)
            Audio.MusicStop()
        end
    end
end

function megaluavania.battleStart(encounter)
    if HBCounter == 0 then
        Audio.SfxPlayCh(1,battlestartSFX,0)
        megaluavania.heart.speedX = (72 - megaluavania.heart.x)/23
        megaluavania.heart.speedY = (567 - megaluavania.heart.y)/23
    elseif HBCounter == 25 then
        if encounter.NPCID ~= nil then
            
        end
        moving = 1
    end
    if HBCounter > 25 and HBCounter < 47 then
        megaluavania.heart.x = megaluavania.heart.x + megaluavania.heart.speedX
        megaluavania.heart.y = megaluavania.heart.y + megaluavania.heart.speedY
    elseif HBCounter == 47 then
        encounter.initiated = megaluavania.BATTLE_ACTIVE
        moving = 0
    end
    blackscreenshow = true
end

function megaluavania.battle(encounter)
    encounterSprite = encounter.sprite
    Misc.pause()
    blackscreenshow = false
    mainblackscreenshow = true
    megaluavania.playerHP = megaluavania.playerHP or megaluavania.playerHPMax or 20
    encounter.enemyHP = encounter.enemyHP or encounter.enemyHPMax or 500
    nameText = megaluavania.name or "Frisk"
    textblox.print(nameText,63,523,megaluavania.nameF,nil,nil,nil,megaluavania.HUDOpacity)
    boxWhite.x = megaluavania.centerX - boxWidth/2
    boxWhite.y = megaluavania.centerY - boxHeight/2
    boxWhite.width = boxWidth
    boxWhite.height = boxHeight
    boxBlack.x = boxWhite.x + 5
    boxBlack.y = boxWhite.y + 5
    boxBlack.width = boxWidth - 10
    boxBlack.height = boxHeight - 10
    HPShow = math.ceil(megaluavania.playerHP * 1.25)
    maxHPShow = math.ceil(megaluavania.playerHPMax * 1.25)
    HPCRed.x = 353 + HPShow
    HPCRed.width = maxHPShow - HPShow
    HPC.width = HPShow
    if encounter.music ~= EMOld and encounter.enemyHP > 0 and encounter.initiated ~= megaluavania.BATTLE_SPARED and encounter.initated ~= megaluavania.BATTLE_SPARED and encounter.initiated ~= megaluavania.BATTLE_RAN then
        Audio.MusicOpen(encounter.music)
        Audio.MusicPlay()
    end
    EMOld = encounter.music
    megaluavania.dotumCheProps.typeSounds = encounter.typeSounds or defaultVoice
    if encounter.enemyHP == 0 and encounter.overrideDeath then
        megaluavania.onKill(encounter)
    elseif encounter.canspare and encounter.overrideSpare then
        megaluavania.onSpare(encounter)
    end
    if (encounter.enemyHP == 0 and not encounter.overrideDeath) or encounter.forceKill then
        megaluavania.kill(encounter)
        megaluavania.onKill(encounter)
        encounterSprite = encounter.spriteHurt or encounter.sprite
    elseif (encounter.initiated == megaluavania.BATTLE_SPARED and not encounter.overrideSpare) or encounter.forceSpare then
        megaluavania.spare(encounter)
        megaluavania.onSpare(encounter)
    elseif encounter.initiated == megaluavania.BATTLE_RAN then
        megaluavania.flee(encounter)
    elseif megaluavania.phase == megaluavania.PHASE_ATTACKCHOICE then
        megaluavania.choose(encounter)
    elseif megaluavania.phase == megaluavania.PHASE_RESULT then
        megaluavania.result(encounter)
    elseif megaluavania.phase == megaluavania.PHASE_ENEMYDIALOGUE then
        megaluavania.enemyDialogue(encounter)
    elseif megaluavania.phase == megaluavania.PHASE_ENEMYATTACK then
        megaluavania.enemyAttack(encounter)
    end
    if textBox ~= nil and megaluavania.phase ~= megaluavania.PHASE_ENEMYDIALOGUE then
        megaluavania.shake(textBox,OT)
    end
    if megaluavania.playerHP == 0 then
        encounter.initiated = megaluavania.BATTLE_LOST
    end
    megaluavania.onLoopBattle(encounter)
    if encounterSprite ~= nil then
        encounterSprite = encounter.spriteHurt or encounter.sprite
        encounter.spriteX = encounter.spriteX or megaluavania.centerX - encounterSprite.width/2
        encounter.spriteY = encounter.spriteY or 246 - encounterSprite.height
        bX = megaluavania.centerX + encounterSprite.width/2 + 20
    end
end

function megaluavania.spare(encounter)
    if killCounter == nil then
        Audio.MusicStop()
        killCounter = 0
        textBox = textblox.Block(tX + 11,tY + 45,"* YOU WON!<br>* You earned "..encounter.gold.." GOLD and 0 EXP.",megaluavania.determinationProps)
        OT = textBox.text
        Audio.SfxPlayCh(12,dustSFX,0)
        megaluavania.exp = megaluavania.exp + encounter.exp
        megaluavania.gold = megaluavania.gold + encounter.gold
        for i = 1,11 do
            local r = rng.random(0,6.28)
            clouds[i] = {}
            clouds[i].dX = 10*math.sin(r)
            clouds[i].x = encounter.spriteX + encounter.sprite.width/2 + clouds[i].dX
            clouds[i].dY = 10*math.cos(r)
            clouds[i].y = encounter.spriteY + encounter.sprite.height/2 + clouds[i].dY
        end
    end
    for _,v in pairs(clouds) do
        v.x = v.x + v.dX/10
        v.y = v.y + v.dY/10
        if killCounter < 15 then
            Graphics.draw{type = RTYPE_IMAGE,image = cloudGFX[0],x = v.x,y = v.y}
        elseif killCounter < 25 then    
            Graphics.draw{type = RTYPE_IMAGE,image = cloudGFX[1],x = v.x,y = v.y}
        elseif (killCounter - 25)/15 < 1 then
            --Graphics.draw{type = RTYPE_IMAGE,image = cloudGFX[2],x = v.x,y = v.y,opacity = 1 - (killCounter - 35)/15}
            Graphics.drawImage(cloudGFX[2],v.x,v.y,1 - (killCounter - 35)/15)
        end
    end
    encounter.sprite = encounter.spriteHurt
    encounter.opacity = 0.5
    killCounter = killCounter + 1
    if player.rawKeys.jump == KEYS_PRESSED and textBox:isFinished() then
        encounter.initiated = megaluavania.BATTLE_EXIT
        textBox:delete()
        textBox = nil
        killCounter = nil
    elseif player.rawKeys.run == KEYS_PRESSED then
        textBox:finish()
    end    
end

function megaluavania.choose(encounter)
    if not turnSet then
        encounter.turn = encounter.turn + 1
        turnSet = true
        set = false
    end
    if megaluavania.choiceLV == megaluavania.CHOICELV_MAINSELECTION then
        if not set then
            megaluavania.determinationProps.typeSounds = {"uttypewriter.ogg"}
            if flavorText == "" then
                flavorText = megaluavania.assignText(encounter.flavorText) or "* No text defined.<br>* This may happen if all of your<br>  requirements return false."
            end
            textBox = textblox.Block(tX + 11,tY + 45,flavorText,megaluavania.determinationProps)
            OT = textBox.text
            set = true
        end
        if megaluavania.choice == megaluavania.CHOICE_FIGHT then
            megaluavania.heart.x,megaluavania.heart.y = 72, 567
            if player.rawKeys.jump == KEYS_PRESSED then
                megaluavania.choiceLV = megaluavania.CHOICELV_ENEMYSELECTION
            end
        elseif megaluavania.choice == megaluavania.CHOICE_ACT then
            megaluavania.heart.x,megaluavania.heart.y = 257, 567
            if player.rawKeys.jump == KEYS_PRESSED then
                megaluavania.choiceLV = megaluavania.CHOICELV_ENEMYSELECTION
            end    
        elseif megaluavania.choice == megaluavania.CHOICE_ITEM then
            megaluavania.heart.x,megaluavania.heart.y = 449, 567
            if player.rawKeys.jump == KEYS_PRESSED and #megaluavania.items ~= 0 then
                megaluavania.choiceLV = megaluavania.CHOICELV_ACTIONSELECTION
            end    
        elseif megaluavania.choice == megaluavania.CHOICE_MERCY then
        megaluavania.heart.x,megaluavania.heart.y = 636, 567
            if player.rawKeys.jump == KEYS_PRESSED then
                megaluavania.choiceLV = megaluavania.CHOICELV_ACTIONSELECTION
            end
        end
        if player.rawKeys.right == KEYS_PRESSED then
            megaluavania.choice = math.min(megaluavania.choice + 1,megaluavania.CHOICE_MERCY)
            Audio.SfxPlayCh(10,menu1SFX,0)
        end    
        if player.rawKeys.left == KEYS_PRESSED then
            megaluavania.choice = math.max(megaluavania.choice - 1,megaluavania.CHOICE_FIGHT)
            Audio.SfxPlayCh(10,menu1SFX,0)
        end
        if player.rawKeys.jump == KEYS_PRESSED then
            set = false
            textBox:delete()
            textBox = nil
            Audio.SfxPlayCh(10,menu1SFX,0)
        elseif player.rawKeys.run == KEYS_PRESSED then
            textBox:finish()
        end
    elseif megaluavania.choiceLV == megaluavania.CHOICELV_ENEMYSELECTION then
        if megaluavania.choice == megaluavania.CHOICE_FIGHT then
            if not set then
                megaluavania.determinationProps.typeSounds = {}
                textBox = textblox.Block(tX + 49,tY + 45,"* "..encounter.name,megaluavania.determinationProps)
                textBox:finish()
                OT = textBox.text
                set = true
            end
            megaluavania.heart.x,megaluavania.heart.y = tX + 24, tY + 32
            monsterHPR.x = megaluavania.centerX
            monsterHPR.y = tY + 31
            monsterHPR.width = math.min(275,encounterSprite.width)
            monsterHP.x = monsterHPR.x
            monsterHP.y = monsterHPR.y
            monsterHP.width = encounter.enemyHP/encounter.enemyHPMax * monsterHPR.width
            if player.rawKeys.jump == KEYS_PRESSED then
                set = false
                textBox:delete()
                textBox = nil
                megaluavania.choiceLV = megaluavania.CHOICELV_ACTIONSELECTION
                Audio.SfxPlayCh(10,menu2SFX,0)
            elseif player.rawKeys.run == KEYS_PRESSED then
                set = false
                textBox:delete()
                textBox = nil
                megaluavania.choiceLV = megaluavania.CHOICELV_MAINSELECTION
                Audio.SfxPlayCh(10,menu2SFX,0)
            end    
        elseif megaluavania.choice == megaluavania.CHOICE_ACT then
            if not set then
                megaluavania.determinationProps.typeSounds = {}
                textBox = textblox.Block(tX + 49,tY + 45,"* ".. encounter.name,megaluavania.determinationProps)
                textBox:finish()
                OT = textBox.text
                set = true
            end
            megaluavania.heart.x,megaluavania.heart.y = tX + 24, tY + 32
            if player.rawKeys.jump == KEYS_PRESSED then
                set = false
                textBox:delete()
                textBox = nil
                megaluavania.choiceLV = megaluavania.CHOICELV_ACTIONSELECTION
                Audio.SfxPlayCh(10,menu2SFX,0)
            elseif player.rawKeys.run == KEYS_PRESSED then
                set = false
                textBox:delete()
                textBox = nil
                megaluavania.choiceLV = megaluavania.CHOICELV_MAINSELECTION
                Audio.SfxPlayCh(10,menu2SFX,0)
            end    
        end
    elseif megaluavania.choiceLV == megaluavania.CHOICELV_ACTIONSELECTION then
        if megaluavania.choice == megaluavania.CHOICE_FIGHT then
            megaluavania.heart.x,megaluavania.heart.y = nil,nil
            if not set then
                dir = 2*rng.randomInt(0,1) - 1
                fightCounter = 0
                set = true
                speed = rng.random(6,9)
            end
            barX = megaluavania.centerX - (287 - speed * fightCounter)*dir
            fightCounter = fightCounter + 1
            if player.rawKeys.jump == KEYS_PRESSED or barX > megaluavania.centerX + 287 or barX < megaluavania.centerX - 287 then
                megaluavania.phase = 1
                pressedFight = true
                set = false
                fightCounter = 0
            end
        elseif megaluavania.choice == megaluavania.CHOICE_ACT then
            for k,v in pairs(encounter.acts) do
                if k % 2 == 1 and not set then
                    actsTB[k] = textblox.Block(tX + 49,tY + 30 + 15*k,"* ".. v.name,megaluavania.determinationProps)
                    actsTB[k]:finish()
                    actsOT[k] = actsTB[k].text
                elseif not set then
                    actsTB[k] = textblox.Block(tX + 315,tY + 15 + 15*k,"* ".. v.name,megaluavania.determinationProps)    
                    actsTB[k]:finish()
                    actsOT[k] = actsTB[k].text
                end
            end
            set = true
            megaluavania.tableShake(actsTB,actsOT)
            if actSelection % 2 == 1 then
                megaluavania.heart.x,megaluavania.heart.y = tX + 24, tY + 17 + 15*actSelection
            else
                megaluavania.heart.x,megaluavania.heart.y = tX + 290, tY + 2 + 15*actSelection
            end
            if player.rawKeys.jump == KEYS_PRESSED then
                set = false
                for _,v in pairs(actsTB) do
                    v:delete()
                    v = nil
                end
                pressedAct = true
                megaluavania.phase = megaluavania.PHASE_RESULT
                flavorText = ""
                Audio.SfxPlayCh(10,menu2SFX,0)
            elseif player.rawKeys.run == KEYS_PRESSED then
                set = false
                for _,v in pairs(actsTB) do
                    v:delete()
                    v = nil
                end
                megaluavania.choiceLV = megaluavania.CHOICELV_ENEMYSELECTION
                actSelection = 1
                Audio.SfxPlayCh(10,menu2SFX,0)
            elseif player.rawKeys.left == KEYS_PRESSED and actSelection % 2 == 0 then
                actSelection = actSelection - 1
                Audio.SfxPlayCh(10,menu1SFX,0)
            elseif player.rawKeys.right == KEYS_PRESSED and actSelection % 2 == 1 and actSelection ~= #encounter.acts then
                actSelection = actSelection + 1
                Audio.SfxPlayCh(10,menu1SFX,0)
            elseif player.rawKeys.up == KEYS_PRESSED and actSelection > 2 then
                actSelection = actSelection - 2
                Audio.SfxPlayCh(10,menu1SFX,0)
            elseif player.rawKeys.down == KEYS_PRESSED and actSelection < #encounter.acts - 1 then
                actSelection = actSelection + 2
                Audio.SfxPlayCh(10,menu1SFX,0)
            end
        elseif megaluavania.choice == megaluavania.CHOICE_ITEM then
            if itemSelection < 5 then
                for i = 1,math.min(4,#megaluavania.items) do
                    if i % 2 == 1 and not set then
                        itemsTB[i] = textblox.Block(tX + 49,tY + 30 + 15*i,"* ".. megaluavania.items[i].name,megaluavania.determinationProps)
                        itemsTB[i]:finish()
                        itemsOT[i] = itemsTB[i].text
                    elseif not set then
                        itemsTB[i] = textblox.Block(tX + 315,tY + 15 + 15*i,"* ".. megaluavania.items[i].name,megaluavania.determinationProps)
                        itemsTB[i]:finish()
                        itemsOT[i] = itemsTB[i].text
                    elseif page == 2 then
                        itemsTB[i]:setText("* ".. megaluavania.items[i].name)
                        itemsTB[i]:finish()
                        itemsOT[i] = itemsTB[i].text
                    end
                end
                if #megaluavania.items > 4 and not set then
                    itemsTB[5] = textblox.Block(tX + 315, tY + 105,"PAGE 1",megaluavania.determinationProps)
                    itemsTB[5]:finish()
                    itemsOT[5] = itemsTB[5].text
                elseif page == 2 then
                    itemsTB[5]:setText("PAGE 1")
                    itemsTB[5]:finish()
                    itemsOT[5] = itemsTB[5].text
                    page = 1
                end
                set = true
            else
                if page == 1 then
                    for i = 5,#megaluavania.items do
                        itemsTB[i - 4]:setText("* ".. megaluavania.items[i].name)
                        itemsTB[i - 4]:finish()
                        itemsOT[i - 4] = itemsTB[i - 4].text
                    end
                    for i = #megaluavania.items + 1,8 do
                        itemsTB[i - 4]:setText("")
                        itemsTB[i - 4]:finish()
                        itemsOT[i - 4] = itemsTB[i - 4].text
                    end
                    itemsTB[5]:setText("PAGE 2")
                    itemsTB[5]:finish()
                    itemsOT[5] = itemsTB[5].text
                    page = 2
                end    
            end
            megaluavania.tableShake(itemsTB,itemsOT)
            if itemSelection % 2 == 1 then
                megaluavania.heart.x,megaluavania.heart.y = tX + 24, tY + 17 + 15*((itemSelection - 1) % 4 + 1)
            else
                megaluavania.heart.x,megaluavania.heart.y = tX + 290, tY + 2 + 15*((itemSelection - 1) % 4 + 1)
            end
            if player.rawKeys.jump == KEYS_PRESSED then
                pressedItem = true
                set = false
                for _,v in pairs(itemsTB) do
                    v:delete()
                    v = nil
                end
                megaluavania.phase = megaluavania.PHASE_RESULT
                Audio.SfxPlayCh(10,menu2SFX,0)
                page = 1
            elseif player.rawKeys.run == KEYS_PRESSED then
                megaluavania.choiceLV = megaluavania.CHOICELV_MAINSELECTION
                set = false
                for _,v in pairs(itemsTB) do
                    v:delete()
                    v = nil
                end
                itemSelection = 1
                page = 1
                Audio.SfxPlayCh(10,menu2SFX,0)
            elseif player.rawKeys.left == KEYS_PRESSED then
                if itemSelection % 2 == 0 then
                    itemSelection = itemSelection - 1
                elseif itemSelection > 4 then
                    itemSelection = itemSelection - 3
                else
                    itemSelection = math.min(itemSelection + 5,#megaluavania.items)
                end
                Audio.SfxPlayCh(10,menu1SFX,0)
            elseif player.rawKeys.right == KEYS_PRESSED and actSelection % 2 == 1 then
                if itemSelection == #megaluavania.items then
                    itemSelection = 1    
                elseif itemSelection % 2 == 1 then
                    itemSelection = math.min(itemSelection + 1,#megaluavania.items)
                elseif itemSelection < 5 then
                    itemSelection = math.min(itemSelection + 3,#megaluavania.items)
                else
                    itemSelection = itemSelection - 5
                end
                Audio.SfxPlayCh(10,menu1SFX,0)
            elseif player.rawKeys.up == KEYS_PRESSED and (itemSelection -1) % 4 > 1 then
                itemSelection = itemSelection - 2
                Audio.SfxPlayCh(10,menu1SFX,0)
            elseif player.rawKeys.down == KEYS_PRESSED and itemSelection < 3 and itemSelection < #megaluavania.items - 1 then
                itemSelection = itemSelection + 2    
                Audio.SfxPlayCh(10,menu1SFX,0)
            end
        elseif megaluavania.choice == megaluavania.CHOICE_MERCY then
            if encounter.canspare then
                font = megaluavania.determinationYProps
            else
                font = megaluavania.determinationProps
            end    
            if not set then
                mercyTB[1] = textblox.Block(tX + 49,tY + 45,"* Spare",font)
                mercyTB[1]:finish()
                mercyOT[1] = mercyTB[1].text
                if encounter.canflee then
                    mercyTB[2] = textblox.Block(tX + 49, tY + 75,"* Flee",megaluavania.determinationProps)
                    mercyTB[2]:finish()
                    mercyOT[2] = mercyTB[2].text
                end    
                set = true
            end
            megaluavania.heart.x,megaluavania.heart.y = tX + 24, tY + 2 + 30*mercySelection
            megaluavania.tableShake(mercyTB,mercyOT)
            if player.rawKeys.jump == KEYS_PRESSED then
                pressedMercy = true
                set = false
                for _,v in pairs(mercyTB) do
                    v:delete()
                    v = nil
                end
                megaluavania.phase = megaluavania.PHASE_RESULT
                Audio.SfxPlayCh(10,menu2SFX,0)
            elseif player.rawKeys.run == KEYS_PRESSED then
                megaluavania.choiceLV = megaluavania.CHOICELV_MAINSELECTION
                set = false
                for _,v in pairs(mercyTB) do
                    v:delete()
                    v = nil
                end
                mercySelection = 1
                Audio.SfxPlayCh(10,menu2SFX,0)
            elseif player.rawKeys.up == KEYS_PRESSED and mercySelection == 2 then
                mercySelection = 1
                Audio.SfxPlayCh(10,menu1SFX,0)
            elseif player.rawKeys.down == KEYS_PRESSED and mercySelection == 1 and encounter.canflee then
                mercySelection = 2
                Audio.SfxPlayCh(10,menu1SFX,0)
            end    
        end
    end
end

function megaluavania.result(encounter)
    megaluavania.heart.x,megaluavania.heart.y = nil,nil
    turnSet = false
    megaluavania.choiceLV = megaluavania.CHOICELV_MAINSELECTION
    flavorText = ""
    if pressedFight then
        local baseDmg = 1 - math.abs(barX - megaluavania.centerX)/287
        if barX > megaluavania.centerX + 287 or barX < megaluavania.centerX - 287 then
            megaluavania.dmg = 0
        else
            megaluavania.dmg = math.max(math.floor(baseDmg * (megaluavania.playerAtk or 50) - (encounter.enemyDef or 0)),0)
        end
        megaluavania.dialogue = megaluavania.onFight(encounter) or megaluavania.assignText(encounter.randomDialogue) or {"No text<br>defined."}
        newEnemyHP = math.max(encounter.enemyHPMin or 0,encounter.enemyHP - megaluavania.dmg)
        megaluavania.displayText = {""}
        if encounter.spriteY - 64 < 10 then
            boxY = 246 + math.ceil(encounter.sprite.height/4)
        else
            boxY = encounter.spriteY - 16
        end
        if fightCounter == 0 then
            if megaluavania.dmg > 0 then
                Audio.SfxPlayCh(11,swingSFX,0)
            end    
            displayEnemyHP = encounter.enemyHP
        elseif fightCounter == 40 then
            ESPXOld = encounter.spriteX
            if megaluavania.dmg > 0 then
                fightBox = textblox.Block(megaluavania.centerX,boxY - 48,tostring(megaluavania.dmg),megaluavania.damageProps)
                fightBox:finish()
                Audio.SfxPlayCh(7,hitSFX,0)
            end
        elseif fightCounter > 40 and fightCounter <= 68 then
            displayEnemyHP = math.max(displayEnemyHP - megaluavania.dmg/27,encounter.enemyHPMin or 0)
            if megaluavania.dmg > 0 then
                encounter.spriteX = encounter.spriteX + math.min(30,megaluavania.dmg)*math.sin(fightCounter/7*math.pi)
            end    
        elseif fightCounter > 68 then
            encounter.spriteX = ESPXOld or encounter.spriteX
        end
        if fightCounter > 40 then
            if fightBox ~= nil then
                fightBox.y = math.min(boxY - 32,boxY - 49 + (fightCounter - 42)*(fightCounter - 42)/4)
            end
            if megaluavania.dmg > 0 then
                encounter.sprite = encounter.spriteHurt or encounter.sprite
                boxGrey.x = encounter.spriteX
                boxGrey.y = boxY
                boxGrey.width = encounter.sprite.width
                box.x = boxGrey.x
                box.y = boxGrey.y
                box.width = displayEnemyHP/encounter.enemyHPMax * encounter.sprite.width
            end    
        end
        fightCounter = fightCounter + 1
    elseif pressedAct then
        megaluavania.displayText = encounter.acts[actSelection].text
        megaluavania.dialogue = encounter.acts[actSelection].dialogue or megaluavania.assignText(encounter.randomDialogue) or {"No text<br>defined."}
        if encounter.acts[actSelection].func ~= nil and not funcSet then
            encounter.acts[actSelection].func()
            funcSet = true
        end
    elseif pressedItem then
        if not HPSet then
            megaluavania.playerHP = math.min(megaluavania.playerHPMax,megaluavania.playerHP + megaluavania.items[itemSelection].rec)
            HPSet = true
            if megaluavania.items[itemSelection].rec > 0 then
                Audio.SfxPlayCh(4,healSFX,0)
            end
            if megaluavania.items[itemSelection].rec == 0 then
                rec = ""
            elseif megaluavania.playerHP == megaluavania.playerHPMax then
                rec = "* Your HP was maxed out."
            else
                rec = "* You recovered ".. megaluavania.items[itemSelection].rec .." HP."
            end
            if megaluavania.items[itemSelection].func ~= nil and not funcSet then
                megaluavania.items[itemSelection].func()
                funcSet = true
            end    
            megaluavania.displayText = megaluavania.items[itemSelection].text
            megaluavania.displayText[#megaluavania.displayText] = megaluavania.displayText[#megaluavania.displayText] .. rec
            megaluavania.dialogue = megaluavania.items[itemSelection].dialogue or megaluavania.assignText(encounter.randomDialogue) or {{text = "No text<br>defined."}}
            table.remove(megaluavania.items,itemSelection)    
        end
    elseif pressedMercy then
        if mercySelection == 1 then
            if not encounter.canspare then
                megaluavania.displayText = {""}
            else
                encounter.initiated = megaluavania.BATTLE_SPARED
            end
        else
            encounter.initiated = megaluavania.BATTLE_RAN
        end
        megaluavania.dialogue = megaluavania.onSpareDialogue(encounter) or megaluavania.assignText(encounter.randomDialogue) or {{text = "No text<br>defined."}}
    end
    if not set then
        megaluavania.determinationProps.typeSounds = {"uttypewriter.ogg"}
        textBox = textblox.Block(tX + 11,tY + 45,megaluavania.displayText[megaluavania.textCounter] or "",megaluavania.determinationProps)
        OT = textBox.text
        set = true
    end    
    if (player.rawKeys.jump == KEYS_PRESSED and textBox:isFinished() and not pressedFight) or fightCounter == 75 or (not pressedFight and megaluavania.displayText[megaluavania.textCounter] == "") then
        fightCounter = 0
        encounter.enemyHP = newEnemyHP or encounter.enemyHP
        if fightBox ~= nil then
            fightBox:delete()
            fightBox = nil
        end
        pressedAct = false
        actSelection = 1
        pressedItem = false
        itemSelection = 1
        pressedMercy = false
        mercySelection = 1
        pressedFight = false
        set = false
        textBox:delete()
        textBox = nil
        HPSet = false
        if megaluavania.textCounter == #megaluavania.displayText then
            megaluavania.phase = megaluavania.PHASE_ENEMYDIALOGUE
            megaluavania.displayText = {}
            megaluavania.textCounter = 0
        end    
        megaluavania.textCounter = megaluavania.textCounter + 1
    elseif player.rawKeys.run == KEYS_PRESSED then
        textBox:finish()
    end    
end

function megaluavania.enemyDialogue(encounter)
    if not set then
        megaluavania.dotumCheProps.typeSounds = megaluavania.dialogue[megaluavania.textCounter].typeSounds or encounter.typeSounds or defaultVoice
        textBox = textblox.Block(bX + 36,bY + 24,megaluavania.dialogue[megaluavania.textCounter].text or "No text<br>defined.",megaluavania.dotumCheProps)
        OT = textBox.text
        if megaluavania.dialogue[megaluavania.textCounter].func ~= nil then
            megaluavania.dialogue[megaluavania.textCounter].func()
        end
        set = true
    end
    encounter.sprite = megaluavania.dialogue[megaluavania.textCounter].sprite or encounter.sprite
    if (player.rawKeys.jump == KEYS_PRESSED and textBox:isFinished()) or megaluavania.dialogue[megaluavania.textCounter].text == "" then
        set = false
        textBox:delete()
        textBox = nil
        if megaluavania.textCounter == #megaluavania.dialogue then
            megaluavania.phase = megaluavania.PHASE_ENEMYATTACK
            megaluavania.dialogue = {}
            megaluavania.textCounter = 0
        end
        megaluavania.textCounter = megaluavania.textCounter + 1
    elseif player.rawKeys.run == KEYS_PRESSED then
        textBox:finish()
    end
end

function megaluavania.enemyAttack(encounter)
    funcSet = false
    if attack == nil then
        attack = megaluavania.onAttack(encounter) or dummyAttack
        setmetatable(attack,attacks.mt)
        BWd = OBW
        BHd = OBH
        megaluavania.heart.x = megaluavania.centerX - megaluavania.heart.width/2
        megaluavania.heart.y = megaluavania.centerY - megaluavania.heart.height/2
    end
    if attackCounter ~= attack.time and not attack.stop then
        spaceX = megaluavania.spaceX or (boxWidth - 10)
        spaceY = megaluavania.spaceY or (boxHeight - 10)
        if megaluavania.heart.color == megaluavania.HCOLOR_RED or megaluavania.heart.color == megaluavania.HCOLOR_BLUE or megaluavania.heart.color == megaluavania.HCOLOR_BLUETOP or megaluavania.heart.color == megaluavania.HCOLOR_PURPLE then
            megaluavania.heart.speedX = 0
        end    
        if megaluavania.heart.color == megaluavania.HCOLOR_RED or megaluavania.heart.color == megaluavania.HCOLOR_BLUELEFT or megaluavania.heart.color == megaluavania.HCOLOR_BLUERIGHT or megaluavania.heart.color == megaluavania.HCOLOR_PURPLE then
            megaluavania.heart.speedY = 0
        end    
        if (player.rawKeys.run == KEYS_DOWN or player.rawKeys.run == KEYS_PRESSED) then
            speed = 2
        else
            speed = 3
        end
        if megaluavania.heart.color == megaluavania.HCOLOR_RED then
            if (player.rawKeys.up == KEYS_DOWN or player.rawKeys.up == KEYS_PRESSED) and (player.rawKeys.down == KEYS_DOWN or player.rawKeys.down == KEYS_PRESSED) then
                megaluavania.heart.speedY = 0
            elseif player.rawKeys.down == KEYS_DOWN or player.rawKeys.down == KEYS_PRESSED then
                megaluavania.heart.speedY = speed
            elseif player.rawKeys.up == KEYS_DOWN or player.rawKeys.up == KEYS_PRESSED then
                megaluavania.heart.speedY = - speed
            end
            if (player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED) and (player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED) then
                megaluavania.heart.speedX = 0
            elseif player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED then
                megaluavania.heart.speedX = speed
            elseif player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED then
                megaluavania.heart.speedX = - speed
            end
        elseif megaluavania.heart.color == megaluavania.HCOLOR_BLUE then
            megaluavania.heart.speedY = math.min(5,megaluavania.heart.speedY + 0.1)
            if (player.rawKeys.up == KEYS_DOWN or player.rawKeys.up == KEYS_PRESSED) and megaluavania.heart.y == megaluavania.centerY + boxHeight/2 - 5 - megaluavania.heart.height then
                megaluavania.heart.speedY = -4
            elseif player.rawKeys.up == KEYS_UNPRESSED then
                megaluavania.heart.speedY = math.max(0,megaluavania.heart.speedY)
            end
            if (player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED) and (player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED) then
                megaluavania.heart.speedX = 0
            elseif player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED then
                megaluavania.heart.speedX = speed
            elseif player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED then
                megaluavania.heart.speedX = - speed
            end
        elseif megaluavania.heart.color == megaluavania.HCOLOR_BLUETOP then
            megaluavania.heart.speedY = math.max(-5,megaluavania.heart.speedY - 0.1)
            if (player.rawKeys.down == KEYS_DOWN or player.rawKeys.down == KEYS_PRESSED) and megaluavania.heart.y == megaluavania.centerY - boxHeight/2 + 5 then
                megaluavania.heart.speedY = 4
            elseif player.rawKeys.down == KEYS_UNPRESSED then
                megaluavania.heart.speedY = math.min(0,megaluavania.heart.speedY)
            end
            if (player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED) and (player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED) then
                megaluavania.heart.speedX = 0
            elseif player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED then
                megaluavania.heart.speedX = speed
            elseif player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED then
                megaluavania.heart.speedX = - speed
            end    
        elseif megaluavania.heart.color == megaluavania.HCOLOR_BLUELEFT then
            megaluavania.heart.speedX = math.max(-5,megaluavania.heart.speedX - 0.1)
            if (player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED) and megaluavania.heart.x == megaluavania.centerX - boxWidth/2 + 5 then
                megaluavania.heart.speedX = 4
            elseif player.rawKeys.up == KEYS_UNPRESSED then
                megaluavania.heart.speedX = math.min(0,megaluavania.heart.speedY)
            end
            if (player.rawKeys.up == KEYS_DOWN or player.rawKeys.up == KEYS_PRESSED) and (player.rawKeys.down == KEYS_DOWN or player.rawKeys.down == KEYS_PRESSED) then
                megaluavania.heart.speedY = 0
            elseif player.rawKeys.down == KEYS_DOWN or player.rawKeys.down == KEYS_PRESSED then
                megaluavania.heart.speedY = speed
            elseif player.rawKeys.up == KEYS_DOWN or player.rawKeys.up == KEYS_PRESSED then
                megaluavania.heart.speedY = - speed
            end
        elseif megaluavania.heart.color == megaluavania.HCOLOR_BLUERIGHT then
            megaluavania.heart.speedX = math.min(5,megaluavania.heart.speedX + 0.1)
            if (player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED) and megaluavania.heart.x == megaluavania.centerX + boxWidth/2 - 5 - megaluavania.heart.width then
                megaluavania.heart.speedX = -4
            elseif player.rawKeys.up == KEYS_UNPRESSED then
                megaluavania.heart.speedX = math.max(0,megaluavania.heart.speedY)
            end
            if (player.rawKeys.up == KEYS_DOWN or player.rawKeys.up == KEYS_PRESSED) and (player.rawKeys.down == KEYS_DOWN or player.rawKeys.down == KEYS_PRESSED) then
                megaluavania.heart.speedY = 0
            elseif player.rawKeys.down == KEYS_DOWN or player.rawKeys.down == KEYS_PRESSED then
                megaluavania.heart.speedY = speed
            elseif player.rawKeys.up == KEYS_DOWN or player.rawKeys.up == KEYS_PRESSED then
                megaluavania.heart.speedY = - speed
            end
        elseif megaluavania.heart.color == megaluavania.HCOLOR_GREEN then
            megaluavania.heart.move = false
            if player.rawKeys.up == KEYS_PRESSED and shieldDir ~= megaluavania.DIRECTION_UP then
                shieldDirNew = megaluavania.DIRECTION_UP
                rotCounter = 5
            elseif player.rawKeys.down == KEYS_PRESSED and shieldDir ~= megaluavania.DIRECTION_DOWN then
                shieldDirNew = megaluavania.DIRECTION_DOWN
                rotCounter = 5
            elseif player.rawKeys.left == KEYS_PRESSED and shieldDir ~= megaluavania.DIRECTION_LEFT then
                shieldDirNew = megaluavania.DIRECTION_LEFT
                rotCounter = 5
            elseif player.rawKeys.right == KEYS_PRESSED and shieldDir ~= megaluavania.DIRECTION_RIGHT then
                shieldDirNew = megaluavania.DIRECTION_RIGHT
                rotCounter = 5
            end
            if rotCounter > 0 then
                rotCounter = rotCounter - 1
                if (shieldDir - shieldDirNew) % 4 == 1 then
                    angle = (angle - 18) % 360
                elseif (shieldDir - shieldDirNew) % 4 == 2 then
                    angle = (angle + 36) % 360
                else
                    angle = (angle + 18) % 360
                end
            end
            if rotCounter == 0 then
                shieldDir = shieldDirNew
            end
            if shieldDir == megaluavania.DIRECTION_LEFT and rotCounter == 0 then
                shield.col.x = megaluavania.heart.x - 23 + megaluavania.cameraX
                shield.col.y = megaluavania.heart.y - 22 + megaluavania.cameraY
                shield.col.width = 3
                shield.col.height = 60
                angle = 270
            elseif shieldDir == megaluavania.DIRECTION_RIGHT and rotCounter == 0 then
                shield.col.x = megaluavania.heart.x + 36 + megaluavania.cameraX
                shield.col.y = megaluavania.heart.y - 22 + megaluavania.cameraY
                shield.col.width = 3
                shield.col.height = 60
                angle = 90
            elseif shieldDir == megaluavania.DIRECTION_UP and rotCounter == 0 then
                shield.col.x = megaluavania.heart.x - 22 + megaluavania.cameraX
                shield.col.y = megaluavania.heart.y - 23 + megaluavania.cameraY
                shield.col.width = 60
                shield.col.height = 3
                angle = 0
            elseif shieldDir == megaluavania.DIRECTION_DOWN and rotCounter == 0 then
                shield.col.x = megaluavania.heart.x - 22 + megaluavania.cameraX
                shield.col.y = megaluavania.heart.y + 36 + megaluavania.cameraY
                shield.col.width = 60
                shield.col.height = 3
                angle = 180
            end
            for i = #megaluavania.bullets,1,-1 do
                local v = megaluavania.bullets[i]
                if colliders.collide(v.col,shield.col) then
                    shieldCounter = 16
                    table.remove(megaluavania.bullets,i)
                    Audio.SfxPlayCh(2,blockSFX,0)
                end
                if colliders.collide(v.col,megaluavania.heart.col) then
                    if v.color == megaluavania.BCOLOR_GREEN then
                        megaluavania.heal(v.dmg)
                    elseif v.color ~= megaluavania.BCOLOR_CYAN and megaluavania.heart.invincibility == 0 then
                        megaluavania.damage(v.dmg)
                    end
                    table.remove(megaluavania.bullets,i)
                end
            end
            shieldCounter = math.max(shieldCounter - 1,0)
        elseif megaluavania.heart.color == megaluavania.HCOLOR_PURPLE then
            if (player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED) and (player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED) then
                megaluavania.heart.speedX = 0
            elseif player.rawKeys.right == KEYS_DOWN or player.rawKeys.right == KEYS_PRESSED then
                megaluavania.heart.speedX = speed
            elseif player.rawKeys.left == KEYS_DOWN or player.rawKeys.left == KEYS_PRESSED then
                megaluavania.heart.speedX = - speed
            end
            spaceX = boxWidth - 26
            if nStrings == nil or nStrings ~= megaluavania.nStrings or bound == nil or bound ~= megaluavania.bound then
                megaluavania.nStrings = megaluavania.nStrings or math.huge
                nStrings = megaluavania.nStrings
                megaluavania.stringDist = megaluavania.stringDist or 40
                stringDist = megaluavania.stringDist
                bound = megaluavania.bound or megaluavania.BOUNDS_BOTH
                if bound == megaluavania.BOUNDS_BOTH then
                    if nStrings == 1 then
                        --what's wrong with you???
                        strings[1] = megaluavania.centerY
                        stringsCol[1] = colliders.Box(megaluavania.centerX - boxWidth/2 + 21 + megaluavania.cameraX,strings[1] + megaluavania.cameraY,boxWidth - 42,1)
                    elseif nStrings ~= math.huge then
                        for i = 1,nStrings do
                            strings[i] = math.ceil(megaluavania.centerY + boxHeight/2 - 30 - (boxHeight - 60)*(i - 1)/(nStrings - 1))
                            stringsCol[i] = colliders.Box(megaluavania.centerX - boxWidth/2 + 21 + megaluavania.cameraX,strings[i] + megaluavania.cameraY,boxWidth - 42,1)
                        end
                    end
                    megaluavania.heart.string = math.min(megaluavania.heart.string or math.ceil((nStrings - 1)/2),nStrings)
                elseif bound == megaluavania.BOUNDS_NONE then
                    for i = -math.max(math.ceil((boxHeight - 35)/stringDist),5),math.max(math.ceil((boxHeight - 35)/stringDist),5) do
                        strings[i] = megaluavania.centerY - stringDist*i
                        stringsCol[i] = colliders.Box(megaluavania.centerX - boxWidth/2 + 21 + megaluavania.cameraX,strings[i] + megaluavania.cameraY,boxWidth - 42,1)
                    end
                    megaluavania.heart.string = 0
                end
            end
            for k,v in pairs(strings) do
                strings[k] = v + (megaluavania.stringSpeed or 0)
                stringsCol[k].x = megaluavania.centerX - boxWidth/2 + 21
                stringsCol[k].y = v
                stringsCol[k].width = boxWidth - 42
            end
            if bound == megaluavania.BOUNDS_NONE then
                for i = -math.max(math.ceil((boxHeight - 35)/stringDist),5),math.max(math.ceil((boxHeight - 35)/stringDist),5) do
                    strings[megaluavania.heart.string + i] = strings[megaluavania.heart.string] - stringDist*i
                    stringsCol[megaluavania.heart.string + i] = colliders.Box(megaluavania.centerX - boxWidth/2 + 21,strings[megaluavania.heart.string + i],boxWidth - 42,1)
                end
            end
            if webDir == nil then
                if player.rawKeys.up == KEYS_PRESSED and player.rawKeys.down == KEYS_PRESSED then
                elseif player.rawKeys.down == KEYS_PRESSED and (megaluavania.heart.string > 1 or (bound == megaluavania.BOUNDS_NONE)) and strings[megaluavania.heart.string - 1] < megaluavania.centerY + spaceY/2 - megaluavania.heart.height then
                    webDir = megaluavania.DIRECTION_DOWN
                elseif player.rawKeys.up == KEYS_PRESSED and megaluavania.heart.string < nStrings and strings[megaluavania.heart.string + 1] >= megaluavania.centerY - spaceY/2 then
                    webDir = megaluavania.DIRECTION_UP
                end
                newY = strings[megaluavania.heart.string] - megaluavania.heart.height/2
            elseif webDir == megaluavania.DIRECTION_UP then
                newY = math.max(strings[megaluavania.heart.string + 1] - megaluavania.heart.height/2,megaluavania.heart.y - 5 + megaluavania.stringSpeed)
                if newY == strings[megaluavania.heart.string + 1] - megaluavania.heart.height/2 then
                    megaluavania.heart.string = megaluavania.heart.string + 1
                    webDir = nil
                end
                megaluavania.heart.speedX = 0
            elseif webDir == megaluavania.DIRECTION_DOWN then
                newY = math.min(strings[megaluavania.heart.string - 1] - megaluavania.heart.height/2,megaluavania.heart.y + 5 + megaluavania.stringSpeed)
                if newY == strings[megaluavania.heart.string - 1] - megaluavania.heart.height/2 then
                    megaluavania.heart.string = megaluavania.heart.string - 1
                    webDir = nil
                end
                megaluavania.heart.speedX = 0
            end
            if strings[megaluavania.heart.string] < megaluavania.centerY - spaceY/2 then
                megaluavania.heart.string = megaluavania.heart.string - 1
            end
            if strings[megaluavania.heart.string] >= megaluavania.centerY + spaceY/2 then
                megaluavania.heart.string = megaluavania.heart.string + 1
            end
        end
        if not megaluavania.heart.move then
            megaluavania.heart.speedX = 0
            megaluavania.heart.speedY = 0
        end
        if megaluavania.heart.move then
            newX = newX or (math.max(megaluavania.centerX - spaceX/2,math.min(megaluavania.heart.x + megaluavania.heart.speedX,megaluavania.centerX + spaceX/2 - megaluavania.heart.width)))
            newY = newY or (math.max(megaluavania.centerY - spaceY/2,math.min(megaluavania.heart.y + megaluavania.heart.speedY,megaluavania.centerY + spaceY/2 - megaluavania.heart.height)))
        else
            newX = newX or megaluavania.heart.x + megaluavania.heart.speedX
            newY = newY or megaluavania.heart.y + megaluavania.heart.speedY
        end
        megaluavania.heart.move = true
        megaluavania.heart.speedX = newX - megaluavania.heart.x
        megaluavania.heart.speedY = newY - megaluavania.heart.y
        megaluavania.heart.x = newX
        megaluavania.heart.y = newY
        newX = nil
        newY = nil
        if megaluavania.heart.speedX == 0 and megaluavania.heart.speedY == 0 then
            megaluavania.heart.isMoving = false
        else
            megaluavania.heart.isMoving = true
        end
        megaluavania.heart.col.x = megaluavania.heart.x + 2 + megaluavania.cameraX
        megaluavania.heart.col.y = megaluavania.heart.y + 2 + megaluavania.cameraY
    end
    if (attackCounter == attack.time or attack.stop) and (attack.boxWidth ~= OBW or attack.boxHeight ~= OBH) then
        if resizeCounter < 32 then
            BWd = BWd + (OBW - attack.boxWidth)/32
            boxWidth = math.floor(BWd)
            BHd = BHd + (OBH - attack.boxHeight)/32
            boxHeight = math.floor(BHd)
            resizeCounter = resizeCounter + 1
        elseif resizeCounter == 32 then
            boxWidth = OBW
            boxHeight = OBH
            resizeCounter = 0
            attackCounter = 0
            megaluavania.phase = megaluavania.PHASE_ATTACKCHOICE
            megaluavania.heart.x,megaluavania.heart.y = nil,nil
            attack.stop = false
            attack = nil
            doAttack = false
        end
    elseif attackCounter == attack.time or attack.stop then
        boxWidth = OBW
        boxHeight = OBH
        resizeCounter = 0
        attackCounter = 0
        megaluavania.phase = megaluavania.PHASE_ATTACKCHOICE
        megaluavania.heart.x,megaluavania.heart.y = nil,nil
        attack.stop = false
        attack = nil
        doAttack = false
    elseif doAttack then
        if attackCounter == 0 then
            megaluavania.heart.invincibility = 0
            for i = #megaluavania.bullets,1,-1 do
                table.remove(megaluavania.bullets,i)
            end
            if attack.arrowTable ~= nil then
                for _,v in pairs(attack.arrowTable) do
                    local delay
                    if v.type == megaluavania.BULLET_REVARROW then
                        v.sprite = v.sprite or attack.arrowGFXTableY[v.direction]
                        delay = v.delay - 45
                    else
                        v.sprite = v.sprite or attack.arrowGFXTable[v.direction]
                        delay = v.delay
                    end
                    local newBullet = megaluavania.createBullet(v)
                    local speed = v.speed or 2
                    newBullet.delay = v.delay
                    newBullet.type = v.type or megaluavania.BULLET_ARROW
                    if v.direction == megaluavania.DIRECTION_UP then
                        newBullet.x = (attack.finalCenterX or (megaluavania.heart.x + megaluavania.heart.width/2)) - newBullet.width/2
                        newBullet.y = (attack.finalCenterY or (megaluavania.heart.y + megaluavania.heart.height/2)) - 31 - speed*delay - newBullet.height
                        newBullet.speedX = 0
                        newBullet.speedY = speed
                    elseif v.direction == megaluavania.DIRECTION_RIGHT then
                        newBullet.x = (attack.finalCenterX or (megaluavania.heart.x + megaluavania.heart.width/2)) + 31 + speed*delay
                        newBullet.y = (attack.finalCenterY or (megaluavania.heart.y + megaluavania.heart.height/2)) - newBullet.height/2
                        newBullet.speedX = -speed
                        newBullet.speedY = 0
                    elseif v.direction == megaluavania.DIRECTION_DOWN then
                        newBullet.x = (attack.finalCenterX or (megaluavania.heart.x + megaluavania.heart.width/2)) - newBullet.width/2
                        newBullet.y = (attack.finalCenterY or (megaluavania.heart.y + megaluavania.heart.height/2)) + 31 + speed*delay
                        newBullet.speedX = 0
                        newBullet.speedY = -speed
                    elseif v.direction == megaluavania.DIRECTION_LEFT then
                        newBullet.x = (attack.finalCenterX or (megaluavania.heart.x + megaluavania.heart.width/2)) - 31 - speed*delay - newBullet.width
                        newBullet.y = (attack.finalCenterY or (megaluavania.heart.y + megaluavania.heart.height/2)) - newBullet.height/2
                        newBullet.speedX = speed
                        newBullet.speedY = 0
                    end
                end
            end
        end
        attack.func(attackCounter)
        attackCounter = attackCounter + 1
        local heartarea = colliders.Circle(megaluavania.heart.x + megaluavania.heart.width/2 + megaluavania.cameraX,megaluavania.heart.y + megaluavania.heart.height/2 + megaluavania.cameraY,75)
        minDelay = {bullet = nil,time = math.huge}
        for i = #megaluavania.bullets,1,-1 do
            local v = megaluavania.bullets[i]
            if v.removed then
                table.remove(megaluavania.bullets,i)
            else
                if v.type == megaluavania.BULLET_ARROW or v.type == megaluavania.BULLET_REVARROW then
                    v.x = v.x + v.speedX
                    v.y = v.y + v.speedY
                end
                v.frameCounter = (v.frameCounter + 1) % v.frameSpeed
                if v.frameCounter == 0 then
                    v.frame = v.frame % v.nFrames + 1
                end
                if not v.hidden then
                    v.col.x = v.x + v.offsetX + megaluavania.cameraX
                    v.col.y = v.y + v.offsetY + megaluavania.cameraY
                    v.col.width = v.width
                    v.col.height = v.height
                    if colliders.collide(megaluavania.heart.col,v.col) then
                        if v.color == megaluavania.BCOLOR_GREEN then
                            megaluavania.heal(v.dmg)
                            table.remove(megaluavania.bullets,i)
                        elseif not (v.color == megaluavania.BCOLOR_CYAN and not megaluavania.heart.isMoving) and not (v.color == megaluavania.BCOLOR_ORANGE and megaluavania.heart.isMoving) and megaluavania.heart.invincibility == 0 then
                            megaluavania.damage(v.dmg)
                        end
                    end
                end
                if v.type == megaluavania.BULLET_REVARROW then
                    if colliders.collide(heartarea,v.col) and v.colTime == nil then
                        v.colCX = v.x + v.width/2
                        v.colCY = v.y + v.height/2
                        v.rotRadius = math.sqrt((v.colCX - megaluavania.centerX)^2 + (v.colCY - megaluavania.centerY)^2)
                        v.colTime = attackCounter
                        v.headstartX = math.acos((v.colCX - megaluavania.centerX)/v.rotRadius)
                        v.headstartY = math.asin((v.colCY - megaluavania.centerY)/v.rotRadius)
                    end
                    if v.colTime ~= nil then
                        if attackCounter < v.colTime + 45 then
                            v.x = -v.width/2 + megaluavania.centerX + v.rotRadius*math.cos((attackCounter - v.colTime)/45*math.pi - v.headstartX)
                            v.y = -v.height/2 + megaluavania.centerY - v.rotRadius*math.sin((attackCounter - v.colTime)/45*math.pi - v.headstartY)
                        end
                        if attackCounter == v.colTime + 45 then
                            v.speedX = -v.speedX
                            v.speedY = -v.speedY
                            v.x = 2*megaluavania.centerX - v.colCX - v.width/2
                            v.y = 2*megaluavania.centerY - v.colCY - v.height/2
                        end
                    end
                elseif v.type == megaluavania.BULLET_BONE then
                    v.x = v.x + v.speedX
                    if v.heightChange ~= nil then
                        megaluavania.setBoneHeight(v,v.heightChange(attackCounter))
                    end
                    if v.x > megaluavania.centerX + amalgamAttacks[2].boxWidth/2 - v.width or v.x < megaluavania.centerX - amalgamAttacks[2].boxWidth/2 then
                        v.hidden = true
                    else
                        v.hidden = false
                    end
                end
                if not v.hidden and v.sprite ~= nil and v.type == megaluavania.BULLET_ARROW and v.delay <= minDelay.time then
                    minDelay = {bullet = v,time = v.delay}
                end
            end
        end
        megaluavania.heart.invincibility = math.max(0,megaluavania.heart.invincibility - 1)
    else
        if resizeCounter < 32 and (attack.boxWidth ~= OBW or attack.boxHeight ~= OBH) then
            BWd = BWd + (attack.boxWidth - OBW)/32
            boxWidth = math.floor(BWd)
            BHd = BHd + (attack.boxHeight - OBH)/32
            boxHeight = math.floor(BHd)
            resizeCounter = resizeCounter + 1
            megaluavania.heart.x = megaluavania.centerX - 8
            megaluavania.heart.y = megaluavania.centerY - 8
            if megaluavania.heart.color == megaluavania.HCOLOR_BLUE then
                megaluavania.heart.y = megaluavania.centerY + boxHeight/2 - 21
            elseif megaluavania.heart.color == megaluavania.HCOLOR_BLUETOP then
                megaluavania.heart.y = megaluavania.centerY - boxHeight/2 + 5
            elseif megaluavania.heart.color == megaluavania.HCOLOR_BLUELEFT then
                megaluavania.heart.x = megaluavania.centerX - boxWidth/2 + 5
            elseif megaluavania.heart.color == megaluavania.HCOLOR_BLUERIGHT then
                megaluavania.heart.x = megaluavania.centerX + boxWidth/2 - 21
            end
        elseif resizeCounter == 32 or (attack.boxWidth == OBW and attack.boxHeight == OBH) then
            boxWidth = attack.boxWidth
            boxHeight = attack.boxHeight
            BWd = boxWidth
            BHd = boxHeight
            resizeCounter = 0
            doAttack = true
            attackCounter = 0
        end    
    end
end

function megaluavania.gameOver(encounter)
    if GOCounter == nil then
        Audio.MusicStop()
        GOCounter = 0
    end
    if GOCounter == 30 then
        Audio.SfxPlayCh(6,heartbreakSFX,0)
    elseif GOCounter == 55 then
        heartshards[0].dir = 2*rng.randomInt(0,1) - 1
        heartshards[1].dir = 2*rng.randomInt(0,1) - 1
        if heartshards[0].dir == heartshards[1].dir then
            heartshards[2].dir = - heartshards[0].dir
            heartshards[3].dir = - heartshards[0].dir
        else
            heartshards[2].dir = 2*rng.randomInt(0,1) - 1
            heartshards[3].dir = - heartshards[2].dir
        end
        heartshards[4].dir = 2*rng.randomInt(0,1) - 1
        heartshards[5].dir = 2*rng.randomInt(0,1) - 1
        heartshards[6].dir = 2*rng.randomInt(0,1) - 1
        for _,v in pairs(heartshards) do
            v.x = megaluavania.heart.x + 8 + 2 * v.dir
            v.y = megaluavania.heart.y + 8
            v.speedX = rng.random(1,3) * v.dir
            v.speedY = rng.random(-5,2)
        end
        Audio.SfxPlayCh(5,heartboomSFX,0)
    elseif GOCounter > 55 then
        for _,v in pairs(heartshards) do
            v.x = v.x + v.speedX
            v.speedY = v.speedY + 0.1
            v.y = v.y + v.speedY
        end
    end
    if GOCounter > 55 and GOCounter % 6 == 0 then
        for k,v in pairs(heartshards) do
            v.sprite = heartshardGFX[(k + GOCounter/6 + 1) % 4]
        end
    end
    if GOCounter == 200 then
        player.x = megaluavania.cameraX - 50
        player:kill()
    end
    if GOCounter > 200 then
        Graphics.draw{type = RTYPE_IMAGE,image = gameover,x = 192,y = 33}
    end
    GOCounter = GOCounter + 1
end

function megaluavania.flee(encounter)
    if killCounter == nil then
        Audio.MusicStop()
        killCounter = 0
        Audio.SfxPlayCh(3,fleeSFX,0)
        local fleeText = megaluavania.fleeText or {"* I'm outta here.","* I've got better to do.","* Escaped...","* Don't slow me down."}
        textBox = textblox.Block(tX + 11,tY + 45,rng.irandomEntry(fleeText),megaluavania.determinationProps)
        OT = textBox.text
    end
    killCounter = killCounter + 1
    if player.rawKeys.jump == KEYS_PRESSED and textBox:isFinished() then
        encounter.initiated = megaluavania.BATTLE_EXIT
        textBox:delete()
        textBox = nil
        killCounter = nil
    elseif player.rawKeys.run == KEYS_PRESSED then
        textBox:finish()
    end
end

function megaluavania.kill(encounter)
    if killCounter == nil then
        Audio.MusicStop()
        killCounter = 0
        for i = 0,encounter.sprite.width/2 do
            pxTable[i] = {}
        end
        megaluavania.exp = megaluavania.exp + (encounter.exp or 0)
        megaluavania.gold = megaluavania.gold + (encounter.gold or 0)
        while megaluavania.exp >= megaluavania.expPerLV(megaluavania.LV + 1) do
            megaluavania.playerHP = megaluavania.playerHP - megaluavania.HPPerLV(megaluavania.LV) + megaluavania.HPPerLV(megaluavania.LV + 1)
            megaluavania.LV = megaluavania.LV + 1
            LVIncrease = true
        end
        if LVIncrease then
            megaluavania.increaseText = "<br>* Your LOVE increased."
            Audio.SfxPlayCh(9,loveSFX,0)
            LVIncrease = false
        end
        megaluavania.playerHPMax = megaluavania.HPPerLV(megaluavania.LV)
        megaluavania.playerAtk = megaluavania.atkPerLV(megaluavania.LV)
        textBox = textblox.Block(tX + 11,tY + 45,"* YOU WON!<br>* You earned "..encounter.gold.." gold and "..encounter.exp.." XP."..megaluavania.increaseText,megaluavania.determinationProps)
        OT = textBox.text
        Audio.SfxPlayCh(12,dustSFX,0)
        megaluavania.increaseText = ""
    end
    for k,v in pairs(pxTable) do
        if killCounter < encounter.sprite.height/2 + 2 and killCounter % 2 == 0 then
            encounter.sourceY = 2*killCounter
            v[encounter.sourceY] = {x = encounter.spriteX + 2*k,y = encounter.spriteY + encounter.sourceY}
        end    
        for j,w in pairs(v) do
            w.x = w.x + rng.randomInt(-6,6)
            w.y = w.y - rng.randomInt(1,2)
            if 1 - 1/42*(killCounter - j/2) > 0 then
                --Graphics.draw{type = RTYPE_IMAGE,image = encounterSprite,x = w.x,y = w.y,sourceX = 2*k,sourceY = j,sourceWidth = 2,sourceHeight = 2,priority = 1 - 1/42*(killCounter - j/2)}
                Graphics.drawImage(encounter.sprite,w.x,w.y,2*k,j,2,2,1 - 1/42*(killCounter - j/2))
            end    
        end
    end
    killCounter = killCounter + 1
    if player.rawKeys.jump == KEYS_PRESSED and textBox:isFinished() then
        encounter.initiated = megaluavania.BATTLE_EXIT
        textBox:delete()
        textBox = nil
        killCounter = nil
    elseif player.rawKeys.run == KEYS_PRESSED then
        textBox:finish()
    end    
end

function megaluavania.shake(TextBlock,OT)
    megaluavania.tableShake({TextBlock},{OT})
end

function megaluavania.tableShake(TBArray,OTArray)
    shakeCounter = (shakeCounter + 1) % 130
    if oldT == nil or oldT ~= TBArray[1].text then
        rem = {}
        text = {}
        pureText = {}
        for k,v in pairs(TBArray) do
            text[k] = v.text
            pureText[k] = string.gsub(text[k],"<(.-)>","")
            rem[k] = {}
            rem[k][1] = {}
            local i = 1
            rem[k][i][1] = string.find(text[k],"<")
            rem[k][i][2] = string.find(text[k],">",rem[k][i][1])
            while rem[k][i][1] ~= nil and rem[k][i][2] ~= nil do
                i = i + 1
                rem[k][i] = {}
                rem[k][i][1] = string.find(text[k],"<",rem[k][i-1][2])
                rem[k][i][2] = string.find(text[k],">",rem[k][i][1])
            end
        end
    end
    if shakeCounter == 0 then
        TBPos = rng.randomInt(1,#TBArray)
        if pureText[TBPos] ~= "" and TBArray[TBPos]:isFinished() then
            local pos
            local inCommand = true
            while inCommand do
                inCommand = false
                pos = rng.randomInt(1,string.len(text[TBPos]))
                for _,v in pairs(rem[TBPos]) do
                    if v[1] ~= nil and v[2] ~= nil and pos >= v[1] and pos <= v[2] then
                        inCommand = true
                        break
                    end
                end
            end
            TBArray[TBPos]:setText(string.sub(text[TBPos],1,pos - 1).."<tremble>"..string.sub(text[TBPos],pos,pos).."</tremble>"..string.sub(text[TBPos],pos + 1))
            TBArray[TBPos]:finish()
        end
    elseif TBPos ~= nil and TBArray[TBPos] ~= nil then
        if shakeCounter == 20 and TBArray[TBPos]:isFinished() then
            TBArray[TBPos]:setText(OTArray[TBPos])
            TBPos = nil
        end    
    end
    oldT = TBArray[1].text
end

function megaluavania.damage(dmg)
    if dmg ~= 0 then
        megaluavania.playerHP = math.max(0,megaluavania.playerHP - dmg)
        megaluavania.heart.invincibility = 64
        Audio.SfxPlayCh(8,hurtSFX,0)
    end
end

function megaluavania.heal(healedHP)
    if healedHP ~= 0 then
        megaluavania.playerHP = math.min(megaluavania.playerHPMax,megaluavania.playerHP + healedHP)
        Audio.SfxPlayCh(4,healSFX,0)
    end    
end

function megaluavania.createBullet(t)
    local newBullet = {    x = t.x or megaluavania.centerX,
                        y = t.y or megaluavania.centerY,
                        sprite = t.sprite,
                        dmg = t.dmg or 3,
                        color = t.color or megaluavania.BCOLOR_WHITE,
                        offsetX = t.offsetX or 0,
                        offsetY = t.offsetY or 0,
                        nFrames = t.nFrames or 1,
                        frameSpeed = t.frameSpeed or 5,
                        frame = t.frame or 1,
                        frameCounter = t.frameCounter or 0,
                        opacity = t.opacity or 1,
                        priority = t.priority or 2,
                        type = t.type or megaluavania.BULLET_NORMAL,
                        direction = t.direction}
    newBullet.width = t.width or newBullet.sprite.width
    newBullet.GFXWidth = t.GFXWidth or newBullet.width
    newBullet.height = t.height or newBullet.sprite.height
    newBullet.GFXHeight = t.GFXHeight or newBullet.height
    newBullet.GFXOffsetX = t.GFXOffsetX or t.offsetX
    newBullet.GFXOffsetY = t.GFXOffsetY or t.offsetY
    newBullet.col = colliders.Box(newBullet.x + newBullet.offsetX,newBullet.y + newBullet.offsetY,newBullet.width,newBullet.height)
    newBullet.removed = false
    newBullet.hidden = false
    table.insert(megaluavania.bullets,newBullet)
    return newBullet
end

function megaluavania.newEncounter()
    local newTable = {}
    newTable.initiated = megaluavania.BATTLE_NONE
    newTable.turn = 0
    newTable.canspare = false
    newTable.canflee = false
    newTable.overrideDeath = false
    newTable.overrideSpare = false
    newTable.forceKill = false
    newTable.forceSpare = false
    newTable.sourceY = 0
    table.insert(megaluavania.encounter,newTable)
    return newTable
end

function megaluavania.assignText(t)
    if #t > 0 then
        for _,v in pairs(t) do    
            if v.req() then
                if v.func ~= nil then
                    v.func()
                end
                return rng.irandomEntry(v.text)
            end
        end
    end
end    

function megaluavania.remove(bullet)
    bullet.removed = true
end

function megaluavania.createBone(t)
    local newB
    if t.direction == megaluavania.DIRECTION_DOWN then
        newB = megaluavania.createBullet{    sprite = t.sprite,
                                            x = t.x,
                                            y = megaluavania.centerY - amalgamAttacks[2].boxHeight/2 + 5,
                                            height = t.height or 50,
                                            GFXOffsetY = t.sprite.height - (t.height or 50),
                                            color = t.color,
                                            priority = t.priority,
                                            dmg = t.dmg}
        newB.speedX = t.speed or 0
        newB.dir = t.direction
    else
        newB = megaluavania.createBullet{    sprite = t.sprite,
                                            x = t.x,
                                            y = megaluavania.centerY + amalgamAttacks[2].boxHeight/2 - 5 - (t.height or 50),
                                            height = t.height or 50,
                                            color = t.color,
                                            priority = t.priority,
                                            dmg = t.dmg}
        
        newB.speedX = t.speed or 0
        newB.dir = t.direction or megaluavania.DIRECTION_UP
    end
    newB.heightChange = t.heightChange
    newB.hidden = true
    newB.type = megaluavania.BULLET_BONE
    return newB
end

function megaluavania.setBoneHeight(b,h)
    b.height = h
    b.GFXHeight = h
    if b.dir == megaluavania.DIRECTION_DOWN then
        b.GFXOffsetY = b.sprite.height - h
    else
        b.y = megaluavania.centerY + amalgamAttacks[2].boxHeight/2 - 5 - h    
    end
end

function megaluavania.onLoopBattle(encounter)
end

function megaluavania.onAttack(encounter)
end

function megaluavania.onSpareDialogue(encounter)
end

function megaluavania.onKill(encounter)
end

function megaluavania.onSpare(encounter)
end

function megaluavania.onDrawBattle(encounter)
end

function megaluavania.onDrawBattleEnd(encounter)
end

return megaluavania