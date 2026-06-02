impulse.RegisterChatCommand("/addxp", {
    description = "Adds xp to the specified player.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, text)
        local target = impulse.FindPlayer(arg[1])
        local amount = arg[2]

        if not ( amount or tonumber(amount) ) then
            return
        end

        if ( target and IsValid(target) ) then
            target:AddXP(amount)
        else
            return ply:Notify("Could not find player: "..tostring(arg[1]))
        end
    end
})

--impulse.RegisterChatCommand("/toggleraise", {
--    description = "Raise or lower your weapon with a command.",
--    onRun = function(ply)
--        ply:ToggleWeaponRaised()
--    end
--})

local setNameCommand = {
	description = "Forcefully changes a player's name. Does not save to database.",
	requiresArg = true,
    adminOnly = true,
	onRun = function(ply, arg, rawText)
        local target = arg[1]
        local newName = string.sub(rawText, (string.len(target) + 2))
		newName = string.Trim(newName)
        local targ = impulse.FindPlayer(target)
        
        if not ply:IsSuperAdmin() then
            return ply:Notify("You do not have permission to use this command.")
        end

        if not targ and not IsValid(targ) then
            ply:Notify("Could not find player: "..tostring(target))
        end

        if targ and IsValid(targ) then
            ply:Notify("You have changed "..targ:Name().."'s name to "..newName..".")
            targ:SetRPName(newName)
        end
    end
}

impulse.RegisterChatCommand("/setname", setNameCommand)

impulse.RegisterChatCommand("/fixlegs", {
    description = "Fixes the legs of the player specified.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local target = impulse.FindPlayer(name)

        if target and not IsValid(target) then
            return ply:Notify("Could not find player: "..tostring(name))
        end

        if not target:HasBrokenLegs(true) then
            ply:Notify("This player's legs are not broken.")
        end

        if target and target:HasBrokenLegs(true) then
            target:FixLegs()

            if ( target == ply ) then
                for k, v in pairs(player.GetAll()) do
                    if not ( v:IsLeadAdmin() ) then
                        continue
                    end
                end
            end
        end
    end
})

impulse.RegisterChatCommand("/addmoney", {
    description = "Add money to the specified player.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local targ = player.GetBySteamID(arg[1])
        local money = arg[2]

        if not ( money or tonumber(money) ) then
            ply:Notify("Invalid Value!")
            return
        end

        if not ( targ or IsValid(targ) ) then
            ply:Notify("Could not find player: "..tostring(arg[1]).." (needs SteamID value)")
        end
    
        if ( targ and IsValid(targ) ) then
            targ:GiveMoney(money)
            ply:Notify("You have given "..targ:SteamName().."  "..money.." Tokens.")
            if ( target == ply ) then
                for k, v in pairs(player.GetAll()) do
                    if not ( v:IsLeadAdmin() ) then
                        continue
                    end

                    v:AddChatText(Color(241, 111, 3), "[ops] Moderator "..ply:SteamName().." has given "..targ:SteamName().." "..money.." Tokens.")
                end
            end
        end
    end
})

impulse.RegisterChatCommand("/addhunger", {
    description = "Adds hunger of the player specified.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local hunger = arg[2]
        local target = impulse.FindPlayer(name)

        if ( target and not IsValid(target) ) then
            return ply:Notify("Could not find player: "..tostring(name))
        end

        if ( target ) then
            target:FeedHunger(arg[2])
            ply:Notify(target:Name().."'s hunger has been set to "..hunger..".")

            if ( target == ply ) then
                for k, v in pairs(player.GetAll()) do
                    if not ( v:IsLeadAdmin() ) then
                        continue
                    end
                end
            end
        end
    end
})

local setModelCommand = {
    description = "Sets the model of the player specified. Does not save to database.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)

        local name = arg[1]
        local model = arg[2]
        local plyTarget = impulse.FindPlayer(name)

        if not ply:IsAdmin() then
            return ply:Notify("You do not have permission to use this command.")
        end

        if plyTarget and not IsValid(plyTarget) then
            ply:Notify("Could not find player: "..tostring(name))
        end

        if plyTarget and IsValid(plyTarget) then
            plyTarget:SetModel(model)
        end
    end
}

impulse.RegisterChatCommand("/setmodel", setModelCommand)

local unfreezeCommand = {
    description = "Unfreeze the player specified.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local plyTarget = impulse.FindPlayer(name)

        if plyTarget then
            plyTarget:Freeze(false)
			plyTarget:SetMoveType(MOVETYPE_WALK)
            ply:Notify(plyTarget:Name().." has been unfrozen.")
        else
            return ply:Notify("Could not find player: "..tostring(name))
        end
    end
}

