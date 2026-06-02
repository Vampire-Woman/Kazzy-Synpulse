AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Manufacturing Machine"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Industrial Tech"

ENT.Spawnable = true
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = false
ENT.PhysgunPickupDisabled = false

sound.Add({
	name = "machine_moving",
	volume = 1.0,
	sound = "ambient/levels/labs/machine_moving_loop4.wav"
})

sound.Add({
	name = "refill_sound",
	volume = 1.0,
	sound = "ambient/water/water_in_boat1.wav"
})

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "RawResource" )
	self:NetworkVar( "Bool", 1, "Manufacturing" )
	self:NetworkVar( "Int", 2, "FuelAmount" )
	self:NetworkVar( "Bool", 3, "Broken" )
	self:NetworkVar( "Bool", 4, "HasScrap" )
	self:NetworkVar( "Bool", 5, "FireActive" )
	self:NetworkVar( "Entity", 1, "PlayerUsing" )
end

function ENT:CreateProduct( pPlayer )
	if not SERVER then return end

	timer.Simple( 0.1, function()
		local eProduct = ents.Create( "ent_industrial_product" )
		local vPos = self:GetPos() + self:GetUp() * 16 + self:GetRight() * -25 + self:GetForward() * -80

		eProduct:SetPos( vPos )
		eProduct:Spawn()
		eProduct:Activate()
		
		local tPlayers = self.tParticipants
		if tPlayers then
			if not tPlayers[ pPlayer ] then
				tPlayers[ pPlayer ] = true
			end

			eProduct.tParticipants = tPlayers
		end

		self.tParticipants = {}
	end )

	self:SetRawResource( 0 )
end

function ENT:Initialize()
	if SERVER then
        self:SetModel("models/props_mining/elevator_winch_empty.mdl")
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetTrigger( true )

		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		self.tParticipants = {}
		self:SetFuelAmount( 100 )
		self:SetHasScrap( false )
	else
		self.NextSmoke = -1
		self.Emitter = ParticleEmitter( self:GetPos() )
		self.EmitterFinished = false
	end
end

function ENT:AddPlayer( pPlayer )
	self.tPlayers = self.tPlayers or {}

	if not self.tParticipants[ pPlayer ] then
		self.tParticipants[ pPlayer ] = true
	end
end

function ENT:AddPlayers( tPlayers )
	if not SERVER then return end

	for pParticipant, _ in pairs( tPlayers ) do
		if not self.tParticipants[ pParticipant ] then
			self.tParticipants[ pParticipant ] = true
		end
	end
end

local tAllowedEntities = {
	[ "ent_industrial_combine_resource" ] = {
		StartTouch = function( eEntity, eTarget )
			if eEntity:GetRawResource() >= 5 then return end

			eEntity:SetRawResource( eEntity:GetRawResource() + 1 )
			if eEntity:GetRawResource() >= 5 then
				eEntity:EmitSound( "buttons/button18.wav" )
			end

			if eTarget.tParticipants then
				eEntity:AddPlayers( eTarget.tParticipants )
			end

			eEntity:EmitSound( "foley/industrial/dump_resource_machine"..math.random(1,3)..".mp3" )

			SafeRemoveEntity( eTarget ) 
		end
	},
	[ "ent_industrial_fuel" ] = {
		StartTouch = function( eEntity, eTarget )
			local iCurrentFuel = eEntity:GetFuelAmount()
            local iNewFuelAmount = 100

            if eEntity:GetFuelAmount() < 100 then
                eEntity:SetFuelAmount( iNewFuelAmount )
                eEntity:EmitSound( "refill_sound" )
				timer.Simple( 2, function()
					eEntity:StopSound( "refill_sound" )
				end )

                if IsValid( eTarget.ent_owner ) then
                    eEntity:AddPlayer( eTarget.ent_owner )
                end

				if eTarget.tParticipants then
					eEntity:AddPlayers( eTarget.tParticipants )
				end

                SafeRemoveEntity( eTarget )
			end
		end
	},
	[ "ent_industrial_scrap" ] = {
		StartTouch = function( eEntity, eTarget )
			if eEntity:GetHasScrap() then return end

			eEntity:SetHasScrap( true )
			eEntity:EmitSound("foley/containers/metal_close_03.wav", 70, math.random( 90, 110 ) )
			SafeRemoveEntity(eTarget)
		end
	}
}

