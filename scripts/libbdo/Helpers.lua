Helpers = { }

function Helpers.IsSafeZone()
	return BDOLua.Execute("return getRegionInfoByPosition( getSelfPlayer():get():getPosition() ):get():isSafeZone()")
end
