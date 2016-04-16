FSM = { }
FSM.__index = FSM

setmetatable(FSM, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function FSM.new()
  local self = setmetatable({}, FSM)
  self.States = { }
  self.CurrentState = nil
  self.ShowOutput = false
  return self
end

function FSM:AddState(state)
    
    if type(state.Name) ~= "string" then
        error("State must have .Name defined !")
    end
    
    if type(state.NeedToRun) ~= "function" then
        error("State must have :NeedToRun() defined !")
    end
    
    if type(state.Run) ~= "function" then
        error("State must have :Run() defined !")
    end
    
    table.insert(self.States, state)
    
end

function FSM:Pulse()
    for _,state in pairs(self.States) do
        if state:NeedToRun() then
            
            if self.CurrentState ~= nil and self.CurrentState ~= state then
                if self.ShowOutput then  print("Exit state : " .. self.CurrentState.Name) end
                if self.CurrentState.Exit ~= nil then
                    self.CurrentState:Exit()
                end
            end
            
            if self.CurrentState ~= state then
                self.CurrentState = state
                if self.ShowOutput then  print("Enter state : " .. state.Name) end
                if self.CurrentState.Enter ~= nil then
                    self.CurrentState:Enter()
                end
            end
            
            state:Run()
            return
        end
    end
end

