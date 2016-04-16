------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

ProfileEditor = { }
ProfileEditor.Visible = false
ProfileEditor.CurrentProfile = Profile()
ProfileEditor.AvailablesProfilesSelectedIndex = 0
ProfileEditor.AvailablesProfiles = { }
ProfileEditor.AttackableMonstersSelectedIndex = 0
ProfileEditor.AttackableMonstersComboSelectedIndex = 0
ProfileEditor.MonstersName = { }
ProfileEditor.CurrentProfileSaveName = "Unamed"

-----------------------------------------------------------------------------
-- ProfileEditor Functions
-----------------------------------------------------------------------------

function ProfileEditor.DrawProfileEditor()
    local shouldDraw
    if ProfileEditor.Visible then
        _, ProfileEditor.Visible = ImGui.Begin("Profile editor", ProfileEditor.Visible, ImVec2(300, 400), -1.0)
        
        _, ProfileEditor.CurrentProfileSaveName = ImGui.InputText("##profile_save_name", ProfileEditor.CurrentProfileSaveName)
        ImGui.SameLine()
        if ImGui.Button("Save") then
            ProfileEditor.SaveProfile(ProfileEditor.CurrentProfileSaveName)
        end
        
        _, ProfileEditor.AvailablesProfilesSelectedIndex = ImGui.Combo("##profile_load_combo", ProfileEditor.AvailablesProfilesSelectedIndex, ProfileEditor.AvailablesProfiles)
        ImGui.SameLine()
        if ImGui.Button("Load") then
            ProfileEditor.LoadProfile(ProfileEditor.AvailablesProfiles[ProfileEditor.AvailablesProfilesSelectedIndex])
        end
        
        if ImGui.Button("Clear profile##id_profile_clear", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
            Navigation.ClearMesh()
            ProfileEditor.CurrentProfile = Profile()
            ProfileEditor.CurrentProfileSaveName = "Unamed"
        end
        
        if ImGui.CollapsingHeader("Mesher", "id_profile_editor_mesh", true, true) then
            _,Navigation.MesherEnabled = ImGui.Checkbox("Enable mesher##profile_enable_mesher", Navigation.MesherEnabled)
            ImGui.SameLine();
            _,Navigation.RenderMesh = ImGui.Checkbox("Draw geometry##profile_draw_mesher", Navigation.RenderMesh)
            if ImGui.Button("Build navigation##id_profile_editor_build_navigation", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                Navigation.BuildNavigation()
            end
        end
        
        if ImGui.CollapsingHeader("Fishing spot", "id_profile_editor_fishing_spot", true, false) then
            if ProfileEditor.CurrentProfile:HasFishSpot() then
                ImGui.Text("Distance : " .. math.floor(ProfileEditor.CurrentProfile:GetFishSpotPosition().Distance3DFromMe) / 100)
            else
                ImGui.Text("Distance : Not set")
            end
            if ImGui.Button("Set##id_profile_set_fishing_spot" , ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                local selfPlayer = GetSelfPlayer()
                if selfPlayer then
                    ProfileEditor.CurrentProfile.FishSpotPosition.X = selfPlayer.Position.X
                    ProfileEditor.CurrentProfile.FishSpotPosition.Y = selfPlayer.Position.Y
                    ProfileEditor.CurrentProfile.FishSpotPosition.Z = selfPlayer.Position.Z
                    ProfileEditor.CurrentProfile.FishSpotRotation = selfPlayer.Rotation
                end
            end
            ImGui.SameLine()
            if ImGui.Button("Clear##id_profile_clear_fishing_spot", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                ProfileEditor.CurrentProfile.TradeManagerNpcName = ""
                ProfileEditor.CurrentProfile.FishSpotPosition.X = 0
                ProfileEditor.CurrentProfile.FishSpotPosition.Y = 0
                ProfileEditor.CurrentProfile.FishSpotPosition.Z = 0
                ProfileEditor.CurrentProfile.FishSpotRotation = 0
            end
        end
        
        if ImGui.CollapsingHeader("TradeManager npc", "id_profile_editor_TradeManager", true, false) then
            if string.len(ProfileEditor.CurrentProfile.TradeManagerNpcName) > 0 then
                ImGui.Text("Name : " .. ProfileEditor.CurrentProfile.TradeManagerNpcName .. " (" .. math.floor(ProfileEditor.CurrentProfile:GetTradeManagerPosition().Distance3DFromMe / 100) .. "y)")
            else
                ImGui.Text("Name : Not set")
            end
            if ImGui.Button("Set##id_profile_set_TradeManager" , ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                local npcs = GetNpcs()
                if table.length(npcs) > 0 then
                    local TradeManagerNpc = npcs[1]
                    ProfileEditor.CurrentProfile.TradeManagerNpcName = TradeManagerNpc.Name
                    ProfileEditor.CurrentProfile.TradeManagerNpcPosition.X = TradeManagerNpc.Position.X
                    ProfileEditor.CurrentProfile.TradeManagerNpcPosition.Y = TradeManagerNpc.Position.Y
                    ProfileEditor.CurrentProfile.TradeManagerNpcPosition.Z = TradeManagerNpc.Position.Z
                end
            end
            ImGui.SameLine()
            if ImGui.Button("Clear##id_profile_clear_TradeManager", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                ProfileEditor.CurrentProfile.TradeManagerNpcName = ""
                ProfileEditor.CurrentProfile.TradeManagerNpcPosition.X = 0
                ProfileEditor.CurrentProfile.TradeManagerNpcPosition.Y = 0
                ProfileEditor.CurrentProfile.TradeManagerNpcPosition.Z = 0
            end
        end
                if ImGui.CollapsingHeader("Vendor npc", "id_profile_editor_Vendor", true, false) then
            if string.len(ProfileEditor.CurrentProfile.VendorNpcName) > 0 then
                ImGui.Text("Name : " .. ProfileEditor.CurrentProfile.VendorNpcName .. " (" .. math.floor(ProfileEditor.CurrentProfile:GetVendorPosition().Distance3DFromMe / 100) .. "y)")
            else
                ImGui.Text("Name : Not set")
            end
            if ImGui.Button("Set##id_profile_set_Vendor" , ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                local npcs = GetNpcs()
                if table.length(npcs) > 0 then
                    local VendorNpc = npcs[1]
                    ProfileEditor.CurrentProfile.VendorNpcName = VendorNpc.Name
                    ProfileEditor.CurrentProfile.VendorNpcPosition.X = VendorNpc.Position.X
                    ProfileEditor.CurrentProfile.VendorNpcPosition.Y = VendorNpc.Position.Y
                    ProfileEditor.CurrentProfile.VendorNpcPosition.Z = VendorNpc.Position.Z
                end
            end
            ImGui.SameLine()
            if ImGui.Button("Clear##id_profile_clear_Vendor", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                ProfileEditor.CurrentProfile.VendorNpcName = ""
                ProfileEditor.CurrentProfile.VendorNpcPosition.X = 0
                ProfileEditor.CurrentProfile.VendorNpcPosition.Y = 0
                ProfileEditor.CurrentProfile.VendorNpcPosition.Z = 0
            end
        end

        if ImGui.CollapsingHeader("Warehouse npc", "id_profile_editor_Warehouse", true, false) then
            if string.len(ProfileEditor.CurrentProfile.WarehouseNpcName) > 0 then
                ImGui.Text("Name : " .. ProfileEditor.CurrentProfile.WarehouseNpcName .. " (" .. math.floor(ProfileEditor.CurrentProfile:GetWarehousePosition().Distance3DFromMe / 100) .. "y)")
            else
                ImGui.Text("Warehouse : Not set")
            end
            if ImGui.Button("Set##id_profile_set_Warehouse" , ImVec2(ImGui.GetContentRegionAvailWidth() / 2, 20)) then
                local npcs = GetNpcs()
                if table.length(npcs) > 0 then
                    local WarehouseNpc = npcs[1]
                    ProfileEditor.CurrentProfile.WarehouseNpcName = WarehouseNpc.Name
                    ProfileEditor.CurrentProfile.WarehouseNpcPosition.X = WarehouseNpc.Position.X
                    ProfileEditor.CurrentProfile.WarehouseNpcPosition.Y = WarehouseNpc.Position.Y
                    ProfileEditor.CurrentProfile.WarehouseNpcPosition.Z = WarehouseNpc.Position.Z
                end
            end
            ImGui.SameLine()
            if ImGui.Button("Clear##id_profile_clear_Warehouse", ImVec2(ImGui.GetContentRegionAvailWidth(), 20)) then
                ProfileEditor.CurrentProfile.WarehouseNpcName = ""
                ProfileEditor.CurrentProfile.WarehouseNpcPosition.X = 0
                ProfileEditor.CurrentProfile.WarehouseNpcPosition.Y = 0
                ProfileEditor.CurrentProfile.WarehouseNpcPosition.Z = 0
            end
        end
        
        ImGui.End()
    end
end

function ProfileEditor.RefreshAvailableProfiles()
    ProfileEditor.AvailablesProfiles = { }
    for k,v in pairs(Pyx.FileSystem.GetFiles("Profiles\\*.json")) do
        v = string.gsub(v, ".json", "")
        table.insert(ProfileEditor.AvailablesProfiles, v)
    end
end



function ProfileEditor.SaveProfile(name)
    


    local profileFilename = "\\Profiles\\" .. name .. ".json"
    local meshFilename = "\\Profiles\\" .. name .. ".mesh"
    local objFilename = "\\Profiles\\" .. name .. ".obj"
    
    --Navigation.ExportWavefrontObject(objFilename)
    
    print("Save mesh : " .. meshFilename)
    if not Navigation.SaveMesh(meshFilename) then
        print("Unable to save .mesh !")
        return
    end
    
    Bot.Settings.LastProfileName = name
    
    local json = JSON:new()
    Pyx.FileSystem.WriteFile(profileFilename, json:encode_pretty(ProfileEditor.CurrentProfile))
    ProfileEditor.RefreshAvailableProfiles()
    
end

function ProfileEditor.LoadProfile(name)
    
    local profileFilename = "\\Profiles\\" .. name .. ".json"
    local meshFilename = "\\Profiles\\" .. name .. ".mesh"
    
    print("Load mesh : " .. meshFilename)
    if not Navigation.LoadMesh(meshFilename) then
        print("Unable to load .mesh !")
        return
    end
    
    Bot.Settings.LastProfileName = name
    ProfileEditor.CurrentProfileSaveName = name
    
    ProfileEditor.AttackableMonstersSelectedIndex = 0
    ProfileEditor.AttackableMonstersComboSelectedIndex = 0
    
    local json = JSON:new()
    ProfileEditor.CurrentProfile = Profile()
    table.merge(ProfileEditor.CurrentProfile, json:decode(Pyx.FileSystem.ReadFile(profileFilename)))
    
end

function ProfileEditor.UpdateMonstersList()
    ProfileEditor.MonstersName = { }
    local selfPlayer = GetSelfPlayer()
    if selfPlayer then
        for k,v in pairs(GetMonsters()) do
            if not table.find(ProfileEditor.MonstersName, v.Name) and not table.find(ProfileEditor.CurrentProfile.AttackMonsters, v.Name) then
                table.insert(ProfileEditor.MonstersName, v.Name)
            end
        end
    end
end

function ProfileEditor.OnDrawGuiCallback()
    ProfileEditor.DrawProfileEditor()
end

function ProfileEditor.OnRender3D()
    
    local selfPlayer = GetSelfPlayer()
    
    if ProfileEditor.CurrentProfile:HasFishSpot() then
        Renderer.Draw3DTrianglesList(GetInvertedTriangleList(ProfileEditor.CurrentProfile.FishSpotPosition.X, ProfileEditor.CurrentProfile.FishSpotPosition.Y + 100, ProfileEditor.CurrentProfile.FishSpotPosition.Z, 100, 150, 0xAAFF0000, 0xAAFF00FF))
    end
        
end

ProfileEditor.RefreshAvailableProfiles()

if table.length(ProfileEditor.AvailablesProfiles) > 0 then
    ProfileEditor.AvailablesProfilesSelectedIndex = 1
end


