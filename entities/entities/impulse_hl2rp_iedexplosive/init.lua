AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = "models/weapons/w_c4_planted.mdl"

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator, caller)
    self:Beep() -- start beeping
    timer.Create("explosionTimer", 5, 1, function() self:Explode() end) -- start the countdown and explosion
end

function ENT:Beep()
    if not IsValid(self) then return end -- check if self is still a valid entity
    self:EmitSound("weapons/c4/c4_beep1.wav", 75, 100, 1, CHAN_ITEM) -- play the beep sound
    timer.Create("beepTimer", 1, 9, function() 
        if not IsValid(self) then return end -- check if self is still a valid entity
        self:EmitSound("weapons/c4/c4_beep1.wav", 75, 100, 1, CHAN_ITEM) -- play the beep sound
    end) -- schedule 9 more beeps
end

function ENT:Explode()
    local pos = self:GetPos()

    -- Create the explosion effect (you can use "HelicopterMegaBomb" or any other effect you want)
    local explosion = EffectData()
    explosion:SetOrigin(pos)
    explosion:SetMagnitude(3)
    explosion:SetScale(900)
    explosion:SetRadius(500)
    explosion:SetNormal(Vector(0, 0, 1))
    util.Effect("HelicopterMegaBomb", explosion)

    -- Apply damage to all players and NPCs within a specified radius
    local explosionRadius = 400   -- Radius for damage
    local explosionDamage = 900   -- Damage to entities (players, NPCs, etc.)

    -- Use Blast Damage to apply damage to nearby entities (players, NPCs)
    util.BlastDamage(self, self, pos, explosionRadius, explosionDamage)

    -- Play explosion sounds
    sound.Play("weapons/explode" .. math.random(3, 5) .. ".wav", pos, 150, math.random(90, 110))
    sound.Play("weapons/c4/c4_explode1.wav", pos, 500)
    sound.Play("weapons/c4/c4_exp_deb1.wav", pos, 125)
    sound.Play("weapons/c4/c4_exp_deb2.wav", pos, 125)
    sound.Play("ambient/atmosphere/terrain_rumble1.wav", pos, 108)

    -- Create a screen shake for nearby players
    util.ScreenShake(pos, 10, 5, 2.5, 1000)

    -- Remove the entity (bomb) after the explosion
    self:Remove()
end
