AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Welding Gun"
    SWEP.Slot = 2
    SWEP.SlotPos = 1
    SWEP.CLMode = 0
    SWEP.DrawAmmo = false
    SWEP.UseHands = true
end

SWEP.HoldType = "pistol"
SWEP.Category = "impulse HL2RP Weapons"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawWeaponInfoBox = false

SWEP.ViewModel = "models/props_combine/combine_emitter01.mdl"
SWEP.WorldModel = "models/props_combine/combine_emitter01.mdl"
SWEP.ViewModelOffset = Vector(0, 0, 0)
SWEP.ViewModelOffsetAng = Angle(0, 0, 90)

SWEP.Primary.Delay = 3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.IsAlwaysRaised = false

SWEP.Secondary.Delay = 3
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.ShouldDropOnDie = false

SWEP.Base = "weapon_base"

local LastAttackTime = 0
local CuttingStartTime = 0
local CuttingDuration = 3 -- Duration to cut before destroying a prop (in seconds)

function SWEP:Initialize()
    self:SetHoldType("pistol")
    CuttingStartTime = 0 -- Reset cutting start time when the weapon is initialized

    if SERVER then return end

    WeldEffects(LocalPlayer(), true)
    LocalPlayer().IsWelding = false
end

function SWEP:Deploy()
    CuttingStartTime = 0 -- Reset cutting start time when the weapon is deployed
    self:SetHoldType("pistol")
    -- Ensure the hands are visible when deployed
    if CLIENT then
        self.Owner:DrawViewModel(true)
    end
    return true
end


function SWEP:OnLowered()
    if SERVER then return end

    WeldEffects(LocalPlayer(), true)
    LocalPlayer().IsWelding = false
end

function SWEP:OnRemove()
    if SERVER then return end

    WeldEffects(LocalPlayer(), true)
    LocalPlayer().IsWelding = false
end

function SWEP:Think()
    if SERVER then return end

    if not input.IsButtonDown(MOUSE_LEFT) or (not LocalPlayer():IsWeaponRaised()) then
        if LocalPlayer().IsWelding then
            WeldEffects(LocalPlayer(), true)
            LocalPlayer().IsWelding = false
        end
    else
        if not LocalPlayer().IsWelding then
            if LocalPlayer():IsWeaponRaised() then
                WeldEffects(LocalPlayer())
                LocalPlayer().IsWelding = true
            end
        end
    end
end

function SWEP:PrimaryAttack()
    local curTime = CurTime()

    if curTime - LastAttackTime < self.Primary.Delay then return end

    LastAttackTime = curTime

    if SERVER then
        local ply = self:GetOwner()
        local trace = ply:GetEyeTrace()

        if IsValid(trace.Entity) and trace.Entity:GetClass() == "prop_physics" then
            if trace.Entity:IsWorld() or trace.Entity:MapCreationID() ~= -1 then return end -- Prevent destroying world and map props

            local distance = ply:GetPos():Distance(trace.HitPos)
            if distance <= 30 * 2.54 then
                local model = trace.Entity:GetModel()

                if model ~= "models/props_combine/combine_fence01a.mdl" and model ~= "models/props_combine/combine_fence01b.mdl" then
                    if not trace.Entity:IsPlayerHolding() then
                        if CuttingStartTime == 0 then
                            CuttingStartTime = curTime
                        elseif curTime - CuttingStartTime >= CuttingDuration then
                            --trace.Entity:Remove()
                            --ply:EmitSound("physics/metal/metal_sheet_impact_hard8.wav")
                            CuttingStartTime = 0 -- Reset the cutting start time
                        end
                    end
                end
            end
        end
    end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
    self:SetHoldType("pistol")
    return false
end

function SWEP:GetViewModelPosition(pos, ang)
    ang:RotateAroundAxis(ang:Right(), self.ViewModelOffsetAng.p)
    ang:RotateAroundAxis(ang:Up(), self.ViewModelOffsetAng.y)
    ang:RotateAroundAxis(ang:Forward(), self.ViewModelOffsetAng.r)

    pos = pos + self.ViewModelOffset.x * ang:Right()
    pos = pos + self.ViewModelOffset.y * ang:Forward()
    pos = pos + self.ViewModelOffset.z * ang:Up()

    return pos, ang
end

if CLIENT then
    local WorldModel = ClientsideModel(SWEP.WorldModel)
    WorldModel:SetNoDraw(true)

    function SWEP:DrawWorldModel()
        local _Owner = self:GetOwner()

        if IsValid(_Owner) then
            local offsetVec = Vector(1, -1, -2.5)
            local offsetAng = Angle(-90, 180, 0)

            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand")
            if not boneid then return end

            local matrix = _Owner:GetBoneMatrix(boneid)
            if not matrix then return end

            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)
            WorldModel:SetModelScale(0.33)
            WorldModel:SetupBones()
        else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
        end

        WorldModel:DrawModel()
    end
end