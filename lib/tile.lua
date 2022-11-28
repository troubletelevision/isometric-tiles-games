-- franklin implemenation of ray method to check if 
-- point is within polygon with vertices
-- 
-- @see https://wrfranklin.org/Research/Short_Notes/pnpoly.html
local function point_in_polygon(vertices, point)
	local contains = false
	local prev = vertices[#vertices]

	for k, vert in pairs(vertices) do
		if 
		(
            (
                (vert.y > point.y) ~= (prev.y > point.y)
            ) and
            (
                point.x < (prev.x - vert.x) * (point.y - vert.y) / (prev.y - vert.y) + vert.x
            )
        )
		then
			contains = not contains
		end

		prev = vert
	end

	return contains
end

-- contructor to initialize a new tile; +tx+ and +ty+ denote the x, y
-- placement in the map itself; +width+ and +height+ set the initial width
-- and height when drawn; +state+ is the initial (and optional) state of the
-- tile to be used to hold all relevant values that relate to the tile; this
-- function should be used when create a new tilemap, to setup a fresh new
-- tile 
return function(tx, ty, width, height, state)
	local t = {
		tx=tx, 
		ty=ty, 
		width=width, 
		height=height, 
		offsetX=offsetX or 10,
		offsetY=offsetY or 10,

		hovered=false, -- hover is essential and therefore tracked in the basic version
		state=state
	}


	-- x returns the current x coordinate of the center of the tile with all
	-- modifications applied
	function t:x()
		return (self.tx + self.ty) * (self.width/2) + self.offsetX
	end

	-- y returns the current y coordinate of the center of the tile with all
	-- modificiation applied (i.e. offset)
	function t:y()
		return (self.tx - self.ty) * (self.height/2) + self.offsetY
	end

	-- update is a handy sugaring function to update a tiles core parameters;
	-- it should be used in a tilemap update function i.e. a game update
	-- function to apply a viewport/movement of the map and zoom
	function t:update(offX, offY, tileWidth, tileHeight)
		self.offsetX = offX
		self.offsetY = offY

		self.width = tileWidth
		self.height = tileHeight
	end

	-- drawDebug renders a simple wireframe representation of the tile, this
	-- should be used for debug purposes or as reference for other
	-- implemenations requiring the corner points of a tile
	function t:drawDebug()
		local lx, ly = self:x() - self.width/2, self:y()
		local tx, ty = self:x(), self:y() - self.height/2
		local rx, ry = self:x() + self.width/2, self:y()
		local bx, by = self:x(), self:y() + self.height/2

		off = 0
		if self.hovered then
			off = 10
		end

		love.graphics.polygon(
			'line',
			lx, ly-off,
			tx, ty-off,
			rx, ry-off,
			bx, by-off
		)
	end

	-- checkHover checks based on +mx+ and +my+ (mouse cursor x and y) if the
	-- current pointer is hovering the tile
	function t:checkHover(mx, my)
		local lx, ly = self:x() - self.width/2, self:y()
		local tx, ty = self:x(), self:y() - self.height/2
		local rx, ry = self:x() + self.width/2, self:y()
		local bx, by = self:x(), self:y() + self.height/2

		self.hovered = point_in_polygon(
			{
				{x=lx, y=ly},
				{x=tx, y=ty},
				{x=rx, y=ry},
				{x=bx, y=by},
			},
			{x=mx, y=my}
		)
	end

	return t
end