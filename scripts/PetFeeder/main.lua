Pyx.System.RegisterCallback("OnScriptStart", function()
    Bot.LoadSettings()
 end)
 
Pyx.System.RegisterCallback("OnScriptStop", function()
    Bot.SaveSettings()
 end)

Pyx.System.RegisterCallback("OnDrawGui", function() 
    MainWindow:OnDrawGuiCallback()
end)

Pyx.System.RegisterCallback("OnPulse", function()
    --Navigator.OnPulse()
    Bot.OnPulse()
end)
