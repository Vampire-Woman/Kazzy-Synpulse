local ITEM = {}

ITEM.UniqueID = "wep_shotgun"
ITEM.Name = "Franchi SPAS-12"
ITEM.Desc =  "A 12-gauge pump-action shotgun that fires buckshot in a cone-shaped pattern and packs a punch.\nIt requires buckshot ammunition."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_shotgun.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(360, 90, 90)
ITEM.Weight = 6
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_spas12"

impulse.RegisterItem(ITEM)
