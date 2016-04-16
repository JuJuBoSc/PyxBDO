BuildNavigationState = { }
BuildNavigationState.__index = BuildNavigationState
BuildNavigationState.Name = "Build Navigation"

setmetatable(BuildNavigationState, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function BuildNavigationState.new()
  local self = setmetatable({}, BuildNavigationState)
  return self
end

function BuildNavigationState:NeedToRun()
    return not Navigation.IsNavigationInitialized
end

function BuildNavigationState:Run()
    
    if not Navigation.IsBuildingNavigation then
        Navigation.BuildNavigation()
    end
    
end
