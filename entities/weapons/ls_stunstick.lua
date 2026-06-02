AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Stun Baton"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "melee"

SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")
SWEP.ViewModel = Model("models/weapons/tfa_hl2r/c_stunbaton.mdl")
SWEP.ViewModelFOV = 52

SWEP.Slot = 4
SWEP.SlotPos = 1

SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")
SWEP.Primary.ImpactSound = Sound("weapons/stunstick/stunstick_impact2.wav")
SWEP.Primary.ImpactEffect = "StunstickImpact"
SWEP.Primary.FlashTime = 1
SWEP.Primary.Recoil = 1.2
SWEP.Primary.Damage = 0.0
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.7
SWEP.Primary.Range = 75

SWEP.Attachments = {
	riot_shield = {
		Cosmetic = {
			Model = "models/bshields/rshield.mdl",
			PlayerParent = true,
			Bone = "ValveBiped.Bip01_L_Hand",
			Pos = Vector(-14.3, -2, 20),
			Ang = Angle(80, 0, 0),
			Scale = 0.85,
			Skin = 0,
			World = {
				Bone = "ValveBiped.Bip01_L_Hand",
				Pos = Vector(-3, 2, 0),
				Ang = Angle(-25, 90, 0),
				Scale = 0.85
			}
		},
		ModSetup = function(e)
		end,
		ModCleanup = function(e)
		end
	}
}

sound.Add({
	name = "lsStunstickBuzz",
	channel = CHAN_AUTO,
	volume = 0.34,
	level = 45,
	sound = "ambient/machines/combine_shield_touch_loop1.wav"
})

function SWEP:ExtraDataTables()
	self:NetworkVar("Int", 5, "Mode")
end

function SWEP:ExtraHolster()
	self.Owner:StopSound("lsStunstickBuzz")

	self:SetMode(1)
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:StopSound("lsStunstickBuzz")
	end
end

function SWEP:OnLowered()
	self:SetMode(1)


	self.Owner:StopSound("lsStunstickBuzz")
end

function SWEP:PrePrimaryAttack()
	local mode = self:GetMode()

	if mode == 1 then
		self.Primary.Damage = 3
		self.Primary.ImpactEffect = nil
		self.Primary.FlashTime = 0.2
		self.Primary.Sound = Sound("WeaponFrag.Roll")
		self.Primary.ImpactSound = Sound("physics/plastic/plastic_barrel_impact_bullet1.wav")
	else
		if mode == 2 then
			self.Primary.Damage = 9
			self.Primary.FlashTime = 0.8
		else
			self.Primary.Damage = 25
			self.Primary.FlashTime = 1.1
		end

		self.Primary.ImpactEffect = "StunstickImpact"
		self.Primary.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")
		self.Primary.ImpactSound = Sound("weapons/stunstick/stunstick_impact2.wav")
	end
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_SPEED) then
		local oldMode = self:GetMode()
		local newMode = oldMode + 1

		if newMode > 3 then
			newMode = 1
			self.Owner:StopSound("lsStunstickBuzz")
		end

		if SERVER then
			self:SetMode(newMode)

			local seq = "deactivatebaton"

			if newMode > 1 then
				self.Owner:EmitSound("weapons/stunstick/spark3.wav", 100, math.random(90, 110))
				seq = "activatebaton"
			else
				self.Owner:EmitSound("weapons/stunstick/spark"..math.random(1, 2)..".wav", 100, math.random(90, 110))
			end

			if newMode == 3 then
				self.Owner:EmitSound("lsStunstickBuzz")
			end

			if self.Owner:Team() == TEAM_CP then
				self.Owner:ForceSequence(seq, nil, nil, true)
			end
		end

		return self:SetNextSecondaryFire(CurTime() + 1)
	end

	self.Owner:LagCompensation(true)

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 72
	trace.filter = self.Owner
	trace.mins = Vector(-7, -7, -30)
	trace.maxs = Vector(8, 8, 10)

	local tr = util.TraceHull(trace)
	local ent = tr.Entity
	self.Owner:LagCompensation(false)

	if SERVER and ent and IsValid(ent) then
		if ent:IsPlayer() then
			self.Owner:EmitSound("weapons/crossbow/hitbod"..math.random(1, 2)..".wav")
			local direction = self.Owner:GetAimVector() * 330
			direction.z = 0

			ent:SetVelocity(direction)

			if self.Owner:Team() == TEAM_CP then
				self.Owner:ForceSequence("pushplayer")
			end

			self:SetNextSecondaryFire(CurTime() + 2)
		end
	end
end

-- based on NS sunstick effects:

local STUNSTICK_GLOW_MATERIAL = Material("effects/stunstick")
local STUNSTICK_GLOW_MATERIAL2 = Material("effects/blueflare1")
local STUNSTICK_GLOW_MATERIAL_NOZ = Material("sprites/light_glow02_add_noz")

local color_glow = Color(128, 128, 128)

function SWEP:ExtraDrawWorldModel()
	self:DrawModel()
	local mode = self:GetMode()

	if not mode or mode < 2 then
		return
	end

	local size

	if mode == 2 then
		size = math.Rand(4.0, 6.0)
	else
		size = math.Rand(6.5, 7.5)
	end

	local glow = math.Rand(0.6, 0.8) * 255
	local color = Color(glow, glow, glow)
	local attachment = self:GetAttachment(1)

	if (attachment) then
		local position = attachment.Pos

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL2)
		render.DrawSprite(position, size * 2, size * 2, color)

		render.SetMaterial(STUNSTICK_GLOW_MATERIAL)
		render.DrawSprite(position, size, size + 3, color_glow)
	end
