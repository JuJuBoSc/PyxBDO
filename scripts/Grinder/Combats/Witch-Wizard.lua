Magician = { }
Magician.__index = Magician
Magician.version = "1.22"

------------- Witch and Wizard Skills ------------------------------------------------------------------------------------
Magician.BLIZZARD_ID 					= { 845, 844, 843 } -- lvl 25, 35, 45					-- TESTING
Magician.CONCENTRATED_MAGIC_ARROW_ID 	= { 889, 888, 887 } -- lvl 38 26 12						-- DONE
Magician.DAGGER_STAB_ID 				= { 897, 896, 895, 894, 893 } -- lvl 49 37 24 12 1		-- DONE
Magician.EARTHS_RESPONSE_ID 			= { 914, 913, 912 } -- lvl 38 23 1						-- TESTING
Magician.EARTHQUAKE_ID 					= { 789, 788, 787, 786 } -- lvl 52 45 38 30				-- NO
Magician.FIREBALL_ID 					= { 821, 820, 819, 818 } -- lvl 30 20 13 3 				-- DONE
Magician.FIREBALL_EXPLOSION_ID 			= { 849, 848, 847 } -- lvl 46 34 18						-- DONE
Magician.FREEZE_ID 						= { 838, 837, 836, 835, 834 } -- lvl 40 31 23 15 9		-- NO
Magician.FRIGID_FOG_ID 					= { 842, 841, 840, 839 } -- lvl 42 34 27 21				-- NO
Magician.HEALING_AURA_ID 				= { 903, 902, 901, 900, 899 } -- lvl 45 36 27 19 10		-- DONE
Magician.HEALING_LIGHTHOUSE_ID 			= { 796, 795, 794, 793 } -- lvl 48 41 34 27				-- DONE
Magician.LIGHTNING_CHAIN_ID 			= { 830, 829, 828, 827 } -- lvl 46 37 28 0				-- DONE
Magician.LIGHTNING_ID 					= { 826, 825, 824, 823, 822 } -- lvl 46 37 29 21 14		-- DONE
Magician.LIGHTNING_STORM_ID 			= { 833, 832, 831 } -- lvl 49 35 23						-- TESTING
Magician.MAGIC_ARROW_ID 				= { 854, 853, 852, 851, 850 } -- lvl 43 39 26 10 1		-- DONE
Magician.MAGIC_LIGHTHOUSE_ID 			= { 1622, 1621, 1620 } -- lvl 49 34 21					-- DONE
Magician.MAGICAL_EVASION_ID 			= { 876, 875, 874, 873, 872 } -- lvl 40 31 20 11 1		-- TESTING
Magician.MAGICAL_SHIELD_ID 				= { 871, 870, 869, 868 } -- lvl 40 29 20 11				-- DONE				
Magician.MAGICAL_ABSORPTION_ID 			= { 867, 866, 865 } -- lvl 45 30 0						-- DONE
Magician.METEOR_SHOWER_ID 				= { 792, 791, 790 } -- lvl 50 40 0						-- TESTING
Magician.MULTIPLE_MAGIC_ARROWS_ID 		= { 855 } -- lvl 49										-- DONE
Magician.PROTECTED_AREA_ID 				= { 864, 863, 862, 861, 860 } -- lvl 54 46 38 31 25		-- NO
Magician.RESIDUAL_LIGHTNING_ID 			= { 859, 858, 857, 856 } -- lvl 40 33 26 19				-- DONE
Magician.RESURRECTION_ID 				= { 892, 891, 890 } -- lvl 54 50 45						-- NO
Magician.SAGES_MEMORY_ID 				= { 898 } -- lvl 20										-- NO
Magician.SPEED_SPELL_ID 				= { 1122, 1121, 1120 } -- lvl 48 32 15					-- NO
Magician.SPELLBOUND_HEART_ID 			= { 908, 907, 906, 905, 904 } -- lvl 55 47 38 29 20		-- DONE
Magician.STAFF_ATTACK_ID 				= { 886, 885, 884, 883, 882, 881, 880, 879, 878, 877 } -- lvl 43 39 35 31 27 23 19 14 9 1 -- NO
Magician.TELEPORT_ID 					= { 911, 910, 909 } -- lvl 51 38 13						-- TESTING
Magician.ULTIMATE_BLIZZARD_ID 			= { 846 } -- lvl 52 									-- NO

