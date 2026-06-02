function PLUGIN:CreateSyncVars()
	SYNC_DISPATCH_BOL = impulse.Sync.RegisterVar(SYNC_INT)
    SYNC_DISPATCH_DEFUNCT = impulse.Sync.RegisterVar(SYNC_INT)
	
    SYNC_SQUAD_ID = impulse.Sync.RegisterVar(SYNC_INT)
    SYNC_SQUAD_LEADER = impulse.Sync.RegisterVar(SYNC_BOOL)
end