-- this initialize function wraps a contructor for a new tilemap it adds some
-- basic functionality which should be used during the lifecycle of the game
-- to have a controlled process when handling tiles
return function()
	local tm = {
		tiles={},
		tileIndex={},
	}

	-- create a new tilemap, +nTiles+ determines how many tiles are supposed
	-- to be in a column/row, +tileWidth+ and +tileHeight+ determine the
	-- initial width and height of a tile; +cb+ is a function value expected
	-- to return a "tile" which then is references to the x and y coordinate;
	-- create also keeps the render order in place so there shouldn't be any
	-- issue when rendering the tilemap; resets before create
	function tm:create(nTiles, tileWidth, tileHeight, cb)
		-- reset 
		self.tiles = {}
		self.tileIndex = {}

		-- create
		for x=1,nTiles do
			for y=nTiles,1,-1 do
				local t = cb(x, y, tileWidth, tileHeight)

				table.insert(self.tiles, t)
				self.tileIndex[x..'_'..y] = t
			end
		end
	end

	-- get retrieves a tile by +x+ and +y+; to be used in any context where a
	-- tile should be retrieved by there map coordinates
	function tm:get(x, y)
		return self.tileIndex[tostring(x)..'_'..tostring(y)]
	end

	-- neighbours returns the adjacent tiles of a tile with coordinates +x+
	-- and +y+; this function is a sugaring method and should be used in any
	-- context when the direct neighborhood of a tile is requested
	function tm:neighbours(x, y)
		return {
			self:get(x-1, y),
			self:get(x-1, y-1),
			self:get(x-1, y+1),

			self:get(x+1, y),
			self:get(x+1, y-1),
			self:get(x+1, y+1),

			self:get(x, y+1),
			self:get(x, y-1),
		}
	end

	-- each iterates over every tile and executes the +cb+ function passed in
	-- and passes the tile as single argument, the function should be used in
	-- any context where you want to process the whole tilemap i.e. game
	-- update, game draw, ...
	function tm:each(cb)
		for id, t in pairs(self.tiles) do
			cb(t)
		end
	end

	return tm
end