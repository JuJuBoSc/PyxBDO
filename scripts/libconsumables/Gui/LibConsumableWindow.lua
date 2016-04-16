------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

LibConsumableWindow = { }
LibConsumableWindow.Visible = false
LibConsumableWindow.ShowCloseButton = true

------------------------------------------------------------------------------
-- Internal variables (Don't touch this if you don't know what you are doing !)
-----------------------------------------------------------------------------
LibConsumableWindow.InventoryComboSelectedIndex = 0
LibConsumableWindow.InventoryName = { }
LibConsumableWindow.InventorySelectedIndex = 0

LibConsumableWindow.ConditionComboSelectedIndex = 3

LibConsumableWindow.SliderMin = 1
LibConsumableWindow.SliderMax = 120
LibConsumableWindow.SliderValue = 30


-- LibConsumableWindow.CurrenAdd = {Name = "", ConditionName="Time", ConditionValue="30"}
-----------------------------------------------------------------------------
-- LibConsumableWindow Functions
-----------------------------------------------------------------------------

function LibConsumableWindow.DrawLibConsumableWindow()
    local valueChanged = false
    if LibConsumableWindow.Visible then
    local _, shouldDisplay = ImGui.Begin("Consumables", true, ImVec2(610, 250), -1.0)
    if shouldDisplay then
    ImGui.Columns(2)

                if ImGui.Button("Add Consumable", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                    LibConsumableAddWindow.Visible = true
                end
                ImGui.NextColumn()

                if LibConsumableWindow.ShowCloseButton == true and ImGui.Button("Close Window", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                    LibConsumableWindow.Visible = false
                end


                ImGui.Columns(4)
                ImGui.Text("Item :")
                ImGui.NextColumn()
                ImGui.Text("Condition :")
                ImGui.NextColumn()
                ImGui.Text("Value :")
                ImGui.NextColumn()
                ImGui.NextColumn()
                if LibConsumables.Settings == nil then
                print("LibConsumables.Settings nil")
                LibConsumables.Settings = ConsumablesState().Settings
                end
                for key,value in pairs(LibConsumables.Settings.Consumables) do
                if value.Name ~= nil then
                ImGui.Text(value.Name)
                end

                ImGui.NextColumn()
                if value.ConditionName ~= nil then
                ImGui.Text(value.ConditionName)
                end
                ImGui.NextColumn()
                if value.ConditionValue ~= nil then
                if value.ConditionName == "Is Usable" then
                ImGui.Text("When Available")
                else
                ImGui.Text(value.ConditionValue)
                end
                end
                ImGui.NextColumn()
                if ImGui.SmallButton("Delete##"..key) then --, ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                    table.remove(LibConsumables.Settings.Consumables, key)
                end
                ImGui.NextColumn()

                end
    end
    ImGui.End()
    end
end

function LibConsumableWindow.OnDrawGuiCallback()
    LibConsumableWindow.DrawLibConsumableWindow()
end


function LibConsumableWindow.UpdateInventoryList()
    LibConsumableWindow.InventoryName = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k, v in pairs(selfPlayer.Inventory.Items) do

            if not table.find(LibConsumableWindow.InventoryName, v.ItemEnchantStaticStatus.Name) then
                table.insert(LibConsumableWindow.InventoryName, v.ItemEnchantStaticStatus.Name)
                --            print("Added: "..v.ItemEnchantStaticStatus.Name)
            end
        end
    end
end
