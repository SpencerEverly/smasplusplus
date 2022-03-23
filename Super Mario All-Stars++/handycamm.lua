--- A library for manipulating the SMBX camera in interesting ways. Cameras can be constructed or accessed by simply indexing the library. For example `local myCam = handycam[1]` will get the camera associated with player 1.
-- @module handycam

local handycam = {}

local clamp = math.clamp
local lerp = math.lerp
local anglelerp = math.anglelerp
local invlerp = math.invlerp
local huge = math.huge
local min = math.min
local max = math.max
local sqrt = math.sqrt
local floor = math.floor

local tableinsert = table.insert
local tableremove = table.remove

local type = type

local crispShader = Shader()
crispShader:compileFromFile("scripts/shaders/crisp.vert", "scripts/shaders/crisp.frag")

function handycam.onInitAPI()
	registerEvent(handycam, "onDrawEnd")
	registerEvent(handycam, "onCameraUpdate", "onCameraUpdate", true)
	registerEvent(handycam, "onCameraDraw", "onCameraDraw", false)
end

--Used to avoid pairs calls
local propertyList = { "x", "y", "rotation", "zoom", "targets", "xOffset", "yOffset" }

local propertyMap = table.map(propertyList)

local activeList = {}

handycam.enableCrispUpscale = true

--- A camera object, connected to a specific SMBX camera. Setting most properties to `nil` will revert them to default behaviour.
	-- @type HandyCamera

	---
	-- @tparam number x The x position of the centre of the camera.
	-- @tparam number y The y position of the centre of the camera.
	-- @tparam number rotation The rotation of the camera in degrees.
	-- @tparam number zoom The zoom factor of the camera.
	-- @tparam table targets A table of focus targets for the camera to look at.
	-- @tparam number xOffset When not overridden by setting `x`, this offsets the camera from its computed target focus, horizontally. 
	-- @tparam number yOffset When not overridden by setting `y`, this offsets the camera from its computed target focus, vertically. 
	-- @tparam number width [READONLY] The zoomed width of the camera.
	-- @tparam number height [READONLY] The zoomed height of the camera.
	-- @tparam bool isValid [READONLY] Determines whether the camera is valid or not (`HandyCamera`s can be invalidated by calling `release()`).
	-- @tparam number idx [READONLY] The camera index associated with this particular `HandyCamera`.
	-- @table _


	
local function interp(v, default)
	if type(v) == "table" and v._transition then
		local t = v[3]/v[4]
		if v.ease ~= nil then
			t = v.ease(t)
		end
		return lerp(v[1] or default, v[2] or default, t)
	else
		return v or default
	end
end

local function angleinterp(v, default)
	if type(v) == "table" and v._transition then
		local t = v[3]/v[4]
		if v.ease ~= nil then
			t = v.ease(t)
		end
		return anglelerp(v[1] or default, v[2] or default, t)
	else
		return v or default
	end
end

--Gets the section boundary
local function getBounds(cam)
	return Section(Player(cam._ref.idx).section).boundary
end

--Gets zoomed width
local function getCamWidth(cam)
	return cam._ref.width/cam.zoom
end

--Gets zoomed height
local function getCamHeight(cam)
	return cam._ref.height/cam.zoom
end

--Gets zoomed size
local function getCamSize(cam)
	local z = 1/cam.zoom
	return cam._ref.width*z, cam._ref.height*z
end


local function validateTargets(targets)
	if targets == nil then return end
	for i = #targets,1,-1 do
		if targets[i].isValid == false then
			tableremove(targets, i)
		end
	end
end

