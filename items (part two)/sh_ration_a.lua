local ITEM = {}

ITEM.UniqueID = "ration_a"
ITEM.Category = "Rations"
ITEM.Name = "Meal Package"
ITEM.Desc = "A vacuum-sealed package manufactured by the Combine containing processed consumable goods.\nIt must be broken down for the contents within to be accessed."
ITEM.Model = Model("models/hls/alyxports/ration_package.mdl")
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
    ply:GiveInventoryItem("food_rationbar")
    ply:GiveInventoryItem("food_rationbox")
	ply:EmitSound("physics/cardboard/cardboard_box_break3.wav")
    return true
end

impulse.RegisterItem(ITEM)