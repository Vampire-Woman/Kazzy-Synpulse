if SERVER then
    util.AddNetworkString("impulseHL2RPBioDeath")

    -- =========================
    -- CONFIG
    -- =========================
    local GAP = 0.15
    local START_DELAY = 5

    -- Optional:
    -- Delay before the chat/waypoint appears
    -- so it lines up with "lost biosignal for unit"
    local MESSAGE_DELAY = START_DELAY + 0

    -- =========================
    -- WORD → SOUND
    -- =========================
    local WORD_SOUNDS = {
        defender = "npc/overwatch/radiovoice/defender.wav",
        hero = "npc/overwatch/radiovoice/hero.wav",
        jury = "npc/overwatch/radiovoice/jury.wav",
        victor = "npc/overwatch/radiovoice/victor.wav",
        line = "npc/overwatch/radiovoice/line.wav",
        patrol = "npc/overwatch/radiovoice/patrol.wav",
        quick = "npc/overwatch/radiovoice/quick.wav",
        roller = "npc/overwatch/radiovoice/roller.wav",
        king = "npc/overwatch/radiovoice/king.wav",
        vice = "npc/overwatch/radiovoice/vice.wav"
    }

    local WORD_NAMES = {
        "Defender",
        "Hero",
        "Jury",
        "Victor",
        "Line",
        "Patrol",
        "Quick",
        "Roller",
        "King",
        "Vice"
    }

    -- =========================
    -- DIGIT → SOUND
    -- =========================
    local DIGIT_SOUNDS = {
        ["0"] = "npc/overwatch/radiovoice/zero.wav",
        ["1"] = "npc/overwatch/radiovoice/one.wav",
        ["2"] = "npc/overwatch/radiovoice/two.wav",
        ["3"] = "npc/overwatch/radiovoice/three.wav",
        ["4"] = "npc/overwatch/radiovoice/four.wav",
        ["5"] = "npc/overwatch/radiovoice/five.wav",
        ["6"] = "npc/overwatch/radiovoice/six.wav",
        ["7"] = "npc/overwatch/radiovoice/seven.wav",
        ["8"] = "npc/overwatch/radiovoice/eight.wav",
        ["9"] = "npc/overwatch/radiovoice/nine.wav"
    }

    -- =========================
    -- SEQUENCE PLAYER
    -- =========================
    local function PlaySequence(sequence, ply, startDelay)
        local delay = startDelay or 0

        for _, snd in ipairs(sequence) do
            timer.Simple(delay, function()
                if IsValid(ply) then
                    ply:EmitSound(snd, 42, 100)
                end
            end)

            delay = delay + SoundDuration(snd) + GAP
        end
    end

    -- =========================
    -- BUILD + PLAY BIOSIGNAL
    -- =========================
    local function PlayBiosignalVoice(name, ply)
        if not name then return end

        -- Remove bracketed text
        name = string.gsub(name, "%[.-%]", "")

        -- Cleanup spacing
        name = string.Trim(name)
        name = string.gsub(name, "%s+", " ")

        local prefix, number = string.match(string.lower(name), "(.+)%s+(%d+)$")

        if not prefix or not number then
            print("[BIOSIGNAL] Failed to parse name:", name)
            return
        end

        local sequence = {}

        -- Intro
        table.insert(sequence, "npc/overwatch/radiovoice/on3.wav")

        -- Main line
        table.insert(sequence, "npc/overwatch/radiovoice/lostbiosignalforunit.wav")

        -- Unit word
        if WORD_SOUNDS[prefix] then
            table.insert(sequence, WORD_SOUNDS[prefix])
        end

        -- Digits
        for digit in string.gmatch(number, "%d") do
            if DIGIT_SOUNDS[digit] then
                table.insert(sequence, DIGIT_SOUNDS[digit])
            end
        end

        -- Ending
        table.insert(sequence, "npc/overwatch/radiovoice/unitdownat.wav")
		
        table.insert(sequence, "npc/advisor/advisorscreenvx0" .. math.random(1,8) .. ".wav")
		
        table.insert(sequence, "npc/overwatch/radiovoice/allteamsrespondcode3.wav")
		table.insert(sequence, "npc/overwatch/radiovoice/off2.wav")

        PlaySequence(sequence, ply, START_DELAY)
    end

    -- =========================
    -- SEND BIOSIGNAL
    -- =========================
    local function SendBiosignal(name, pos)
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsCP()
            and ply:Team() ~= TEAM_WORKER
            and ply:Team() ~= TEAM_HAZMAT then

                net.Start("impulseHL2RPBioDeath")
                    net.WriteString(name)
                    net.WriteVector(pos)
                net.Send(ply)
            end
        end
    end

    -- =========================
    -- SEND CHAT MESSAGE
    -- =========================
    local function SendDeathChatMessage(name, isNPC)
        local rawText
		local faggot = bit.tohex(bit.tobit(math.random(-999999999999999, 999)))

        if isNPC then
            rawText =
                "Lost biosignal for Protection Team Unit [" ..
                math.random(25, 99) ..
                "] " ..
                name ..
                ". Unit down at 404 zone. All teams, respond code 3."
        else
            rawText =
                "Lost biosignal for Protection Team Unit " ..
                name ..
                ". Unit down at " .. faggot .. ". All teams, respond code 3."
        end

        for _, ply in ipairs(player.GetAll()) do
            if ply:IsCP()
            and ply:Team() ~= TEAM_WORKER
            and ply:Team() ~= TEAM_HAZMAT then

                ply:SendChatClassMessage(14, rawText, ply)
            end
        end
    end

    -- =========================
    -- NPC DEATH
    -- =========================
    hook.Add("OnNPCKilled", "impulseHL2RPBiosignal_NPC", function(npc)
        if npc:GetClass() ~= "npc_metropolice" then return end

        local name = table.Random(WORD_NAMES) .. " " .. math.random(100, 999)
        local pos = npc:GetPos()

        -- Play voice immediately (with built-in START_DELAY)
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsCP()
            and ply:Team() ~= TEAM_WORKER
            and ply:Team() ~= TEAM_HAZMAT then

                PlayBiosignalVoice(name, ply)
            end
        end

        -- Delay chat + waypoint
        timer.Simple(MESSAGE_DELAY, function()
            SendBiosignal(name, pos)
            SendDeathChatMessage(name, true)
        end)
    end)

    -- =========================
    -- PLAYER DEATH
    -- =========================
    hook.Add("PlayerDeath", "impulseHL2RPBiosignal_Player", function(victim)
        if not IsValid(victim) then return end
        if not victim:IsCP() then return end

        if victim:Team() == TEAM_WORKER then return end
        if victim:Team() == TEAM_HAZMAT then return end
        if victim:Team() == TEAM_OTA then return end

        if victim._biosignalTriggered then return end
        victim._biosignalTriggered = true

        timer.Simple(0, function()
            if IsValid(victim) then
                victim._biosignalTriggered = nil
            end
        end)

        local name = victim:Nick()
        local pos = victim:GetPos()

        -- Play biosignal to all CPs
        for _, ply in ipairs(player.GetAll()) do
            if ply:IsCP()
            and ply:Team() ~= TEAM_WORKER
            and ply:Team() ~= TEAM_HAZMAT then

                PlayBiosignalVoice(name, ply)
            end
        end

        -- Delay chat + waypoint
        timer.Simple(MESSAGE_DELAY, function()
            SendBiosignal(name, pos)
            SendDeathChatMessage(name, false)
        end)
    end)
end

if CLIENT then
    net.Receive("impulseHL2RPBioDeath", function()
        local name = net.ReadString()
        local pos = net.ReadVector()

        local ply = LocalPlayer()

        if not IsValid(ply) then return end
        if not ply:IsCP() then return end
        if ply:Team() == TEAM_WORKER then return end
        if ply:Team() == TEAM_HAZMAT then return end

        ply:SendCombineMessage(
            " Downloading lost biosignal data",
            Color(255, 53, 53)
        )

        impulse.AddCombineWaypoint(
            "BIOSIGNAL LOSS",
            pos,
            300,
            3,
            4,
            4
        )
    end)
end