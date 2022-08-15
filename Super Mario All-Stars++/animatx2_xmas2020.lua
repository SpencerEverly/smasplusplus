--***************************************************************************
--*  animatx2.lua                                                           *
--*  1.0.4.4                                                                *
--***************************************************************************

local rng    = require("rng")
local vectr  = API.load ("vectr")

local animatx = {}

function animatx.onInitAPI()
    registerEvent(animatx, "onHUDDraw", "onHUDDraw", false)
    registerEvent(animatx, "onDraw", "onDraw", false)
end



--**************
--** TO-DO    **
--**************
--[[
    - check skew, shear, funnel, etc. properties to see if the hacky negative w/h fix broke them...
    - ...and/or implement a less hack-y negative w/h fix
    - Finish adding sequence commands and method functions for skew, shear, xfunnel, yfunnel and all other easeable properties
    - Move visible checks outside of the draw call and rework the draw call to accept named arguments
    - Look into allowing matrix transformation stuff as hoeloe suggested
--]]



--**************
--** OVERVIEW **
--**************
--[[

    animatx is a helper library written to simplify complex animation scripting in LunaLua/SMBX 2.0.
 
    This library works by allowing you to create Animation Set (AnimSet) objects which define the rules and limits of animated sprites.
    You may then use those to create Animation Instances (AnimInst) which animate independently from one another based on the behavior defined in their assigned AnimSet.
--]]


--***************
--** CONSTANTS **
--***************

animatx.ALIGN = {LEFT=1, RIGHT=2, TOP=3, BOTTOM=4, MID=5}
animatx.COMMAND = {
                   CHAR = {f=1,frame=1,  p=2,pause=2,  r=3,random=3,  x=4,funct=4,  c=5,color=5,  q=6,quake=6,  s=7,speed=7,  e=8,ease=8,  ls=9,loopstart=9,  le=10,loopend=10,  ro=11,rotate=11,  sh=12,shear=12,  sk=13,skew=13,  fx=14,funnelx=14,  fy=15,funnely=15,  rp=16,ripple=16},
                   NAME = {"frame",      "pause",      "rand",        "funct",      "color",      "quake",      "speed",      "ease",      "lstart",          "lend",            "rotate",         "shear",         "skew",         "funnelx",         "funnely",         "ripple"}         
                  }



--***********************
--** UTILITY FUNCTIONS **
--***********************

-- Initializes an NPC reference for exGfx animation
local function initNpc (npcRef)
    local pnpcRef = npcRef
    if  pnpcRef.data.animatx == nil  then
        pnpcRef.data.animatx = {state=1, frame=1, timer=0}
    end
end

-- Checks if a field is nil and errors if it is --
local function nilcheck(tbl, name)
    if(tbl[name] == nil) then
        error("Field \""..name.."\" cannot be nil.",2);
    end
end

local function hexToRGBATable(hex)
    if type(hex) == "Color" then
        return hex
    elseif type(hex) == "string" then
        return Color.parse(hex)
    else
        return Color.fromHexRGBA(hex)
    end
    --return {math.floor(hex/(256*256*256))/255,(math.floor(hex/(256*256))%256)/255,(math.floor(hex/256)%256)/255,(hex%256)/255}
end


local function quadPoints (x1,y1, x2,y2, x3,y3, x4,y4)
    local pts = {}
    pts[1]  = x1;      pts[2]  = y1;
    pts[3]  = x2;      pts[4]  = y2;
    pts[5]  = x4;      pts[6]  = y4;

    pts[7]  = x4;      pts[8]  = y4;
    pts[9]  = x3;      pts[10] = y3;
    pts[11] = x2;      pts[12] = y2;

    return pts
end

local function rectPointsXYXY (x1,y1,x2,y2)
    return quadPoints (x1,y1, x2,y1, x2,y2, x1,y2)
end

local function rectPointsXYWH (x,y,w,h)
    return rectPointsXYXY (x,y, x+w,y+h)
end


