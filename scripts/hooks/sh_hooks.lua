local util_AddNetworkString = SERVER and util.AddNetworkString
local umsg_PoolString = SERVER and umsg.PoolString
local FindMetaTable = FindMetaTable
local net_Receive = net.Receive
local net_ReadEntity = net.ReadEntity
local net_ReadUInt = net.ReadUInt
local player_GetAll = player.GetAll
local net_Start = net.Start
local net_WriteUInt = net.WriteUInt
local net_WriteEntity = net.WriteEntity
local net_Send = SERVER and net.Send
local net_ReadFloat = net.ReadFloat
local net_WriteFloat = net.WriteFloat
local net_ReadData = net.ReadData
local table_getn = table.getn
local STNDRD = STNDRD
local timer_Create = timer.Create
local net_WriteData = net.WriteData
local net_ReadColor = net.ReadColor
local net_ReadString = net.ReadString
local net_WriteColor = net.WriteColor
local net_WriteString = net.WriteString
local umsg_Start = SERVER and umsg.Start
local umsg_Float = SERVER and umsg.Float
local umsg_End = SERVER and umsg.End
local hook_Add = hook.Add
local CreateClientConVar = CreateClientConVar
local surface_CreateFont = CLIENT and surface.CreateFont
local Color = Color
local net_SendToServer = CLIENT and net.SendToServer
local ScrH = ScrH
local ScrW = ScrW
local util_Base64Encode = util.Base64Encode
local render_Capture = CLIENT and render.Capture
local util_Compress = util.Compress
local string_len = string.len
local math_ceil = math.ceil
local string_sub = string.sub
local CurTime = CurTime
local math_Round = math.Round
local LocalPlayer = LocalPlayer
local vgui_Create = CLIENT and vgui.Create
local vgui_GetWorldPanel = CLIENT and vgui.GetWorldPanel
local table_concat = table.concat
local util_Decompress = util.Decompress
local GetConVar = GetConVar
local surface_SetDrawColor = CLIENT and surface.SetDrawColor
local surface_DrawOutlinedRect = CLIENT and surface.DrawOutlinedRect
local surface_DrawRect = CLIENT and surface.DrawRect
local surface_SetFont = CLIENT and surface.SetFont
local surface_SetTextPos = CLIENT and surface.SetTextPos
local surface_GetTextSize = CLIENT and surface.GetTextSize
local surface_SetTextColor = CLIENT and surface.SetTextColor
local surface_DrawText = CLIENT and surface.DrawText
local PaintClose = PaintClose
local player_GetHumans = player.GetHumans
local isstring = isstring
local timer_Simple = timer.Simple
local file_Find = file.Find
local table_ToString = table.ToString
local DermaMenu = DermaMenu
local file_Delete = file.Delete
local file_Read = file.Read
local hook_Remove = hook.Remove
local type = type
local file_Exists = file.Exists
local file_CreateDir = file.CreateDir
local os_date = os.date
local file_Write = file.Write
local concommand_Add = concommand.Add
local usermessage_Hook = usermessage.Hook
local SoundDuration = SoundDuration
local ipairs = ipairs
local istable = istable
local timer_Simple = timer.Simple
local hook_Add = hook.Add
local net_Start = net.Start
local net_WriteString = net.WriteString
local net_Send = SERVER and net.Send
local vgui_Create = CLIENT and vgui.Create
local player_GetCount = player.GetCount
local IsValid = IsValid
local impulse = impulse
local tonumber = tonumber
local pairs = pairs
local string_Trim = string.Trim
local tostring = tostring

local KEY_BLACKLIST = IN_ATTACK + IN_ATTACK2

meta.CanBecomeTeamClass = meta.CanBecomeTeamClassFixed or meta.CanBecomeTeamClassFixed
meta.CanBecomeTeamRank = meta.CanBecomeTeamRankFixed or meta.CanBecomeTeamRankFixed

function meta:HasWhitelistLevel(lvl)
    return table.HasValue(self.whitelists, lvl)
end

local wepTable = {
	"ls_357",
	"ls_usp",
	"ls_akm",
	"ls_ar2",
	"ls_axe",
	"ls_pickaxe",
	"ls_crossbow",
	"ls_crowbar",
	"ls_cleaver",
	"ls_grenade",
	"ls_pipe",
	"ls_molotov",
	"ls_mp5k",
	"ls_mp7",
	"ls_shovel",
	"ls_spas12",
}

function meta:IsArmed()
	
	if (not IsValid(self)) then return false end

	for k,v in pairs(wepTable) do
		if self:HasWeapon(v) then
			return true
		end
	end

	return false
end

function meta:IsArmored()
	if self and IsValid(self) then
		if self:Team() == TEAM_CITIZEN then
			local bg = self:GetBodygroup(0)

			if bg == 5 or  bg == 6 or bg == 7 or bg == 8 then
				return true
			end
		end
	end

	if self:GetModel() == "models/vortigaunt.mdl" then
		return true
	end

	if self:GetModel() == "models/vortigaunt_blue.mdl" then
		return true
	end

	if self:GetModel() == "models/vortigaunt_doctor.mdl" then
		return true
	end
					
	return false
