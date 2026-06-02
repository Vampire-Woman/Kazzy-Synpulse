function SCHEMA:ForceDermaSkin()
    return "impulse"
end

scrW, scrH = ScrW(), scrH
function SCHEMA:OnScreenSizeChanged()
    scrW, scrH = ScrW(), scrH
end

--function SCHEMA:HUDPaintBackground()
--    if impulse.GetSetting("drawtesterhud", false) then
--		surface.SetFont( "Impulse-Elements32" )
--		surface.SetTextColor( 255, 255, 255, 70 )
--		surface.SetTextPos( 52, 58 ) 
--		surface.DrawText( "Ping:  " .. LocalPlayer():Ping() )
--
--		surface.SetFont( "Impulse-Elements32" )
--		surface.SetTextColor( 255, 255, 255, 70 )
--		surface.SetTextPos( 52, 28 ) 
--		surface.DrawText( "Suppressed | " .. "User: " .. LocalPlayer():Nick() )
--
--		surface.SetFont( "Impulse-Elements32" )
--		surface.SetTextColor( 255, 255, 255, 70 )
--		surface.SetTextPos( 52, 88 ) 
--		surface.DrawText( "Closed Alpha Version " .. impulse.Config.SchemaVersion )
--	end
--end

--function SCHEMA:ProcessICChatMessage(sender, message)
	--if sender:IsCP() then
		--return "<:: "..message.." ::>"
	--end
--end

function SCHEMA:PlayerStartVoice(ply)
	net.Start("PlayerStartVoiceSV")
	net.SendToServer()
end

function SCHEMA:PlayerEndVoice(ply)
	net.Start("PlayerEndVoiceSV")
	net.SendToServer()
end

--function SCHEMA:DefineSettings()
--	impulse.DefineSetting("drawtesterhud", {
--        name = "Draw Tester Stats",
--        category = "HUD",
--        type = "tickbox",
--        default = true,
--    })
--end

function SCHEMA:Think()
	if ( LocalPlayer():Team() == 0 ) then
        return
    end

	if ( IsValid(impulse.MainMenu) and impulse.MainMenu:IsVisible() ) then
        return
    end

    if not ( LocalPlayer():Alive() ) then
        return
    end

    if IsValid(impulse.playerMenu) and (input.IsKeyDown(KEY_SPACE) or input.IsKeyDown(KEY_ESCAPE)) then
        impulse.playerMenu:Remove()
    end
end

--RunConsoleCommand("disconnect")

hook.Add("Think", "GrenadeLightColor", function()
	for k, v in ipairs(ents.FindByClass("npc_grenade_frag")) do
		local dlight = DynamicLight(v:EntIndex())
		if ( dlight ) then
			dlight.pos = v:GetPos()
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 128
			dlight.DieTime = CurTime() + 1
		end
	end
	
	for k, v in ipairs(ents.FindByClass("crossbow_bolt")) do
		local dlight = DynamicLight(v:EntIndex())
		if ( dlight ) then
			dlight.pos = v:GetPos()
			dlight.r = 255
			dlight.g = 102
			dlight.b = 0
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 128
			dlight.DieTime = CurTime() + 1
		end
	end
	
	for k, v in ipairs(ents.FindByClass("impulse_hl2rp_armorcharger")) do
		local dlight = DynamicLight(v:EntIndex())
		if ( dlight ) then
			dlight.pos = v:GetPos()
			dlight.r = 255
			dlight.g = 125
			dlight.b = 0
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 128
			dlight.DieTime = CurTime() + 1
		end
	end
	
	--for k, v in ipairs(ents.FindByClass("impulse_hl2rp_hpcharger")) do
		--local dlight = DynamicLight(v:EntIndex())
		--if ( dlight ) then
			--dlight.pos = v:GetPos()
			--dlight.r = 0
			--dlight.g = 120
			--dlight.b = 255
			--dlight.brightness = 1
			--dlight.Decay = 1000
			--dlight.Size = 128
			--dlight.DieTime = CurTime() + 1
		--end
	--end
end)

VeryHeavyWeapon = {} 
VeryHeavyWeapon[1] = "ls_m60"
VeryHeavyWeapon[2] = "ls_combinesniper" 
VeryHeavyWeapon[3] = "weapon_bp_guardgun" 
VeryHeavyWeapon[4] = "ls_sniper" 

HeavyWeapon = {} 
HeavyWeapon[1] = "ls_ar2"
HeavyWeapon[2] = "ls_akm" 
HeavyWeapon[3] = "ls_mini14" 
HeavyWeapon[4] = "ls_broom" 
HeavyWeapon[5] = "ls_crossbow" 
HeavyWeapon[6] = "ls_doublebarrel" 
HeavyWeapon[7] = "ls_spas12" 
HeavyWeapon[8] = "weapon_bp_taucannon" 

MediumWeapon = {} 
MediumWeapon[1] = "ls_mp7" 
MediumWeapon[2] = "ls_mp5k" 
MediumWeapon[3] = "ls_m4a1" 

LightWeapon = {} 
LightWeapon[1] = "ls_357"
LightWeapon[2] = "ls_flashbang" 
LightWeapon[3] = "ls_grenade" 
LightWeapon[4] = "ls_medkit" 
LightWeapon[5] = "ls_molotov" 
LightWeapon[6] = "ls_usp" 
LightWeapon[7] = "ls_alyxgun" 
LightWeapon[8] = "ls_goldengun" 

plyLastJump = plyLastJump or 0

hook.Add("StartCommand", "MovementHooks", function(ply, mvData)
    if not ply:Alive() then return end

    -- Arrested speed handling
    if ply:GetSyncVar(SYNC_ARRESTED, false) then
        local arrestedSpeed = 50
        local speedModifier = arrestedSpeed / ply:GetWalkSpeed()
        mvData:SetForwardMove(mvData:GetForwardMove() * speedModifier)
        mvData:SetSideMove(mvData:GetSideMove() * speedModifier)
        return
    end

    -- General movement logic
    local speedRun = ply:GetRunSpeed()
    local wepMod = 1
    local vitalmod = ({0.9, 0.95, 1, 1.05, 1.1})[ply:GetSkillLevel("vitality")] or 0.9

    -- Weapon weight modifiers
    local activeWeapon = ply:GetActiveWeapon()
    if IsValid(activeWeapon) then
        local weaponClass = activeWeapon:GetClass()
        if table.HasValue(VeryHeavyWeapon, weaponClass) then
            wepMod = 0.8
        elseif table.HasValue(HeavyWeapon, weaponClass) then
            wepMod = 0.85
        elseif table.HasValue(MediumWeapon, weaponClass) then
            wepMod = 0.9
        elseif table.HasValue(LightWeapon, weaponClass) then
            wepMod = 1
        end
    end

    -- Adjustments for team classes
    if ply:Team() == TEAM_OTA and ply:GetTeamClass() then
        wepMod = wepMod + 0.025
    end
end)