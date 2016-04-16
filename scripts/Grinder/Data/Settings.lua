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
    
    self.WarehouseSettings = {}
    self.VendorSettings = {}
    self.DeathSettings = {}
    self.RepairSettings = {}
    self.LootSettings = {}
    self.InventoryDeleteSettings = {}
    self.LibConsumablesSettings = {}

	self.WarehouseAfterVendor = true
    self.AttackPvpFlagged = true

    self.Advanced = {PvpAttackRadius = 1800, HotSpotRadius = 3000, IgnorePullBetweenHotSpots = true, IgnoreInCombatBetweenHotSpots = false, PullDistance = 2500, PullSecondsUntillIgnore = 10, CombatMaxDistanceFromMe = 2200, CombatSecondsUntillIgnore = 15}

    return self
end



