local ITEM = {}

ITEM.UniqueID = "cos_armoredpants"
ITEM.Name = "Padded Blue Jeans"
ITEM.Desc =  "A blue pair of pants, reinforced with ballistic padding. It provides decent protection."
ITEM.Category = "Armor"
ITEM.Model = Model("models/weapons/w_defuser.mdl")
ITEM.Weight = 3
ITEM.FOV = 11.126074498567
ITEM.CamPos = Vector(46.762176513672, -27.507164001465, 3.7822349071503)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "legs"
ITEM.CanStack = false

function ITEM:OnEquip(ply)
	ply.HasArmoredPants = true
	ply:SetBodygroup(2, 3)
end

function ITEM:UnEquip(ply)
	ply.HasArmoredPants = false
	ply:SetBodygroup(2, 0)
end

impulse.RegisterItem(ITEM)