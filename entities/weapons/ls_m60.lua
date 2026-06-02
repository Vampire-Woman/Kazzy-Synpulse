AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "Heavy Machine Gun"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "shotgun"

SWEP.WorldModel = Model("models/weapons/suppressor/w_suppressor.mdl")
SWEP.ViewModel = Model("models/weapons/suppressor/c_suppressor.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_M249.Reload")
SWEP.EmptySound = Sound("buttons/combine_button3.wav")

SWEP.Primary.Sound = Sound("TFA_HL2R_PMG.1")
SWEP.Primary.Recoil = 0.28 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 12
SWEP.Primary.PenetrationScale = 1.65
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.088
SWEP.Primary.Delay = RPM(600)

SWEP.Primary.Ammo = "Rifle"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 120
SWEP.Primary.DefaultClip = 120

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.03
SWEP.Spread.IronsightsMod = 0.65 -- multiply
SWEP.Spread.CrouchMod = 0.35 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.8 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.25 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(0, 0, 0)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.85
SWEP.IronsightsSensitivity = 1
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 3.5

SWEP.Attachments = {
	hula = {
		Cosmetic = {
			Model = "models/props_lab/huladoll.mdl",
			Bone = "v_weapon.m249",
			Pos = Vector(-0.721, -3.537, 3.635),
			Ang = Angle(-29.611, -5.844, -94.676),
			Scale = 0.379,
			Skin = 0
		},
		ModSetup = function(e)
			e.CustomShootEffects = function()
				if CLIENT and IsValid(e.AttachedCosmetic) then
					e:ResetSequence("shake")
				end
			end
		end,
		ModCleanup = function(e)
			e.CustomShootEffects = nil
		end,
		Behaviour = "dumb"
	}
}

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(45, 0, 0)

local soundData = {
    name                = "Weapon_Swing" ,
    channel     = CHAN_WEAPON,
    volume              = 0.3,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "suppressor/supressor_deploy_heavy.wav"
}
sound.Add(soundData)

local soundData = {
    name                = "Weapon_Swing2" ,
    channel     = CHAN_WEAPON,
    volume              = 0.3,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "suppressor/supressor_deploy.wav"
}
sound.Add(soundData)

local soundData = {
    name                = "Magazine.Out" ,
    channel     = CHAN_WEAPON,
    volume              = 1,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "pshotgun/wpn_shotgun_foley_close_tube_01.wav"
}
sound.Add(soundData)

local soundData = {
    name                = "Magazine.In" ,
    channel     = CHAN_WEAPON,
    volume              = 1,
    soundlevel  = 80,
    pitchstart  = 100,
    pitchend    = 100,
    sound               = "pshotgun/wpn_shotgun_foley_rack_back_01.wav"
}
sound.Add(soundData)


local soundData = {
    name        = "TFA_HL2R_PMG.1" ,
    channel     = CHAN_WEAPON,
    volume      = 1,
    soundlevel  = 100,
	pitch 		= {95, 105},
    sound       = "suppressor/suppressor_fire"..math.random( 1, 4 )..".wav"
}
sound.Add(soundData)