function ENT:StartTouch( eEntity )
	local tEntity = tAllowedEntities[ eEntity:GetClass() ]
	if not tEntity then return end

    timer.Simple( 0, function() 
        if not IsValid( eEntity ) or not IsValid( self ) then return end

		tEntity.StartTouch( self, eEntity )
    end )
end

function ENT:Explode()
    local explosion = ents.Create( "env_explosion" )
    explosion:SetPos( self:GetPos() )
    explosion:SetOwner( self )
    explosion:Spawn()
    explosion:SetKeyValue( "iMagnitude", "200" )
    explosion:Fire( "Explode", 0, 0 )
    explosion:EmitSound( "ambient/fire/gascan_ignite1.wav", 100, 100 )

    local fire = ents.Create( "env_fire" )
    fire:SetPos( self:GetPos() )
    fire:SetKeyValue( "health", "120" )
    fire:SetKeyValue( "firesize", "128" )
    fire:SetKeyValue( "fireattack", "1" )
    fire:SetKeyValue( "ignitionpoint", "0" )
    fire:SetKeyValue( "damagescale", "10.0" )
    fire:Spawn()
    fire:Activate()
    fire:Fire( "StartFire", "", 0 )
	self:Ignite( 120 )

	self:SetFireActive(true)

    fire:SetKeyValue( "OnHealthChanged", "self,StopSound,ambient/fire/fire_med_loop1.wav,0,-1" )

	timer.Simple( 120, function()
        if IsValid( self ) then
			self:SetFireActive(false)
			self:Extinguish()
		end
    end )

    self:CallOnRemove( "CleanupFireAndSound", function(ent)
        if IsValid( fire ) then
			fire:Remove()
        end
		self:SetFireActive(false)
    end )
end

function ENT:Think()
    if CLIENT then return end

    if self:GetManufacturing() then
        local eEnt = self:GetPlayerUsing()
        if eEnt and not IsValid( eEnt ) then
            self:SetManufacturing( false )
            self:StopSound( "machine_moving" )
            self:EmitSound( "ambient/levels/labs/machine_stop1.wav" )
        end
    end

    if self:GetBroken() and not self.HasCheckedForExplosion then -- possibility to explode and kill the nigger
        self.HasCheckedForExplosion = true
        if self:GetHasScrap() then
            self:Explode()
            self.HasExploded = true
        end
    end

    self:NextThink(CurTime() + 1)
    return true
end

