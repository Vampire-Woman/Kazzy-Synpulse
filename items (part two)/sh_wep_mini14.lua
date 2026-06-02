local ITEM = {}

ITEM.UniqueID = "wep_mini14"
ITEM.Name = "Sniper Pulse Rifle"
ITEM.Desc =  "A dark energy-powered sniper rifle manufactured by the Combine.\nIt requires Pulse Mk. II ammunition."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/lrh/w_ospr.mdl")
ITEM.FOV = 11.396848137536
ITEM.CamPos = Vector(-83.722061157227, -125, 100.1461317539215)
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_mini14"

impulse.RegisterItem(ITEM)