end

impulse.data = impulse.data or {}
impulse.data.stored = impulse.data.stored or {}

function impulse.data.Set(key, value, bGlobal, bIgnoreMap)
	local path = "impulse/" .. (bGlobal and "" or engine.ActiveGamemode() .. "/") .. (bIgnoreMap and "" or game.GetMap() .. "/")

	if (!bGlobal) then
		file.CreateDir("impulse/" .. engine.ActiveGamemode() .. "/")
	end

	file.CreateDir(path)
	file.Write(path .. key .. ".txt", util.TableToJSON({value}))
	impulse.data.stored[key] = value

	return path
end

function impulse.data.Get(key, default, bGlobal, bIgnoreMap, bRefresh)
	if (!bRefresh) then
		local stored = impulse.data.stored[key]

		if (stored != nil) then
			return stored
		end
	end

	local path = "impulse/" .. (bGlobal and "" or engine.ActiveGamemode() .. "/") .. (bIgnoreMap and "" or game.GetMap() .. "/")
	local contents = file.Read(path .. key .. ".txt", "DATA")

	if (contents and contents != "") then
		local status, decoded = pcall(util.JSONToTable, contents)

		if (status and decoded) then
			local value = decoded[1]

			if (value != nil) then
				return value
			end
		end

		status, decoded = pcall(pon.decode, contents)

		if (status and decoded) then
			local value = decoded[1]

			if (value != nil) then
				return value
			end
		end
	end

	return default
end

function impulse.data.Delete(key, bGlobal, bIgnoreMap)
	local path = "impulse/" .. (bGlobal and "" or engine.ActiveGamemode() .. "/") .. (bIgnoreMap and "" or game.GetMap() .. "/")
	local contents = file.Read(path .. key .. ".txt", "DATA")

	if (contents and contents != "") then
		file.Delete(path .. key .. ".txt")
		impulse.data.stored[key] = nil
		return true
	end

	return false
end

if (SERVER) then
	timer.Create("impulseSaveData", 600, 0, function()
		hook.Run("SaveData")
	end)
end

impulse.RegisterChatCommand("/givewhitelist", {
    description = "Give whitelist, can be TEAM/CLASS/RANK name",
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local targ = impulse.FindPlayer(arg[1])
        local whitelist = table.concat(arg, " ", 2) -- Combine all arguments after the first one
        
        targ:GiveWhitelist(whitelist)
        
        ply:Notify("You have given "..targ:SteamName().. " whitelist for "..whitelist..".")
    end
})

impulse.RegisterChatCommand("/takewhitelist", {
    description = "Take whitelist, can be TEAM/CLASS/RANK name",
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local targ = impulse.FindPlayer(arg[1])
        local whitelist = table.concat(arg, " ", 2) -- Combine all arguments after the first one
        
        targ:TakeWhitelist(whitelist)
        
        ply:Notify("You have taken "..targ:SteamName().. "'s whitelist for "..whitelist..".")
    end
})

local speakGestures = {
    {"g_puncuate", 1445},
    {"hg_headshake", 1446},
    {"hg_nod_left", 1447},
    {"hg_nod_right", 1448},
    {"hg_puncuate_down", 1449},
    {"g_display_left", 1450},
    {"g_left_openhand", 1451},
    {"g_puncuate", 1452},
    {"g_right_openhand", 1453},
    {"b_accent_back", 1454},
    {"b_accent_fwd", 1455},
    {"b_accent_fwd_upperbody", 1456},
    {"b_accent_fwd2", 1457},
    {"b_head_back", 1458},
    {"b_head_forward", 1459},
    {"b_overhere_left", 1460},
    {"b_overhere_right", 1461},
    {"holdhands", 1462},
    {"g_arrest_clench", 1463},
    {"scan_skies_respondin", 1464}
}

local vortSpeakGestures = {
    {"g_accent_bothhands01", 1449},
    {"g_accent2hands_01", 1500},
    {"g_refer_left", 1501},
    {"g_refer_right", 1502}
}

local gestures = {
    {"gesture_item_drop", 1503}
}

function SCHEMA:DoAnimationEvent(ply, event, data)
    if ( event == PLAYERANIMEVENT_CUSTOM_GESTURE ) then
        for k, v in pairs(gestures) do
            if ( data == v[2] ) then
                ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(v[1]), 0, true)

                return ACT_INVALID
            end
        end
		
        if ply:Team() == TEAM_VORT then
            for k, v in pairs(vortSpeakGestures) do
                if ( data == v[2] ) then
                    ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(v[1]), 0, true)
	
                    return ACT_INVALID
                end
            end
        else
            for k, v in pairs(speakGestures) do
                if ( data == v[2] ) then
                    ply:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:LookupSequence(v[1]), 0, true)

                    return ACT_INVALID
                end
            end
        end
    end
