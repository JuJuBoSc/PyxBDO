Pyx.System.RegisterCallback("OnScriptStart", function()
    Bot.LoadSettings()
 end)
 
Pyx.System.RegisterCallback("OnScriptStop", function()
    Bot.SaveSettings()
 end)

Pyx.System.RegisterCallback("OnDrawGui", function() 
LibConsumableAddWindow:OnDrawGuiCallback()
LibConsumableWindow:OnDrawGuiCallback()
end)

Pyx.System.RegisterCallback("OnPulse", function()
    Bot.OnPulse()
end)

--Pyx.System.RegisterCallback("OnRender3D", function()
--end)
