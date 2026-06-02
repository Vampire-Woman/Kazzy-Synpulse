local ITEM = {}

ITEM.UniqueID = "wep_ordgun"
ITEM.Name = "Pulse Rifle Mk. I"
ITEM.Desc =  "An older variant, dark energy-powered assault rifle manufactured by the Combine.\nIt requires Pulse Mk. I ammunition."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/ocipr/w_ocipr.mdl")
ITEM.FOV = 2
ITEM.CamPos = Vector(-900.045845031738, -900.191976547241, 300.4383955001831)
ITEM.CamAng = Vector(97.573, 256.530, 0.000)
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

ITEM.WeaponClass = "ls_ordgun"

impulse.RegisterItem(ITEM)
