local ITEM = {}

ITEM.UniqueID = "ration_coupon_standard"
ITEM.Category = "Rations"
ITEM.Name = "Ration Coupon"
ITEM.Desc =  "A sleek, transparent Combine-issued ration coupon, strictly single-use at an ATM.\nIt appears to bear security markings and a QR code."
ITEM.Model = Model("models/synapse/props/ration_coupon.mdl")
ITEM.Weight = 0.1
ITEM.FOV = 15
ITEM.CamPos = Vector(-10, 25, 23)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

function ITEM:OnUse(ply)
    ply:Notify("You redeem this coupon.")
    ply:GiveBankMoney(5)
	ply:EmitSound("physics/plastic/plastic_box_break2.wav")
    return true
end

function ITEM:ShouldTraceUse(ply, ent)
	return ent:GetClass() == "impulse_atm"
end

impulse.RegisterItem(ITEM)