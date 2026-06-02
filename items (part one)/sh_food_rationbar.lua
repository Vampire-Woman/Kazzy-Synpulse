local ITEM = {}

ITEM.UniqueID = "food_rationbar"
ITEM.Name = "Desiccated Sustenance Bar"
ITEM.Desc =  "A bland tasting hydration bar manufactured by the Combine.\nThe packaging reads: 'Water flavor. Once seal is broken, consume within 9000 days'."
ITEM.Category = "Food"
ITEM.Model = Model("models/hls/alyxports/ration_bar.mdl")
ITEM.FOV = 22
ITEM.Weight = 0.5
ITEM.NoCenter = true
ITEM.CamPos = Vector(-10, 25, 23)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 6
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

ITEM.Food = 14

function ITEM:OnUse(ply)
    ply:FeedHunger(self.Food)
	ply:EmitSound("npc/barnacle/barnacle_gulp" .. math.random(1,2) .. ".wav")
    return true
end

impulse.RegisterItem(ITEM)
