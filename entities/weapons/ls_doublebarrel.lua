AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "Gonome Claws"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "fist"

SWEP.WorldModel = ""
SWEP.ViewModel = "models/zombie/hla/hands/v_worker01_hands.mdl"
SWEP.ViewModelFOV = 135
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

-- Primary attack
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Delay = 1.5
SWEP.Primary.Damage = 33.33
SWEP.Primary.Range = 45

-- Secondary unused
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

-- Sounds
SWEP.SwingSound = Sound("npc/zombie/claw_miss1.wav")
SWEP.HitSound = Sound("npc/zombie/claw_strike1.wav")

SWEP.IronsightsPos = Vector(0,0,0)
SWEP.IronsightsAng = Angle(0,0,0)

SWEP.LoweredPos = Vector(0, -16, -13)
SWEP.LoweredAng = Angle(45, 0, 0)

-- PRIMARY ATTACK
function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    -- Swing sound & player attack animation
    self:EmitSound(self.SwingSound)
    owner:SetAnimation(PLAYER_ATTACK1)

    -- Client-side: play claw swing animation smoothly
    if CLIENT then
        local vm = owner:GetViewModel()
        if IsValid(vm) then
            local seq = vm:LookupSequence("anim_fire3_layer") -- make sure this exists!
            if seq and seq ~= -1 then
                vm:SendViewModelMatchingSequence(seq)
                vm:SetPlaybackRate(1)
                vm:SetCycle(0)

                -- Reset to idle after animation finishes
                timer.Simple(5, function()
                    if IsValid(owner) then
                        local vm2 = owner:GetViewModel()
                        if IsValid(vm2) then
                            local idleSeq = vm2:LookupSequence("idle")
                            if idleSeq and idleSeq ~= -1 then
                                vm2:SendViewModelMatchingSequence(idleSeq)
                                vm2:SetPlaybackRate(1)
                                vm2:SetCycle(0)
                            end
                        end
                    end
                end)
            end
        end
    end

    -- Server-side: damage trace
    if SERVER then
        local tr = util.TraceHull({
            start = owner:GetShootPos(),
            endpos = owner:GetShootPos() + owner:GetAimVector() * self.Primary.Range,
            filter = owner,
            mins = Vector(-10,-10,-10),
            maxs = Vector(10,10,10),
            mask = MASK_SHOT_HULL
        })

        if tr.Hit then
            self:EmitSound(self.HitSound)

            local dmg = DamageInfo()
            dmg:SetDamage(self.Primary.Damage)
            dmg:SetAttacker(owner)
            dmg:SetInflictor(self)
            dmg:SetDamageForce(owner:GetAimVector() * 500)
            dmg:SetDamagePosition(tr.HitPos)
            dmg:SetDamageType(DMG_SLASH)

            if IsValid(tr.Entity) then
                tr.Entity:TakeDamageInfo(dmg)
            end
        end
    end
end

-- SECONDARY ATTACK
function SWEP:SecondaryAttack()
    return false
end

-- RELOAD
function SWEP:Reload()
    return false
end