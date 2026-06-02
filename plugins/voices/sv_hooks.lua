util.AddNetworkString("PlayerStartChat")

local supported = {
    [1] = true, -- ic
    [6] = true, -- yell
    [7] = true  -- whisper
}

function PLUGIN:ChatClassMessageSend(id, rawtext, ply)
    if not impulse.Voice.ChatTypes[id] then
        return
    end
    
    for _, definition in ipairs(impulse.Voice.GetClass(ply)) do
        local sounds, rawtext = impulse.Voice.GetVoiceList(definition.class, rawtext)
        if sounds then
            local volume = 80
            if id == 7 then
                volume = 60
            elseif id == 6 then
                volume = 150
            end
            
            if definition.onModify then
                if definition.onModify(ply, sounds, id, rawtext) == false then
                    continue
                end
            end
            
            if definition.isGlobal then
                netstream.Start(nil, "voicePlay", sounds, volume)
            else
                netstream.Start(nil, "voicePlay", sounds, volume, ply:EntIndex())
                if id == 8 then
                    for _, k in pairs(player.GetAll()) do
                        if k:IsCP() and k ~= ply then
                            netstream.Start(k, "voicePlay", sounds, volume * 0.5)
                        end
                    end
                end
                if (id == 57 or id == 58) and ply:IsCP() then
                    for _, k in pairs(player.GetAll()) do
                        if k:Team() == ply:Team() and k ~= ply then
                            netstream.Start(k, "voicePlay", sounds, volume * 0.5)
                        end
                    end
                end
            end

            if supported[id] then
                net.Start("impulseSuppressedProcessDisplayChat")
                    net.WriteEntity(ply)
                    net.WriteString(rawtext)
                    net.WriteUInt(id, 4)
                net.Broadcast()
            end

            return rawtext
        end
    end
end

net.Receive("PlayerStartChat", function(len, client)
	if (!client.bTypingBeep) then
        if ( impulse.Voice.BeepSounds[client:Team()] ) then
            if ( impulse.Voice.BeepSounds[client:Team()].on ) then
                client:EmitSound(impulse.Voice.BeepSounds[client:Team()].on[math.random(1, #impulse.Voice.BeepSounds[client:Team()].on)])
                client.bTypingBeep = true
            end
        end
	end
end)