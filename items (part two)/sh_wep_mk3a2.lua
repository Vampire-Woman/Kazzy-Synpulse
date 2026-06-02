local ITEM = {}

ITEM.UniqueID = "wep_grenade"
ITEM.Name = "Overwatch MK3A2 Grenade"
ITEM.Desc =  "Cylindrical concussion grenade designed to produce casualties during close combat while minimizing danger to friendly personnel exposed in the open owing to minimal fragmentation."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_grenade.mdl")
ITEM.FOV = 4.6676217765043
ITEM.CamPos = Vector(128.36676025391, -38.510028839111, 128.59599304199)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true


ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_grenade"
ITEM.WeaponOverrideClip = 1

function ITEM:CanEquip(ply)
	if ply:IsTeamVort() then
		return false
	else
		return true
	end
end

impulse.RegisterItem(ITEM)