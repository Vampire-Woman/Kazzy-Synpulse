local ITEM = {}

ITEM.UniqueID = "ammo_spare_buckshot"
ITEM.Name = "Spare Shotgun Shell"
ITEM.Desc =  "Unfired shell from an opened ammo box. Automatically re-loaded."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/weapons/shotgun_shell.mdl")
ITEM.Weight = 0.8
ITEM.FOV = 7.756446991404
ITEM.CamPos = Vector(-24.756446838379, -41.260746002197, 30.257879257202)
ITEM.NoCenter = true

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Discard"


ITEM.AmmoType = "buckshot"

function ITEM:OnUse(ply)
    local has, amount = ply:HasInventoryItem(self.UniqueID)

    for i=1, amount do
        ply:TakeInventoryItemClass(self.UniqueID)
    end

    return false
end

impulse.RegisterItem(ITEM)