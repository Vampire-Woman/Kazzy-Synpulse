AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "AR-1"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "ar2"

SWEP.WorldModel = Model("models/weapons/ocipr/w_ocipr.mdl")
SWEP.ViewModel = Model("models/weapons/ocipr/c_ocipr.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.EmptySound = Sound("Weapon_AR2.Empty")

function SWEP:Reload()
	if self:Clip1() >= self:GetMaxClip1() then return end
	if self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType()) <= 0 then return end

	self:DefaultReload(ACT_VM_RELOAD)

	-- First reload sound
	self:EmitSound("ar1/ar2_reload_rotate.wav")

	-- Second reload sound after 1 second
	timer.Simple(1, function()
		if IsValid(self) then
			self:EmitSound("ar1/ar2_reload_push.wav")
		end
	end)
end

SWEP.Primary.Sound = Sound("TFA_HL2R_AR1.1")
SWEP.Primary.Recoil = 0.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 35
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.02 -- base spread value
SWEP.Primary.Delay = RPM(652)
SWEP.Primary.Tracer = "AR2Tracer"

SWEP.Primary.Ammo = "ar2"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.7 -- multiply
SWEP.Spread.CrouchMod = 0.7 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.4 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0.1 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.16 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-4.82, 0, 2.2)
SWEP.IronsightsAng = Angle(0, 0, 0)
SWEP.IronsightsFOV = 0.7
SWEP.IronsightsSensitivity = 0.7
SWEP.IronsightsCrosshair = true
SWEP.IronsightsRecoilVisualMultiplier = 4
SWEP.IronsightsMuzzleFlash = "AirboatMuzzleFlash"

local copyIronPos = Vector(SWEP.IronsightsPos.x, SWEP.IronsightsPos.y, SWEP.IronsightsPos.z)
local copyIronFOV = SWEP.IronsightsFOV + 0
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copySpreadVel = SWEP.Spread.VelocityMod + 0
SWEP.Attachments = {
	evr_scope = {
		Cosmetic = {
			Model = "models/props_combine/combine_binocular01.mdl",
			Bone = "Base",
			Pos = Vector(-0.38, 2, 7.791),
			Ang = Angle(90, -12.858, -90),
			Scale = 0.26,
			Skin = 0
		},
		ModSetup = function(e)
			e.IronsightsPos = Vector(-4.624, -17.286, 0.201)
			e.IronsightsFOV = 0.65
			e.FOVScoped = 0.3
			e.Spread.IronsightsMod = 0.4
			e.IronsightsSensitivity = 0.2
			e.Spread.VelocityMod = 1.1

			e.Primary.Burst = true
		end,
		ModCleanup = function(e)
			e.IronsightsPos = copyIronPos
			e.IronsightsFOV = copyIronFOV
			e.IronsightsSensitivity = copyIronSens
			e.Spread.VelocityMod = copySpreadVel
			e.FOVScoped = nil
			e.Spread.IronsightsMod = nil

			e.Primary.Burst = false
		end,
		NeedsHDR = true,
		Behaviour = "sniper_sight",
		ScopePaint = function(wep)
			if not CMB_OVERLAY then
		        CMB_OVERLAY = Material("effects/combine_binocoverlay")
		        CMB_OVERLAY:SetFloat("$salpha", "0.2")
		        CMB_OVERLAY:Recompute()
			end

			surface.SetDrawColor(Color(255, 255, 255, 255))
	        surface.SetMaterial(CMB_OVERLAY)
	        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	        
	        local lp = LocalPlayer()
	       	local trace = {}
			trace.start = lp:EyePos()
			trace.endpos = trace.start + lp:GetAimVector() * 7000
			trace.filter = lp

			local traceData = util.TraceLine(trace)
			local dist = "UNKWN"

			if not traceData.Hit and traceData.HitPos then
				return
			end

			dist = traceData.HitPos:Distance(lp:GetPos()) / 39.3701
			dist = math.floor(dist)

	    	local ang = lp:EyeAngles()
    		local bearing = impulse.AngleToBearing(ang)

			local w = (ScrW() * .5) + 200
			local h = (ScrH() * .5) - 150
			local c = Color(230, 0, 0)
			draw.SimpleText("RANGE: "..dist.."m", "DebugFixed", w, h, c)
			draw.SimpleText("BEARING: "..bearing.."º", "DebugFixed", w, h + 14, c)

			if wep:GetBursting() then
				draw.SimpleText("** FIRING **", "DebugFixed", w, h + 28, c)
			end
		end,
		ScopeTexture = Material("ph_scope/ph_scope_lens6")
	}
}

function SWEP:SecondaryAttack()
    local ply = self:GetOwner()

    if not IsValid(ply) or not ply:IsPlayer() then return end

    if ply:Team() == TEAM_OTA then
        if ply:GetTeamClass() == CLASS_ELITE then
            if not ply.BallCooldown or CurTime() >= ply.BallCooldown then
                ply:CombineSoldierBall()
            else
                --ply:ConCommand("say /bash")
            end
        else
            --ply:ConCommand("say /bash")
        end
    else
        return
    end
end

local soundData = {
    name        = "TFA_HL2R_AR1.1" ,
    channel     = CHAN_WEAPON,
    volume      = 1,
    soundlevel  = 80,
	pitch 		= {95, 110},
    sound       = "weapons/ar1/fire"..math.random( 1, 16 )..".wav"
}
sound.Add(soundData)