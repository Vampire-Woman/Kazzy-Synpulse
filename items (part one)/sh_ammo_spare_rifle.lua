local ITEM = {}

ITEM.UniqueID = "ammo_spare_rifle"
ITEM.Name = "Spare 7.62 Round"
ITEM.Desc =  "Unfired rounds left over from reloading. Automatically re-loaded."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/weapons/rifleshell.mdl")
ITEM.Weight = 0.13
ITEM.FOV = 7.1948424068768
ITEM.CamPos = Vector(-22.922636032104, -42.17765045166, 22.693408966064)
ITEM.NoCenter = true

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Discard"

ITEM.AmmoType = "Rifle"

function ITEM:OnUse(ply)
    local has, amount = ply:HasInventoryItem(self.UniqueID)

    for i=1, amount do
        ply:TakeInventoryItemClass(self.UniqueID)
    end

    return false
end

impulse.RegisterItem(ITEM)