--Calculate desired zoom level from a list of targets (clamped between 1 and 2)
local function calcTargetZoom(cam, targets)

	validateTargets(targets)
	
	if targets == nil or #targets < 2 or not cam.autozoom then
	
		--Don't bother zooming if we only have one target or the camera is set not to auto-zoom
		return 1
	end
	
	--Find bounding rectangle of all targets
	local minx, miny, maxx, maxy = huge, huge, -huge, -huge
	
	for _,v in ipairs(targets) do
		local x = v.x
		local y = v.y
		
		if x < minx then
			minx = x
		end
		
		if v.width ~= nil then
			x = x + v.width
		end
		
		if x > maxx then
			maxx = x
		end
		
		if y < miny then
			miny = y
		end
		
		if v.height ~= nil then
			y = y + v.height
		end
		
		if y > maxy then
			maxy = y
		end
	end
	
	local xOffset = cam.xOffset
	local yOffset = cam.yOffset
	maxx = maxx + xOffset
	minx = minx + xOffset
	maxy = maxy + yOffset
	miny = miny + yOffset
	
	--Clamp each coordinate to the section bounds
	local bounds = getBounds(cam)
	maxx = clamp(maxx, bounds.left, bounds.right)
	minx = clamp(minx, bounds.left, bounds.right)
	maxy = clamp(maxy, bounds.top, bounds.bottom)
	miny = clamp(miny, bounds.top, bounds.bottom)
	
	--Find size of bounding rectangle
	local h = maxy-miny
	local w = maxx-minx
	
	h = h+64
	w = w+64
	--Find zoom levels for each axis of the bounding rectangle
	local hz = cam._ref.width/w
	local vz = cam._ref.height/h
	
	--Use the zoom level that will fit all targets on screen, clamped between 1 and 2
	return clamp(min(hz, vz), 1, 2)
end

--Compute the default zoom level, used if the zoom property is nil
local function computeTargetZoom(cam)
	local z
	if cam._properties.targets == nil or #cam._properties.targets < 2 then
		--If focussing on one target, don't bother adjusting zoom
		z = 1 
		
	elseif cam._properties.targets._transition then
	
		--If targets are mid-transition, find respecting zoom levels and lerp between them
		local z1 = calcTargetZoom(cam, cam._properties.targets[1])
		local z2 = calcTargetZoom(cam, cam._properties.targets[2])
				
		local t = cam._properties.targets[3]/cam._properties.targets[4]
		if cam._properties.targets.ease ~= nil then
			t = cam._properties.targets.ease(t)
		end
				
		z = lerp(z1, z2, t)
		
	else
	
		--If targets are static, compute desired zoom
		z = calcTargetZoom(cam, cam._properties.targets)
		
	end
	return z
end

--Calculate desired position from a list of targets (clamped between 1 and 2)
local function calcTargetPos(cam, targets)

	local xt,yt
		
	validateTargets(targets)

	if targets == nil or #targets == 0 then
	
		--If we have no target, point at our respective player
		local p = Player(cam._ref.idx)
		
		xt = p.x+p.width*0.5
		yt = p.y+p.height
	elseif #targets == 1 and type(targets[1]) == "Player" then
	
		local p = targets[1]
		
		xt = p.x+p.width*0.5
		yt = p.y+p.height
		
	else
		
		--Find bounding rectangle of all targets
		local minx, miny, maxx, maxy = huge, huge, -huge, -huge

		for _,v in ipairs(targets) do
			local x = v.x
			local y = v.y
			
			if x < minx then
				minx = x
			end
			
			if v.width ~= nil then
				x = x + v.width
			end
			
			if x > maxx then
				maxx = x
			end
			
			if y < miny then
				miny = y
			end
			
			if v.height ~= nil then
				y = y + v.height
			end
			
			if y > maxy then
				maxy = y
			end
		end
		
		--Find centre of bounding rectangle
		xt = (minx+maxx)*0.5
		yt = (miny+maxy)*0.5
	end
	
	xt = xt + cam.xOffset
	yt = yt + cam.yOffset
	
	--Get the section bounds
	local bounds = getBounds(cam)
	
	--If the zoom level is changing, going to need more calculation for smoother positioning
	local v = cam._properties.zoom
	if type(v) == "table" and v._transition then
			
		
		--Compute start and end zoom levels
		local z1 = v[1]
		local z2 = v[2]
		
		if z1 == nil then
			z1 = computeTargetZoom(cam)
			if z2 == nil then
				z2 = z1
			end
		elseif z2 == nil then
			z2 = computeTargetZoom(cam)
		end
		
		--Find parameterised zoom level
		local z,t
		
		--If z1 = z2, invlerp will produce NaN, so shortcut around it
		if z1 == z2 then
			z = z1
			t = 0
		else
			z = cam.zoom
			t = clamp(invlerp(z1, z2, z),0,1)
		end
		
		--Area/length ratio means a square root is necessary
		t = sqrt(t)
		
		
		--Find clamped coordinates for each zoom level
		z1 = 1/z1
		z2 = 1/z2
		
		local cw,ch = cam._ref.width, cam._ref.height
		
		local xt1 = clamp(xt, bounds.left + cw*0.5*z1, bounds.right - cw*0.5*z1)
		local yt1 = clamp(yt, bounds.top + ch*0.5*z1, bounds.bottom - ch*0.5*z1)
		local xt2 = clamp(xt, bounds.left + cw*0.5*z2, bounds.right - cw*0.5*z2)
		local yt2 = clamp(yt, bounds.top + ch*0.5*z2, bounds.bottom - ch*0.5*z2)
		
		cw,ch = cw/z, ch/z
		
		--Lerp between zoom levels, clamping the result
		xt = clamp(lerp(xt1,xt2,t), bounds.left + cw*0.5, bounds.right - cw*0.5)
		yt = clamp(lerp(yt1,yt2,t), bounds.top + ch*0.5, bounds.bottom - ch*0.5)
	else
	
		--Clamp position to the section bounds
		local cw,ch = getCamSize(cam)
		
		xt = clamp(xt, bounds.left + cw*0.5, bounds.right - cw*0.5)
		yt = clamp(yt, bounds.top + ch*0.5, bounds.bottom - ch*0.5)
	end
	
	return xt, yt
