local ITEM = {}

ITEM.UniqueID = "wep_cleaver"
ITEM.Name = "Cleaver"
ITEM.Desc =  "Can be used to cut up all sorts of meat..."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/hitman6/cleaver.mdl")
ITEM.FOV = 3.8252148997135
ITEM.CamPos = Vector(-160, 135.7020111084, 26.475645065308)
ITEM.NoCenter = true
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_cleaver"

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)