local ITEM = {}

ITEM.UniqueID = "item_lockshocker"
ITEM.Name = "Lock Shocker"
ITEM.Desc =  "Can be attached to a Combine Lock to short-circuit it."
ITEM.Category = "Tools"
ITEM.Model = Model("models/props_citizen_tech/transponder.mdl")
ITEM.FOV = 51
ITEM.CamPos = Vector(-8.2521486282349, 6.4183382987976, 26.475645065308)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.UseName = "Attach to Combine Lock"

function ITEM:OnUse(ply)
	
	local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 64
		trace.filter = ply
	local tr = util.TraceLine(trace)
	local door = tr.Entity

	if IsValid(door) and door:IsDoor() then
		if IsValid(door) and door:IsDoor() then
			local rareChance = math.random(1, 100) <= 10
			local soundToPlay
			if rareChance then
				soundToPlay = "vo/eli_lab/al_sweet.wav"
			else
				soundToPlay = "npc/roller/mine/rmine_shockvehicle"..math.random(1,2)..".wav"
			end
			
			door:EmitSound(soundToPlay, 80, math.random(95,105), 1)
			
			timer.Create(door:EntIndex().."ShockLockUnlock", 0.5, 1, function()
				door:DoorUnlock()
				door:EmitSound("buttons/combine_button1.wav", 80, 100, 1)
				if door:GetClass() == "prop_door_rotating" then
					local target = ents.Create("info_target")
					target:SetName(tostring(target))
				   	target:SetPos(ply:GetPos())
				   	target:Spawn()

					door:Fire("openawayfrom", tostring(target), 0)
				elseif door:GetClass() == "func_door_rotating" then
					door:Fire("open", "")
					door:Fire("setanimation", "open")
				end
			end)
			return true
		else
			ply:Notify("Can only be used on doors that have a Combine Lock")
			return
		end
	else
		ply:Notify("No door in range to attach to.")
	end
end

impulse.RegisterItem(ITEM)