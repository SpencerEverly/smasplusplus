--***************************************************************************************
--                                                                                      *
--  inputos.lua                                                                          *
--  v1.3                                                                                *
--                                                                                      *
--***************************************************************************************


--[[
    Vars:  
        inputos.locked[keystr] -- if true, SMBX does not process this input, but the state
                                 is still recorded by this library.
                             
        inputos.state[keystr]  -- the current state of that key (read-only)
        
    keystrings are same as the respective fields, all lowercase
    (I.E. player.leftKeyPressing --> "left",  player.dropItemKeyPressing --> "dropItem")
    
    state constants are inputos.UP
                        inputos.PRESS
                        inputos.HOLD
                        inputos.RELEASE
--]]



local inputos = {} --Package table

    function inputos.onInitAPI()
        registerEvent(inputos, "onLoop", "onLoop", true)
        registerEvent(inputos, "onInputUpdate", "onInputUpdate", true)
    end


    
    --***********************************************************************************
    --                                                                                  *
    --  State constants                                                                 *
    --                                                                                  *
    --***********************************************************************************
    
    do
        inputos.UP = 0
        inputos.PRESS = 1
        inputos.HOLD = 2
        inputos.RELEASE = 3
    end

    
    
    --***********************************************************************************
    --                                                                                  *
    --  State table                                                                     *
    --                                                                                  *
    --***********************************************************************************
    
    do
        inputos.state = {}
        inputos.state["up"] = inputos.UP
        inputos.state["down"] = inputos.UP
        inputos.state["left"] = inputos.UP
        inputos.state["right"] = inputos.UP
        inputos.state["jump"] = inputos.UP
        inputos.state["altjump"] = inputos.UP
        inputos.state["run"] = inputos.UP
        inputos.state["altrun"] = inputos.UP
        inputos.state["dropitem"] = inputos.UP
        inputos.state["pause"] = inputos.UP
        inputos.state["any"] = inputos.UP
        inputos.state["all"] = inputos.UP
    end

    

    --***********************************************************************************
    --                                                                                  *
    --  Lock table                                                                      *
    --                                                                                  *
    --***********************************************************************************
    
    do
        inputos.locked = {}
        inputos.locked["all"] = false
        inputos.locked["up"] = false
        inputos.locked["down"] = false
        inputos.locked["left"] = false
        inputos.locked["right"] = false
        inputos.locked["jump"] = false
        inputos.locked["altjump"] = false
        inputos.locked["run"] = false
        inputos.locked["altrun"] = false
        inputos.locked["dropitem"] = false
        inputos.locked["pause"] = false
    end
    
    
    inputos.key = {}
    
    
    inputos.debug = false
    
    
    --***********************************************************************************
    --                                                                                  *
    --  Update input                                                                    *
    --                                                                                  *
    --***********************************************************************************
    
    local anyPressed = false
    local anyHeld = false
    local anyReleased = false
        
    
    function inputos.onLoop ()
        -- Debug
        if  inputos.debug == true  then

            Text.print ("Any Press: "..tostring(anyPressed), 20, 380)
            Text.print ("Any Hold: "..tostring(anyHeld), 20, 400)
            Text.print ("Any Release: "..tostring(anyReleased), 20, 420)
            
            i = 0
            
            for k,v in pairs(inputos.state) do
            
                    local debugStr = tostring(k)..": "..tostring(inputos.state[k])
                    
                    if  inputos.locked[k] == true  then
                        debugStr = debugStr.." (L)"
                    end

                    Text.print (debugStr, 20, 80 + 20*i)
                i = i+1
            end
        end
    end
    

    

    function inputos.onInputUpdate ()        
        inputos.key["up"] = player.upKeyPressing
        inputos.key["down"] = player.downKeyPressing
        inputos.key["left"] = player.leftKeyPressing
        inputos.key["right"] = player.rightKeyPressing
        inputos.key["jump"] = player.jumpKeyPressing
        inputos.key["altjump"] = player.altJumpKeyPressing
        inputos.key["run"] = player.runKeyPressing
        inputos.key["altrun"] = player.altRunKeyPressing
        inputos.key["dropitem"] = player.dropItemKeyPressing
        inputos.key["pause"] = player.pauseKeyPressing
    
    
        -- STORE INPUT STATE FOR EACH KEY
        local i = 0
        anyPressed = false
        anyHeld = false
        anyReleased = false
        
        for k,v in pairs(inputos.state) do
            if  k ~= "any"  then
                if  inputos.state[k] == inputos.UP            then
                    if     inputos.key[k] == true     then
                        inputos.state[k] = inputos.PRESS
                        anyPressed = true
                    end
                
                elseif inputos.state[k] == inputos.PRESS        then
                    inputos.state[k] = inputos.HOLD
                
                elseif inputos.state[k] == inputos.HOLD        then
                    anyHeld = true
                    
                    if     inputos.key[k] == false     then
                        inputos.state[k] = inputos.RELEASE
                        anyReleased = true
                    end
                
                elseif inputos.state[k] == inputos.RELEASE    then
                    inputos.state[k] = inputos.UP
                
                end
            end
        end
        
        
        -- Any key
        if  (anyPressed == true)  and  inputos.state["any"] == inputos.UP  then
            inputos.state["any"] = inputos.PRESS
        
        elseif  (anyHeld == true)  and  inputos.state["any"] == inputos.PRESS  then
            inputos.state["any"] = inputos.HOLD

        elseif  anyPressed == false  and  anyHeld == false  and  inputos.state["any"] == inputos.HOLD  then
            inputos.state["any"] = inputos.RELEASE
        
        elseif  inputos.state["any"] == inputos.RELEASE  then
            inputos.state["any"] = inputos.UP
        end

        
        
        -- Disable locked keys
        if  inputos.locked["up"] == true         then  player.upKeyPressing = false;             end
        if  inputos.locked["down"] == true       then  player.downKeyPressing = false;           end
        if  inputos.locked["left"] == true       then  player.leftKeyPressing = false;           end
        if  inputos.locked["right"] == true      then  player.rightKeyPressing = false;          end
        if  inputos.locked["jump"] == true       then  player.jumpKeyPressing = false;           end
        if  inputos.locked["altjump"] == true    then  player.altJumpKeyPressing = false;        end
        if  inputos.locked["run"] == true        then  player.runKeyPressing = false;            end
        if  inputos.locked["altrun"] == true     then  player.altRunKeyPressing = false;         end
        if  inputos.locked["dropitem"] == true   then  player.dropItemKeyPressing = false;       end
        if  inputos.locked["pause"] == true      then  player.pauseKeyPressing = false;          end
        
        -- disable all keys
        if  inputos.locked["all"] == true        then  
            player.upKeyPressing = false;
            player.downKeyPressing = false;
            player.leftKeyPressing = false;
            player.rightKeyPressing = false; 
            player.jumpKeyPressing = false;
            player.altJumpKeyPressing = false; 
            player.runKeyPressing = false;
            player.altRunKeyPressing = false;
            player.dropItemKeyPressing = false;
            player.pauseKeyPressing = false;
        end

        
    end

return inputos