costumes = {}

--*****************************
--** Costume info            **
--*****************************

local charids = {mario=CHARACTER_MARIO, luigi=CHARACTER_LUIGI, peach=CHARACTER_PEACH, toad=CHARACTER_TOAD, link=CHARACTER_LINK, unclebroadsword=CHARACTER_UNCLEBROADSWORD}


-- The costume IDs specific to each character
costumes.charLists = {}

--Fill this in
costumes.data = 
{
	-- Template
	DEMO_TEMPLATE   = {path = "Demo-Centered", name = "Default"},
	IRIS_TEMPLATE   = {path = "Iris-Centered", name = "Default"},
	KOOD_TEMPLATE   = {path = "Kood-Centered", name = "Default"},
	RAOCOW_TEMPLATE = {path = "Raocow-Centered", name = "Default"},
	SHEATH_TEMPLATE = {path = "Sheath-Centered", name = "Default"},
	
	--Player 2 Set
	DEMO_PLAYER2   = {path = "Demo-Player2", name = "Player 2", collectName = "Player 2 (Demo)", set = "PLAYER2"},
	IRIS_PLAYER2   = {path = "Iris-Player2", name = "Player 2", collectName = "Player 2 (Iris)", set = "PLAYER2"},
	KOOD_PLAYER2   = {path = "Kood-Player2", name = "Player 2", collectName = "Player 2 (Kood)", set = "PLAYER2"},
	RAOCOW_PLAYER2 = {path = "Raocow-Player2", name = "Player 2", collectName = "Player 2 (Raocow)", set = "PLAYER2"},
	SHEATH_PLAYER2 = {path = "Sheath-Player2", name = "Player 2", collectName = "Player 2 (Sheath)", set = "PLAYER2"},


	-- Unique
	DEMO_BOBBLE = {path = "Demo-BobbleHat", name = "Bobble Hat Demo"},
	DEMO_SAFETYBEE = {path = "Demo-SafetyBee", name = "D the Safety Bee"},

	--[[
	IRIS_XMAS = {path = "Iris-Centered", name = "Christmas Tree Iris"},
	IRIS_CATPLANET = {path = "Iris-Centered", name = "Cat Planet Cat"},

	KOOD_DOCTOR = {path = "Kood-Centered", name = "Doctor Kood"},
	KOOD_ROBIN = {path = "Kood-Centered", name = "Robin Kood"},

	RAOCOW_SKELETON = {path = "Raocow-Centered", name = "Skelecow"},
	RAOCOW_MEGAMAN = {path = "Raocow-Centered", name = "Megacow"},
	RAOCOW_MIKE = {path = "Raocow-Centered", name = "Mike Raones"},
	RAOCOW_CLASSIC = {path = "Raocow-Centered", name = "Vintage Raocow"},

	SHEATH_SHETH = {path = "Sheath-Centered", name = "SHETH"},
	SHEATH_BOKI = {path = "Sheath-Centered", name = "Boki"},
	]]
}

-- Sets
--[[
local setData = {
	Player2 = {},
	Paper = {},
	Gameboy = {
		costName = "GB"
	},
	Cosplay = {
		uniqueNames = {Kood="Princess Kood", Sheath="Lanko"}
	},
	Cat = {
		uniqueNames = {Demo="Demeow", Iris="Irhiss", Kood="Mewd", Raocow="Meowcow"}
	},
	Robot = {
		uniqueNames = {Demo="D3.M0", Iris="IrIS Mk.II", Kood="Koodborg", Raocow="Robocow", Sheath="Sh347h"}
	},
	Real = {
		uniqueNames = {Demo="Daisy Maria Owen", Iris="Iris Owen", Kood="Duke the Turtle", Raocow="Let's Player raocow", Sheath="Sarah Heath"}
	}
}
for  _,v in pairs(charids)  do
	if  v ~= CHARACTER_UNCLEBROADSWORD  then
		local name = CHARACTER_NAME[v]
		local uName = string.upper(name)
		local lName = string.lower(name)

		for  k2,v2 in pairs{setData}  do
			local setName = k2
			local uSetName = string.upper(k2)
			local uniqueName
			if  v2.uniqueNames ~= nil  then
				uniqueName = v2.uniqueNames[name]
			end

			costumes.data[uName.."_"..uSetName] = {path = name.."-"..setName, name = uniqueName  or  (v2.costName  or  setName).." "..name, set=uSetName}
		end
	end
end
--]]

