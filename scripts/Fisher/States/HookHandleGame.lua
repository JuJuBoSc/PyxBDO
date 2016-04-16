HookFishHandleGameState = { }
HookFishHandleGameState.__index = HookFishHandleGameState
HookFishHandleGameState.Name = "Hook game"

setmetatable(HookFishHandleGameState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function HookFishHandleGameState.new()
  local self = setmetatable({}, HookFishHandleGameState)
  self.LastHookFishTickCount = 0
  self.LastGameTick = 0
  self.RandomWaitTime = 0
  self.Settings = {InstantFish = false}
  return self
end

function HookFishHandleGameState:NeedToRun()

    local selfPlayer = GetSelfPlayer()
    
    if not selfPlayer then
        return false
    end
    
    if not selfPlayer.IsAlive then
        return false
    end

    return selfPlayer.CurrentActionName == "FISHING_HOOK_START" or selfPlayer.CurrentActionName == "FISHING_HOOK_ING_HARDER"
end

function HookFishHandleGameState:Run()
    local selfPlayer = GetSelfPlayer()
    if selfPlayer.CurrentActionName == "FISHING_HOOK_START" then
        selfPlayer:DoAction("FISHING_HOOK_PERFECT")
        selfPlayer:DoAction("FISHING_HOOK_ING")
        BDOLua.Execute("getSelfPlayer():get():SetMiniGameResult(1)")
        selfPlayer:DoAction("FISHING_HOOK_ING_HARDER")
        self.LastGameTick = Pyx.System.TickCount
        if self.Settings.InstantFish then    
        self.RandomWaitTime = 0
        else
        self.RandomWaitTime = math.random(2500,3800)
        end
    elseif selfPlayer.CurrentActionName == "FISHING_HOOK_ING_HARDER" then
        if not selfPlayer.CurrentActionName == "FISHING_HOOK_ING_HARDER" then
            return
        else
            if Pyx.System.TickCount - self.LastGameTick > self.RandomWaitTime then
                BDOLua.Execute("getSelfPlayer():get():SetMiniGameResult(2)")
                BDOLua.Execute("MiniGame_Command_OnSuccess()")
            end
        end
    end
end