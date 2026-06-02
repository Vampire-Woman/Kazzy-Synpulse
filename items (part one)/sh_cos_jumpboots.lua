local Model = Model
local Vector = Vector
local impulse = impulse

local ITEM = {}


ITEM.UniqueID = "cos_jumpboots"
ITEM.Name = "J.M.P Boots"
ITEM.Desc =  "A pair of Jump Mobility Power Boots that enables increased jump height."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_junk/Shoe001a.mdl")
ITEM.FOV = 12.213467048711
ITEM.CamPos = Vector(46.418338775635, 20.630373001099, 32.091690063477)
ITEM.NoCenter = true
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "feet"
ITEM.CanStack = false

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetJumpPower(320)
	ply.JMPBoots = true
end

function ITEM:UnEquip(ply)
	ply:SetJumpPower(160)
	ply.JMPBoots = false
end

impulse.RegisterItem(ITEM)
