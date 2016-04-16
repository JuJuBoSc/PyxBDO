IdleState = { }
IdleState.__index = IdleState
IdleState.Name = "Idle"

setmetatable(IdleState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function IdleState.new()
  local self = setmetatable({}, IdleState)
  return self
end

function IdleState:NeedToRun()
    return true
end

function IdleState:Run()
    
end
