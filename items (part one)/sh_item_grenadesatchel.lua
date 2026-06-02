local ITEM = {}

ITEM.UniqueID = "item_grenadesatchel"
ITEM.Category = "Tools"
ITEM.Name = "Overwatch Grenade Satchel"
ITEM.Desc = "A pouch containing two Combine-modified, MK3A2 grenades. They should pack a punch."
ITEM.Model = Model("models/weapons/w_defuser.mdl")
ITEM.Weight = 2
ITEM.FOV = 11.126074498567
ITEM.CamPos = Vector(46.762176513672, -27.507164001465, 3.7822349071503)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.UseName = "Open"
 
function ITEM:OnUse(ply)
    net.Start("RoleplayAction")
        net.WriteString("say /me unpacks grenades from satchel.")
    net.Send(ply)
    ply:EmitSound("physics/wood/wood_crate_impact_hard1.wav")	
    ply:GiveInventoryItem("wep_grenade", 1 ,false)
    ply:GiveInventoryItem("wep_grenade", 1 ,false)
    return true
end

impulse.RegisterItem(ITEM)