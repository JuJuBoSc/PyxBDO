EdanScout = {}
EdanScout.FrontDegrees = 90
EdanScout.MeleeRange = 150
EdanScout.MidRange = 800
EdanScout.MaxRange = 1400

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

		
		local meleeRange = (v.Position.Distance2DFromMe - v.BodySize - selfPlayer.BodySize < EdanScout.MeleeRange) and EdanScout.Melee2DHeightCheck(selfPlayer, v)
		local distance = v.Position.Distance3DFromMe - v.BodySize - selfPlayer.BodySize
    	
    	if meleeRange then
    		EdanScout.MonstersInMeleeRange = EdanScout.MonstersInMeleeRange + 1
		elseif distance < EdanScout.MidRange then
			EdanScout.MonstersInMidRange = EdanScout.MonstersInMidRange + 1
		end
	end
end

-- Assuming position is at the bottom of each model. This only works on monsters right next to you with 2d calculations. Might be able to add some extra distance to this.
-- if we are below them, then player height is the max
-- if we are above them, then target height is the max
function EdanScout.Melee2DHeightCheck(player, target)
	local ydiff = player.Position.Y - target.Position.Y
	if ydiff < 0 then
		return -ydiff <= player.BodyHeight
	else
		return ydiff <= target.BodyHeight
	end
end

-- table.sort(monsters, function(a,b) return a.Position:GetDistance3D(selfPlayerPosition) < b.Position:GetDistance3D(selfPlayerPosition) end)

-- rotation starts from 0 at south and increases clockwise to 2 pi

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

-- returns a unit vector given a rotation
function EdanScout.RotationVector(radians)
	local fixedRotation = math.pi * 2 - EdanScout.WrapFloat(radians - math.pi / 2, math.pi * 2)
	return -math.cos(fixedRotation), -math.sin(fixedRotation)
end

-- returns a position given the starting position, rotation, and optional length
function EdanScout.RotationPosition(originVector, rotationRadians, length)
	if length == nil then
		length = 1
	end
	local dx,dz = EdanScout.RotationVector(rotationRadians)
	return Vector3(originVector.X + dx * length, originVector.Y, originVector.Z + dz * length)
end

function EdanScout.MyForwardPosition(length)
	local player = GetSelfPlayer()
	return EdanScout.RotationPosition(player.Position, player.Rotation, length)
end

function EdanScout.MyLeftPosition(length)
	local player = GetSelfPlayer()
	return EdanScout.RotationPosition(player.Position, player.Rotation - math.pi / 2, length)
end

function EdanScout.MyRightPosition(length)
	local player = GetSelfPlayer()
	return EdanScout.RotationPosition(player.Position, player.Rotation + math.pi / 2, length)
end

function EdanScout.MyBackPosition(length)
	local player = GetSelfPlayer()
	return EdanScout.RotationPosition(player.Position, player.Rotation - math.pi, length)
end

-- utilities

-- wraps value between 0 and max
function EdanScout.WrapFloat(value, max)
	if value < 0 then
		return max + math.fmod(value, max)
	else
		return math.fmod(value, max)
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

-- deprecated names

EdanScout.InverseAtan = EdanScout.RotationVector