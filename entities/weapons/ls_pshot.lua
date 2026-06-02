AddCSLuaFile()

SWEP.Base = "ls_base_shotgun"

SWEP.PrintName = "Shotgun Heavy"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/heavyshotgun/w_shotgun_heavy.mdl")
SWEP.ViewModel = Model("models/weapons/heavyshotgun/c_shotgun_heavy.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadShellSound = Sound("weapons/pshotgun/shotgun_cock.wav")
SWEP.EmptySound = Sound("Weapon_Shotun.Empty")

SWEP.Primary.Sound = Sound("weapons/pshotgun/wpn_combine_shotgun_fire_body_01.wav")
SWEP.Primary.Recoil = 3 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 6
SWEP.Primary.Cone = 0.069
SWEP.Primary.Delay = RPM(73)

SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 6

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.069
SWEP.Spread.Max = 0.2
SWEP.Spread.IronsightsMod = 1 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.01 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.15 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4.77, 0, 2.2)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.63
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 15