impulse.RegisterChatCommand("/unfreeze", unfreezeCommand)

local freezeCommand = {
    description = "Freezes the player specified.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local plyTarget = impulse.FindPlayer(name)

        if plyTarget == ply then
            return ply:Notify("Why would you want to freeze yourself??? Dumb faggot.")
        end

        if plyTarget then
            plyTarget:Freeze(true)
			plyTarget:SetMoveType(MOVETYPE_NONE)
		end
	end
}
impulse.RegisterChatCommand("/freeze", freezeCommand)

local itemsremoveCommand = {
    description = "Removes all dropped items on the map.",
    requiresArg = no,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
       	for _, v in pairs(ents.FindByClass("impulse_item")) do
            if ( IsValid(v) ) then
                SafeRemoveEntity(v)
            end
        end
        ply:Notify("All items have been removed.")
	end
}
impulse.RegisterChatCommand("/cleanupitems", itemsremoveCommand)

impulse.RegisterChatCommand("/setclass", {
    description = "Sets the class of the player specified. Classes are refrenced with their team ID number.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local classID = arg[2]
        local plyTarget = impulse.FindPlayer(name)

        if not tonumber(classID) then
            return ply:Notify("Class ID should be a number.")
        end

        classID = tonumber(classID)

        if ( plyTarget ) then
            local classData = impulse.Teams.Data[plyTarget:Team()].classes
            if ( classID and classData[classID] ) then
                local className = classData[classID].name
                plyTarget:SetTeamClass(classID)
                ply:Notify(plyTarget:Name().." has been set to "..className..".")
                
                hook.Run("PlayerChangeClass", plyTarget, plyTarget:GetTeamClass(), plyTarget:GetTeamClassName())
            else
                ply:Notify("Invalid class ID.")
            end
        else
            return ply:Notify("Could not find player: "..tostring(name))
        end
    end
})

local meleeBashCommand = {
    description = "Bash with your weapon.",
    requiresArg = false,
    requiresAlive = true,
    onRun = function(ply, arg, rawText)
        local damage = 100

        if ply:Team() ~= TEAM_OTA then
            ply:Notify("You must be a Soldier to use this command.")
            return
        end

        local weapon = ply:GetActiveWeapon()
        if not IsValid(weapon) or not weapon:IsWeapon() then
            ply:Notify("You must have a weapon equipped to bash.")
            return
        end

        impulse.PlayGesture(ply, "gunbash_2")
        ply:EmitSound("npc/combine_soldier/gear1.wav")

        local trace = util.TraceHull({
            start = ply:GetShootPos(),
            endpos = ply:GetShootPos() + ply:GetAimVector() * 75,
            filter = ply,
            mins = Vector(-6, -6, -6),
            maxs = Vector(6, 6, 6),
            mask = MASK_SHOT_HULL
        })

        local target = trace.Entity

        if IsValid(target) then
            if target:GetClass() == "prop_door_rotating" or target:GetClass() == "func_door_rotating" then
                target:EmitSound("physics/wood/wood_crate_break3.wav")
                target:Fire("unlock")
                target:SetKeyValue("Speed", "500")

                if target:GetClass() == "prop_door_rotating" then
                    local tempTarget = ents.Create("info_target")
                    tempTarget:SetPos(ply:GetPos())
                    tempTarget:SetName(tostring(tempTarget))
                    tempTarget:Spawn()

                    target:Fire("openawayfrom", tostring(tempTarget), 0)

                    timer.Simple(1, function()
                        if IsValid(tempTarget) then
                            tempTarget:Remove()
                        end

                        if IsValid(target) then
                            target:SetKeyValue("Speed", "100")
                        end
                    end)
                elseif target:GetClass() == "func_door_rotating" then
                    target:Fire("open", "", 0.6)
                    target:Fire("setanimation", "open", 0.6)

                    timer.Simple(1, function()
                        if IsValid(target) then
                            target:SetKeyValue("Speed", "100")
                        end
                    end)
                end
            else
                if target:IsPlayer() and target:Team() ~= TEAM_OTA then
                    target:TakeDamage(damage, ply, weapon)
                    target:EmitSound("physics/body/body_medium_impact_hard6.wav")
                elseif not target:IsPlayer() then
                    target:TakeDamage(damage, ply, weapon)
                    target:EmitSound("physics/body/body_medium_impact_hard6.wav")
                end
            end
        end
    end
}

impulse.RegisterChatCommand("/bash", meleeBashCommand)

