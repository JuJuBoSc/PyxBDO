VitalicTamer = { }
VitalicTamer.__index = VitalicTamer
VitalicTamer.Author = "Vitalic"
VitalicTamer.Version = "1.0"

------------------------- SKILL ID'S -------------------------------------------------------------------------

VitalicTamer.ABSORB_HEILANG = { 231, 230, 229, 36, 35, 34 }
VitalicTamer.BOLT_WAVE = { 18, 14, 13, 12, 11 }
VitalicTamer.CHANCE_MAKER = { 33, 32, 31 }
VitalicTamer.COMMAND_ATTACK = { 242 }
VitalicTamer.COMMAND_FOLLOW = { 233 }
VitalicTamer.COMMAND_STAY = { 232 }
VitalicTamer.EVASION = { 363, 362, 1062 }
VitalicTamer.EVASIVE_ATTACK = { 1221, 1220, 1065 }
VitalicTamer.FLASH = { 1226, 1225, 1224, 1067 }
VitalicTamer.FLASH_POLE_THRUST = { 87, 86, 85 }
VitalicTamer.FLASH_STANCE_SHIFT = { 42, 41 }
VitalicTamer.FLOWING_WATER = { 228, 84 }
VitalicTamer.FLURRY_OF_KICKS = { 1219, 1218, 1217, 1064 }
VitalicTamer.HEILANG_FEARFUL_TREMBLING = { 1076, 239, 238, 237, 236, 235 }
VitalicTamer.HEILANG_EARTHQUAKE = { 1240, 1239, 1238, 1237, 1072 }
VitalicTamer.HEILANG_LIGHTNING_OF_EARTH = { 1311, 1310, 1309, 1308 }
VitalicTamer.HELIANG_ROARING = { 1245, 1244, 1243, 1242, 1241, 1073 }
VitalicTamer.HEILANG_SCRATCH = { 1234, 1233, 1232, 1070 }
VitalicTamer.HEILANG_SURGING_TIDE = { 1295, 1249, 1248, 1247, 1246, 1074 }
VitalicTamer.HEILANG_THROAT_BURN = { 1236, 1235, 1071 }
VitalicTamer.HEILANG_TRAMPLE = { 1231, 1230, 1069 }
VitalicTamer.HEILANG_UPWARD_CLAW = { 212, 211, 210, 209, 208 }
VitalicTamer.HEILANG_WHIPLASH = { 205, 132, 130, 129 }
VitalicTamer.JOLT_WAVE = { 19, 17, 16, 15 }
VitalicTamer.LEAF_SLASH = { 128, 126, 125, 124, 123, 127, 122, 1216, 1215, 1063 }
VitalicTamer.SHARPENING_CLAWS = { 361, 360, 359, 358 }
VitalicTamer.SOARING_KICK = { 135, 134, 133 }
VitalicTamer.SPRING_OF_PROTECTION = { 1307, 1306, 1305 }
VitalicTamer.SPRING_OF_STAMINA = { 1304, 1303, 1302, 1301 }
VitalicTamer.STRETCH_KICK = { 241, 240 }
VitalicTamer.SUMMON_HEILANG = { 1346, 1344, 1343, 1342, 1341, 1345, 1340, 1339, 1338, 1075, 1347 }
VitalicTamer.TREE_CLIMB = { 1223, 1222, 1066 }
VitalicTamer.VOID_LIGHTNING = { 1229, 1228, 1227, 1068 }

---------------------------------------------------------------------------------------------------------------

setmetatable(VitalicTamer, {
	__call = function (cls, ...)
	return cls.new(...)
end,
})

-----------------------------------------------------------------------------------------------------------------

function VitalicTamer.new()
	local instance = {}
	local self = setmetatable(instance, VitalicTamer)

	self.SummonPetInitial = false
	self.SummonPetTimer = PyxTimer:New(600)

	return self
end

-----------------------------------------------------------------------------------------------------------------

function VitalicTamer:Roaming()
	local selfPlayer = GetSelfPlayer()
	
	if not selfPlayer then
		return
	end

end

--------------------------------------------------------------------------------------------------------------------

function VitalicTamer:Attack(monsterActor)
	
