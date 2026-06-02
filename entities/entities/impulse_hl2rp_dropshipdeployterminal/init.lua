AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_interface003.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local physObj = self:GetPhysicsObject()
    if IsValid(physObj) then
        physObj:EnableMotion(false)
        physObj:Wake()
    end

    -- Initialize the queue if it doesn't exist
    if not impulse.dp.queue then
        impulse.dp.queue = {}
    end
    if not impulse.dp.queue.plaza then
        impulse.dp.queue.plaza = {}
    end
end

function ENT:Use(ply)
    if ply:Team() == TEAM_OTA then
        ply:EmitSound("buttons/combine_button1.wav", 100, math.random(95, 100), 0.33)

        if table.HasValue(impulse.dp.queue.plaza, ply) then
            -- Player is in the queue, remove them
            self:LeaveQueue(ply)
        else
            -- Player is not in the queue, add them
            self:JoinQueue(ply)
        end
    end
end

function ENT:JoinQueue(ply)
    if not table.HasValue(impulse.dp.queue.plaza, ply) then
        table.insert(impulse.dp.queue.plaza, ply)
        ply:Notify("You have joined the queue.")

        net.Start("UpdatePlazaWait")
            net.WriteTable(impulse.dp.queue.plaza)
        net.Broadcast()

        self:StartDeploymentTimer()
    else
        ply:Notify("You are already in the queue.")
    end
end

function ENT:LeaveQueue(ply)
    for k, v in ipairs(impulse.dp.queue.plaza) do
        if v == ply then
            table.remove(impulse.dp.queue.plaza, k)
            ply:Notify("You have left the queue.")

            net.Start("UpdatePlazaWait")
                net.WriteTable(impulse.dp.queue.plaza)
            net.Broadcast()
            return
        end
    end
    ply:Notify("You are not in the queue.")
end

function ENT:StartDeploymentTimer()
    if not impulse.dp.deployTimer then
        impulse.dp.deployTimer = true
        timer.Simple(20, function()
            if #impulse.dp.queue.plaza > 0 then
                -- Notify players 10 seconds before deployment
                for _, player in ipairs(impulse.dp.queue.plaza) do
                    if IsValid(player) then
                        player:Notify("Deployment in 10 seconds!")
                    end
                end

                timer.Simple(10, function()
                    impulse.dp.DeployAtPlaza(impulse.dp.queue.plaza)
                end)

                timer.Simple(10, function()
                    impulse.dp.deployTimer = nil
                end)
            else
                impulse.dp.deployTimer = nil
            end
        end)
    end
end

function impulse.dp.DeployAtPlaza(queue)
    -- Check if the queue is valid and not empty
    if #queue == 0 then
        return
    end

    local dropship = ents.Create("npc_combinedropship")
    dropship:SetPos(Vector(1034.0708007813, 932.80603027344, 1040.7374267578))
    dropship:SetAngles(Angle(0, 0, 0))
    dropship:SetKeyValue("squadname", "overwatch")
    dropship:SetKeyValue("GunRange", "3000")
    dropship:SetKeyValue("CrateType", "1")
    dropship:CapabilitiesAdd(CAP_MOVE_FLY)
    dropship:CapabilitiesAdd(CAP_SQUAD)
    dropship:Spawn()
    dropship:Activate()

    local spectateEnt = ents.Create("prop_dynamic")
    spectateEnt:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    spectateEnt:SetPos(dropship:GetPos() + dropship:GetForward() * 50 + dropship:GetUp() * 30)
    spectateEnt:SetAngles(dropship:GetAngles())
    spectateEnt:SetParent(dropship)
    spectateEnt:Spawn()
    spectateEnt:SetRenderMode(RENDERMODE_TRANSALPHA)
    spectateEnt:SetColor(Color(255, 255, 255, 0))

    local dropflyingpoint1 = ents.Create("path_track")
    dropflyingpoint1:SetName("plaza_dropship_track_1")
    dropflyingpoint1:SetPos(Vector(-540.41149902344, -3.0951154232025, 581.98107910156))
    dropflyingpoint1:SetKeyValue("target", "plaza_dropship_track_2")
    dropflyingpoint1:Spawn()

    local dropflyingpoint2 = ents.Create("path_track")
    dropflyingpoint2:SetName("plaza_dropship_track_2")
    dropflyingpoint2:SetPos(Vector(903.30316162109, 1175.6020507813, 1423.2448730469))
    dropflyingpoint2:Spawn()

    dropship:Fire("SetTrack", "plaza_dropship_track_1")

    local dropposition = ents.Create("scripted_target")
    dropposition:SetPos(Vector(-540.41149902344, -3.0951154232025, 76.03125))
    dropposition:SetNotSolid(true)
    dropposition:SetNoDraw(true)
    dropposition:Spawn()
    dropposition:Activate()
    dropposition:SetName("plaza_dropship_landing_point")

    timer.Simple(10, function()
        dropship:Fire("SetLandTarget", "plaza_dropship_landing_point")
        dropship:Fire("StopWaitingForDropoff")
        dropship:Fire("LandTakeCrate", 0)
    end)

    -- Process each player in the queue
    for _, player in ipairs(queue) do
        if IsValid(player) then
            player:SetPos(dropship:GetPos())
            player:SetMoveType(MOVETYPE_NONE)
            player:SetNoTarget(true)
            player:SetNotSolid(true)
            player:SetNoDraw(true)
            player:Freeze(true)
            player:SetDSP(31)
            player:SetViewEntity(spectateEnt)
        end
    end

    timer.Simple(19, function()
        for _, player in ipairs(queue) do
            if IsValid(player) then
                timer.Simple(1, function()
                    player:SetMoveType(MOVETYPE_WALK)
                    player:SetNoTarget(false)
                    player:SetNoDraw(false)
                    player:Freeze(false)
                    player:SetDSP(0)
                    player:SetPos(Vector(2956.388672, 369.190216, 136.219025))
                    player:SetViewEntity(nil)
                    timer.Simple(5, function()        
                    	player:SetNotSolid(false)
					end)
                    table.RemoveByValue(queue, player)
                end)
            end
        end
    end)

    timer.Simple(24, function()
        dropship:Fire("SetTrack", "plaza_dropship_track_2")
    end)

    timer.Simple(32, function()
        dropship:Fire("kill")
        dropflyingpoint1:Remove()
        dropflyingpoint2:Remove()
        dropposition:Remove()
        spectateEnt:Remove()  -- Remove the spectator entity
        dropship:Remove()      -- Remove the dropship
        ResetQueue(queue)      -- Call function to reset the queue
    end)
end

function ResetQueue(queue)
    -- Clear the queue (optional, if you want to reset the entire queue)
    for _, player in ipairs(queue) do
        if IsValid(player) then
            player:SetNoTarget(false)
            player:SetNotSolid(false)
            player:SetNoDraw(false)
            player:Freeze(false)
            player:SetDSP(0)
        end
    end
    -- Optionally clear the queue table if you want it to be empty
    table.Empty(queue) -- Clears the queue
end