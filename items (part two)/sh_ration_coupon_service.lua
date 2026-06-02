local ITEM = {}

ITEM.UniqueID = "ration_coupon_service"
ITEM.Category = "Rations"
ITEM.Name = "Metropolice Ration Coupon"
ITEM.Desc =  "Redeem this at an ATM for a reward."
ITEM.Model = Model("models/bioshockinfinite/hext_coin.mdl")
ITEM.Weight = 0.1
ITEM.FOV = 10.845272206304
ITEM.CamPos = Vector(-10, 25, 9)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

function ITEM:OnUse(ply)
    ply:GiveBankMoney(25)
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "impulse_atm"
end

impulse.RegisterItem(ITEM)