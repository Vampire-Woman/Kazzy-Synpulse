AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "357 Magnum"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "revolver"

SWEP.WorldModel = Model("models/weapons/tfa_hl2r/w_357.mdl")
SWEP.ViewModel = Model("models/weapons/tfa_hl2r/c_357.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("weapons/tfa_hl2r/357/357_spin1.wav")
SWEP.EmptySound = Sound("Weapon_357.Empty")

SWEP.Primary.Sound = Sound("Weapon_357.Single")
SWEP.Primary.Recoil = 4 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 69420
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = RPM(65)

SWEP.Primary.Ammo = "357"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.01
SWEP.Spread.IronsightsMod = 0.4 -- multiply
SWEP.Spread.CrouchMod = 0.9 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.03 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.8 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-3.22, -2, 1.1)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.72
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 2

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(70, 0, 0)
