Settings = { }
Settings.__index = Settings

setmetatable(Settings, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Settings.new()
  local self = setmetatable({}, Settings)
    
    self.LastProfileName = ""
    self.CombatScript = ""
    
   
    self.VendorafterTradeManager = true

    self.WarehouseAfterVendor = true
    self.WarehouseAfterTradeManager = true

    self.WarehouseSettings = {}
    self.VendorSettings = {}

    self.TradeManagerSettings = {}
    self.ConsumablesSettings = {}

    self.InventoryDeleteSettings = {}
    self.DeleteUsedRods = true

    self.IgnoreUntradeAbleItems = false

    self.LibConsumablesSettings = {}

    self.StartFishingSettings = {}
    self.HookFishHandleGameSettings = {}
    
  return self
end

