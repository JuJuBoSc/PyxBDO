CombatFightState = { }
CombatFightState.__index = CombatFightState
CombatFightState.Name = "Combat - Fight"

setmetatable(CombatFightState, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function CombatFightState.new()
    local self = setmetatable( { }, CombatFightState)
    self.CurrentCombatActor = { Key = 0 }
    self._newTarget = false
    self._combatStarted = nil
    self._targetHealth = 0

    self.MobIgnoreList = PyxTimedList:New()

    return self
end

function CombatFightState:Exit()
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        selfPlayer:ClearActionState()
    end
end 

function CombatFightState:NeedToRun()

    local selfPlayer = GetSelfPlayer()

    if not selfPlayer then
        return false
    end

    if not selfPlayer.IsAlive or selfPlayer.IsSwimming then
        return false
    end

    local selfPlayerPosition = selfPlayer.Position

    -- Need to do PvP Check
    --[[
    if Bot.Settings.AttackPvpFlagged == true and Helpers.IsSafeZone() == false then
        local players = Bot.GetPlayers(true)
        table.sort(players, function(a, b) return a.Position:GetDistance3D(selfPlayerPosition) < b.Position:GetDistance3D(selfPlayerPosition) end)
        for key, value in pairs(monsters) do
            if value.IsAlive and value.IsPvpEnable and selfPlayer.Key ~= value.Key
            and value.Distance3DFromMe <= value.BodySize + Bot.Settings.Advanced.PvpAttackRadius then
                if value.Key ~= self.CurrentCombatActor.Key then
                    self._newTarget = true
                else
                    self._newTarget = false
                end

                self.CurrentCombatActor = value
                print("Want to Attack Player: "..value.Name.." "..value.CanAttack)
--                return true
            end
        end
    end
    --]]
    local monsters = GetMonsters()
    table.sort(monsters, function(a, b) return a.Position:GetDistance3D(selfPlayerPosition) < b.Position:GetDistance3D(selfPlayerPosition) end)
    for k, v in pairs(monsters) do
        if
            v.IsAlive and
            v.CanAttack and
            v.IsAggro and
            not self.MobIgnoreList:Contains(v.Key) and
            v.Position.Distance3DFromMe <= Bot.Settings.Advanced.CombatMaxDistanceFromMe and
            (Bot.Settings.Advanced.IgnoreInCombatBetweenHotSpots == false or Bot.Settings.Advanced.IgnoreInCombatBetweenHotSpots == true
            and ProfileEditor.CurrentProfile:IsPositionNearHotspots(v.Position, Bot.Settings.Advanced.HotSpotRadius * 2)) and
            (v.Position.Distance3DFromMe < v.BodySize + 200 or v.Position.Distance3DFromMe < v.BodySize + 1400 and v.IsLineOfSight or Navigator.CanMoveTo(v.Position))-- Should be a Pull/combat distance check
        then
            if v.Key ~= self.CurrentCombatActor.Key then
                self._newTarget = true
            else
                self._newTarget = false
            end

            self.CurrentCombatActor = v
            return true
        end
    end

    return false
end

function CombatFightState:Run()
    if self._combatStarted == nil or self._newTarget == true then
        self._combatStarted = PyxTimer:New(Bot.Settings.Advanced.CombatSecondsUntillIgnore)
        self._combatStarted:Start()
        self._targetHealth = self.CurrentCombatActor.Health
    end

    local selfPlayer = GetSelfPlayer()
    if selfPlayer and not selfPlayer.IsActionPending and not selfPlayer.IsBattleMode then
        print("Switch to battle mode !")
        selfPlayer:SwitchBattleMode()
    end

    if self._combatStarted:Expired() == true then
        if self.CurrentCombatActor.Health >= self._targetHealth then
            self.MobIgnoreList:Add(self.CurrentCombatActor.Key, 60)
            print("Combat Added :" .. self.CurrentCombatActor.Key .. " to temp Ignore list")
            print("Start Health :" .. self._targetHealth .. " Current Health :" .. self.CurrentCombatActor.Health)
            return
        end
        self._combatStarted = nil
    end

    Bot.CallCombatAttack(self.CurrentCombatActor, false)
end


