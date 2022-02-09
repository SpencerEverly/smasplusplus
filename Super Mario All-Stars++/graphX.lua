--***************************************************************************************
--                                                                                      *
--  graphX.lua                                                                          *
--  v0.3c                                                                               *
--  Based on colliders.lua by Hoeloe                                                    *
--                                                                                      *
--***************************************************************************************

local graphX = {}
local mathematX = loadSharedAPI ("mathematX")

	graphX.resourcePath     = "..\\..\\..\\LuaScriptsLib\\graphX\\"
	graphX.resourcePathOver = "..\\..\\LuaScriptsLib\\graphX\\"

	graphX.imageWidths = {}
	graphX.imageHeights = {}
	
	
	
	function graphX.getPath (filename)		
		--windowDebug ("TEST")
		
		local localPath = Misc.resolveFile (filename)  
						
		if  localPath  ~=  nil  then
			return localPath
		end
		
		if isOverworld == true  then
			return graphX.resourcePathOver..filename
		end
		
		return graphX.resourcePath..filename
	end
	
	
	
	local function getScreenBounds (camNumber)
		if  camNumber == nil  then
			camNumber = 1
		end
		
		local cam = Camera.get ()[camNumber]
		local b =  {left = cam.x, 
					right = cam.x + cam.width,
					top = cam.y,
					bottom = cam.y + cam.height}
		
		return b;
		
	end

	function graphX.worldToScreen (x,y)
		local b = getScreenBounds ();
		local x1 = x-b.left;
		local y1 = y-b.top;
		return x1,y1;
	end
	
	
	--***************************************************************************************************
	--                                                                                                  *
	--              PRIMITIVE DRAWING FUNCTIONS                                                         *
	--                                                                                                  *
	--***************************************************************************************************
	
	function graphX.boxLevel (x,y,w,h, col, tex)
		local x1,y1 = graphX.worldToScreen (x, y);
		graphX.boxScreen (x1,y1,w,h, col, tex)
	end
	
	function graphX.boxScreen (x,y,w,h, col, tex)
		col = col or 0xFFFFFFFF; --0xFF000099;
		Graphics.glSetTextureRGBA (tex, col);
		
		local pts = {};
		local x1,y1 = x,y;
		pts[0] = x1; 	pts[1] = y1;
		pts[2] = x1+w;	pts[3] = y1;
		pts[4] = x1;	pts[5] = y1+h;
		pts[6] = x1;	pts[7] = y1+h;
		pts[8] = x1+w;	pts[9] = y1+h;
		pts[10] = x1+w; pts[11] = y1;

		local texpts = {};
		texpts[0] = 0.0; 	texpts[1] = 0.0;
		texpts[2] = 1.0;	texpts[3] = 0.0;
		texpts[4] = 0.0;	texpts[5] = 1.0;
		texpts[6] = 0.0;	texpts[7] = 1.0;
		texpts[8] = 1.0;	texpts[9] = 1.0;
		texpts[10] = 1.0; 	texpts[11] = 0.0;

		
		Graphics.glDrawTriangles (pts, texpts, 6);
		Graphics.glSetTextureRGBA (nil, 0xFFFFFFFF);
	end

	
	
	function graphX.boxLevelExt (x,y,w,h, properties)
		local x1,y1 = graphX.worldToScreen (x, y);
		graphX.boxScreenExt (x1,y1,w,h, properties)
	end
	
	function graphX.boxScreenExt (x,y,w,h, properties)			
		local x1,y1 = x,y;
		local pts = {};
		pts[1] = x1; 	pts[2] = y1;
		pts[3] = x1+w;	pts[4] = y1;
		pts[5] = x1;	pts[6] = y1+h;
		pts[7] = x1;	pts[8] = y1+h;
		pts[9] = x1+w;	pts[10] = y1+h;
		pts[11] = x1+w; pts[12] = y1;
		
		graphX.polyExt (pts, properties)
	end
	
	
	
	function graphX.quadLevelExt (points, properties)
		for i=1, #points, 2 do 
			local x1,y1 = graphX.worldToScreen (points[i], points[i+1]);
			points[i],points[i+1] = x1,y1
		end

		graphX.quadScreenExt (points, properties)
	end
	
	function graphX.quadScreenExt (points, properties)
		local x1,x2,x3,x4 = points[1],points[3],points[5],points[7];
		local y1,y2,y3,y4 = points[2],points[4],points[6],points[8];
		
		local pts = {};
		pts[1] = x1; 	pts[2] = y1;
		pts[3] = x2;	pts[4] = y2;
		pts[5] = x3;	pts[6] = y3;
		pts[7] = x3;	pts[8] = y3;
		pts[9] = x4;	pts[10] = y4;
		pts[11] = x1;	pts[12] = y1;
		
		graphX.polyExt (pts, properties)
	end
	
	
	
	function graphX.polyExt (points, properties)
		
		-- Get properties
		local uAdd, vAdd = 0,0
		local tile = false
		local col = 0xFFFFFFFF
		local tex = nil
		local texAngle = 0
		local texScaleX = 1
		local texScaleY = 1
		
		if  properties ~= nil  then
			uAdd = properties["u"] or 0
			vAdd = properties["v"] or 0
			tex = properties["tex"]
			texAngle = properties["texAngle"] or 0
			texScaleX = properties["texScaleX"] or properties["texScale"] or 1
			texScaleY = properties["texScaleY"] or properties["texScale"] or 1
			
			col = properties["color"] or 0xFFFFFFFF
			tile = properties["tile"]
			
			if  tile == nil  then
				tile = false
			end			
		end
		
		
		-- Get UV bounds
		Graphics.glSetTextureRGBA (tex, col);
		local x1,x2,y1,y2 = points[1],points[1],points[2],points[2];
		
		for i=1, #points, 2 do 
			-- Left- and rightmost
			if  points[i] < x1  then 
				x1 = points[i]
			end
			if  points[i] > x2  then 
				x2 = points[i]
			end
			
			-- Top- and bottommost
			if  points[i+1] < y1  then 
				y1 = points[i+1]
			end
			if  points[i+1] > y2  then 
				y2 = points[i+1]
			end
		end
		
		
		-- Calculate texture positioning
		local shapeW,shapeH = x2-x1, y2-y1;
		local xMid,yMid = (x1+x2)*0.5, (y1+y2)*0.5;
		
		local pixels = {};
		local texW,texH = 2,2;
		if   tex ~= nil  then
			if  graphX.imageWidths[tex] == nil  then
				pixels,texW,texH = Graphics.getPixelData(tex);
				graphX.imageWidths[tex] = texW
				graphX.imageHeights[tex] = texH
			else
				texW,texH = graphX.imageWidths[tex],graphX.imageHeights[tex]
			end
		end

		local texL,texR,texT,texB = x1,x2,y1,y2;
		
		
		if  tile == false  then
			texW,texH = shapeW, shapeH;		
		end
		
		texW,texH = texW*texScaleX, texH*texScaleY;
		
		
		texL = xMid - texW*(0.5)--+uAdd);
		texR = texL+texW;
		texT = yMid - texH*(0.5)--+vAdd);
		texB = texT+texH;
		
		if  texW == 0  or  texH == 0  then
			return
		end
		
		
		-- Calculate rotation
		local angleAdd = (texAngle) * (math.pi/180);
		local cosMult, sinMult = math.cos(angleAdd), math.sin(angleAdd)
		
		-- Determine UVs
		local uvs = {}
		for i=1, (#points), 2  do
			local rotX = xMid + cosMult * (points[i] - xMid) - sinMult * (points[i+1] - yMid);
			local rotY = yMid + sinMult * (points[i] - xMid) + cosMult * (points[i+1] - yMid);
			
			local newU, newV = mathematX.invLerp (texL,texR, rotX), mathematX.invLerp (texT,texB, rotY);
			
			uvs[i] = newU;
			uvs[i+1] = newV;
			
			--Text.print (string.format("%.2f", uvs[i])..", "..string.format("%.2f", uvs[i+1]), 4, 8, 120+10*i)
		end
		

		-- Draw the poly
		Graphics.glDrawTriangles (points, uvs, (#points + 1)/2);
		Graphics.glSetTextureRGBA (nil, 0xFFFFFFFF);
	end

	
	
	function graphX.circleLevel (x,y,r, col)
		local x1,y1 = graphX.worldToScreen (x, y);
		graphX.circleScreen (x1,y1,r, col)
	end
	
	function graphX.circleScreen (x,y,r, col)
		col = col or 0xFF000099;
		Graphics.glSetTextureRGBA (nil, col);
		
		local pts = circleToTris(x,y,r);
		
		Graphics.glDrawTriangles (pts, {}, (#pts + 1)/2);
		Graphics.glSetTextureRGBA (nil, 0xFFFFFFFF);
	end



	function circleToTris(x,y,r)
		local x1 = x
		local y1 = y;
		local pts = {};
		local m = math.ceil(math.sqrt(r));
		if(m < 1) then m = 1; end
		local s = (math.pi/2)/m;
		local ind = 0;
		local xmult = 1;
		local ymult = -1;
		for n=1,4 do
			local lx = 0;
			local ly = 1;
			for i=1,m do
				local xs = math.cos((math.pi/2)-s*i);
				local ys = math.sin((math.pi/2)-s*i);
				pts[ind] = x1;
				pts[ind+1] = y1;
				pts[ind+2] = x1+xmult*r*lx;
				pts[ind+3] = y1+ymult*r*ly;
				pts[ind+4] = x1+xmult*r*xs;
				pts[ind+5] = y1+ymult*r*ys;
				ind = ind+6;
				lx = xs;
				ly = ys;
			end
			if xmult == 1 then
				if ymult == -1 then
					ymult = 1;
				elseif ymult == 1 then
					xmult = -1;
				end
			elseif xmult == -1 then
				if ymult == -1 then
					xmult = 1;
				elseif ymult == 1 then
					ymult = -1;
				end
			end
		end
		return pts;
	end

	

	--***************************************************************************************************
	--                                                                                                  *
	--              UI DRAWING FUNCTIONS                                                                *
	--                                                                                                  *
	--***************************************************************************************************

	
	graphX.MENU_FILL = Graphics.loadImage(graphX.getPath("menuFillA.png"))
	graphX.BORDER_UL = Graphics.loadImage(graphX.getPath("menuBorderUL.png"))
	graphX.BORDER_UR = Graphics.loadImage(graphX.getPath("menuBorderUR.png"))
	graphX.BORDER_DL = Graphics.loadImage(graphX.getPath("menuBorderDL.png"))
	graphX.BORDER_DR = Graphics.loadImage(graphX.getPath("menuBorderDR.png"))
	graphX.BORDER_U = Graphics.loadImage(graphX.getPath("menuBorderU.png"))
	graphX.BORDER_D = Graphics.loadImage(graphX.getPath("menuBorderD.png"))
	graphX.BORDER_L = Graphics.loadImage(graphX.getPath("menuBorderL.png"))
	graphX.BORDER_R = Graphics.loadImage(graphX.getPath("menuBorderR.png"))

	
	function graphX.menuBoxLevel (x,y,w,h, col, fillTex, borderTable)
		local x1,y1 = graphX.worldToScreen (x, y);
		graphX.menuBoxScreen (x1,y1,w,h, col, fillTex, borderTable)
	end
	
	function graphX.menuBoxScreen (x,y,w,h, col, fillTex, borderTable)
		local texImg = fillTex or graphX.MENU_FILL
		
		local x1 = math.min(x,x+w)
		local y1 = math.min(y,y+h)
		
		-- Fill
		graphX.boxScreen (x1,y1,math.abs(w),math.abs(h), col, texImg)
					
		-- Border
		graphX.menuBorderScreen (x,y,w,h, borderTable)
	end


	function graphX.menuBorderLevel (x,y,w,h, borderTable)
		local x1,y1 = graphX.worldToScreen (x, y);
		graphX.menuBorderScreen (x1,y1,w,h, borderTable)
	end
	
	function graphX.menuBorderScreen (x,y,w,h, borderTable)
					
		-- Border
		drawMenuBorder (x,y,w,h, borderTable)
	end


	function graphX.getDefBorderTable ()
		local borderTable = {}
		
		borderTable["ulImg"] = graphX.BORDER_UL
		borderTable["uImg"] = graphX.BORDER_U
		borderTable["urImg"] = graphX.BORDER_UR
		borderTable["rImg"] = graphX.BORDER_R
		borderTable["drImg"] = graphX.BORDER_DR
		borderTable["dImg"] = graphX.BORDER_D
		borderTable["dlImg"] = graphX.BORDER_DL
		borderTable["lImg"] = graphX.BORDER_L

		borderTable["thick"] = 4
		borderTable["col"] = 0xFFFFFFFF
	
		return borderTable
	end
	
	function drawMenuBorder (x,y,w,h, borderTable)

		if borderTable == nil  then
			borderTable = graphX.getDefBorderTable ()
		end
	
		local ulImg = borderTable["ulImg"]
		local uImg = borderTable["uImg"]
		local urImg = borderTable["urImg"]
		local rImg = borderTable["rImg"]
		local drImg = borderTable["drImg"]
		local dImg = borderTable["dImg"]
		local dlImg = borderTable["dlImg"]
		local lImg = borderTable["lImg"]

		local th = borderTable["thick"]
		local col = borderTable["col"]
		
		local x1 = math.min(x,x+w)-th
		local x2 = x
		local x3 = math.max(x,x+w)
		local x4 = x3+th

		local y1 = math.min(y,y+h)-th
		local y2 = y
		local y3 = math.max(y,y+h)
		local y4 = y3+th
		
		-- Corners
		graphX.boxScreen (x1,y1,th,th, col, ulImg) -- Upper-left
		graphX.boxScreen (x3,y1,th,th, col, urImg) -- Upper-right
		graphX.boxScreen (x1,y3,th,th, col, dlImg) -- Lower-left
		graphX.boxScreen (x3,y3,th,th, col, drImg) -- Lower-right
		
		-- Edges
		graphX.boxScreen (x1,y2,th,h, col, lImg) -- Left
		graphX.boxScreen (x2,y1,w,th, col, uImg) -- Top
		graphX.boxScreen (x3,y2,th,h, col, rImg) -- Right
		graphX.boxScreen (x2,y3,w,th, col, dImg) -- Bottom
		
		--[[
		-- Black outline
		graphX.boxScreen (x-1,		y-1,	w+2,	3,		0x000000FF) -- Top
		graphX.boxScreen (x-1,		y+h-1,	w+2,	3,		0x000000FF) -- Bottom
		graphX.boxScreen (x-1,		y-1,	3,		h+2,	0x000000FF) -- Left
		graphX.boxScreen (x+w-1,		y-1,	3,		h+2,	0x000000FF) -- Right
		
		-- White outline
		graphX.boxScreen (x,			y,		w,		1,		0xFFFFFFFF) -- Top
		graphX.boxScreen (x,			y+h,	w,		1,		0xFFFFFFFF) -- Bottom
		graphX.boxScreen (x,			y,		1,		h,		0xFFFFFFFF) -- Left
		graphX.boxScreen (x+w,		y,		1,		h,		0xFFFFFFFF) -- Right
		]]
	end

	
	function graphX.progressBarLevel (x,y,w,h, col, align, amt)
		local x1,y1 = graphX.worldToScreen (x, y);
		graphX.progressBarScreen (x1,y1,w,h, col, align, amt)
	end
	
	function graphX.progressBarScreen (x,y,w,h, col, align, amt)
		if  align == "left"  then
			drawProgressBarLeft (x,y,w,h, col, amt)
		end
		
		if  align == "top"  then
			drawProgressBarTop (x,y,w,h, col, amt)
		end
		
		if  align == "right"  then
			drawProgressBarRight (x,y,w,h, col, amt)
		end
		
		if  align == "bottom"  then
			drawProgressBarBottom (x,y,w,h, col, amt)
		end
	
	end

	
	
	local function drawProgressBarLeft (x,y,w,h, col, amt)		
		-- Fill
		graphX.boxScreen (x,	y,	w*amt,	h,	col)		
				
		-- Border
		cinematX.drawMenuBorder (x,y,w,h)		
	end
	
	local function drawProgressBarRight (x,y,w,h, col, amt)		
		-- Fill
		graphX.boxScreen (x + w*(1-amt),	y,	w*amt,	h,	col)		
				
		-- Border
		cinematX.drawMenuBorder (x,y,w,h)		
	end

	local function drawProgressBarTop (x,y,w,h, col, amt)		
		-- Fill
		graphX.boxScreen (x,	y,	w,	h*amt,	col)		
				
		-- Border
		cinematX.drawMenuBorder (x,y,w,h)		
	end

	local function drawProgressBarBottom (x,y,w,h, col, amt)		
		-- Fill
		graphX.boxScreen (x,	y + h*(1-amt),	w,	h*amt,	col)		
				
		-- Border
		cinematX.drawMenuBorder (x,y,w,h)		
	end
		
	

	
return graphX;