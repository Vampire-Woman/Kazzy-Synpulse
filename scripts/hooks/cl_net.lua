local net_ReadUInt = net.ReadUInt
local net_ReadString = net.ReadString
local Derma_StringRequest = Derma_StringRequest
local net_Start = net.Start
local net_WriteUInt = net.WriteUInt
local net_WriteString = net.WriteString
local net_SendToServer = net.SendToServer
local net_ReadEntity = net.ReadEntity
local IsValid = IsValid
local net_ReadString = net.ReadString
local net_ReadInt = net.ReadInt
local net_ReadUInt = net.ReadUInt
local net_ReadBool = net.ReadBool
local impulse = impulse
local vgui_Create = vgui.Create
local net_Receive = net.Receive
local net_ReadTable = net.ReadTable
local isnumber = isnumber
local timer_Simple = timer.Simple
local LocalPlayer = LocalPlayer
local net_ReadString = net.ReadString
local net_ReadAngle = net.ReadAngle
local gui_OpenURL = gui.OpenURL

netstream.Hook("voicePlay", function(sounds, volume, index)
	if index then
		local client = Entity(index)

		if (IsValid(client)) then
			client:EmitQueuedSounds(sounds, nil, nil, volume)
		end
	else
		--table.insert(sounds, 1, "npc/overwatch/radiovoice/on1.wav")
		--table.insert(sounds, "npc/overwatch/radiovoice/off4.wav")
		LocalPlayer():EmitQueuedSounds(sounds, nil, nil, volume)
	end
end)

net.Receive("impulseDoGesture", function(len)
    local ply = net.ReadEntity()
    if not ( IsValid(ply) ) then
        return
    end

    local gestureID = net.ReadString()
    if not ( gestureID ) then
        gestureID = ""
    end

    local slotID = net.ReadInt(16)
    if not ( slotID ) then
        slotID = GESTURE_SLOT_CUSTOM
    end

    local gesture = ply:LookupSequence(gestureID)
    local slot = slotID

    ply:AddVCDSequenceToGestureSlot(slot, gesture, 0, 1)
end)

net.Receive("ApplyRecognize", function()
	local ply = net.ReadEntity()
	for v,k in pairs(player.GetAll()) do
		if IsValid(ply) and IsValid(k) and (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then -- ended up using talk distance lol
			CreateApply(ply)
		end
	end
end)

net.Receive("impulseStringRequest", function()
	local time = net.ReadUInt(32)
	local title, subTitle = net.ReadString(), net.ReadString()
	local default = net.ReadString()

	Derma_StringRequest(title, subTitle, default or "", function(text)
		net.Start("impulseStringRequest")
			net.WriteUInt(time, 32)
			net.WriteString(text)
		net.SendToServer()
	end)
end)