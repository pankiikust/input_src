-- made by reelplum
local BorderSnap = {}

local function getCornerPosition(minimumSize, absoluteSize, cornerSize, corner)
	return Vector2.new(cornerSize, cornerSize),Vector2.new(cornerSize, absoluteSize.Y - cornerSize) , Vector2.new(absoluteSize.X - cornerSize, cornerSize), Vector2.new(absoluteSize.X - cornerSize, absoluteSize.Y - cornerSize)
end

local function getRadius(cornerRadius, absoluteSize)
	local minimumSize = math.min(absoluteSize.X, absoluteSize.Y)
	local maximumSize = math.max(absoluteSize.X, absoluteSize.Y)
	local cornerSize = minimumSize*math.clamp(cornerRadius.Scale, 0, .5)+math.clamp(cornerRadius.Offset, 0, minimumSize/2)
	return cornerSize, getCornerPosition(minimumSize, absoluteSize, cornerSize)
end

local function check(pos, pos1, pos2, pos3, pos4)
	if pos.X < pos1.X and pos.Y < pos1.Y then
		--It's on the left-top corner
		return "left-top"
	elseif pos.X < pos2.X and pos.Y > pos2.Y then
		--It's on the left-botttom corner
		return "left-bottom"
	elseif pos.X > pos3.X and pos.Y < pos3.Y then
		--It's on the right-top corner
		return "right-top"
	elseif pos.X > pos4.X and pos.Y > pos4.Y then
		--It's on the right-bottom corner
		return "right-bottom"
	end
end

local function clamp(pos, center, radius, corner)
	local dist = (pos-center).magnitude
	if dist > radius then
		if corner == "left-top" then
			local diff = Vector2.new(center.X - pos.X, center.Y - pos.Y)

			local hypotenus = dist
			local b = diff.Y
			local A = math.acos(b/hypotenus)

			return center - Vector2.new(radius * math.sin(A),radius  * math.cos(A))
		elseif corner == "left-bottom" then

			local diff = Vector2.new(center.X - pos.X, center.Y - pos.Y)

			local hypotenus = dist
			local b = diff.Y
			local A = math.acos(b/hypotenus)

			return center - Vector2.new(radius * math.sin(A),radius  * math.cos(A))

		elseif corner == "right-top" then
			local diff = Vector2.new(pos.X - center.X, pos.Y - center.Y)

			local hypotenus = dist
			local b = diff.Y
			local A = math.acos(b/hypotenus)

			return center + Vector2.new(radius * math.sin(A),radius  * math.cos(A))
		end
		--Elseif corner == "right-bottom" then
		local diff = Vector2.new(pos.X - center.X, pos.Y - center.Y)

		local hypotenus = dist
		local b = diff.Y
		local A = math.acos(b/hypotenus)

		return center + Vector2.new(radius * math.sin(A),radius  * math.cos(A))
	end
	return pos
end

function BorderSnap:ClampToBorder(position, absoluteSize, cornerRadius)
	--local pos = Vector2.new(math.clamp(position.X, 0, absoluteSize.X),math.clamp(position.Y, 0, absoluteSize.Y))
	local pos = position
	
	local radius, pos1, pos2, pos3, pos4 = getRadius(cornerRadius, absoluteSize)
	local corner = check(pos, pos1, pos2, pos3, pos4)
	
	if corner == "left-top" then
		pos = clamp(pos, pos1, radius, corner)
	elseif corner == "left-bottom" then
		pos = clamp(pos, pos2, radius, corner)
	elseif corner == "right-top" then
		pos = clamp(pos, pos3, radius, corner)
	elseif corner == "right-bottom" then
		pos = clamp(pos, pos4, radius, corner)
	end
	
	pos = Vector2.new(math.clamp(pos.X, 0, absoluteSize.X), math.clamp(pos.Y, 0, absoluteSize.Y))
	
	return pos
end

return BorderSnap
