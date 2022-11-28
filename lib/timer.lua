-- constructor to create a new timer setup; which is used based on +dt+ to
-- progress animations, run functions based on a certain timing aspect
-- (i.e. every x second, afer x seconds, ...)
return function()
	local timer = {every_collection={}, after_collection={}}

	-- every registers a new timer that should run +func+ every +time+ amount
	-- of seconds
	function timer:every(time, func)
		table.insert(self.every_collection, {
			current=time,
			reset=time,
			func=func
		})
	end

	-- after registers a new timer which runs +func+ after +time+ amount of
	-- seconds; the 'orchestrator' will remove the entry from its registry
	-- when +func+ ran
	function timer:after(time, func)
		table.insert(self.after_collection, {
			current=time,
			func=func
		})
	end

	-- update orchestrates the scheduled function running; it should be used
	-- within a love.update method and should receive it's +dt+ argument;
	function timer:update(dt)
		for _, t in pairs(self.every_collection) do
			t.current = t.current - dt
			if t.current <= 0 then
				t.current = t.reset
				t.func()
			end
		end

		for idx, t in pairs(self.after_collection) do
			t.current = t.current - dt
			if t.current <= 0 then
				t.func()
				table.remove(self.after_collection, idx)
			end
		end
	end

	return timer
end