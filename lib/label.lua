-- this returns a tile label which is a combined overlay with a renderable
-- (usually image) and a text caption; this can be used – for example – to
-- render a price of a tile 
return function(text, renderable)
	local i = {
		caption=love.graphics.newText(love.graphics.getFont(), tostring(text)),
		renderable=renderable
	}

	-- draw renders the label on the tile, the +x+ coordinate of the left
	-- outermost point and the +y+ coord of the top most point is used to
	-- place the overlay (adjust as needed); +tileWidth+ is the width of the
	-- tile and necessary to calculate how side the label can be. 
	function i:draw(x, y, tileWidth)
		if self.caption and not self.renderable then
			love.graphics.draw(self.caption, x+(tileWidth-self.caption:getWidth())/2, y)
			return
		end

		if self.caption and self.renderable then
			local padding = 2*(tileWidth*0.01)
			local rw = tileWidth*0.25
			local scale = rw/self.renderable:getWidth()

			local maxH = math.max(self.caption:getHeight(), self.renderable:getHeight()*scale)
			local marginY = (tileWidth-(self.caption:getWidth()+rw+padding))/2

			love.graphics.draw(self.renderable, x+marginY-padding/2, y+(maxH-self.renderable:getHeight()*scale)/2, 0, scale)
			love.graphics.draw(self.caption, x+marginY+(self.renderable:getWidth()*scale)+padding/2, y+(maxH-self.caption:getHeight())/2)
			return
		end
	end

	return i
end