RoamingState = { }
RoamingState.__index = RoamingState
RoamingState.Name = "Roaming"

setmetatable(RoamingState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function RoamingState.new()
  local self = setmetatable({}, RoamingState)
  self.Hotspots = ProfileEditor.CurrentProfile:GetHotspots()
  self.CurrentHotspotIndex = 1
  return self
end

function RoamingState:NeedToRun()
    
    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end
    
    return true
end

function RoamingState:Run()
    
    local hotspot = self.Hotspots[self.CurrentHotspotIndex]
    
    if hotspot.Distance3DFromMe > 200 then
        Bot.CallCombatRoaming()
        Navigator.MoveTo(hotspot)
    else
        if self.CurrentHotspotIndex < table.length(self.Hotspots) then
            self.CurrentHotspotIndex = self.CurrentHotspotIndex + 1
        else
            self.CurrentHotspotIndex = 1
        end
        print("Moving to hotspot #" .. tostring(self.CurrentHotspotIndex))
    end
    
end