end

--Compute the default position, used if the x or y properties are nil
local function computeTargetPosition(cam)
	local x,y		
	
	if cam._properties.targets == nil or (#cam._properties.targets == 0 and cam._properties.targets._transition == nil) then
	
		--If we have no target, point at our respective player
		local x1,y1 = calcTargetPos(cam, { Player(cam._ref.idx) })
		x = x or x1
		y = y or y1
		
	elseif cam._properties.targets._transition then
	
		--If targets are mid-transition, find respecting positions and lerp between them
		local x1,y1 = calcTargetPos(cam, cam._properties.targets[1])
		local x2,y2 = calcTargetPos(cam, cam._properties.targets[2])
		
		local t = cam._properties.targets[3]/cam._properties.targets[4]
		if cam._properties.targets.ease ~= nil then
			t = cam._properties.targets.ease(t)
		end
		
		x = x or (lerp(x1, x2, t))
		y = y or (lerp(y1, y2, t))
		
	else
	
		--If targets are static, compute desired positions
		local x1,y1 = calcTargetPos(cam, cam._properties.targets)
		x = x or x1
		y = y or y1
		
	end
	return x,y
end

--Calculates the current position of the camera
local function computePosition(cam)
	local x,y
	
	local tx,ty
	if type(cam._properties.x) == "table" and cam._properties.x._transition and (cam._properties.x[1] == nil or cam._properties.x[2] == nil) then

		--If we're transitioning from or to a "nil" state, we need to use the target position for that field, so do that and interpolate
		tx,ty = computeTargetPosition(cam)
		x = interp{ cam._properties.x[1] or tx, cam._properties.x[2] or tx, cam._properties.x[3], cam._properties.x[4], ease = cam._properties.x.ease, _transition = true}
		
	else
	
		--Otherwise just interpolate the property
		x = interp(cam._properties.x)
		
	end
	
	if type(cam._properties.y) == "table" and cam._properties.y._transition and (cam._properties.y[1] == nil or cam._properties.y[2] == nil) then
	
	
		--If we're transitioning from or to a "nil" state, we need to use the target position for that field, so do that and interpolate
		if ty == nil then
			tx,ty = computeTargetPosition(cam)
		end
		y = interp{ cam._properties.y[1] or ty, cam._properties.y[2] or ty, cam._properties.y[3], cam._properties.y[4], ease = cam._properties.y.ease, _transition = true}
		
	else
	
		--Otherwise just interpolate the property
		y = interp(cam._properties.y)
		
	end
	
	if x == nil or y == nil then
	
		--If one or both of the properties uses the target position, then we need to compute it
		if tx == nil then
			tx,ty = computeTargetPosition(cam)
		end
		
		x,y = tx,ty
		
	end
	
	return x,y
end

--Calculates the current zoom level of the camera
local function computeZoom(cam)
	if type(cam._properties.zoom) == "table" and cam._properties.zoom._transition and (cam._properties.zoom[1] == nil or cam._properties.zoom[2] == nil) then
	
		--If we're transitioning from or to a "nil" state, we need to use the target zoom, so do that and interpolate
		local z = computeTargetZoom(cam)
		return interp{ cam._properties.zoom[1] or z, cam._properties.zoom[2] or z, cam._properties.zoom[3], cam._properties.zoom[4], ease = cam._properties.zoom.ease, _transition = true}
		
	else
	
		--Otherwise just interpolate the property
		local z = interp(cam._properties.zoom)
		
		if z == nil then
		
			--If the property uses the target position, then we need to compute it
			z = computeTargetZoom(cam)
			
		end
		
		return z
	end
end


--Camera metatable
local cam_mt = {}

function cam_mt.__index(tbl,key)
	if key == "x" then
		local x = computePosition(tbl)
		return interp(tbl._properties.x, x)
	elseif key == "y" then
		local _,y = computePosition(tbl)
		return interp(tbl._properties.y, y)
	elseif key == "xOffset" then
		return interp(tbl._properties.xOffset, 0)
	elseif key == "yOffset" then
		return interp(tbl._properties.yOffset, 0)
	elseif key == "rotation" then
		return interp(tbl._properties.rotation, 0)
	elseif key == "zoom" then
		return interp(tbl._properties.zoom, computeZoom(tbl))
	elseif key == "targets" then
		local v = tbl._properties.targets
		if v == nil or v._transition == nil then
			return v
		else
			return v[1]
		end
	elseif key == "width" then
		return getCamWidth(tbl)
	elseif key == "height" then
		return getCamHeight(tbl)
	elseif key == "idx" then
		return tbl._ref.idx
	elseif key == "isValid" then
		return handycam[tbl._ref.idx] == tbl
	end
end

function cam_mt.__newindex(tbl,key,val)
	if propertyMap[key] then
		tbl._properties[key] = val
	end
end

cam_mt.__type = "HandyCamera"




--- Clears the transition queue.
-- @function HandyCamera:clearQueue
local function clearQueue(cam)
	cam._queue._timer = 0
	for i = #cam._queue,1,-1 do
		cam._queue[i] = nil
	end
end

--- Performs a camera transition immediately. Transitions take in their arguments any of the @{HandyCamera}'s non-readonly fields. Assigning any property to `false` will reset it to the default behaviour.
-- @function HandyCamera:transition
-- @tparam table args
-- @tparam[opt=1] number args.time The time in seconds for the transition to complete.
-- @tparam[opt] function args.ease An easing function. This will be passed one argument between 0 and 1, and should return one value, also between 0 and 1.
-- @tparam[opt=false] bool args.ignoreBounds Whether the transition should ignore section bounds when computing the relevant positions.
-- @tparam[opt=false] bool args.noClear If set to true, the transition queue will not be cleared after beginning this transition.
-- @usage myCamera:transition{ time = 5, x = 500 }
-- @usage myCamera:transition{ time = 2, zoom = 2, rotation = 45 }
-- @usage myCamera:transition{ zoom = false, x = false }
local function doTransition(cam, args)
	local t = max(lunatime.toTicks(args.time or 1), 1)
	
	local bound = {}
	if not args.ignoreBounds then
		bound.x = args.x
		bound.y = args.y
		local bounds = getBounds(cam)
		local z = args.zoom
		if type(z) ~= "number" then
			z = cam.zoom
		end
		z = 1/z
		local cw,ch = cam._ref.width*z, cam._ref.height*z
		
		if type(bound.x) == "number" then
			bound.x = clamp(bound.x, bounds.left + cw*0.5, bounds.right - cw*0.5)
		else 
			bound.x = nil
		end
		
		if type(bound.y) == "number" then
			bound.y = clamp(bound.y, bounds.top + ch*0.5, bounds.bottom - ch*0.5)
		else 
			bound.y = nil
		end
	end
	
	local runpaused = args.runWhilePaused
	
	if runpaused == nil then
		runpaused = false
	end
	
	for _,v in ipairs(propertyList) do
		local w = args[v]
		if w ~= nil then
			if bound[v] ~= nil then 
				w = bound[v] 
			end
			if (type(w) == "table" and #w == 0) or type(w) == "boolean" then
				w = nil
			end
			
			local p = cam._properties[v]
			if p ~= nil then
				p = cam[v]
			end
			
			cam._properties[v] = { p, w, 0, t, _transition = true, _runWhilePaused = runpaused, ease = args.ease }
		end
	end
	
	if not args.noClear then
		clearQueue(cam)
	end
end

local queueID = 0

--- Adds a camera transition to the end of the transition queue. Queued transitions will be run consecutively in the order they are queued. 
--- Transitions take in their arguments any of the @{HandyCamera}'s non-readonly fields. Assigning any property to `false` will reset it to the default behaviour.
--- Returns a queue ID that can be used to later remove the transition from the queue, if it is still waiting to start.
-- @function HandyCamera:queue
-- @return number
-- @tparam table args
-- @tparam[opt=1] number args.time The time in seconds for the transition to complete.
-- @tparam[opt] function args.ease An easing function. This will be passed one argument between 0 and 1, and should return one value, also between 0 and 1.
-- @tparam[opt=false] bool args.ignoreBounds Whether the transition should ignore section bounds when computing the relevant positions.
-- @usage myCamera:queue{ time = 5, x = 500 }
-- @usage myCamera:queue{ time = 2, zoom = 2, rotation = 45 }
-- @usage myCamera:queue{ zoom = false, x = false }
local function queueTransition(cam, args)
	local t = {ease = args.ease, time = args.time, ignoreBounds = args.ignoreBounds, runWhilePaused = args.runWhilePaused}
	for _,v in ipairs(propertyList) do
		if args[v] ~= nil then
			t[v] = args[v]
		end
	end
	t._id = queueID
	queueID = queueID+1
	tableinsert(cam._queue, t)
	return queueID
end

--- Removes a camera transition from the transition queue. If an ID is supplied, that ID will be removed, otherwise the most recently queued transition will be removed.
--- Returns `true` if a transition was successfully removed, or `false` if none could be found.
-- @function HandyCamera:unqueue
-- @return bool
-- @tparam[opt] number id The ID of the transition to remove
local function unqueueTransition(cam, id)
	if id == nil then
		if #cam._queue > 0 then
			tableremove(cam._queue)
			return true
		else
			return false
		end
	end
	local idx = 0
	for k,v in ipairs(cam._queue) do
		if v._id == id then
			idx = k
			break
		end
	end
	if idx < 1 then
		return false
	else
		if idx == 1 then
			cam._queue._timer = 0
		end
		tableremove(cam._queue, idx)
		return true
	end
end

--- Releases control from a @{HandyCamera}, returning behaviour to SMBX core.
-- @function HandyCamera:release
local function release(cam)
	local i = 1
	while i <= #activeList do
		if activeList[i] == cam._ref.idx then
			tableremove(activeList, i)
			break
		end
	end
	
	handycam[cam._ref.idx] = nil
end

--- Converts a coordinate from world space to screen space for this @{HandyCamera}.
-- @function HandyCamera:worldToScreen
-- @return number,number
-- @tparam number x The x coordinate to transform.
-- @tparam number y The y coordinate to transform.


--- Converts a coordinate from world space to screen space for this @{HandyCamera}.
-- @function HandyCamera:worldToScreen
-- @return number,number
-- @tparam Vector2 v The coordinate to transform.
local function world2Screen(cam, x, y)
	if y == nil and type(x) == "table" or type(x) == "Vector2" then
		y = x[2]
		x = x[1]
	end
	
	local cx,cy = cam._ref.x+cam._ref.width*0.5, cam._ref.y+cam._ref.height*0.5
	
	local x1,y1 = x-cx, y-cy
	
	local z = cam.zoom
	x1 = x1*z
	y1 = y1*z
	
	local v = vector.v2(x1,y1):rotate(-cam.rotation)
	
	return v[1] + 400, v[2] + 300
end

--- Converts a coordinate from screen space for this @{HandyCamera} to world space.
-- @function HandyCamera:screenToWorld
-- @return number,number
-- @tparam number x The x coordinate to transform.
-- @tparam number y The y coordinate to transform.


--- Converts a coordinate from screen space for this @{HandyCamera} to world space.
-- @function HandyCamera:screenToWorld
-- @return number,number
-- @tparam Vector2 v The coordinate to transform.
local function screen2World(cam, x, y)
	if y == nil and type(x) == "table" or type(x) == "Vector2" then
		y = x[2]
		x = x[1]
	end
	
	local x1,y1 = x-400, y-300
	
	local v = vector.v2(x1,y1):rotate(cam.rotation)
	
	local z = 1/cam.zoom
	v[1] = v[1]*z
	v[2] = v[2]*z
	
	
	
	return v[1] + cam._ref.x+cam._ref.width*0.5, v[2] + cam._ref.y+cam._ref.height*0.5
end

--- Resets the camera to default behaviour.
-- @function HandyCamera:reset
local function reset(cam)
	for _,k in ipairs(propertyList) do
		cam._properties[k] = nil
	end
	clearQueue(cam)
end

--- Instantly finishes all currently active transitions and clears the transition queue.
-- @function HandyCamera:finish
local function finish(cam)
	for _,k in ipairs(propertyList) do
		local v = cam._properties[k]
		if type(v) == "table" and v._transition then
			cam._properties[k] = v[2]
		end
	end
	clearQueue(cam)
end

--- Instantly finishes all currently active transitions and proceeds to the next transition in the transition queue.
-- @function HandyCamera:skip
local function skip(cam)
	for _,k in ipairs(propertyList) do
		local v = cam._properties[k]
		if type(v) == "table" and v._transition then
			cam._properties[k] = v[2]
		end
	end
	
	cam._queue._timer = 0
end

--- Aborts all transitions in their current state. Is prone to leaving the camera in awkward states, use with caution.
-- @function HandyCamera:abort
local function abort(cam)
	for _,k in ipairs(propertyList) do
		local v = cam._properties[k]
		if type(v) == "table" and v._transition then
			if k == "targets" then
				cam._properties[k] = v[1]
			else
				cam._properties[k] = cam[k]
			end
		end
	end
end

--Creates a new camera wrapper over the specified camera
function makenew(cam)
	local c = {_ref = cam, scene = Graphics.CaptureBuffer(cam.width, cam.height), _properties = {}, _queue = {_timer = 0}, updateWhilePaused = true, autozoom = false}
	
	c.transition = doTransition
	c.queue = queueTransition
	c.unqueue = unqueueTransition
	c.clearQueue = clearQueue
	c.release = release
	c.worldToScreen = world2Screen
	c.screenToWorld = screen2World
	c.reset = reset
	c.finish = finish
	c.abort = abort
	c.skip = skip
	
	tableinsert(activeList, cam.idx)
	
	setmetatable(c, cam_mt)
	return c
end

function handycam.onDrawEnd()
	local isPaused = Misc.isPaused()

	--Loop over cameras and update their transitions and queues
	for _,idx in ipairs(activeList) do
		local c = rawget(handycam, idx)
		
		if c ~= nil and c.updateWhilePaused or not isPaused then
		
			for _,k in ipairs(propertyList) do
				local v = c._properties[k]
				
				--Update the timer for a given property if it is a transition
				if type(v) == "table" and v._transition and (not isPaused or v._runWhilePaused) then
					v[3] = v[3]+1
					if v[3] >= v[4] then
						c._properties[k] = v[2]
					end
				end
			end
			
			if c._queue._timer > 0 and (not isPaused or c._queue._runWhilePaused)  then
				
				--Decrement the queue timer so we don't pop from the queue too early
				c._queue._timer = c._queue._timer - 1
				
			elseif #c._queue > 0 then
				
				--Pop an element from the queue, apply it, and set when to look at the queue next
				c._queue._timer = max(lunatime.toTicks(c._queue[1].time or 1), 1)
				c._queue._runWhilePaused = c._queue[1].runWhilePaused
				if c._queue._runWhilePaused == nil then
					c._queue._runWhilePaused = false
				end
				c._queue[1].noClear = true
				doTransition(c, c._queue[1])
				tableremove(c._queue, 1)
				
			end
		end
	end
end


function handycam.onCameraUpdate(idx)
	local c = rawget(handycam, idx)
	if c ~= nil then
		local w,h = c._ref.width,c._ref.height
		
		--Update capture buffer if we need to
		if w ~= c.scene.width or h ~= c.scene.height then
			c.scene = Graphics.CaptureBuffer(w,h)
		end
		
		--Position reference camera
		local x,y = c.x, c.y
		c._ref.x = floor(x - c._ref.width*0.5 + 0.5)
		c._ref.y = floor(y - c._ref.height*0.5 + 0.5)
	end
end


function handycam.onCameraDraw(idx)
	local c = rawget(handycam, idx)
	if c ~= nil then
		local w,h = c._ref.width,c._ref.height
		
		local z = c.zoom
		local rt = -c.rotation
		local isrot = (rt % 360) ~= 0
		
		--Only do this bit if we need to draw the capture buffer
		if z ~= 1 or isrot then
			--Capture scene
			c.scene:captureAt(0)
		
			if z < 1 or isrot then
				--Draw black over the scene
				Graphics.drawScreen{color=Color.black, priority = 6}
			end
		
			--Take reference points in screen space
			local l = -w*0.5
			local r = w*0.5
			local t = -h*0.5
			local b = h*0.5
			
			--Apply zoom
			l = l*z
			r = r*z
			t = t*z
			b = b*z
			
			
			local offset = vector.v2(w*0.5, h*0.5)
			
			local tl = offset
			local tr = offset
			local bl = offset
			local br = offset
			
			if isrot then
				local v = vector.v2(l,t)
				
				--Apply rotation and offset
				tl = tl + v:rotate(rt)
				v[1] = r
				v[2] = t
				tr = tr + v:rotate(rt)
				v[1] = l
				v[2] = b
				bl = bl + v:rotate(rt)
				v[1] = r
				v[2] = b
				br = br + v:rotate(rt)
			else
				local v = vector.v2(l,t)
				
				--Apply offset
				tl = tl + v
				v[1] = r
				v[2] = t
				tr = tr + v
				v[1] = l
				v[2] = b
				bl = bl + v
				v[1] = r
				v[2] = b
				br = br + v
			end
			
			if z ~= 1 then
				--Coordinate rounding based on zoom level to avoid distortion
				local iz = 1/z
				for i = 1,2 do
					tl[i] = floor(floor(tl[i]*z + 0.5)*iz + 0.5)
					tr[i] = floor(floor(tr[i]*z + 0.5)*iz + 0.5)
					bl[i] = floor(floor(bl[i]*z + 0.5)*iz + 0.5)
					br[i] = floor(floor(br[i]*z + 0.5)*iz + 0.5)
				end
			end
			
			--Draw new camera
			local args = { vertexCoords = { tl[1],tl[2], tr[1],tr[2], br[1],br[2], bl[1],bl[2] }, textureCoords = { 0,0, 1,0, 1,1, 0,1 }, primitive = Graphics.GL_TRIANGLE_FAN, priority = 6, texture = c.scene }
			if (z > 1.0) and handycam.enableCrispUpscale then
				args.shader = crispShader
				args.linearFiltered = true
				args.uniforms = {inputSize={w,h}, crispScale = {max(floor(w*z+0.5)/w, 1), max(floor(h*z+0.5)/h, 1)}}
			end
			Graphics.glDraw(args)
		end

	end
end


--- Functions.
-- @section Functions


--- Converts an easing function (such as those found in `ext/easing`) to the format used by HandyCam.
-- @function HandyCam.ease
-- @return function
-- @tparam function easeFunc The function to transform.
function handycam.ease(easeFunc)
	return function(t) return easeFunc(t,0,1,1) end
end

local global_mt = {}

--Cameras are accessed via `handycam[idx]`
function global_mt.__index(tbl,key)
	if type(key) == "number" then
		local c = Camera(key)
		if c ~= nil then
			rawset(tbl, key, makenew(c))
			return rawget(tbl, key)
		end
	end
end

setmetatable(handycam, global_mt)
return handycam