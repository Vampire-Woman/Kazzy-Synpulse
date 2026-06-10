AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Disassembly Table"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

function ENT:CreateResource( pPlayer )
	if not SERVER then return end

	timer.Simple( 0.1, function()
		local eResource = ents.Create( "ent_industrial_combine_resource" )
		eResource:SetPos( self:GetPos() + Vector( 10, 40, 40 ) )
		eResource:Spawn()
		eResource:Activate()
		
		local tParticipants = self.tParticipants
		if tParticipants then
			if not tParticipants[ pPlayer ] then
				tParticipants[ pPlayer ] = true
			end

			eResource.tParticipants = tParticipants
		end
		
        eResource:PhysicsInit(SOLID_VPHYSICS)
        eResource:SetMoveType(MOVETYPE_VPHYSICS)
        eResource:SetSolid(SOLID_VPHYSICS)

		self.tParticipants = {}
	end )
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "ProductAmount" )
	self:NetworkVar( "Int", 1, "ProductMax" )
end

function ENT:Initialize()
	if SERVER then
        self:SetModel("models/props/cs_italy/it_mkt_table2.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetTrigger( true )

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		self.tParticipants = {}

		self:SetProductMax( 10 )
	else
		self.bShouldDraw = true
	end
end

function ENT:AddPlayers( tPlayers )
	if not SERVER then return end

	for pParticipant, _ in pairs( tPlayers ) do
		if not self.tParticipants[ pParticipant ] then
			self.tParticipants[ pParticipant ] = true
		end
	end
end

function ENT:StartTouch( eEntity )
	if self:GetProductAmount() > 0 or eEntity:GetClass() ~= "ent_industrial_combine_shipment" then return end

	timer.Simple( 0.1, function()
		self:EmitSound( "physics/wood/wood_crate_impact_soft"..math.random( 1, 3 )..".wav", 70 )

		self:SetProductAmount( 10 )

		if eEntity.tParticipants then
			self:AddPlayers( eEntity.tParticipants )
		end
		
		SafeRemoveEntity( eEntity )
	end )
end

function ENT:Use( pPlayer )
	if pPlayer:GetSyncVar(SYNC_ARRESTED) or self.bCreateResource or pPlayer._mrpAction then return end
    if ( self.iNextResourceCreation or 0 ) > CurTime() then return end
	if self:GetProductAmount() == 0 then return end

	if pPlayer:GetPos():DistToSqr( self:GetPos() ) > 2000 then return end

    -- Do not allow combine to create rations
	local bCivilWorker = pPlayer:Team() == TEAM_CITIZEN or pPlayer:Team() == TEAM_VORT
    if not bCivilWorker then return end

	self.bCreateResource = true
	self:EmitSound( "foley/industrial/disassemble_crate".. math.random( 1, 3 ).. ".mp3", 70 )

	if pPlayer:Team() == TEAM_VORT then
		pPlayer:ForceSequence("lab_partinstall")
	elseif pPlayer:Team() == TEAM_CITIZEN then
		pPlayer:ForceSequence("open_door_towards_left")
	else
		pPlayer:ForceSequence("open_door_towards_left")
	end

	timer.Simple(3, function()
		self:CreateResource( pPlayer )

        self.bCreateResource = false
        self.iNextResourceCreation = CurTime() + 0

		self:SetProductAmount( self:GetProductAmount() - 1 )
        self:EmitSound( "foley/industrial/package_finished"..math.random( 1, 2 )..".mp3", 70 )

		local iChanceForScrap = math.random( 1, 30 )
		if iChanceForScrap == 1 then
			local eScrap = ents.Create( "ent_industrial_scrap" )
			eScrap:SetPos( self:GetPos() + Vector( -10, -30, 40 ) )
			eScrap:Spawn()
			eScrap:Activate()
			eScrap:SetMoveType(MOVETYPE_VPHYSICS)
			eScrap:SetSolid(SOLID_VPHYSICS)

			pPlayer:ViewPunch( Angle( 3, 0, 2 ) )
			pPlayer:Notify("A piece of scrap snaps off the crate after unpacking material from it.")
			self:EmitSound( "foley/crushable/break_wood_picture_frame_small_0"..math.random( 1, 3 )..".wav", 70 )

			local iChanceForInjury = math.random( 1, 3 )
			if iChanceForInjury == 1 then
				pPlayer:TakeDamage( 2 )
				pPlayer:ViewPunch( Angle( 3, 0, 2 ) )
				pPlayer:Notify("You accidentally cut your finger while unpacking a Combine shipment.")
			end
		end

		if self:GetProductAmount() == 0 then
			self:EmitSound( "foley/crushable/break_wood_plank_0"..math.random( 1, 3 )..".wav", 70 )
		end
	end, {
		--ent = self,
		--ActionTimeRemainingText = L( "helix.industrial.extracting" ),
		--ActionColor = Monolith.Color.industrialworkforce
	}, function()
		if not self.bCreateResource then return end

		self:StopSound( "package_sound" )
        self.bCreateResource = false
        self.iNextResourceCreation = CurTime() + 2
		return
	end )
end

if SERVER then return end

function ENT:DrawProductPreview()
	local iCurrentDistance = self:GetPos():DistToSqr( LocalPlayer():GetPos() )
	if iCurrentDistance > 440000 then
		if IsValid( self.ProductPreview ) then
			SafeRemoveEntity( self.ProductPreview )
		end

		bShouldDraw = false
	else
		bShouldDraw = true
	end

	if not IsValid( self.ProductPreview ) and self:GetProductAmount() > 0 and bShouldDraw then
		self.ProductPreview = ClientsideModel( "models/props_junk/wood_crate002a.mdl" )
		self.ProductPreview:SetParent( self )
		self.ProductPreview:SetLocalPos( Vector( 0, 0, 56.2 ) )
		self.ProductPreview:SetLocalAngles( Angle( 0, -180, 0 ) )
	end
end

function ENT:Think()
	if self:GetProductAmount() <= 0 and IsValid( self.ProductPreview ) then 
		SafeRemoveEntity( self.ProductPreview )
	end
end

function ENT:OnRemove()
	if IsValid( self.ProductPreview ) then
		SafeRemoveEntity( self.ProductPreview )
	end
end

function ENT:Draw()
	self:DrawModel()
	self:DrawProductPreview()
end