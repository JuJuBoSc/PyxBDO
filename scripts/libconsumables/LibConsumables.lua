--[[
Can be used just like a common state

add LibConsumables.ConsumableState to your fsm

-- make sure to do a table merge on load settings if you are not already
add LibConsumables.Settings to your settings load and save

-- add following to Pyx.System.RegisterCallback
LibConsumableAddWindow:OnDrawGuiCallback()
LibConsumableWindow:OnDrawGuiCallback()

-- use the following to open/close the consumable window
LibConsumableWindow.Visible  (true or fale)

--]]

LibConsumables = { }
LibConsumables.ConsumablesState = ConsumablesState()
LibConsumables.Settings = LibConsumables.ConsumablesState.Settings