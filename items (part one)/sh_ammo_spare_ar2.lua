local ITEM = {}

ITEM.UniqueID = "ammo_spare_ar2"
ITEM.Name = "Spare AR2 Round"
ITEM.Desc =  "Unfired rounds left over from reloading. Automatically re-loaded."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/combine_helicopter/bomb_debris_1.mdl")
ITEM.FOV = 22.919770773639
ITEM.CamPos = Vector(0.91600000858307, 94.440002441406, -30)

ITEM.Weight = 0.15

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Discard"

ITEM.AmmoType = "AR2"

function ITEM:OnUse(ply)
    local has, amount = ply:HasInventoryItem(self.UniqueID)

    for i=1, amount do
        ply:TakeInventoryItemClass(self.UniqueID)
    end

    return false
end

impulse.RegisterItem(ITEM)