LootState = { }
LootState.__index = LootState
LootState.Name = "Loot"

setmetatable(LootState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function LootState.new()
  local self = setmetatable({}, LootState)
  self.LastHookFishTickCount = 0
  return self
end

function LootState:NeedToRun()

    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end
    
    if selfPlayer.Inventory.FreeSlots == 0 then
        return false
    end
    
    return Looting.IsLooting
    
end

function LootState:Run()
    local numLoots = Looting.ItemCount
    for i=0,numLoots-1 do 
        local lootItem = Looting.GetItemByIndex(i)
        if lootItem then
            if not Bot.Settings.IgnoreUntradeAbleItems or lootItem.ItemEnchantStaticStatus.IsTradeAble then
                print("Loot item : " .. lootItem.ItemEnchantStaticStatus.Name)
                Looting.Take(i)
            end
        end
    end
    Looting.Close()
end
