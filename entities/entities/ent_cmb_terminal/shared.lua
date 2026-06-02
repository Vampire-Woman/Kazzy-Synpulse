ENT.Type                    = "anim"

ENT.PrintName               = "Combine Civic Station"
ENT.Author                  = "Kill yourself"
ENT.Category                = "Test"

ENT.Spawnable               = true
ENT.AdminOnly               = true

ENT.RenderGroup             = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance   = false

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Online" )

	self:NetworkVar( "Entity", 1, "AlarmRequester" )
	self:NetworkVar( "Int", 1, "AlarmTimeEnd" )
	self:NetworkVar( "Int", 2, "NextRequestTime" )
end