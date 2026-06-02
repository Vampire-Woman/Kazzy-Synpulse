local ITEM = {}

ITEM.UniqueID = "util_circuitboard"
ITEM.Name = "Circuit Board"
ITEM.Desc = "A relic of Human technology. This one has stood the test of time."
ITEM.Model = Model("models/props/cs_office/computer_caseb_p3a.mdl")
ITEM.Weight = 1
ITEM.FOV = 29.378223495702
ITEM.CamPos = Vector(0, 0, -26.475645065308)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "electronics"
ITEM.CraftTime = 5

impulse.RegisterItem(ITEM)