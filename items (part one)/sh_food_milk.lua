local ITEM = {}

ITEM.UniqueID = "food_milk"
ITEM.Name = "Carton of Milk"
ITEM.Desc =  "A paper carton of creamy milk. It has a slightly sour taste."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_milkcarton002a.mdl")
ITEM.FOV = 55
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 0.5
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.Food = 6
ITEM.Level = 3

function ITEM:OnUse(ply)
	impulse.PlayGesture(ply, "g_fist_r")
    SpawnJunk(self, ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)