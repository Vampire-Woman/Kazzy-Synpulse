local ITEM = {}

ITEM.UniqueID = "ration_a_supplementary"
ITEM.Category = "Rations"
ITEM.Name = "Supplementary Ration"
ITEM.Desc =  "Contains some chocolate and snack foods."
ITEM.Model = Model("models/weapons/w_packati.mdl")
ITEM.Weight = 2.5
ITEM.FOV = 15.899713467049
ITEM.CamPos = Vector(-46.762176513672, -33.9255027771, 45.386817932129)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = false

ITEM.UseName = "Open"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Opening Ration..."
 
function ITEM:OnUse(ply)
    net.Start("RoleplayAction")
        net.WriteString("say /me opens a supplementary ration.")
    net.Send(ply)
    ply:GiveInventoryItem("food_chocolate")
    ply:GiveInventoryItem("food_bagofchips")
    ply:GiveInventoryItem("food_pizza")
    return true
end

impulse.RegisterItem(ITEM)