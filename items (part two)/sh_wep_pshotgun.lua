local ITEM = {}

ITEM.UniqueID = "wep_pshotgun"
ITEM.Name = "gun"
ITEM.Desc =  "gun that kills anti-whites"
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/heavyshotgun/w_shotgun_heavy.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(360, 90, 90)
ITEM.Weight = 6
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_pshot"

impulse.RegisterItem(ITEM)
