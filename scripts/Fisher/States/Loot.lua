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
  self.DeleteList = {}
  Bot.LastLootTime = nil
  Bot.LootTimes = {}
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
    
    if #self.DeleteList > 0 and os.clock() - self.DeleteTime > 0 then
        local deleteCounts = {}
        for _,deleteId in pairs(self.DeleteList) do
            deleteCounts[deleteId] = (deleteCounts[deleteId] or 0) + 1
        end
        self.DeleteList = {}
        for _,item in pairs(selfPlayer.Inventory.Items) do 
            local numberToDelete = deleteCounts[item.ItemEnchantStaticStatus.ItemId]
            if numberToDelete ~= nil and numberToDelete > 0 then
                deleteCounts[item.ItemEnchantStaticStatus.ItemId] = deleteCounts[item.ItemEnchantStaticStatus.ItemId] - 1
                selfPlayer.Inventory:DeleteItem(item.InventoryIndex, 1)
                print(string.format("Deleting %s at slot %i", item.ItemEnchantStaticStatus.Name, item.InventoryIndex))
            end
        end
    end

    if selfPlayer.Inventory.FreeSlots <= 1 then
        return false
    end
    
    return Looting.IsLooting
    
end

function LootState:Run()
    if Bot.LastLootTime ~= nil then
        table.insert(Bot.LootTimes, os.clock() - Bot.LastLootTime)
        local sum = 0
        for k,v in pairs(Bot.LootTimes) do 
            sum = sum + v
        end
        Bot.Stats.AverageLootTime = sum / #Bot.LootTimes
    end
    Bot.LastLootTime = os.clock()
    Bot.Stats.Loots = Bot.Stats.Loots + 1

    local numLoots = Looting.ItemCount
    for i=0,numLoots-1 do 
        local lootItem = Looting.GetItemByIndex(i)
        if lootItem then

            -- stats
            Bot.Stats.LootQuality[lootItem.ItemEnchantStaticStatus.Grade] = (Bot.Stats.LootQuality[lootItem.ItemEnchantStaticStatus.Grade] or 0) + 1
            if lootItem.ItemEnchantStaticStatus.ItemId == 40218 then
                Bot.Stats.Relics = Bot.Stats.Relics + 1
            elseif lootItem.ItemEnchantStaticStatus.ItemId == 44165 then
                Bot.Stats.Keys = Bot.Stats.Keys + 1
            end

            -- loot filtering
            if not Bot.Settings.IgnoreUntradeAbleItems or lootItem.ItemEnchantStaticStatus.IsTradeAble then
                if lootItem.ItemEnchantStaticStatus.ItemId == 40218 then
                    if Bot.Settings.LootRelic then
                        print("Loot item : " .. lootItem.ItemEnchantStaticStatus.Name)
                        Looting.Take(i)
                    end
                elseif lootItem.ItemEnchantStaticStatus.ItemId == 44165 then
                    if Bot.Settings.LootKey then
                        print("Loot item : " .. lootItem.ItemEnchantStaticStatus.Name)
                        Looting.Take(i)
                    end
                elseif (lootItem.ItemEnchantStaticStatus.Grade == 0 and not Bot.Settings.LootWhite) 
                    or (lootItem.ItemEnchantStaticStatus.Grade == 1 and not Bot.Settings.LootGreen)
                    or (lootItem.ItemEnchantStaticStatus.Grade == 2 and not Bot.Settings.LootBlue)
                    then
                    -- delete later
                    if Bot.Settings.LootAndDeleteUnwantedFish then
                        Looting.Take(i)
                        table.insert(self.DeleteList, lootItem.ItemEnchantStaticStatus.ItemId)
                        self.DeleteTime = os.clock() + 0.5
                    end
                else
                    print("Loot item : " .. lootItem.ItemEnchantStaticStatus.Name)
                    Looting.Take(i)
                end
            end
        end
    end
    Looting.Close()
end
