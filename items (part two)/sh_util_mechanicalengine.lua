local ITEM = {}

ITEM.UniqueID = "item_mechanicalengine"
ITEM.Name = "Mechanical Engine"
ITEM.Desc = "A heavy, powerful machine."
ITEM.Model = Model("models/gibs/airboat_broken_engine.mdl")
ITEM.Weight = 10
ITEM.FOV = 53.246418338109
ITEM.CamPos = Vector(-26.590257644653, -15.587392807007, 34.040115356445)

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Activate"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Pulling crank..."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply, ent)
	ply:EmitSound("ambient/machines/sputter1.wav")
	ply:Notify("Nothing happens.")
end

impulse.RegisterItem(ITEM)