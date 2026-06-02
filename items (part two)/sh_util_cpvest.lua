local ITEM = {}

ITEM.UniqueID = "util_cpvest"
ITEM.Name = "Salvaged Metro Cop Vest"
ITEM.Desc =  "A bullet-resistant vest utilized by metro cops."
ITEM.Model = Model("models/weapons/w_defuser.mdl")
ITEM.FOV = 11.126074498567
ITEM.CamPos = Vector(46.762176513672, -27.507164001465, 3.7822349071503)
ITEM.NoCenter = true
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "fabric"
ITEM.CraftTime = 2

impulse.RegisterItem(ITEM)