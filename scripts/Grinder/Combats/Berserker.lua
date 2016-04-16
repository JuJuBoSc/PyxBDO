CombatBerserker = { }
CombatBerserker.__index = CombatBerserker
CombatBerserker.Version = "1.1.3"
CombatBerserker.Author = "Vitalic/Edited By DimLight For Berzerker"



setmetatable(CombatBerserker, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function CombatBerserker.new()
  local self = setmetatable({}, CombatBerserker)
  
  self.Mode = 0
  
	CombatBerserker.ELASTIC_FORCE_IDS = { 1057, 1180, 1181, 1290 }
	CombatBerserker.RAGING_THUNDER_IDS = { 1179, 1178, 1177, 1176, 1175, 1044 }
	CombatBerserker.FRENZIED_DESTROYER_IDS = { 1171, 1170, 1169, 1168, 1167, 1042 }
	CombatBerserker.FEARSOME_TYRANT_IDS = { 1150, 1149, 1032 }

  return self
end



function CombatBerserker:GetMonsterCount()
    local monsters = GetMonsters()
    local monsterCount = 0

	for k, v in pairs(monsters) do
		if v.IsAggro then
			monsterCount = monsterCount + 1
		end

		self.Mode = 0

		if self.Mode == 0 then
			self.Mode = 1
		end
	end

	return monsterCount
end

function CombatBerserker:Roaming()
	local selfPlayer = GetSelfPlayer()
	if not selfPlayer then
		return
	end

	if self.Mode == 0 then
		self.Mode = 1
	end
end


function CombatBerserker:Attack(monsterActor)
    
	local ELASTIC_FORCE_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.ELASTIC_FORCE_IDS)
    local RAGING_THUNDER_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.RAGING_THUNDER_IDS)
    local FRENZIED_DESTROYER_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.FRENZIED_DESTROYER_IDS)
    local FEARSOME_TYRANT_ID = SkillsHelper.GetKnownSkillId(CombatBerserker.FEARSOME_TYRANT_IDS)
    
	local selfPlayer = GetSelfPlayer()
	local actorPosition = monsterActor.Position
	
------- Mob Find ----------------------------------------------------------------------
	if monsterActor then
		
		if actorPosition.Distance3DFromMe > monsterActor.BodySize + 500 then
			Navigator.MoveTo(actorPosition)
		else
			Navigator.Stop()
            
            if not selfPlayer.IsActionPending then

            
        if  RAGING_THUNDER_ID ~= 0 and selfPlayer.Mana > 100 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 450 and
                not selfPlayer:IsSkillOnCooldown(RAGING_THUNDER_ID) then
				print("Launching Raging Beasst!")
				selfPlayer:SetActionState(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, 7000)
                    return
                end
                
                   if FRENZIED_DESTROYER_ID ~= 0 and selfPlayer.Mana > 150 and selfPlayer:IsSkillOnCooldown(RAGING_THUNDER_ID) then
                    print("Launching Beastly Slash!")
						                   selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK, 1500)
						                   selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK, 500)
                    	return
                end
                
                    if FEARSOME_TYRANT_ID ~= 0 and (self:GetMonsterCount() > 3) and selfPlayer.Mana > 100 and selfPlayer.BlackRage == 100 and selfPlayer:IsSkillOnCooldown(RAGING_THUNDER_ID) then
                    print("Launching Fearsome Tyrant!")
						                   selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_1, 8000)
						                   selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_1, 8000)
                    	return
                end

            end
            selfPlayer:Interact(monsterActor) -- Auto attack for the win !
        end
    end
end

return CombatBerserker()