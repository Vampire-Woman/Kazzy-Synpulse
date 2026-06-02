AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Oil Tank"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

sound.Add({
	name = "siphon_oil",
	volume = 1.0,
	sound = "ambient/water/water_pump_drainin1.wav"
})

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "RawResource" )
	self:NetworkVar( "Bool", 1, "Siphoning" )
end

function ENT:CreateFuel( pPlayer )
	if not SERVER then return end

	timer.Simple( 0.1, function()
		local eFuel = ents.Create( "ent_industrial_fuel" )
		local vPos = self:GetPos() + self:GetUp() * 30 + self:GetRight() * -30 + self:GetForward() * 80

		eFuel:SetPos( vPos )
		eFuel:Spawn()
		eFuel:Activate()
		eFuel.ent_owner = pPlayer
	end )
end

function ENT:Initialize()
	if SERVER then
        self:SetModel("models/props_mining/oiltank01.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetTrigger( true )

        local vPhys = self:GetPhysicsObject()
        if vPhys:IsValid() then
            vPhys:Wake()
        end
	end
end

function ENT:Use( pPlayer )
	if pPlayer:IsHandcuffed() or self:GetSiphoning() or pPlayer._mrpAction then return end
	if ( self.iNextResourceCreation or 0 ) > CurTime() then 
		pPlayer:AddNotification( L( "entities.fuelRefill.cooldown", string.NiceTime( self.iNextResourceCreation - CurTime() ) ) )
		return 
	end

    -- Do not allow combine to create rations
	local bCivilWorker = pPlayer:GetJobCategory() == L( "cfg.job.category.civilWorker" ) or pPlayer:Team() == TEAM_ENSLAVED_VORTIGAUNT
    if not bCivilWorker then return end
    
	if Monolith.Combine:GetSocialFractureInProgress() then return pPlayer:AddNotification( L"helix.industrial.machineJW" ) end

	-- @TODO: Create a log here.

	self:SetSiphoning( true )
    self:EmitSound( "siphon_oil" )

	Monolith.Say3DAction( pPlayer, L( "entities.fuelRefill.action.start" ), pPlayer )
	pPlayer:ForceSequence("Open_door_towards_left")

	Monolith.Actions.DoAction( pPlayer, 15, function()
		self:CreateFuel( pPlayer )
        self:SetSiphoning( false )

        self.iNextResourceCreation = CurTime() + 15
		
		self:StopSound( "siphon_oil" )
		self:EmitSound( "physics/metal/metal_barrel_impact_hard5.wav" )
	end, {
		ent = self,
		ActionTimeRemainingText = L( "helix.industrial.siphoning" ),
		ActionColor = Monolith.Color.industrialworkforce
	}, function()
		if not self:GetSiphoning() then return end

		self:StopSound( "siphon_oil" )
        self:SetSiphoning( false )
        self.iNextResourceCreation = CurTime() + 2
		return
	end )
end

if SERVER then return end

function ENT:Draw()
	self:DrawModel()
end