-------------------- Local Spell ID's --------------------------------------------------------

	local ABSORB_HEILANG = SkillsHelper.GetKnownSkillId(VitalicTamer.ABSORB_HEILANG)
	local BOLT_WAVE = SkillsHelper.GetKnownSkillId(VitalicTamer.BOLT_WAVE)
	local CHANCE_MAKER = SkillsHelper.GetKnownSkillId(VitalicTamer.CHANCE_MAKER)
	local COMMAND_ATTACK = SkillsHelper.GetKnownSkillId(VitalicTamer.COMMAND_ATTACK)
	local COMMAND_FOLLOW = SkillsHelper.GetKnownSkillId(VitalicTamer.COMMAND_FOLLOW)
	local COMMAND_STAY = SkillsHelper.GetKnownSkillId(VitalicTamer.COMMAND_STAY)
	local EVASION = SkillsHelper.GetKnownSkillId(VitalicTamer.EVASION)
	local EVASIVE_ATTACK = SkillsHelper.GetKnownSkillId(VitalicTamer.EVASIVE_ATTACK)
	local FLASH = SkillsHelper.GetKnownSkillId(VitalicTamer.FLASH)
	local FLASH_POLE_THRUST = SkillsHelper.GetKnownSkillId(VitalicTamer.FLASH_POLE_THRUST)
	local FLASH_STANCE_SHIFT = SkillsHelper.GetKnownSkillId(VitalicTamer.FLASH_STANCE_SHIFT)
	local FLOWING_WATER = SkillsHelper.GetKnownSkillId(VitalicTamer.FLOWING_WATER)
	local FLURRY_OF_KICKS = SkillsHelper.GetKnownSkillId(VitalicTamer.FLURRY_OF_KICKS)
	local HEILANG_FEARFUL_TREMBLING = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_FEARFUL_TREMBLING)
	local HEILANG_EARTHQUAKE = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_EARTHQUAKE)
	local HEILANG_LIGHTNING_OF_EARTH = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_LIGHTNING_OF_EARTH)
	local HELIANG_ROARING = SkillsHelper.GetKnownSkillId(VitalicTamer.HELIANG_ROARING)
	local HEILANG_SCRATCH = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_SCRATCH)
	local HEILANG_SURGING_TIDE = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_SURGING_TIDE)
	local HEILANG_THROAT_BURN = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_THROAT_BURN)
	local HEILANG_TRAMPLE = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_TRAMPLE)
	local HEILANG_UPWARD_CLAW = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_UPWARD_CLAW)
	local HEILANG_WHIPLASH = SkillsHelper.GetKnownSkillId(VitalicTamer.HEILANG_WHIPLASH)
	local JOLT_WAVE = SkillsHelper.GetKnownSkillId(VitalicTamer.JOLT_WAVE)
	local LEAF_SLASH = SkillsHelper.GetKnownSkillId(VitalicTamer.LEAF_SLASH)
	local SHARPENING_CLAWS = SkillsHelper.GetKnownSkillId(VitalicTamer.SHARPENING_CLAWS)
	local SOARING_KICK = SkillsHelper.GetKnownSkillId(VitalicTamer.SOARING_KICK)
	local SPRING_OF_STAMINA = SkillsHelper.GetKnownSkillId(VitalicTamer.SPRING_OF_STAMINA)
	local SPRING_OF_PROTECTION = SkillsHelper.GetKnownSkillId(VitalicTamer.SPRING_OF_PROTECTION)
	local STRETCH_KICK = SkillsHelper.GetKnownSkillId(VitalicTamer.STRETCH_KICK)
	local SUMMON_HEILANG = SkillsHelper.GetKnownSkillId(VitalicTamer.SUMMON_HEILANG)
	local TREE_CLIMB = SkillsHelper.GetKnownSkillId(VitalicTamer.TREE_CLIMB)
	local VOID_LIGHTNING = SkillsHelper.GetKnownSkillId(VitalicTamer.VOID_LIGHTNING)