local function rotatePoints (pts, x,y, angle)
    local newPts = {}

    local s = math.sin(angle)
    local c = math.cos(angle)

    -- Rotate points
    for i=1, (#pts), 2  do
        local lx = pts[i]-x
        local ly = pts[i+1]-y
        local newX = lx*c - ly*s
        local newY = lx*s + ly*c

        newPts[i],newPts[i+1] = newX+x,newY+y
    end

    return newPts;
end


local function animatxToPlayerFrame(frame)
    if  frame > 50  then
        return frame-50, DIR_RIGHT
    else
        return 50-frame, DIR_LEFT
    end
end

local function playerToAnimatxFrame(frame, dir)
    if  dir == DIR_LEFT  then
        return 50-frame
    else
        return frame+50
    end
end



--***************
--** SEQUENCES **
--***************
--[[

    Sequences define the animation behavior of an Animation Set's state.  They consist of a series of "steps", each containing its' own set of commands.
    When in a given state, an AnimInst object will follow the commands of the corresponding sequence step by step.  
    Once it gets to the end of a sequence it will change to the next state in its' queue (or restart the current sequence if none are queued).
    
    Sequences should be defined as a table of strings passed in during an AnimSet's creation with the "sequences" argument.
    The basic structure of a sequence string is a series of command-number pairs separated by commas, like so:
    
    
        "frame1, frame2, frame4, frame3, frame2 loopstart, frame9, random4 quake3, frame5 pause1, frame5 loopend, frame6"
    
    
    Full sequences like that are rather awkward to read, however, so there are a number of ways to make them more compact:
    - If a command group begins with a number, that number is assumed to be the frame number. 
    - Each command has a one- or two-character shorthand equivalent.  For example, 'random' can be shortened to 'r' and 'loopstart' can be written as 'ls'.
    - If no number is specified for a given command it will default to a pre-defined value.
    - Spaces between commands or steps are optional.
    
    With the above tricks in mind, the following string is equivalent to the previous example:
    
        "1, 2, 4, 3, 2ls, 9, r4q3, 5p2, 5le, 6"
    
    
    Here are all the commands that can be used in sequence strings:
    
        Full command (shortened version)       Default       Effect
        -------------------------------------------------------------------------------------------------------------------------------
        frame      (f)                         1             Sets the AnimInst object's current frame to the given row of the state's column.

        pause      (p)                         1             Pauses the AnimInst object, preventing it from continuing the sequence for the given number of steps.

        random     (r)                         1             Sets the AnimInst object's current frame to a random frame from the given random set index.

        funct      (x)                         1             Calls a custom member function of the AnimInst object's AnimSet.

        color      (c)                         1             Sets the tint of the AnimInst object to one of the AnimSet's indexed colors.

        quake      (q)                         30            Causes the AnimInst object to shake for the given amount of time (similar to the Mother Brain NPC).

        loopstart  (ls)                        n/a           Marks the beginning of the sequence's loop.
                                                             If this command is not used, the AnimSet will always loop back to the first step of the sequence.

        loopend    (le)                        n/a           Marks the end of the sequence's loop.
                                                             If the AnimSet reaches this step when no other states are queued, it will ignore all of the other commands and 
                                                             jump to the first step of the sequence's loop.  Otherwise, this command has no effect.
                                                             if this command is not used, the AnimObject will restart or move on after completing the last step



    Sequence strings that are passed into a newly-created AnimSet are used to generate instances of the AnimSequence class.
    These objects are strictly read-only and are cached based on their string.  The following properties are accessible:


        Fields                  Return type             Description
        -------------------------------------------------------------------------------------------------------------------------------
        list                    table of tokenized      The table of commands.  You shouldn't ever need to mess with
                                commands                this but I'm including it for the sake of being thorough.

        length                  integer                 The number of steps in the sequence.

        loopStart               integer                 The step that the sequence restarts at.
                                                        If not defined with the 'loopstart' command, this defaults to 1.

        loopEnd                 integer                 The step that marks the end of the sequence's loop.
                                                        If not defined with the 'loopend' command, this defaults to (length+1).
--]]



local sequenceCache = {}

local AnimSequence = {}
local AnimSequenceMeta = {}


function AnimSequence.__index(obj,key)
    if     (key == "length") then
        local a = obj.list
        return #a
    elseif (key == "_type") then
        return "animatx sequence";

    elseif (key == "meta") then
        return AnimSequence;

    else
        return rawget(AnimSequence, key)
    end
end

function AnimSequence.__newindex(obj,key,val)
    error("The properties of generated AnimSequence objects are read-only.");
end


function AnimSequence.create (args)--str, isPlayerSheet, useOldIndexing, rows, column, frameOffset)
    --windowDebug ("GENERATING SEQUENCE FROM\n"..tostring(str))

    -- Misc variables
    local frameOffset = args.frameOffset  or  0

    -- Create sequence table
    local p = {};

    -- Sequence list
    p.list = {}
    p.loopStart = 1
    p.loopEnd = -1
    p.noAnim = false

    -- If no animation, just return that
    if  args.str == ""  then
        p.noAnim = true

    else
        -- Loop through the string step by step
        --local debugStr = "GENERATED SEQUENCE:"
        local step = 1
        for  beforeSpace, commandStr, afterCommas  in  string.gmatch(args.str, "(%s*)([^,]*)(,*)")  do

            -- Only process steps that have something for their command strings
            if  (commandStr ~= nil  and  commandStr ~= "")  then
                
                --debugStr = debugStr.."\nstep "..tostring(step)..":     <"..commandStr..">\n"
                -- Create the commands table
                local commandsTbl = {}

                -- Parse the commands string
                for  cmdChar, cmdMod  in  string.gmatch(commandStr, "(%a*)([%d%-%.]*)")  do

                    if  (cmdChar ~= nil  and  cmdChar ~= "")  or  (cmdMod ~= nil  and  cmdMod ~= "")  then  

                        --debugStr = debugStr..cmdChar.."="..cmdMod..", "
                        local cmdNm

                        -- If no leading command character, assume it's for the frame
                        if  cmdChar == nil  or  cmdChar == ""  then
                            cmdNm = "frame"

                        -- If there is a leading command character, check if it's a valid field
                        else
                            local cmdId = animatx.COMMAND.CHAR[cmdChar]  or  99
                            cmdNm = animatx.COMMAND.NAME[cmdId]

                            -- Special handling for loop start and loop end
                            if      cmdId == animatx.COMMAND.CHAR.ls  then
                                p.loopStart = step

                            elseif  cmdId == animatx.COMMAND.CHAR.le  then
                                p.loopEnd   = step
                            end
                        end

                        -- If the command name is a valid field, add it
                        if  cmdNm ~= nil  then
                            local cmdModNum = tonumber(cmdMod)

                            -- Convert player sheet and animatx1 indexing to animatx2 indexing
                            if  cmdNm == "frame"  then
                                if  args.isPlayerSheet  then
                                    if  cmdModNum <= 0  then
                                        cmdModNum = playerToAnimatxFrame(math.abs(cmdModNum), DIR_LEFT)
                                    else
                                        cmdModNum = playerToAnimatxFrame(cmdModNum, DIR_RIGHT)
                                    end
                                elseif  args.useOldIndexing == true  then
                                    cmdModNum = cmdModNum + (args.rows*(args.column-1))
                                end

                                cmdModNum = cmdModNum + frameOffset
                            end
                            commandsTbl[cmdNm] = cmdModNum
                        end
                    end
                end

                -- Insert the commands
                table.insert(p.list, commandsTbl)

                -- Increment the step
                step = step + 1
            end
        end

        --windowDebug(debugStr)

        -- If the loop end was not set in the sequence, make it the sequence length+1
        if  p.loopEnd == -1  then  p.loopEnd = step;  end; 
    end

    -- Determine whether there is animation
    p.noAnim = (next(p.list) == nil)

    -- Assign metatable and return
    setmetatable (p,AnimSequence)
    return p;
