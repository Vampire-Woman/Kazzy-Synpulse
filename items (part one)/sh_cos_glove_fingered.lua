local ITEM = {}

ITEM.UniqueID = "cos_glove_fingered"
ITEM.Name = "Gloves"
ITEM.Desc =  "A pair of leather gloves."
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
ITEM.EquipGroup = "hands"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	end
	if ply:IsCP() then
		return false
	end

	return true
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(3, 2)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(3, 0)
end

impulse.RegisterItem(ITEM)