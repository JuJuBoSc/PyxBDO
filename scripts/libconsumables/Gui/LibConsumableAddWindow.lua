------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

LibConsumableAddWindow = { }
------------------------------------------------------------------------------
-- Internal variables (Don't touch this if you don't know what you are doing !)
-----------------------------------------------------------------------------
LibConsumableAddWindow.Visible = false

LibConsumableAddWindow.InventoryComboSelectedIndex = 0
LibConsumableAddWindow.InventoryName = { }
LibConsumableAddWindow.InventorySelectedIndex = 0

LibConsumableAddWindow.ConditionComboSelectedIndex = 3

LibConsumableAddWindow.SliderMin = 1
LibConsumableAddWindow.SliderMax = 120
LibConsumableAddWindow.SliderValue = 30



-- LibConsumableAddWindow.CurrenAdd = {Name = "", ConditionName="Time", ConditionValue="30"}
-----------------------------------------------------------------------------
-- LibConsumableAddWindow Functions
-----------------------------------------------------------------------------

function LibConsumableAddWindow.DrawLibConsumableAddWindow()
    local valueChanged = false
    if LibConsumableAddWindow.Visible then
        local _, shouldDisplay = ImGui.Begin("Add Consumable", true, ImVec2(290, 160), -1.0)
        if shouldDisplay then
            LibConsumableAddWindow.UpdateInventoryList()
            _, LibConsumableAddWindow.InventoryComboSelectedIndex = ImGui.Combo("Item##id_guid_con_inventory_combo_select_trip", LibConsumableAddWindow.InventoryComboSelectedIndex, LibConsumableAddWindow.InventoryName)
            valueChanged, LibConsumableAddWindow.ConditionComboSelectedIndex = ImGui.Combo("Condition##id_guid_con_condition_combo_select_trip", LibConsumableAddWindow.ConditionComboSelectedIndex, ConsumablesState.Conditions)
            if valueChanged then
                if LibConsumableAddWindow.ConditionComboSelectedIndex == 1 or LibConsumableAddWindow.ConditionComboSelectedIndex == 2 then
                    LibConsumableAddWindow.SliderMax = 100
                    LibConsumableAddWindow.SliderMin = 1
                    LibConsumableAddWindow.SliderValue = 50
                elseif LibConsumableAddWindow.ConditionComboSelectedIndex == 3 then
                    LibConsumableAddWindow.SliderMax = 120
                    LibConsumableAddWindow.SliderMin = 1
                    LibConsumableAddWindow.SliderValue = 30
                end
            end
            if LibConsumableAddWindow.ConditionComboSelectedIndex >= 1 and LibConsumableAddWindow.ConditionComboSelectedIndex <= 3 then
                local strAdd = "%"
                if LibConsumableAddWindow.ConditionComboSelectedIndex == 3 then
                    strAdd = "Mins"
                end
                _, LibConsumableAddWindow.SliderValue = ImGui.SliderInt(strAdd .. "##id_gui_con_slider_trip", LibConsumableAddWindow.SliderValue, LibConsumableAddWindow.SliderMin, LibConsumableAddWindow.SliderMax)
            elseif LibConsumableAddWindow.ConditionComboSelectedIndex == 4 then
                ImGui.Text("When Usable")
            end

            if ImGui.Button("Add", ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                if LibConsumableAddWindow.InventoryComboSelectedIndex > 0 then
                    local inventoryName = LibConsumableAddWindow.InventoryName[LibConsumableAddWindow.InventoryComboSelectedIndex]
                    local newItem = {
                        Name = inventoryName,
                        ConditionName = ConsumablesState.Conditions[LibConsumableAddWindow.ConditionComboSelectedIndex],
                        ConditionValue = LibConsumableAddWindow.SliderValue
                    }
                    if LibConsumables.Settings.Consumables == nil then
                    print("LibConsumables.Settings.Consumables")
                    LibConsumables.Settings.Consumables = {}
                    end
                    if not table.find(LibConsumables.Settings.Consumables, newItem) then
                        table.insert(LibConsumables.Settings.Consumables, newItem)
                    end
                    LibConsumableAddWindow.Visible = false
                end
            end
            ImGui.SameLine()
            if ImGui.Button("Cancel", ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                LibConsumableAddWindow.Visible = false
            end
        end
        ImGui.End()

    end
end

function LibConsumableAddWindow.OnDrawGuiCallback()
    LibConsumableAddWindow.DrawLibConsumableAddWindow()
end


function LibConsumableAddWindow.UpdateInventoryList()
    LibConsumableAddWindow.InventoryName = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(selfPlayer.Inventory.Items) do

            if not table.find(LibConsumableAddWindow.InventoryName, v.ItemEnchantStaticStatus.Name) then
                table.insert(LibConsumableAddWindow.InventoryName, v.ItemEnchantStaticStatus.Name)
                --            print("Added: "..v.ItemEnchantStaticStatus.Name)
            end
        end
    end
end
