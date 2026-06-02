local ITEM = {}

ITEM.UniqueID = "wep_id"
ITEM.Name = "Identification Card"
ITEM.Desc = "A metallic card issued and manufactured by the Combine.\nIt contains the full name and identification code of the subject.  The writing is very small, you need to hold it up close to read."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/props_combine/combinebutton.mdl")
ITEM.FOV = 0.5
ITEM.CamPos = Vector(-1000, -2200, -200)
ITEM.Weight = 0

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.UseName = "Apply"

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = false
ITEM.Equipable = false
ITEM.CanStack = false

function ITEM:OnUse(ply)
    ply:ConCommand("say /me would show their identification")
    local steamid64 = ply:SteamID64()
    local lastfive = string.sub(tostring(steamid64), -5)

    timer.Simple(2, function()
        ply:ConCommand("say /it The card would read: '" .. ply:Nick() .. " — " .. lastfive .. "' ")
    end)
end

impulse.RegisterItem(ITEM)