end


function animatx.Sequence (args)--str, isPlayerSheet, useOldIndexing, rows, column, frameOffset)
    -- Don't bother if given nil or an empty string
    if args.str == nil  or  args.str == ""  then
        return nil
    end
    
    -- Check for the sequence in the cache;  if it already exists, just return that
    if sequenceCache[args.str] ~= nil  then  return sequenceCache[args.str];  end;

    -- Otherwise, create a new sequence
    return AnimSequence.create (args)
end






--********************
--** ANIMATION SETS **
--********************
--[[

    AnimSets act as models or templates for AnimInst objects, containing the sprite sheet and defining the animation sequences for each state.
    
        Required arguments       Type                       Description
        -------------------------------------------------------------------------------------------------------------------------------
        sheet                    LuaImageResource           The sprite sheet used by the AnimSet.




        Optional arguments      Type                    Default       Description
        -------------------------------------------------------------------------------------------------------------------------------

        sequences               table of Strings        empty table   The sequence strings for the AnimSet's states.

        columns                 integer                 1             The number of columns on the sheet.

        rows                    integer                 1             The number of rows on the sheet.

        xOffsets                table of integers       nil           The horizontal offsets for each frame.
                                                                      Positive values shift the sprite right, negative values shift it left.

        yOffsets                table of integers       nil           The vertical offsets for each frame.
                                                                      Positive values shift the sprite down, negative values shift it up.

        randomSets              table of tables of      empty table   Groups of frame numbers to be used for the 'random' AnimSequence command.
                                integers                              Each group should be indexed by number.

        functions               table of functions      empty table   A table of functions that may be called by AnimInst objects through sequences.
                                                                      The functions should be indexed by number and have two arguments:
                                                                      the AnimSet's 'self' reference and one for passing in the AnimInst object calling it.
                                                                      The functions will be stored as AnimSet:function<key>, i.e. AnimSet:function2, so if need
                                                                      be they could be called outside of sequence processing with any given AnimInst passed in 
                                                                      (though this is not recommended).
                                                                      




    Exercise caution when changing an AnimSet's variables after creation.

        Fields                  Type                    Read-only?    Description
        -------------------------------------------------------------------------------------------------------------------------------
        sheet                   LuaImageResource                      The sprite sheet image.
        
        states                  integer                 X             The total number of animation states.

        frames                  integer                 X             The total number of frames in the sprite sheet.

        width                   integer                 X             The width of each frame, calculated from (width of sprite sheet/number of states).

        height                  integer                 X             The height of each frame, calculated from (height of sprite sheet/number of frames).

        sheetWidth              integer                 X             The width of the sprite sheet.

        sheetHeight             integer                 X             The height of the sprite sheet.

        xOffsets                table of integers                     The horizontal offsets for each frame.
                                                                      Positive values shift the sprite right, negative values shift it left.

        yOffsets                table of integers                     The vertical offsets for each frame.
                                                                      Positive values shift the sprite down, negative values shift it up.





        Functions                             Return type             Description
        -------------------------------------------------------------------------------------------------------------------------------
        Instance{named args}                  AnimInst object         Instantiate an AnimInst object from this set.
        
        getRow(int frame)                     number                  Returns the sprite sheet row of the given frame.

        getColumn(int frame)                  number                  Returns the sprite sheet column of the given frame.
        
        getOffset(int frame)                  number, number          Returns the x and y offset for the given frame.
        
        getFrameXY(int frame)                 number, number          Returns the x and y position of the frame's upper-left corner.
        
        getOffset(int frame)                  number, number          Returns the x and y offset for the given frame.

--]]


local AnimSet = {}
local AnimSetMeta = {}



function AnimSet.__index(obj,key)
    if     (key == "sheetWidth") then
        return obj.sheet.width
    elseif (key == "sheetHeight") then
        return obj.sheet.height

    elseif (key == "rows") then
        return obj._rows
    elseif (key == "columns") then
        return obj._columns

    elseif (key == "width") then
        local a=obj.sheetWidth
        local b=obj.columns
        return a/b
    elseif (key == "height") then
        local a = obj.sheetHeight
        local b = obj.rows
        return a/b

    elseif (key == "uWidth") then
        local a=obj.width
        local b=obj.sheetWidth
        return a/b
    elseif (key == "vHeight") then
        local a = obj.height
        local b = obj.sheetHeight
        return a/b

    elseif (key == "uFix") then
        local a=obj.sheetWidth
        return 1/(2*a)
    elseif (key == "vFix") then
        local a=obj.sheetHeight
        return 1/(2*a)

    elseif (key == "frames") then
        return obj.rows * obj.columns
    elseif (key == "states") then
        return obj._stateCount

    elseif(key == "_type") then
        return "animatx set";

    elseif(key == "meta") then
        return AnimSet;

    else
        return rawget(AnimSet, key)
    end
end


--animatx.popupWarnings = true
local setReadonly = {width=1, height=1, sheetWidth=1, sheetHeight=1, states=1, frames=1}
local setWarning = {sheet=1, xOffsets=1, yOffsets=1}
local warned = {}

function AnimSet.__newindex(obj,key,val)
    if     (setReadonly[key] ~= nil) then
        error ("The AnimSet class' "..key.." property is read-only.");

    elseif (setWarning[key] ~= nil  and  warned[key] ~= true  and  animatx.popupWarnings)  then
        --console.popup("<color pink>Why are you changing an AnimSet's "..key.." property after creating it?<br>Not gonna stop you, but I really hope you know what you're doing there...")
        --console.print("<color pink>Why are you changing an AnimSet's "..key.." property after creating it?")
        --console.print("<color pink>Not gonna stop you, but I really hope you know what you're doing there...")
        warned[key] = true
        rawset(obj, key, val);

    elseif (key == "_type") then
        error("Cannot set the type of AnimSet objects.",2);
    else
        rawset(obj, key, val);
    end
