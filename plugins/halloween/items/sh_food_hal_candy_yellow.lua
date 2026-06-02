local ITEM = {}

ITEM.UniqueID = "food_hal_candy_yellow"
ITEM.Name = "Yellow Halloween Candy"
ITEM.Desc =  "Trick or treat!"
ITEM.Category = "Food"
ITEM.Model = Model("models/bag/bag.mdl")
ITEM.Colour = Color(255,255,0)

ITEM.FOV = 8.3180515759312
ITEM.CamPos = Vector(126.53295135498, -160, -18.91117477417)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 5

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)