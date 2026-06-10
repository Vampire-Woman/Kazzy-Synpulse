AddCSLuaFile()

ENT.Base = "base_gmodentity"
ENT.Type = "anim"
ENT.PrintName = "Ration Dispenser"
ENT.Author = "Bloodmore"
ENT.Category = "impulse: HL2RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsBeingDrilled")
    self:NetworkVar("Int", 0, "Display")
    self:NetworkVar("Int", 1, "RationAmount") -- ration count
end

local allowedTeams = {
    [TEAM_CITIZEN] = true,
    [TEAM_CP] = true,
    [TEAM_OTA] = false,
    [TEAM_VORT] = false,
    [TEAM_WORKER] = true
}

ENT.Displays = {
    [1] = { " ", Color(255,255,255), true },
    [2] = { " ", Color(0,150,255) },
    [3] = { " ", Color(255,0,0), true },
    [4] = { " ", Color(255,0,0), true },
    [5] = { " ", Color(0,255,0) },
    [6] = { " ", Color(255,255,0) }
}

if SERVER then

-- Track players who have claimed a ration
ENT.ClaimedPlayers = {}
ENT.UseCooldown = 5
ENT.LastUseTime = {}

function ENT:Initialize()
    self:SetModel("models/Gibs/HGIBS.mdl")

    -- Temporarily disable physics
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_NONE)

    -- Lift and rotate entity exactly where you want
    local newPos = self:GetPos() + Vector(0,0,10) -- adjust to desired height
    local newAng = self:GetAngles()
    self:SetPos(newPos)
    self:SetAngles(newAng)

    -- Now initialize physics
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Wake()
        phys:SetPos(newPos)     -- sync physics object
        phys:SetAngles(newAng)  -- sync physics rotation
    end

    -- Dummy dispenser
    self.dummy = ents.Create("prop_dynamic")
    self.dummy:SetModel("models/Gibs/HGIBS.mdl")
    self.dummy:SetPos(newPos)
    self.dummy:SetAngles(newAng)
    self.dummy:SetParent(self)
    self.dummy:Spawn()

    self:SetDisplay(1)
    self:SetRationAmount(10)
end

function ENT:SetDisplayStatus(iStatus, ply, bError)
    self:SetDisplay(iStatus)
    if bError and IsValid(ply) then
        ply:EmitSound("buttons/combine_button_locked.wav")
    end
end

function ENT:SpawnFunction(ply, tr, ClassName)
    if not tr.Hit then return end

    local spawnPos = tr.HitPos + tr.HitNormal * 10
    local ent = ents.Create(ClassName)
    if not IsValid(ent) then return end

    -- Face the player
    ent:SetAngles(Angle(0, ply:EyeAngles().yaw + 180, 0))

    -- Push forward so the front of the dispenser is out of the wall
    local front = ent:GetForward() * 0.1 -- model front
    ent:SetPos(spawnPos + front * 10) -- adjust distance if needed

    ent:Spawn()
    ent:Activate()

    -- Dummy model
    ent.dummy = ents.Create("prop_dynamic")
    ent.dummy:SetModel("models/props_combine/combine_dispenser.mdl")
    ent.dummy:SetPos(ent:GetPos())
    ent.dummy:SetAngles(ent:GetAngles())
    ent.dummy:SetParent(ent)
    ent.dummy:Spawn()

    return ent
end

end

