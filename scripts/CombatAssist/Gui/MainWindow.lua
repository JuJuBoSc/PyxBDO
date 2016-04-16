------------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

MainWindow = { }
MainWindow.AvailablesCombats = { }
MainWindow.CombatsComboBoxSelected = 0
MainWindow.CurrentTargetKey = 0
MainWindow.ButtonWasPress = false
MainWindow.State = "Stopped"
MainWindow.Combat = nil

------------------------------------------------------------------------------
-- Internal variables (Don't touch this if you don't know what you are doing !)
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- MainWindow Functions
-----------------------------------------------------------------------------

function MainWindow.DrawMainWindow()
    local valueChanged = false
    local _, shouldDisplay = ImGui.Begin("Combat Assist", true, ImVec2(400, 110), -1.0)
    if shouldDisplay then
    
        local player = GetSelfPlayer()
        ImGui.Text("Simply aim at a monster, and press ALT :)")
        ImGui.Columns(2)
        ImGui.Text("State")
        ImGui.NextColumn()
        ImGui.Text(MainWindow.State)
        ImGui.NextColumn()
        ImGui.Text("Health")
        ImGui.NextColumn()
        ImGui.Text(( function(player) if player then return player.Health .. " / " .. player.MaxHealth else return 'N / A' end end)(player))
        ImGui.NextColumn()
        
        ImGui.Text("Combat script")
        ImGui.NextColumn()
        if not table.find(MainWindow.AvailablesCombats, CurrentSettings.CombatScript) then
            table.insert(MainWindow.AvailablesCombats, CurrentSettings.CombatScript)
        end
        ImGui.PushItemWidth(-1)
        valueChanged, MainWindow.CombatsComboBoxSelected = ImGui.Combo("##id_gui_combat_script", table.findIndex(MainWindow.AvailablesCombats, CurrentSettings.CombatScript), MainWindow.AvailablesCombats)
        if valueChanged then
            CurrentSettings.CombatScript = MainWindow.AvailablesCombats[MainWindow.CombatsComboBoxSelected]
            print("Combat script selected : " .. CurrentSettings.CombatScript)
        end
        ImGui.PopItemWidth()
        ImGui.NextColumn()
        
        ImGui.Columns(1)
        

        ImGui.End()
    end
end

function MainWindow.OnDrawGuiCallback()
    MainWindow.DrawMainWindow()
end

function MainWindow.RefreshAvailableCombats()
    MainWindow.AvailablesCombats = { }
    for k, v in pairs(Pyx.FileSystem.GetFiles("..\\Grinder\\Combats\\*.lua")) do
        table.insert(MainWindow.AvailablesCombats, v)
    end
end

function MainWindow.OnPulse()
    
    MainWindow.State = "Idle"
    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return
    end
    
    if Pyx.Input.IsGameForeground() then 
        if MainWindow.ButtonWasPressed and not Pyx.Input.IsKeyDown(CurrentSettings.HoldButton) then
            -- Button released
            MainWindow.ButtonWasPressed = false
        elseif not MainWindow.ButtonWasPressed and Pyx.Input.IsKeyDown(CurrentSettings.HoldButton) then
            -- Button pressed
            local targetKey = selfPlayer.CrossHairTargetKey
            
            if MainWindow.CurrentTargetKey ~= 0 then
                MainWindow.CurrentTargetKey = 0
            elseif targetKey ~= 0 then
            
                MainWindow.Combat = nil
            
                local combatScriptFile = CurrentSettings.CombatScript

                local combatScriptFunc = loadfile("../Grinder/Combats/" .. combatScriptFile)

                if not combatScriptFunc then
                    print("Unable to load combat script !")
                    return
                end

                MainWindow.Combat = combatScriptFunc()

                if not MainWindow.Combat then
                    print("Unable to load combat script !")
                    return
                end
            
                MainWindow.CurrentTargetKey = targetKey
            end
            
            MainWindow.ButtonWasPressed = true
        end
    end
    
    if MainWindow.CurrentTargetKey ~= 0 and MainWindow.Combat and MainWindow.Combat.Attack then
    
        local actor = GetActorByKey(MainWindow.CurrentTargetKey)
        
        if not actor then
            MainWindow.CurrentTargetKey = 0
            return
        end
        
        if not actor.IsMonster then
            MainWindow.CurrentTargetKey = 0
            return
        end
        
        local monsterActor = actor.MonsterActor
        
        if not monsterActor.IsAlive then
            print("Target killed !")
            MainWindow.CurrentTargetKey = 0
            return
        end
        
        if selfPlayer and not selfPlayer.IsActionPending and not selfPlayer.IsBattleMode then
            print("Switch to battle mode !")
            selfPlayer:SwitchBattleMode()
        end
        
        MainWindow.State = "Attacking : " .. monsterActor.Name
        MainWindow.Combat:Attack(monsterActor, not monsterActor.IsAggro)
        
    end
    
end

MainWindow.RefreshAvailableCombats()