------------- Testing Toggles --------------------------------------------------------------------------------------------
Magician.USECOOLDOWNS = true
Magician.USETELEPORT = false
Magician.EARTHSRESPONSE = false
--------------------------------------------------------------------------------------------------------------------------

--blackspirit rage
	-- BT_Party_Skill_Lightning_Bolt_Cast_Lv3
	-- BT_Party_Skill_Lightning_Bolt_Att_Lv3
	-- BT_Party_Skill_Lightning_Bolt_End

------------- SetActionState Buttons -------------------------------------------------------------------------------------
Magician.LMB 		= ACTION_FLAG_MAIN_ATTACK
Magician.RMB 		= ACTION_FLAG_SECONDARY_ATTACK
Magician.Shift 		= ACTION_FLAG_EVASION
Magician.Space 		= ACTION_FLAG_JUMP
Magician.Q 			= ACTION_FLAG_SPECIAL_ACTION_1
Magician.E 			= ACTION_FLAG_SPECIAL_ACTION_2
Magician.F 			= ACTION_FLAG_SPECIAL_ACTION_3
Magician.W 			= ACTION_FLAG_MOVE_FORWARD
Magician.S 			= ACTION_FLAG_MOVE_BACKWARD
Magician.A 			= ACTION_FLAG_MOVE_LEFT
Magician.D 			= ACTION_FLAG_MOVE_RIGHT
Magician.Z 			= ACTION_FLAG_PARTNER_COMMAND_1
Magician.X 			= ACTION_FLAG_PARTNER_COMMAND_2
Magician.C 			= ACTION_FLAG_AWEKENED_GEAR
Magician.V 			= ACTION_FLAG_EMERGENCY_ESCAPE
--------------------------------------------------------------------------------------------------------------------------
--Magician.USEDODGE = false
-- if Magician.USEDODGE and monsterPosition.Distance3DFromMe < monster.BodySize + 300 and selfPlayer.HealthPercent < 30 then
	-- local rnd = math.random(1,3)
	-- local direction = { self.A, self.S, self.D }
	-- print("low hp try to dodge [TESTING]")
	-- selfPlayer:SetActionState(self.Shift | direction[rnd], 100)
	-- if string.match(selfPlayer.CurrentActionName, "BT_ROLL_") then
	-- end
	-- return
-- end
-- if selfPlayer.HealthPercent > 99 then
	-- DodgeCount = 0
-- end
--------------------------------------------------------------------------------------------------------------------------
setmetatable(Magician, { 
	__call = function(cls, ...)
		return cls.new(...)
	end,
})
------------- Setup New Magician -----------------------------------------------------------------------------------------

function Magician.new()
	local self = setmetatable({}, Magician)
	self.manaabsorb = false
	local Magical_Absorption = SkillsHelper.GetKnownSkillId(Magician.MAGICAL_ABSORPTION_ID)
	if Magical_Absorption ~= 0 then
		self.manaabsorb = true
	else
		self.manaabsorb = false
	end
		
	--self.residual_timer = PyxTimer:New(1)
	
	return self
end
------------- functions --------------------------------------------------------------------------------------------------

function Magician:SkillReady(Id)
	local selfPlayer = GetSelfPlayer()
	if selfPlayer and Id ~= 0 and SkillsHelper.IsSkillUsable(Id) and selfPlayer:IsSkillOnCooldown(Id) == false then
		return true
	end
	return false
end

function Magician:MonsterCount()
	local monsters = GetMonsters()
	local count = 0
	for k, monsters in pairs(monsters) do
		if monsters.IsAggro then
			count = count + 1
		end
	end
	return count
end

function Magician:FixFire()
	local selfPlayer = GetSelfPlayer()
	if selfPlayer:CheckCurrentAction("BT_Skill_Fireball_Ing") then
		print("Fireball stuck...firing")
		selfPlayer:DoActionAtPosition("BT_Skill_Fireball_Shot", selfPlayer.Position, 500)
		return
	end
end
------------- Roaming ----------------------------------------------------------------------------------------------------

