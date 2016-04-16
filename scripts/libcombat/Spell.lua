Spell = { }
Spell.__index = Spell

setmetatable(Spell, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Spell:new( ids , flags , duration , name )
  local self = setmetatable({}, Spell)
  
  self.SkillIDs = ids
  self.SkillID = 0
  self.CastFlags = flags
  self.Duration = duration
  self.LastCast = 0
  self.Name = name
  self.Known = false
  self.ForcedCooldown = 0
  self:initialize()
  
  return self
end

-- Initializes the spell , this can be later used
function Spell:initialize()

	-- Get the skill ID we know
	self.SkillID = SkillsHelper.GetKnownSkillId(self.SkillIDs)
	-- Determine if spell is known
	if self.SkillID == 0 then 
		self.Known = false 
	else 
		self.Known = true 
	end
	
	print("Skill : " .. self.Name .. " Id : " .. self.SkillID .. " Known : " .. tostring(self.Known) .. " IsUsable : " .. tostring(self:isUsable()))
end

-- Returns whether the spell was cast or not
function Spell:cast(targetPosition)
	local selfPlayer = GetSelfPlayer()
	
	if not self:isUsable() then
		return false
	end
	
	print("Casting spell - " .. self.Name)
	selfPlayer:UseSkillAtPosition(self.SkillID,targetPosition,self.DURATION)
	self.LastCast = Pyx.System.TickCount
	return true
end

function Spell:castHoldKey(targetPosition,shouldFaceTarget)
	local selfPlayer = GetSelfPlayer()
	
	if not self:isUsable() then
		return false
	end
	
	if shouldFaceTarget then
		selfPlayer:FacePosition(targetPosition)
	end
	print("Casting spell - " .. self.Name)
	if self.CastFlags == -1 then
		return self:cast(targetPosition)
	end
	
	selfPlayer:SetActionState(self.CastFlags)
	self.LastCast = Pyx.System.TickCount
	return true
end

-- Overrides the use of in-built cooldown system
function Spell:setForcedCooldown(cooldown)
	self.ForcedCooldown = cooldown
end

function Spell:isUsable()
	-- Spell is known, usable and is not on cooldown
	local isOnCooldown = true
	--print("Spell " .. self.Name .. " Known " .. tostring(self.Known) .. " IsUsable : " .. tostring(SkillsHelper.IsSkillUsable(self.SkillID)))
	-- handling user defined cooldowns
	if self.ForcedCooldown == 0 then 
		--print("LUA CD")
		isOnCooldown = GetSelfPlayer():IsSkillOnCooldown(self.SkillID) 
	else 
		--print("Custom CD")
		isOnCooldown = Pyx.System.TickCount - self.LastCast > self.ForcedCooldown 
	end

	--print("Spell " .. self.Name .. " Known " .. tostring(self.Known) .. " IsUsable : " .. tostring(SkillsHelper.IsSkillUsable(self.SkillID)) .. " IsOnCd : " .. tostring(isOnCooldown))
	return self.Known and 
		   SkillsHelper.IsSkillUsable(self.SkillID) and 
		   not isOnCooldown
end
