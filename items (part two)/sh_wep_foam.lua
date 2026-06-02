local ITEM = {}

ITEM.UniqueID = "wep_foam"
ITEM.Name = "Foam Applicator"
ITEM.Desc = "A combine tool for foaming."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/hls/alyxports/w_applicator.mdl")
ITEM.FOV = 16
ITEM.CamPos = Vector(50, 0, 0)
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

ITEM.WeaponClass = "weapon_cmb_hazmattool"

impulse.RegisterItem(ITEM)
