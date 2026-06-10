AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Restricted Combine Forcefield"
ENT.Category = "Suppressed: Combine Tech"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.bNoPersist = true

local BREAK_CHANCE = 0.01 -- high for testing purposes

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Mode")
	self:NetworkVar("Entity", 0, "Dummy")
end

local MODES = {
	{
		function(client)
			return true
		end,
		"On."
	},
	{
		function(client)
			return false
		end,
		"Off."
	}
}

if SERVER then
function ENT:SpawnFunction(client, trace)

	if not trace.Hit then return end

	local angles = (client:GetPos() - trace.HitPos):Angle()
	angles.p = 0
	angles.r = 0
	angles:RotateAroundAxis(angles:Up(), 270)

	local entity = ents.Create("impulse_forcefield_combine")

	local pos = trace.HitPos
	pos.z = math.Round(pos.z)

	entity:SetPos(pos + Vector(0,0,40))
	entity:SetAngles(angles:SnapTo("y",90))

	entity:Spawn()
	entity:Activate()

	return entity

end

function ENT:IsBroken()
	return self:GetNWBool("broken", false)
end

function ENT:SetBroken(state)
	self:SetNWBool("broken", state)
end

function ENT:BreakForcefield()
    -- Immediately prevent multiple breaks
    if self:IsBroken() or self.breaking then return end
    self.breaking = true -- lock breaking

    timer.Simple(2, function()
        if not IsValid(self) then return end
		
		self:EmitSound("ambient/energy/zap5.wav")
		
		if IsValid(self:GetDummy()) then
			self:GetDummy():EmitSound("ambient/energy/zap5.wav")
		end

        self:SetBroken(true)
        self.breaking = false -- unlock breaking (won't matter until repaired)
		self:SetSolid(SOLID_VPHYSICS)           -- keep the entity solid so E works
		self:SetCustomCollisionCheck(true)      -- your ShouldCollide hook will manage actual collisions
		self:EnableCustomCollisions(true)

        self:SetSkin(1)
        if IsValid(self:GetDummy()) then
            self:GetDummy():SetSkin(1)
        end

		local effect1 = EffectData()
		effect1:SetOrigin(self:GetPos() + Vector(0,10,0))
		util.Effect("cball_explode", effect1)

		local effect2 = EffectData()
		effect2:SetOrigin(self:GetDummy():GetPos() + Vector(0,0,10))
		util.Effect("cball_explode", effect2)
    end)
end

function ENT:RepairForcefield()
    self:SetBroken(false)
    self.breaking = false -- allow breaking again

    self:SetNotSolid(false)
    self:SetCustomCollisionCheck(true)
    self:EnableCustomCollisions(true)

    self:SetSkin(0)
    self:GetDummy():SetSkin(0)

		-- Play repair sound at main entity
	self:EmitSound("combine_tech/forcefield/repair_field_complete.mp3")

	-- Play repair sound at dummy entity if valid
	if IsValid(self:GetDummy()) then
		self:GetDummy():EmitSound("combine_tech/forcefield/repair_field_complete.mp3")
	end
end

function ENT:Initialize()

	self:SetModel("models/props_combine/combine_fence01b.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)

	local data = {}
	data.start = self:GetPos() + self:GetRight() * -16
	data.endpos = self:GetPos() + self:GetRight() * -480
	data.filter = self
	
	local trace = util.TraceLine(data)

	self.startPos = data.start
	self.endPos = trace.HitPos
	
	local angles = self:GetAngles()
	angles:RotateAroundAxis(angles:Up(), 90)	

	self.dummy = ents.Create("prop_physics")
	self.dummy:SetModel("models/props_combine/combine_fence01a.mdl")
	self.dummy:SetPos(trace.HitPos)
	self.dummy:SetAngles(self:GetAngles())
	self.dummy:Spawn()
	self.dummy.PhysgunDisabled = true

	self:DeleteOnRemove(self.dummy)

	local verts = {
		{pos = Vector(0,0,-25)},
		{pos = Vector(0,0,150)},
		{pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0,0,150)},
		{pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0,0,150)},
		{pos = self:WorldToLocal(self.dummy:GetPos()) - Vector(0,0,25)},
		{pos = Vector(0,0,-25)}
	}

	self:PhysicsFromMesh(verts)

	local physObj = self:GetPhysicsObject()

	if IsValid(physObj) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end

	self:SetCustomCollisionCheck(true)
	self:EnableCustomCollisions(true)
	self:SetDummy(self.dummy)

	physObj = self.dummy:GetPhysicsObject()

	if IsValid(physObj) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end

	self:SetMoveType(MOVETYPE_PUSH)
	self:MakePhysicsObjectAShadow()

	self:SetMode(1)

	self:SetSkin(0)
	self:GetDummy():SetSkin(0)

	self.bbuzzer = CreateSound(self, "ambient/machines/combine_shield_loop3.wav")
	self.fbuzzer = CreateSound(self.dummy, "ambient/machines/combine_shield_loop3.wav")

	if self.bbuzzer and self.fbuzzer then
		local timerName = "BBuzzerLoop_" .. self:EntIndex()

		timer.Create(timerName, 8, 0, function()
			if not IsValid(self) then return end

			if self.bbuzzer then
				self.bbuzzer:Stop()
				self.bbuzzer:PlayEx(0.25, 100)
			end

			if IsValid(self.dummy) and self.fbuzzer then
				self.fbuzzer:Stop()
				self.fbuzzer:PlayEx(0.25, 100)
			end
		end)

		-- start immediately
		self.bbuzzer:PlayEx(0.25, 100)
		self.fbuzzer:PlayEx(0.25, 100)
	end
