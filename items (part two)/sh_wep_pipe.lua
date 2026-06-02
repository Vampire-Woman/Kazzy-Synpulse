local ITEM = {}

ITEM.UniqueID = "wep_pipe"
ITEM.Name = "Pipe"
ITEM.Desc =  "A weapon that can cause blunt trauma upon hitting a target."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_canal/mattpipe.mdl")
ITEM.FOV = 40.610315186246
ITEM.CamPos = Vector(34.842407226563, 42.17765045166, 11.346704483032)
ITEM.NoCenter = true
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

ITEM.WeaponClass = "ls_pipe"

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)