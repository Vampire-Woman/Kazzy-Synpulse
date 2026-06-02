local ITEM = {}

ITEM.UniqueID = "wep_pulsesmg"
ITEM.Name = "Overwatch Standard Issue Pulse Sub-Machinegun"
ITEM.Desc =  "A dark energy-powered submachine gun manufactured by the Combine.\nIt requires Pulse Mk. I ammunition."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/psmg/w_psmg.mdl")
ITEM.FOV = 1.3
ITEM.CamPos = Vector(825.227661, 500.733673, 900)
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

ITEM.WeaponClass = "ls_pulsesmg"

impulse.RegisterItem(ITEM)
