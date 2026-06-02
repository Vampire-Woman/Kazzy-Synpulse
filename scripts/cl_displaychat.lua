impulse.DisplayChat = impulse.DisplayChat or {}

local stored = impulse.DisplayChat.stored or {}
impulse.DisplayChat.stored = stored

net.Receive("impulseSuppressedProcessDisplayChat", function()
    local ply = net.ReadEntity()
    local text = net.ReadString()
    local chatType = net.ReadUInt(4)

    if not (text) then
        return
    end

    if (IsValid(ply)) then
        local maxLen = 256
        local textLen = string.utf8len(text)
        local duration = 15

        if chatType == 9 then
            text = ply:KnownName() .. " " .. text
        end

        table.insert(stored, {
            ply = ply,
            text = textLen > maxLen and utf8.sub(text, 1, 256) .. "..." or text,
            color = color,
            font = font,
            chatType = chatType, -- Store chat type
            fadeTime = duration,
            startTime = CurTime()
        })
    end
end)