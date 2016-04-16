Settings = { }
Settings.__index = Settings

setmetatable(Settings, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Settings.new()
  local self = setmetatable({}, Settings)
    self.CombatScript = ""
    self.HoldButton = 0x12 -- ALT
    return self
end



CurrentSettings = Settings();

function LoadSettings()
    local json = JSON:new()
    CurrentSettings = Settings()
    table.merge(CurrentSettings, json:decode(Pyx.FileSystem.ReadFile("Settings.json")))
end

function SaveSettings()
    local json = JSON:new()
    Pyx.FileSystem.WriteFile("Settings.json", json:encode_pretty(CurrentSettings))
end