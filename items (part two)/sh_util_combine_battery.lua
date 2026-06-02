local ITEM = {}

ITEM.UniqueID = "util_combine_battery"
ITEM.Name = "Combine Battery"
ITEM.Desc = "An advanced power source based on Combine technology."
ITEM.Model = Model("models/items/battery.mdl")
ITEM.Weight = 2
ITEM.FOV = 23.481375358166
ITEM.CamPos = Vector(25.67335319519, -13.753582000732, 22.693408966064)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "electronics"
ITEM.CraftTime = 5

impulse.RegisterItem(ITEM)