local ITEM = {}

ITEM.UniqueID = "util_combine_interface_module"
ITEM.Name = "Combine Interface Module"
ITEM.Desc = "A device installed in Combine technology that interacts with connected systems."
ITEM.Model = Model("models/gibs/scanner_gib04.mdl")
ITEM.Weight = 2
ITEM.FOV = 52.684813753582
ITEM.CamPos = Vector(-13.753582000732, 8.2521486282349, 3.7822349071503)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "gunmetal"
ITEM.CraftTime = 5

impulse.RegisterItem(ITEM)