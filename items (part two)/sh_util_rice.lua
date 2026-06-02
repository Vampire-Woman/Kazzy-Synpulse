local ITEM = {}

ITEM.UniqueID = "util_rice"
ITEM.Name = "Bag of Rice"
ITEM.Desc = "A bag containing rice."
ITEM.Model = Model("models/props_junk/garbage_bag001a.mdl")
ITEM.FOV = 33.17335243553
ITEM.CamPos = Vector(-1.1461317539215, 2.292263507843, 33.237823486328)
ITEM.NoCenter = true
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

impulse.RegisterItem(ITEM)