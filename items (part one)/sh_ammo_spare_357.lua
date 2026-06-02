local ITEM = {}

ITEM.UniqueID = "ammo_spare_357"
ITEM.Name = "Spare .357 Round"
ITEM.Desc =  "Unfired rounds left over from reloading. Automatically re-loaded."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/weapons/shell.mdl")
ITEM.Weight = 0.4
ITEM.FOV = 3.8252148997135
ITEM.CamPos = Vector(-26.590257644653, -47.679084777832, 34.040115356445)
ITEM.NoCenter = true

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Discard"

ITEM.AmmoType = "357"

function ITEM:OnUse(ply)
    local has, amount = ply:HasInventoryItem(self.UniqueID)

    for i=1, amount do
        ply:TakeInventoryItemClass(self.UniqueID)
    end

    return false
end

impulse.RegisterItem(ITEM)