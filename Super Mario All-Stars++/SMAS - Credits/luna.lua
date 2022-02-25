local textplus = require("textplus")

Graphics.activateHud(false)

local fadein = false

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0
local time2 = 0
local time3 = 0

local opacity = timer1/speed
local middle = math.floor(timer1*numberup)

local logo = Graphics.loadImageResolved("launcher/title-final-2x.png")
local scrolltextyes = false

local credits = {
			"Credits",
			"",
			"Episode made by Spencer Everly",
			"Project started on March 9th, 2012 (On the original SMBX 1.3.0)",
			"v1.0.0.0 finished on TBD",
			"",
			"Graphic Pack Credits",
			"",
			"Packs/Sprites are by:",
			"Murphmario",
			"Valtteri",
			"LeanneTM",
			"Kojimkj",
			"thesmbxgamer1",
			"Squishy Rex",
			"Katrina",
			"Eevee",
			"Citrusponge",
			"Q-Nova",
			"Spade",
			"bEEtle",
			"SupahLuigi",
			"Awesomezack",
			"TSPRR",
			"MARIOBONNIE",
			"CrystallicAshley",
			"redigit",
			"IsaacP2003",
			"LinkstormZ",
			"MegaDood",
			"AwesomeZack",
			"MarioFan5000",
			"Sednaiur",
			"BackwardsPigeon1985",
			"SilverDeoxys563",
			"MarioWizzerd",
			"FlatKiwi",
			"Spriters Resource",
			"MFGG",
			"Hat Loving Gamer",
			"Sapphire Bullet Bill",
			"Phil",
			"Ludwig Koopa Is Awesome",
			"braineat",
			"",
			"Costume/Character Credits",
			"",
			"Characters:",
			"SMW2: YI Yoshi, and Minecraft Steve made by MrDoubleA",
			"A2XT Gaiden 2's Pily made by raocow, and the A2XT Gaiden 2 Team",
			"",
			"Costumes:",
			"NES Toad, NES Mario & Luigi, Toadette, Daisy, Pauline, Luigi with",
			"Mario's clothes, and some Toad Colors by IsaacP2003",
			"Sonic sprites by megamario1500, rodrig0 (Also costume code modified",
			"by Spencer Everly)",
			"Daisy idle sprite by magibowser",
			"Wario and Waluigi by couch tomato",
			"Bass sprite by Unknown",
			"Kirby powerup hats by Kabi-Ribi",
			"Yoshi sprite base from Joshr_691 and Supernova Bandana Dee",
			"SMB2 Mario (Big) by Johnny Webb",
			"South Park characters (Eric, Kyle, Stan, Kenny) by Lolwutburger/Matt",
			"Parker and Trey Stone",
			"NSMBDS SMBX Styled Mario and Luigi by Bowl_of_Oatmeal",
			"SMB3 8-Bit SMAS++ Beta Sprites by ??? (From the old SMBX Forums from",
			"2009-2013. If you know the creator who made the variants for Small, Big,",
			"Fire, and Ice Mario... Leaf, Tanooki and Hammer Suits were made by me...",
			"please contact spencer.everly@gmail.com)",
			"Super Mario Bros. 8-Bit and Retro DX Episode sprites by CrystallicAshley",
			"Modern Mario Bros. sprites by Linkstormz (Front, back, Luigi projectile throw),",
			"Anonymous (Luigi's skid, jump, and falling), and JRMaster (Tanooki statues and",
			"Fox Luigi)",
			"SMW2 Mario by Mit, ported by Murphmario",
			"SMA4 Mario and Luigi by TheNintendoBros and jdaster64",
			"SMG4 by Mosaic, Hunter2258, Zeus Guy, and Cosmic",
			"JC Foster Takes it to the Moon by JC Foster Takes it to the Moon (Duh)",
			"Larry the Cucumber by Cmanflip/Big Idea/Phil Vischer",
			"GoAnimate Caillou/Boris by GoAnimate/Vyond, and Cookie Jar Entertainment",
			"Marink character by Phil (The Legend of Mario)",
			"Super Mario Bros. 0 characters by BrokenAce",
			"Minecraft Skins by Spencer Everly, uxiee36, breadconjurer0, HyperSanic666,",
			"SuperSaiyanT07, sadlove, overcasterz, Ledkalnis, Joa11, Legendboy1313, djgirlx,",
			"monsterboy772, raptyblocks, anniemichelle, M4PL3, GorillaMask, DoctorSkins,",
			"tayblecloth (UnofficialStudios/Riley), GeorgeNotFound, Tommyinnit, Karl,",
			"Quackity, ExplodingTNT, ItsJerryAndHarry, Notch, and the Mojang Staff",
			"Golden Mario by It's-A-Me",
			"Playable Goomba by Turret 3471",
			"Frisk Costume Block Sprites by Frisky",
			"",
			"(Some sprites, characters, and costumes are made/edited/compiled",
			"by Spencer Everly, which were also packed from Spriters Resource)",
			"",
			"Asset/Other Character Credits",
			"",
			"Pigeon Raca made by studsX",
			"",
			"LunaLua Credits",
			"",
			"NPCs are made by:",
			"MrDoubleA",
			"Core",
			"",
			"Code for certain parts made by:",
			"KBM-Quine",
			"Enjl",
			"MrDoubleA",
			"Chipss",
			"Bulby_VR",
			"Enjl",
			"9thCore",
			"Hatsune Blake/Blake Hatsune",
			"CJ_RLushi",
			"Yingchun Soul",
			"Zeus guy",
			"Lukinsky Play",
			"JustOneMGuy",
			"Yoshi021",
			"SetaYoshi",
			"Marioman2007",
			"cold soup",
			"Coldcolor900",
			"deice",
			"",
			"Music Credits",
			"",
			"Some SMB1, SMB2, SMB3, LL, SMW music by LadiesMan217 and Nintendo",
			"Some other SMB1, SMB2, SMB3, LL, SMW music by The Mario Multiverse Team,",
			"with one song recreated by me in All-Stars 16 bit format (EmmaNerd),",
			"with other SMAS music by TheLegendofRenegade, Nimbus Cumulus, and some",
			"other people.",
			"",
			"Some music by me:",
			"- SMB1, LL, SMBS Map Music",
			"- True Ending Music (Heaven Music 1)",
			"- Dancing Mushrooms (By Blue Warrior, FL instrument remaster by me)",
			"",
			"Other music played on the episode are made by:",
			"Maxodex",
			"Gamma V",
			"Jimmy",
			"qantuum",
			"Kusamochi",
			"Roberto zampari",
			"Ultima",
			"Joy Sticks",
			"TrojanHorse711",
			"Ryan Landry",
			"skydev",
			"Bramble",
			"Xane",
			"Mr. Wes",
			"Dark Magician S62",
			"xyz600sp",
			"Fullcannon",
			"EDIT3333",
			"HaruMKT",
			"SMB64 Beta Archive (Zodiaku)",
			"Nintendo",
			"HAL Labratories",
			"Darren Mitchell (Acclaim Entertainment)",
			"Wohlstand",
			"GLuigiX",
			"Talkhaus",
			"Herbert Richers/Audio News (VeggieTales)",
			"drmr (Homebrew Channel, NOT drmr. on YouTube, it's a different",
			"user)",
			"GoAnimate/Vyond (Some from Kevin MacLeod, PremiumBeat, other",
			"anonymous sources)",
			"Holy Order Sol",
			"Hooded Edge",
			"FYRE150",
			"Wakana",
			"com_poser",
			"HarvettFox96",
			"mario90",
			"MiracleWater",
			"Kevin",
			"Lazy",
			"Lui",
			"Kevin",
			"DAA234",
			"sincx",
			"mindmatchingmoment",
			"Toby Fox",
			"The Undertoad Team",
			"ZerJox, Jedo, BenLab (Undertale: Last Breath)",
			"IsabelleChiming",
			"skydev",
			"Master Jonald",
			"Estlib",
			"Tater-Tot Tunes",
			"Lu9",
			"Milon Luxy",
			"Mr. MS",
			"Lood",
			"Mad Nyle",
			"Captain 3",
			"",
			"Sound Credits",
			"",
			"SMB2 sounds by antonioflowers056",
			"8-Bit Sounds by Valtteri",
			"Is the pool clean? SFX by sullyrox",
			"",
			"Level Credits",
			"",
			"Levels made by:",
			"Spencer Everly",
			"barkers",
			"",
			"Boot Menu Theming Credits",
			"",
			"Themes made by:",
			"redigit",
			"Spencer Everly",
			"bossedit8",
			"TepigFan101",
			"SMBX2 Staff",
			"",
			"Adventures of Demo (Credits)",
			"",
			"Adventures of Demo by Wohlstand",
			"",
			"Stuff by raocow and his fan community.",
			"",
			"Characters By:",
			"Cadwyn",
			"Chaoxys",
			"darkychao",
			"Jolpengammler",
			"Mata Hari",
			"MrWeirdGuy",
			"raocow",
			"Roo",
			"Tsurugi",
			"",
			"Graphics By:",
			"Cadwyn",
			"Chaoxys",
			"darkychao",
			"Enjl",
			"Feenicks",
			"Frozelar",
			"Hoeloe",
			"Mata Hari",
			"MrWeirdGuy",
			"Paralars",
			"Quine",
			"raocow",
			"RedYoshi",
			"rixithechao",
			"SAJewers",
			"SilverDeoxys563",
			"supermarioman",
			"Terry Von Feleday",
			"Various members of Talkhaus",
			"Wohlstand",
			"",
			"Music By:",
			"A13XIS",
			"Amber Vasami",
			"Aristo",
			"BaDLiZ",
			"Chrom1um",
			"d.r.m of disknet",
			"Dr.Tapeworm",
			"Izuna",
			"Kil",
			"Lui37",
			"Mandew",
			"Michail Oberuechtin",
			"necros/fm",
			"Prsynth1111",
			"Razmatan_iki",
			"RednGreen",
			"Robert A. Allen",
			"Roberto Ricioppo",
			"Rondo",
			"SharkNurse",
			"Sinc-X",
			"S.N.N.",
			"ThinkOneMoreTime",
			"Torchkas",
			"Various authors at modarchive.org",
			"WhiteYoshiEgg",
			"Wohlstand",
			"Woolters",
			"",
			"Extra Music provided by Spencer Everly:",
			"Acumen",
			"Cynmusic",
			"Awesome",
			"",
			"SFX By:",
			"Hoeloe",
			"rixithechao",
			"Wohlstand",
			"or from public domain",
			"",
			"Special thanks to:",
			"",
			"- Anyone who supported my actual content throughout",
			"the years.",
			"- redigit for SMBX.",
			"- Horikawa Otane, Kevsoft, Rednaxela, Hoeloe, and Enjl",
			"for SMBX2.",
			"- Any other credits TBD.",
			"- And YOU, for playing this game!",
			"",
			"2012-2022, Spencerly Enterprises Inc., No Rights",
			"Reserved (Except for original characters/things)",
			"",
			"Dedicated to the person who made the SMAS++ 2012",
			"Beta Costume",
			"",
			"Credits are unfinished, so space will be empty",
			"until the full credits are done"
			
}

