CombatSorcerer = { }
CombatSorcerer.__index = CombatSorcerer

CombatSorcerer.ABSOLUTE_DARKNESS_ID = { 1432, 1431, 1430 }
CombatSorcerer.ABYSSAL_FLAME_ID = { 1200, 1199, 1054 }
CombatSorcerer.BEAT_KICK_ID = { 168, 167 }
CombatSorcerer.BLACK_WAVE_ID = { 588, 587, 586, 585 }
CombatSorcerer.BLOODY_CALAMITY_ID = { 348 }
CombatSorcerer.BLOODY_CONTRACT_ID = { 1415, 1414 }
CombatSorcerer.CLAWS_OF_DARKNESS_ID = { 583, 1203, 1202, 1056 }
CombatSorcerer.CROW_FLARE_ID = { 166, 165, 164 }
CombatSorcerer.CROW_FOOD_ID = { 170 }
CombatSorcerer.DARK_AFFINITY_ID = { 83, 82, 81, 80, 79, 78, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 67, 66, 65, 64 }
CombatSorcerer.DARK_ARMOR_ID = { 53, 52, 51, 50, 49, 48, 47, 46, 45, 44 }
CombatSorcerer.DARK_BACKSTEP_ID = { 163 }
CombatSorcerer.DARK_FLAME_ID = { 1205, 1204 }
CombatSorcerer.DARK_MANEUVER_ID = { 63, 62, 61, 60, 59, 58, 57, 56, 55, 54 }
CombatSorcerer.DARK_SPLIT_ID = { 120, 119, 118, 117, 116, 115, 114, 1206, 1059 }
CombatSorcerer.DARK_TRADE_ID = { 161, 160, 1210 }
CombatSorcerer.DARKNESS_RELEASED_ID = { 1362, 1361, 1360, 1359 }
CombatSorcerer.DREAM_OF_DOOM_ID = { 93, 1195, 1052 }
CombatSorcerer.ERUPTION_OF_GUILT_ID = { 584 }
CombatSorcerer.FLOW_OF_DARKNESS_ID = { 1413, 1411 }
CombatSorcerer.GUILTY_CONSCIENCE_ID = { 172 }
CombatSorcerer.HIGH_KICK_ID = { 1412 }
CombatSorcerer.IMMINENT_DOOM_ID = { 1209 }
CombatSorcerer.LOW_KICK_ID = { 1182, 1047 }
CombatSorcerer.MARK_OF_THE_SHADOW_ID = { 1194, 1193, 1192, 1191, 1051 }
CombatSorcerer.MIDNIGHT_STINGER_ID = { 171, 380 }
CombatSorcerer.NIGHT_CROW_ID = { 1201, 1055 }
CombatSorcerer.REBOUNDING_DARKNESS_ID = { 162 }
CombatSorcerer.RUSHING_CROW_ID = { 1418, 1417 }
CombatSorcerer.SCATTERING_SHADOW_ID = { 169 }
CombatSorcerer.SHADOW_ERUPTION_ID = { 1190, 1189, 1188, 1050 }
CombatSorcerer.SHADOW_KICK_ID =  { 199 }
CombatSorcerer.SHADOW_RIOT_ID = { 200 }
CombatSorcerer.SHARD_EXPLOSION_ID = { 1356 }
CombatSorcerer.SHARDS_OF_DARKNESS_ID = { 1184, 1183, 1048 }
CombatSorcerer.SHARP_NAILS_ID = { 1208, 1061 }
CombatSorcerer.SHIELD_OF_DARKNESS_ID = { 312, 311, 310 }
CombatSorcerer.SIGNS_OF_AGONY_ID = { 1187, 1186, 1185, 1049 }
CombatSorcerer.SINISTER_ENERGY_ID = { 581, 1198, 1197, 1196, 1053 }
CombatSorcerer.SINISTER_OMEN_ID = { 347 }
CombatSorcerer.SINISTER_SHADOW_ID = { 1355, 1354, 1353 }
CombatSorcerer.SPIRIT_ABSORBSION_ID = { 1358, 1357 }
CombatSorcerer.STORMING_CROW_ID = { 582, 1060 }
CombatSorcerer.ULTIMATE_CROW_FLARE_ID = { 95 }
CombatSorcerer.ULTIMATE_DARK_FLAME_ID = { 94 }
CombatSorcerer.ULTIMATE_MIDNIGHT_STINGER_ID = { 378 }
CombatSorcerer.ULTIMATE_NIGHT_CROW_ID = { 379 }
CombatSorcerer.ULTIMATE_SHADOW_ERUPTION_ID = { 1500 }

