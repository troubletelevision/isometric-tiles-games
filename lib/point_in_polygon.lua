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

return {
	point_in_polygon=point_in_polygon
}