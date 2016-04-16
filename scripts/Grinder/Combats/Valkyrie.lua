CombatValkyrie = { }
CombatValkyrie.__index = CombatValkyrie

CombatValkyrie.ABILITY_CHARGING_SLASH_IDS = {749,748,747}
CombatValkyrie.ABILITY_FORWARD_SLASH_IDS = {1478,1477,1476}
CombatValkyrie.ABILITY_SWORD_OF_JUDGEMENT_IDS = {735,734,733,732}
CombatValkyrie.CELESTIALSPEAR_IDS = { 768, 767, 766, 765 }
CombatValkyrie.BREATHOFELION_IDS = { 764, 763, 762 }
CombatValkyrie.SHIELDTHROW_IDS = { 1486, 1485 }
CombatValkyrie.HEAVENSECHO_IDS = { 746, 745, 744 }
CombatValkyrie.DIVINEPOWER_IDS = { 742, 741, 740, 739 }
CombatValkyrie.PUNISHMENT_IDS = { 779, 778, 777, 776 }
CombatValkyrie.SHIELD_STRIKE_IDS = { 1499, 1498, 1497 }
CombatValkyrie.GUARD_IDS = { 718 }

setmetatable(CombatValkyrie, {
	__call = function (cls, ...)
		return cls.new(...)
	end,
})

function CombatValkyrie.new()
	local self = setmetatable({}, CombatValkyrie)
	
-- Sword of Judgement Constants
	self.SWORD_OF_JUDGEMENT_TIMER = PyxTimer:New(1)
	self.SWORD_OF_JUDGEMENT_COUNT = 0
	self.DOING_SWORD_OF_JUDGEMENT = false
	
-- Forward Slash Constants
	self.FORWARD_SLASH_TIMER = PyxTimer:New(1)
	self.FORWARD_SLASH_COUNT = 0
	self.DOING_FORWARD_SLASH = false
	
-- Celestial Spear Constant
	self.DID_CELESTIALSPEAR = false
	
-- Breath of Elion Constant
	self.DID_BREATHOFELION = false
	
-- Sheild Throw Constant
	self.DID_SHIELDTHROW = false
	
-- Heavens Echo Constant
	self.DID_HEAVENSECHO = false
	
-- Divine Power Constant
	self.DID_DIVINEPOWER = false

-- Punishment Constant
	self.DID_PUNISHMENT = false	

-- Guard Constant
	self.DID_GUARD = false	
	
-- Shield Strike Constant
	self.DID_SHIELD_STRIKE = false	
	
-- End Constant
	return self
	
end


CombatValkyrie.SwordOfJudgement = function(self,monsterActor)
	local selfPlayer = GetSelfPlayer()
	local ABILITY_SWORD_OF_JUDGEMENT_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.ABILITY_SWORD_OF_JUDGEMENT_IDS)
	print("Sword of Judgement "..self.SWORD_OF_JUDGEMENT_COUNT)
if ABILITY_SWORD_OF_JUDGEMENT_ID == 732 then
 if self.SWORD_OF_JUDGEMENT_COUNT == 0 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_A_1LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 1 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_B_1LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 2 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_C_1LV",monsterActor.Position,900)
 end

elseif ABILITY_SWORD_OF_JUDGEMENT_ID == 733 then
 if self.SWORD_OF_JUDGEMENT_COUNT == 0 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_A_2LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 1 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_B_2LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 2 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_C_2LV",monsterActor.Position,900)
 end

elseif ABILITY_SWORD_OF_JUDGEMENT_ID == 734 then
 if self.SWORD_OF_JUDGEMENT_COUNT == 0 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_A_3LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 1 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_B_3LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 2 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_C_3LV",monsterActor.Position,900)
 end

elseif ABILITY_SWORD_OF_JUDGEMENT_ID == 735 then
 if self.SWORD_OF_JUDGEMENT_COUNT == 0 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_A_4LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 1 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_B_4LV",monsterActor.Position,900)
 elseif self.SWORD_OF_JUDGEMENT_COUNT == 2 then
  selfPlayer:DoActionAtPosition("BT_Skill_RotationBash_C_4LV",monsterActor.Position,900)
 end
end
	self.SWORD_OF_JUDGEMENT_COUNT = self.SWORD_OF_JUDGEMENT_COUNT + 1
	self.SWORD_OF_JUDGEMENT_TIMER:Reset()
	self.SWORD_OF_JUDGEMENT_TIMER:Start()
	self.DOING_SWORD_OF_JUDGEMENT = true
	if self.SWORD_OF_JUDGEMENT_COUNT >= 3 then
		self.SWORD_OF_JUDGEMENT_COUNT = 0
		self.DOING_SWORD_OF_JUDGEMENT = false
	end

end


CombatValkyrie.FrontSlice = function(self,monsterActor)
	local selfPlayer = GetSelfPlayer()
	local ABILITY_FORWARD_SLASH_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.ABILITY_FORWARD_SLASH_IDS)
	print("Front Slice "..self.FORWARD_SLASH_COUNT)

