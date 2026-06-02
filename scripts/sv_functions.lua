local net_Send = net.Send
local net_WriteUInt = net.WriteUInt
local net_WriteBool = net.WriteBool
local ipairs = ipairs
local IsValid = IsValid
local SafeRemoveEntity = SafeRemoveEntity
local net_Start = net.Start
local net_WriteEntity = net.WriteEntity
local net_WriteString = net.WriteString
local net_WriteInt = net.WriteInt
local net_Broadcast = net.Broadcast
local pairs = pairs
local player_GetAll = player.GetAll
local impulse = impulse
local timer_Exists = timer.Exists
local timer_Create = timer.Create
local timer_Simple = timer.Simple
local math_random = math.random
local ents_FindByClass = ents.FindByClass

function impulse.PlayGesture(ply, gesture, slot)
    local slot = slot or GESTURE_SLOT_CUSTOM

    net_Start("impulseDoGesture")
        net_WriteEntity(ply)
        net_WriteString(gesture)
        net_WriteInt(slot, 16)
    net_Broadcast()
end

function meta:IsInGame()
    if ( IsValid(impulse.splash) or IsValid(impulse.MainMenu) ) then
        return false
    end

    return true
end

function impulse.NotifyAll(message)
    for k, v in ipairs(player_GetAll()) do
        v:Notify(message)
    end
end

function impulse.AddChatText(...)
    for k, v in ipairs(player_GetAll()) do
        v:AddChatText(...)
    end
end

function impulse.ZeroNumber(number, length)
	local amount = math.max(0, length - string.len(number))
	return string.rep("0", amount)..tostring(number)
end

// i find this better than the impulse version
// taken from https://github.com/NebulousCloud/helix/blob/master/gamemode/core/sh_util.lua#L1108
local ADJUST_SOUND = SoundDuration("npc/metropolice/pain1.wav") > 0 and "" or "../../hl2/sound/"

--- Emits sounds one after the other from an entity.
-- @realm shared
-- @entity entity Entity to play sounds from
-- @tab sounds Sound paths to play
-- @number delay[opt=0] How long to wait before starting to play the sounds
-- @number spacing[opt=0.1] How long to wait between playing each sound
-- @number volume[opt=75] The sound level of each sound
-- @number pitch[opt=100] Pitch percentage of each sound
-- @treturn number How long the entire sequence of sounds will take to play
function impulse.EmitQueuedSounds(entity, sounds, delay, spacing, volume, pitch)
	-- Let there be a delay before any sound is played.
	delay = delay or 0
	spacing = spacing or 0.1

	-- Loop through all of the sounds.
	for _, v in ipairs(sounds) do
		local postSet, preSet = 0, 0

		-- Determine if this sound has special time offsets.
		if (istable(v)) then
			postSet, preSet = v[2] or 0, v[3] or 0
			v = v[1]
		end

		-- Get the length of the sound.
		local length = SoundDuration(ADJUST_SOUND..v)
		-- If the sound has a pause before it is played, add it here.
		delay = delay + preSet

		-- Have the sound play in the future.
		timer.Simple(delay, function()
			-- Check if the entity still exists and play the sound.
			if (IsValid(entity)) then
				entity:EmitSound(v, volume, pitch)
			end
		end)

		-- Add the delay for the next sound.
		delay = delay + length + postSet + spacing
	end

	-- Return how long it took for the whole thing.
	return delay
end

function meta:IsTeamCP()
    return self:Team() == TEAM_CP
end

function meta:IsTeamOTA()
    return self:Team() == TEAM_OTA
end

function meta:IsTeamRebel()
    return self:Team() == TEAM_REBEL
end

function meta:IsCombine()
    return self:IsTeamCP() or self:IsTeamOTA()
end

function meta:IsTeamVort()
    return self:Team() == TEAM_VORT
end

function impulse.CreateItemCleanerTimer()
    timer.Create("impulseRagdollCleaner", (60 * 1), 0, function()
        timer.Simple(300, function()
            for _, v in pairs(ents.FindByClass("gib")) do
                if ( IsValid(v) ) then
                    SafeRemoveEntity(v)
                end
            end
        end)
    end)
end

function SpawnJunk(item, ply)
    local junk = ents.Create("prop_physics")
    if IsValid(junk) then
        junk:SetModel(item.Model)  -- Use the item's model for the junk
        junk:SetPos(ply:GetPos() + ply:GetForward() * 30 + Vector(0, 0, 10))  -- Spawn slightly in front of the player
        junk:Spawn()

        timer.Simple(300, function()
            if IsValid(junk) then
                junk:Remove()
            end
        end)
    end
end

function meta:RequestString(title, subTitle, callback, default)
    local time = math.floor(os.time())

    self.impulseStrReqs = self.impulseStrReqs or {}
    self.impulseStrReqs[time] = callback

    net.Start("impulseStringRequest")
        net.WriteUInt(time, 32)
        net.WriteString(title)
        net.WriteString(subTitle)
        net.WriteString(default)
    net.Send(self)
end

local workshop_items = engine.GetAddons()
for i = 1, #workshop_items do
	resource.AddWorkshop(workshop_items[i].wsid)
end

local eligibleTeams = {
    [TEAM_CP] = false,
    [TEAM_OTA] = false,
    [TEAM_CITIZEN] = true,
    [TEAM_VORT] = true
}

local function notifyPlayerRestrictedBlock(ply, blockName)
    if blockName == "404 Zone" and eligibleTeams[ply:Team()] then
        ply:Notify("404 OVERWATCH index error", 2)
    end
end

hook.Add("PlayerZoneChanged", "RestrictedBlockNotify", function(ply, id)
    local zoneName = impulse.Config.Zones[id] and impulse.Config.Zones[id].name or ""
    notifyPlayerRestrictedBlock(ply, zoneName)
end)