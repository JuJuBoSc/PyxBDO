MoveToFishingSpotState = { }
MoveToFishingSpotState.__index = MoveToFishingSpotState
MoveToFishingSpotState.Name = "Move to fish spot"

setmetatable(MoveToFishingSpotState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function MoveToFishingSpotState.new()
  local self = setmetatable({}, MoveToFishingSpotState)
  self.LastStartFishTickcount = 0
  return self
end

function MoveToFishingSpotState:NeedToRun()

    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end
    
    if not Navigator.CanMoveTo(ProfileEditor.CurrentProfile:GetFishSpotPosition()) then
        return false
    end
    
    return ProfileEditor.CurrentProfile:GetFishSpotPosition().Distance3DFromMe > 100 
    
end

function MoveToFishingSpotState:Run()
    Navigator.MoveTo(ProfileEditor.CurrentProfile:GetFishSpotPosition())
end
