impulse.ci = impulse.ci or {}

util.AddNetworkString("NewRankBecome")
util.AddNetworkString("impulseCitadelRankOpen")
util.AddNetworkString("impulseCitadelOverlayBoot")
util.AddNetworkString("impulseHL2RPCombineOverlayBoot")
util.AddNetworkString("impulseHL2RPAmmoRaid")
util.AddNetworkString("impulseCitadelCombineTerminalOpen")
util.AddNetworkString("impulseTerminalMenu")
util.AddNetworkString("impulseTerminalPlayer")
util.AddNetworkString("impulseChargesMenu")
util.AddNetworkString("impulseTerminalPlayer")
util.AddNetworkString("impulseCitadelCombineTerminalCharge")
util.AddNetworkString("impulseCitadelCombineTerminalChangeSocioStatus")
util.AddNetworkString("RankPointEquipmentCheck")
util.AddNetworkString("DivisionLeaderBecome")

net.Receive("RankPointEquipmentCheck", function(len, ply)
    local load1 = net.ReadBool(option1)
    local load2 = net.ReadBool(option2)
    local load3 = net.ReadBool(option3)
    local load4 = net.ReadBool(option4)
    local load5 = net.ReadBool(option5)
    local load6 = net.ReadBool(option6)

    if load1 == true then
        ply:AddLoadoutExtraAmmo()
    else
        ply:RemoveLoadoutExtraAmmo()
    end
    if load2 == true then
        ply:Give("ls_usp")
    else
        ply:StripWeapon("ls_usp")
    end
    if load3 == true then
        ply:AddLoadoutHealthVial()
    else
        ply:RemoveLoadoutHealthVial()
    end
    if load4 == true then
        ply:AddLoadoutHealthKit()
    else
        ply:RemoveLoadoutHealthKit()
    end
    if load5 == true then
        ply:AddLoadoutSMG()
    else
        ply:RemoveLoadoutSMG()
    end
    if load6 == true then
        ply:AddLoadoutExtraCuffs()
    else
        ply:RemoveLoadoutExtraCuffs()
    end
end)

net.Receive("DivisionLeaderBecome", function(len, ply)
    if ( ply:CanBecomeTeamClass(4, true) ) then
        ply:SetTeamClass(4)
        ply:DynamicNotify("You have been given Divisional Leader clearance.", 1)
    else
        ply:DynamicNotify("You do not have clearance to use this.", 2)
    end
end)

