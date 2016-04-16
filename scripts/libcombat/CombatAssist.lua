CA = {}

-- Returns all monsters in specified range from the player
function CA.MonstersInRange(range)
	local monsters = GetMonsters()
	local result = {}
	print("Range " .. range)
    for _, v in pairs(monsters) do
        if v.Position.Distance3DFromMe < range then
            table.insert(result,v)
        end
    end
    return result
end

-- Returns the count of all monsters in specified range from the player
function CA.MonstersInRangeCount(range)
	return table.length(CA.MonstersInRange(range))
end


function CA.AggroedMonstersInRange(range)
	local result = {}
	for _, v in pairs(CA.MonstersInRange(range)) do
		if v.IsAggro then
			table.insert(result,v)
		end
	end
	return result
end

function CA.AggroedMonstersInRangeCount(range)
	return table.length(CA.AggroedMonstersInRange(range))
end

function CA.IsTargetAttacking(targetMob)
	return string.find(targetMob.CurrentActionName,"ATTACK")
end

function CA.IsGuarding()
	local selfPlayer = GetSelfPlayer()
	return string.find(selfPlayer.CurrentActionName,"Defence")
end