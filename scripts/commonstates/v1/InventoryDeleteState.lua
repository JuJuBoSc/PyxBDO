InventoryDeleteState = { }
InventoryDeleteState.__index = InventoryDeleteState
InventoryDeleteState.Name = "Inventory Delete"

setmetatable(InventoryDeleteState, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function InventoryDeleteState.new()
    local self = setmetatable( { }, InventoryDeleteState)
    self.State = 0
    self.Settings = { DeleteItems = {}, DeleteDepletedItems = {}, SecondsBetweenTries = 60}

    self.Forced = false
    self.SleepTimer = nil

    self.CallWhenCompleted = nil
    self.ItemCheckFunction = nil

    self.ItemList = {}

    return self
end

function InventoryDeleteState:NeedToRun()

    local selfPlayer = GetSelfPlayer()

      if self.LastUseTimer ~= nil and not self.LastUseTimer:Expired() then
        return false
    end


    if not selfPlayer then
        return false
    end

    if not selfPlayer.IsAlive then
        return false
    end

    if table.length(self:GetItems()) > 0 then
       return true
    end

    return false
end


function InventoryDeleteState:Reset()
    self.State = 0
    self.LastUseTimer = nil
    self.Forced = false
    self.ItemList = {}
end

function InventoryDeleteState:Exit()
    if self.State > 1 then
        self.State = 0
        self.LastUseTimer = PyxTimer:New(self.Settings.SecondsBetweenTries)
        self.LastUseTimer:Start()
        self.Forced = false
        self.ItemList = {}
        end

end

function InventoryDeleteState:Run()
    local selfPlayer = GetSelfPlayer()
    self.State = 2

        for k, v in pairs(self:GetItems()) do
        print("Deleting Item: "..v.item.ItemEnchantStaticStatus.Name)
        selfPlayer.Inventory:DeleteItem(v.slot)

    end
    self:Exit()


end

function InventoryDeleteState:GetItems()
    local items = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(selfPlayer.Inventory.Items) do
            if self.ItemCheckFunction then
                if self.ItemCheckFunction(v) then
                    table.insert(items, { item = v, slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                end
            else
                if table.find(self.Settings.DeleteItems, v.ItemEnchantStaticStatus.Name) then
                    table.insert(items, { item = v, slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                elseif v.HasEndurance and v.EndurancePercent < 1 and table.find(self.Settings.DeleteItems, v.ItemEnchantStaticStatus.Name) then
                    table.insert(items, { item = v, slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                end
            end
        end
    end
    --[[
                if v.HasEndurance and v.EndurancePercent < 100 then
                    table.insert(items, { item = v, slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                end
    
    --]]
    return items
end
