local ITEM = {}

ITEM.UniqueID = "food_combinerationbar"
ITEM.Name = "Synthesized Anti-Fatigue Bar"
ITEM.Desc =  "A heavily infused hydration bar manufactured by the Combine.\nThe packaging reads: 'Vanilla flavor. Once seal is broken, consume within 9000 days'."
ITEM.Category = "Food"
ITEM.Model = Model("models/hls/alyxports/ration_bar.mdl")
ITEM.FOV = 22
ITEM.Skin = 4
ITEM.Weight = 0.5
ITEM.NoCenter = true
ITEM.CamPos = Vector(-10, 25, 23)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 5
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.Food = 30

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
	ply:EmitSound("npc/barnacle/barnacle_gulp" .. math.random(1,2) .. ".wav")
    return true
end

impulse.RegisterItem(ITEM)
