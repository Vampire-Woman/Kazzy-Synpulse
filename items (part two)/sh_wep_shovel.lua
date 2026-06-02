local ITEM = {}

ITEM.UniqueID = "wep_shovel"
ITEM.Name = "Garden Shovel"
ITEM.Desc =  "An old garden shovel for digging holes and moving soil."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_junk/shovel01a.mdl")
ITEM.Weight = 3
ITEM.FOV = 54.931232091691
ITEM.CamPos = Vector(-52.263610839844, 50.429798126221, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_shovel"

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)