impulse.RegisterChatCommand("/cc", {
    description = "Changes the citycode.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        ply:ConCommand("stopsound")  -- Stop any sound playing

        local code = arg[1]  -- Get the city code argument

        -- Check if the city code exists
        if not impulse.ci.socioStatus.list[code] then
            ply:Notify("Invalid city code.")
            return
        end

        local codeData = impulse.ci.socioStatus.list[code]

        -- 🔥 EVENT TRIGGERS: Trigger appropriate event based on city code
        if code == "cu" then
            net.Start("impulseHL2RPCivilUnrestStart")
            net.Broadcast()
        end

        if code == "cc" then
            net.Start("impulseHL2RPCivilStart")
            net.Broadcast()
        end

        if code == "jw" then
            net.Start("impulseHL2RPJWStart")
            net.Broadcast()
        end

        -- 🔵 Apply city code properly
        impulse.Dispatch.SetCityCode(ply, code)
        impulse.Dispatch.SetupCityCode(code)

        ply:Notify("Changed city code to: " .. codeData.name)

        -- 🔵 Send messages only to Combine players
        local message

        if code == "cc" then
            message = "Sociostabilization restored. All units return to code 12."
        elseif code == "cu" then
            message = "Social fracture in progress. Respond."
        elseif code == "jw" then
            message = "Protection Team, lock down your location. Sacrifice Code One."
        else
            message = "Unknown city code has started"
        end

        for _, k in pairs(player.GetAll()) do
            if k:IsCombine() then
                -- Send dynamic message based on city code to Combine players
                k:SendChatClassMessage(14, message, k)

                -- Emit only the appropriate sound for the specific city code
                if soundPath ~= "" then
                    --k:EmitSound(soundPath)  -- Play the specific sound for this city code
                end
            end
        end

        -- 🔵 Notify CP + OTA about the code change
        local rf = RecipientFilter()
        rf:AddRecipientsByTeam(TEAM_CP)
        rf:AddRecipientsByTeam(TEAM_OTA)

        net.Start("impulseHL2RPCityCodeChange")
        net.WriteString(code)
        net.Send(rf)

        hook.Run("OnCityCodeChanged", ply, codeData.name)
    end
})

local unshacklecmd = {
    description = "Unshackle yourself with a command.",
    requiresArg = false,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local target = impulse.FindPlayer(arg[1])
        
        if (target:IsPlayer() and target:Team() == TEAM_VORT and target:GetModel() == "models/vortigaunt_slave.mdl") then
            target:SetTeamClass(1)
            target:Notify("You have been freed.")
            ply:Notify("Shackles removed.")
        end
    end
}
impulse.RegisterChatCommand("/unshackle", unshacklecmd)

local grenadecommand = {
    description = "Throw a grenade.",
    requiresArg = false,
    requiresAlive = true,
    onRun = function(ply)
        if ply:Team() ~= TEAM_OTA then 
            ply:Notify("You must be a Soldier to use this command.")
            return
        end

        if not ply.NextGrenadeTimer then 
            ply.NextGrenadeTimer = 0 
        end

        if CurTime() > ply.NextGrenadeTimer then
            local ent = ents.Create("suppressed_osgrenade")
            ent:SetPos(ply:EyePos() + (ply:GetAimVector() * 22) + (ply:GetRight() * 1))
            ent:Spawn()

            -- Set the owner of the grenade
            ent:SetOwner(ply)

            -- Apply force to throw the grenade
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceCenter(ply:GetAimVector() * 800)
            end

            -- Play grenade throw animation and sound
            impulse.PlayGesture(ply, "grenthrow")
            --ply:EmitSound("npc/combine_soldier/vo/displace.wav")

            -- Set cooldown for throwing another grenade
            ply.NextGrenadeTimer = CurTime() + 2
        else
            ply:Notify("You must wait " .. tostring(math.ceil(ply.NextGrenadeTimer - CurTime())) .. " seconds before throwing another grenade.")
        end
    end
}
impulse.RegisterChatCommand("/grenade", grenadecommand)

local giveRankPoints = {
    description = "Reward a unit with 5 Rank Points.",
	adminOnly = true,
    requiresArg = true,
    onRun = function(ply, arg, rawText, target)
        local target = impulse.FindPlayer(arg[1])

        if (ply:Team() == TEAM_CP or ply:IsAdmin()) and (ply:GetTeamClass() == CLASS_DISPATCH or ply:IsAdmin()) then
            if target:IsPlayer() and (target:Team() == TEAM_CP or target:Team() == TEAM_OTA) then
                local currentRankPoints = target:GetRankPoints()
                if currentRankPoints < 100 then
                    target:Promote(5)
                    timer.Simple(1, function()
                        local newRankPoints = target:GetRankPoints()
                        --ply:Notify("This unit now has " .. newRankPoints .. " Rank Points.")
                    end)
                else
                    ply:Notify("This unit already has 100 Rank Points.")
                end
            end
        end
    end
}
impulse.RegisterChatCommand("/promote", giveRankPoints)

