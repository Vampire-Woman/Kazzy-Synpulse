function SCHEMA:PlayerUse(ply, ent)
    if ( ent:GetClass():find("gmod_sent_vehicle_fphysics_*") and ent:GetClass() != "gmod_sent_vehicle_fphysics_base" ) then
        return false
    end

    if ( ent:GetClass() == "func_door" ) then
        local doorOwners, doorGroup = ent:GetSyncVar(SYNC_DOOR_OWNERS, nil), ent:GetSyncVar(SYNC_DOOR_GROUP, nil)
        if ( ply:CanLockUnlockDoor(doorOwners, doorGroup) and ( ent.impulseCooldown or 0 ) < CurTime() ) then
            ent:DoorUnlock()
            ent:EmitSound("doors/latchunlocked1.wav")

            ent.impulseCooldown = CurTime() + 1
        end
    end
end

function SCHEMA:PlayerJailed(ply)
	if ply:GetSyncVar(SYNC_DISPATCH_BOL, nil) then
		ply:RemoveDispatchBOL()
	end
end

function SCHEMA:PostSetupPlayer(ply)
    ply:SetFOV(0)
end

function SCHEMA:OnPlayerChangedTeam(ply, new, old)
    ply:SetRPName(ply:GetSavedRPName(), true)
end

function SCHEMA:PlayerShouldBreakLegs(ply, dmg)
    return not ply:IsTeamOTA()
end

function SCHEMA:PlayerShouldGetHungry(ply)
    return not ply:IsTeamOTA()
end

function SCHEMA:DoInventorySearch(searcher, searchee)
	if searcher:Team() == TEAM_CP then
		searcher:ForceSequence("spreadwall")
	end
end

function SCHEMA:EntityTakeDamage(ent, dmg)
    if not IsValid(ent) then
        return
    end

    if ent:IsPlayer() then
        if dmg:IsDamageType(DMG_CRUSH) then
            if not (IsValid(dmg:GetAttacker()) and dmg:GetAttacker():GetClass() == "gmod_sent_vehicle_fphysics_base") then
                return true
            end
        end

        if ent:Team() == TEAM_OTA and dmg:IsDamageType(DMG_ACID) then
            return true
        end
    end
end

local blacklisted = {
	["models/props_c17/oildrum001_explosive.mdl"] = true,
    ["models/props_c17/canister02a.mdl"] = true,
    ["models/props_junk/gascan001a.mdl"] = true,
    ["models/props_junk/propane_tank001a.mdl"] = true,
    ["models/props_explosive/explosive_butane_can02.mdl"] = true,
    ["models/props_explosive/explosive_butane_can.mdl"] = true,
}

function SCHEMA:PlayerSpawnProp(ply, model)
    if IsValid(ply) and not (ply:HasInventoryItem("item_buildingkit") or ply:IsAdmin() or ply:Team() == TEAM_OTA) then
        ply:Notify("You need a building kit to spawn props.")
        return false
    end
    
    if not ( GAMEMODE:PlayerSpawnProp(ply, model) ) then return false end
    return not blacklisted[model]
end

local painSounds = {
    Sound("vo/npc/male01/pain01.wav"),
    Sound("vo/npc/male01/pain02.wav"),
    Sound("vo/npc/male01/pain03.wav"),
    Sound("vo/npc/male01/pain04.wav"),
    Sound("vo/npc/male01/pain05.wav"),
    Sound("vo/npc/male01/pain06.wav"),
    Sound("vo/npc/male01/pain07.wav"),
    Sound("vo/npc/male01/pain08.wav"),
    Sound("vo/npc/male01/pain09.wav"),
}

