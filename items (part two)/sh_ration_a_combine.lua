local ITEM = {}

ITEM.UniqueID = "ration_a_combine"
ITEM.Category = "Rations"
ITEM.Name = "Meal Package (GR-AF)"
ITEM.Desc = "A vacuum-sealed package manufactured by the Combine containing processed consumable goods.\nIt must be broken down for the contents within to be accessed."
ITEM.Model = Model("models/hls/alyxports/ration_package.mdl")
ITEM.Skin = 4
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

local CombineRationFoods = {
    {
        "food_combinerationbox"
    },
    {
        "food_combinerationbar"
    }
}
    
function ITEM:OnUse(ply)
    ply:GiveInventoryItem(CombineRationFoods[1][math.random(1,#CombineRationFoods[1])],1,false)
    ply:GiveInventoryItem(CombineRationFoods[2][math.random(1,#CombineRationFoods[2])],1,false)
	ply:EmitSound("physics/cardboard/cardboard_box_break3.wav")
    return true
end

impulse.RegisterItem(ITEM)
