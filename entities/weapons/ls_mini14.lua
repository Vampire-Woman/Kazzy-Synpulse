AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "Sniper Pulse Rifle"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/lrh/w_ospr.mdl")
SWEP.ViewModel = Model("models/weapons/lrh/c_ospr.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("npc/sniper/reload1.wav")
SWEP.EmptySound = Sound("buttons/combine_button3.wav")

SWEP.Primary.Sound = Sound("NPC_Sniper.FireBullet")
SWEP.Primary.Recoil = 1.1
SWEP.Primary.Damage = 1000
SWEP.Primary.PenetrationScale = 2
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.029
SWEP.Primary.Delay = RPM(1000)

SWEP.Primary.Ammo = "Rifle"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0
SWEP.Spread.IronsightsMod = 0
SWEP.Spread.CrouchMod = 0
SWEP.Spread.AirMod = 0
SWEP.Spread.RecoilMod = 0
SWEP.Spread.VelocityMod = 0

SWEP.IronsightsPos = Vector(-0.893, 0, 0.365)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.5
SWEP.IronsightsSensitivity = 0.2
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 1

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(70, 0, 0)

-------------------------------------------------
-- LASER BEAM (FIXED)
-------------------------------------------------

if CLIENT then

local beam = Material("effects/bluelaser2")
local sprite = Material("effects/blueflare1")

function SWEP:ShouldDrawBeam()
    return self:GetIronsights() and self:Clip1() > 0
end

function SWEP:GetAimTrace()
    local ply = self:GetOwner()

    return util.TraceLine({
        start = ply:GetShootPos(),
        endpos = ply:GetShootPos() + ply:GetAimVector() * 8192,
        filter = {ply, self},
        mask = MASK_SHOT
    })
end

-- First person beam
function SWEP:PostDrawViewModel(vm)

    if not self:ShouldDrawBeam() then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    local att = vm:GetAttachment(2)
    if not att then return end

    local tr = self:GetAimTrace()

    render.SetMaterial(beam)
    render.DrawBeam(att.Pos, tr.HitPos, 2, 0, tr.Fraction * 10, Color(255,0,0))

    render.SetMaterial(sprite)
    render.DrawSprite(tr.HitPos, 4, 4, Color(50,190,255))

end

-- Third person beam
function SWEP:PostDrawTranslucentRenderables()

    if not self:ShouldDrawBeam() then return end

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local att = self:GetAttachment(3)
    if not att then return end

    local tr = self:GetAimTrace()

    render.SetMaterial(beam)
    render.DrawBeam(att.Pos, tr.HitPos, 2, 0, tr.Fraction * 10, Color(255,0,0))

    render.SetMaterial(sprite)
    render.DrawSprite(tr.HitPos, 5, 5, Color(50,190,255))

end

end

-------------------------------------------------
-- FIRING
-------------------------------------------------

function SWEP:PrimaryAttack()
    if not self:GetIronsights() then
        return
    end

    self.BaseClass.PrimaryAttack(self)
end

-------------------------------------------------
-- SOUND
-------------------------------------------------

sound.Add({
    name = "NPC_Sniper.FireBullet",
    sound = "npc/sniper/echo1.wav",
    channel = CHAN_WEAPON,
    level = SNDLVL_GUNFIRE,
    pitch = {95, 105}
})