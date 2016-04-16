Profile = { }
Profile.__index = Profile

setmetatable(Profile, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Profile.new()
  local self = setmetatable({}, Profile)
    self.AttackAnyMonsters = true
    self.Hotspots = { }
    self.AttackMonsters = { }
    self.VendorNpcName = ""
    self.VendorNpcPosition = { X = 0, Y = 0, Z = 0 }
    self.WarehouseNpcName = ""
    self.WarehouseNpcPosition = { X = 0, Y = 0, Z = 0 }
    self.RepairNpcName = ""
    self.RepairNpcPosition = { X = 0, Y = 0, Z = 0 }
  return self
end

function Profile:GetHotspots()
    local hotspotsVector = { }
    for k,v in pairs(self.Hotspots) do
        table.insert(hotspotsVector, Vector3(v.X, v.Y, v.Z))
    end
    return hotspotsVector
end

function Profile:IsPositionNearHotspots(position, distance)
    for k,v in pairs(self:GetHotspots()) do
        if v:GetDistance3D(position) <= distance then
            return true
        end
    end
    return false
end

function Profile:GetVendorPosition()
    return Vector3(self.VendorNpcPosition.X, self.VendorNpcPosition.Y, self.VendorNpcPosition.Z)
end

function Profile:GetRepairPosition()
    return Vector3(self.RepairNpcPosition.X, self.RepairNpcPosition.Y, self.RepairNpcPosition.Z)
end

function Profile:GetWarehousePosition()
    return Vector3(self.WarehouseNpcPosition.X, self.WarehouseNpcPosition.Y, self.WarehouseNpcPosition.Z)
end

function Profile:HasVendor()
    return string.len(self.VendorNpcName) > 0
end

function Profile:HasWarehouse()
    return string.len(self.WarehouseNpcName) > 0
end

function Profile:HasRepair()
    return string.len(self.RepairNpcName) > 0
end

function Profile:CanAttackMonster(monsterActor)
    if not monsterActor then
        return false
    end
    local actorName = monsterActor.Name
    for k,v in pairs(self.AttackMonsters) do
        if v == actorName then
            return true
        end
    end
    return true
end

