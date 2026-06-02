if SERVER then
    util.AddNetworkString("impulseWeldEffectsStart")
    util.AddNetworkString("impulseWeldEffects")

    net.Receive("impulseWeldEffectsStart", function(len, ply)
        local kill = net.ReadBool()

        if kill == true then
            WeldEffects(ply, true)
        else
            WeldEffects(ply)
        end
    end)

    function WeldEffects(ply, kill)
        net.Start("impulseWeldEffects")
        net.WriteEntity(ply)
        net.WriteBool(kill == true)
        net.Broadcast()
    end
end

if CLIENT then
    function WeldEffects(ply, kill)
        net.Start("impulseWeldEffectsStart")
        net.WriteBool(kill == true)
        net.SendToServer()
    end

    net.Receive("impulseWeldEffects", function()
        local welder = net.ReadEntity()
        local kill = net.ReadBool()

        if kill == true then
            EndWeld(welder)
        else
            StartWeld(welder)
        end
    end)

    function StartWeld(welder)
        welder.ActiveWelder = true
        welder.CutSound = CreateSound(welder, "ambient/energy/electric_loop.wav")
        welder.CutSound2 = CreateSound(welder, "ambient/machines/electric_machine.wav")
        welder.CutSound3 = CreateSound(welder, "ambient/levels/outland/ol11_welding_loop.wav")
        welder.CutSound4 = CreateSound(welder, "ambient/machines/combine_shield_loop3.wav")
    end

    function EndWeld(welder)
        for k,v in pairs(player.GetAll()) do
            if v == welder then
                if v.ActiveWelder then
                    v.ActiveWelder = nil
                    if v.CutSound:IsPlaying() then v.CutSound:Stop() end
                    if v.CutSound2:IsPlaying() then v.CutSound2:Stop() end
                    if v.CutSound3:IsPlaying() then v.CutSound3:Stop() end
                    if v.CutSound4:IsPlaying() then v.CutSound4:Stop() end
                    break
                end
            end
        end
    end

    hook.Add("Think", "impulseClientWeldEffects", function()
        for k,v in pairs(player.GetAll()) do
            if not v.ActiveWelder then continue end

            if (not v:GetActiveWeapon()) or (not IsValid(v:GetActiveWeapon())) or (v:GetActiveWeapon():GetClass() != "weapon_cmb_welding_gun") then
                continue
            end

            local traceData = {
                start = v:EyePos(),
                endpos = v:EyePos() + v:GetAimVector() * 64,
                filter = v
            }

            local cutTrace = util.TraceLine(traceData)

            if not v.CutSound4:IsPlaying() then
                v.CutSound4:PlayEx(0, 255)
            end

            if cutTrace.Hit and cutTrace.Entity:GetClass() == "prop_physics" then
                if not v.CutSound:IsPlaying() then v.CutSound:PlayEx(0.2, 125) end
                if not v.CutSound2:IsPlaying() then v.CutSound2:PlayEx(0.2, 125) end
                if not v.CutSound3:IsPlaying() then v.CutSound3:PlayEx(1, 100) end

                local pos = cutTrace.HitPos + cutTrace.HitNormal
                local emitter = ParticleEmitter(pos)

                local part = emitter:Add("Effects/yellowflare", pos)
                if part then
                    part:SetDieTime(5)
                    part:SetStartAlpha(255)
                    part:SetEndAlpha(0)
                    part:SetStartSize(math.Rand(1,3))
                    part:SetEndSize(0)
                    part:SetGravity(Vector(0, 0, -250))
                    part:SetVelocity(VectorRand() * math.random(100,250))
                end

                local par2 = emitter:Add("effects/combinemuzzle1", pos)
                if par2 then
                    par2:SetDieTime(0.2)
                    par2:SetStartAlpha(255)
                    par2:SetEndAlpha(0)
                    par2:SetStartSize(math.Rand(0,10))
                    par2:SetEndSize(0)
                end

                emitter:Finish()
            else
                if v.CutSound:IsPlaying() then v.CutSound:Stop() end
                if v.CutSound2:IsPlaying() then v.CutSound2:Stop() end
                if v.CutSound3:IsPlaying() then v.CutSound3:Stop() end
            end
        end
    end)
end