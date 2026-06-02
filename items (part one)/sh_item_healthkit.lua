local ITEM = {}

ITEM.UniqueID = "item_healthkit"
ITEM.Name = "Health Kit"
ITEM.Desc =  ""
ITEM.Category = "Medical"
ITEM.Model = Model("models/items/healthkit.mdl")
ITEM.FOV = 8
ITEM.CamPos = Vector(100, -100, 75)
ITEM.NoCenter = true
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Use"
ITEM.UseWorkBarTime = 8
ITEM.UseWorkBarName = "Healing..."
ITEM.UseWorkBarFreeze = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false


function ITEM:OnUse(ply, target)
	ply:SetHealth(100)
	ply:FixLegs()
	ply:Notify("You applied a healing substance to your body.")
	ply:EmitSound( "items/smallmedkit1.wav")
end

function ITEM:OnInspect(ply, target)
	ply:Notify("A medical kit manufactured by the Combine infused with a healing substance. Insert into an exposed area for a near instant boost to health.")
end

function ITEM:CanUse( ply )
	return ply:Health() < ply:GetMaxHealth() ( "You are too healthy for this item to be utilized." )
end

impulse.RegisterItem(ITEM)