net.Receive("NewRankBecome", function(len, ply)
    ply:EmitSound("items/ammocrate_open.wav")

    -- Set team class based on rank points
	local rankPoints = ply:GetRankPoints()

	if rankPoints >= 75 then
		ply:SetTeamClass(4)
		print("You currently have " .. rankPoints .. " RP.")
	elseif rankPoints >= 50 then
		ply:SetTeamClass(3)
		print("You currently have " .. rankPoints .. " RP.")
	elseif rankPoints >= 25 then
		ply:SetTeamClass(2)
		print("You currently have " .. rankPoints .. " RP.")
	else
		ply:SetTeamClass(1)
		print("You currently have " .. rankPoints .. " RP.")
	end

    -- Define all code tables
    local tCPCodes = {"Defender","Hero","Jury","Victor","Line","Patrol","Quick","Roller","King","Vice"}
    local tTFCodes = {"Blade","Dagger","Hammer","Hunter","Ranger","Razor","Spear","Striker","Tracker","Savage","Flash","Slash","Scar","Sweeper","Swift","Fist","Sword","Stab"}
    local tAWCodes = {"Ghost","Winder","Nomad","Hurricane","Phantom","Judge","Shadow","Stinger","Storm","Reaper"}
    local tCivilCodes = {"Stick","Tap","Union","Xray","Yellow"}

    local sSteamID = ply:SteamID64()
    local sLastDigits = string.Right(sSteamID, 3)
    local sTagLine = ""

    -- Determine tag line based on TEAM
    local team = ply:Team()

    if team == TEAM_VORT then
        sTagLine = "B39-09" .. sLastDigits
    elseif team == TEAM_CP then
        -- Pick random CP code
        sTagLine = tCPCodes[(sSteamID[11] % #tCPCodes) + 1] .. " " .. sLastDigits
    elseif team == TEAM_OTA then
        -- HL2 soldiers use TF codes
        sTagLine = tTFCodes[(sSteamID[11] % #tTFCodes) + 1] .. " " .. sLastDigits
    elseif team == TEAM_WORKER then
        -- Civilian workers use civil codes
        sTagLine = tCivilCodes[(sSteamID[11] % #tCivilCodes) + 1] .. " " .. sLastDigits
    else
        -- fallback: just use CP codes
        sTagLine = tCPCodes[(sSteamID[11] % #tCPCodes) + 1] .. " " .. sLastDigits
    end

    -- Apply the RP name
    ply:SetRPName(sTagLine, false)

    -- Notify CP players about new rank
    local recipFilter = RecipientFilter()
    for _, k in pairs(player.GetAll()) do
        if k:IsCP() then
            recipFilter:AddPlayer(k)
        end
    end
    net.Start("impulseHL2RPJoinRank")
    net.WriteUInt(ply:EntIndex(), 8)
    net.Send(recipFilter)

    -- Open overlay for the player
    net.Start("impulseHL2RPCombineOverlayBoot")
    net.Send(ply)
end)

net.Receive("impulseCitadelCombineTerminalCharge", function(len, ply)
    local chargesTable = net.ReadTable()
    local chargesTimeOriginal = net.ReadUInt(4)
    local chargesTime = net.ReadUInt(12) 
    local arrest = ply.ArrestedDragging

    if not arrest then
        ply:Notify("You are not dragging someone!")
        return
    end

    local reasons = {}  -- New table to store the reasons for the selected charges
    for _, charge in pairs(chargesTable) do
        table.insert(reasons, impulse.ci.arrest.config["arrestCharges"][charge].name)
    end

    ply:Notify("You have jailed " .. arrest:Nick() .. " for " .. chargesTime .. " seconds. With the reasons of: " .. table.concat(reasons, ", "))
    ply:GiveInventoryItem("item_ziptie", 1, true)
    arrest:Jail(chargesTime)

    arrest:DynamicNotify("You have been jailed for " .. chargesTime .. " seconds. With the reasons of: " .. table.concat(reasons, ", "), 2)
    arrest:Jail(chargesTime)
end)

function impulse.ci.socioStatus.Set(ply, socioStatus)
    if ( IsValid(ply) ) then
        if ( impulse.ci.socioStatus.Get(socioStatus) and impulse.ci.socioStatus.Get(socioStatus).OnCheckAccess ) then
            if ( ( impulse.ci.socioStatus.coolDown or 0 ) < CurTime() ) then
                impulse.ci.socioStatus.coolDown = CurTime() + 0

                if not ( impulse.ci.socioStatus.Get(socioStatus):OnCheckAccess(ply) ) then
                    --ply:Notify("You do not have access to change the socio status.")
                    return false
                end
            else
                --ply:Notify("You must wait before using changing socio statuses.")
                return false
            end
        end
    end
    
    for k, v in pairs(impulse.ci.socioStatus.list) do
        if ( impulse.ci.socioStatus.Get(k) and impulse.ci.socioStatus.Get(k).onEnd ) then
            if ( impulse.ci.socioStatus.GetCurrent() == k ) then
                impulse.ci.socioStatus.Get(k):OnEnd()
            end
        end
    end

    if ( impulse.ci.socioStatus.Get(socioStatus) and impulse.ci.socioStatus.Get(socioStatus).onStart ) then
        if not ( impulse.ci.socioStatus.GetCurrent() == socioStatus ) then
            impulse.ci.socioStatus.Get(socioStatus):OnStart()
        end
    end
    
    SetGlobalString("impulseCitadelSocioStatus", socioStatus)
end