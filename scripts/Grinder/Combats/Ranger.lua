CombatRanger = { }
CombatRanger.__index = CombatRanger

CombatRanger.ABILITY_BOW_SKILL_IDS = { 98, 98, 99, 100, 101, 1002, 1086, 1211, 1332, 1333 }
CombatRanger.ABILITY_DAGGER_OF_PROTECTION_IDS = { 307, 308, 309 }
CombatRanger.ABILITY_CHARGING_WIND_IDS = { 1006, 1091, 1092, 1093 }
CombatRanger.ABILITY_ROUND_KICK_IDS = { 1003, 1029, 1087, 1119, 1250, 1252, 1251 }
CombatRanger.ABILITY_BLASTING_GUST_IDS = { 1126, 1125, 1077 }
CombatRanger.ABILITY_EVASIVE_EXLPOSION_SHOT_IDS = { 1257, 1116, 1016 }
CombatRanger.ABILITY_PINPOINT_IDS = { 322, 323, 324 }
CombatRanger.ABILITY_EVASIVE_SHOT_IDS = { 1012, 1107, 1253 }
CombatRanger.DaggerMode = 1


setmetatable(CombatRanger, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function CombatRanger.new()
    local self = setmetatable( { }, CombatRanger)
    self.Mode = 0
    self.ModeTimer = nil
    self.CombatTimer = nil
--    self.ability_ChargingWind = {spellIds = { 1006, 1091, 1092, 1093 }, flags = ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_EVASION }
--    self.ability_Pinpoint = {spellIds = { 322, 323, 324 }, flags = ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_MOVE_BACKWARD, animationTime = 500 }

    return self
end


function CombatRanger:Attack(monsterActor, isPulling)
    local ABILITY_BOW_SKILL_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_BOW_SKILL_IDS)
    local ABILITY_DAGGER_OF_PROTECTION_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_DAGGER_OF_PROTECTION_IDS)
    local ABILITY_CHARGING_WIND_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_CHARGING_WIND_IDS)
    local ABILITY_ROUND_KICK_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_ROUND_KICK_IDS)
    local ABILITY_BLASTING_GUST_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_BLASTING_GUST_IDS)
    local ABILITY_EVASIVE_EXLPOSION_SHOT_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_EVASIVE_EXLPOSION_SHOT_IDS)
    local ABILITY_PINPOINT_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_PINPOINT_IDS)
    local ABILITY_EVASIVE_SHOT_ID = SkillsHelper.GetKnownSkillId(CombatRanger.ABILITY_EVASIVE_SHOT_IDS)

    local selfPlayer = GetSelfPlayer()

    if monsterActor and selfPlayer then
        local actorPosition = monsterActor.Position

        if self.CombatTimer == nil or self.CombatTimer:Expired() then
            self.CombatTimer = PyxTimer:New(3)
            self.CombatTimer:Start()
            self.Mode = 0
        end

        if self.Mode == 10 and self.ModeTimer ~= nil and self.ModeTimer:Expired() then
            print("Mode 10 Timer Expired")
            self.Mode = 0
        end


        if selfPlayer:CheckCurrentAction("BT_skill_WindblowShot_Ing") then
            print("Launch Windblow!")
            if ABILITY_BLASTING_GUST_ID == 1077 then
                selfPlayer:DoActionAtPosition("BT_skill_WindblowShot_Fire", actorPositio)
            elseif ABILITY_BLASTING_GUST_ID == 1125 then
                selfPlayer:DoActionAtPosition("BT_skill_WindblowShot_Fire_UP", actorPosition)
            else
                selfPlayer:DoActionAtPosition("BT_skill_WindblowShot_Fire_UP2", actorPosition)
            end
            self.Mode = 0
            return
        end



        if actorPosition.Distance3DFromMe > monsterActor.BodySize + 1700 then
            self.Mode = 0
            Navigator.MoveTo(actorPosition)
        else
            Navigator.Stop()



            if selfPlayer.IsActionPending then
                return
            end


            if self.Mode == 10 then
                print("Launch JumpShot!")
                self.Mode = 0
    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK,actorPosition)

--                selfPlayer:DoActionAtPosition("BT_Attack_JumpShot_Faster", actorPosition, 1000)
--                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK,actorPosition,1000)
                self.CombatTimer:Reset()
                return
            end


            if actorPosition.Distance3DFromMe <= monsterActor.BodySize + 450 and
                ABILITY_EVASIVE_EXLPOSION_SHOT_ID ~= 0 and
                SkillsHelper.IsSkillUsable(ABILITY_EVASIVE_EXLPOSION_SHOT_ID) and
                not selfPlayer:IsSkillOnCooldown(ABILITY_EVASIVE_EXLPOSION_SHOT_ID)
            then
                print("Evasive Explosion Shot!")