end



function AnimSet.create(args)
    -- Create
    local p = {};

    -- nil checks
    nilcheck (args, "sheet")

    -- Spritesheet properties
    p.sheet    = args.sheet
    p._columns = args.columns   or  1
    p._rows    = args.rows      or  1
    p.xOffsets = args.xOffsets  or  {}
    p.yOffsets = args.yOffsets  or  {}

    -- Load sheet if provided as a string
    if  type(p.sheet) == "string"  then
        p.sheet = Graphics.loadImage(Misc.resolveFile("costumes/mario/Demo-XmasPily/sheet.png"))
    end

    -- Random number sets
    p.randomSets = args.randomSets  or  {}

    -- Sequence properties
    local seqStrings = args.sequences  or  {}
    p.sequences = {}
    p._playerSet = args.isPlayerSheet
    p.oldIndexing = args.oldIndexing
    p._stateCount = 0

    for  k,v in pairs(args.sequences)  do
        if  type(v) == "string"  then
            p.sequences[k] = animatx.Sequence {str=v, isPlayerSheet=p._playerSet, useOldIndexing=p.oldIndexing, rows=p._rows, column=k}
            p._stateCount = p._stateCount + 1
        else
            error("Sequences should be defined as strings.")
        end
    end

    -- Test function
    p.test = function (self)
        windowDebug("Set test function works")
    end

    -- Custom functions
    local functs = args.functions  or  {}
    for  k,v in pairs (functs)  do
        p["function"..tostring(k)] = v
    end

    -- Assign metatable and return
    setmetatable (p,AnimSet)
    return p;
end


function animatx.Set (args)
    return AnimSet.create (args)
end


do
    function AnimSet:getRow(frame)
        local row = (frame % self.rows)
        if  row == 0  then
            row = self.rows
        end
        --windowDebug("Frame " .. tostring(frame) .. " is in row " .. tostring(row))
        return row
    end

    function AnimSet:getColumn(frame)
        local col,_ = math.floor((frame-1)/self.rows)
        --windowDebug("Frame " .. tostring(frame) .. " is in column " .. tostring(col))
        return col+1
    end

    function AnimSet:getOffset(frame)
        --windowDebug("State: "..tostring(state)..", frame: "..tostring(frame))
        local a,b = self.xOffsets[frame] or 0,  self.yOffsets[frame] or 0
        return a,b
    end

    function AnimSet:getFrameXY(frame)
        local a = self.width
        local b = self.height
        local c = self:getColumn(frame)-1
        local d = self:getRow(frame)-1

        local x,y = a*c, b*d
        --windowDebug("FRAME " .. tostring(frame) .. " X: " .. tostring(x) .. ", Y: " .. tostring(y) .. ", C: " .. tostring(c+1) .. ", R: " .. tostring(d+1))
        return x,y
    end

    function AnimSet:getFrameUV(frame)
        local a,b = self:getFrameXY(frame)
        local c,d = self.sheetWidth, self.sheetHeight
        local u,v = a/c, b/d
        
        --windowDebug("FRAME " .. tostring(frame) .. " U: " .. tostring(u) .. ", V: " .. tostring(v) .. ", X: " .. tostring(a) .. ", Y: " .. tostring(b) .. ", W: " .. tostring(c) .. ", H: " .. tostring(d))
        return u,v
    end
end



--******************************
--** ANIMATION INSTANCE CLASS **
--******************************
--[[

    (description coming later).
    

        Arguments               Type                    Default       Description
        -------------------------------------------------------------------------------------------------------------------------------




    (description coming later).

        Fields                  Return type             Read-only?    Description
        -------------------------------------------------------------------------------------------------------------------------------
        xScaleTotal             number                  X             The AnimInst's total horizontal scale calculated from (xScale*scale).

        yScaleTotal             number                  X             The AnimInst's total vertical scale calculated from (yScale*scale).
        
        width                   integer                 X             The width of the AnimInst's display rect, calculated from (set.width*xScaleTotal).

        height                  integer                 X             The height of the AnimInst's display rect, calculated from (set.width*xScaleTotal).

        left                    integer                 X             The x coordinate of the left edge of the AnimInst's display rect.

        right                   integer                 X             The x coordinate of the right edge of the AnimInst's display rect.

        top                     integer                 X             The y coordinate of the top edge of the AnimInst's display rect.

        bottom                  integer                 X             The y coordinate of the bottom edge of the AnimInst's display rect.

        xOffset                 integer                 X             The horizontal offset for the current frame.

        yOffset                 integer                 X             The vertical offset for the current frame.

        xShake                  integer                 X             The horizontal shaking offset.

        yShake                  integer                 X             The vertical shaking offset.
--]]


local AnimInst = {}
local AnimInstMeta = {}

--AnimInst.__index = AnimInst;


local vertMods     = {x=1,y=1, image=1, scale=1, xScale=1, yScale=1, xAlign=1, yAlign=1, shear=1,skew=1, angle=1, xFunnel=1,yFunnel=1, sceneCoords=1}
local uvMods       = {state=1, frame=1}
local instAliases  = {sheet="image", x1="left",y1="top",x2="right",y2="bottom"}


