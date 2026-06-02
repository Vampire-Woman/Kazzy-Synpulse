local ITEM = {}

ITEM.UniqueID = "food_rationbox"
ITEM.Name = "Gelatinated Calorie Paste"
ITEM.Desc =  "A box of revolting tasting paste manufactured by the Combine.\nThe packaging reads: 'Egg flavor. Once seal is broken, consume within 9000 days'."
ITEM.Category = "Food"
ITEM.Model = Model("models/hls/alyxports/ration_box.mdl")
ITEM.FOV = 22
ITEM.Weight = 1
ITEM.CamPos = Vector(-11, 25, 20)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 18

function ITEM:OnUse(ply)
	ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
