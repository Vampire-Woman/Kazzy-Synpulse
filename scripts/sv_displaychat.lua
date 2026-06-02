util.AddNetworkString("impulseSuppressedProcessDisplayChat")

local supported = {
    [1] = true, -- ic
    [6] = true, -- yell
    [7] = true, -- whisper
    [9] = true  -- me
}

hook.Add("ChatClassMessageSend", "impulseSuppressedProcessDisplayChat", function(id, rawText, ply)
    if not supported[id] then return end
    if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
    if not rawText or rawText == "" then return end

    net.Start("impulseSuppressedProcessDisplayChat")
        net.WriteEntity(ply)
        net.WriteString(rawText)
        net.WriteUInt(id, 4)
    net.Broadcast()
end)