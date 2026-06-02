local ITEM = {}

ITEM.UniqueID = "item_canopener"
ITEM.Name = "Can Opener"
ITEM.Desc =  "Needed to cut open the lid of a tin can."
ITEM.Model = Model("models/props_c17/tools_pliers01a.mdl")
ITEM.Weight = 1
ITEM.FOV = 20.67335243553
ITEM.CamPos = Vector(-22.005731582642, -22.005731582642, -41.604583740234)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

impulse.RegisterItem(ITEM)