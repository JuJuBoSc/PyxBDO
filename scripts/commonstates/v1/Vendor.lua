VendorState = { }
VendorState.__index = VendorState
VendorState.Name = "Vendor"


setmetatable(VendorState, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function VendorState.new()
    local self = setmetatable( { }, VendorState)
    self.Settings = {
        NpcName = "",
        NpcPosition = { X = 0, Y = 0, Z = 0 },
        VendorOnInventoryFull = true,
        VendorOnWeight = true,
        VendorWhite = true,
        VendorGreen = false,
        VendorBlue = false,
        VendorGold = false,
        SellEnabled = true,
        BuyEnabled = true,
        BuyWhenAtVendor = true,
        IgnoreItemsNamed = { },
        -- Buy Items Format {Name, BuyAt, BuyMax} BuyAt level we should buyat or below, BuyMax Max to have in Inventory so if is 100 and we have 20 bot will buy 80
        BuyItems = { },
        SecondsBetweenTries = 3000
    }

    self.State = 0
    -- 0 = Nothing, 1 = Moving, 2 = Arrived
    self.DepositList = nil

    self.LastUseTimer = nil
    self.SleepTimer = nil
    self.CurrentSellList = { }
    self.CurrentBuyList = { }
    self.Forced = false

    -- Overideable functions
    self.ItemCheckFunction = nil
    self.CallWhenCompleted = nil
    self.CallWhileMoving = nill

    return self
end

function VendorState:NeedToRun()

    local selfPlayer = GetSelfPlayer()


    if not selfPlayer then
        return false
    end

    if not selfPlayer.IsAlive then
        return false
    end

    if not self:HasNpc() then
        self.Forced = false
        return false
    end

    if self.Settings.SellEnabled == false and self.Settings.BuyEnabled == false then
        return false
    end

    if self.Forced and not Navigator.CanMoveTo(self:GetPosition()) then
        self.Forced = false
        return false
    elseif self.Forced == true then
        return true
    end

    if self.LastUseTimer ~= nil and not self.LastUseTimer:Expired() then
        return false
    end


    if self.Settings.SellEnabled and self.Settings.VendorOnInventoryFull and
        selfPlayer.Inventory.FreeSlots <= 2 and
        table.length(self:GetSellItems()) > 0 and
        Navigator.CanMoveTo(self:GetPosition()) then
        self.Forced = true
        return true
    end

    if self.Settings.SellEnabled and self.Settings.VendorOnWeight and
        selfPlayer.WeightPercent >= 95 and
        table.length(self:GetSellItems()) > 0 and
        Navigator.CanMoveTo(self:GetPosition()) then
        self.Forced = true
        return true
    end

    if self.Settings.BuyItems and
        table.length(self:GetBuyItems(false)) > 0 and
        Navigator.CanMoveTo(self:GetPosition()) then
        self.Forced = true
        return true
    end

    return false
end

function VendorState:HasNpc()
    return string.len(self.Settings.NpcName) > 0
end

function VendorState:GetPosition()
    return Vector3(self.Settings.NpcPosition.X, self.Settings.NpcPosition.Y, self.Settings.NpcPosition.Z)
end

function VendorState:Reset()
    self.State = 0
    self.LastUseTimer = nil
    self.SleepTimer = nil
    self.Forced = false
    self.DepositedMoney = false
end

function VendorState:Exit()
    if self.State > 1 then
        if Dialog.IsTalking then
            Dialog.ClickExit()
        end
        self.State = 0
        self.LastUseTimer = PyxTimer:New(self.Settings.SecondsBetweenTries)
        self.LastUseTimer:Start()
        self.SleepTimer = nil
        self.Forced = false

    end
end

function VendorState:Run()
    local selfPlayer = GetSelfPlayer()
    local vendorPosition = self:GetPosition()

    if vendorPosition.Distance3DFromMe > 300 then
        if self.CallWhileMoving then
            self.CallWhileMoving(self)
        end

        Navigator.MoveTo(vendorPosition)
        if self.State > 1 then
            self:Exit()
            return true
        end
        self.State = 1
        return true
    end
    Navigator.Stop()

    if self.SleepTimer ~= nil and self.SleepTimer:IsRunning() and not self.SleepTimer:Expired() then
        return true
    end


    local npcs = GetNpcs()

    if table.length(npcs) < 1 then
        print("Vendor could not find any NPC's")
        self:Exit()
        return false
    end
    table.sort(npcs, function(a, b) return a.Position:GetDistance3D(vendorPosition) < b.Position:GetDistance3D(vendorPosition) end)

    local npc = npcs[1]

    if self.State == 1 then
        npc:InteractNpc()
        self.SleepTimer = PyxTimer:New(3)
        self.SleepTimer:Start()
        self.State = 2
        return true
    end


    if self.State == 2 then
        if not Dialog.IsTalking then
            print("Vendor Error Dialog didn't open")
            self:Exit()
            return false
        end
        BDOLua.Execute("npcShop_requestList()")
        self.SleepTimer = PyxTimer:New(1)
        self.SleepTimer:Start()
        if self.Settings.SellEnabled then
            self.State = 3
            self.CurrentSellList = self:GetSellItems()
            self.CurrentBuyList = self:GetBuyItems(self.Settings.BuyWhenAtVendor)
        elseif self.Settings.BuyEnabled then
            self.State = 4
            -- go right to buying
            self.CurrentBuyList = self.GetBuyItems(self.Settings.BuyWhenAtVendor)
        else
            -- how did we get here!
            self.State = 5
        end
        return true
    end

    if self.State == 3 then

        if table.length(self.CurrentSellList) < 1 then
            print("Vendor Sell done")
            if self.Settings.BuyEnabled then
                self.State = 4
                return true
            else
                self.State = 5
                return true
            end
        end

        local item = self.CurrentSellList[1]
        local itemPtr = selfPlayer.Inventory:GetItemByName(item.name)
        if itemPtr ~= nil then
            print(itemPtr.InventoryIndex .. " Sell item : " .. itemPtr.ItemEnchantStaticStatus.Name)
            itemPtr:RequestSellItem(npc)
            self.SleepTimer = PyxTimer:New(0.5)
            self.SleepTimer:Start()
        end
        table.remove(self.CurrentSellList, 1)
        return true
    end
    if self.State == 4 then

        if table.length(self.CurrentBuyList) < 1 then
            print("Vendor Buy done")
            self.State = 5
            return true
        else
            if selfPlayer.Inventory.FreeSlots <= 0 then
                print("Vendor Buy Inventory Full")
                self.State = 5
                return true
            end
        end
        local item = self.CurrentBuyList[1]
        local itemPtr = self:GetBuyItemByName(item.name)
        if itemPtr ~= nil then
            print("Buying " .. item.name .. " Quantity: " .. item.countNeeded)
            for cnt = 1, item.countNeeded do
                itemPtr:Buy(1)
            end
            self.SleepTimer = PyxTimer:New(1)
            self.SleepTimer:Start()
        else
            print("Need to Buy " .. item.name .. " Quantity: " .. item.countNeeded .. " but can't find at vendor!")
        end

        table.remove(self.CurrentBuyList, 1)
        return true
    end

    if self.State == 5 then
        if self.CallWhenCompleted then
            self.CallWhenCompleted(self)
        end
    end

    self:Exit()
    return false
end


function VendorState:CanSellGrade(item)

    if self.Settings.VendorWhite and item.ItemEnchantStaticStatus.Grade == ITEM_GRADE_WHITE then
        return true
    end

    if self.Settings.VendorGreen and item.ItemEnchantStaticStatus.Grade == ITEM_GRADE_GREEN then
        return true
    end

    if self.Settings.VendorBlue and item.ItemEnchantStaticStatus.Grade == ITEM_GRADE_BLUE then
        return true
    end

    if self.Settings.VendorGold and item.ItemEnchantStaticStatus.Grade == ITEM_GRADE_GOLD then
        return true
    end

    return false
end


function VendorState:GetSellItems()
    local items = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(selfPlayer.Inventory.Items) do
            if self.ItemCheckFunction then
                if self.ItemCheckFunction(v) then
                    table.insert(items, { slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                end
            else
                if not table.find(self.Settings.IgnoreItemsNamed, v.ItemEnchantStaticStatus.Name) and self:CanSellGrade(v) == true then
                    table.insert(items, { slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                end

            end
        end
    end
    return items
end

function VendorState:NeedToBuy(itemName, count)
    for key, value in pairs(self.Settings.BuyItems) do
        if value.Name == itemName then
            if (count - value.BuyAt) <= 0 then
                --            print(value.Name.." "..count.." "..value.BuyAt.." "..value.BuyMax - count)
                return value.BuyMax - count
            end
            return 0
        end
    end
    return 0


end


function VendorState:StockUpToBuy(itemName, count)
    for key, value in pairs(self.Settings.BuyItems) do
        if value.Name == itemName then
            return value.BuyMax - count
        end
    end
    return 0


end

function VendorState:GetBuyItems(stockUp)
    local items = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        local tmpInventory = { }
        -- Check equipped and add to total (for fishing Rods)
        local equippedItem = selfPlayer:GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND)

        if equippedItem ~= nil then
            tmpInventory[equippedItem.ItemEnchantStaticStatus.Name] = 1
        end


        -- get totals from inventory
        for k, v in pairs(selfPlayer.Inventory.Items) do
            if tmpInventory[v.ItemEnchantStaticStatus.Name] == nil then
                tmpInventory[v.ItemEnchantStaticStatus.Name] = v.Count
            else
                tmpInventory[v.ItemEnchantStaticStatus.Name] = tmpInventory[v.ItemEnchantStaticStatus.Name] + v.Count
            end
        end

        -- check if we have enough on us
        for k, v in pairs(tmpInventory) do
            local countNeeded = self:NeedToBuy(k, v)
            if countNeeded > 0 then
                table.insert(items, { name = k, currentCount = v, countNeeded = countNeeded })
            elseif stockUp == true and self:StockUpToBuy(k, v) > 0 then
                table.insert(items, { name = k, currentCount = v, countNeeded = self:StockUpToBuy(k, v) })
            end
        end

        -- check for items we don't have in inventory
        for key, value in pairs(self.Settings.BuyItems) do
            if tmpInventory[value.Name] == nil then
                table.insert(items, { name = value.Name, currentCount = 0, countNeeded = value.BuyMax })
            end
        end


    end
    return items
end

function VendorState:GetBuyItemByName(itemName)
    for i = 0, NpcShop.BuyItemCount - 1 do
        local item = NpcShop.GetBuyItemByIndex(i)
        print(item.ItemEnchantStaticStatus.Name)
        print(itemName)
        if item.ItemEnchantStaticStatus.Name == itemName then
            return item
        end
    end

    return nil
end
