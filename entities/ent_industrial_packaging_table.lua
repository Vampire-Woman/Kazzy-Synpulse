AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Packaging Table"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

local tModels = {
	"models/props_junk/cardboard_box001a.mdl",
	"models/props_junk/cardboard_box002a.mdl"
}

sound.Add({
	name = "package_sound",
	volume = 1.0,
	sound = "foley/industrial/packaging_box1.mp3"
})

function ENT:CreatePackage( pPlayer, sModel )
	if not SERVER then return end

	timer.Simple( 0.1, function()
		local ePackage = ents.Create( "ent_industrial_package" )
		ePackage:SetPos( self:GetPos() + Vector( 0, 0, 49 ) )
		ePackage:Spawn()
		ePackage:Activate()
		
		local tParticipants = self.tParticipants
		if tParticipants then
			if not tParticipants[ pPlayer ] then
				tParticipants[ pPlayer ] = true
			end

			ePackage.tParticipants = tParticipants
		end

		ePackage:SetModel( sModel )
        ePackage:PhysicsInit(SOLID_VPHYSICS)
        ePackage:SetMoveType(MOVETYPE_VPHYSICS)
        ePackage:SetSolid(SOLID_VPHYSICS)

		self.tParticipants = {}
	end )
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "ProductAmount" )
	self:NetworkVar( "String", 1, "SelectedModel" )
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
	if self:GetProductAmount() >= 5 or eEntity:GetClass() ~= "ent_industrial_product" then return end

	self:SetSelectedModel( tModels[ math.random( #tModels ) ] )

	timer.Simple( 0.1, function()
		self:EmitSound( "physics/cardboard/cardboard_box_impact_soft"..math.random(1,7)..".wav" )

		self:SetProductAmount( self:GetProductAmount() + 1 )

		if eEntity.tParticipants then
			self:AddPlayers( eEntity.tParticipants )
		end
		
		SafeRemoveEntity( eEntity )
	end )
end

function ENT:Use( pPlayer )
	if pPlayer:GetSyncVar(SYNC_ARRESTED) or self.bCreateResource or pPlayer._mrpAction then return end
    if ( self.iNextResourceCreation or 0 ) > CurTime() then return end
	if self:GetProductAmount() < 5 then return end

    -- Do not allow combine to create rations
	local bCivilWorker = pPlayer:Team() == TEAM_CITIZEN or pPlayer:Team() == TEAM_VORT
    if not bCivilWorker then return end

	self.bCreateResource = true

	self:EmitSound( "package_sound" )

	if pPlayer:Team() == TEAM_VORT then
		pPlayer:ForceSequence("lab_partinstall")
	elseif pPlayer:Team() == TEAM_CITIZEN then
		pPlayer:ForceSequence("open_door_towards_left")
	else
		pPlayer:ForceSequence("open_door_towards_left")
	end
	
	timer.Simple(9, function()
		self:CreatePackage( pPlayer, self:GetSelectedModel() )

        self.bCreateResource = false
        self.iNextResourceCreation = CurTime() + 2

		self:SetProductAmount( 0 )
        self:EmitSound( "physics/cardboard/cardboard_box_break"..math.random(1,3)..".wav" )
		self:StopSound( "package_sound" )

		local iChanceForInjury = math.random( 1, 10 )
		if iChanceForInjury == 1 then
			pPlayer:TakeDamage( 2 )
			pPlayer:ViewPunch( Angle( 3, 0, 2 ) )
		end
	end, {
		--ent = self,
		--ActionTimeRemainingText = L( "helix.industrial.packaging" ),
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
    local iCurrentDistance = self:GetPos():DistToSqr(LocalPlayer():GetPos())
    if iCurrentDistance > 340000 then
        if IsValid(self.ProductPreview) then
            SafeRemoveEntity(self.ProductPreview)
        end
        bShouldDraw = false
        return
    else
        bShouldDraw = true
    end

    if not IsValid(self.ProductPreview) and self:GetProductAmount() > 0 and bShouldDraw then
        -- Create preview
        self.ProductPreview = ClientsideModel(self:GetSelectedModel())
        self.ProductPreview:SetParent(self)
        self.ProductPreview:SetLocalPos(Vector(0, 0, 49))
        self.ProductPreview:SetLocalAngles(Angle(0, 0, 0))
    end

    if IsValid(self.ProductPreview) then
        -- Update color based on product amount
        if self:GetProductAmount() >= 5 then
            self.ProductPreview:SetColor(Color(0, 255, 255)) -- cyan
        else
            self.ProductPreview:SetColor(Color(240, 194, 128)) -- orange
        end
        self.ProductPreview:SetMaterial("models/wireframe")
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