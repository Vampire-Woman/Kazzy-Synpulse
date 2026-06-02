local doorHealth = {
	[0] = 50,
	[1] = 30,
	[2] = 50,
	[3] = 30,
	[4] = 70,
	[5] = 70,
	[6] = 70,
	[7] = 60,
	[8] = 70,
	[9] = 60,
	[10] = 30,
	[11] = 50,
	[12] = 70,
	[13] = 30
}

local kickDoorCommand = {
	description = "Kicks down the door the player is looking at.",
	onRun = function(ply)
		if ply.kickDoorCooldown and ply.kickDoorCooldown > CurTime() then return end
		ply.kickDoorCooldown = CurTime() + 2


		if ply:Team() != TEAM_CP then
			return ply:Notify("You must be a Metropolice officer to use this command.")
		end

		if ply:GetVelocity():Length() != 0 then
			return ply:Notify("You must stand still to kick down a door.")
		end

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

		local tr = util.TraceLine(trace)
		local door = tr.Entity

		if door:IsPropDoor() and not door:IsDoor() then
			ply:Freeze(true)
			ply:ForceSequence("adoorkick", function()
				if IsValid(ply) then
					ply:Freeze(false)
				end
			end, 1.2)

			timer.Simple(1, function()
				if not IsValid(door) or not IsValid(ply) then return end

				door:Fire("open", "", .6)
    			door:Fire("setanimation", "open", .6)
				door:EmitSound("physics/wood/wood_crate_break3.wav")
			end)

			return
		end
		
		-- This prevents from non-buyable doors to be kicked down if they are not an apartment.
		if not door:GetSyncVar(SYNC_DOOR_BUYABLE, true) then
			-- SHOULD fix the dummy property system breaking the door system
			if not door.IsABlastableDoor then
				return
			end
		end

		local doorOwners = door:GetSyncVar(SYNC_DOOR_OWNERS, nil)
		local doorGroup =  door:GetSyncVar(SYNC_DOOR_GROUP, nil)

		if doorGroup and (doorGroup == 1 or doorGroup == 2) then
			return
		end

		if IsValid(door) and door:IsDoor() and not ply:CanLockUnlockDoor(doorOwners, doorGroup) then
			door.doorHP = door.doorHP or doorHealth[door:GetSkin()] or 70
			ply:Freeze(true)
			ply:ForceSequence("adoorkick", function()
				if IsValid(ply) then
					ply:Freeze(false)
				end
			end, 1.2)

			timer.Simple(1, function()
				if not IsValid(door) or not IsValid(ply) then return end

				door.doorHP = door.doorHP or doorHealth[door:GetSkin()] or 70
				door.doorHP = door.doorHP - (35)

				if door.doorHP <= 0 then
					door:DoorUnlock()
					door:SetKeyValue("Speed", "500")

					if door:GetClass() == "prop_door_rotating" then
						local target = ents.Create("info_target")
						target:SetName(tostring(target))
				   		target:SetPos(ply:GetPos())
				   		target:Spawn()

						door:Fire("openawayfrom", tostring(target), 0)
					elseif door:GetClass() == "func_door_rotating" then
						door:Fire("open", "", .6)
						door:Fire("setanimation", "open", .6)
					end
					//door:Fire("setspeed", "500")
					//door:Fire("setanimation", "open", 0)

					door:DoorUnlock()

					door:EmitSound("physics/wood/wood_crate_break3.wav")
					door.doorHP = doorHealth[door:GetSkin()]

					timer.Simple(1, function()
						if IsValid(target) then
							target:Remove()
						end

						if IsValid(door) then
							door:SetKeyValue("Speed", 100)
						end
					end)
				else
					door:EmitSound("physics/wood/wood_plank_break1.wav")
				end
			end)
		end
	end
}

impulse.RegisterChatCommand("/kickdoor", kickDoorCommand)

local doorHealth = {
	[0] = 50,
	[1] = 30,
	[2] = 50,
	[3] = 30,
	[4] = 70,
	[5] = 70,
	[6] = 70,
	[7] = 60,
	[8] = 70,
	[9] = 60,
	[10] = 30,
	[11] = 50,
	[12] = 70,
	[13] = 30
}

local openDoorCommand = {
	description = "Open down the door the player is looking at.",
	adminOnly = true,
	onRun = function(ply)
		if ply.openDoorCooldown and ply.openDoorCooldown > CurTime() then return end
		ply.openDoorCooldown = CurTime() + 2


		if ply:Team() != TEAM_CP and ply:Team() != TEAM_OTA then
			return ply:Notify("You must be a Combine to use this command.")
		end

		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

		local tr = util.TraceLine(trace)
		local door = tr.Entity

		if door:IsPropDoor() and not door:IsDoor() then
			ply:ForceSequence("harassfront2", function()
				if IsValid(ply) then
					ply:Freeze(false)
				end
			end, 1.2)

			timer.Simple(0.2, function()
				if not IsValid(door) or not IsValid(ply) then return end

				door:Fire("open", "", .6)
    			door:Fire("setanimation", "open", .6)
				door:EmitSound("physics/wood/wood_crate_break3.wav")
			end)

			return
		end

		local doorOwners = door:GetSyncVar(SYNC_DOOR_OWNERS, nil)
		local doorGroup =  door:GetSyncVar(SYNC_DOOR_GROUP, nil)

		if doorGroup and (doorGroup == 1 or doorGroup == 2) then
			return
		end

		if IsValid(door) and door:IsDoor() and not ply:CanLockUnlockDoor(doorOwners, doorGroup) then
			door.doorHP = door.doorHP or doorHealth[door:GetSkin()] or 70
			ply:Freeze(false)
			ply:ForceSequence("harassfront2", function()
				if IsValid(ply) then
					ply:Freeze(false)
				end
			end, 1.2)

			timer.Simple(0.2, function()
				if not IsValid(door) or not IsValid(ply) then return end

				door.doorHP = door.doorHP or doorHealth[door:GetSkin()] or 70
				door.doorHP = door.doorHP - (70)

				if door.doorHP <= 0 then
					door:DoorUnlock()
					door:SetKeyValue("Speed", "100")

					if door:GetClass() == "prop_door_rotating" then
						local target = ents.Create("info_target")
						target:SetName(tostring(target))
				   		target:SetPos(ply:GetPos())
				   		target:Spawn()

						door:Fire("openawayfrom", tostring(target), 0)
					elseif door:GetClass() == "func_door_rotating" then
						door:Fire("open", "", .6)
						door:Fire("setanimation", "open", .6)
					end
					--door:Fire("setspeed", "500")
					--door:Fire("setanimation", "open", 0)

					door:DoorUnlock()

					--door:EmitSound("physics/wood/wood_crate_break3.wav")
					door.doorHP = doorHealth[door:GetSkin()]

					timer.Simple(1, function()
						if IsValid(target) then
							target:Remove()
						end

						if IsValid(door) then
							door:SetKeyValue("Speed", 100)
						end
					end)
				else
					--door:EmitSound("physics/wood/wood_plank_break1.wav")
				end
			end)
		end
	end
}

impulse.RegisterChatCommand("/opendoor", openDoorCommand)
impulse.RegisterChatCommand("/od", openDoorCommand)