Bot = { }
Bot.Settings = Settings()
Bot.Running = false
Bot.Fsm = FSM()
Bot.WarehouseState = WarehouseState()
Bot.VendorState = VendorState()
Bot.TradeManagerState = TradeManagerState()
Bot.InventoryDeleteState = InventoryDeleteState()
Bot.ConsumablesState = ConsumablesState()
Bot.StartFishingState = StartFishingState()
Bot.HookFishHandleGameState = HookFishHandleGameState()

function Bot.Start()
    if not Bot.Running then

        Bot.ResetStats()
        Bot.SaveSettings()

        local currentProfile = ProfileEditor.CurrentProfile
        Bot.WarehouseState.Settings.NpcName = currentProfile.WarehouseNpcName
        Bot.WarehouseState.Settings.NpcPosition = currentProfile.WarehouseNpcPosition
        Bot.WarehouseState.CallWhenCompleted = Bot.StateComplete
        Bot.WarehouseState.CallWhileMoving = Bot.StateMoving
        Bot.WarehouseState.ItemCheckFunction = Bot.CustomWarehouseCheck

        Bot.VendorState.Settings.NpcName = currentProfile.VendorNpcName
        Bot.VendorState.Settings.NpcPosition = currentProfile.VendorNpcPosition
        Bot.VendorState.CallWhenCompleted = Bot.StateComplete
        Bot.VendorState.CallWhileMoving = Bot.StateMoving

        Bot.TradeManagerState.Settings.NpcName = currentProfile.TradeManagerNpcName
        Bot.TradeManagerState.Settings.NpcPosition = currentProfile.TradeManagerNpcPosition
        Bot.TradeManagerState.CallWhenCompleted = Bot.StateComplete
        Bot.TradeManagerState.CallWhileMoving = Bot.StateMoving
        Bot.Settings.TradeManagerSettings.SecondsBetweenTries = 0

        Bot.InventoryDeleteState.ItemCheckFunction = Bot.DeleteItemCheck

        Bot.ConsumablesState.CustomCondition = Bot.ConsumablesCustomRunCheck
        Bot.ConsumablesState:ClearTimers()

        Bot.ConsumablesState.Settings.PreConsumeWait = 2
        Bot.ConsumablesState.Settings.ConsumeWait = 8

        Bot.ConsumablesState.ValidActions = { "WAIT" }

        if not currentProfile then
            print("No profile loaded !")
            return
        end

        if not currentProfile:HasFishSpot() then
            print("Profile require a fish spot !")
            return
        end


        ProfileEditor.Visible = false
        Navigation.MesherEnabled = false
        Bot.TradeManagerForced = false

        Bot.Fsm = FSM()
        Bot.Fsm.ShowOutput = true
        Bot.Fsm:AddState(BuildNavigationState())
        Bot.Fsm:AddState(LootState())
        Bot.Fsm:AddState(Bot.InventoryDeleteState)
        Bot.Fsm:AddState(Bot.HookFishHandleGameState)
        Bot.Fsm:AddState(HookFishState())
        Bot.Fsm:AddState(UnequipFishingRodState())
        Bot.Fsm:AddState(Bot.TradeManagerState)
        Bot.Fsm:AddState(Bot.VendorState)
        Bot.Fsm:AddState(Bot.WarehouseState)
        Bot.Fsm:AddState(EquipFishingRodState())
        Bot.Fsm:AddState(Bot.ConsumablesState)
        Bot.Fsm:AddState(LibConsumables.ConsumablesState)
        Bot.Fsm:AddState(Bot.StartFishingState)
        Bot.Fsm:AddState(MoveToFishingSpotState())
        Bot.Fsm:AddState(IdleState())
        Bot.Running = true
    end
end

function Bot.Stop()
    Navigator.Stop()
    Bot.Running = false
    Bot.WarehouseState:Reset()
    Bot.VendorState:Reset()
    Bot.TradeManagerState:Reset()

end

function Bot.ResetStats()

end

function Bot.OnPulse()
    if Bot.Running then
        Bot.Fsm:Pulse()
    end
end

function Bot.SaveSettings()
    local json = JSON:new()
    Pyx.FileSystem.WriteFile("Settings.json", json:encode_pretty(Bot.Settings))
end

function Bot.LoadSettings()
    local json = JSON:new()

    Bot.Settings = Settings()
    Bot.Settings.WarehouseSettings = Bot.WarehouseState.Settings
    Bot.Settings.VendorSettings = Bot.VendorState.Settings
    Bot.Settings.TradeManagerSettings = Bot.TradeManagerState.Settings
    Bot.Settings.InventoryDeleteSettings = Bot.InventoryDeleteState.Settings
    Bot.Settings.ConsumablesSettings = Bot.ConsumablesState.Settings
    Bot.Settings.LibConsumablesSettings = LibConsumables.Settings
       Bot.Settings.StartFishingSettings = Bot.StartFishingState.Settings
    Bot.Settings.HookFishHandleGameSettings = Bot.HookFishHandleGameState.Settings
 

    table.merge(Bot.Settings, json:decode(Pyx.FileSystem.ReadFile("Settings.json")))
    if string.len(Bot.Settings.LastProfileName) > 0 then
        ProfileEditor.LoadProfile(Bot.Settings.LastProfileName)
    end

    if Bot.Settings.ConsumablesSettings.Consumables[1] == nil then
        Bot.Settings.ConsumablesSettings.Consumables[1] = { Name = "None", ConditionValue = 3, ConditionName = "Time" }
    end
end

function Bot.StateMoving(state)
    local selfPlayer = GetSelfPlayer()
    local equippedItem = selfPlayer:GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND)
    if equippedItem ~= nil then
        if equippedItem.ItemEnchantStaticStatus.IsFishingRod then
            selfPlayer:UnequipItem(INVENTORY_SLOT_RIGHT_HAND)

        end

    end

end


function Bot.StateComplete(state)
    if state == Bot.TradeManagerState then
        if Bot.Settings.VendorafterTradeManager == true then
            Bot.VendorState.Forced = true
        end
        if Bot.Settings.WarehouseAfterTradeManager == true then
            Bot.WarehouseState.Forced = true
        end
    elseif state == Bot.VendorState then
        if Bot.Settings.WarehouseAfterVendor == true then
            Bot.WarehouseState.Forced = true
        end

    end
    print("State Complete!")
end


function Bot.DeleteItemCheck(item)


    if table.find(Bot.InventoryDeleteState.Settings.DeleteItems, item.ItemEnchantStaticStatus.Name) then
        return true
    elseif Bot.Settings.DeleteUsedRods and item.ItemEnchantStaticStatus.IsFishingRod and item.HasEndurance and item.EndurancePercent <= 0 then
        return true
    end

end

function Bot.ConsumablesCustomRunCheck()
    local selfPlayer = GetSelfPlayer()
    if selfPlayer.CurrentActionName == "WAIT" then
        local equippedItem = selfPlayer:GetEquippedItem(INVENTORY_SLOT_RIGHT_HAND)

        if equippedItem ~= nil and equippedItem.ItemEnchantStaticStatus.IsFishingRod then
            return true
        end

    end
    return false
end

function Bot.CustomWarehouseCheck(item)
    if not table.find(Bot.WarehouseState.Settings.IgnoreItemsNamed, item.ItemEnchantStaticStatus.Name) and item.Type ~= 8 then
        return true
    end
    return false
end

Bot.ResetStats()
