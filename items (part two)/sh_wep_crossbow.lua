local ITEM = {}

ITEM.UniqueID = "wep_crossbow"
ITEM.Name = "Crossbow"
ITEM.Desc = "A heavy, powerful crossbow, used by the Resistance to hunt Overwatch Soldiers."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_crossbow.mdl")
ITEM.FOV = 61.389684813754
ITEM.CamPos = Vector(-20.171918869019, 37.593124389648, 22.693408966064)
ITEM.Weight = 7

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "sniper"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_crossbow"
ITEM.Reward = 100

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)