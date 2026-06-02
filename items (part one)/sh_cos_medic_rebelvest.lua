local ITEM = {}

ITEM.UniqueID = "cos_medic_rebelvest"
ITEM.Name = "Armored Medic Jacket"
ITEM.Desc =  "A white denim jacket with a medical armband, fortified by salvaged Combine ballistic armor. It provides great protection."
ITEM.Category = "Armor"
ITEM.Model = Model("models/weapons/w_defuser.mdl")
ITEM.Weight = 5
ITEM.FOV = 11.126074498567
ITEM.CamPos = Vector(46.762176513672, -27.507164001465, 3.7822349071503)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "chest"
ITEM.CanStack = false

function ITEM:OnEquip(ply)
	ply.HasRebelKevlarVest = true
	ply:SetBodygroup(1, 7)
end

function ITEM:UnEquip(ply)
	ply.HasRebelKevlarVest = false
	ply:SetBodygroup(1, 0)
end

impulse.RegisterItem(ITEM)