end

function ENT:StartTouch(entity)
    -- Remove the old breaking logic:
    -- if not self:IsBroken() and math.random() < BREAK_CHANCE then
    --     self:BreakForcefield()
    --     return
    -- end

    -- Only play buzzer sound if needed
    if not self.buzzer then
        self.buzzer = CreateSound(entity,"ambient/machines/combine_shield_touch_loop1.wav")
        self.buzzer:Play()
        self.buzzer:ChangeVolume(0.25,0)
    else
        self.buzzer:Play()
        self.buzzer:ChangeVolume(0.25,0)
    end

    self.entities = (self.entities or 0) + 1
end

function ENT:EndTouch()

	self.entities = math.max((self.entities or 0) - 1,0)

	if self.buzzer and self.entities == 0 then
		self.buzzer:FadeOut(0.25)
	end

end

function ENT:OnRemove()

	if self.buzzer then
		self.buzzer:Stop()
		self.buzzer = nil
	end

end

function ENT:Use(activator)
    if (self.nextUse or 0) > CurTime() then return end
    self.nextUse = CurTime() + 1.5

    -- Workers can repair
    if activator:Team() == TEAM_WORKER and self:IsBroken() then
        self:RepairForcefield()
        activator:Notify("You repaired the forcefield!")
        return
    end

    -- CPs can cycle modes even if broken
    if activator:Team() == TEAM_CP then
        local mode = self:GetMode() + 1
        if mode > #MODES then mode = 1 end
        self:SetMode(mode)

        -- Set skins
        if self:IsBroken() then
            self:SetSkin(1) -- broken + mode skin
            if IsValid(self:GetDummy()) then
                self:GetDummy():SetSkin(1)
            end
        else
            if mode == 1 then
                self:SetSkin(0)
                self:GetDummy():SetSkin(0)
            else
                self:SetSkin(1)
                self:GetDummy():SetSkin(1)
            end
        end

        self:SetCustomCollisionCheck(true)
        self:EnableCustomCollisions(true)
		local dummy = self:GetDummy()
		activator:ForceSequence("harassfront1")
        self:EmitSound("buttons/combine_button1.wav", 75, 100 + (mode - 0) * -25)
		dummy:EmitSound("buttons/combine_button1.wav", 75, 100 + (mode - 0) * -25)
        activator:Notify("Changed forcefield mode to: " .. MODES[mode][2])
        return
    end

	-- Pick a random sound once
	local soundIndex = math.random(1,3)
	local soundPath = "ambient/water/rain_drip"..soundIndex..".wav"

	-- Play on self
	self:EmitSound(soundPath, 66, 100)

	-- Play on dummy if valid
	if IsValid(self:GetDummy()) then
		self:GetDummy():EmitSound(soundPath, 66, 100)
	end

	if activator:IsPlayer() then
		if activator:Team() == TEAM_WORKER then
			--activator:Notify("It's not broken. Get back to work.")
		else
			--activator:Notify("The forcefield buzzes something you don't understand. It was probably a slur.")
		end
	end