function Magician:Roaming()
    local selfPlayer = GetSelfPlayer()
    if not selfPlayer then return end
	local playerPosition = selfPlayer.Position
	
    self:FixFire()
	
    local Healing_Aura = SkillsHelper.GetKnownSkillId(Magician.HEALING_AURA_ID)
    if selfPlayer.HealthPercent <= 70 and self:SkillReady(Healing_Aura) then
		print("Health Low out of comabt using Healing Aura")
    	selfPlayer:SetActionState(self.E)
    	return
    end
	
	--speed spell buff ids (lvl 3 22548 22688 22828) (lvl 2 22541 22681 22821) (lvl 1 22534 22674 22814)
	-- local Speed_Spell = SkillsHelper.GetKnownSkillId(Magician.SPEED_SPELL_ID)
	-- if self:SkillReady(Speed_Spell) and selfPlayer.ManaPercent > 15 and not (selfPlayer:HasBuffById(22548) or selfPlayer:HasBuffById(22541) or selfPlayer:HasBuffById(22534)) then
		-- print("Using Speed Spell - Sweet Sweet Buffs")
		-- selfPlayer:UseSkillAtPosition(Speed_Spell, playerPosition, 100)
		-- return
	-- end		
end
------------- Attack Rotation --------------------------------------------------------------------------------------------