if ABILITY_FORWARD_SLASH_ID == 1476 then
 if self.FORWARD_SLASH_COUNT == 0 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice",monsterActor.Position,900)
 elseif self.FORWARD_SLASH_COUNT == 1 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_B",monsterActor.Position,900)
 elseif self.FORWARD_SLASH_COUNT == 2 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_RE",monsterActor.Position,900)
 end
 
 elseif ABILITY_FORWARD_SLASH_ID == 1477 then
 if self.FORWARD_SLASH_COUNT == 0 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_UP",monsterActor.Position,900)
 elseif self.FORWARD_SLASH_COUNT == 1 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_B_UP",monsterActor.Position,900)
 elseif self.FORWARD_SLASH_COUNT == 2 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_RE_UP",monsterActor.Position,900)
 end

 elseif ABILITY_FORWARD_SLASH_ID == 1478 then
 if self.FORWARD_SLASH_COUNT == 0 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_UP2",monsterActor.Position,900)
 elseif self.FORWARD_SLASH_COUNT == 1 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_B_UP2",monsterActor.Position,900)
 elseif self.FORWARD_SLASH_COUNT == 2 then
  selfPlayer:DoActionAtPosition("BT_Skill_FrontSlice_RE_UP2",monsterActor.Position,900)
 end

end

	self.FORWARD_SLASH_COUNT = self.FORWARD_SLASH_COUNT + 1
	self.FORWARD_SLASH_TIMER:Reset()
	self.FORWARD_SLASH_TIMER:Start()
	self.DOING_FORWARD_SLASH = true
	if self.FORWARD_SLASH_COUNT >= 3 then
		self.FORWARD_SLASH_COUNT = 1
		self.DOING_FORWARD_SLASH = false
	end


 
end


function CombatValkyrie:Attack(monsterActor)
    
	local ABILITY_CHARGING_SLASH_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.ABILITY_CHARGING_SLASH_IDS)
	local ABILITY_FORWARD_SLASH_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.ABILITY_FORWARD_SLASH_IDS)
	local ABILITY_SWORD_OF_JUDGEMENT_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.ABILITY_SWORD_OF_JUDGEMENT_IDS)
	local CELESTIALSPEAR_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.CELESTIALSPEAR_IDS)
	local BREATHOFELION_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.BREATHOFELION_IDS)
	local SHIELDTHROW_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.SHIELDTHROW_IDS)
	local HEAVENSECHO_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.HEAVENSECHO_IDS)
	local DIVINEPOWER_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.DIVINEPOWER_IDS)
	local PUNISHMENT_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.PUNISHMENT_IDS)
	local SHIELD_STRIKE_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.SHIELD_STRIKE_IDS)
	local GUARD_ID = SkillsHelper.GetKnownSkillId(CombatValkyrie.GUARD_IDS)
    
	if monsterActor then
		local selfPlayer = GetSelfPlayer()
		local actorPosition = monsterActor.Position
        
		if not self.FORWARD_SLASH_TIMER:IsRunning() 
		or self.FORWARD_SLASH_TIMER:IsRunning() and self.FORWARD_SLASH_TIMER:Expired() then
			self.DOING_FORWARD_SLASH = false
			self.FORWARD_SLASH_COUNT = 0
			self.FORWARD_SLASH_TIMER:Stop()

		end

		if not self.SWORD_OF_JUDGEMENT_TIMER:IsRunning() 
		or self.SWORD_OF_JUDGEMENT_TIMER:IsRunning() and self.SWORD_OF_JUDGEMENT_TIMER:Expired() 
		then
			self.DOING_SWORD_OF_JUDGEMENT = false
			self.SWORD_OF_JUDGEMENT_COUNT = 0
			self.SWORD_OF_JUDGEMENT_TIMER:Stop()

		end



		if actorPosition.Distance3DFromMe > monsterActor.BodySize + 150 then
			Navigator.MoveTo(actorPosition)
		else
			Navigator.Stop()
			if selfPlayer.IsActionPending then
				return
			end

-- Cast Breath of Elion
			if self.DID_BREATHOFELION == false and selfPlayer.HealthPercent < 60 and SkillsHelper.IsSkillUsable(BREATHOFELION_ID) and not selfPlayer:IsSkillOnCooldown(BREATHOFELION_ID) then
				print("HP is less than 60%, Healing!")
				selfPlayer:UseSkillAtPosition(BREATHOFELION_ID, actorPosition, 1000)
				self.DID_BREATHOFELION = true
				return
			end
			self.DID_BREATHOFELION = false

-- Cast Shield Strike Only if we just cast Guard!
			if self.DID_SHIELD_STRIKE == false and self.DID_GUARD == true and SkillsHelper.IsSkillUsable(SHIELD_STRIKE_ID) and not selfPlayer:IsSkillOnCooldown(SHIELDTHROW_ID) then
				print("Guard Up using Shield Strike!")
			  selfPlayer:UseSkillAtPosition(SHIELD_STRIKE_ID, actorPosition, 900)
			  self.DID_SHIELD_STRIKE = true
			 return
			end
			self.DID_SHIELD_STRIKE = false
			