end

local NUM_BEAM_ATTACHEMENTS = 4
local BEAM_ATTACH_CORE_NAME	= "sparkrear"

function SWEP:PostDrawViewModel()
    local mode = self:GetMode()

    -- Only run the code if mode is valid and >= 2
    if not mode or mode < 2 then
        return
    end

    local vm = LocalPlayer():GetViewModel()

    -- Ensure the view model is valid
    if not IsValid(vm) then
        return
    end

    cam.Start3D(EyePos(), EyeAngles())
        local size

        -- Set sprite size based on mode
        if mode == 2 then
            size = math.Rand(3.0, 4.0)
        else
            size = math.Rand(6.0, 8.0)
        end

        -- Set color with dynamic alpha change over time
        local color = Color(255, 255, 255, 50 + math.sin(RealTime() * 2) * 20)

        -- Set the material for the glow effect
        STUNSTICK_GLOW_MATERIAL_NOZ:SetFloat("$alpha", color.a / 255)
        render.SetMaterial(STUNSTICK_GLOW_MATERIAL_NOZ)

        -- Core Attachment (Beam Attach)
        local attachment = vm:GetAttachment(vm:LookupAttachment(BEAM_ATTACH_CORE_NAME))

        if attachment and attachment.Pos then
            -- Optional: Adjust position of the core attachment using offsets (tune these values)
            local adjustedPos = attachment.Pos + attachment.Ang:Right() * 0 + attachment.Ang:Up() * 0 -- Modify these for fine adjustments
            render.DrawSprite(adjustedPos, size * 15, size * 15, color)
        end

        -- Loop through spark attachments (spark1a, spark1b, etc.)
		for i = 1, NUM_BEAM_ATTACHEMENTS do
			local attachmentA = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))
			local attachmentB = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))
			local attachmentC = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))
			local attachmentD = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))
			local attachmentE = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))
			local attachmentF = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))
			local attachmentI = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))
			local attachmentJ = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))		
			local attachmentK = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))			
			local attachmentL = vm:GetAttachment(vm:LookupAttachment("spark" .. i .. "b"))

			size = math.Rand(2.5, 5.0)

			-- Adjust for attachment A
			if attachmentA and attachmentA.Pos then
				local adjustedPosA = attachmentA.Pos + attachmentA.Ang:Right() * -0 + attachmentA.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosA, size, size, color)
			end

			-- Adjust for attachment B
			if attachmentB and attachmentB.Pos then
				local adjustedPosB = attachmentB.Pos + attachmentB.Ang:Right() * -0.5 + attachmentB.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosB, size, size, color)
			end

			-- Adjust for attachment C
			if attachmentC and attachmentC.Pos then
				local adjustedPosC = attachmentC.Pos + attachmentC.Ang:Right() * -1.5 + attachmentC.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosC, size, size, color)
			end

			-- Adjust for attachment D
			if attachmentD and attachmentD.Pos then
				local adjustedPosD = attachmentD.Pos + attachmentD.Ang:Right() * -2.5 + attachmentD.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosD, size, size, color)
			end

			-- Adjust for attachment E
			if attachmentE and attachmentE.Pos then
				local adjustedPosE = attachmentE.Pos + attachmentE.Ang:Right() * -3.5 + attachmentE.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosE, size, size, color)
			end

			-- Adjust for attachment F
			if attachmentF and attachmentF.Pos then
				local adjustedPosF = attachmentF.Pos + attachmentF.Ang:Right() * -4.5 + attachmentF.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosF, size, size, color)
			end

			-- Adjust for attachment G
			if attachmentG and attachmentG.Pos then
				local adjustedPosG = attachmentG.Pos + attachmentG.Ang:Right() * -5.5 + attachmentG.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosG, size, size, color)
			end
			
			-- Adjust for attachment H
			if attachmentH and attachmentH.Pos then
				local adjustedPosH = attachmentH.Pos + attachmentH.Ang:Right() * -5 + attachmentH.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosH, size, size, color)
			end			
			
			-- Adjust for attachment I
			if attachmentI and attachmentI.Pos then
				local adjustedPosI = attachmentI.Pos + attachmentI.Ang:Right() * -4 + attachmentI.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosI, size, size, color)
			end			

			-- Adjust for attachment J
			if attachmentJ and attachmentJ.Pos then
				local adjustedPosJ = attachmentJ.Pos + attachmentJ.Ang:Right() * -3 + attachmentJ.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosJ, size, size, color)
			end			

			-- Adjust for attachment K
			if attachmentK and attachmentK.Pos then
				local adjustedPosK = attachmentK.Pos + attachmentK.Ang:Right() * -2 + attachmentK.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosK, size, size, color)
			end				

			-- Adjust for attachment L
			if attachmentL and attachmentL.Pos then
				local adjustedPosL = attachmentL.Pos + attachmentL.Ang:Right() * -1 + attachmentL.Ang:Up() * -0.5
				render.DrawSprite(adjustedPosL, size, size, color)
			end									
		end
    cam.End3D()
end