local ITEM = {}

ITEM.UniqueID = "wep_akm"
ITEM.Name = "AKM Assault Rifle"
ITEM.Desc =  "A cheap yet reliable high powered rifle for medium range combat. Kicks as hard as it hits."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_rif_ak47.mdl")
ITEM.FOV = 48.191977077364
ITEM.CamPos = Vector(-44.928367614746, 17.421203613281, -11.346704483032)
ITEM.NoCenter = true
ITEM.Weight = 3.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_akm"
ITEM.Reward = 30

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)