local drownSounds = {
    Sound("player/pl_drown1.wav"),
    Sound("player/pl_drown2.wav"),
    Sound("player/pl_drown3.wav"),
}
function SCHEMA:PlayerHurt(ply, attacker, health, damage)
    if ( ( ply.impulseNextPain or 0 ) < CurTime() and health > 0) then
        local painSound = hook.Run("GetPlayerPainSound", ply) or painSounds[math.random(1, #painSounds)]

        if ( ply:IsCharacterFemale() and !painSound:find("female") ) then
            painSound = painSound:gsub("male", "female")
        end

        ply:EmitSound(painSound)

        ply.impulseNextPain = CurTime() + 1
    end
end

function SCHEMA:GetPlayerPainSound(ply)
    if ( ply:WaterLevel() >= 3 ) then
        return drownSounds[math.random(1, #drownSounds)]
    elseif ( ply:IsTeamOTA() ) then
        return ""
    elseif ( ply:IsTeamCP() ) then
        return "npc/metropolice/pain"..math.random(1, 4)..".wav"
	elseif ply:Team() == TEAM_GONOME then
		return "npc/zombie/zombie_pain"..math.random(1, 6)..".wav"
	elseif ply:Team() == TEAM_HAVANGER then
		return "npc/fast_zombie/fz_alert_close1.wav"
    elseif ( ply:IsTeamVort() ) then
        return table.Random({
            "vo/npc/vortigaunt/vortigese02.wav",
            "vo/npc/vortigaunt/vortigese03.wav",
            "vo/npc/vortigaunt/vortigese04.wav",
            "vo/npc/vortigaunt/vortigese05.wav",
            "vo/npc/vortigaunt/vortigese07.wav",
            "vo/npc/vortigaunt/vortigese08.wav",
            "vo/npc/vortigaunt/vortigese09.wav",
        })
    end
end

function SCHEMA:PlayerDeath(ply, victim, inflictor, attacker)
    local deathSound = hook.Run("GetPlayerDeathSound", ply)

    if ( deathSound and deathSound != false ) then
        deathSound = deathSound or deathSounds[math.random(1, #deathSounds)]

        if ( ply:IsCharacterFemale() and !deathSound:find("female") ) then
            deathSound = deathSound:gsub("male", "female")
        end

        timer.Simple(0, function()
            if IsValid(ply) then
                ply:EmitSound(deathSound)
            end
        end)
    end
end


function SCHEMA:GetPlayerDeathSound(ply)
    if ply:Team() == TEAM_OTA then
        return "npc/combine_soldier/die"..math.random(1, 3)..".wav"			
    elseif ply:Team() == TEAM_VORT then
        return "vo/npc/vortigaunt/vortigese08.wav"
	elseif ply:Team() == TEAM_GONOME then
		return "npc/zombie/zombie_die"..math.random(1, 3)..".wav"	
	elseif ply:Team() == TEAM_HAVANGER then
		return "npc/fast_zombie/wake1.wav"	
    elseif ply:Team() == TEAM_CP then
        return table.Random({
            "npc/metropolice/die1.wav",
            "npc/metropolice/die2.wav",
            "npc/metropolice/die3.wav",
            "npc/metropolice/die4.wav",
            "npc/metropolice/r_terminated.wav",			
        })
    end
end

impulse.NPCDrops = {
    ["npc_cscanner"] = {
        max = 1,
        chance = 0.5,  -- 50% chance to drop an item
        items = {
            "util_metalplate"
        }
    },
    ["npc_manhack"] = {
        max = 1,
        chance = 0.5,  -- 50% chance to drop an item
        items = {
            "util_metalplate"
        }
    }
}

function SCHEMA:OnNPCKilled(npc, attacker, inflictor)
    if not impulse.NPCDrops then
        return
    end

    local npcClass = npc:GetClass()
    local dropData = impulse.NPCDrops[npcClass]

    if not dropData then
        return
    end

    if math.random() <= dropData.chance then
        for i = 1, math.random(1, dropData.max) do
            local randomItem = dropData.items[math.random(1, #dropData.items)]
            impulse.Inventory.SpawnItem(randomItem, npc:GetPos() + Vector(0, 0, 40))
        end
    end
end

impulse.Config.ChanceDropping = {
    [TEAM_CP] = {
        [CLASS_OFC] = {
            {class = "util_cpvest"}
        },
        [CLASS_PTL] = { 
            {class = "util_cpvest"}
        },
        [CLASS_SV] = { 
            {class = "util_cpvest"}
        },
        [CLASS_RL] = {
            {class = "util_cpvest"}
        }
    },
}

hook.Add("DoPlayerDeath", "chanceDropSystem", function(ply, attacker, dmg)
    local teamDrops = impulse.Config.ChanceDropping[ply:Team()]

    if teamDrops then
        local classDrops = teamDrops[ply:GetTeamClass()] and teamDrops[ply:GetTeamClass()][ply:GetTeamRank()]
        if not classDrops then
            classDrops = teamDrops[ply:GetTeamClass()] or {}
        end

        for _, itm in ipairs(classDrops) do
            impulse.Inventory.SpawnItem(itm.class, ply:GetPos() + Vector(0, 0, 80))
        end
    end
end)

-- Ready-to-paste universal damage scaler
-- Works for players and NPCs

local playerGestures = {
    [HITGROUP_CHEST] = "flinchgutgest1",
    [HITGROUP_STOMACH] = "flinchgutgest1",
    [HITGROUP_LEFTARM] = "flinchlarmgest",
    [HITGROUP_RIGHTARM] = "flinchrarmgest",
    [HITGROUP_HEAD] = "flinchheadgest1",
    [HITGROUP_LEFTLEG] = "flinch_gesture",
    [HITGROUP_RIGHTLEG] = "flinch_gesture"
}

hook.Add("EntityTakeDamage", "UniversalScaleDamage", function(ent, dmginfo)
    if not IsValid(ent) or not dmginfo then return end
    if not ent:IsPlayer() then return end

    local team = ent:Team() or 0
	local ply = ent
    local hitgroup = ent:LastHitGroup() or HITGROUP_GENERIC

    -- Default = squishy
    local damageScale = 3.3

    -- OTA = heavy armor
    if team == TEAM_OTA then
        damageScale = 1

    -- CP = lighter armor
    elseif team == TEAM_CP then
        damageScale = 1.8
		
    elseif ply.HasRebelKevlarVest == true then
        damageScale = 1.8
    end

    dmginfo:ScaleDamage(damageScale)

    -- Hit reaction
    local gesture = playerGestures[hitgroup]
    if gesture then
        impulse.PlayGesture(ent, gesture)
    end

    -- OTA slowdown effect
    if team == TEAM_OTA then
        if not ent.SlowedDown then
            ent.DefaultRunSpeed = ent:GetRunSpeed()
            ent.SlowedDown = true
        end

        ent.LastHit = CurTime() + 2.5
        ent:SetRunSpeed(math.max(ent:GetRunSpeed() - 15, 50))
    end
end)

-- Think hook to reset player speed after being slowed
hook.Add("Think", "ResetPlayerSpeedAfterHit", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply.SlowedDown and ply.LastHit and CurTime() >= ply.LastHit then
            ply:SetRunSpeed(ply.DefaultRunSpeed)
            ply.SlowedDown = false
        end
    end
end)

hook.Add("InitPostEntity", "impulse.ItemCleaner.Init", function()
    if ( timer.Exists("impulseItemCleaner") ) then
        timer.Remove("impulseItemCleaner")
    end

    impulse.CreateItemCleanerTimer()
end)

function SCHEMA:PlayerUnRestrain(ply)
	ply:GiveInventoryItem("item_ziptie", 1, true)
end

local function AdjustDamageByTeam(player, baseDamage)
    local team = player:Team()
    if team == TEAM_OTA then
        return baseDamage * 9
    elseif team == TEAM_VORT then
        return baseDamage * 12
    elseif team == TEAM_CITIZEN or team == TEAM_CP or team == TEAM_REBEL then
        return baseDamage * 18
    else
        return baseDamage
    end
end

hook.Add("PlayerInitialSpawn", "impulseHooks.PlayerInitialSpawn", function(ply, player)
    local rankCol = impulse.Config.RankColours[ply:GetUserGroup()]
    
    if rankCol then
		ply:SetWeaponColor(Vector(rankCol.r / 255, rankCol.g / 255, rankCol.b / 255))
	end

    ply:AllowFlashlight(false)
	ply.SlowDownRatio = 1
end)

hook.Add("PlayerLoadout", "impulseHL2RP.PlayerLoadout.Setup", function(ply)
	local rankCol = impulse.Config.RankColours[ply:GetUserGroup()]
	
	if rankCol then
		ply:SetWeaponColor(Vector(rankCol.r / 255, rankCol.g / 255, rankCol.b / 255))
	end

    ply:AllowFlashlight(false)
	ply.SlowDownRatio = 1
end)

hook.Add("PlayerCanHearPlayersVoice", "impulseHL2RP.Combine.DistanceRadio", function(listen, talk)
    if (talk:Team() == TEAM_OTA) then
        if (listen:Team() == TEAM_OTA) then
            return true
        else
            return false
        end
    end
end)

local animationCooldown = 1
local lastAnimationTime = {}

hook.Add("PlayerUse", "DoorAnimationHook", function(ply, ent)
    if ent:IsDoor() then
        local currentTime = CurTime()
        
        if not lastAnimationTime[ply] or (currentTime - lastAnimationTime[ply]) >= animationCooldown then
            if ent:GetInternalVariable("m_eDoorState") == 0 then  -- Door is closed
                impulse.PlayGesture(ply, "g_drop_meleeweapon")
            else
                impulse.PlayGesture(ply, "g_drop_meleeweapon")
            end
            
            lastAnimationTime[ply] = currentTime
        end
    end
end)

hook.Add("PlayerPickupItem", "impulseHooks.PlayerPickupItem", function(ply, itemID)
    if (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_REBEL) then
		impulse.PlayGesture(ply, "pickup")
    	ply:EmitSound("physics/body/body_medium_impact_soft1.wav", 60, math.random(95, 110))
	elseif ply:Team() == TEAM_CP then
		impulse.PlayGesture(ply, "pickup")
    	ply:EmitSound("physics/body/body_medium_impact_soft1.wav", 60, math.random(95, 110))
	end
end)

file.CreateDir("impulse/"..engine.ActiveGamemode().."/whitelists")

hook.Add("PlayerLoadout", "whitelistCustomSystem", function(ply)
    if ( file.Exists("impulse/"..engine.ActiveGamemode().."/whitelists/"..ply:SteamID64()..".txt", "DATA") ) then
        ply.whitelists = impulse.data.Get("whitelists/"..ply:SteamID64(), {}, false, true)
    else
        ply.whitelists = {}
    end
end)

function meta:GiveWhitelist(id)
    self.whitelists[#self.whitelists + 1] = id
    
    impulse.data.Set("whitelists/"..self:SteamID64(), self.whitelists, false, true)
end

function meta:TakeWhitelist(id)
    for k, v in pairs(self.whitelists) do
        if ( v == id ) then
            table.remove(self.whitelists, k) 
        end
    end
    
    impulse.data.Set("whitelists/"..self:SteamID64(), self.whitelists, false, true)
end