local creditsLayouts = {}
local creditsScrollY = 0
function onStart()
	Audio.MusicVolume(80)
	fadein = true
	SaveData.hideCoinCounter = true
	for i = 1, #credits do
		local text = credits[i]
		local font = textplus.loadFont("littleDialogue/font/sonicMania-smallFont.ini")
		local color = white
		local scale = 1.5
		if text == "" then
			text = " "
		elseif text == "Credits" or text == "Graphic Pack Credits" or text == "Costume/Character Credits" or text == "Asset/Other Character Credits" or text == "LunaLua Credits" or text == "Music Credits" or text == "Sound Credits" or text == "Level Credits" or text == "Boot Menu Theming Credits" or text == "Adventures of Demo (Credits)" or text == "Special thanks to:" then
			font = textplus.loadFont("littleDialogue/font/10.ini")
			--color = Color.fromHexRGBA(0x00D8F8FF)
			scale = 1.5
		end
		local layout = textplus.layout(text,nil,{font = font,color = color,xscale = scale,yscale = scale})

        table.insert(creditsLayouts,layout)
		Routine.run(scrolltext)
	end
end

function scrolltext()
	Routine.wait(22, true)
	scrolltextyes = true
end

function endcredits()
	Routine.wait(5, true)
	Level.load("SMAS - Start.lvlx", nil, nil)
