local letterWidths = {
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},

    --     L  O  A  D  I  N  G  .  .  .
    {52,16,16,16,8, 20,16,10,10,46},
}

package.path = package.path .. ";./scripts/?.lua"
-- Address of the first player's character. Equivalent to 'player.character', except the player class doesn't exist in loading screens
local FIRST_PLAYER_CHARACTER_ADDR = mem(0x00B25A20,FIELD_DWORD) + 0x184 + 0xF0

local episodePath = mem(0x00B2C61C, FIELD_STRING)

local image = Graphics.loadImage("loadscreen.png")

local loadicon = Graphics.loadImage("hardcoded-30-5.png")

local frame = 0
local frame2 = 0
local timer = 0
local speed = 0

local letterData = {}


local time = 0

function onDraw()
    if image == nil then -- this sometimes happens?
        return
    end

    local message = mem(FIRST_PLAYER_CHARACTER_ADDR,FIELD_WORD)
    local widths = letterWidths[message]

    if widths == nil then
        message = #letterWidths
        widths = letterWidths[message]
    end


    local opacity = math.min(1,time/42)

    local height = (image.height/#letterWidths)
    local sourceY = (message-1) * height

    local baseX = (400 - image.width*0.5)
    local baseY = (300 - height*0.5 - 32)
    local xOffset = 0

    local count = #widths
	
	speed = speed - 1
	Graphics.drawImage(loadicon, 672, 536, 0, frame2 * 64, 128, 64,opacity)
	frame = math.floor(timer/speed)%7
	timer = timer + 1	
	frame2 = math.floor(timer/8)%7

    for index,width in ipairs(widths) do
        letterData[index] = letterData[index] or {offset = 0,speed = 0}
        local data = letterData[index]

        if (time/8)%(count+8) == index-1 then
            data.speed = -3.5
        end

        data.speed = data.speed + 0.26
        data.offset = math.min(0,data.offset + data.speed)
		
        Graphics.drawImage(image,baseX+xOffset,baseY+data.offset,xOffset,sourceY,width,height,opacity)
        xOffset = xOffset + width
    end


    time = time + 1
end