function AnimInst.__index(obj,key)

    if     (instAliases[key] ~= nil)  then
        return obj[instAliases[key]]

    elseif (key == "image")           then
        return (obj._image  or  obj.set.sheet)

    elseif (key == "xScaleTotal")     then
        local a=obj.scale
        local b=obj.xScale
        return a*b
    elseif (key == "yScaleTotal")     then
        local a=obj.scale
        local b=obj.yScale
        return a/b

    elseif (key == "xScaleTotalSign") then
        local a=obj.xScaleTotal
        local b=math.abs(a)
        return a/b
    elseif (key == "yScaleTotalSign") then
        local a=obj.yScaleTotal
        local b=math.abs(a)
        return a/b

    elseif (key == "width")    then
        local a=obj.set.width
        local b=math.abs(obj.xScaleTotal)
        return a*b
    elseif (key == "height")   then
        local a=obj.set.height
        local b=math.abs(obj.yScaleTotal)
        return a*b

    elseif (key == "xOffset")  then
        local b=obj.frame
        local c,_ = obj.set:getOffset(b)
        return c
    elseif (key == "yOffset")  then
        local b=obj.frame
        local _,c = obj.set:getOffset(b)
        return c

    elseif (key == "left")     then
        local a = obj.x
        if  obj.xAlign == animatx.ALIGN.LEFT    then  a = obj.x;                  end;
        if  obj.xAlign == animatx.ALIGN.RIGHT   then  a = obj.x-obj.width;        end;
        if  obj.xAlign == animatx.ALIGN.MID     then  a = obj.x-(obj.width*0.5);  end;
        return a;

    elseif (key == "right")    then
        return obj.left + obj.width

    elseif (key == "top")      then
        local a = obj.y
        if  obj.yAlign == animatx.ALIGN.TOP     then  a = obj.y;                  end;
        if  obj.yAlign == animatx.ALIGN.BOTTOM  then  a = obj.y-obj.height;       end;
        if  obj.yAlign == animatx.ALIGN.MID     then  a = obj.y-(obj.height*0.5); end;
        return a;

    elseif (key == "bottom")   then
        return obj.top + obj.height

    elseif (key == "xMid")     then
        return 0.5*(obj.left + obj.right)
    elseif (key == "yMid")     then
        return 0.5*(obj.top + obj.bottom)

    elseif (key == "rgba")     then
        return hexToRGBATable(obj.color)

    elseif (key == "states")   then
        return obj._stateCount

    elseif(key == "_type")     then
        return "animatx set";

    elseif (key == "meta")     then
        return AnimInst;

    elseif  (vertMods[key] ~= nil  or  uvMods[key] ~= nil)  then
        return rawget (obj, "_"..key)

    else
        return rawget(AnimInst, key)
    end
end


local instReadonly = {
    xScaleTotal=1, yScaleTotal=1, 
    xScaleTotalSign=1, yScaleTotalSign=1,
    left=1, right=1, top=1, bottom=1, 
    xMid=1, yMid=1, 
    width=1, height=1,
    xOffset=1, yOffset=1, xShake=1, yShake=1, rgba=1
}

function AnimInst.__newindex(obj,key,val)

    if     (instAliases[key] ~= nil)  then
        obj[instAliases[key]] = val

    elseif (instReadonly[key] ~= nil)  then 
        error ("The AnimInst class' "..key.." property is read-only.");

    elseif (key == "_type") then
        error("Cannot set the type of AnimInst objects.",2);

    elseif  (vertMods[key] ~= nil)  then
        rawset (obj, "vertsDirty", true)
        rawset (obj, "_"..key, val)

    elseif  (uvMods[key] ~= nil)  then
        rawset (obj, "uvsDirty", true)
        rawset (obj, "_"..key, val)

    else
        -- Basic rawset
        rawset(obj, key, val);
    end
end




function AnimInst.create(args, setobj)

    -- Create
    local p = {};

    -- Assign the animset argument to the one in args if necessary 
    if  args.set ~= nil  then
        setobj = args.set
    end

    -- Display properties
    p._x        = args.x        or  0
    p._y        = args.y        or  0
    p.z         = args.z        or  args.depth    or  args.priority     or  0

    p._image    = args.image    or  args.sheet
    p.color     = args.color    or  Color.white
    p.alpha     = args.alpha    or  1

    p.xAlign    = args.xAlign   or  animatx.ALIGN.MID
    p.yAlign    = args.yAlign   or  animatx.ALIGN.MID

    p.xRotate   = args.xRotate  or  animatx.ALIGN.MID
    p.yRotate   = args.yRotate  or  animatx.ALIGN.MID

    p._scale    = args.scale    or  1
    p._xScale   = args.xScale   or  1
    p._yScale   = args.yScale   or  1
    p._xFunnel  = args.xFunnel  or  0
    p._yFunnel  = args.yFunnel  or  0
    p._shear    = args.shear    or  0
    p._skew     = args.skew     or  0
    p._angle    = args.angle    or  0

    p.target      = args.target
    p.shader      = args.shader
    p.sAttributes = args.sAttributes
    p.sUniforms   = args.sUniforms

    p._sceneCoords = args.sceneCoords
    if  p._sceneCoords == nil  then  p._sceneCoords = false;  end;

    p.object    = args.object


    -- Instance-specific sequences
    p._stateCount = setobj.states
    p.sequences = {}

    if  args.sequences ~= nil  then
        for  k,v in pairs(args.sequences)  do
            if  type(v) == "string"  then
                p.sequences[k] = animatx.Sequence(v, setobj._playerSet)
                if  setobj.sequences[k] == nil  then
                    p._stateCount = p._stateCount + 1
                end
            else
                error("Sequences should be defined as strings.")
            end
        end
    end


    -- Animation properties
    p.animPriority = -1
    p.set       = setobj
    p._state    = args.state      or  1
    p.speed     = args.speed      or  1
    p.timerSize = args.timerSize  or  8
    p.frozen    = args.frozen
    if  (p.frozen == nil)  then  p.frozen = false;  end;
    p.visible   = args.visible
    if  (p.visible == nil)  then  p.visible = true;  end;
    p.animIfPaused = args.animIfPaused
    if  (p.animIfPaused == nil)  then  p.animIfPaused = false;  end;
    p.debug     = args.debug
    if  (p.debug == nil)  then  p.debug = false;  end;


    -- Control vars
    p.tableColor   = hexToRGBATable(p.color)
    p.oldColor     = p.color

    p.colorRoutine = nil

    p.verts        = {}
    p.uvs          = {}
    p.vertsDirty   = true
    p.uvsDirty     = true

    p.xShake       = 0
    p.yShake       = 0
    p.shakeTimer   = 0
    p.shakeMax     = 30

    p.animTimer    = 0
    p.step         = 1
    p._frame       = 1
    p._randomGroup = 0
    p.repeats      = 0
    p.pauseSteps   = 0

    if  p.object ~= nil  then
        p.objectLastX  = p.object.x
        p.objectLastY  = p.object.y
    end

    --[[
    p.easing = {
                color = {
                         startVal = p.color,
                         endVal   = p.color,
                         span     = 0,
                         current  = 0
                        }
               }
    --]]

    p.queue = {}


    -- Assign metatable and return
    setmetatable(p, AnimInst)
    return p;
