------------------------------------------------------------------------------
-- Version .2 by Triplany 2016-03-28
-----------------------------------------------------------------------------

Bot = { }
Bot.Settings = {}
Bot.Running = false
Bot.Feeding = false
Bot.PulseTimer = PyxTimer:New(1)


function Bot.Start()
    if not Bot.Running then
        
        Bot.ResetStats()
        Bot.SaveSettings()
        
        Bot.Running = true
    end
end

function Bot.Stop()
    Bot.Running = false
end

function Bot.ResetStats()
    
end

function Bot.OnPulse()
    if not Bot.PulseTimer:IsRunning() or Bot.PulseTimer:Expired() then
        Bot.PulseTimer = PyxTimer:New(1)
        Bot.PulseTimer:Start()
    else
        return
    end

    local petsOut = Pets.GetUnsealedPetCount()
    local selfPlayer = GetSelfPlayer()


    if petsOut <= 0 or selfPlayer == nil then
        return
    end

    if Bot.Feeding == true then
        local food = selfPlayer.Inventory:GetItemByName(Bot.Settings.FoodName)
        if food == nil or food.IsInCooldown then
            return
        end
            food:UseItem()
    end
    
        for cnt = 1, petsOut do
        if Bot.GetUnsealedPetHungerPercent(cnt) <= Bot.Settings.FoodPercent then
            Bot.Feeding = true
        return
        end
    end
    Bot.Feeding = false
end

function Bot.SaveSettings()
    local json = JSON:new()
    Pyx.FileSystem.WriteFile("Settings.json", json:encode_pretty(Bot.Settings))
end

function Bot.LoadSettings()
    local json = JSON:new()
    Bot.Settings = {FoodPercent = 50, FoodName = "None"}
    table.merge(Bot.Settings, json:decode(Pyx.FileSystem.ReadFile("Settings.json")))
end

function Bot.GetUnsealedPetHungerPercent(petIndex)
    local pet = Pets.GetUnsealedPetInfo(petIndex)

    if pet == nil then return 100 end

    return (pet.Hunger/pet.MaxHunger)*100
end

function Bot.GetFood()
    local selfPlayer = GetSelfPlayer()

    if selfPlayer then
        for k,v in pairs(selfPlayer.Inventory.Items) do
            if v.ItemEnchantStaticStatus.Name == Bot.Settings.FoodName then
                return v
            end
        end
    end
    
return nil

end




Bot.ResetStats()
