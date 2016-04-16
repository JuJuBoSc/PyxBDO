HookFishState = { }
HookFishState.__index = HookFishState
HookFishState.Name = "Hook fish"

setmetatable(HookFishState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function HookFishState.new()
  local self = setmetatable({}, HookFishState)
  self.LastHookFishTickCount = 0
  return self
end

function HookFishState:NeedToRun()

    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end
    
    if Pyx.System.TickCount - self.LastHookFishTickCount < 4000 then
        return false
    end

    return selfPlayer.CurrentActionName == "FISHING_HOOK_ING"
end

function HookFishState:Run()
    local selfPlayer = GetSelfPlayer()
    print("Got a fish !")
    selfPlayer:DoAction("FISHING_HOOK_START")
    self.LastHookFishTickCount = Pyx.System.TickCount
end