setmetatable(CombatSorcerer, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function CombatSorcerer.new()
  local instance = {}
  local self = setmetatable(instance, CombatSorcerer)
  self.DarkwaveStep = 0
  return self
end

function CombatSorcerer:GetMonsterCount()
    local monsters = GetMonsters()
    local monsterCount = 0
    for k, v in pairs(monsters) do
        if v.IsAggro then
            monsterCount = monsterCount + 1
        end
    end
    return monsterCount
end

function CombatSorcerer:Attack(monsterActor)

    local ABSOLUTE_DARKNESS = SkillsHelper.GetKnownSkillId(CombatSorcerer.ABSOLUTE_DARKNESS_ID)
    local ABYSSAL_FLAME = SkillsHelper.GetKnownSkillId(CombatSorcerer.ABYSSAL_FLAME_ID)
    local BEAT_KICK = SkillsHelper.GetKnownSkillId(CombatSorcerer.BEAT_KICK_ID)
    local BLACK_WAVE = SkillsHelper.GetKnownSkillId(CombatSorcerer.BLACK_WAVE_ID)
    local BLOODY_CALAMITY = SkillsHelper.GetKnownSkillId(CombatSorcerer.BLOODY_CALAMITY_ID)
    local BLOODY_CONTRACT = SkillsHelper.GetKnownSkillId(CombatSorcerer.BLOODY_CONTRACT_ID)
    local CLAWS_OF_DARKNESS = SkillsHelper.GetKnownSkillId(CombatSorcerer.CLAWS_OF_DARKNESS_ID)
    local CROW_FLARE = SkillsHelper.GetKnownSkillId(CombatSorcerer.CROW_FLARE_ID)
    local CROW_FOOD = SkillsHelper.GetKnownSkillId(CombatSorcerer.CROW_FOOD_ID)
    local DARK_AFFINITY = SkillsHelper.GetKnownSkillId(CombatSorcerer.BLACK_WAVE_ID)
    local DARK_ARMOR = SkillsHelper.GetKnownSkillId(CombatSorcerer.DARK_ARMOR_ID)
    local DARK_BACKSTEP = SkillsHelper.GetKnownSkillId(CombatSorcerer.DARK_BACKSTEP_ID)
    local DARK_FLAME = SkillsHelper.GetKnownSkillId(CombatSorcerer.DARK_FLAME_ID)
    local DARK_MANEUVER = SkillsHelper.GetKnownSkillId(CombatSorcerer.DARK_MANEUVER_ID)
    local DARK_SPLIT = SkillsHelper.GetKnownSkillId(CombatSorcerer.DARK_SPLIT_ID)
    local DARK_TRADE = SkillsHelper.GetKnownSkillId(CombatSorcerer.DARK_TRADE_ID)
    local DARKNESS_RELEASED = SkillsHelper.GetKnownSkillId(CombatSorcerer.DARKNESS_RELEASED_ID)
    local DREAM_OF_DOOM = SkillsHelper.GetKnownSkillId(CombatSorcerer.DREAM_OF_DOOM_ID)
    local ERUPTION_OF_GUILT = SkillsHelper.GetKnownSkillId(CombatSorcerer.ERUPTION_OF_GUILT_ID)
    local FLOW_OF_DARKNESS = SkillsHelper.GetKnownSkillId(CombatSorcerer.FLOW_OF_DARKNESS_ID)
    local GUILTY_CONSCIENCE = SkillsHelper.GetKnownSkillId(CombatSorcerer.GUILTY_CONSCIENCE_ID)
    local HIGH_KICK = SkillsHelper.GetKnownSkillId(CombatSorcerer.HIGH_KICK_ID)
    local IMMINENT_DOOM = SkillsHelper.GetKnownSkillId(CombatSorcerer.IMMINENT_DOOM_ID)
    local LOW_KICK = SkillsHelper.GetKnownSkillId(CombatSorcerer.LOW_KICK_ID)
    local MARK_OF_THE_SHADOW = SkillsHelper.GetKnownSkillId(CombatSorcerer.MARK_OF_THE_SHADOW_ID)
    local MIDNIGHT_STINGER = SkillsHelper.GetKnownSkillId(CombatSorcerer.MIDNIGHT_STINGER_ID)
    local NIGHT_CROW = SkillsHelper.GetKnownSkillId(CombatSorcerer.NIGHT_CROW_ID)
    local REBOUNDING_DARKNESS = SkillsHelper.GetKnownSkillId(CombatSorcerer.REBOUNDING_DARKNESS_ID)
    local RUSHING_CROW = SkillsHelper.GetKnownSkillId(CombatSorcerer.RUSHING_CROW_ID)
    local SCATTERING_SHADOW = SkillsHelper.GetKnownSkillId(CombatSorcerer.SCATTERING_SHADOW_ID)
    local SHADOW_ERUPTION = SkillsHelper.GetKnownSkillId(CombatSorcerer.SHADOW_ERUPTION_ID)
    local SHADOW_KICK = SkillsHelper.GetKnownSkillId(CombatSorcerer.SHADOW_KICK_ID)
    local SHADOW_RIOT = SkillsHelper.GetKnownSkillId(CombatSorcerer.SHADOW_RIOT_ID)
    local SHARD_EXPLOSION = SkillsHelper.GetKnownSkillId(CombatSorcerer.SHARD_EXPLOSION_ID)
    local SHARDS_OF_DARKNESS = SkillsHelper.GetKnownSkillId(CombatSorcerer.SHARDS_OF_DARKNESS_ID)
    local SHARP_NAILS = SkillsHelper.GetKnownSkillId(CombatSorcerer.SHARP_NAILS_ID)
    local SHIELD_OF_DARKNESS = SkillsHelper.GetKnownSkillId(CombatSorcerer.SHIELD_OF_DARKNESS_ID)
    local SIGNS_OF_AGONY = SkillsHelper.GetKnownSkillId(CombatSorcerer.SIGNS_OF_AGONY_ID)
    local SINISTER_ENERGY = SkillsHelper.GetKnownSkillId(CombatSorcerer.SINISTER_ENERGY_ID)
    local SINISTER_OMEN = SkillsHelper.GetKnownSkillId(CombatSorcerer.SINISTER_OMEN_ID)
    local SINISTER_SHADOW = SkillsHelper.GetKnownSkillId(CombatSorcerer.SINISTER_SHADOW_ID)
    local STORMING_CROW = SkillsHelper.GetKnownSkillId(CombatSorcerer.STORMING_CROW_ID)
    local ULTIMATE_CROW_FLARE = SkillsHelper.GetKnownSkillId(CombatSorcerer.ULTIMATE_CROW_FLARE_ID)
    local ULTIMATE_DARK_FLAME = SkillsHelper.GetKnownSkillId(CombatSorcerer.ULTIMATE_DARK_FLAME_ID)
    local ULTIMATE_MIDNIGHT_STINGER = SkillsHelper.GetKnownSkillId(CombatSorcerer.ULTIMATE_MIDNIGHT_STINGER_ID)
    local ULTIMATE_NIGHT_CROW = SkillsHelper.GetKnownSkillId(CombatSorcerer.ULTIMATE_NIGHT_CROW_ID)
    local ULTIMATE_SHADOW_ERUPTION = SkillsHelper.GetKnownSkillId(CombatSorcerer.ULTIMATE_SHADOW_ERUPTION_ID)

    if monsterActor then
        local selfPlayer = GetSelfPlayer()
        local actorPosition = monsterActor.Position
            
        if not selfPlayer.IsActionPending then
            --Buff Shield
                if SHIELD_OF_DARKNESS ~= 0 and not string.match(selfPlayer.CurrentActionName, "DARKWAVE") and not selfPlayer:IsSkillOnCooldown(SHIELD_OF_DARKNESS) then
                    print("SHIELD_OF_DARKNESS")
                    selfPlayer:SetActionState(ACTION_FLAG_EVASION | ACTION_FLAG_SPECIAL_ACTION_1)
                    return
                end
            --Buff Damage and Mana management
                if SHARDS_OF_DARKNESS ~= 0 and not selfPlayer:HasBuffById(26998) and not string.match(selfPlayer.CurrentActionName, "DARKWAVE") and
                    SHARDS_OF_DARKNESS == 1048 and selfPlayer.SubResourcePoint > 9 or 
                     SHARDS_OF_DARKNESS == 1183 and selfPlayer.SubResourcePoint > 19 or
                      SHARDS_OF_DARKNESS == 1184 and selfPlayer.SubResourcePoint > 29 and
                       selfPlayer.MaxMana - selfPlayer.Mana > selfPlayer.SubResourcePoint/10*40 then
                    print("Shard Of Darkness")
                    selfPlayer:SetActionState(ACTION_FLAG_SPECIAL_ACTION_1)
                    return
                end
                
            if actorPosition.Distance3DFromMe > monsterActor.BodySize + 150 then
            --GapClose Rushing Crow
                if RUSHING_CROW ~= 0 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 700 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 300 and
                    not selfPlayer:IsSkillOnCooldown(RUSHING_CROW) then
                    print("GapClose Rushing Crow")
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_EVASION | ACTION_FLAG_MOVE_FORWARD | ACTION_FLAG_SECONDARY_ATTACK, actorPosition)
            --Night Crow = Buff move speed
                elseif NIGHT_CROW ~= 0 and not selfPlayer:HasBuffById(22530) and selfPlayer:IsSkillOnCooldown(RUSHING_CROW) and selfPlayer.Stamina > 200 and
                    actorPosition.Distance3DFromMe <= monsterActor.BodySize + 700 and actorPosition.Distance3DFromMe >= monsterActor.BodySize + 300 then
                    print('GapClose Night Crow, Rushing Crow on Cooldown')
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_JUMP | ACTION_FLAG_EVASION | ACTION_FLAG_MOVE_FORWARD, actorPosition)
                    return
                end

                Navigator.MoveTo(actorPosition)
            else
                
                Navigator.Stop()

            --Sinister Shadow = Buff Range Critical hit Random Left or Right
                if SINISTER_SHADOW ~= 0 and not string.match(selfPlayer.CurrentActionName, "DARKWAVE") and not string.match(selfPlayer.CurrentActionName, "DARKWAVE") and not selfPlayer:HasBuffById(23034) then
                    if actorPosition.Distance3DFromMe <= monsterActor.BodySize + 700 and actorPosition.Distance3DFromMe > monsterActor.BodySize + 300 then
                        print("Buff Crit Range")
                        if math.random(1, 2) == 1 then
                            selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_MOVE_LEFT, actorPosition)
                        else
                            selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_MOVE_RIGHT,actorPosition)
                            return
                        end
            --Midnight Stinger = Buff Melee Critical Hit
                   elseif MIDNIGHT_STINGER ~= 0 and not string.match(selfPlayer.CurrentActionName, "DARKWAVE") and not string.match(selfPlayer.CurrentActionName, "DARKWAVE") and not selfPlayer:IsSkillOnCooldown(MIDNIGHT_STINGER) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 300 then
                        print("Buff Crit Melee!")
                        selfPlayer:SetActionStateAtPosition(ACTION_FLAG_EVASION | ACTION_FLAG_MAIN_ATTACK, actorPosition)
                        return
                    end
                end
                
            --Flow Of Darkness = Buff Melee Evasion
                if FLOW_OF_DARKNESS ~= 0 and not string.match(selfPlayer.CurrentActionName, "DARKWAVE") and not selfPlayer:HasBuffById(27550) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 and selfPlayer.Stamina > 200 then
                    local rnd = math.random(1, 2)
                    print("Buff Evasion Melee")
                    if math.random(1, 2) == 1 then
                        selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_MOVE_LEFT, actorPosition)
                    else
                        selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_MOVE_RIGHT,actorPosition)
                        return
                    end
                end
            --Black Wave                          
                if BLACK_WAVE ~= 0 and (not selfPlayer:IsSkillOnCooldown(BLACK_WAVE) or string.match(selfPlayer.CurrentActionName, "DARKWAVE")) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 550 then
                    if string.match(selfPlayer.CurrentActionName, "PowerShot") or (string.match(selfPlayer.CurrentActionName, "DARKWAVE") and not string.match(selfPlayer.CurrentActionName, "END")) then
                        print("Black wave")
                        selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SECONDARY_ATTACK | ACTION_FLAG_MAIN_ATTACK, actorPosition, 500)
                        return
                    end
                end
                
                if BLACK_WAVE ~= 0 and not selfPlayer:IsSkillOnCooldown(BLACK_WAVE) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 550 then
                    print("POWERSHOT")
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_SECONDARY_ATTACK, actorPosition, 200)
                    return
                end  
           --Crow Flare and Beat kick
                if BEAT_KICK ~= 0 and not selfPlayer:IsSkillOnCooldown(BEAT_KICK) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 then
                    if string.match(selfPlayer.CurrentActionName, "CrowFlame") then
                        print("Beat Kick") 
                        selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SPECIAL_ACTION_3,actorPosition)
                        return
                    end
                end
                if CROW_FLARE ~= 0 and not selfPlayer:IsSkillOnCooldown(BEAT_KICK) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 then
                    print("Crow Flare")
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SPECIAL_ACTION_2,actorPosition)
                    return 
                end
            --((COMING SOON))NightCrow with Storming Crow back to slow
                --[[if NIGHT_CROW ~= 0 and STORMING_CROW ~= 0 and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 500 and selfPlayer.Stamina > 200 then
                print("AAAAAAAAAAA")
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_FORWARD, actorPosition)
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_FORWARD, actorPosition)
                end]]
            --NightCrow with Abyssal flame
                if NIGHT_CROW ~= 0 and ABYSSAL_FLAME ~= 0 and not selfPlayer:IsSkillOnCooldown(ABYSSAL_FLAME) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 and selfPlayer.Stamina > 200 then
                    if string.match(selfPlayer.CurrentActionName, "EvadeBurster") then
                        print("Abyssal Flame") 
                        selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK,actorPosition)
                        return
                    end
                end
                
                if NIGHT_CROW ~= 0 and ABYSSAL_FLAME ~= 0 and not selfPlayer:IsSkillOnCooldown(ABYSSAL_FLAME) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 and selfPlayer.Stamina > 200 then
                    print("Night Crow")
                    selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_EVASION)
                end
            --Low Kick with High Kick Combo ((NOT SHADOW_KICK OR SCATTERING_SHADOW))
                if LOW_KICK ~= 0 and HIGH_KICK ~= 0 and (not selfPlayer:IsSkillOnCooldown(LOW_KICK) or string.match(selfPlayer.CurrentActionName, "LowKick")) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 then
                    if string.match(selfPlayer.CurrentActionName, "LowKick") then
                        print("High Kick") 
                        selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SPECIAL_ACTION_3,actorPosition)
                        return
                    end
                end
                if LOW_KICK ~= 0 and HIGH_KICK ~= 0 and not selfPlayer:IsSkillOnCooldown(LOW_KICK) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 then
                    print("Low kick")
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_SPECIAL_ACTION_3,actorPosition)
                end
            --Claws of darkness or autoattack if low mana
                 if CLAWS_OF_DARKNESS ~= 0 and DARK_FLAME ~= 0 and (not selfPlayer:IsSkillOnCooldown(DARK_FLAME) or string.match(selfPlayer.CurrentActionName, "DarkHit_B3")) and actorPosition.Distance3DFromMe <= monsterActor.BodySize + 200 then
                    if string.match(selfPlayer.CurrentActionName, "DarkHit_B3") then
                        print("Dark Flame") 
                        selfPlayer:SetActionState(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK | ACTION_FLAG_SECONDARY_ATTACK)
                        return
                    end
                end
                if CLAWS_OF_DARKNESS ~= 0 and selfPlayer.ManaPercent > 25 then
                    print("Claws of Darkness")
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MOVE_BACKWARD | ACTION_FLAG_MAIN_ATTACK, actorPosition)
                    return
                else
                    print("Autoattack mana low")
                    selfPlayer:SetActionStateAtPosition(ACTION_FLAG_MAIN_ATTACK, actorPosition)
                    return
                end
            end
        end
    end
end

return CombatSorcerer()
