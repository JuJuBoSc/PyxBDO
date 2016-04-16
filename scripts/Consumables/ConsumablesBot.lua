Bot = { }
Bot.Running = false
Bot.ConsumablesState = LibConsumables.ConsumablesState
LibConsumableWindow.Visible = true
LibConsumableWindow.ShowCloseButton = false


function Bot.ResetStats()
end

function Bot.OnPulse()
if Bot.ConsumablesState:NeedToRun() then
    Bot.ConsumablesState:Run()
end
end

function Bot.SaveSettings()
    local json = JSON:new()
    Pyx.FileSystem.WriteFile("Settings.json", json:encode_pretty(Bot.ConsumablesState.Settings))
end

function Bot.LoadSettings()
    local json = JSON:new()
    table.merge(Bot.ConsumablesState.Settings, json:decode(Pyx.FileSystem.ReadFile("Settings.json")))
end
