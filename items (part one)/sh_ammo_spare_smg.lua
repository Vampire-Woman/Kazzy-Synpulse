local ITEM = {}

ITEM.UniqueID = "ammo_spare_smg"
ITEM.Name = "Spare SMG Round"
ITEM.Desc =  "Unfired rounds left over from reloading. Automatically re-loaded."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/shells/shell_57.mdl")
ITEM.Weight = 0.1
ITEM.FOV = 2.9828080229226
ITEM.CamPos = Vector(-22.922636032104, -41.260746002197, 15.128939628601)

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Discard"


ITEM.AmmoType = "smg1"

function ITEM:OnUse(ply)
    local has, amount = ply:HasInventoryItem(self.UniqueID)

    for i=1, amount do
        ply:TakeInventoryItemClass(self.UniqueID)
    end

    return false
end

impulse.RegisterItem(ITEM)