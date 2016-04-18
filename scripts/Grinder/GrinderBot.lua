Bot = { }
Bot.Settings = Settings()
Bot.Running = false
Bot.Fsm = FSM()
Bot.Combat = nil
Bot.CombatPull = nil
-- Converted to CommonStates
Bot.WarehouseState = WarehouseState()
Bot.VendorState = VendorState()
Bot.DeathState = DeathState()
Bot.RepairState = RepairState()
Bot.LootState = LootActorState()
Bot.BuildNavigationState = BuildNavigationState()
Bot.InventoryDeleteState = InventoryDeleteState()

-- Not Converted yet
Bot.CombatFightState = CombatFightState()
Bot.CombatPullState = CombatPullState()

-- Bot.Fsm:AddState(RoamingState())
-- Bot.Fsm:AddState(IdleState())


function Bot.GetPlayers(onlyPvpFlagged)
    local actors = GetActors()
    local players = { }
    for key, value in pairs(monsters) do
        if value.IsPlayer then
            if (onlyPvpFlagged == nil or onlyPvpFlagged == false) or(onlyPvpFlagged == true and value.IsPvpEnable == true) then
                players[#players] = value
            end

        end
    end
    return players
end

function Bot.Start()
    if not Bot.Running then

        Bot.ResetStats()
        Bot.Combat = nil
        Bot.RepairState.Forced = false
        Bot.WarehouseState.Forced = false
        Bot.VendorState.Forced = false

        Bot.SaveSettings()

        local combatScriptFile = Bot.Settings.CombatScript

        local code = Pyx.FileSystem.ReadFile("Combats/" .. combatScriptFile)
        combatScriptFunc,combatScriptError = load(code)

        if combatScriptFunc == nil then
            print(string.format("Unable to load combat script: func %s err %s", tostring(combatScriptFunc), tostring(combatScriptError)))
            return
        end

        Bot.Combat = combatScriptFunc()

        if not Bot.Combat then
            print("Unable to load combat script !")
            return
        end

        if not Bot.Combat.Attack then
            print("Combat script doesn't have .Attack function !")
            return
        end

        local currentProfile = ProfileEditor.CurrentProfile

        if not currentProfile then
            print("No profile loaded !")
            return
        end

        if Bot.MeshDisabled ~= true and table.length(currentProfile:GetHotspots()) < 2 then
            print("Profile require at least 2 hotspots !")
            return
        end

        if Bot.MeshDisabled == true then
            Navigator.RealMoveTo = Navigator.MoveTo
            Navigator.MoveTo = function(p)
                GetSelfPlayer():MoveTo(p)     
            end
            Navigator.RealCanMoveTo = Navigator.CanMoveTo
            Navigator.CanMoveTo = function(p) return true end
        end

        Bot.WarehouseState:Reset()
        Bot.VendorState:Reset()
        Bot.RepairState:Reset()
        Bot.DeathState:Reset()

        Bot.WarehouseState.Settings.NpcName = currentProfile.WarehouseNpcName
        Bot.WarehouseState.Settings.NpcPosition = currentProfile.WarehouseNpcPosition
        Bot.WarehouseState.CallWhenCompleted = Bot.StateComplete
        Bot.WarehouseState.CallWhileMoving = Bot.StateMoving

        Bot.VendorState.Settings.NpcName = currentProfile.VendorNpcName
        Bot.VendorState.Settings.NpcPosition = currentProfile.VendorNpcPosition
        Bot.VendorState.CallWhenCompleted = Bot.StateComplete
        Bot.VendorState.CallWhileMoving = Bot.StateMoving

        Bot.DeathState.CallWhenCompleted = Bot.Death

        Bot.RepairState.Settings.NpcName = currentProfile.RepairNpcName
        Bot.RepairState.Settings.NpcPosition = currentProfile.RepairNpcPosition
        Bot.RepairState.CallWhileMoving = Bot.StateMoving

        Bot.LootState.CallWhileMoving = Bot.StateMoving

        if Bot.MeshDisabled ~= true then
            ProfileEditor.Visible = false
            Navigation.MesherEnabled = false
        end
        Navigator.OnStuckCall = Bot.OnStuck

        Bot.Fsm = FSM()
        Bot.Fsm.ShowOutput = true

        if Bot.MeshDisabled ~= true then
            Bot.Fsm:AddState(Bot.BuildNavigationState)
            Bot.Fsm:AddState(Bot.DeathState)
            Bot.Fsm:AddState(LibConsumables.ConsumablesState)
            Bot.Fsm:AddState(Bot.CombatFightState)
            Bot.Fsm:AddState(Bot.LootState)
            Bot.Fsm:AddState(Bot.VendorState)
            Bot.Fsm:AddState(Bot.WarehouseState)
            Bot.Fsm:AddState(Bot.RepairState)
            Bot.Fsm:AddState(Bot.InventoryDeleteState)
            Bot.Fsm:AddState(Bot.CombatPullState)
            Bot.Fsm:AddState(RoamingState())
            Bot.Fsm:AddState(IdleState())
        else
            Bot.Fsm:AddState(Bot.DeathState)
            Bot.Fsm:AddState(PlayerPressState())
            Bot.Fsm:AddState(LibConsumables.ConsumablesState)
            Bot.Fsm:AddState(Bot.CombatFightState)
            Bot.Fsm:AddState(Bot.LootState)
            Bot.Fsm:AddState(Bot.InventoryDeleteState)
            Bot.Fsm:AddState(Bot.CombatPullState)
            Bot.Fsm:AddState(IdleState())
        end

        Bot.Running = true
    end
end

function Bot.Death(state)
    if Bot.DeathState.Settings.ReviveMethod == DeathState.SETTINGS_ON_DEATH_ONLY_CALL_WHEN_COMPLETED then
        Bot.Stop()
    end
end

function Bot.Stop()
    Navigator.Stop()
    Bot.Running = false

    if Navigator.RealMoveTo ~= nil then
        Navigator.MoveTo = Navigator.RealMoveTo
        Navigator.RealMoveTo = nil

        Navigator.CanMoveTo = Navigator.RealCanMoveTo
        Navigator.RealCanMoveTo = nil
    end
end

function Bot.ResetStats()

end

function Bot.OnPulse()

    if Pyx.Input.IsGameForeground() then
        -- pause to start or stop bot
        if Pyx.Input.IsKeyDown(0x12) and Pyx.Input.IsKeyDown(string.byte('S')) then
            if Bot._startHotKeyPressed ~= true then
                Bot._startHotKeyPressed = true
                if Bot.Running then
                    print("stopping bot from hotkey")
                    Bot.Stop()
                else
                    print("starting bot from hotkey")
                    Bot.Start()
                end
            end
        else
            Bot._startHotKeyPressed = false
        end

        -- alt+F hotspot adding
        if Pyx.Input.IsKeyDown(0x12) and Pyx.Input.IsKeyDown(string.byte('F')) then
            if Bot._addHotKeyPressed ~= true then
                Bot._addHotKeyPressed = true
                print("Adding hotspot through hotkey")
                local selfPlayer = GetSelfPlayer()
                if selfPlayer then
                    local selfPlayerPosition = selfPlayer.Position
                    table.insert(ProfileEditor.CurrentProfile.Hotspots, { X = selfPlayerPosition.X, Y = selfPlayerPosition.Y, Z = selfPlayerPosition.Z })
                end
            end
        else
            Bot._addHotKeyPressed = false
        end
    end

    if Bot.Running then
        Bot.Fsm:Pulse()

        if Bot.VendorState.Forced == true or Bot.RepairState.Forced == true or Bot.WarehouseState.Forced == true then
            Bot.CombatPullState.Enabled = false
        else
            Bot.CombatPullState.Enabled = true
        end
    end
end

function Bot.CallCombatAttack(monsterActor, isPull)
    if Bot.Combat and Bot.Combat.Attack then
        Bot.Combat:Attack(monsterActor, isPull)
    end
end

function Bot.CallCombatRoaming()
    if Bot.Combat and Bot.Combat.Roaming then
        Bot.Combat:Roaming()
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
    Bot.Settings.DeathSettings = Bot.DeathState.Settings
    Bot.Settings.RepairSettings = Bot.RepairState.Settings
    Bot.Settings.LootSettings = Bot.LootState.Settings
    Bot.Settings.InventoryDeleteSettings = Bot.InventoryDeleteState.Settings
    Bot.Settings.LibConsumablesSettings = LibConsumables.Settings


    table.merge(Bot.Settings, json:decode(Pyx.FileSystem.ReadFile("Settings.json")))
    if string.len(Bot.Settings.LastProfileName) > 0 then
        ProfileEditor.LoadProfile(Bot.Settings.LastProfileName)
    end
end

function Bot.StateMoving(state)
    Bot.CallCombatRoaming()
end


function Bot.OnStuck()
    if Navigator.StuckCount > 15 then
        print("We are too stuck try rescue")
         BDOLua.Execute("callRescue()")
        
    end
end

function Bot.StateComplete(state)

    if state == Bot.VendorState then
        if Bot.Settings.WarehouseAfterVendor == true then
            Bot.WarehouseState.Forced = true
        end
    end
end


Bot.ResetStats()
