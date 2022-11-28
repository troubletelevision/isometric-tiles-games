-- this constructs a new render layer, it encloses it's own canvas and has
-- some utility functions to work with set canvas to separate viewing
-- concerns
return function()
	local l = {canvas=love.graphics.newCanvas()}

	-- update sets the layers canvas as active canvas, executes +cb+ function
	-- which should draw everything relevant for the layer on the canvas;
	-- after that it'll reset to the previous active canvas
	function l:update(cb)
		local reset = love.graphics.getCanvas()
		love.graphics.setCanvas(self.canvas)
		cb()
		love.graphics.setCanvas(reset)
	end

	-- draw renders the layers' canvas to the currently active canvas
	function l:draw()
		love.graphics.draw(self.canvas)
	end

	return l

end