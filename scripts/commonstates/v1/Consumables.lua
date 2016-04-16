ConsumablesState = { }
ConsumablesState.__index = ConsumablesState
ConsumablesState.Name = "Consumables"

-- Health Percent and Mana Percent are less than % 1-100
-- Time is after X Minutes


ConsumablesState.Conditions = { "Health Percent", "Mana Percent", "Time", "Is Usable" } -- , "Have Buff", "Don't Have Buff" }

setmetatable(ConsumablesState, {
    __call = function(cls, ...)
        return cls.new(...)
    end,
} )

function ConsumablesState.new()
    local self = setmetatable( { }, ConsumablesState)
    self.State = 0

    -- Format Consumables in table {Name, ConditionName, ConditionValue}
    -- example {Name = "Steamed Bird",ConditionName="Time", ConditionValue="30", ConsumeTime = 1} ** ConsumeTime is Optional if not present ConsumeWait is used
    self.Settings = { PreConsumeWait = 0, ConsumeWait = 1, SecondsBetweenTries = 0.25, Consumables = { } }


    self.Forced = false
    self.LastUseTimer = nil
    self.SleepTimer = nil

    self.CustomCondition = nil
    self.CallWhenCompleted = nil
    self.CallWhileMoving = nil
    self.Items = { }
    return self
end

function ConsumablesState:NeedToRun()

    local selfPlayer = GetSelfPlayer()


    if not selfPlayer then
        return false
    end

    if not selfPlayer.IsAlive then
        return false
    end

    if self.Forced == true then
        return true
    end


    if self.LastUseTimer ~= nil and not self.LastUseTimer:Expired() then
        return false
    end

    if self.CustomCondition then
        if self.CustomCondition() == false then
            return false
        end
    end

    if table.length(self:GetItems()) >= 1 then
        self.Forced = true
        return true
    end
    return false
end


function ConsumablesState:Reset()
    self.State = 0
    self.LastUseTimer = nil
    self.SleepTimer = nil
    self.Forced = false
    self.Items = { }
end

function ConsumablesState:Exit()
    self.State = 0
    self.LastUseTimer = PyxTimer:New(0.25)
    self.LastUseTimer:Start()
    self.SleepTimer = nil
    self.Forced = false
    self.Items = { }
end

function ConsumablesState:Run()

    if self.SleepTimer ~= nil and self.SleepTimer:IsRunning() and self.SleepTimer:Expired() == false then
        return true
    end

    local selfPlayer = GetSelfPlayer()
    if self.State == 0 then
        self.SleepTimer = PyxTimer:New(self.Settings.PreConsumeWait)
        self.SleepTimer:Start()
        self.State = 1
        self.Items = self:GetItems()
        return true
    end
    if self.State == 1 then

        if table.length(self.Items) < 1 then
            print("Consumables Done")
            self.State = 2
            if self.CallWhenCompleted then
                self.CallWhenCompleted(self)
            end
            self:Exit()
            return
        end

        local item = self.Items[1]
        self:ExecuteItem(item)
        if item.ConsumeTime ~= nil then
            self.SleepTimer = PyxTimer:New(tonumber(item.ConsumeTime))
        else
            self.SleepTimer = PyxTimer:New(self.Settings.ConsumeWait)
        end
        self.SleepTimer:Start()

        table.remove(self.Items, 1)
        return true
    end

    self:Exit()
end

function ConsumablesState:ExecuteItem(item)
    print("Use Consumable: " .. item.Name)
    local selfPlayer = GetSelfPlayer()
    local foodItem = selfPlayer.Inventory:GetItemByName(item.Name)
    foodItem:UseItem()
    if item.ConditionName == "Time" then
        if item.Timer ~= nil then
            item.Timer = PyxTimer:New(tonumber(item.ConditionValue) * 60)
        else
            item["Timer"] = PyxTimer:New(tonumber(item.ConditionValue) * 60)
        end
        item.Timer:Start()
    end
end

function ConsumablesState:ClearTimers()
    for k, v in pairs(self.Settings.Consumables) do
        if v.Timer ~= nil then
            v.Timer = nil
        end
    end
end

function ConsumablesState:CanExecute(item)
    if Item == nil then return false end

    local selfPlayer = GetSelfPlayer()
    local foodItem = selfPlayer.Inventory:GetItemByName(item.Name)

    if foodItem == nil or foodItem.IsOnCooldown ~= false then
        return false
    end

    if item.ConditionName == "Health Percent" or item.ConditionName == "Mana Percent" then
        local pcntCheck = selfPlayer.HealthPercent
        if item.ConditionName == "Mana Percent" then
            pcntCheck = selfPlayer.ManaPercent
        end
        if pcntCheck < tonumber(item.ConditionValue) then
            return true
        end
    elseif item.ConditionName == "Time" then
        if item.Timer == nil or item.Timer.Expired == nil or item.Timer:Expired() then
            return true
        end
    elseif item.ConditionName == "Is Usable" then
        return true
    end

    return false
end

function ConsumablesState:GetItems()
    local items = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(self.Settings.Consumables) do
            if self:CanExecute(v) then
                table.insert(items, v)
            end
        end
    end

    return items
end