function ENT:Use( pPlayer )
	if pPlayer:GetSyncVar(SYNC_ARRESTED) or self:GetManufacturing() or pPlayer._mrpAction then return end
	if ( self.iNextResourceCreation or 0 ) > CurTime() then return end

	if self:GetBroken() then
		if pPlayer:Team() == TEAM_WORKER then
			if self:GetHasScrap() then
				pPlayer:EmitSound("foley/inventory/choreo_foley_jacket" .. math.random(1, 3) .. ".wav", 65 )
				pPlayer:ForceSequence("d1_town05_daniels_kneel_entry", function()
					pPlayer:ForceSequence( "d1_town05_daniels_kneel_idle" )
				end )
				timer.Simple(5, function()
					pPlayer:Notify("This machine appears to be in disrepair due to a piece of maliciously placed scrap jamming it's internal mechanisms.", 8, 1)

					timer.Simple( 1, function()
						pPlayer:EmitSound("foley/inventory/choreo_foley_jacket" .. math.random(1, 3) .. ".wav", 65 )
						pPlayer:ForceSequence("roofidle1")
						timer.Simple(6, function()
							self:SetHasScrap( false )
							pPlayer:Notify("You have successfully removed the scrap jamming the machine's internal mechanisms.", 5, 1)
							self:EmitSound("foley/containers/metal_open_03.wav", 65, math.random( 90, 110 ) )

							self.iNextResourceCreation = CurTime() + 2
						end, {
							--ent = self,
							--ActionTimeRemainingText = "Removing...",
							--ActionColor = Monolith.Color.engineercore
						} )
					end )
				end, {
					--ent = self,
					--ActionTimeRemainingText = "Inspecting...",
					--ActionColor = Monolith.Color.engineercore
				} )
			else
				pPlayer:EmitSound("foley/inventory/choreo_foley_jacket" .. math.random(1, 3) .. ".wav", 65 )
				pPlayer:ForceSequence("d1_town05_daniels_kneel_entry", function()
					pPlayer:ForceSequence( "d1_town05_daniels_kneel_idle" )
				end )
				timer.Simple(5, function()
					pPlayer:Notify("This machine appears to be in disrepair due to regular wear and tear of it's components.")
					
					self.iNextResourceCreation = CurTime() + 2
				end, {
					--ent = self,
					--ActionTimeRemainingText = "Inspecting...",
					--ActionColor = Monolith.Color.engineercore
				} )
			end
		else
			pPlayer:Notify("This machine appears to be in a state of disrepair.")
		end
		self.iNextResourceCreation = CurTime() + 2
		return
	end

	if self:GetHasScrap() and pPlayer:Team() == TEAM_WORKER then
		pPlayer:EmitSound("foley/inventory/choreo_foley_jacket" .. math.random(1, 3) .. ".wav", 65 )
		pPlayer:ForceSequence("roofidle1")

		timer.Simple(6, function()
			self:SetHasScrap( false )
			pPlayer:Notify("You have successfully removed the scrap jamming the machine's internal mechanisms.", 5, 1)
			self:EmitSound("foley/containers/metal_open_03.wav", 65, math.random( 90, 110 ) )

			self.iNextResourceCreation = CurTime() + 2
		end, {
			--ent = self,
			--ActionTimeRemainingText = "Removing...",
			--ActionColor = Monolith.Color.engineercore
		} )
		return
	end

	if self:GetRawResource() < 5 then
		pPlayer:Notify("This machine requires Combine material in order to manufacture product." )

		self.iNextResourceCreation = CurTime() + 2
		return
	end

	if self:GetFuelAmount() <= 0 then
		self:EmitSound( "ambient/machines/sputter1.wav" )
		pPlayer:Notify( "This machine is currently out of fuel and must be refilled with an oil cannister from the rail yard." )

		self.iNextResourceCreation = CurTime() + 2
		return
	end

    -- Do not allow combine to create rations
	local bCivilWorker = pPlayer:Team() == TEAM_CITIZEN or pPlayer:Team() == TEAM_VORT
    if not bCivilWorker then
		pPlayer:Notify("This machine appears to be operational." )

		self.iNextResourceCreation = CurTime() + 2
		return
	end

	self:SetManufacturing( true )
	self:SetPlayerUsing( pPlayer )

	-- @TODO: Create a log here.

	if pPlayer:Team() == TEAM_VORT then
		pPlayer:ForceSequence("lab_partinstall")
	elseif pPlayer:Team() == TEAM_CITIZEN then
		pPlayer:ForceSequence("open_door_towards_left")
	else
		pPlayer:ForceSequence("open_door_towards_left")
	end

	timer.Simple (1, function()
		self:EmitSound( "machine_moving" )
		util.ScreenShake( pPlayer:GetPos(), 5, 5, 4, 62 )
	end )

	timer.Simple (25, function()
		self:StopSound( "machine_moving" )
		self:SetManufacturing( false )
		self:SetPlayerUsing( nil )

		local iEngineers = 0 for _, ply in ipairs(player.GetAll()) do if IsValid(ply) and ply:Team() == TEAM_WORKER then iEngineers = iEngineers + 1 end end
		if self:GetHasScrap() and iEngineers > 0 then
			self:EmitSound( "foley/industrial/mechanism_broken_" .. math.random( 1, 2 ) .. ".mp3" )
			self:SetBroken( true )
			self:SetRawResource( 0 )
			util.ScreenShake( pPlayer:GetPos(), 15, 15, 1, 62 )

			self.iNextResourceCreation = CurTime() + 2
			return
		end

		local iBreakChance = math.random( 1, 30 )
		if iBreakChance == 1 and iEngineers > 0 then
			self:EmitSound( "foley/industrial/mechanism_broken_" .. math.random( 1, 2 ) .. ".mp3" )
			self:SetBroken( true )
			self:SetRawResource( 0 )
			util.ScreenShake( pPlayer:GetPos(), 15, 15, 1, 62 )

			local iChanceForInjury = math.random( 1, 8 )
			if iChanceForInjury == 1 then
				pPlayer:TakeDamage( 45 )
				pPlayer:ViewPunch( Angle( 3, 0, 2 ) )
				pPlayer:Notify( L("helix.industrial.injuryMachine"), 8, 1 )
			end

			self.iNextResourceCreation = CurTime() + 2
			return
		end

		self:CreateProduct( pPlayer )

		local nNewFuelAmount = self:GetFuelAmount() - 10

		self:SetFuelAmount( nNewFuelAmount )
		if nNewFuelAmount <= 0 then
			self:EmitSound( "ambient/machines/sputter1.wav" )
		end

        self.iNextResourceCreation = CurTime() + 2

        self:EmitSound( "ambient/levels/labs/machine_stop1.wav" )
		util.ScreenShake( pPlayer:GetPos(), 5, 5, 0.5, 62 )
	end, {
		--ent = self,
		--ActionTimeRemainingText = L( "helix.industrial.manufacturing" ),
		--ActionColor = Monolith.Color.industrialworkforce
	}, function()
		if not self:GetManufacturing() then return end

		self:StopSound( "machine_moving" )
        self:SetManufacturing( false )
        self.iNextResourceCreation = CurTime() + 2
		return
	end )
