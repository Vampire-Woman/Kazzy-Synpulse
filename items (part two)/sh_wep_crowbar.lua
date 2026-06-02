local ITEM = {}

ITEM.UniqueID = "wep_crowbar"
ITEM.Name = "Crowbar"
ITEM.Desc =  "A steel bar for prying and wacking."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_crowbar.mdl")
ITEM.FOV = 17.58452722063
ITEM.CamPos = Vector(-37.593124389648, 38.510028839111, 56.73352432251)
ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_crowbar"

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)