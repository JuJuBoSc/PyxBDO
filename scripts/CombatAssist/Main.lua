Pyx.System.RegisterCallback("OnScriptStart", function()
    LoadSettings()
 end)
 
Pyx.System.RegisterCallback("OnScriptStop", function()
    SaveSettings()
 end)

Pyx.System.RegisterCallback("OnDrawGui", function() 
    MainWindow.OnDrawGuiCallback()
end)

Pyx.System.RegisterCallback("OnPulse", function()
    MainWindow.OnPulse()
end)

Pyx.System.RegisterCallback("OnRender3D", function()

end)

-- Overwrite

function Navigator.MoveTo(destination, forceRecalculate)
    Navigator.MoveToStraight(destination)
    return true
end

function Navigator.CanMoveTo(destination)
    return true
end
