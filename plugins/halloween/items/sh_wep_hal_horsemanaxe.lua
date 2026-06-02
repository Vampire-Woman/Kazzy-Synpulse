local ITEM = {}

ITEM.UniqueID = "wep_hal_horsemanaxe"
ITEM.Name = "Horseless Headless Horsemann's Headtaker"
ITEM.Desc =  "You wield the power of the Horsemann!"
ITEM.Category = "Weapons"
ITEM.Model = Model("models/raidhwn/weapon_headtaker.mdl")
ITEM.FOV = 15.338108882521
ITEM.CamPos = Vector(-23.839542388916, -19.255014419556, -336.61889648438)
ITEM.Weight = 8
ITEM.Colour = Color(147,112,219)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_horsemanaxe"

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)