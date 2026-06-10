AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Combine Package"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = true

-- Setup networked variables
function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "RationAmount")
end

-- Initialize entity
function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_junk/cardboard_box001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() end

        self:SetHealth(75)
        self:SetRationAmount(5)

        self.HeldBy = nil
        self.iDeleteTime = CurTime() + 1200
    end
end

-- Player interaction
function ENT:Use(activator)
    if not SERVER or not IsValid(activator) or not activator:IsPlayer() then return end

    if self.HeldBy == activator then
        activator:DropObject()
        self.HeldBy = nil
    else
        activator:PickupObject(self)
        self.HeldBy = activator
    end
end

-- Reward the player holding this entity
function ENT:RewardPlayers(bonus)
    if not IsValid(self.HeldBy) or not self.HeldBy:IsPlayer() then return end
	
	local amountXP = 1
	local ChanceForPoints = math.random(1, 3)
	if ChanceForPoints == 1 then
		self.HeldBy:AddXP(amountXP)
		self.HeldBy:Notify("An additional bonus of " .. amountXP .. " civic point(s) was added to your accreditation.")
	end

    local amount = 1
    if self.HeldBy.GiveMoney then
        self.HeldBy:GiveMoney(amount)
    end
    self.HeldBy:Notify("You received " .. amount .. " credit(s) for your involvement in the delivery of a Combine package.")
end

-- Helper function to restock entities
local function RestockEntity(eEntity, eTarget, stockAmount, sound)
    local iCurrentStock = eTarget:GetStockCount()
    local iMaxStock = eTarget:GetMaxStock()

    if iCurrentStock < iMaxStock then
        local newStock = math.min(iCurrentStock + stockAmount, iMaxStock)
        eTarget:SetStockCount(newStock)
        eTarget:EmitSound(sound, 60)
        eEntity:RewardPlayers()
        SafeRemoveEntity(eEntity)
    end
end

-- Allowed entity interactions
local tAllowedEntities = {
    ["ent_fabricator"] = {
        StartTouch = function(eEntity, eTarget)
            eTarget:EmitSound("combine_tech/upgrade_station/combine_3d_printer_resin_tray_retract_01.wav", 65, math.random(95, 105))
            eEntity:RewardPlayers()
            SafeRemoveEntity(eEntity)
        end
    },

    ["ent_cmb_vendingmachine"] = {
        StartTouch = function(eEntity, eTarget)
            for i = 1, 4 do
                if eTarget:GetStock(i) == 0 then
                    eTarget:SetStock(i, 10)
                    eTarget:EmitSound("ambient/materials/bump1.wav")
                    eEntity:RewardPlayers()
                    SafeRemoveEntity(eEntity)
                    break
                end
            end
        end
    },

    ["ent_cmb_permitstore"] = {
        StartTouch = function(eEntity, eTarget)
            local restored = 0
            local stockToRestore = 29
            for _, tData in ipairs(eTarget.StoreStock) do
                if tData.amount == 0 then
                    tData.amount = 1
                    restored = restored + 1
                end
                if restored >= stockToRestore then break end
            end
            if restored > 0 then
                eTarget:EmitSound("ambient/machines/combine_terminal_idle1.wav")
                eEntity:RewardPlayers()
                SafeRemoveEntity(eEntity)
            end
        end
    },

    ["impulse_rationdispenser"] = {
        StartTouch = function(eEntity, eTarget)
            eTarget:EmitSound("ambient/machines/combine_terminal_idle4.wav")
            eTarget.dummy:Fire("SetAnimation", "dispense_package", 0)
            eEntity:RewardPlayers(true)
            SafeRemoveEntity(eEntity)
        end
    },

    ["ent_cmb_refill"] = {
        StartTouch = function(eEntity, eTarget)
            if Monolith.Budget.GetResin() >= Monolith.Budget.MaxResin then return end
            eTarget:EmitSound("combine_tech/upgrade_station/combine_3d_printer_resin_tray_retract_01.wav", 65, math.random(95, 105))
            Monolith.Budget.Add(10)
            eEntity:RewardPlayers()
            SafeRemoveEntity(eEntity)
        end
    },

    -- Refill entities using DRY approach
    ["ent_med_refill"]     = { StartTouch = function(eEntity, eTarget) RestockEntity(eEntity, eTarget, 5, "foley/containers/wood_cabinet_close.mp3") end },
    ["ent_pill_refill"]    = { StartTouch = function(eEntity, eTarget) RestockEntity(eEntity, eTarget, 5, "foley/containers/wood_cabinet_close.mp3") end },
    ["ent_weld_refill"]    = { StartTouch = function(eEntity, eTarget) RestockEntity(eEntity, eTarget, 5, "doors/door_metal_thin_close2.wav") end },
    ["ent_bodybag_refill"] = { StartTouch = function(eEntity, eTarget) RestockEntity(eEntity, eTarget, 5, "foley/containers/hazmatcrate_close.mp3") end },
}

-- Called when touching another entity
function ENT:StartTouch(eEntity)
    if not SERVER then return end
    local tEntity = tAllowedEntities[eEntity:GetClass()]
    if not tEntity then return end

    timer.Simple(0, function()
        if not IsValid(eEntity) or not IsValid(self) then return end
        tEntity.StartTouch(self, eEntity)
    end)
end

-- Damage handling
function ENT:OnTakeDamage(dmg)
    if SERVER then
        self:SetHealth(self:Health() - dmg:GetDamage())
        if self:Health() <= 0 then
            self:EmitSound("physics/cardboard/cardboard_box_break1.wav", 70)
            SafeRemoveEntity(self)
        end
    end
end

-- Think loop
function ENT:Think()
    if not SERVER then return end

    if self.HeldBy and not IsValid(self.HeldBy) then
        self.HeldBy = nil
    end

    if self.iDeleteTime <= CurTime() then
        SafeRemoveEntity(self)
        return
    end

    self:NextThink(CurTime() + 1)
    return true
end

-- Draw entity
function ENT:Draw()
    self:DrawModel()
end