--                local directions = { "", "_L", "_R" }
                local rnd = math.random(1, 3)
                if rnd == 1 then
                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_MOVE_BACKWARD,actorPosition,600)
                elseif rnd == 2 then
                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_MOVE_LEFT,actorPosition,600)
                else
                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_MOVE_RIGHT,actorPosition,600)
                end


--[[
                local skillUp = ""
                if ABILITY_EVASIVE_EXLPOSION_SHOT_ID == 1116 then
                    skillUp = "_UP"
                elseif ABILITY_EVASIVE_EXLPOSION_SHOT_ID == 1257 then
                    skillUp = "_UP2"
                end
                selfPlayer:DoActionAtPosition("BT_skill_TurnArrow" .. directions[rnd] .. skillUp, actorPosition, 600)
                --]]
                self.Mode = 10
                self.ModeTimer = PyxTimer:New(2)
                self.ModeTimer:Start()
                self.CombatTimer:Reset()

                return

            end


            -- Range stuff
            --[[
			if actorPosition.Distance3DFromMe < monsterActor.BodySize + 1000 and
			selfPlayer.Mana >= 40 and ABILITY_BLASTING_GUST_ID ~= 0 and
			SkillsHelper.IsSkillUsable(ABILITY_BLASTING_GUST_ID) and
			not selfPlayer:IsSkillOnCooldown(ABILITY_BLASTING_GUST_ID)
			then
				selfPlayer:UseSkillAtPosition(ABILITY_BLASTING_GUST_ID,actorPosition, 2000)
			end
            --]]


            self.Mode = self.Mode + 1

            if self.Mode > 4 then
                self.Mode = 1
            end

            if self.Mode == 1 and ABILITY_PINPOINT_ID ~= 0 and
                not selfPlayer:IsSkillOnCooldown(ABILITY_PINPOINT_ID)
                and SkillsHelper.IsSkillUsable(ABILITY_PINPOINT_ID)
            then
                print("Using PinPoint")
--                local ability = "BT_skill_Weakpoint"
                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_MOVE_BACKWARD,actorPosition,800)
                self.CombatTimer:Reset()
                return
            end

            if self.Mode == 2 and actorPosition.Distance3DFromMe > monsterActor.BodySize + 400 and
                ABILITY_CHARGING_WIND_ID ~= 0 and
                not selfPlayer:IsSkillOnCooldown(ABILITY_CHARGING_WIND_ID) and selfPlayer.ManaPercent > 30
                and SkillsHelper.IsSkillUsable(ABILITY_CHARGING_WIND_ID)
            then
                print("Using ChargeWind")
                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_EVASION,actorPosition,1000)
                self.CombatTimer:Reset()
                return

            end

            if self.Mode == 3 and actorPosition.Distance3DFromMe < monsterActor.BodySize + 1200 and ABILITY_EVASIVE_SHOT_ID ~= 0 and
                not selfPlayer:IsSkillOnCooldown(ABILITY_EVASIVE_SHOT_ID)
                and SkillsHelper.IsSkillUsable(ABILITY_EVASIVE_SHOT_ID)
            then
                print("Using Evasive Shot: " .. ABILITY_EVASIVE_SHOT_ID)
                local rnd = math.random(1, 2)
                if rnd == 1 then
                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_MOVE_LEFT,actorPosition)
                else
                selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_MOVE_RIGHT,actorPosition)
                end
                self.CombatTimer:Reset()
                return
            end

            --[[
            if self.Mode == 4 and actorPosition.Distance3DFromMe < monsterActor.BodySize + 1400 and
                ABILITY_BLASTING_GUST_ID ~= 0 and
                SkillsHelper.IsSkillUsable(ABILITY_BLASTING_GUST_ID) and
                not selfPlayer:IsSkillOnCooldown(ABILITY_BLASTING_GUST_ID)

            then
                selfPlayer:UseSkillAtPosition(ABILITY_BLASTING_GUST_ID, actorPosition, 2000)
                return
            end
            --]]
--            print("Auto Attack")
--            selfPlayer:Interact(monsterActor)

            -- Auto attack for the win !
    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK,actorPosition)
            self.CombatTimer:Reset()
               return
        end

    end

end


return CombatRanger()