-----------------------------------------------------------------------------------------------------------------
	local monsters = GetMonsters()
	local monsterCount = 0
	local selfPlayer = GetSelfPlayer()

	if monsterActor then
		local selfPlayer = GetSelfPlayer()
        local actorPosition = monsterActor.Position

        if actorPosition.Distance3DFromMe > monsterActor.BodySize + 150 then
            Navigator.MoveTo(actorPosition)
        else
            Navigator.Stop()

            for k, v in pairs(monsters) do
				if v.IsAggro then
					monsterCount = monsterCount + 1
				end
			end

            if not selfPlayer.IsActionPending then

            ---------------------------------------------- Summon Heilang -----------------------------------------

            	if self.SummonPetInitial == false and not selfPlayer:IsSkillOnCooldown(SUMMON_HEILANG) and SkillsHelper.IsSkillUsable(SUMMON_HEILANG) then
            		print("Starting! Casting Pet!")
            		selfPlayer:UseSkill(SUMMON_HEILANG, 2000)
            		self.SummonPetInitial = true
            		return
            	end

            	if SUMMON_HEILANG ~= 0 and self.SummonPetTimer:Expired() and not selfPlayer:IsSkillOnCooldown(SUMMON_HEILANG) and SkillsHelper.IsSkillUsable(SUMMON_HEILANG) then
            		print("We can summon our fluffy dog!")
            		selfPlayer:UseSkill(SUMMON_HEILANG, 2000)
            		SummonPetTimer:Reset()
            		SummonPetTimer:Start()
            		return
            	end

            -----------------------------------------------------------------------------------------------------------------------------

			---------------------------------------- Void Lightning---------------------------------------
				if VOID_LIGHTNING ~= 0 and selfPlayer.ManaPercent >= 10 and not selfPlayer:IsSkillOnCooldown(VOID_LIGHTNING)
				and SkillsHelper.IsSkillUsable(VOID_LIGHTNING) and monsterCount >= 2 then
					print("Atleast two on me! Casting Void Lightning!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SPECIAL_ACTION_1, actorPosition, 2000)
					return
				end
			-----------------------------------------------------------------------------------------------------------------------------


			-------------------------------------------- Bolt Wave + Jolt Wave Combo ----------------------------------------------------

				if BOLT_WAVE ~= 0 and selfPlayer.Stamina >= 200 and selfPlayer.ManaPercent > 10 and not selfPlayer:IsSkillOnCooldown(HEILANG_TRAMPLE) then
					print("Casting Bolt Wave + Jolt Wave Combo!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_EVASION | ACTION_FLAG_MAIN_ATTACK, actorPosition, 1000)

					if HEILANG_TRAMPLE ~= 0 and not selfPlayer:IsSkillOnCooldown(HEILANG_TRAMPLE) and selfPlayer.ManaPercent > 10 and string.match(selfPlayer.CurrentActionName, "WallBreak") then
						print("Trample!")
						selfPlayer:SetActionStateAtPosition(ACTION_FLAG_JUMP, actorPosition, 1200)
						return
					end
					return
				end

			-------------------------------------------------------------------------------------------------------------------------------

			---------------------------------------------- Upward Claw ---------------------------------------------------------------

				if HEILANG_UPWARD_CLAW  ~= 0 and selfPlayer.ManaPercent > 10 and not selfPlayer:IsSkillOnCooldown(HEILANG_UPWARD_CLAW) then
					print("Casting Upward Claw!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 300)
					return
				end

			----------------------------------------------------------------------------------------------------------------------------

			------------------------------------------------- Surging Tide -------------------------------------------------------------

				if HEILANG_SURGING_TIDE ~= 0 and selfPlayer.ManaPercent > 10 and not selfPlayer:IsSkillOnCooldown(HEILANG_SURGING_TIDE) then
					print("Casting Surging Tide!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_3, actorPosition, 500)
					return
				end

			---------------------------------------------- Whiplash ---------------------------------------------------
				if HEILANG_WHIPLASH ~= 0 and selfPlayer.ManaPercent > 10 and selfPlayer.HealthPercent <= 70 then
					print("Using Whiplash!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 600)
					return
				end

			-----------------------------------------------------------------------------------------------------------------------------

			----------------------------------------  Lightning of Earth ----------------------------------------------------------------
				if HEILANG_LIGHTNING_OF_EARTH ~= 0 and selfPlayer.ManaPercent > 10 then
					print("Lightning of Earth Spam!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_FORWARD | ACTION_FLAG_SECONDARY_ATTACK, actorPosition)
					return
				end

			------------------------------------------------------------------------------------------------------------------------------

			---------------------------------------- Low on Mana? Spam Leaf Slash to Regain! ----------------------------------------------
				if selfPlayer.ManaPercent < 10 then 
					print("Low on Mana! Casting Leaf Slash!")
					selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_FORWARD | ACTION_FLAG_MAIN_ATTACK, actorPosition)
					return
				end

			------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

			end	
		end
	end
end

return VitalicTamer()

