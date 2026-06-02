local ITEM = {}

ITEM.UniqueID = "util_reclaimedmetalplate"
ITEM.Name = "Reclaimed Metal"
ITEM.Desc = "A misshapen bar of metal."
ITEM.Model = Model("models/gibs/metal_gib2.mdl")
ITEM.Weight = 1.6
ITEM.FOV = 7.1948424068768
ITEM.CamPos = Vector(66.017189025879, -64.183380126953, 83.209167480469)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 3

impulse.RegisterItem(ITEM)