end

function onTick()
    player:setFrame(50)
	player:mem(0x142, FIELD_BOOL, true)
	if Player.count() == 2 then
		player2:setFrame(50)
	end
	--Text.print(creditsScrollY,120,120)
	if creditsScrollY == 9600 then
		--Audio.MusicFadeOut(player.section, 4000)
	elseif creditsScrollY > 9600 and creditsScrollY < 9900 then
		Graphics.drawScreen{color = Color.black .. (creditsScrollY - 9600) * 0.0042, priority = 6}
	elseif creditsScrollY >= 9900 then
		Graphics.drawScreen{color = Color.black .. 1, priority = 6}
		Routine.run(endcredits)
	end
	if scrolltextyes then
		creditsScrollY = creditsScrollY + 0.8
	end
end

function onExit()
	Audio.MusicVolume(64)
end

function onInputUpdate()
	player.upKeyPressing = false;
	player.downKeyPressing = false;
	player.leftKeyPressing = false;
	player.rightKeyPressing = false;
	player.altJumpKeyPressing = false;
	player.runKeyPressing = false;
	player.altRunKeyPressing = false;
	player.dropItemKeyPressing = false;
	player.jumpKeyPressing = false;
end

function onDraw()
	local y = 0
	--Graphics.draw{type = RTYPE_IMAGE, x = 200, y = creditsScrollY*-1 + 600, image = logo, priority = 0, sceneCoords = false}
    for _,layout in ipairs(creditsLayouts) do
        textplus.render{layout = layout,priority = -1,x = 400 - layout.width*0.5,y = y - creditsScrollY + 605}

        y = y + layout.height + 4
    end
	if fadein then
		time = time - 1
		Graphics.drawScreen{color = Color.black..math.min(1,time/20),priority = 5}
	end
end
