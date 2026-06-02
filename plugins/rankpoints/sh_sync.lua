function PLUGIN:CreateSyncVars()
	SYNC_RANKPOINTS = impulse.Sync.RegisterVar(SYNC_BIGINT)
    SYNC_LOADOUTPISTOL = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_LOADOUTSMG = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_LOADOUTHEALTHVIAL = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_LOADOUTHEALTHKIT = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_LOADOUTEXTRAAMMO = impulse.Sync.RegisterVar(SYNC_BOOL)
    SYNC_LOADOUTEXTRACUFFS = impulse.Sync.RegisterVar(SYNC_BOOL)
end

function meta:GetRankPoints()
	return (self.GetSyncVar(self, SYNC_RANKPOINTS, nil) or 0)
end

if SERVER then
	function meta:SetRankPoints(val)
		self:SetLocalSyncVar(SYNC_RANKPOINTS, val, true)
		self:GetData().rp = val
		self:SaveData()
	end
end