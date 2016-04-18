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

--[[
FISHING_HOOK_READY - notification
FISHING_HOOK_ING - notification waiting
FISHING_HOOK_DELAY - short pause
FISHING_HOOK_START - start of bar game

success here if perfect

FISHING_HOOK_GOOD - cmpleted bar game
FISHING_HOOK_ING_HARDER - qte game
FISHING_HOOK_ING_SUCCESS - qte complete
]]--

function HookFishHandleGameState:Run()
    local selfPlayer = GetSelfPlayer()
    if selfPlayer.CurrentActionName == "FISHING_HOOK_START" then
        if self.Settings.InstantFish then
            selfPlayer:DoAction("FISHING_HOOK_ING_SUCCESS")
        else
            self.LastGameTick = Pyx.System.TickCount
            self.RandomWaitTime = math.random(2500, 4500)
            selfPlayer:DoAction("FISHING_HOOK_GOOD")
            --BDOLua.Execute("getSelfPlayer():get():SetMiniGameResult(1)")            
        end
    elseif selfPlayer.CurrentActionName == "FISHING_HOOK_ING_HARDER" then
        if Pyx.System.TickCount - self.LastGameTick > self.RandomWaitTime then
            --BDOLua.Execute("getSelfPlayer():get():SetMiniGameResult(2)")
            --BDOLua.Execute("MiniGame_Command_OnSuccess()")
            selfPlayer:DoAction("FISHING_HOOK_ING_SUCCESS")
        end
    end
end