function ENT:Use(ply)
    if not IsValid(ply) then return end

    local steamID = ply:SteamID()

    -- Prevent spam with cooldown
    if self.LastUseTime[steamID] and CurTime() - self.LastUseTime[steamID] < self.UseCooldown then
        ply:Notify("Please wait before using this dispenser again.", 2)
        return
    end

    -- Mark last use time immediately (even for denials)
    self.LastUseTime[steamID] = CurTime()

    -- Check if player already claimed this dispenser
    if self.ClaimedPlayers[steamID] then
		self:SetDisplayStatus(4, ply, true) -- locked sound
        ply:Notify("You have already received a meal package within the last 6 hours.", 2)
		timer.Simple(1, function()
			if IsValid(self) and IsValid(ply) then
				self:SetDisplayStatus(1, ply, false)
			end
		end)
		
        return
    end

    -- Unauthorized team
    if not allowedTeams[ply:Team()] then
        self:SetDisplayStatus(4, ply, true) -- locked sound
        return
    end
	
	-- Check if player is not from TEAM_CP and has insufficient XP
	if ply:GetXP() < 25 and ply:Team() ~= TEAM_CP and not ply:IsAdmin() then
		self:SetDisplayStatus(4, ply, true) -- locked sound
		ply:Notify("Your current low civil status results in the denial of receiving a meal package.")
		
		timer.Simple(1, function()
			if IsValid(self) and IsValid(ply) then
				self:SetDisplayStatus(1, ply, false)
			end
		end)
		
		return
	end

    -- Inventory full
    if ply.Inventory and not ply.Inventory:FindFirstEmptySlot() then
        self:SetDisplayStatus(4, ply, true) -- locked sound
        ply:Notify("Inventory full.", 2)
        return
    end

    -- Dispenser empty
    if self:GetRationAmount() <= 0 then
        self:SetDisplayStatus(6, ply, false) -- no locked sound
        ply:Notify("This dispenser is empty.", 2)
        self:EmitSound("combine_tech/ration_dispenser/empty_stock.mp3")
        return
    end

    -- Mark claim (prevents multiple claims within 6 hours)
    self.ClaimedPlayers[steamID] = true

    -- Preparing dispenser
    self:SetDisplayStatus(5, ply)
    self:EmitSound("ambient/machines/combine_terminal_idle3.wav")
    ply:ForceSequence("wave")

    timer.Simple(9, function()
        if not IsValid(self) or not IsValid(ply) then return end

        -- Play dispenser animation
        if IsValid(self.dummy) then
            self.dummy:Fire("SetAnimation", "dispense_package", 0)
        end
        ply:ForceSequence("takepackage")

        -- Determine ration type
        local rationType = "ration_a"
        local loyalty = ply:GetRankPoints() or 0

        if ply:Team() == TEAM_CITIZEN then
            if loyalty < 200 then
                rationType = "ration_a"
            elseif loyalty < 400 then
                rationType = "ration_b"
            else
                rationType = "ration_c"
            end
        elseif ply:Team() == TEAM_VORT then
            rationType = "ration_a"
        elseif ply:Team() == TEAM_CP then
            rationType = "ration_a_combine"
        end

        -- Give ration and reduce stock
        if ply.GiveInventoryItem then
            ply:GiveInventoryItem(rationType)
            ply:GiveInventoryItem("ration_coupon_standard")
        end

        local newAmount = self:GetRationAmount() - 1
        self:SetRationAmount(newAmount)

        -- Update display after giving ration
        if newAmount <= 0 then
            self:SetDisplayStatus(6, ply, false)
        else
            self:SetDisplayStatus(1, ply, false)
        end

        ply:Notify("You have received a meal package.")
        self:EmitSound("ambient/machines/combine_terminal_idle4.wav")

        timer.Simple(1, function()
            if IsValid(ply) then
                ply:AnimRestartMainSequence()
            end
        end)
    end)
end

if CLIENT then
    local glowMat = Material("sprites/glow04_noz")

    function ENT:Draw()
        self:DrawModel()

        local displayIndex = self:GetDisplay() or 1
        local text, color, blink = self.Displays[displayIndex][1], self.Displays[displayIndex][2], self.Displays[displayIndex][3]

        local alpha = blink and math.abs(math.cos(RealTime()*2)*255) or 255
        color.a = alpha

        local basePos = self:GetPos() + self:GetUp()*-4 + self:GetForward()*5.5 + self:GetRight()*-1.5
        local ang = self:GetAngles()
        ang:RotateAroundAxis(ang:Right(), -90)
        ang:RotateAroundAxis(ang:Up(), 90)

        cam.Start3D2D(basePos, ang, 0.1)
            draw.SimpleText(text, "DermaLarge", 0, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()

        local spritePos = basePos + self:GetUp() * 23 + self:GetForward()*2.5
        render.SetMaterial(glowMat)
        render.DrawSprite(spritePos, 5, 5, color)
    end
end