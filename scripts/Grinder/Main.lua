Pyx.System.RegisterCallback("OnScriptStart", function()
    Bot.LoadSettings()
 end)
 
Pyx.System.RegisterCallback("OnScriptStop", function()
    Bot.SaveSettings()
    Navigation.MesherEnabled = false
    Navigation.RenderMesh = false
    Navigation.ClearMesh()
 end)

Pyx.System.RegisterCallback("OnDrawGui", function() 
    MainWindow:OnDrawGuiCallback()
    ProfileEditor.OnDrawGuiCallback()
    LibConsumableWindow:OnDrawGuiCallback()
    LibConsumableAddWindow:OnDrawGuiCallback()

end)

Pyx.System.RegisterCallback("OnPulse", function()
    Navigator.OnPulse()
    Bot:OnPulse()
end)

Pyx.System.RegisterCallback("OnRender3D", function()
    Navigator.OnRender3D()
    ProfileEditor.OnRender3D()
end)
