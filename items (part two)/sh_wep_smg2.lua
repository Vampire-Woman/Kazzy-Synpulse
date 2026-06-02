local ITEM = {}

ITEM.UniqueID = "wep_smg2"
ITEM.Name = "MP5K Submachine Gun"
ITEM.Desc =  "Slow but accurate. Most effective in close to medium to short range."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_smg2.mdl")
ITEM.FOV = 55
ITEM.CamPos = Vector(-10, 12.836676597595, 9)
ITEM.Weight = 2.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_mp5k"
ITEM.Reward = 20

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)