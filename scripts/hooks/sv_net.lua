-- Networking
util.AddNetworkString("ApplyRecognize")
util.AddNetworkString("cwuGiveMoney")
util.AddNetworkString("cwuTakeMoney")
util.AddNetworkString("CitadelTrainDeploy")
util.AddNetworkString("PlayerEndVoiceSV")
util.AddNetworkString("PlayerStartVoiceSV")
util.AddNetworkString("impulseDoGesture")
util.AddNetworkString("impulseStringRequest")
util.AddNetworkString("impulseCreateVGUI")

-- Money / Class
net.Receive("cwuTakeMoney", function(len, ply)
    local classOption = net.ReadUInt(3)

    if classOption == 1 then
        ply:SetTeamClass(CLASS_CWU_INDUSTRIAL)
    elseif classOption == 2 then
        ply:SetTeamClass(CLASS_CWU_COMMERCIAL)
    elseif classOption == 3 then
        ply:SetTeamClass(CLASS_CWU_MEDICAL)
    end

    ply:TakeMoney(10)
end)

net.Receive("cwuGiveMoney", function(len, ply)
    ply:GiveMoney(10)
    ply:SetTeam(1)
end)

-- Train deploy
net.Receive("CitadelTrainDeploy", function(len, ply)
    ply:SetPos(Vector(-3559.431640625, 1591.9478759766, 48.03125))
    ply:ScreenFade(SCREENFADE.IN, color_black, 20, 3)
    ply:EmitSound("ambient/alarms/razortrain_horn1.wav")
    ply:Notify("You have taken the Razor Train to the City.")
end)

-- String request system
net.Receive("impulseStringRequest", function(length, client)
    local time = net.ReadUInt(32)
    local text = net.ReadString()

    if client.impulseStrReqs and client.impulseStrReqs[time] then
        client.impulseStrReqs[time](text)
        client.impulseStrReqs[time] = nil
    end
end)

-- Meta function
local meta = FindMetaTable("Player")

function meta:OpenVGUI(panel)
    if not isstring(panel) then
        ErrorNoHalt("Warning argument is required to be a string! Instead is "..type(panel).."\n")
        return
    end

    net.Start("impulseCreateVGUI")
        net.WriteString(panel)
    net.Send(self)
end

function SCHEMA:PlayerFootstep(ply, pos, foot, soundName, vol)
    local team = ply:Team()
    local class = ply.GetTeamClass and ply:GetTeamClass()
    local cityCode = impulse.Dispatch.GetCityCode()

    local function playGear(level, pitchMin, pitchMax, volume)
        ply:EmitSound("npc/combine_soldier/gear"..math.random(1,6)..".wav", level, math.random(pitchMin, pitchMax), volume)
    end

    if ply:KeyDown(IN_SPEED) then
        if team == TEAM_CP then
            ply:EmitSound("npc/metropolice/gear"..math.random(1,6)..".wav", 70, math.random(95,105), 0.2)
            return true
        end

        if team == TEAM_OTA and (class == CLASS_ECHO or class == CLASS_MACE or class == CLASS_ELITE) then
            if class == CLASS_ECHO or class == CLASS_ELITE then
                playGear(80, 88, 92, 0.2)
            else
                playGear(100, 98, 102, 0.2)
            end
            return true
        end

        if team == TEAM_VORT then
            ply:EmitSound("npc/vort/vort_foot"..math.random(1,4)..".wav", 100, 100, 1)
        end

    elseif team == TEAM_OTA and (class == CLASS_MACE or class == CLASS_ELITE) then
        playGear(80, 88, 92, 0.2)
        return true
    end
end

-- =====================================================
-- ALL THE APLANS ARE DEAD
-- =====================================================

local lastFootZ = {}
local footState = {}
local nextStepTime = {}

local STEP_COOLDOWN = 0.7
local STEP_HEIGHT_DELTA = 0

local function GetFootBones(ply)
    return {
        left = ply:LookupBone("ValveBiped.Bip01_L_Foot"),
        right = ply:LookupBone("ValveBiped.Bip01_R_Foot")
    }
end

local function GetSurfaceSound(pos, ply)
    local trace = util.TraceLine({
        start = pos,
        endpos = pos - Vector(0, 0, 20),
        filter = ply
    })

    if not trace.Hit then return "concrete" end

    local surfaceData = util.GetSurfaceData(trace.SurfaceProps)
    if surfaceData and surfaceData.name then
        local name = string.lower(surfaceData.name)

        if string.find(name, "metal") then return "metal" end
        if string.find(name, "dirt") then return "dirt" end
		if string.find(name, "rubber") then return "rubber" end
        if string.find(name, "grass") then return "grass" end
        if string.find(name, "sand") then return "sand" end
        if string.find(name, "wood") then return "wood" end
        if string.find(name, "tile") then return "tile" end
    end

    return "concrete"
end

hook.Add("Think", "LegitFootsteps", function()
    for _, ply in ipairs(player.GetAll()) do
		local isRunning = ply:KeyDown(IN_SPEED)
		
        if not IsValid(ply) then continue end
        if not ply:Alive() then continue end
        if not ply:OnGround() then continue end
		if isRunning then continue end

        local velocity = ply:GetVelocity():Length2D()
        if velocity < 20 then continue end  -- too slow, probably idle

        local isRunning = velocity > 90  -- running threshold

        lastFootZ[ply] = lastFootZ[ply] or {left = 0, right = 0}
        footState[ply] = footState[ply] or {left = false, right = false}
        nextStepTime[ply] = nextStepTime[ply] or {left = 0, right = 0}

        local isCharger = ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_CHARGER

        if isCharger then
            -- Charger fallback: play footsteps based on a timer
            nextStepTime[ply].left = nextStepTime[ply].left or 0
            if CurTime() >= nextStepTime[ply].left then
                nextStepTime[ply].left = CurTime() + 0.5  -- fast footsteps

                ply:EmitSound(
                    "footsteps/charger_step_0" .. math.random(1, 5) .. ".mp3",
                    100,
                    100,
                    1
                )
            end
            continue  -- skip normal bone-based logic
        end

        -- Normal players with proper bones
        local bones = GetFootBones(ply)
        if not bones.left or not bones.right then continue end

        for side, bone in pairs(bones) do
            local pos, ang = ply:GetBonePosition(bone)
            if not pos or pos == vector_origin then continue end

            local currentZ = pos.z
            local lastZ = lastFootZ[ply][side]

            local goingDown = currentZ < (lastZ - STEP_HEIGHT_DELTA)
            local canStep = CurTime() >= nextStepTime[ply][side]

            if goingDown and canStep then
                if not footState[ply][side] and not isRunning then
                    footState[ply][side] = true
                    nextStepTime[ply][side] = CurTime() + STEP_COOLDOWN

                    local mat = GetSurfaceSound(pos, ply)
                    -- Rubber only has rubber.wav
                    if mat == "rubber" then
                        soundPath = "player/footsteps/rubber.wav"
                    else
                        soundPath = "player/footsteps/" .. mat .. math.random(1, 4) .. ".wav"
                    end

                    ply:EmitSound(
                        soundPath,
                        100,
                        math.random(97, 103),
                        0.2
                    )
                end
            else
                footState[ply][side] = false
            end

            lastFootZ[ply][side] = currentZ
        end
    end
end)

hook.Add("PlayerDisconnected", "CleanupLegFootsteps", function(ply)
    lastFootZ[ply] = nil
    footState[ply] = nil
    nextStepTime[ply] = nil
end)