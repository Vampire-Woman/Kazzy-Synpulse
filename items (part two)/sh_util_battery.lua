local ITEM = {}

ITEM.UniqueID = "util_battery"
ITEM.Name = "Battery"
ITEM.Desc = "A functional, rechargeable battery."
ITEM.Model = Model("models/props_citizen_tech/transponder.mdl")
ITEM.Weight = 0.5
ITEM.FOV = 51
ITEM.CamPos = Vector(-8.2521486282349, 6.4183382987976, 26.475645065308)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "electronics"
ITEM.CraftTime = 5

impulse.RegisterItem(ITEM)