local takeRankPoints = {
    description = "Deduct 5 Rank Point from a unit.",
	adminOnly = true,
    requiresArg = true,
    onRun = function(ply, arg, rawText, target)
        local target = impulse.FindPlayer(arg[1])

        if (ply:Team() == TEAM_CP or ply:IsAdmin()) and (ply:GetTeamClass() == CLASS_DISPATCH or ply:IsAdmin()) then
            if target:IsPlayer() and (target:Team() == TEAM_CP or target:Team() == TEAM_OTA) then
                local currentRankPoints = target:GetRankPoints()
                if currentRankPoints > 0 then
                    target:Demote(5)
                    timer.Simple(1, function()
                        local newRankPoints = target:GetRankPoints()
                        --ply:Notify("This unit now has " .. newRankPoints .. " Rank Points remaining.")
                    end)
                else
                    ply:Notify("This unit does not have enough points to be deducted.")
                end
            end
        end
    end
}
impulse.RegisterChatCommand("/demote", takeRankPoints)

local defunctCommand = {
    description = "Mark a unit for deservicement. (Must be a STEAMID or look at the player if no argument is given)",
	adminOnly = true,
    requiresArg = false,
    onRun = function(ply, arg, rawText, target)
        local target

        if #arg == 0 then
            local trace = ply:GetEyeTrace()
            if trace.Hit and IsValid(trace.Entity) and trace.Entity:IsPlayer() then
                target = trace.Entity
            else
                ply:Notify("You must look at a player or provide a STEAMID.")
                return
            end
        else
            target = impulse.FindPlayer(arg[1])
        end

        if (ply:Team() == TEAM_CP or ply:IsAdmin()) and (ply:GetTeamClass() == CLASS_DISPATCH or ply:IsAdmin()) then
            if target:IsPlayer() and (target:Team() == TEAM_CP or target:Team() == TEAM_OTA) then
                if not target:IsDispatchDefunct() then
                    local recipFilter = RecipientFilter()

                    for _, k in pairs(player.GetAll()) do
                        if k:Team() == TEAM_CP or k:Team() == TEAM_OTA then
                            recipFilter:AddPlayer(k)
                        end
                    end

                    target:AddDispatchDefunct()
                    target:Notify("You have been marked for deservicement by OVERWATCH do not resist.")

                    net.Start("impulseHL2RPDefunct")
                    net.WriteUInt(target:EntIndex(), 8)
                    net.Send(recipFilter)
                else
                    ply:Notify("This unit is already marked defunct.")
                end
            else
                ply:Notify("Target is not a valid unit.")
            end
        else
            ply:Notify("You must be a rank leader to use this command.")
        end
    end
}
impulse.RegisterChatCommand("/deservice", defunctCommand)

local manhackCommand = {
    description = "Deploy a manhack.",
    requiresArg = false,
    adminOnly = false,
    onRun = function(ply, arg, rawText)
        -- Check team restriction
        if ply:Team() ~= TEAM_CP then
            return ply:Notify("Only CP officers can deploy a manhack!")
        end

        -- Bodygroup check: allow deploy only if at least one bodygroup is non-zero
        local canDeploy = false
        for _, bg in ipairs(ply:GetBodyGroups()) do
            if ply:GetBodygroup(bg.id) ~= 0 then
                canDeploy = true
                break
            end
        end

        if not canDeploy then
            return ply:Notify("You have no manhack.")
        end

        -- Freeze player during animation
        ply:Freeze(true)
        ply:ForceSequence("deploy")

        -- Reset all bodygroups to 0
        for _, bg in ipairs(ply:GetBodyGroups()) do
            ply:SetBodygroup(bg.id, 0)
        end

        -- Spawn the manhack after a short delay
        timer.Simple(1.5, function()
            if not IsValid(ply) then return end

            local manhack = ents.Create("npc_manhack")
            if IsValid(manhack) then
                local spawnPos = ply:GetPos() + ply:GetForward() * 50 + Vector(0,0,10)
                manhack:SetPos(spawnPos)
                manhack:SetAngles(ply:GetAngles())
                manhack:Spawn()
                manhack:Activate()
                manhack:SetOwner(ply)
            end

            ply:Freeze(false)
            ply:Notify("Your manhack has been deployed!")
        end)
    end
}

impulse.RegisterChatCommand("/mh", manhackCommand)