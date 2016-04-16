EdanScout = {}
EdanScout.FrontDegrees = 90
EdanScout.MeleeRange = 50
EdanScout.MidRange = 800
EdanScout.MaxRange = 1200

-- call this right before use
function EdanScout.Update()
	local selfPlayer = GetSelfPlayer()
	local rotation = selfPlayer.Rotation

	EdanScout.X = selfPlayer.Position.X
	EdanScout.Z = selfPlayer.Position.Z
	local halfOfFront = math.rad(EdanScout.FrontDegrees) / 2
	EdanScout.FrontLeft = EdanScout.WrapFloat(rotation - halfOfFront, math.pi * 2)
	EdanScout.FrontRight = EdanScout.WrapFloat(rotation + halfOfFront, math.pi * 2)

    local monsters = GetMonsters()
    EdanScout.Monsters = {}
    for k,v in pairs(monsters) do
        if v.IsVisible and 
            v.IsAlive and
            v.CanAttack and
            v.Position.Distance2DFromMe - v.BodySize <= EdanScout.MaxRange and 
            v.IsLineOfSight then
            table.insert(EdanScout.Monsters, v)
        end
    end

    EdanScout.MonstersInMidRange = 0
    EdanScout.MonstersInMeleeRange = 0
    EdanScout.MonstersAggroed = 0
    EdanScout.AggroBehind = 0

    for i,v in ipairs(EdanScout.Monsters) do
    	if v.IsAggro then
    		EdanScout.MonstersAggroed = EdanScout.MonstersAggroed + 1
    		if not EdanScout.InFrontOfMe(v.Position) then
    			EdanScout.AggroBehind = EdanScout.AggroBehind + 1
			end
		end

		local distance = v.Position.Distance2DFromMe - v.BodySize - selfPlayer.BodySize
		if v.BodySize > 150 then
			distance = distance - 150
		end
    	
    	if distance < EdanScout.MeleeRange then
    		EdanScout.MonstersInMeleeRange = EdanScout.MonstersInMeleeRange + 1
		elseif distance < EdanScout.MidRange then
			EdanScout.MonstersInMidRange = EdanScout.MonstersInMidRange + 1
		end
	end
end

-- table.sort(monsters, function(a,b) return a.Position:GetDistance3D(selfPlayerPosition) < b.Position:GetDistance3D(selfPlayerPosition) end)

-- is this coordinate in front of me?
function EdanScout.InFrontOfMe(vector)
	local relativeX = vector.X - EdanScout.X
	local relativeZ = vector.Z - EdanScout.Z
	local rotationRelativeToOrigin = EdanScout.Atan2bdo(relativeZ, relativeX)

	-- right on top
	if relativeX == 0 and relativeY == 0 then
		return true
	end

	if EdanScout.FrontLeft > EdanScout.FrontRight then
		return rotationRelativeToOrigin > EdanScout.FrontLeft or rotationRelativeToOrigin < EdanScout.FrontRight
	else
		return rotationRelativeToOrigin < EdanScout.FrontRight and rotationRelativeToOrigin > EdanScout.FrontLeft
	end
end

function EdanScout.InFront(originVector, originRotation, fieldOfViewDegrees, targetVector)
	local relativeX = targetVector.X - originVector.X
	local relativeZ = targetVector.Z - originVector.Z
	local rotationRelativeToOrigin = EdanScout.Atan2bdo(relativeZ, relativeX)

	-- right on top
	if relativeX == 0 and relativeY == 0 then
		return true
	end

	local halfOfFront = math.rad(fieldOfViewDegrees) / 2
	local frontLeft = EdanScout.WrapFloat(originRotation - halfOfFront, math.pi * 2)
	local frontRight = EdanScout.WrapFloat(originRotation + halfOfFront, math.pi * 2)

	if frontLeft > frontRight then
		return rotationRelativeToOrigin > frontLeft or rotationRelativeToOrigin < frontRight
	else
		return rotationRelativeToOrigin < frontRight and rotationRelativeToOrigin > frontLeft
	end	
end

-- utilities

-- binds f between 0 and max. WARNING, absolute value of f cannot be bigger than max
function EdanScout.WrapFloat(f, max)
	if f < 0 then
		return max + f
	elseif f > max then
		return f - max
	else
		return f
	end
end

-- atan2 that works with actor.Rotation
function EdanScout.Atan2bdo(y, x)
	local output = 0
	if y ~= 0 then
		output = 2 * math.atan((math.sqrt(x*x + y*y) - x) / y)
	elseif x > 0 then
		output = 0
	elseif x < 0 then
		output = math.pi
	else
		output = 0
	end

	return math.pi * 2 - EdanScout.WrapFloat(output + math.pi / 2, math.pi * 2)
end

-- returns a unit vector given a rotation
function EdanScout.InverseAtan(radians)
	local fixedRotation = math.pi * 2 - WrapFloat(radians - math.pi / 2, math.pi * 2)
	return -math.cos(fixedRotation), -math.sin(fixedRotation)
end