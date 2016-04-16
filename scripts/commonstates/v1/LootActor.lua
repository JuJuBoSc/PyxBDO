LootActorState = { }
LootActorState.__index = LootActorState
LootActorState.Name = "LootActor"

setmetatable(LootActorState, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function LootActorState.new()
    local self = setmetatable( { }, LootActorState)
    self.CurrentLootActor = { }
    self.BlacklistActors = { }
    self.Settings = { TakeLoot = true, LootRadius = 4000 }
    self.State = 0

    self.ItemCheckFunction = nil
    self.CallWhenCompleted = nil
    self.CallWhileMoving = nill

    return self
end

function LootActorState:NeedToRun()

    if self.Settings.TakeLoot == false then
        return false
    end

    local selfPlayer = GetSelfPlayer()

    if not selfPlayer then
        return false
    end

    if not selfPlayer.IsAlive then
        return false
    end

    local selfPlayerPosition = selfPlayer.Position

    if selfPlayer.Inventory.FreeSlots == 0 then
        return false
    end

    local actors = GetActors()
    table.sort(actors, function(a, b) return a.Position:GetDistance3D(selfPlayerPosition) < b.Position:GetDistance3D(selfPlayerPosition) end)
    for k, v in pairs(actors) do
        if v.IsInteractable and
            v.IsLootInteraction and
            v.Position.Distance3DFromMe < self.Settings.LootRadius and
            Navigator.CanMoveTo(v.Position) -- or v.IsLineOfSight and v.Position.Distance3DFromMe < 1000)
        then
            self.CurrentLootActor = v
            return true
        end
    end

    return false
end

function LootActorState:Run()

    local selfPlayer = GetSelfPlayer()
    local actorPosition = self.CurrentLootActor.Position

    if selfPlayer.LootState > 0 then
        selfPlayer:LootAllItemsToPlayer()
        if self.CallWhenCompleted then
            self.CallWhenCompleted(self)
        end

        return true
    end

    if actorPosition.Distance3DFromMe > self.CurrentLootActor.BodySize + 150 then
        if self.CallWhileMoving then
            self.CallWhileMoving(self)
        end
        Navigator.MoveTo(actorPosition)
    else
        Navigator.Stop()
        selfPlayer:Interact(self.CurrentLootActor)
    end

    return true

end