end

-- Hook to detect Gonome primary attacks for sparking and optional break
hook.Add("EntityTakeDamage", "ForcefieldGonomeHit", function(target, dmginfo)
    if not IsValid(target) then return end
    if target:GetClass() ~= "impulse_forcefield_combine" then return end

    local attacker = dmginfo:GetAttacker()
    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    if target:IsBroken() then return end

    if attacker:Team() == TEAM_GONOME or attacker:Team() == TEAM_HAVANGER then
        local wep = attacker:GetActiveWeapon()
        if IsValid(wep) and wep:GetClass() == "weapon_zombie_classic" or wep:GetClass() == "weapon_zombie_fast" then
            -- Only respond to primary attack types (slash/club)
            if dmginfo:GetDamageType() == DMG_SLASH or dmginfo:GetDamageType() == DMG_CLUB then
			-- local roll = math.random()
			-- print("[Forcefield] Break roll: "..roll.." BREAK_CHANCE="..tostring(BREAK_CHANCE))
                -- Sparks
                target:EmitSound("combine_tech/forcefield/spark_sparkles_"..math.random(1,14)..".mp3", 66, 100)
                if IsValid(target:GetDummy()) then
                    target:GetDummy():EmitSound("combine_tech/forcefield/spark_sparkles_"..math.random(1,14)..".mp3", 66, 100)
                end

                -- Optional: small chance to break on hit
                if not target:IsBroken() and math.random() < BREAK_CHANCE then
                    target:BreakForcefield()
                end
            end
        end
    end
end)

hook.Add("ShouldCollide","forcefieldColcheck",function(a,b)

	local client
	local entity

	if a:IsPlayer() then
		client = a
		entity = b
	elseif b:IsPlayer() then
		client = b
		entity = a
	end

	if IsValid(entity) and entity:GetClass() == "impulse_forcefield_combine" then

		if entity:GetNWBool("broken",false) then
			return false
		end

		if IsValid(client) then

			if client:IsArrested() then return false end
			if client:IsCP() then return false end

			local mode = entity:GetMode() or 1
			return istable(MODES[mode]) and MODES[mode][1](client)

		end

	end

end)

else
    local SHIELD_MATERIAL = Material("effects/combineshield/comshieldwall3")

    function ENT:Initialize()
        local data = {}
        data.start = self:GetPos() + self:GetRight() * -16
        data.endpos = self:GetPos() + self:GetRight() * -480
        data.filter = self

        local trace = util.TraceLine(data)

        self.startPos = data.start
        self.endPos = trace.HitPos
    end

    function ENT:Draw()
        self:DrawModel()
    end

	function ENT:DrawTranslucent()
		if self:GetNWBool("broken", false) then return end -- don't draw if broken
		if self:GetMode() ~= 1 then return end -- don't draw if mode is not "On"
		if not self.startPos or not self.endPos then return end
		if EyePos():Distance(self:GetPos()) > 2450 then return end

		local bottom = Vector(0,0,-40)
		local top = Vector(0,0,150)

		local p1 = self.startPos + bottom
		local p2 = self.startPos + top
		local p3 = self.endPos + top
		local p4 = self.endPos + bottom

		render.SetMaterial(SHIELD_MATERIAL)

		mesh.Begin(MATERIAL_QUADS, 2)

			-- Front face
			mesh.Position(p1)
			mesh.TexCoord(0,0,0)
			mesh.AdvanceVertex()

			mesh.Position(p2)
			mesh.TexCoord(0,0,3)
			mesh.AdvanceVertex()

			mesh.Position(p3)
			mesh.TexCoord(0,3,3)
			mesh.AdvanceVertex()

			mesh.Position(p4)
			mesh.TexCoord(0,3,0)
			mesh.AdvanceVertex()

			-- Back face (reversed order)
			mesh.Position(p4)
			mesh.TexCoord(0,0,0)
			mesh.AdvanceVertex()

			mesh.Position(p3)
			mesh.TexCoord(0,0,3)
			mesh.AdvanceVertex()

			mesh.Position(p2)
			mesh.TexCoord(0,3,3)
			mesh.AdvanceVertex()

			mesh.Position(p1)
			mesh.TexCoord(0,3,0)
			mesh.AdvanceVertex()

		mesh.End()
	end
end