UnequipFishingRodState = { }
UnequipFishingRodState.__index = UnequipFishingRodState
UnequipFishingRodState.Name = "Unequip fishing rod"

setmetatable(UnequipFishingRodState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function UnequipFishingRodState.new()
  local self = setmetatable({}, UnequipFishingRodState)
  self.LastUnequipTickcount = 0
  return self
end

function UnequipFishingRodState:NeedToRun()

    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end
    
    if Pyx.System.TickCount - self.LastUnequipTickcount < 4000 then
        return false
    end
    
    local equippedItem = selfPlayer:GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND)
    
    if not equippedItem then
        return false
    end
    
    if not equippedItem.ItemEnchantStaticStatus.IsFishingRod then
        return true
    end

    return equippedItem.Endurance == 0
    
end

function UnequipFishingRodState:Run()
    local selfPlayer = GetSelfPlayer()
    selfPlayer:UnequipItem(INVENTORY_SLOT_RIGHT_HAND)
    self.LastUnequipTickcount = Pyx.System.TickCount
end
