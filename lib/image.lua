-- constructor to wrap an image to be render on a tile; requires an +image+
-- (love.Image)
return function(image)
	local i = {image=image}

	-- getWidth returns the width of the underlying image, it is used e.g. to
	-- calculate the correct scale the tile image should be rendered at.
	function i:getWidth() 
		return self.image:getWidth()
	end

	-- draw renders the image on the tile; +x+ denotes the x coordinate of the
	-- left most point; +y+ denotes the y coordinate of the upper most point;
	-- so the image is an overlay to the tile; +scale+ is used as scale to
	-- render the image exactly as an overlay on the tile; it is usually
	-- denoted by tileWidth/image:getWidth()
	function i:draw(x, y, scale)
		love.graphics.draw(
			self.image,
			x,
			y,
			0,
			scale
		)
	end

	return i
end