costumes.defaults =
{	
	[CHARACTER_DEMO] = "DEMO_TEMPLATE";
	[CHARACTER_IRIS] = "IRIS_TEMPLATE";
	[CHARACTER_KOOD] = "KOOD_TEMPLATE";
	[CHARACTER_RAOCOW] = "RAOCOW_TEMPLATE";
	[CHARACTER_SHEATH] = "SHEATH_TEMPLATE";
}

local reference = {}

for k,v in pairs(costumes.data) do
	reference[v.path] = k;
end

-- Properties for each costume
costumes.info = {}
for  _,v1 in ipairs(Misc.listDirectories(Misc.episodePath().."costumes"))  do
	for  _,v2 in ipairs(Misc.listDirectories(Misc.episodePath().."/costumes/"..v1))  do
		local costume_id = reference[v2];
		
		if(costume_id) then
			local cid = charids[v1]

			if  costumes.charLists[cid] == nil  then
				costumes.charLists[cid] = {}
			end
			local charList = costumes.charLists[cid]
			
			table.insert(charList, costume_id);

			local info = {
				path = "costumes/"..v1.."/"..v2,
				id = costume_id,
				costume = v2,
				name = costumes.data[costume_id].name,
				collectName =  costumes.data[costume_id].collectName or costumes.data[costume_id].name,
				character = cid,
				characterName = v1
				-- any other properties defined in a text document maybe?
			}
			info.animatx = Graphics.loadImage(info.path.."/"..v1.."_anmx.png")

			costumes.info[costume_id] = info
		end

	end
end


--*****************************
--** Save data management    **
--*****************************

if  SaveData.costumes == nil  then
	SaveData.costumes = {}
end


function costumes.getUnlocked (character)
	local unlocked = {}
	if(costumes.charLists[character])then
		for  _,v in ipairs (costumes.charLists[character])  do
			if  SaveData.costumes[v]  then
				table.insert(unlocked, v)
			end
		end
	end

	return unlocked
end

function costumes.getCurrent(character)
	local current = Player.getCostume(character);
	if(current) then
		current = current:upper();
	else
		return nil;
	end
	for  _,v in ipairs (costumes.charLists[character])  do
		if(costumes.data[v] and costumes.data[v].path:upper() == current) then
			return v;
		end
	end
	return nil;
end

function costumes.isDefault (character)
	return  (costumes.getCurrent(character) == costumes.defaults[character])
end

function costumes.unlock (id)
	if(not id:match("_TEMPLATE$")) then
		SaveData.costumes[id] = true
	end
end


function costumes.wear (id)
	local info = costumes.info[id]
	--Misc.dialog{tostring(id),info}
	Player.setCostume(info.character, info.costume)
end

registerEvent(costumes,"onStart","onStart",false);
registerEvent(costumes,"onDraw","onDraw",false);
registerEvent(costumes,"onTickEnd","onTickEnd",false);

local playerId
local powerId
local pHitbox

function costumes.onStart()
	playerId = player.character
	powerId = player.powerup
	pHitbox = Colliders.getHitbox(player)

	--[[
	for i=1,5 do
		if(Player.getCostume(i) == nil) then
			costumes.wear(costumes.defaults[i]);
		end
	end
	--]]
end

function costumes.onTickEnd()
	if  playerId ~= player.character  or  powerId ~= player.powerup  and  player:mem(0x122,FIELD_WORD) <= 0  then
		pHitbox:Debug(false)
		playerId = player.character
		powerId = player.powerup
		pHitbox = Colliders.getHitbox(player)
	end

	pHitbox.x = player.x
	pHitbox.y = player.y
end

function costumes.onDraw()
	pHitbox:Debug(GameData.showPlayerHitbox);
end

return costumes