------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

MainWindow = { }
------------------------------------------------------------------------------
-- Internal variables (Don't touch this if you don't know what you are doing !)
-----------------------------------------------------------------------------
MainWindow.InventoryComboSelectedIndex = 0
MainWindow.InventoryName = { }
MainWindow.InventorySelectedIndex = 0

MainWindow.WarehouseComboSelectedIndex = 0
MainWindow.WarehouseSelectedIndex = 0
MainWindow.WarehouseName = { }


MainWindow.BaitComboBoxItems = { }
MainWindow.BaitComboBoxSelected = 0

-----------------------------------------------------------------------------
-- MainWindow Functions
-----------------------------------------------------------------------------

function MainWindow.DrawMainWindow()
    local valueChanged = false
    local _, shouldDisplay = ImGui.Begin("Fisher", true, ImVec2(400, 400), -1.0)
    if shouldDisplay then
        if ImGui.CollapsingHeader("Bot status", "id_gui_status", true, true) then
            local player = GetSelfPlayer()
            ImGui.Columns(2)
            ImGui.Text("State")
            ImGui.NextColumn()
            ImGui.Text(( function() if Bot.Running and Bot.Fsm.CurrentState then return Bot.Fsm.CurrentState.Name else return 'N/A' end end)(player))
            ImGui.NextColumn()
            ImGui.Text("Name")
            ImGui.NextColumn()
            ImGui.Text(( function(player) if player then return player.Name else return 'Disconnected' end end)(player))
            ImGui.NextColumn()
            ImGui.Columns(1)
            if not Bot.Running then
                if ImGui.Button("Start##btn_start_bot", ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                    Bot.Start()
                end
                ImGui.SameLine()
                if ImGui.Button("Profile editor", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                    ProfileEditor.Visible = true
                end
            else
                if ImGui.Button("Stop##btn_stop_bot", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                    Bot.Stop()
                end
                if ImGui.Button("Force trade manager##btn_force_trademanager", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                    Bot.TradeManagerState.Forced = true
                end
            end
            if ImGui.Button("Consumables##btn_con_show", ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                LibConsumableWindow.Visible = true
            end

        end
        if ImGui.CollapsingHeader("Bait", "id_gui_fish_bait", true, false) then
            MainWindow.UpdateBaitComboBox()
            if not table.find(MainWindow.BaitComboBoxItems, Bot.Settings.ConsumablesSettings.Consumables[1].Name) then
                table.insert(MainWindow.BaitComboBoxItems, Bot.Settings.ConsumablesSettings.Consumables[1].Name)
            end
            valueChanged, MainWindow.BaitComboBoxSelected = ImGui.Combo("Bait##id_gui_fish_bait_to_use", table.findIndex(MainWindow.BaitComboBoxItems, Bot.Settings.ConsumablesSettings.Consumables[1].Name), MainWindow.BaitComboBoxItems)

            if valueChanged then
                Bot.Settings.ConsumablesSettings.Consumables[1].Name = MainWindow.BaitComboBoxItems[MainWindow.BaitComboBoxSelected]
                print("Bait selected : " .. Bot.Settings.ConsumablesSettings.Consumables[1].Name)
            end
            _, Bot.Settings.ConsumablesSettings.Consumables[1].ConditionValue = ImGui.SliderInt("Mins Lasts for##id_gui_bait_lasts", tonumber(Bot.Settings.ConsumablesSettings.Consumables[1].ConditionValue), 1, 120)
        end
        if ImGui.CollapsingHeader("Trade Manager", "id_gui_trademanager", true, false) then
            _, Bot.Settings.TradeManagerSettings.TradeManagerOnInventoryFull = ImGui.Checkbox("Sell at trade manager when inventory is full##id_guid_trademanager_full_inventory", Bot.Settings.TradeManagerSettings.TradeManagerOnInventoryFull)
        end

        if ImGui.CollapsingHeader("Looting", "id_gui_looting", true, false) then
            _, Bot.Settings.IgnoreUntradeAbleItems = ImGui.Checkbox("Ignore untradeable items##id_guid_looting_ignore_untradeable", Bot.Settings.IgnoreUntradeAbleItems)
            _, Bot.Settings.LootWhite = ImGui.Checkbox("Loot whites##id_guid_loot_white", Bot.Settings.LootWhite)
            _, Bot.Settings.LootGreen = ImGui.Checkbox("Loot greens##id_guid_loot_green", Bot.Settings.LootGreen)
            _, Bot.Settings.LootBlue = ImGui.Checkbox("Loot blues##id_guid_loot_blue", Bot.Settings.LootBlue)
            _, Bot.Settings.LootKey = ImGui.Checkbox("Loot keys##id_guid_loot_key", Bot.Settings.LootKey)
            _, Bot.Settings.LootRelic = ImGui.Checkbox("Loot shards##id_guid_loot_relic", Bot.Settings.LootRelic)
            _, Bot.Settings.LootAndDeleteUnwantedFish = ImGui.Checkbox("Loot and delete unwanted fish##id_guid_loot_and_delete_unwanted_fish", Bot.Settings.LootAndDeleteUnwantedFish)
        end
        MainWindow.UpdateInventoryList()
        if ImGui.CollapsingHeader("Inventory Management", "id_gui_inv_manage", true, false) then
            _, Bot.Settings.DeleteUsedRods = ImGui.Checkbox("Delete Used Up Fishing Rods##id_guid_inv_Man_oldrods", Bot.Settings.DeleteUsedRods)
            ImGui.Text("Always Delete these Items")
            valueChanged, MainWindow.InventoryComboSelectedIndex = ImGui.Combo("##id_guid_inv_inventory_combo_select", MainWindow.InventoryComboSelectedIndex, MainWindow.InventoryName)
            if valueChanged then
                local inventoryName = MainWindow.InventoryName[MainWindow.InventoryComboSelectedIndex]
                if not table.find(Bot.Settings.InventoryDeleteSettings.DeleteItems, inventoryName) then

                    table.insert(Bot.Settings.InventoryDeleteSettings.DeleteItems, inventoryName)
                end
                MainWindow.InventoryComboSelectedIndex = 0
            end
            _, MainWindow.InventorySelectedIndex = ImGui.ListBox("##id_guid_inv_Delete", MainWindow.InventorySelectedIndex, Bot.Settings.InventoryDeleteSettings.DeleteItems, 5)
            if ImGui.Button("Remove Item##id_guid_inv_delete_remove", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                if MainWindow.InventorySelectedIndex > 0 and MainWindow.InventorySelectedIndex <= table.length(Bot.Settings.InventoryDeleteSettings.DeleteItems) then
                    table.remove(Bot.Settings.InventoryDeleteSettings.DeleteItems, MainWindow.InventorySelectedIndex)
                    MainWindow.InventorySelectedIndex = 0
                end
            end
        end
        if ImGui.CollapsingHeader("Vendor Selling", "id_gui_vendor", true, false) then
            _, Bot.Settings.VendorSettings.VendorOnInventoryFull = ImGui.Checkbox("Vendor when inventory is full##id_guid_vendor_full_inventory", Bot.Settings.VendorSettings.VendorOnInventoryFull)
            _, Bot.Settings.VendorafterTradeManager = ImGui.Checkbox("Vendor after Trader##id_guid_vendor_full_inventory", Bot.Settings.VendorafterTradeManager)
            _, Bot.Settings.VendorSettings.VendorOnWeight = ImGui.Checkbox("Vendor when you are too heavy##id_guid_vendor_weight", Bot.Settings.VendorSettings.VendorOnWeight)
            _, Bot.Settings.VendorSettings.VendorWhite = ImGui.Checkbox("##id_guid_vendor_sell_white", Bot.Settings.VendorSettings.VendorWhite)
            ImGui.SameLine()
            ImGui.TextColored(ImVec4(1, 1, 1, 1), "Sell white")
            _, Bot.Settings.VendorSettings.VendorGreen = ImGui.Checkbox("##id_guid_vendor_sell_green", Bot.Settings.VendorSettings.VendorGreen)
            ImGui.SameLine()
            ImGui.TextColored(ImVec4(0.20, 1, 0.20, 1), "Sell green")
            _, Bot.Settings.VendorSettings.VendorBlue = ImGui.Checkbox("##id_guid_vendor_sell_blue", Bot.Settings.VendorSettings.VendorBlue)
            ImGui.SameLine()
            ImGui.TextColored(ImVec4(0.40, 0.6, 1, 1), "Sell blue")

            valueChanged, MainWindow.InventoryComboSelectedIndex = ImGui.Combo("##id_guid_vendor_inventory_combo_select", MainWindow.InventoryComboSelectedIndex, MainWindow.InventoryName)
            if valueChanged then
                local inventoryName = MainWindow.InventoryName[MainWindow.InventoryComboSelectedIndex]
                if not table.find(Bot.Settings.VendorSettings.IgnoreItemsNamed, inventoryName) then

                    table.insert(Bot.Settings.VendorSettings.IgnoreItemsNamed, inventoryName)
                end
                MainWindow.InventoryComboSelectedIndex = 0
            end
            _, MainWindow.InventorySelectedIndex = ImGui.ListBox("##id_guid_vendor_neversell", MainWindow.InventorySelectedIndex, Bot.Settings.VendorSettings.IgnoreItemsNamed, 5)
            if ImGui.Button("Remove Item##id_guid_vendor_neversell_remove", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                if MainWindow.InventorySelectedIndex > 0 and MainWindow.InventorySelectedIndex <= table.length(Bot.Settings.VendorSettings.IgnoreItemsNamed) then
                    table.remove(Bot.Settings.VendorSettings.IgnoreItemsNamed, MainWindow.InventorySelectedIndex)
                    MainWindow.InventorySelectedIndex = 0
                end
            end

        end
        if ImGui.CollapsingHeader("Vendor Buying", "id_gui_vendor_buy", true, false) then
            valueChanged, MainWindow.InventoryComboSelectedIndex = ImGui.Combo("Select Item##id__vendor_buy_combo_select", MainWindow.InventoryComboSelectedIndex, MainWindow.InventoryName)
            if valueChanged then
                local inventoryName = MainWindow.InventoryName[MainWindow.InventoryComboSelectedIndex]
                local found = false
                for key, value in pairs(Bot.VendorState.Settings.BuyItems) do
                    if value.Name == inventoryName then
                        found = true
                    end
                end
                if found == false then
                    table.insert(Bot.VendorState.Settings.BuyItems, { Name = inventoryName, BuyAt = 0, BuyMax = 1 })
                end
                MainWindow.InventoryComboSelectedIndex = 0
            end
            ImGui.Columns(3)
            ImGui.Text("Name")
            ImGui.NextColumn()
            ImGui.Text("Buy At")
            ImGui.NextColumn()
            ImGui.Text("Total")
            ImGui.NextColumn()
            local vbCount = table.length(Bot.VendorState.Settings.BuyItems)
            for key = 1, vbCount do
            local value = Bot.VendorState.Settings.BuyItems[key]
            local erase = false
--            for key, value in pairs(Bot.VendorState.Settings.BuyItems) do
            if ImGui.SmallButton("X##vb_del_"..key) then
            erase = true
            end
            ImGui.SameLine()
            if value ~= nil then
                ImGui.Text(value.Name)
                ImGui.NextColumn()
                valueChanged, Bot.VendorState.Settings.BuyItems[key].BuyAt = ImGui.InputFloat("Min##vb_min_"..key, Bot.VendorState.Settings.BuyItems[key].BuyAt, 1, 10, 0, 0)
                if valueChanged then
                    if Bot.VendorState.Settings.BuyItems[key].BuyAt < 0 then
                        Bot.VendorState.Settings.BuyItems[key].BuyAt = 0
                    end
                    if Bot.VendorState.Settings.BuyItems[key].BuyAt > 250 then
                        Bot.VendorState.Settings.BuyItems[key].BuyAt = 250
                    end
                end
                --            _, Bot.VendorState.Settings.BuyItems[key].BuyAt = ImGui.SliderInt("Min##id_gui_vbuy_min_"..key, tonumber(Bot.VendorState.Settings.BuyItems[key].BuyAt), 0, 250)
                ImGui.NextColumn()
                valueChanged, Bot.VendorState.Settings.BuyItems[key].BuyMax = ImGui.InputFloat("Max##vb_max_"..key, Bot.VendorState.Settings.BuyItems[key].BuyMax, 1, 10, 0, 0)
                if valueChanged then
                    if Bot.VendorState.Settings.BuyItems[key].BuyMax < 1 then
                        Bot.VendorState.Settings.BuyItems[key].BuyMax = 1
                    end
                    if Bot.VendorState.Settings.BuyItems[key].BuyMax > 500 then
                        Bot.VendorState.Settings.BuyItems[key].BuyMax = 500
                    end
                end
                ImGui.NextColumn()
                if erase then
                table.remove(Bot.VendorState.Settings.BuyItems,key)
                vbCount = vbCount -1
                end
                end
            end
            ImGui.Columns(1)
        end
        if ImGui.CollapsingHeader("Warehouse", "id_gui_warehouse", true, false) then
            _, Bot.Settings.WarehouseAfterVendor = ImGui.Checkbox("Deposit after Vendor##id_guid_warehouse_after_vendor", Bot.Settings.WarehouseAfterVendor)
            _, Bot.Settings.WarehouseAfterTradeManager = ImGui.Checkbox("Deposit after trader##id_guid_warehouse_after_trader", Bot.Settings.WarehouseAfterTradeManager)
            _, Bot.Settings.WarehouseSettings.DepositMoney = ImGui.Checkbox("Deposit Money##id_guid_warehouse_deposit_money", Bot.Settings.WarehouseSettings.DepositMoney)
            _, Bot.Settings.WarehouseSettings.MoneyToKeep = ImGui.SliderInt("Money to Keep##id_gui_warehouse_keep_money", Bot.Settings.WarehouseSettings.MoneyToKeep, 0, 1000000)
            _, Bot.Settings.WarehouseSettings.DepositItems = ImGui.Checkbox("Deposit Items##id_guid_warehouse_deposit_items", Bot.Settings.WarehouseSettings.DepositItems)
            ImGui.Text("Never Deposit these Items")
            valueChanged, MainWindow.WarehouseComboSelectedIndex = ImGui.Combo("##id_guid_warehouse_inventory_combo_select", MainWindow.WarehouseComboSelectedIndex, MainWindow.InventoryName)
            if valueChanged then
                local inventoryName = MainWindow.InventoryName[MainWindow.WarehouseComboSelectedIndex]
                if not table.find(Bot.Settings.WarehouseSettings.IgnoreItemsNamed, inventoryName) then

                    table.insert(Bot.Settings.WarehouseSettings.IgnoreItemsNamed, inventoryName)
                end
                MainWindow.WarehouseComboSelectedIndex = 0
            end
            _, MainWindow.WarehouseSelectedIndex = ImGui.ListBox("##id_guid_warehouse_neverdeposit", MainWindow.WarehouseSelectedIndex, Bot.Settings.WarehouseSettings.IgnoreItemsNamed, 5)
            if ImGui.Button("Remove Item##id_guid_warehouse_neverdeposit_remove", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                if MainWindow.WarehouseSelectedIndex > 0 and MainWindow.WarehouseSelectedIndex <= table.length(Bot.Settings.NeverWarehouse) then
                    table.remove(Bot.Settings.WarehouseSettings.IgnoreItemsNamed, MainWindow.WarehouseSelectedIndex)
                    MainWindow.WarehouseSelectedIndex = 0
                end
            end

        end
        if ImGui.CollapsingHeader("Cheats", "id_gui_fish_cheats", true, false) then
            _, Bot.Settings.TradeManagerSettings.DoTradeGame = ImGui.Checkbox("Play/Win Trade game##id_guid_trademanager_do_game", Bot.Settings.TradeManagerSettings.DoTradeGame)
            _, Bot.Settings.HookFishHandleGameSettings.InstantFish = ImGui.Checkbox("Fast Fish game##id_guid_fish_fast_game", Bot.Settings.HookFishHandleGameSettings.InstantFish)
            _, Bot.Settings.StartFishingSettings.MaxEnergyCheat = ImGui.Checkbox("Max Energy Cast (uses no energy)##id_guid_hook_fast_game", Bot.Settings.StartFishingSettings.MaxEnergyCheat)
        end

        if ImGui.CollapsingHeader("Stats","id_gui_stats", true, false) then
            if ImGui.Button("Reset Stats##id_guid_reset_stats", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                Bot.ResetStats()
            end

            local statLog = ""

            statLog = statLog .. string.format("Loots: %i\n", Bot.Stats.Loots)
            statLog = statLog .. string.format("Loot Time: %.02f\n", Bot.Stats.AverageLootTime)

            if Bot.Stats.Loots > 0 then
                statLog = statLog .. string.format("Whites: %i - %.02f%%\n", Bot.Stats.LootQuality[0] or 0, (Bot.Stats.LootQuality[0] or 0) / Bot.Stats.Loots * 100)
                statLog = statLog .. string.format("Greens: %i - %.02f%%\n", Bot.Stats.LootQuality[1] or 0, (Bot.Stats.LootQuality[1] or 0) / Bot.Stats.Loots * 100)
                statLog = statLog .. string.format("Blues: %i - %.02f%%\n", Bot.Stats.LootQuality[2] or 0, (Bot.Stats.LootQuality[2] or 0) / Bot.Stats.Loots * 100)
                statLog = statLog .. string.format("Yellows: %i - %.02f%%\n", Bot.Stats.LootQuality[3] or 0, (Bot.Stats.LootQuality[3] or 0) / Bot.Stats.Loots * 100)
                statLog = statLog .. string.format("Oranges: %i - %.02f%%\n", Bot.Stats.LootQuality[4] or 0, (Bot.Stats.LootQuality[4] or 0) / Bot.Stats.Loots * 100)
                statLog = statLog .. string.format("Keys: %i - %.02f%%\n", Bot.Stats.Keys, Bot.Stats.Keys / Bot.Stats.Loots * 100)
                statLog = statLog .. string.format("Relics: %i - %.02f%%\n", Bot.Stats.Relics, Bot.Stats.Relics / Bot.Stats.Loots * 100)
            end

            local conSize = ImGui.GetContentRegionAvail()
            ImGui.InputTextMultiline("stat_log", statLog, 1024000, ImVec2(conSize.x, 15 * 9), ImGuiInputTextFlags_AutoSelectAll|ImGuiInputTextFlags_ReadOnly)
        end
        ImGui.End()
    end
end

function MainWindow.OnDrawGuiCallback()
    MainWindow.DrawMainWindow()
end


function MainWindow.UpdateInventoryList()
    MainWindow.InventoryName = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(selfPlayer.Inventory.Items) do

            if not table.find(MainWindow.InventoryName, v.ItemEnchantStaticStatus.Name) then
                table.insert(MainWindow.InventoryName, v.ItemEnchantStaticStatus.Name)
                --            print("Added: "..v.ItemEnchantStaticStatus.Name)
            end
        end
    end
end

function MainWindow.UpdateBaitComboBox()
    MainWindow.BaitComboBoxItems = { "None" }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(selfPlayer.Inventory.Items) do
            if v.ItemEnchantStaticStatus.Type == 2 then
                if not table.find(MainWindow.BaitComboBoxItems, v.ItemEnchantStaticStatus.Name) then
                    table.insert(MainWindow.BaitComboBoxItems, v.ItemEnchantStaticStatus.Name)
                end
            end
        end
    end
end
