local ITEM = {}

ITEM.UniqueID = "item_citizenradio"
ITEM.Category = "Tools"
ITEM.Name = "Handcrafted Radio"
ITEM.Desc = "A basic radio crafted from scavenged parts. Has a small selection of songs."
ITEM.Model = Model("models/props_lab/citizenradio.mdl")
ITEM.Weight = 10
ITEM.FOV = 95

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.UseName = "Place"
ITEM.UseWorkBarTime = 3
ITEM.UseWorkBarName = "Placing Radio..."
ITEM.UseWorkBarFreeze = true

function ITEM:OnUse(ply)
	net.Start("RoleplayAction")
        net.WriteString("say /me places down radio.")
    net.Send(ply)
	local radio = ents.Create("impulse_hl2rp_citizenradio")
		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 32
		trace.filter = ply
		local tr = util.TraceLine(trace)

		radio:SetPos(tr.HitPos)
	radio:Spawn()
	return true
end

impulse.RegisterItem(ITEM)