end

if SERVER then return end

function ENT:DrawSmokeEffect()
	if not self:GetManufacturing() and IsValid( self.Emitter ) then
		self.Emitter:Finish()
	end

	if self:GetManufacturing() and self.NextSmoke < CurTime() then
		if not IsValid( self.Emitter ) then
			self.Emitter = ParticleEmitter( self:GetPos() )
		end

		self.Emitter:SetPos( self:GetPos() )
		self.NextSmoke = CurTime() + 1

		local iRandom = math.random( 1, 16 )
		local sSmokeMat = "particle/smokesprites_00" .. ( iRandom < 10 and "0" .. iRandom or iRandom )
		local oSmokePos = self:GetPos() + self:GetUp() * 55 + self:GetRight() * -48 + self:GetForward() * -80

		local oSmoke = self.Emitter:Add( sSmokeMat, oSmokePos )
		oSmoke:SetVelocity( self:GetVelocity() )
		oSmoke:SetDieTime( 30 )
		oSmoke:SetStartAlpha( 20 )
		oSmoke:SetEndAlpha( 0 )
		oSmoke:SetStartSize( math.Rand( 10, 16 ) )
		oSmoke:SetEndSize( 3 )
		oSmoke:SetGravity( Vector( 0, 0, 10 ) )
		oSmoke:SetColor( 230, 230, 230 )
		oSmoke:SetAirResistance( 100 )
	end
end

local mGlow = Material( "sprites/glow04_noz" )

function ENT:DrawOnlineEffects()
	if self:GetBroken() then return end

	local vFirstSprite = self:GetPos() + self:GetUp() * 16 + self:GetRight() * -46 + self:GetForward() * -64.5
	local vSecondSprite = self:GetPos() + self:GetUp() * 16 + self:GetRight() * -5 + self:GetForward() * -64.5

	render.SetMaterial( mGlow )

	local cColor = Monolith.Color.combinered
	if self:GetRawResource() >= 1 and self:GetRawResource() < 5 then
		cColor = Monolith.Color.combineyellow
	elseif self:GetRawResource() >= 5 then
		cColor = Monolith.Color.combinegreen
	end

	render.DrawSprite( vFirstSprite, 5.5, 5.5, cColor )
	render.DrawSprite( vSecondSprite, 5.5, 5.5, cColor )
end

function ENT:Draw()
	self:DrawModel()
end

hook.Add( "Monolith._Kernel.PostFullLoad", "AddIndustrialMachineCallbacks", function()
    Monolith._Kernel:AddCachedEntityDrawCallback( "PostDrawTranslucentRenderables", "ent_industrial_manufacture_machine", 340000, function( eEntity )
		eEntity:DrawSmokeEffect()
		eEntity:DrawOnlineEffects()
    end )
end )