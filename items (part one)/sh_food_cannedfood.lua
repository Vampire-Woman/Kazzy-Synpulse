local ITEM = {}

ITEM.UniqueID = "food_canned_food"
ITEM.Name = "Canned Food"
ITEM.Desc =  "A can of perfectly preserved food."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_metalcan002a.mdl")
ITEM.Weight = 1.5
ITEM.FOV = 16.180515759312
ITEM.CamPos = Vector(-18.338108062744, 24.756446838379, 0)
ITEM.NoCenter = true

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Open Can"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Trying to open can..."
ITEM.UseWorkBarSound = "ambient/misc/creak5.wav"

ITEM.Food = 30
ITEM.Level = 3

function ITEM:OnUse(ply)
    if ply:HasInventoryItem("item_canopener") then
        ply:FeedHunger(self.Food)
        return true
    else
		ply:TakeDamage( 2 )
		ply:ViewPunch( Angle( 3, 0, 2 ) )
        ply:Notify("You cut yourself because you don't have a Can Opener.")
		ply:EmitSound("ambient/machines/slicer3.wav")
    end
end

impulse.RegisterItem(ITEM)
