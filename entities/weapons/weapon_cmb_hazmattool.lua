AddCSLuaFile()

SWEP.PrintName				= "Foam Applicator"
SWEP.Author					= "Bloodmore"
SWEP.Instructions			= ""
SWEP.Purpose				= ""
SWEP.Category 				= "impulse HL2RP Weapons"

SWEP.Spawnable				= true
SWEP.AdminOnly				= false

SWEP.ShouldDropOnDie		= false
SWEP.HoldType				= "ar2"

SWEP.Primary.Damage			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.Slot					= 4
SWEP.SlotPos				= 1

SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true

SWEP.ViewModel		= "models/hls/alyxports/c_applicator.mdl"
SWEP.WorldModel		= "models/hls/alyxports/w_applicator.mdl"
SWEP.ViewModelFOV	= 70

SWEP.UseHands				= true

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)

    if SERVER then
        self:SetCleansLeft( 5 )
        self:SetCleansMax( 5 )

        self.NextReload = 0
    end
end

function SWEP:CanPrimaryAttack()
	return self:GetNextPrimaryFire() < CurTime()
end

function SWEP:SetupDataTables()
    self:NetworkVar( "Int", 0, "CleansLeft" )
    self:NetworkVar( "Int", 1, "CleansMax" )
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    
    if self.Owner:Team() ~= TEAM_HAZMAT then return self.Owner:Notify( "helix.xenflora.lethal" ) end

    local eEntity = self.Owner:GetEyeTrace().Entity
    if not IsValid( eEntity ) or eEntity:GetClass() ~= "ent_xen_flora" then return end
    if ( eEntity:GetLastClean() or 0 ) > CurTime() then return self.Owner:Notify( L"helix.xenflora.alreadyCleaned" ) end

    local iCleansLeft = self:GetCleansLeft()
    if iCleansLeft <= 0 then return self.Owner:Notify( L"helix.xenflora.noCleansLeft" ) end

    eEntity:DoClean( self.Owner )
end

function SWEP:SecondaryAttack()
    return false
end

function SWEP:Reload()
    if CLIENT then return end	
	if not IsValid( self.Owner ) then return end

	if IsFirstTimePredicted() and self.NextReload < CurTime() then
		self.Owner:Notify("You have 5 litre(s) of cleanup solution remaining.")
		
        self.NextReload = CurTime() + 5
    end
end

function SWEP:Deploy()
	self:SetHoldType( self.HoldType )

	return true
end