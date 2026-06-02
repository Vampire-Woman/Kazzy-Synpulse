local ITEM = {}

ITEM.UniqueID = "ration_c_combine"
ITEM.Category = "Rations"
ITEM.Name = "Ration Unit MP-RP-800"
ITEM.Desc = "Contains some decent food. For Metropolice only."
ITEM.Model = Model("models/weapons/w_packatm.mdl")
ITEM.Weight = 2.5
ITEM.FOV = 15.899713467049
ITEM.CamPos = Vector(-46.762176513672, -33.9255027771, 45.386817932129)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.UseName = "Open"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Opening Ration..."

local CombineRationFoods = {
    {
        "food_friedrice",
        "food_bread",
        "food_noodles",
        "food_cabbage",
    },
    {
        "food_water",
        "food_breenwater",
        "food_jugwater",
    }
}
    
function ITEM:OnUse(ply)
    net.Start("RoleplayAction")
        net.WriteString("say /me opens a Metropolice Ration.")
    net.Send(ply)
    ply:GiveInventoryItem(CombineRationFoods[1][math.random(1,#CombineRationFoods[1])],1,false)
    ply:GiveInventoryItem(CombineRationFoods[2][math.random(1,#CombineRationFoods[2])],1,false)
    return true
end

impulse.RegisterItem(ITEM)
