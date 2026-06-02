local ITEM = {}

ITEM.UniqueID = "ammo_spare_pistol"
ITEM.Name = "Spare 9mm Round"
ITEM.Desc =  "Unfired rounds left over from reloading. Automatically re-loaded."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/shells/shell_9mm.mdl")
ITEM.Weight = 0.12
ITEM.FOV = 2
ITEM.CamPos = Vector(-27.507164001465, -54.09741973877, 34.040115356445)

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Discard"


ITEM.AmmoType = "pistol"

function ITEM:OnUse(ply)
    local has, amount = ply:HasInventoryItem(self.UniqueID)

    for i=1, amount do
        ply:TakeInventoryItemClass(self.UniqueID)
    end

    return false
end

impulse.RegisterItem(ITEM)