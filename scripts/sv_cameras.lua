-- ===============================
-- Combine Security Camera Server
-- Tracks which players are viewing which cameras
-- ===============================

-- Network strings
util.AddNetworkString("Combine_Security_Enter")
util.AddNetworkString("Combine_Security_Exit")

-- Table to track players viewing cameras
local CameraPlayers = {}

-- Player requests to enter camera view
net.Receive("Combine_Security_Enter", function(len, ply)
    local camIndex = net.ReadInt(16)
    local cam = Entity(camIndex)

    -- Validate camera entity
    if not IsValid(cam) or (cam:GetClass() ~= "npc_turret_ceiling" and cam:GetClass() ~= "npc_combine_camera") then return end

    -- Track player and camera
    CameraPlayers[ply] = cam

    -- Freeze the player
    ply:Freeze(true)
end)

-- Player requests to exit camera view
net.Receive("Combine_Security_Exit", function(len, ply)
    -- Untrack player
    CameraPlayers[ply] = nil

    -- Unfreeze the player
    if IsValid(ply) then
        ply:Freeze(false)
    end
end)

-- Optional: clean up on disconnect
hook.Add("PlayerDisconnected", "CombineCameraCleanup", function(ply)
    CameraPlayers[ply] = nil
end)

-- Optional: can be used server-side if you need a list of active cameras
function GetPlayerCamera(ply)
    return CameraPlayers[ply]
end