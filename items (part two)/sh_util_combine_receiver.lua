local ITEM = {}

ITEM.UniqueID = "util_combine_receiver"
ITEM.Name = "Combine Receiver"
ITEM.Desc = "A component which receives Combine radio transmissions."
ITEM.Model = Model("models/gibs/scanner_gib04.mdl")
ITEM.Weight = 1
ITEM.FOV = 52.684813753582
ITEM.CamPos = Vector(-13.753582000732, 8.2521486282349, 3.7822349071503)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "electronics"
ITEM.CraftTime = 5

impulse.RegisterItem(ITEM)