end

if ( SERVER ) then
    local supported = {
        [1] = true, -- ic
        [6] = true, -- yell
        [7] = true -- whisper
    }

    hook.Add("ChatClassMessageSend", "impulseSuppressedSpeakingGestures", function(id, rawText, ply)
        if not supported[id] then return end
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
        if not rawText or rawText == "" then return end

        if (ply.nextSpeak or 0) > CurTime() then return end

        if ply:Team() == TEAM_VORT then
            ply:DoAnimationEvent(vortSpeakGestures[math.random(1, #vortSpeakGestures)][2])
        else
            ply:DoAnimationEvent(speakGestures[math.random(1, #speakGestures)][2])
        end

        ply.nextSpeak = CurTime() + 0.5
    end)
	
    hook.Add("PlayerDropItem", "impulseCitadelDropANim", function(ply, item, id)
        ply:DoAnimationEvent(1448)
        ply:EmitSound("physics/body/body_medium_impact_soft1.wav", 60, math.random(95, 110))
    end)
end

if ( CLIENT ) then
    net.Receive("impulsePlaySound", function(len, ply)
        local snd = net.ReadString()
        LocalPlayer():EmitSound(snd, 75, 100, 0.2)
    end)
    
    net.Receive("impulseCreateVGUI", function(len, ply)
        vgui.Create(tostring(net.ReadString()))
    end)
end

-- Define Combine and Rebel NPCs
local npcCombine = {
    ["npc_cscanner"] = true,
    ["npc_stalker"] = true,
    ["npc_clawscanner"] = true,
    ["npc_turret_floor"] = true,
    ["npc_turret_ceiling"] = true,
    ["npc_combine_camera"] = true,
    ["npc_metropolice"] = true,
    ["npc_csniper"] = true,
    ["npc_combine_s"] = true,
    ["npc_manhack"] = true,
    ["npc_rollermine"] = true,
    ["npc_strider"] = true,
    ["npc_hunter"] = true,
    ["npc_combinegunship"] = true,
    ["npc_combinedropship"] = true,
    ["npc_helicopter"] = true
}

local npcRebels = {
    ["npc_alyx"] = true,
    ["npc_barney"] = true,
    ["npc_monk"] = true,
    ["npc_vortigaunt"] = true,	
    ["npc_citizen"] = true
}

function UpdateRelationShip(ent)
    for k, v in pairs(player.GetAll()) do
        local entClass = ent:GetClass()

        -- Combine NPC behavior
        if npcCombine[entClass] then
            if v:Team() == TEAM_CP then
                ent:AddEntityRelationship(v, D_LI, 99)
            elseif v:IsCP() then
                ent:AddEntityRelationship(v, D_LI, 99)
            elseif v:Team() == TEAM_CITIZEN or v:Team() == TEAM_VORT then
                if v:IsArmed() or v:IsArmored() then
                    ent:AddEntityRelationship(v, D_HT, 99)
                else
                    ent:AddEntityRelationship(v, D_LI, 99)
                end
            end
        end

        -- Rebel NPC behavior
        if npcRebels[entClass] then
            if v:Team() == TEAM_CP or v:Team() == TEAM_OTA then
                ent:AddEntityRelationship(v, D_HT, 99)
            else
                ent:AddEntityRelationship(v, D_LI, 99)
            end
        end
    end
end

function SCHEMA:PlayerSpawnedNPC( ply, ent )
    UpdateRelationShip(ent)
end

if ( SERVER ) then
    local chance = math.random(1, 4)
    function SCHEMA:Think()
        for k, v in ipairs(ents.FindByClass("npc_*")) do
            if ( v:GetClass():find("vj_*") ) then
                v.DisableWandering = false
                UpdateRelationShip(v)
                v.FollowPlayerCloseDistance = 64 -- vjbase
                return 
            end
            
            v:SetKeyValue("spawnflags", "16384")
            v:SetKeyValue("spawnflags", "2097152")
            v:SetKeyValue("spawnflags", "8192") -- dont drop weapons

            if ( v.SetCurrentWeaponProficiency ) then
                
                local weaponProficiency

                if ( chance == 0 ) then
                    weaponProficiency = WEAPON_PROFICIENCY_POOR
                elseif ( chance == 1 ) then
                    weaponProficiency = WEAPON_PROFICIENCY_AVERAGE
                elseif ( chance == 2 ) then
                    weaponProficiency = WEAPON_PROFICIENCY_GOOD
                elseif ( chance == 3 ) then
                    weaponProficiency = WEAPON_PROFICIENCY_VERY_GOOD
                elseif ( chance == 4 ) then
                    weaponProficiency = WEAPON_PROFICIENCY_PERFECT
                end

                v:SetCurrentWeaponProficiency(weaponProficiency)
            end
            
			UpdateRelationShip(v)
        end
    end
end