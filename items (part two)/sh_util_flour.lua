local ITEM = {}

ITEM.UniqueID = "util_flour"
ITEM.Name = "Bag of Flour"
ITEM.Desc = "A bag containing flour."
ITEM.Model = Model("models/props_junk/garbage_bag001a.mdl")
ITEM.FOV = 33.17335243553
ITEM.CamPos = Vector(-1.1461317539215, 2.292263507843, 33.237823486328)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

impulse.RegisterItem(ITEM)