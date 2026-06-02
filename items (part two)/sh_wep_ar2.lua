local ITEM = {}

ITEM.UniqueID = "wep_ar2"
ITEM.Name = "Pulse Rifle Mk. II"
ITEM.Desc =  "A newer variant, dark energy-powered assault rifle manufactured by the Combine.\nIt requires Pulse Mk. II ammunition."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_irifle.mdl")
ITEM.FOV = 30.836676217765
ITEM.CamPos = Vector(45.257879257202, -31.174785614014, 10)
ITEM.NoCenter = true
ITEM.Weight = 8

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_ar2"

impulse.RegisterItem(ITEM)
