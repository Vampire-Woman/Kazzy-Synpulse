AddCSLuaFile()

DEFINE_BASECLASS("base_anim")

ENT.PrintName = "Music Radio"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Citizen Tech"

ENT.Spawnable = true
ENT.AdminOnly = true

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = false

local tRadioTypes = {
    [ ">B Radio" ] = {
        Model = "models/hls/alyxports/radioset_1.mdl",
        Songs = {
            { "music_radio/breen/breen_radio_1.mp3", time = 215 },
            { "music_radio/breen/breen_radio_2.mp3", time = 62 },
            { "music_radio/breen/breen_radio_3.mp3", time = 91 },
            { "music_radio/breen/breen_radio_4.mp3", time = 144 },
            { "music_radio/breen/breen_radio_5.mp3", time = 174 },
            { "music_radio/breen/breen_radio_6.mp3", time = 136 },
            { "music_radio/breen/breen_radio_7.mp3", time = 136 },
            { "music_radio/breen/breen_radio_8.mp3", time = 243 },
            { "music_radio/breen/breen_radio_9.mp3", time = 189 },
            { "music_radio/breen/breen_radio_10.mp3", time = 198 },
            { "music_radio/breen/breen_radio_11.mp3", time = 135 },
            { "music_radio/breen/breen_radio_12.mp3", time = 222 },
            { "music_radio/breen/breen_radio_13.mp3", time = 117 }
        }
    },
    [ "Counterculture Radio" ] = {
        Model = "models/hls/alyxports/radioset_1.mdl",
        Songs = {
            { "music_radio/counterculture/cc_song_1.mp3", time = 146 },
            { "music_radio/counterculture/cc_song_2.mp3", time = 147 },
            { "music_radio/counterculture/cc_song_3.mp3", time = 3 },
            { "music_radio/counterculture/cc_song_4.mp3", time = 245 },
            { "music_radio/counterculture/cc_song_5.mp3", time = 175 },
            { "music_radio/counterculture/cc_song_6.mp3", time = 164 },
            { "music_radio/counterculture/cc_song_7.mp3", time = 248 },
            { "music_radio/counterculture/cc_song_8.mp3", time = 158 },
            { "music_radio/counterculture/cc_song_9.mp3", time = 150 },
            { "music_radio/counterculture/cc_song_10.mp3", time = 241 },
            { "music_radio/counterculture/cc_song_11.mp3", time = 199 },
            { "music_radio/counterculture/cc_song_12.mp3", time = 56 },
            { "music_radio/counterculture/cc_song_13.mp3", time = 179 },
            { "music_radio/counterculture/cc_song_14.mp3", time = 13 },
            { "music_radio/counterculture/cc_song_15.mp3", time = 172 },
            { "music_radio/counterculture/cc_song_16.mp3", time = 199 },
            { "music_radio/counterculture/cc_song_17.mp3", time = 119 },
            { "music_radio/counterculture/cc_song_18.mp3", time = 109 },
            { "music_radio/counterculture/cc_song_19.mp3", time = 3 },
            { "music_radio/counterculture/cc_song_20.mp3", time = 162 },
            { "music_radio/counterculture/cc_song_21.mp3", time = 161 },
            { "music_radio/counterculture/cc_song_22.mp3", time = 144 }
        }
    }
}

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/hls/alyxports/radioset_1.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
		self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
		self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
		self:SetUseType( SIMPLE_USE )
    	self:GetPhysicsObject():EnableMotion( false )

        self:SetRadioEnabled( false )

        self.tRadioData = tRadioTypes[ "Counterculture Radio" ]
	end
end

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "RadioType" )
    self:NetworkVar( "Bool", 0, "RadioEnabled" )
end

if SERVER then
    function ENT:Use( pPlayer )
        if not IsValid( pPlayer ) then return end
        if pPlayer:GetPos():DistToSqr( self:GetPos() ) > 5200 then return end
        if ( self.iNextRadioUse or 0 ) > CurTime() then return end

        if pPlayer:Team() == TEAM_VORT then
            pPlayer:ForceSequence("nectar_give")
        elseif pPlayer:Team() == TEAM_CITIZEN then
            pPlayer:ForceSequence("Open_door_away")
        else
            pPlayer:ForceSequence("harassfront2")
        end
    
        if self:GetRadioEnabled() then
            timer.Simple ( 1, function()
                if not IsValid( self ) then return end

                self:ResetAudio()

                self:SetRadioEnabled( false )
                self:EmitSound( "television/tv_off.mp3", 66 )
            end )
        else
            timer.Simple ( 1, function()
                if not IsValid( self ) then return end

                self:SetRadioEnabled( true )
                self:EmitSound( "music_radio/radio_on.mp3", 66 )

                self:PlaySong()
            end )
        end

        self.iNextRadioUse = CurTime() + 2.8
    end

    function ENT:PlaySong()
        if not self.tRadioData then return end

        local tSong = self.tRadioData.Songs[ math.random( #self.tRadioData.Songs ) ]
        local sSong = tSong[ 1 ]
        self:EmitSound( sSong, 66 )
        self.sCurrentSong = sSong

        timer.Create( "NextSongShuffle" .. self:EntIndex(), tSong.time, 1, function()
            self:PlaySong()
        end )
    end

    function ENT:SetRadio( sRadioType )
        self:ResetAudio()

        local tRadio = tRadioTypes[ sRadioType ]
        if not tRadio then return end

        self:SetModel( tRadio.Model )

        self:PhysicsInit( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:SetSolid( SOLID_VPHYSICS )
        self:GetPhysicsObject():Wake()

        self:SetUseType( SIMPLE_USE )

        self:SetRadioType( sRadioType )
        self:SetRadioEnabled( false )

        self.tRadioData = tRadio
    end


    function ENT:ResetAudio()
        timer.Remove( "NextSongShuffle" .. self:EntIndex() )

        if self.sCurrentSong and self.sCurrentSong ~= "" then
            self:StopSound( self.sCurrentSong )
        end
    end

    function ENT:OnRemove()
        self:ResetAudio()
    end
end