-- Cast Guard
			if self.DID_GUARD == false and selfPlayer.HealthPercent < 55 and SkillsHelper.IsSkillUsable(GUARD_ID) and not selfPlayer:IsSkillOnCooldown(GUARD_ID) then
				print("HP is less than 50%, Guard!")
			  selfPlayer:UseSkillAtPosition(GUARD_ID, actorPosition, 900)
			  self.DID_GUARD = true
			 return
			end
			self.DID_GUARD = false
			
-- Cast Heavens Echo
			if self.DID_HEAVENSECHO == false and SkillsHelper.IsSkillUsable(HEAVENSECHO_ID) and not selfPlayer:IsSkillOnCooldown(HEAVENSECHO_ID) then
				print("Casting Heavens Echo")
				selfPlayer:UseSkillAtPosition(HEAVENSECHO_ID, monsterActor.Position, 900)
				self.DID_HEAVENSECHO = true
				return
			end
			self.DID_HEAVENSECHO = false
			
-- Cast Celestial Spear
			if self.DID_CELESTIALSPEAR == false and SkillsHelper.IsSkillUsable(CELESTIALSPEAR_ID) and not selfPlayer:IsSkillOnCooldown(CELESTIALSPEAR_ID) and selfPlayer.ManaPercent > 10 then
				print("Casting Celestial Spear!")
			 if CELESTIALSPEAR_ID == 765 then
				selfPlayer:DoActionAtPosition ("BT_Skill_HeavenSpear_1LV",actorPosition, 900)
			 elseif	CELESTIALSPEAR_ID == 766 then
				selfPlayer:DoActionAtPosition ("BT_Skill_HeavenSpear_2LV",actorPosition, 900)
			 elseif	CELESTIALSPEAR_ID == 767 then
				selfPlayer:DoActionAtPosition ("BT_Skill_HeavenSpear_3LV",actorPosition, 900)
			 elseif	CELESTIALSPEAR_ID == 768 then
				selfPlayer:DoActionAtPosition ("BT_Skill_HeavenSpear_4LV",actorPosition, 900)
--			 elseif	CELESTIALSPEAR_ID == 769 then
--				selfPlayer:UseSkillAtPosition(CELESTIALSPEAR_ID, monsterActor.Position, 900)
			 end
				self.DID_CELESTIALSPEAR = true
				return
			elseif self.DID_PUNISHMENT == false and not selfPlayer:IsSkillOnCooldown(PUNISHMENT_ID) then
				print("Punishment")
				selfPlayer:UseSkillAtPosition(PUNISHMENT_ID, monsterActor.Position, 900)
				self.DID_PUNISHMENT = true
				return
			end
			self.DID_CELESTIALSPEAR = false
			self.DID_PUNISHMENT = false
			
-- Cast Divine Power
			if self.DOING_FORWARD_SLASH == false and self.DID_DIVINEPOWER == false and SkillsHelper.IsSkillUsable(DIVINEPOWER_ID) and not selfPlayer:IsSkillOnCooldown(DIVINEPOWER_ID) and selfPlayer.Mana > 70 then
				print("Casting Divine Power")
				selfPlayer:UseSkillAtPosition(DIVINEPOWER_ID, monsterActor.Position, 900)
				self.DID_DIVINEPOWER = true
				return
			end
			self.DID_DIVINEPOWER = false
			
-- Cast Shield Throw
			if self.DID_SHIELDTHROW == false and SkillsHelper.IsSkillUsable(SHIELDTHROW_ID) and not selfPlayer:IsSkillOnCooldown(SHIELDTHROW_ID) and selfPlayer.ManaPercent > 10 then
				print("Using Shield Throw!")
				selfPlayer:UseSkillAtPosition(SHIELDTHROW_ID, monsterActor.Position, 900)
				self.DID_SHIELDTHROW = true
				return
			end
			self.DID_SHIELDTHROW = false
			
-- Sword Of Judgement
			if self.DOING_FORWARD_SLASH == false and SkillsHelper.IsSkillUsable(ABILITY_SWORD_OF_JUDGEMENT_ID) and
			not selfPlayer:IsSkillOnCooldown(ABILITY_SWORD_OF_JUDGEMENT_ID)
			then
				print("Using Sword of Judgement!")
				self.SwordOfJudgement(self,monsterActor)
				return
			end
			self.DOING_SWORD_OF_JUDGEMENT = false
			
-- Front Slice            
			if SkillsHelper.IsSkillUsable(ABILITY_FORWARD_SLASH_ID) and
			not selfPlayer:IsSkillOnCooldown(ABILITY_FORWARD_SLASH_ID)
			then
				self.FrontSlice(self,monsterActor)
				return
			end
		end
	end
end

return CombatValkyrie()