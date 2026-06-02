local ITEM = {}

ITEM.UniqueID = "cos_tan_shirt"
ITEM.Name = "Tan Shirt"
ITEM.Desc =  "A Tan shirt made out of a denim."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 11.126074498567
ITEM.CamPos = Vector(46.762176513672, -27.507164001465, 3.7822349071503)
ITEM.NoCenter = true
ITEM.Weight = 0

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.Illegal = false

ITEM.Equipable = true
ITEM.EquipGroup = "shirt"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(1,3)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(1, 0)
end

impulse.RegisterItem(ITEM)