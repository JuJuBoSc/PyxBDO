-- Create Date : 3/08/2016 Triplany
PyxTimer = {}
PyxTimer.__index = PyxTimer

function PyxTimer:New(seconds)

  local o = {
    _expireSeconds = seconds,
    _startTime = nil,
    _stopTime = nil,

  }
  setmetatable(o, self)
  return o
end


PyxTimer.Start = function(self)
  self._startTime = os.clock()
  self._stopTime = nil
end

PyxTimer.Stop = function(self)

  self._stopTime = os.clock ()
end

PyxTimer.Reset = function(self)
  if self._stopTime == nil then
    self._startTime = os.clock ()
  else
    self._startTime = nil
    self._stopTime = nil
  end
end

PyxTimer.IsRunning = function(self)
  if self._startTime ~= nil and self._stopTime == nil then
    return true
  end
  return false
end

PyxTimer.Expired = function(self)

  if self._startTime ~= nil and self._stopTime == nil and self._expireSeconds + self._startTime <= os.clock ()
    or self._startTime ~= nil and self._stopTime ~= nil and self._expireSeconds + self._startTime <= self._stopTime then
    return true
  end

  return false

end
