local ITEM = {}

ITEM.UniqueID = "wep_medkit"
ITEM.Name = "Welding Gun"
ITEM.Desc = "A combine tool for welding."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_combine/combine_emitter01.mdl")
ITEM.FOV = 22
ITEM.CamPos = Vector(-50, 50, 100)
ITEM.Weight = 5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "medical"
ITEM.CanStack = false

ITEM.WeaponClass = "weapon_cmb_welding_gun"

impulse.RegisterItem(ITEM)
