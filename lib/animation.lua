-- constructor to wrap an sprite/imagestrip based animation to be rendered on
-- a tile. requires an +image+ (love.Image) and a +totalFrames+ count which is
-- used to move the quad along and progress the animation
return function(image, totalFrames)
	local animation = {
		image=image,
		totalFrames=totalFrames,
		currentFrame=0
	}

	-- progress progresses through the animation; this should be used within
	-- a timer function to play through the animation
	function animation:progress()
		self.currentFrame = (self.currentFrame + 1) % self.totalFrames
	end

	-- getHeight returns the height of a frame, it is used to calculate the
	-- correct quad for the next frame
	function animation:getHeight()
		return self.image:getHeight()
	end

	-- getWidth returns the width of a frame, it is used to calculate the
	-- correct quad for the next frame, it is also used to allow the
	-- calculation of the correct scaling factor
	function animation:getWidth()
		return self.image:getWidth()/self.totalFrames
	end

	-- draw renders the animation at the current frame upon a tile; where +x+
	-- denotes the x coordinate of the left most point of the tile and +y+
	-- denotes the y coordinate of the up most corner of the tile; so the
	-- frame is an overlay on the tile. +scale+ is used to denote the scale
	-- at which the frame should be rendered usually that is denoted by
	-- tileWidth/animation:getWidth()
	function animation:draw(x, y, scale)
		local quad = love.graphics.newQuad(
			self:getWidth()*self.currentFrame, 
			0, 
			self:getWidth(), 
			self:getHeight(), 
			self.image:getDimensions() -- quad requires the original image strip size as parameter aswell
		)

		love.graphics.draw(image, quad, x, y, 0, scale)
	end

	return animation
end