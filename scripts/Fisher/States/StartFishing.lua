StartFishingState = { }
StartFishingState.__index = StartFishingState
StartFishingState.Name = "Start fishing"

setmetatable(StartFishingState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function StartFishingState.new()
  local self = setmetatable({}, StartFishingState)
  self.LastStartFishTickcount = 0
  self.Settings = {MaxEnergyCheat = false}
  return self
end

function StartFishingState:NeedToRun()

    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end
    
    local equippedItem = selfPlayer:GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND)
    
    if not equippedItem then
        return false
    end
    
    if not equippedItem.ItemEnchantStaticStatus.IsFishingRod then
        return false
    end
    
    if Pyx.System.TickCount - self.LastStartFishTickcount < 4000 then
        return false
    end
    
    if ProfileEditor.CurrentProfile:GetFishSpotPosition().Distance3DFromMe > 100 then
        return false
    end

    return selfPlayer.CurrentActionName == "WAIT"
end

function StartFishingState:Run()
    local selfPlayer = GetSelfPlayer()
    print("Start fishing ...")
    selfPlayer:SetRotation(ProfileEditor.CurrentProfile:GetFishSpotRotation())
    selfPlayer:DoAction("FISHING_START")
    selfPlayer:DoAction("FISHING_ING_START")
    if self.Settings.MaxEnergyCheat == true then
    selfPlayer:DoAction("FISHING_START_END_Lv10")
    else
    selfPlayer:DoAction("FISHING_START_END_Lv0")
    end
    self.LastStartFishTickcount = Pyx.System.TickCount
end
