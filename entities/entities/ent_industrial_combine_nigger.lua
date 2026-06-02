AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Combine Nigger"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

function ENT:Initialize()
	if not SERVER then return end

	self:SetModel("models/ctvehicles/hla/prisoner_transport.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)

	self.tParticipants = {}

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	self:SetMaxStock(85)
	self:SetStockCount(85) -- Initialize the stock count to the maximum
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "StockCount")
	self:NetworkVar("Int", 1, "MaxStock")
end

function ENT:CreateShipment(pPlayer)
	if not SERVER then return end

	timer.Simple(0.1, function()
		local eShipment = ents.Create("ent_industrial_combine_shipment")

		local vShipmentPos = self.vBoxSpawnPos or (self:GetPos() + self:GetUp() * 20 + self:GetRight() * 145)
		eShipment:SetPos(vShipmentPos)
		eShipment:SetAngles(Angle(0, 270, 0))
		eShipment:Spawn()
		eShipment:Activate()

		local tParticipants = self.tParticipants
		if tParticipants then
			if not tParticipants[pPlayer] then
				tParticipants[pPlayer] = true
			end

			eShipment.tParticipants = tParticipants
		end

		eShipment.ent_owner = pPlayer
	end)
end

function ENT:Use(pPlayer)
	if pPlayer:GetSyncVar(SYNC_ARRESTED) or self.bCreateResource or pPlayer._mrpAction then return end
	-- Check stock count
	local iStockCount = self:GetStockCount()
	if iStockCount <= 0 then
		pPlayer:Notify("This razor train is out of shipments. A new batch will arrive at the start of the next work shift.")
		return
	end

	-- Do not allow combine to create rations
	local bCivilWorker = pPlayer:Team() == TEAM_CITIZEN or pPlayer:Team() == TEAM_VORT
	if not bCivilWorker then return end

	if (self.iNextResourceCreation or 0) > CurTime() then return end

	self.bCreateResource = true

	-- @TODO: Create a log and todo here.
	self:EmitSound("foley/industrial/disassemble_crate" .. math.random(1, 3) .. ".mp3", 80)
	if pPlayer:Team() == TEAM_VORT then
		pPlayer:ForceSequence("vort_shout")
	elseif pPlayer:Team() == TEAM_CITIZEN then
		pPlayer:ForceSequence("gunrack")
	end

	timer.Simple(1.5, function()
		if pPlayer:Team() == TEAM_VORT then
			pPlayer:ForceSequence("vort_shout_end")
		elseif pPlayer:Team() == TEAM_CITIZEN then
			pPlayer:ForceSequence("gunrack")
		end
	end)

	timer.Simple(4, function()
		if not IsValid(self) or not IsValid(pPlayer) then return end

		-- @TODO: Add a notification what to do next here.
		self:CreateShipment(pPlayer)

		-- Decrease stock count by 1 after creating a shipment
		self:SetStockCount(self:GetStockCount() - 1)

		self.bCreateResource = false
		self.iNextResourceCreation = CurTime() + 20

		if pPlayer:Team() == TEAM_VORT then
			pPlayer:ForceSequence("nectar_give")
		elseif pPlayer:Team() == TEAM_CITIZEN then
			pPlayer:ForceSequence("throwitem")
		end
	end, {
		--ent = self,
		--ActionTimeRemainingText = L("helix.industrial.obtaining"),
		--ActionColor = Monolith.Color.industrialworkforce,
		--entDistance = 32738
	}, function()
		if not self.bCreateResource then return end
		self.bCreateResource = false
		self.iNextResourceCreation = CurTime() + 5
		return
	end)
end

function ENT:Restock()
	self:SetStockCount(self:GetMaxStock())
end

if not CLIENT then return end

function ENT:Draw()
	self:DrawModel()
end
