local ITEM = {}

ITEM.UniqueID = "cos_paddedpants"
ITEM.Name = "Padded Trousers"
ITEM.Desc =  "A pair of trousers."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.Weight = 0
ITEM.FOV = 11.126074498567
ITEM.CamPos = Vector(46.762176513672, -27.507164001465, 3.7822349071503)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "legs"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply.HasArmoredPants = true
	ply:SetBodygroup(2, 3)
end

function ITEM:UnEquip(ply)
	ply.HasArmoredPants = false
	ply:SetBodygroup(2, 0)
end

impulse.RegisterItem(ITEM)