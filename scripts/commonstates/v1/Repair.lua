RepairState = { }
RepairState.__index = RepairState
RepairState.Name = "Repair"

setmetatable(RepairState, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function RepairState.new()
    local self = setmetatable( { }, RepairState)
    self.State = 0
    self.Settings = { NpcName = "", NpcPosition = { X = 0, Y = 0, Z = 0 }, SecondsBetweenTries = 3000 }

    self.Forced = false
    self.LastUseTimer = nil
    self.SleepTimer = nil

    self.CallWhenCompleted = nil
    self.CallWhileMoving = nil

    self.RepairList = {}

    return self
end

function RepairState:NeedToRun()

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
        
    if self.Forced == true and not Navigator.CanMoveTo(self:GetPosition()) then
        print("Was told to go to Repair but Navigator.CanMoveTo returns false")
        self.Forced = false
        return false
    elseif self.Forced == true then
        return true
    end


        if self.LastUseTimer ~= nil and not self.LastUseTimer:Expired() then
        return false
    end

        for k, v in pairs(selfPlayer.EquippedItems) do
            if v.HasEndurance and v.EndurancePercent <= 20 then
                if Navigator.CanMoveTo(self:GetPosition()) then
                    self.Forced = true
                    return true
                else
                    print("Need to Repair! Can not find path to NPC: " .. self.Settings.NpcName)
                    return false
                end

            end
        end

    return false
end

function RepairState:HasNpc()
    return string.len(self.Settings.NpcName) > 0
end
function RepairState:GetPosition()
    return Vector3(self.Settings.NpcPosition.X, self.Settings.NpcPosition.Y, self.Settings.NpcPosition.Z)
end

function RepairState:Reset()
    self.State = 0
    self.LastUseTimer = nil
    self.SleepTimer = nil
    self.Forced = false
    self.RepairList = {}
end

function RepairState:Exit()
    if Dialog.IsTalking then
        Dialog.ClickExit()
    end
    if self.State > 1 then
        self.State = 0
        self.LastUseTimer = PyxTimer:New(self.Settings.SecondsBetweenTries)
        self.LastUseTimer:Start()
        self.SleepTimer = nil
        self.Forced = false
        self.RepairList = {}
        end

end

function RepairState:Run()
    local selfPlayer = GetSelfPlayer()
    local vendorPosition = self:GetPosition()

    if vendorPosition.Distance3DFromMe > 300 then
        if self.CallWhileMoving then
            self.CallWhileMoving(self)
        end
        Navigator.MoveTo(vendorPosition)
        if self.State > 1 then
            self:Exit()
            return
        end
        self.State = 1
        return
    end
    Navigator.Stop()

    if self.SleepTimer ~= nil and self.SleepTimer:IsRunning() and not self.SleepTimer:Expired() then
        return
    end

    local npcs = GetNpcs()

    if table.length(npcs) < 1 then
        print("Repair could not find any NPC's")
        self:Exit()
        return
    end
    table.sort(npcs, function(a, b) return a.Position:GetDistance3D(vendorPosition) < b.Position:GetDistance3D(vendorPosition) end)

    local npc = npcs[1]

    if self.State == 1 then
        npc:InteractNpc()
        self.SleepTimer = PyxTimer:New(2)
        self.SleepTimer:Start()
        self.State = 2
        return true
    end

    if self.State == 2 then
        if not Dialog.IsTalking then
            print("Repair Error Dialog didn't open")
            self:Exit()
            return
        end
        self.SleepTimer = PyxTimer:New(0.1)
        self.SleepTimer:Start()
        self.State = 3
        self.RepairList = self:GetItems()
        return
    end
    if self.State == 3 then

        if table.length(self.RepairList) < 1 then
            print("Repair done list")
            self.State = 4
            if self.CallWhenCompleted then
                self.CallWhenCompleted(self)
            end
            self:Exit()
            return
        end

        local item = self.RepairList[1]
        --        local itemPtr = selfPlayer.Inventory:GetItemByName(item.name)
        if item.item ~= nil then
            print(" Repair item : " .. item.name)
            item.item:Repair(npc)
            self.SleepTimer = PyxTimer:New(0.5)
            self.SleepTimer:Start()
        end
        table.remove(self.RepairList, 1)
        return
    end

    self:Exit()


end

function RepairState:GetItems()
    local items = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(selfPlayer.EquippedItems) do
            if self.ItemCheckFunction then
                if self.ItemCheckFunction(v) then
                    table.insert(items, { item = v, slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                end
            else
                if v.HasEndurance and v.EndurancePercent < 100 then
                    table.insert(items, { item = v, slot = v.InventoryIndex, name = v.ItemEnchantStaticStatus.Name, count = v.Count })
                end
            end
        end
    end

    return items
end

