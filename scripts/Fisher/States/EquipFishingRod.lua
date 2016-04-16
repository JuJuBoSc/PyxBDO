EquipFishingRodState = { }
EquipFishingRodState.__index = EquipFishingRodState
EquipFishingRodState.Name = "Equip fishing rod"

setmetatable(EquipFishingRodState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function EquipFishingRodState.new()
  local self = setmetatable({}, EquipFishingRodState)
  self.LastEquipTickCount = 0
  self.ItemToEquip = nil
  return self
end

function EquipFishingRodState:NeedToRun()

    self.ItemToEquip = nil

    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end
    
    if Pyx.System.TickCount - self.LastEquipTickCount < 4000 then
        return false
    end

    if ProfileEditor.CurrentProfile:GetFishSpotPosition().Distance3DFromMe > 100 then
    return false
    end
	
    local items = selfPlayer.Inventory.Items
	
	table.sort(items, function(a, b) return a.Endurance < b.Endurance end)
	
    for k,v in pairs(items) do
        if v.ItemEnchantStaticStatus.IsFishingRod and v.Endurance > 0 then
            self.ItemToEquip = v
            break
        end
    end
    
    if not self.ItemToEquip then
        return false
    end
    
    local equippedItem = selfPlayer:GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND)
    
    if not equippedItem then
        return true
    end
    
    if not equippedItem.ItemEnchantStaticStatus.IsFishingRod then
        return true
    end

    return equippedItem.Endurance == 0
    
end

function EquipFishingRodState:Run()
    local selfPlayer = GetSelfPlayer()
    self.ItemToEquip:UseItem()
    self.LastEquipTickCount = Pyx.System.TickCount
end
