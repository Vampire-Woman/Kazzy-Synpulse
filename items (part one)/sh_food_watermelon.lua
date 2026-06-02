local ITEM = {}

ITEM.UniqueID = "food_watermelon"
ITEM.Name = "Watermelon"
ITEM.Desc =  "A not-so freshly grown watermelon."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/watermelon01.mdl")
ITEM.FOV = 55
ITEM.Weight = 4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 100
ITEM.Level = 5

function ITEM:OnUse(ply)
    ply:AddVitality(self.Level, self.Food)
    net.Start("RoleplayAction")

        net.WriteString("say /me eats watermelon.")

    net.Send(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
