costumes = {}

--*****************************
--** Costume info            **
--*****************************

CHARACTER_DEMO = CHARACTER_MARIO;
CHARACTER_IRIS = CHARACTER_LUIGI;
CHARACTER_KOOD = CHARACTER_PEACH;
CHARACTER_RAOCOW = CHARACTER_TOAD;
CHARACTER_SHEATH = CHARACTER_LINK;

CHARACTER_NAME = {
                    [CHARACTER_MARIO] = "Demo",
                    [CHARACTER_LUIGI] = "Iris",
                    [CHARACTER_PEACH] = "Kood",
                    [CHARACTER_TOAD]  = "Raocow",
                    [CHARACTER_LINK]  = "Sheath"
                  }

CHARACTER_CONSTANT = {
                        mario=CHARACTER_MARIO,
                        luigi=CHARACTER_LUIGI,
                        peach=CHARACTER_PEACH,
                        toad=CHARACTER_TOAD,
                        link=CHARACTER_LINK,

                        demo=CHARACTER_MARIO,
                        iris=CHARACTER_LUIGI,
                        kood=CHARACTER_PEACH,
                        raocow=CHARACTER_TOAD,
                        sheath=CHARACTER_LINK
                      }

local charids = {mario=CHARACTER_MARIO, luigi=CHARACTER_LUIGI, peach=CHARACTER_PEACH, toad=CHARACTER_TOAD, link=CHARACTER_LINK, unclebroadsword=CHARACTER_UNCLEBROADSWORD}


-- The costume IDs specific to each character
costumes.charLists = {}

--Fill this in
costumes.data = 
{
    -- Template
    DEMO_TEMPLATE   = {path = "A2XT-Demo", name = "Default"},
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
    GA_CAILLOU   = {path = "GA-Caillou", name = "Default"},
    DEMO_XMASPILY   = {path = "ZZ-Demo-XmasPily", name = "Default"},
    SMBDDX   = {path = "Demo-SMBDDX", name = "Default"}
}

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

return costumes