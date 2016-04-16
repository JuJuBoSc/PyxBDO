WarriorV3 = { }
WarriorV3.__index = WarriorV3
WarriorV3.ShouldGuard = false
WarriorV3.ShouldTryDisable = true

setmetatable(WarriorV3, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function WarriorV3.new()
	local instance = {}
	local self = setmetatable(instance, WarriorV3)

	instance.CHARGING_THRUST = 	
	Spell:new({ 1022, 1130, 1131, 1132 }, 
	ACTION_FLAG_MOVE_FORWARD | ACTION_FLAG_SPECIAL_ACTION_3 ,	
	1500,	
	"ChargingThrust")

	instance.SPINNING_SLASH = 
	Spell:new({ 1021, 1127, 1128, 1129, 1041 },
	ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SECONDARY_ATTACK,
	1000,
	"SpinningSlash")

	instance.CHOPPING_KICK = 
	Spell:new({1144,712,1145},
	ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SPECIAL_ACTION_3,
	1000,
	"ChoppingKick")
	instance.CHOPPING_KICK:setForcedCooldown(4000) -- We dont want to just spam chopping kick
	
	instance.HEAVY_STRIKE = 
	Spell:new({ 1020, 1083, 1084 },
	ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK,
	1500,
	"HeavyStrike")

	instance.GUARD = 
	Spell:new({1144,712,1145,1019},
	ACTION_FLAG_SPECIAL_ACTION_1,
	1500,
	"Guard")
	
	instance.SCARS_OF_DUSK = 
	Spell:new({385},
	-1, -- force cast via ID
	2000,
	"ScarsOfDusk")
	
	instance.FORWARD_SLASH = 
	Spell:new({ 349, 350, 351, 705 ,376 },
	ACTION_FLAG_MOVE_FORWARD | ACTION_FLAG_MAIN_ATTACK,
	1000,
	"ForwardSlash")
	
	instance.GROUND_ROAR = 
	Spell:new({ 216, 217, 218, 219},
	ACTION_FLAG_EVASION |  ACTION_FLAG_SECONDARY_ATTACK,
	1000,
	"GroundRoar")
	instance.GROUND_ROAR:setForcedCooldown(10000) -- We just want the debuff
	
	instance.GROUND_SMASH = 
	Spell:new({ 1023, 1133, 1134, 1135},
	ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_3,
	1000,
	"GroundSmash")
	
	instance.KICK = 
	Spell:new({ 1030 },
	ACTION_FLAG_SPECIAL_ACTION_3 ,
	1000,
	"Kick")
	instance.KICK:setForcedCooldown(4000) -- same as chopping kick
	
	instance.TAKEDOWN = 
	Spell:new({ 1028, 1080, 1081, 1082 , 715 },
	-1,
	1000,
	"Takedown")
	
	print("Creating spellbooks")
	instance.SpellbookST = {}
	table.insert(self.SpellbookST,instance.GROUND_ROAR)
	table.insert(self.SpellbookST,instance.SCARS_OF_DUSK)
	table.insert(self.SpellbookST,instance.CHOPPING_KICK)
	table.insert(self.SpellbookST,instance.GROUND_SMASH)
	table.insert(self.SpellbookST,instance.SPINNING_SLASH)
	table.insert(self.SpellbookST,instance.FORWARD_SLASH)
	print("Created single target spellbook")
	
	instance.SpellbookAOE = {}
	table.insert(self.SpellbookAOE,instance.GROUND_ROAR)
	table.insert(self.SpellbookAOE,instance.SCARS_OF_DUSK)
	table.insert(self.SpellbookAOE,instance.GROUND_SMASH)
	table.insert(self.SpellbookAOE,instance.SPINNING_SLASH)
	table.insert(self.SpellbookAOE,instance.FORWARD_SLASH)
	print("Created aoe spellbook")
	
	instance.SpellbookDISABLE = {}
	table.insert(self.SpellbookDISABLE,instance.KICK)
	table.insert(self.SpellbookDISABLE,instance.TAKEDOWN)
	print("Created disable spellbook")
	
	
	instance.CastLock = 0
	
	return self
end

function WarriorV3:castSpellFrom(spellbook,targetPosition)
	for _, v in pairs(spellbook) do
		if v:castHoldKey(targetPosition,true) then
			self.CastLock = Pyx.System.TickCount + v.Duration
			return
		end
	end
end

function WarriorV3:evadeDamage(monsterActor)
	-- Experimental so bear with me :)
	if not CA.IsGuarding() and CA.IsTargetAttacking(monsterActor) then
		print("I should guard")
		self.GUARD:castHoldKey(monsterActor.Position,true)
		return true
	elseif CA.IsGuarding() and CA.IsTargetAttacking(monsterActor) then
		return true
	end
	return false
end

function WarriorV3:Attack(monsterActor)
    local selfPlayer = GetSelfPlayer()
    local targetPosition = monsterActor.Position   
   	
		
	if Pyx.System.TickCount < self.CastLock then
		--print("Spell in progress return")
		return
	end
	
    if monsterActor then		
		
        if targetPosition.Distance3DFromMe > monsterActor.BodySize + 250 then
			-- Close the gap
			if self.CHARGING_THRUST:cast(targetPosition) then
				return
			end
            Navigator.MoveTo(targetPosition)
        else
			
			
			if self.ShouldGuard then
				if self:evadeDamage(monsterActor) then
					return 
				end
			end
			
			if self.ShouldTryDisable then
				print("############# TRY DISABLE ##################")
				self:castSpellFrom(self.SpellbookDISABLE,targetPosition)
			end						
			
			if CA.AggroedMonstersInRangeCount(400) > 4 then
				-- Aoe mode
				self:castSpellFrom(self.SpellbookAOE,targetPosition)
			else
				-- Single targetPosition
				self:castSpellFrom(self.SpellbookST,targetPosition)
			end

			-- If we have cast no spell at least auto attack 
			print("Interacting - Autoattack")
			selfPlayer:Interact(monsterActor) 
        end
         
    end
end


return WarriorV3()