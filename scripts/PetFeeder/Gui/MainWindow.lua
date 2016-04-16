------------------------------------------------------------------------------
-- Version .2 by Triplany 2016-03-28
-----------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

MainWindow = { }
MainWindow.FoodComboBoxItems = {}
MainWindow.FoodComboBoxSelected = 0

------------------------------------------------------------------------------
-- Internal variables (Don't touch this if you don't know what you are doing !)
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- MainWindow Functions
-----------------------------------------------------------------------------

function MainWindow.DrawMainWindow()
    local valueChanged = false
    local petsOut = Pets.GetUnsealedPetCount()
    local _, shouldDisplay = ImGui.Begin("Pet Feeder", true, ImVec2(338, 142), -1.0)
    if shouldDisplay then
        ImGui.Columns(2)
        ImGui.Text("Pets Out")
        ImGui.NextColumn()
        if petsOut == nil then
            ImGui.Text("Unknown")
        else
            ImGui.Text(petsOut)
        end
        ImGui.NextColumn()
        ImGui.Text("Food Left")
        ImGui.NextColumn()
        ImGui.Text(MainWindow.GetFoodLeft())
        ImGui.Columns(1)
        

        if ImGui.CollapsingHeader("Settings", "id_gui_food", true, false) then
            MainWindow.UpdateFoodComboBox()
            if not table.find(MainWindow.FoodComboBoxItems, Bot.Settings.FoodName) then
                table.insert(MainWindow.FoodComboBoxItems, Bot.Settings.FoodName)
            end
            valueChanged, MainWindow.FoodComboBoxSelected = ImGui.Combo("Pet Food##id_gui_pet_food", table.findIndex(MainWindow.FoodComboBoxItems, Bot.Settings.FoodName), MainWindow.FoodComboBoxItems)
            if valueChanged then
                Bot.Settings.FoodName = MainWindow.FoodComboBoxItems[MainWindow.FoodComboBoxSelected]   
                print("Pet Food selected : " .. Bot.Settings.FoodName)
            end
            valueChanged, Bot.Settings.FoodPercent = ImGui.SliderInt("Health percent##id_gui_pet_food_health_pct", Bot.Settings.FoodPercent, 1, 100)
        end
        ImGui.End()
    end
end

function MainWindow.OnDrawGuiCallback()
    MainWindow.DrawMainWindow()
end

function MainWindow.GetFoodLeft()
    local selfPlayer = GetSelfPlayer()

    if selfPlayer then
        for k,v in pairs(selfPlayer.Inventory.Items) do
            if v.ItemEnchantStaticStatus.Name == Bot.Settings.FoodName then
            return v.Count
            end
        end
    end
    
return 0
end


function MainWindow.UpdateFoodComboBox()
    MainWindow.FoodComboBoxItems = { "None" }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k,v in pairs(selfPlayer.Inventory.Items) do
            if v.ItemEnchantStaticStatus.Type == 10 then
                if not table.find(MainWindow.FoodComboBoxItems, v.ItemEnchantStaticStatus.Name) then
                    table.insert(MainWindow.FoodComboBoxItems, v.ItemEnchantStaticStatus.Name)
                end
            end
        end
    end
end


