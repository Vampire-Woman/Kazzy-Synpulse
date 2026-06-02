local ITEM = {}

ITEM.UniqueID = "cos_glasses"
ITEM.Name = "Glasses"
ITEM.Desc =  "A basic piece of eyewear."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_lab/box01a.mdl")
ITEM.FOV = 11.126074498567
ITEM.CamPos = Vector(46.762176513672, -27.507164001465, 3.7822349071503)
ITEM.NoCenter = true
ITEM.Weight = 0

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.Illegal = false

ITEM.Droppable = true
ITEM.DropOnDeath = false
ITEM.Illegal = false

ITEM.Equipable = true
ITEM.EquipGroup = "eyes"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	if ply:IsCharacterFemale() then
        ply:SetBodygroup(4,1)
    else
        ply:SetBodygroup(5,1)
    end
end

function ITEM:UnEquip(ply)
	if ply:IsCharacterFemale() then
        ply:SetBodygroup(4,0)
    else
        ply:SetBodygroup(5,0)
    end
end

impulse.RegisterItem(ITEM)