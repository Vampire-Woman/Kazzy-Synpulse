local ITEM = {}

ITEM.UniqueID = "food_friedrice"
ITEM.Name = "Fried Rice"
ITEM.Desc =  "Oil-fried brown rice mixed with cooked vegetables and small chunks of meat."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_takeoutcarton001a.mdl")
ITEM.FOV = 28.255014326648
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Eat"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Eating..."
ITEM.UseWorkBarSound = "impulse/eat.wav"

ITEM.Food = 60
ITEM.Level = 3

function ITEM:OnUse(ply)
    ply:AddVitality(self.Level, self.Food)
    net.Start("RoleplayAction")

        net.WriteString("say /me eats some fried rice.")

    net.Send(ply)
    ply:FeedHunger(self.Food)
    return true
end

impulse.RegisterItem(ITEM)
