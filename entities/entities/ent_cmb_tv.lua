AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Combine Television"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Citizen Tech"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = false

ENT.IsItem = true
ENT.OwnerOnlyPickUp = true
ENT.WalkOnlyPickUp = true

local tPrograms = {
    [ 1 ] = {
        Skin = 5,
        Sound = { "television/tv_humanscience1.mp3", time = 62 }
    },
    [ 2 ] = {
        Skin = 5,
        Sound = { "television/tv_combineforsafety1.mp3", time = 116 }
    },
    [ 3 ] = {
        Skin = 6,
        Sound = { "television/tv_reportthevort1.mp3", time = 68 }
    },
    [ 4 ] = {
        Skin = 7,
        Sound = { "television/tv_breencast1.mp3", time = 214 }
    },
    [ 5 ] = {
        Skin = 7,
        Sound = { "television/tv_breencast2.mp3", time = 90 }
    },
    [ 6 ] = {
        Skin = 8,
        Sound = { "television/tv_juggler.mp3", time = 47 }
    }
}

local tIntermissions = {
    [ 1 ] = {
        Skin = 1,
        Sound = { "ambient/levels/citadel/datatransrandom01.wav", time = 10 }
    },
    [ 2 ] = {
        Skin = 2,
        Sound = { "ambient/levels/citadel/datatransrandom01.wav", time = 10 }
    },
    [ 3 ] = {
        Skin = 3,
        Sound = { "ambient/levels/citadel/datatransrandom01.wav", time = 10 }
    }
}

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/hls/alyxports/television_1.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )   
		self:SetSolid( SOLID_VPHYSICS )         
		self:SetUseType( SIMPLE_USE )
    	self:GetPhysicsObject():EnableMotion( false )
        self:SetSkin( 0 )

        self:SetTVEnabled( false )
	end
end

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "TVEnabled" )
end

if SERVER then
    function ENT:Use( pPlayer )
        if not IsValid( pPlayer ) then return end
        if pPlayer:GetPos():DistToSqr( self:GetPos() ) > 10000 then return end
        if ( self.iNextTVUse or 0 ) > CurTime() then return end

		if pPlayer:Team() == TEAM_VORT then
			pPlayer:ForceSequence("lab_partinstall")
		elseif pPlayer:Team() == TEAM_CITIZEN then
			pPlayer:ForceSequence("open_door_towards_left")
		else
			pPlayer:ForceSequence("harassfront1")
		end
    
        if self:GetTVEnabled() then
            timer.Simple ( 1, function()
                if not IsValid( self ) then return end

                self:ResetAudio()
                self:SetSkin( 0 ) -- Disable the TV.

                self:SetTVEnabled( false )
                self:EmitSound( "television/tv_off.mp3", 66 )
            end )
        else
            timer.Simple ( 1, function()
                if not IsValid( self ) then return end

                self:SetTVEnabled( true )
                self:EmitSound( "television/tv_on.mp3", 66 )

                self:PlayProgram( true )
            end )
        end

        self.iNextTVUse = CurTime() + 2.8
    end

    function ENT:PlayProgram( bIntermission )
        local tSound = bIntermission and tIntermissions[ math.random( #tIntermissions ) ] or tPrograms[ math.random( #tPrograms ) ]
        local sSound = tSound.Sound[ 1 ]
        local iSkin = tSound.Skin

        if not bIntermission then
            bIntermission = true
        else
            bIntermission = false
        end

        self:SetSkin( iSkin )
        self:EmitSound( sSound, 70 )
        self.sCurrentSound = sSound

        timer.Create( "NextTVProgram" .. self:EntIndex(), tSound.Sound.time, 1, function()
            self:PlayProgram( bIntermission ) -- Shuffle and play another program.
        end )
    end

    function ENT:ResetAudio()
        timer.Remove( "NextTVProgram" .. self:EntIndex() )

        if self.sCurrentSound and self.sCurrentSound ~= "" then
            self:StopSound( self.sCurrentSound )
        end
    end

    function ENT:OnRemove()
        self:ResetAudio()
    end
end