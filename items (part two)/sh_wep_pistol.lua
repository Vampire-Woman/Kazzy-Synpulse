local ITEM = {}

ITEM.UniqueID = "wep_pistol"
ITEM.Name = "USP Match Pistol"
ITEM.Desc =  "A semi-automatic 9mm handgun.\nThe standard sidearm for Civil Protection.\nIt requires handgun ammunition."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_pistol.mdl")
ITEM.FOV = 26.008595988539
ITEM.CamPos = Vector(14.67048740387, -21.08882522583, 7.5644698143005)
ITEM.Weight = 1.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_usp"

impulse.RegisterItem(ITEM)