function Magician:Attack(monster)
	local selfPlayer = GetSelfPlayer()
	if monster and selfPlayer then
		local monsterPosition = monster.Position
		local playerPosition = selfPlayer.Position
		
		self:FixFire()
		if string.match(selfPlayer.CurrentActionName, "BT_Skill_Meteor_Ing") or string.match(selfPlayer.CurrentActionName, "BT_Skill_Blizzard_CastIng") or string.match(selfPlayer.CurrentActionName, "BT_Skill_Magic_Blaster_Ing") then -- or string.match(selfPlayer.CurrentActionName, "BT_Skill_Fireball_Ing")
			selfPlayer:SetActionState(self.LMB, 500)
		end
		
		if (monsterPosition.Distance3DFromMe > monster.BodySize + 1200) or not monster.IsLineOfSight then
			Navigator.MoveTo(monsterPosition)
		else
			Navigator.Stop()
			if not selfPlayer.IsActionPending then
				-- Pre Mana Drain Rotation for lower level chain etc etc
				if not self.manaabsorb then

					local Healing_Aura = SkillsHelper.GetKnownSkillId(Magician.HEALING_AURA_ID)
					if (selfPlayer.HealthPercent <= 75 or selfPlayer.ManaPercent < 60) and self:SkillReady(Healing_Aura) and not string.match(selfPlayer.CurrentActionName, "Lightning") and not string.match(selfPlayer.CurrentActionName, "Mana_Drain") and not string.match(selfPlayer.CurrentActionName, "Fireball") then
						print("Health is under 75% Using Healing Aura")
						selfPlayer:SetActionState(self.E)
						return
					end
					
					local Magical_Shield = SkillsHelper.GetKnownSkillId(Magician.MAGICAL_SHIELD_ID)
					if ((selfPlayer.HealthPercent <= 70 and Magician:MonsterCount() >= 2) or selfPlayer.HealthPercent <= 50) and selfPlayer.ManaPercent >= 30 and self:SkillReady(Magical_Shield) and not selfPlayer:HasBuffById(617) then
						print("Health low, mobs around using defensive Magical Shield")
						selfPlayer:SetActionStateAtPosition(self.Q, monsterPosition, 100)
						return
					end
				
					local Lightning_Chain = SkillsHelper.GetKnownSkillId(Magician.LIGHTNING_CHAIN_ID)
					if self:SkillReady(Lightning_Chain) and monster.IsLineOfSight and selfPlayer.ManaPercent >= 50 and not self:SkillReady(Fireball) and not self:SkillReady(Lightning) and (Magician.MonsterCount() > 1 or monster.HealthPercent > 95) then
						print("USING CHAIN MOBS > 3")
						selfPlayer:SetActionStateAtPosition(self.Shift | self.RMB, monsterPosition, 3500)
						return
					end
					
					local Fireball = SkillsHelper.GetKnownSkillId(Magician.FIREBALL_ID)
					if self:SkillReady(Fireball) and selfPlayer.ManaPercent > 10  and monster.HealthPercent > 10 and not string.match(selfPlayer.CurrentActionName, "Lightning") and not string.match(selfPlayer.CurrentActionName, "Mana_Drain") then
						if monsterPosition.Distance3DFromMe > monster.BodySize + 900 then
							Navigator.Stop()
							print("Casting Fireball")
							selfPlayer:SetActionStateAtPosition(self.S | self.LMB, monsterPosition, 1500)
						else
							Navigator.Stop()
							selfPlayer:SetActionStateAtPosition(self.S | self.LMB, monsterPosition, 2000)
							if string.match(selfPlayer.CurrentActionName, "Fireball_Cast_") then
								print("Mob close range: Casting quick fireball")
								selfPlayer:SetActionStateAtPosition(self.RMB, monsterPosition, 2000)
							end
						end
						return
					end
					
					local Magic_Arrow = SkillsHelper.GetKnownSkillId(Magician.MAGIC_ARROW_ID)
					if self:SkillReady(Magic_Arrow) then
						print("Using Magic Arrow")
						selfPlayer:SetActionStateAtPosition(self.RMB, monsterPosition, 300)
						return
					end
					
				else
				
					local Healing_Aura = SkillsHelper.GetKnownSkillId(Magician.HEALING_AURA_ID)
					if (selfPlayer.HealthPercent <= 75 or selfPlayer.ManaPercent < 60) and self:SkillReady(Healing_Aura) then
						print("Health is under 75% Using Healing Aura")
						selfPlayer:SetActionState(self.E)
						return
					end

					local Healing_Lighthouse = SkillsHelper.GetKnownSkillId(Magician.HEALING_LIGHTHOUSE_ID)  
					if (selfPlayer.HealthPercent <= 50 or selfPlayer.ManaPercent <= 30) and self:SkillReady(Healing_Lighthouse) and selfPlayer.ManaPercent >= 10 then
						print("Health is under 50% or Mana is under 30% Using Healing Lighthouse")
						selfPlayer:SetActionState(self.Shift | self.E, 3000)
						return
					end

					local Magical_Absorption = SkillsHelper.GetKnownSkillId(Magician.MAGICAL_ABSORPTION_ID)
					if selfPlayer.ManaPercent <= 55 and self:SkillReady(Magical_Absorption) and not string.match(selfPlayer.CurrentActionName, "Lightning") and not string.match(selfPlayer.CurrentActionName, "Fireball") then
						Navigator.Stop()
						print("Mana is under 55% Using Magical Absorption")
						selfPlayer:SetActionStateAtPosition(self.Shift | self.LMB, monsterPosition, 4000)
						return
					end
					
					local Spellbound_Heart = SkillsHelper.GetKnownSkillId(Magician.SPELLBOUND_HEART_ID)
					if selfPlayer.ManaPercent <= 80 and self:SkillReady(Spellbound_Heart) then
						print("Mana Orb Going out")
						selfPlayer:UseSkillAtPosition(Spellbound_Heart, playerPosition, 500)
						return
					end

					local Magical_Shield = SkillsHelper.GetKnownSkillId(Magician.MAGICAL_SHIELD_ID)
					if ((selfPlayer.HealthPercent <= 70 and Magician:MonsterCount() >= 2) or selfPlayer.HealthPercent <= 50) and selfPlayer.ManaPercent >= 30 and self:SkillReady(Magical_Shield) and not selfPlayer:HasBuffById(617) then
						print("Health low, mobs around using defensive Magical Shield")
						selfPlayer:SetActionStateAtPosition(self.Q, monsterPosition, 100)
						return
					end
					
					local Magic_Lighthouse = SkillsHelper.GetKnownSkillId(Magician.MAGIC_LIGHTHOUSE_ID)
					if Magician.MonsterCount() > 2 and selfPlayer.HealthPercent <= 40 and self:SkillReady(Magic_Lighthouse) then
						print("Using Taunt Orb")
						selfPlayer:UseSkillAtPosition(Magic_Lighthouse, monsterPosition, 500)
						return
					end			
					
					local Teleport = SkillsHelper.GetKnownSkillId(Magician.TELEPORT_ID)
					if Magician.USETELEPORT and selfPlayer.HealthPercent < 40 and monsterPosition.Distance3DFromMe < monster.BodySize + 400 and self:SkillReady(Teleport) and not (self:SkillReady(Healing_Aura) or self:SkillReady(Healing_Lighthouse)) then
						print("[TESTING] Health under 40% and mobs close using Teleport [TEST]")
						selfPlayer:SetActionState(self.Shift | self.Space, 1500)
						return
					end
					
					local Sage_Memory = SkillsHelper.GetKnownSkillId(Magician.SAGES_MEMORY_ID) -- buff 110
					local Blizzard = SkillsHelper.GetKnownSkillId(Magician.BLIZZARD_ID)
					local Meteor_Shower = SkillsHelper.GetKnownSkillId(Magician.METEOR_SHOWER_ID)
					if self:SkillReady(Sage_Memory) and not selfPlayer:HasBuffById(110) and (self:SkillReady(Blizzard) or self:SkillReady(Meteor_Shower)) and Magician.MonsterCount() >= 3 then
						print("Casting Sage Memory [Instant Cast Cooldowns")
						selfPlayer:UseSkillAtPosition(Sage_Memory, monsterPosition, 1000)
						return
					end
					
					if Magician.USECOOLDOWNS and selfPlayer.BlackRage < 100 and self:SkillReady(Blizzard) and selfPlayer.ManaPercent >= 60 and selfPlayer:HasBuffById(110) and not string.match(selfPlayer.CurrentActionName, "BT_Skill_Meteor")  and Magician.MonsterCount() >= 3 then
						print("Casting Blizzard [TEST]")
						selfPlayer:SetActionStateAtPosition(self.Shift | self.LMB | self.RMB, monsterPosition, 4000)
						return
					end
					
					if Magician.USECOOLDOWNS and selfPlayer.BlackRage < 100 and selfPlayer.ManaPercent >= 50 and selfPlayer:HasBuffById(110) and self:SkillReady(Meteor_Shower) and not string.match(selfPlayer.CurrentActionName, "BT_Skill_Blizzard") and Magician.MonsterCount() >= 3 then
						print("Casting Meteor [TEST]")
						selfPlayer:SetActionStateAtPosition(self.S | self.LMB | self.RMB, monsterPosition, 4000)
						return
					end
					
					local Lightning = SkillsHelper.GetKnownSkillId(Magician.LIGHTNING_ID)
					if self:SkillReady(Lightning) and selfPlayer.ManaPercent > 10 and not string.match(selfPlayer.CurrentActionName, "Fireball") and not string.match(selfPlayer.CurrentActionName, "Mana_Drain") and not string.match(selfPlayer.CurrentActionName, "Chain_Lightning") then --and (selfPlayer.BlackRage < 100 or Magician.MonsterCount() >= 3)
						print("Casting Lightning")
						selfPlayer:SetActionStateAtPosition(self.S | self.F, monsterPosition, 500)
						return
					end
					
					local Residual_Lightning = SkillsHelper.GetKnownSkillId(Magician.RESIDUAL_LIGHTNING_ID)
					if self:SkillReady(Residual_Lightning) and string.match(selfPlayer.CurrentActionName, "Lightning") and selfPlayer.ManaPercent >= 10 then
						print("Lightning has been cast: Using Residual Lightning")
						selfPlayer:SetActionStateAtPosition(self.RMB, monsterPosition, 2000)
						return
					end
					
					local Fireball = SkillsHelper.GetKnownSkillId(Magician.FIREBALL_ID)
					if self:SkillReady(Fireball) and selfPlayer.ManaPercent > 10 and not string.match(selfPlayer.CurrentActionName, "Lightning") and not string.match(selfPlayer.CurrentActionName, "Mana_Drain") then
						if monsterPosition.Distance3DFromMe > monster.BodySize + 900 then
							Navigator.Stop()
							print("Casting Fireball")
							selfPlayer:SetActionStateAtPosition(self.S | self.LMB, monsterPosition, 1500)
						else
							Navigator.Stop()
							selfPlayer:SetActionStateAtPosition(self.S | self.LMB, monsterPosition, 2000)
							if string.match(selfPlayer.CurrentActionName, "Fireball_Cast_") then
								print("Mob close range: Casting quick fireball")
								selfPlayer:SetActionStateAtPosition(self.RMB, monsterPosition, 2000)
							end
						end
						return
					end

					local Fireball_Explosion = SkillsHelper.GetKnownSkillId(Magician.FIREBALL_EXPLOSION_ID)
					if selfPlayer:HasBuffById(1001) and self:SkillReady(Fireball_Explosion) and string.match(selfPlayer.CurrentActionName, "Fireball") then
						print("Casting Fireball Explosion following Fireball")
						selfPlayer:SetActionStateAtPosition(self.RMB, monsterPosition, 1000)
						return
					end
					
					local Multiple_Magic_Arrow = SkillsHelper.GetKnownSkillId(Magician.MULTIPLE_MAGIC_ARROWS_ID)
					if self:SkillReady(Multiple_Magic_Arrow) and not string.match(selfPlayer.CurrentActionName, "Lightning") and not string.match(selfPlayer.CurrentActionName, "Fireball") and not string.match(selfPlayer.CurrentActionName, "Mana_Drain") then
						print("Firing Multiple Magic Arrows")
						selfPlayer:UseSkillAtPosition(Multiple_Magic_Arrow, monsterPosition, 500)
						return
					end
					
					local Lightning_Storm = SkillsHelper.GetKnownSkillId(Magician.LIGHTNING_STORM_ID)
					if selfPlayer:HasBuffById(1002) and self:SkillReady(Lightning_Storm) and selfPlayer.ManaPercent > 10 then
						print("Using Lightning Storm after Chain Lightning")
						selfPlayer:UseSkillAtPosition(Lightning_Storm, monsterPosition, 1000)
						----selfPlayer:SetActionStateAtPosition(self.LMB | self.RMB, monsterPosition, 1500)
						return
					end
					
					local Lightning_Chain = SkillsHelper.GetKnownSkillId(Magician.LIGHTNING_CHAIN_ID)
					if self:SkillReady(Lightning_Chain) and selfPlayer.ManaPercent >= 30 and not self:SkillReady(Fireball) and not self:SkillReady(Lightning) then
						print("Using Chain Lightning")
						selfPlayer:SetActionStateAtPosition(self.Shift | self.RMB, monsterPosition, 3500)
						return
					end
					
					local Earths_Response = SkillsHelper.GetKnownSkillId(Magician.EARTHS_RESPONSE_ID)
					if Magician.EARTHSRESPONSE and self:SkillReady(Earths_Response) and Magician.MonsterCount() > 2 and monsterPosition.Distance3DFromMe < monster.BodySize + 300 and selfPlayer.HealthPercent < 40 then
						local rnd = math.random(1,2)
						local direction = { self.A, self.D }
						print("Dodge + Earths Response [TESTING]")
						selfPlayer:SetActionStateAtPosition(direction[rnd] | self.LMB, monsterPosition, 500)
						return
					end
					
					local Concentrated_Magic_Arrow = SkillsHelper.GetKnownSkillId(Magician.CONCENTRATED_MAGIC_ARROW_ID)
					if self:SkillReady(Concentrated_Magic_Arrow) and selfPlayer.ManaPercent > 15 then
						print("Concentrated Magic Arrow Firing")
						selfPlayer:SetActionStateAtPosition(self.LMB | self.RMB, monsterPosition, 1000)
						return
					end
					
					local Magic_Arrow = SkillsHelper.GetKnownSkillId(Magician.MAGIC_ARROW_ID)
					if self:SkillReady(Magic_Arrow) then
						selfPlayer:SetActionStateAtPosition(self.RMB, monsterPosition, 100)
						print("Using Magic Arrow")
						return
					end
					
					local Dagger_Stab = SkillsHelper.GetKnownSkillId(Magician.DAGGER_STAB_ID)
					if self:SkillReady(Dagger_Stab) and monsterPosition.Distance3DFromMe < monster.BodySize + 150 then
						print("Dagger Stab mob in melee")
						selfPlayer:SetActionStateAtPosition(self.F, monsterPosition)
						return
					end
				end
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------
return Magician()