PlayerPressState = {}
PlayerPressState.__index = PlayerPressState
PlayerPressState.Name = "PlayerPress"

setmetatable(PlayerPressState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function PlayerPressState.new()
  local self = setmetatable({}, PlayerPressState)
  self.lastPress = 0
  return self
end

function PlayerPressState:NeedToRun()
  return Pyx.Input.IsGameForeground() and (self:ButtonsPressed() or os.clock() - self.lastPress < 0.25)
end

function PlayerPressState:Run()

end

function PlayerPressState:ButtonsPressed()
  local pressed = 
  Pyx.Input.IsKeyDown(string.byte('A'))
  or Pyx.Input.IsKeyDown(string.byte('D'))
  or Pyx.Input.IsKeyDown(string.byte('S'))
  or Pyx.Input.IsKeyDown(string.byte('W'))
  or Pyx.Input.IsKeyDown(string.byte(' '))

  if pressed then
    self.lastPress = os.clock()
  end

  return pressed
end