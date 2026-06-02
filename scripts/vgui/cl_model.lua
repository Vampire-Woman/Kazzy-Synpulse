local PANEL = {}

local otaModels = {
    ["models/combine_soldier.mdl"] = true,
    ["models/combine_soldier_prisonguard.mdl"] = true,
    ["models/combine_super_soldier.mdl"] = true
}

function PANEL:Init()
    self.OldSetModel = self.SetModel
    self.SetModel = function(self, model, skin)
        self:OldSetModel(model)

        local ent = self.Entity
        if not IsValid(ent) then return end

        if skin then
            ent:SetSkin(skin)
        end

        -- Select the idle sequence like before
        local sequence = ent:SelectWeightedSequence(ACT_IDLE)

        if otaModels[model] or (sequence <= 0) then
            sequence = ent:LookupSequence("idle_unarmed")
        end

        if sequence > 0 then
            ent:ResetSequence(sequence)
        else
            -- Fallback: find any idle or fly animation
            local found = false
            for k, v in ipairs(ent:GetSequenceList()) do
                if (v:lower():find("idle") or v:lower():find("fly")) and v ~= "idlenoise" then
                    ent:ResetSequence(v)
                    found = true
                    break
                end
            end
            if not found then
                ent:ResetSequence(4) -- Default to seq 4 as last resort
            end
        end

        ent:SetCycle(0)          -- Start animation at frame 0
        ent:SetPlaybackRate(0)   -- Freeze animation (pause playback)
        ent:SetIK(false)

        ent.AutomaticFrameAdvance = false -- Disable auto animation running

        -- Set the angle here so it looks slightly right as in your screenshot
        ent:SetAngles(Angle(0, 0, 0))
    end
end

function PANEL:LayoutEntity(ent)
    -- No animation running or advancing
    -- Just keep the pose frozen

    if not IsValid(ent) then return end

    -- Ensure angles stay consistent
    ent:SetAngles(Angle(0, 25, 0))

    -- Prevent animation from advancing every frame
    ent:SetCycle(0)
    ent:SetPlaybackRate(0)
end

vgui.Register("impulseModelPanel", PANEL, "DModelPanel")