end


function AnimInst:test()
    windowDebug("Test function works!")
end



--****************
--** COROUTINES **
--****************

function cor_easeProp(obj, prop, new, span)
end


function cor_easeColor(obj, new, span)

    -- Convert colors to rgb tables
    local newTab = hexToRGBATable(new)
    local oldTab = Color(obj.tableColor[1], obj.tableColor[2], obj.tableColor[3], obj.tableColor[4])

    local passed = 0

    while  (passed < span)  do

        -- Handle time passage
        local percent = passed/span
        passed = passed+1

        -- Handle easing for each part of the color
        for  k,v in ipairs(oldTab)  do
            obj.tableColor[k] = oldTab[k] + (newTab[k] - oldTab[k]) * percent
        end

        -- Yield
        Routine.skip()
    end
    
    -- When done, set the object's rgba table to that of the new color
    obj.tableColor = newTab
end



do
    --*************
    --** GETTERS **
    --*************
    do
        function AnimInst:getUVs ()
            local u1,v1 = self.set:getFrameUV (self.frame)
            u1,v1 = u1+self.set.uFix, v1+self.set.vFix
            local u2,v2 = u1+self.set.uWidth-self.set.uFix, v1+self.set.vHeight-self.set.vFix


            --windowDebug(" U1: " .. tostring(u1) .. ", V1: " .. tostring(v1) .. "\nU2: " .. tostring(u2) .. ", V2: " .. tostring(v2))

            return rectPointsXYXY(u1,v1,u2,v2)
        end

        function AnimInst:getVerts ()
            -- Init temp vars
            local a     = self.angle
            local sh,sk = self.shear,   self.skew
            local fx,fy = self.xFunnel, self.yFunnel

            -- Calculate rect coords
            local x1,y1 = self.left,       self.top
            local x2,y2 = self.right,      self.bottom
            local xm,ym = self.xMid,       self.yMid


            if  self.xScaleTotalSign == -1  then
                local x1Temp,x2Temp = x1,x2
                x1 = x2Temp
                x2 = x1Temp
            end

            if  self.yScaleTotalSign == -1  then
                local y1Temp,y2Temp = y1,y2
                y1 = y2Temp
                y2 = y1Temp
            end

            -- Calculate verts based on rect + shear, skew and funnel values
            pts = {}
            pts[1]  = x1 +sh+fx;    pts[2]  = y1 +sk+fy;
            pts[3]  = x2 +sh-fx;    pts[4]  = y1 -sk-fy;
            pts[5]  = x1 -sh-fx;    pts[6]  = y2 +sk-fy;

            pts[7]  = x1 -sh-fx;    pts[8]  = y2 +sk-fy;
            pts[9]  = x2 -sh+fx;    pts[10] = y2 -sk+fy;
            pts[11] = x2 +sh-fx;    pts[12] = y1 -sk-fy;


            -- Rotate
            local newPts
            if  a ~= 0  and  a ~= nil  then
                local xr,yr

                -- Determine the center of rotation
                if  self.xRotate == animatx.ALIGN.LEFT    then  xr = x1;  end;
                if  self.xRotate == animatx.ALIGN.MID     then  xr = xm;  end;
                if  self.xRotate == animatx.ALIGN.RIGHT   then  xr = x2;  end;

                if  self.yRotate == animatx.ALIGN.TOP     then  yr = y1;  end;
                if  self.yRotate == animatx.ALIGN.MID     then  yr = ym;  end;
                if  self.yRotate == animatx.ALIGN.BOTTOM  then  yr = y2;  end;

                newPts = rotatePoints (pts, xr,yr, a)
            else
                newPts = pts
            end

            return newPts
        end
    end


    --*************
    --** ACTIONS **
    --*************
    do
        function AnimInst:shake (amount)
            self.shakeTimer = amount
            self.shakeMax = self.shakeTimer
        end

        function AnimInst:setColor (newColor, timeSpan)

            -- Make sure to abort the existing routine first
            if self.colorRoutine ~= nil and self.colorRoutine.waiting then  self.colorRoutine:abort();  end;

            -- Override color cache
            if  self.color ~= newColor  then
                self.color = newColor
                self.oldColor = newColor
            end

            -- If a time span is specified, ease the color
            if  timeSpan ~= nil  then
                self.colorRoutine = Routine.run (cor_easeColor, self, newColor, timeSpan)

            -- Otherwise, just set it
            else
                self.tableColor = hexToRGBATable(newColor)
            end
        end

        function AnimInst:freeze()
            self.frozen = true
        end

        function AnimInst:unfreeze()
            self.frozen = false
        end

        function AnimInst:toggleFreeze()
            self.frozen = not self.frozen
        end
    end




    --***********************
    --** STATE PROGRESSION **
    --***********************
    do
        function AnimInst:attemptStates (states, stateArgs)
            local stateToCall = ""
            for  _,v in ipairs(states)  do
                if  self.set.sequences[v]  then
                    stateToCall = v
                    break;
                end
            end

            if  stateToCall ~= ""  then
                stateArgs.state = stateToCall
                self:startState (stateArgs)
            end
        end

        function AnimInst:startState (args)
            args.priority = args.priority  or  1

            -- If it's the same as the current state, don't restart unless forced to
            if  not self.frozen  and  args.priority >= self.animPriority  and  (self.state ~= args.state  or  args.force == true)  then

                --Misc.dialog(args.state, self.sheet, debug.traceback())
                --Misc.dialog(args)

                -- Change the state, restart the current step, restart the frame, (and restart the animation timer if specified)
                self.animPriority = args.priority
                self.state = args.state
                self.step = args.step    or  1
                self.frame = args.frame  or  1
                self._randomGroup = 0
                if  args.resetTimer == true  then  self.animTimer = 0;  end;

                -- Run the commands if specified
                if  args.commands == true  then  self:runStepCommands();  end;
            end
        end

        function AnimInst:nextState (args)
            if  args == nil  then  args = {};  end;

            local nextArgs = {force=true, resetTimer=args.resetTimer, commands=args.commands, source="NEXT FROM QUEUE"}

            if  self.onStateEnd ~= nil  then
                self:onStateEnd()
            end

            local nextState, nextStep = self.state, 1
            if  #self.queue > 0  then
                nextState = self.queue[1]
                table.remove(self.queue, 1)
                nextArgs.priority = self.animPriority
            else
                --nextArgs.force = false
            end

            if  nextState == self.state  then
                nextStateData = self.set.sequences[self.state]
                if  nextStateData ~= nil  then
                    nextStep = self.set.sequences[self.state].loopStart
                else
                    nextStep = 1
                end
            end
            nextArgs.state = nextState
            nextArgs.step = nextStep

            self:startState (nextArgs)
        end

        function AnimInst:queueState (state)
            table.insert (self.queue, state)
        end

        function AnimInst:clearQueue ()
            self.queue = {}
        end

        function AnimInst:applyStepFrame ()
            -- Check whether there is a sequence for the current state
            local curSeq = self.sequences[self.state]  or  self.set.sequences[self.state]

            -- If there is no sequence for the current state, just set the frame equal to the step
            if  curSeq == nil  then
                self.frame = self.step

            -- If there is a sequence, get the frame
            else
                -- Get the commands for the current step of the current sequence
                local curCommands = curSeq.list[self.step]

                if  curCommands ~= nil  then

                    -- Set the frame
                    if  curCommands.frame ~= nil  then
                        self.frame = curCommands.frame
                    end
                end
            end
        end

        function AnimInst:runStepCommands ()
            -- Check whether there is a sequence for the current state
            local curSeq = self.sequences[self.state]  or  self.set.sequences[self.state]
            
            -- If there is no sequence for the current state, just set the frame equal to the step
            if  curSeq == nil  then
                self.frame = self.step
            
            -- If there is a sequence, process its' commands
            else
                -- Get the commands for the current step of the current sequence
                local curCommands = curSeq.list[self.step]

                if  curCommands ~= nil  then

                    -- Easing
                    local easeSpan = curCommands.ease

                    -- Set the frame
                    if  curCommands.frame ~= nil  then
                        self._randomGroup = 0
                        self.frame = curCommands.frame
                    end

                    -- Pause
                    if  curCommands.pause ~= nil  then
                        self.pauseSteps = curCommands.pause
                    end

                    -- Random
                    if  curCommands.rand ~= nil  then
                        self._randomGroup = curCommands.rand
                        self.frame = rng.irandomEntry(self.set.randomSets[self._randomGroup])
                    end

                    -- Function
                    if  curCommands.funct ~= nil  then
                        if  self.set["function"..tostring(curCommands.funct)] ~= nil  then
                            self.set["function"..tostring(curCommands.funct)](self.set, self)
                        end
                    end

                    -- Color
                    if  curCommands.color ~= nil  then
                        local newColor = Color.white
                        if  self.set.colors[curCommands.color] ~= nil  then
                            newColor = self.set.colors[curCommands.color]
                        end
                        self:setColor(newColor, easeSpan)
                    end

                    -- Quake
                    if  curCommands.quake ~= nil  then
                        self:shake (curCommands.quake)
                    end

                    -- Speed
                    if  curCommands.speed ~= nil  then
                        self.speed = curCommands.speed
                    end
                end
            end
        end
    end


    --*********************
    --** UPDATE ROUTINES **
    --*********************
    do
        function AnimInst:update (args)
            args = args  or  {}
            self:move ()
            if  not self.frozen  then
                self:animate ()
            end
            self:render (args)
        end

        AnimInst.Draw = AnimInst.update;

        function AnimInst:move ()
            if  self.object ~= nil  then
                if  self.objectLastX ~= nil  and  self.objectLastY ~= nil  then
                    local deltaX = self.object.x - self.objectLastX
                    local deltaY = self.object.y - self.objectLastY
                    self.x = self.x + deltaX
                    self.y = self.y + deltaY
                else
                    self.x = self.object.x
                    self.y = self.object.y
                end

                self.objectLastX = self.object.x
                self.objectLastY = self.object.y
            end
        end

        function AnimInst:animate ()
            -- Color
            if  self.color ~= self.oldColor  then
                self.oldColor = self.color
                self.tableColor = hexToRGBATable (self.color)
            end                

            -- Only update the animation when the game is paused if it's allowed
            if  (not Misc.isPaused()  or  self.animIfPaused)  then

                -- Shaking
                self.shakeTimer = math.max(0, self.shakeTimer - 1)
                local shakeMult = math.min(0.2, self.shakeTimer/self.shakeMax)
                self.xShake = rng.random(-32,32)*shakeMult
                self.yShake = rng.random(-32,32)*shakeMult

                -- Increment animation timer
                self.animTimer = self.animTimer + self.speed

                -- Progress to the next step of the sequence if necessary
                while  (self.animTimer > self.timerSize)  do

                    -- Subtract the frame count from the anim timer
                    self.animTimer = self.animTimer - self.timerSize

                    -- Get the current sequence object
                    local curSeq = self.set.sequences[self.state]
                    
                    local hasAnim = true
                    if  curSeq ~= nil  then  
                        if  curSeq.noAnim == true  then
                            hasAnim = false
                        end
                    end

                    -- Manage pausing;  prevent further step processing until pauseSteps is 0
                    self.pauseSteps = math.max(0, self.pauseSteps - 1)

                    if  self.pauseSteps == 0  and  hasAnim == true  then

                        -- Next step
                        self.step = self.step + 1

                        -- If there is no sequence for the current state, cycle through the frames normally
                        if  curSeq == nil  then

                            -- If no more frames, end the current state and start the next
                            if  self.step > self.set.frames  then
                                self:nextState()
                            end

                        -- If we are working with a sequence, loop and follow commands accordingly
                        else
                            -- If at the loop and no states are queued, return to the loop start step
                            if  self.step == curSeq.loopEnd  and  #self.queue == 0  then
                                self.step = curSeq.loopStart
                                
                            -- If no more steps are left, end the current state and start the next
                            elseif  self.step > curSeq.length  then
                                self:nextState()
                            end
                        end

                        -- Process the commands of whatever step in whatever sequence we're at now
                        self:runStepCommands()
                    end
                end
            end
        end

        function AnimInst:render (args)
            args = args or {}
            -- Don't bother if not visible
            if  self.visible == false  or  self.x == nil  or  self.y == nil  then  return;  end;


            -- Get verts
            local ptsCached
            if  self.vertsDirty == false  then
                ptsCached = self.verts
            else
                ptsCached = self:getVerts()
                self.verts = ptsCached
            end

            local pts = {}
            for  i=1,11,2  do
                pts[i]   = ptsCached[i]   + self.xShake + self.xOffset
                pts[i+1] = ptsCached[i+1] + self.yShake + self.yOffset
            end


            -- Get UVs
            local uvs
            if  self.uvsDirty == false  then
                uvs = self.uvs
            else
                uvs = self:getUVs()
                self.uvs = uvs
            end


            -- Alpha mult
            local alphaMultTableColor = Color(self.tableColor[1], self.tableColor[2], self.tableColor[3], self.tableColor[4]*self.alpha)


            -- Debug
            if  self.debug  then
                local cam = camera
                local debugCols = {1,0.5,0.5,0.25}
                if  self.vertsDirty  or  self.uvsDirty  then
                    debugCols = {0.5,1,0.5,0.5}
                end

                -- Full area rect
                Graphics.glDraw {
                                 vertexCoords  = pts,
                                 color         = debugCols,
                                 primitive     = Graphics.GL_TRIANGLES,
                                 priority      = self.z,
                                 sceneCoords   = self.sceneCoords
                                }

                -- Full area rect, no offset
                Graphics.glDraw {
                                 vertexCoords  = ptsCached,
                                 color         = {1,0.5,0.5,0.25},
                                 primitive     = Graphics.GL_TRIANGLES,
                                 priority      = self.z,
                                 sceneCoords   = self.sceneCoords
                                }

                -- Origin bound to the screen
                local boundX = math.max(0,math.min(800,self.x-cam.x))
                local boundY = math.max(0,math.min(600,self.y-cam.y))

                Graphics.glDraw {vertexCoords  = rectPointsXYWH(boundX-2,boundY-2,4,4),
                                 color         = {0.25,0.25,1,0.5},
                                 primitive     = Graphics.GL_TRIANGLES,
                                 priority      = self.z,
                                 sceneCoords   = false
                                }

                -- Origin
                Graphics.glDraw {vertexCoords  = rectPointsXYWH(self.x-4,self.y-4,8,8),
                                 color         = {1,0.25,0.25,0.5},
                                 primitive     = Graphics.GL_TRIANGLES,
                                 priority      = self.z,
                                 sceneCoords   = self.sceneCoords
                                }
            end

            -- Draw
            Graphics.glDraw {vertexCoords  = pts,
                             textureCoords = uvs, 
                             priority      = args.z  or  args.priority  or  self.z,
                             color         = args.color       or  alphaMultTableColor,
                             texture       = args.image       or  self.image,
                             primitive     = Graphics.GL_TRIANGLES,
                             sceneCoords   = self.sceneCoords,
                             shader        = args.shader      or  self.shader,
                             attributes    = args.attributes  or  self.sAttributes,
                             uniforms      = args.uniforms    or  self.sUniforms,
                             target        = args.target      or  self.target
                            }

            -- Reset dirty flags
            self.vertsDirty   = false
            self.uvsDirty     = false
        end
    end
end


function AnimSet:Instance (args)
    local returnObj = AnimInst.create(args, self)

    --[[
    local str = "OBJECT:\n"
    for k,v in pairs(returnObj) do
        if  type(v)  ~=  "userdata"  then
            str = str .. "\n" .. k .. ":  " .. (tostring(v))
        end
    end

    str = str .. "\n\nMETATABLE:\n"

    for k,v in pairs(returnObj.meta) do
        if  type(v)  ~=  "userdata"  then
            str = str .. "\n" .. k .. ":  " .. (tostring(v))
        end
    end

    windowDebug (str)
    --]]

    -- Run the first step's commands if applicable
    local curSeq = returnObj.set.sequences[returnObj.state]
    local noAnim = true
    if  curSeq ~= nil  then
        noAnim = curSeq.noAnim
    end
    
    if  noAnim == false  then  returnObj:runStepCommands();  end;
    return returnObj
end



return animatx;