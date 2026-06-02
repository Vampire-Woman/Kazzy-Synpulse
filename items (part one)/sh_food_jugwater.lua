local ITEM = {}

ITEM.UniqueID = "food_jugwater"
ITEM.Name = "Jug of Clean Water"
ITEM.Desc =  "A jug containing clean water purified with burning the bacteria with a synapse kettle. It appears to be safe to drink."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_milkcarton001a.mdl")
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

ITEM.Food = 5
ITEM.Level = 2

function ITEM:OnUse(ply)
	impulse.PlayGesture(ply, "g_fist_r")
    SpawnJunk(self, ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)