local ITEM = {}

ITEM.UniqueID = "util_computerhardware"
ITEM.Name = "Computer Hardware"
ITEM.Desc = "1.7 Ghz CPU, 2x256 MB of RAM, 6.5 GB HDD, DX 8.1 compatible GPU, and Windows XP"
ITEM.Model = Model("models/props/cs_office/computer_caseb_p7a.mdl")
ITEM.Weight = 2
ITEM.FOV = 52.684813753582
ITEM.CamPos = Vector(-31.174785614014, 4.584527015686, 11.346704483032)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "electronics"
ITEM.CraftTime = 5

impulse.RegisterItem(ITEM)