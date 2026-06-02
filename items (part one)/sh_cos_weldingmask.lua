local ITEM = {}

ITEM.UniqueID = "cos_weldingmask"
ITEM.Name = "Welding Mask"
ITEM.Desc =  "A metal mask used by welders.\nIt hides your face from being seen.\n(Gain 100 sneak points while this item is active)"
ITEM.Category = "Armor"
ITEM.Model = Model("models/props_silo/welding_helmet.mdl")
ITEM.FOV = 0.8
ITEM.CamPos = Vector(900.590257644653, -256, 1000.5644698143005)
ITEM.NoCenter = true
ITEM.NoCenter = true
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = Model("models/props_silo/welding_helmet.mdl"),
	pos = Vector(1.2, -1, 0),
	ang = Angle(90, 180, 270),
	scale = 1.1,
	femalePos = Vector(2.75, -1.1, 0),
	femaleScale = 1
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[1] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_FACE, 1, true)
	ply.HasWelding = true
	ply.HasFaceCover = true
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_FACE, nil, true)
	ply.HasWelding = false
	ply.HasFaceCover = false
end

impulse.RegisterItem(ITEM)