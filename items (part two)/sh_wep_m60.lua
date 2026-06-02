local ITEM = {}

ITEM.UniqueID = "wep_m60"
ITEM.Name = "Heavy Machine Gun"
ITEM.Desc =  "A dark energy-powered minigun manufactured by the Combine.\nIt requires Pulse Mk. I ammunition."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/suppressor/w_suppressor.mdl")
ITEM.Mass = 1
ITEM.FOV = 12.75787965616
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Weight = 30

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "primary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_m60"

impulse.RegisterItem(ITEM)
