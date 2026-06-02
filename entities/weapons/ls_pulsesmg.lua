AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "Pulse Submachine Gun"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "smg"

SWEP.WorldModel = Model("models/weapons/psmg/w_psmg.mdl")
SWEP.ViewModel = Model("models/weapons/psmg/c_psmg.mdl")
SWEP.ViewModelFOV = 45

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

SWEP.Primary.Sound = Sound("TFA_HL2R_PSMG.1")
SWEP.Primary.Recoil = 0.18
SWEP.Primary.Damage = 14
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.038
SWEP.Primary.Delay = RPM(550)

SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 45
SWEP.Primary.DefaultClip = 45

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 0.04
SWEP.Spread.IronsightsMod = 0.97
SWEP.Spread.CrouchMod = 0.95
SWEP.Spread.AirMod = 1.2
SWEP.Spread.RecoilMod = 0
SWEP.Spread.VelocityMod = 0.1

SWEP.IronsightsPos = Vector(-4.651, -2.54, -0.55)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 4

-- ===============================
-- SECONDARY ATTACK OVERRIDE
-- ===============================

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    -- Only run on server
    if not SERVER then return end

    -- Cooldown check
    if self.NextVoiceLine and self.NextVoiceLine > CurTime() then return end
    self.NextVoiceLine = CurTime() + 5

    local attackKeys = {
        "ENGAGING",
        "TARGET ENGAGED",
        "PROSECUTING",
        "RESPONDING FA",
        "TAKING SHOT",
        "ATTACKING ADVANTAGE",
        "TAKING ADVANTAGE",
        "TARGET LOCKED",
        "WEAPONS FREE",
        "TARGET ONE",
        "JACKPOT CONFIRMED",
        "TARGET ILL",
        "FIRING",
        "PRIMARY ENGAGED",
        "ENGAGING TARGET",
        "OPEN DAGGERS",
        "OPEN FORM",
        "OPEN OPPRESSION",
        "CLEANING SECTOR",
        "COMMITTED",
        "FIRING PLAYER1",
        "FIRING PLAYER4",
        "FIRING PLAYER8",
        "FIRING 110",
        "FIRING 120",
        "FIRING 132",
        "FIRING 150",
        "FIRING 160",
        "FIRING 170",
        "FIRING 180",
        "FIRING 190",
        "FIRING 200",
        "PROSECUTING SECTOR"
    }

    local key = attackKeys[math.random(#attackKeys)]

    -- Prevent recursion
    if not ply._ImpulseVoiceBlock then
        ply._ImpulseVoiceBlock = true

        ply:ConCommand("say " .. key)

        timer.Simple(0, function()
            if IsValid(ply) then
                ply._ImpulseVoiceBlock = false
            end
        end)
    end
end

-- ===============================
-- SOUNDS (UNCHANGED)
-- ===============================

local soundData = {
    name = "0",
    channel = CHAN_WEAPON,
    volume = 0.5,
    soundlevel = 80,
    pitchstart = 100,
    pitchend = 100,
    sound = "psmg/eblaster_screw_in_0"..math.random(1, 5)..".wav"
}
sound.Add(soundData)

local soundData = {
    name = "1",
    channel = CHAN_WEAPON,
    volume = 0.5,
    soundlevel = 80,
    pitchstart = 100,
    pitchend = 100,
    sound = "ar1/ar2_reload_rotate.wav"
}
sound.Add(soundData)

local soundData = {
    name = "2",
    channel = CHAN_WEAPON,
    volume = 0.5,
    soundlevel = 80,
    pitchstart = 100,
    pitchend = 100,
    sound = "ar1/ar2_reload_push.wav"
}
sound.Add(soundData)

local soundData = {
    name = "TFA_HL2R_PSMG.1",
    channel = CHAN_WEAPON,
    volume = 1.5,
    soundlevel = 80,
    pitch = {120, 130},
    sound = "psmg/smg1_fire"..math.random(1, 16)..".wav"
}
sound.Add(soundData)

local soundData = {
    name = "TFA_HL2R_PSMG.2",
    channel = CHAN_WEAPON,
    volume = 1.7,
    soundlevel = 90,
    pitch = {95, 110},
    sound = "psmg/wpn_combine_smg_body_0"..math.random(1, 5)..".wav"
}
sound.Add(soundData)

local soundData = {
    name = "TFA_HL2R_PSMG.3",
    channel = CHAN_WEAPON,
    volume = 1.7,
    soundlevel = 90,
    pitch = {95, 110},
    sound = "psmg/wpn_combine_smg_tail_0"..math.random(1, 5)..".wav"
}
sound.Add(soundData)