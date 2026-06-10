AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Combine Lock"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Combine Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = true
ENT.IsCombineLock = true

local tAllowedTeams = {
	[ TEAM_CP ] = true,
	[ TEAM_OTA ] = true
}

ENT.Types = {
	{
		color = color_red,
		check = function( pPlayer ) return pPlayer:IsCombine() or tAllowedTeams[ pPlayer:Team() ] end
	},
	{
		color = color_orange,
		check = function( pPlayer ) 
			return tAllowedTeams 
		end,
	},
	{
		color = color_yellow,
		check = function( pPlayer ) 
			return tAllowedTeams
		end,
	}
}

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "Mode" )
    self:NetworkVar( "Bool", 0, "Locked" )
    self:NetworkVar( "Int", 1, "Type" )
    self:NetworkVar( "Bool", 1, "Broken" )

    if SERVER then
        self:NetworkVarNotify( "Locked", self.OnLockChanged )
    end
end

function ENT:Use( pPlayer )
    if ( self.nNextUse or 0 ) > CurTime() then return end

    if self:GetBroken() then
		local effectData = EffectData()
		effectData:SetOrigin( self:GetPos() )
		effectData:SetMagnitude(2)
		effectData:SetScale(1)
		effectData:SetRadius(5)
		util.Effect("ElectricSpark", effectData, true, true)

		self:EmitSound("ambient/energy/spark" .. math.random(4, 6) .. ".wav", 75, 100) 
		pPlayer:Notify("The Combine lock appears to have malfunctioned.")
        self.nNextUse = CurTime() + 2
        return
    end

    local bAllowed = self.Types[ self:GetType() ].check( pPlayer )
    if not bAllowed then
        self:EmitSound( "buttons/combine_button_locked.wav", 70 )
        self:SetMode( 1 )

        timer.Simple(0.8, function()
            if not IsValid( self ) then return end

            self:SetMode( 0 )
        end)

        self.nNextUse = CurTime() + 2
        return
    end

    self:SetLocked( not self:GetLocked() )
    self.nNextUse = CurTime() + 2
end

function ENT:Initialize()
	self:SetType( 1 )

	if not SERVER then return end

	self:SetModel( "models/props_combine/combine_lock01.mdl" )
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )

	-- Set the lock to be locked by default.
	self:SetLocked( true )
	self:OnLockChanged( "Locked", false, true )
end

function ENT:SetDoor( eDoor, vPosition, aAngles )
	if not SERVER then return end

	if not IsValid( eDoor ) or not eDoor:IsDoor() then return end

	self.eDoor = eDoor
	self.eDoor:DeleteOnRemove( self )
	eDoor.combineLock = self

	local eDoorPartner = eDoor.ePartner
	if IsValid( eDoorPartner ) then
		self.eDoorPartner = eDoorPartner
		self.eDoorPartner:DeleteOnRemove( self )

		eDoorPartner.combineLock = self
	end

	self:SetPos( vPosition )
	self:SetAngles( aAngles )
	self:SetParent( eDoor )
end 

function ENT:OnRemove()
	if not SERVER then return end

	self:SetParent( nil )

	if IsValid( self.eDoor ) then
		self.eDoor.combineLock = nil
	end

	if IsValid( self.eDoorPartner ) then
		self.eDoorPartner.combineLock = nil
	end
end

function ENT:GetLockPosition( eDoor, aNormal )
	if not SERVER then return end

	local nIndex = eDoor:LookupBone( "handle" )
	local vPos = eDoor:GetPos()
	
	aNormal = aNormal or eDoor:GetForward():Angle()

	if nIndex and nIndex >= 1 then
		vPos = eDoor:GetBonePosition( nIndex )
	end

	vPos = vPos + aNormal:Forward() * 0 + aNormal:Up() * 9 + aNormal:Right() * 3.33

	aNormal:RotateAroundAxis( aNormal:Up(), 90 )
	aNormal:RotateAroundAxis( aNormal:Forward(), 180 )
	aNormal:RotateAroundAxis( aNormal:Right(), 180 )

	return vPos, aNormal
end

function ENT:OnLockChanged( sName, bWasLocked, bLocked )
	if not SERVER then return end

	if not IsValid( self.eDoor ) then return end

	if bLocked then
		self:EmitSound( "buttons/combine_button2.wav", 70 )
		self.eDoor:Fire( "lock" )
		self.eDoor:Fire( "close" )

		if IsValid( self.eParent ) then
			self.eParent:Fire( "lock" )
			self.eParent:Fire( "close" )
		end
	else
		self:EmitSound( "buttons/combine_button1.wav", 70 )
		self.eDoor:Fire( "unlock" )

		if IsValid( self.eParent ) then
			self.eParent:Fire( "unlock" )
		end
	end
end

function ENT:SpawnFunction( pPlayer, tTrace )
	if not SERVER then return end

	local eDoor = tTrace.Entity
	if not IsValid( eDoor ) or not eDoor:IsDoor() or IsValid( eDoor.combineLock ) then return end

	local aNormal = pPlayer:GetEyeTrace().HitNormal:Angle()
	local vPos, aAng = self:GetLockPosition( eDoor, aNormal )

	local eEntity = ents.Create( "ent_cmb_lock" )
	eEntity:SetPos( tTrace.HitPos )
	eEntity:Spawn()
	eEntity:SetDoor( eDoor, vPos, aAng )
	eEntity:Activate()

	return eEntity
end

if not CLIENT then return end

local glowMaterial = Material("sprites/glow04_noz")

function ENT:Draw()
    self:DrawModel()
end

hook.Add("PostDrawTranslucentRenderables", "AddCombineLockSprite", function()
    for _, eEntity in pairs(ents.FindByClass("ent_cmb_lock")) do
        -- Ensure the entity is valid
        if not IsValid(eEntity) then continue end

        local cColor = Color(255, 0, 0)  -- Default color (red)
        local bDisplaySprite = false

        -- Change the color to green if unlocked
        if not eEntity:GetLocked() then
            cColor = Color(0, 255, 0)  -- Green for open/unlocked
        end

        -- Display the sprite if the lock is unlocked or in its special mode
        if bDisplaySprite then
            local vSpritePos = eEntity:GetPos() + eEntity:GetUp() * -8.8 + eEntity:GetForward() * -4.8 + eEntity:GetRight() * 3.7

            render.SetMaterial(glowMaterial)
            render.DrawSprite(vSpritePos, 6, 6, cColor)
        end
    end
end)