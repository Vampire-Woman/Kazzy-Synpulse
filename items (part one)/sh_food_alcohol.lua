local ITEM = {}

ITEM.UniqueID = "food_alcohol"
ITEM.Name = "Jar of Alcohol"
ITEM.Desc =  "A jar of poisonous alcohol"
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/glassjug01.mdl")
ITEM.FOV = 55
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Drink"
ITEM.UseWorkBarTime = 0.5
ITEM.UseWorkBarName = "Drinking..."
ITEM.UseWorkBarSound = "impulse/drink.wav"

function ITEM:OnUse(ply)
	net.Start("RoleplayAction")

        net.WriteString("say /me drinks jar of alcohol.")

    net.Send(ply)
    ply:Kill()
    ply:Notify("Womp Womp.")
    return true
end

impulse.RegisterItem(ITEM)