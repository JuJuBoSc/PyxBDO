CombatPullState = { }
CombatPullState.__index = CombatPullState
CombatPullState.Name = "Combat - Pull"

setmetatable(CombatPullState, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function CombatPullState.new()
    local self = setmetatable( { }, CombatPullState)
    self.CurrentCombatActor = { Key = 0 }
    self._pullStarted = nil
    self._newTarget = false
    self.MobIgnoreList = PyxTimedList:New()
    self.Enabled = true
    return self
end

function CombatPullState:Exit()
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        selfPlayer:ClearActionState()
    end
end

function CombatPullState:NeedToRun()
    local selfPlayer = GetSelfPlayer()

    if not selfPlayer or self.Enabled == false then
        return false
    end

    if not selfPlayer.IsAlive or selfPlayer.IsSwimming then
        return false
    end

    local selfPlayerPosition = selfPlayer.Position

    local monsters = GetMonsters()
    table.sort(monsters, function(a, b) return a.Position:GetDistance3D(selfPlayerPosition) < b.Position:GetDistance3D(selfPlayerPosition) end)
    for k, v in pairs(monsters) do
        if v.IsVisible and
            v.IsAlive and
            --v.CharacterStaticStatus.TribeType ~= TRIBE_TYPE_UNTRIBE and
            v.CanAttack and
            not self.MobIgnoreList:Contains(v.Key) and
            v.Position.Distance3DFromMe <= Bot.Settings.Advanced.PullDistance and
            (Bot.MeshDisabled == true or Bot.Settings.Advanced.IgnorePullBetweenHotSpots == false or
            Bot.Settings.Advanced.IgnorePullBetweenHotSpots == true and ProfileEditor.CurrentProfile:IsPositionNearHotspots(v.Position, Bot.Settings.Advanced.HotSpotRadius)) and
            ProfileEditor.CurrentProfile:CanAttackMonster(v) and
            Navigator.CanMoveTo(v.Position) then
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

function CombatPullState:Run()
    if self._pullStarted == nil or self._newTarget == true then
        self._pullStarted = PyxTimer:New(Bot.Settings.Advanced.PullSecondsUntillIgnore)
        self._pullStarted:Start()
    end
    
    local selfPlayer = GetSelfPlayer()
    if selfPlayer and not selfPlayer.IsActionPending and not selfPlayer.IsBattleMode then
        print("Switch to battle mode !")
        selfPlayer:SwitchBattleMode()
    end

    if self._pullStarted:Expired() == true then
        self.MobIgnoreList:Add(self.CurrentCombatActor.Key, 600)
        print("Pull Added :" .. self.CurrentCombatActor.Key .. " to Ignore list")
        return
    end

    Bot.CallCombatAttack(self.CurrentCombatActor, true)
end
