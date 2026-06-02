local ITEM = {}

ITEM.UniqueID = "wep_stunstick"
ITEM.Name = "Stun Baton"
ITEM.Desc =  "An electrified baton manufactured by the Combine.            Standard melee weapon for Civil Protection.\nIt can be used to stun disobedient citizens."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_stunbaton.mdl")
ITEM.FOV = 25
ITEM.CamPos = Vector(-10.315186500549, 21.203437805176, 30.315186500549)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_stunstick"

impulse.RegisterItem(ITEM)
