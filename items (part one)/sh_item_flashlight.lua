local ITEM = {}

ITEM.UniqueID = "item_flashlight"
ITEM.Name = "Pocket Flashlight"
ITEM.Desc =  "A portable hand-held electric lamp with a 35 degree multi-poseable head. It requires a 9-volt battery to operate."
ITEM.Category = "Tools"
ITEM.Model = Model("models/props/de_nuke/IndustrialLight01.mdl")
ITEM.FOV = 3
ITEM.CamPos = Vector(-15.587392807007, 90.590257644653, -700.5644698143005)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "light"
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
	ply:AllowFlashlight(true)
	ply:Flashlight(true)
end
function ITEM:UnEquip(ply)
	ply:Flashlight(false)
	ply:AllowFlashlight(false)
end

impulse.RegisterItem(ITEM)