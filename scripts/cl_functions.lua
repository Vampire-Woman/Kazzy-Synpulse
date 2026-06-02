local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_ClearStencil = render.ClearStencil
local Material = Material
local impulse = impulse
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local surface_DrawTexturedRect = surface.DrawTexturedRect
local ScrW = ScrW
local ScrH = ScrH
local surface_DrawTexturedRectUV = surface.DrawTexturedRectUV
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local Vector = Vector
local math_rad = math.rad
local Matrix = Matrix
local math_cos = math.cos
local math_sin = math.sin
local cam_PushModelMatrix = cam.PushModelMatrix
local surface_SetFont = surface.SetFont
local surface_SetTextColor = surface.SetTextColor
local surface_SetTextPos = surface.SetTextPos
local surface_DrawText = surface.DrawText
local cam_PopModelMatrix = cam.PopModelMatrix
local draw_SimpleText = draw.SimpleText
local table_insert = table.insert
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local LocalPlayer = LocalPlayer
local IsValid = IsValid
local Color = Color
local team_GetColor = team.GetColor
local team_GetName = team.GetName
local hook_Add = hook.Add
local ScreenScale = ScreenScale
local surface_CreateFont = surface.CreateFont

function impulse.ZeroNumber(number, length)
    local amount = math.max(0, length - string.len(number))
    return string.rep("0", amount)..tostring(number)
end

function impulse.TextSize(text, font)
    surface.SetFont(font)
    return surface.GetTextSize(text)
end

// impulse utility functions are garbage, helix is WAYYYYYYY better...
// https://github.com/NebulousCloud/helix/blob/master/gamemode/core/sh_util.lua

impulse.blurRenderQueue = {}

local ADJUST_SOUND = SoundDuration("npc/metropolice/pain1.wav") > 0 and "" or "../../hl2/sound/"

--- Emits sounds one after the other from an entity.
-- @realm shared
-- @entity entity Entity to play sounds from
-- @tab sounds Sound paths to play
-- @number delay[opt=0] How long to wait before starting to play the sounds
-- @number spacing[opt=0.1] How long to wait between playing each sound
-- @number volume[opt=75] The sound level of each sound
-- @number pitch[opt=100] Pitch percentage of each sound
-- @treturn number How long the entire sequence of sounds will take to play
function impulse.EmitQueuedSounds(entity, sounds, delay, spacing, volume, pitch)
    -- Let there be a delay before any sound is played.
    delay = delay or 0
    spacing = spacing or 0.1

    -- Loop through all of the sounds.
    for _, v in ipairs(sounds) do
        local postSet, preSet = 0, 0

        -- Determine if this sound has special time offsets.
        if (istable(v)) then
            postSet, preSet = v[2] or 0, v[3] or 0
            v = v[1]
        end

        -- Get the length of the sound.
        local length = SoundDuration(ADJUST_SOUND..v)
        -- If the sound has a pause before it is played, add it here.
        delay = delay + preSet

        -- Have the sound play in the future.
        timer.Simple(delay, function()
            -- Check if the entity still exists and play the sound.
            if (IsValid(entity)) then
                entity:EmitSound(v, volume, pitch)
            end
        end)

        -- Add the delay for the next sound.
        delay = delay + length + postSet + spacing
    end

    -- Return how long it took for the whole thing.
    return delay
end

--- Wraps text so it does not pass a certain width. This function will try and break lines between words if it can,
-- otherwise it will break a word if it's too long.
-- @realm client
-- @string text Text to wrap
-- @number maxWidth Maximum allowed width in pixels
-- @string[opt="Impulse-ChatSmall"] font Font to use for the text
function impulse.WrapText(text, maxWidth, font)
    font = font or "Impulse-ChatSmall"
    surface.SetFont(font)

    local words = string.Explode("%s", text, true)
    local lines = {}
    local line = ""
    local lineWidth = 0 -- luacheck: ignore 231

    -- we don't need to calculate wrapping if we're under the max width
    if (surface.GetTextSize(text) <= maxWidth) then
        return {text}
    end

    for i = 1, #words do
        local word = words[i]
        local wordWidth = surface.GetTextSize(word)

        -- this word is very long so we have to split it by character
        if (wordWidth > maxWidth) then
            local newWidth

            for i2 = 1, word:utf8len() do
                local character = word[i2]
                newWidth = surface.GetTextSize(line .. character)

                -- if current line + next character is too wide, we'll shove the next character onto the next line
                if (newWidth > maxWidth) then
                    lines[#lines + 1] = line
                    line = ""
                end

                line = line .. character
            end

            lineWidth = newWidth
            continue
        end

        local space = (i == 1) and "" or " "
        local newLine = line .. space .. word
        local newWidth = surface.GetTextSize(newLine)

        if (newWidth > maxWidth) then
            -- adding this word will bring us over the max width
            lines[#lines + 1] = line

            line = word
            lineWidth = wordWidth
        else
            -- otherwise we tack on the new word and continue
            line = newLine
            lineWidth = newWidth
        end
    end

    if (line != "") then
        lines[#lines + 1] = line
    end

    return lines
end

impulse.Draw = {}

local blur = Material("pp/blurscreen")
local surface = surface

--- Blurs the content underneath the given panel. This will fall back to a simple darkened rectangle if the player has
-- blurring disabled.
-- @realm client
-- @tparam panel panel Panel to draw the blur for
-- @number[opt=5] amount Intensity of the blur. This should be kept between 0 and 10 for performance reasons
-- @number[opt=0.2] passes Quality of the blur. This should be kept as default
-- @number[opt=255] alpha Opacity of the blur
-- @usage function PANEL:Paint(width, height)
-- 	impulse.Draw.Blur(self)
-- end
function impulse.Draw.Blur(panel, amount, passes, alpha)
    amount = amount or 5

    if not ( impulse.GetSetting("perf_blur") ) then
        surface.SetDrawColor(50, 50, 50, alpha or (amount * 20))
        surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())
    else
        surface.SetMaterial(blur)
        surface.SetDrawColor(255, 255, 255, alpha or 255)

        local x, y = panel:LocalToScreen(0, 0)

        for i = -(passes or 0.2), 1, 0.2 do
            -- Do things to the blur material to make it blurry.
            blur:SetFloat("$blur", i * amount)
            blur:Recompute()

            -- Draw the blur material over the screen.
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(x * -1, y * -1, ScrW(), scrH)
        end
    end
end

--- Draws a blurred rectangle with the given position and bounds. This shouldn't be used for panels, see `impulse.Draw.Blur`
-- instead.
-- @realm client
-- @number x X-position of the rectangle
-- @number y Y-position of the rectangle
-- @number width Width of the rectangle
-- @number height Height of the rectangle
-- @number[opt=5] amount Intensity of the blur. This should be kept between 0 and 10 for performance reasons
-- @number[opt=0.2] passes Quality of the blur. This should be kept as default
-- @number[opt=255] alpha Opacity of the blur
-- @usage hook.Add("HUDPaint", "MyHUDPaint", function()
-- 	impulse.DrawBlurAt(0, 0, ScrW(), scrH)
-- end)

function impulse.PlayGesture(ply, gesture, slot)
    if not ( ply ) then
        ply = LocalPlayer()
    end

    if not ( slot ) then
        slot = GESTURE_SLOT_CUSTOM
    end

    ply:AddVCDSequenceToGestureSlot(slot, ply:LookupSequence(gesture), 0, 1)
end

function meta:IsInGame()
    if ( IsValid(impulse.splash) or IsValid(impulse.MainMenu) ) then
        return false
    end

    return true
end

function impulse.Draw.BlurAt(x, y, width, height, amount, passes, alpha)
    amount = amount or 5

    if not ( impulse.GetSetting("perf_blur") ) then
        surface.SetDrawColor(30, 30, 30, amount * 20)
        surface.DrawRect(x, y, width, height)
    else
        surface.SetMaterial(blur)
        surface.SetDrawColor(255, 255, 255, alpha or 255)

        local scrW, scrH = ScrW(), scrH
        local x2, y2 = x / scrW, y / scrH
        local w2, h2 = (x + width) / scrW, (y + height) / scrH

        for i = -(passes or 0.2), 1, 0.2 do
            blur:SetFloat("$blur", i * amount)
            blur:Recompute()

            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRectUV(x, y, width, height, x2, y2, w2, h2)
        end
    end
end

--- Pushes a 3D2D blur to be rendered in the world. The draw function will be called next frame in the
-- `PostDrawOpaqueRenderables` hook.
-- @realm client
-- @func drawFunc Function to call when it needs to be drawn
function impulse.Draw.PushBlur(drawFunc)
    impulse.blurRenderQueue[#impulse.blurRenderQueue + 1] = drawFunc
end

function impulse.Draw.OutlinedRect(x, y, width, height, bgCol, outCol, thickness)
    surface.SetDrawColor(bgCol)
    surface.DrawRect(x, y, width, height)

    surface.SetDrawColor(outCol)
    surface.DrawOutlinedRect(x, y, width, height, thickness)
end

function impulse.Draw.SkewedText(txt, font, col, x, y, textalign, za, ya, scale)
    local pos = Vector(x, y )
    scale = scale or 1
    ya = ya or 0
    za = za or 0

    local yAng = math.rad(ya)

    local m = Matrix()
    local yMat = Matrix()
    yMat:SetField(1, 1, math.cos(yAng))
    yMat:SetField(1, 3, math.sin(yAng))
    yMat:SetField(2, 2, scale)
    yMat:SetField(1, 3, -math.sin(yAng))
    yMat:SetField(3, 3, math.cos(yAng))

    local zAng = math.rad(za)

    local zMat = Matrix()
    zMat:SetField(1, 1, math.cos(zAng))
    zMat:SetField(2, 1, -math.sin(zAng))
    zMat:SetField(2, 1, math.sin(zAng))
    zMat:SetField(2, 2, math.cos(zAng))
    zMat:SetField(3, 3, scale)

    local xMat = Matrix()
    xMat:SetField(1, 1, scale)

    m:Translate(pos)
        m:Mul(xMat)
        m:Mul(yMat)
        m:Mul(zMat)
    m:Translate(-pos)
    
    cam.PushModelMatrix(m)
        draw.DrawText(txt, font, x, y, col or color_white, textalign or TEXT_ALIGN_LEFT)
    cam.PopModelMatrix()    
end

function impulse.Draw.Texture(material, color, x, y, w, h, ...)
    surface.SetDrawColor(color or color_white)
    surface.SetMaterial(Material(material, ...))
    surface.DrawTexturedRect(x, y, w, h)
end

function impulse.Draw.BlurText(text, font, x, y, color, xAlign, yAlign)
    draw.SimpleText(text, font, x, y, color, xAlign, yAlign or 0)
    draw.SimpleText(text, font .. "-Blurred", x, y, color, xAlign, yAlign or 0)
end

function meta:IsTeamCP()
    return self:Team() == TEAM_CP
end

function meta:IsTeamOTA()
    return self:Team() == TEAM_OTA
end

function meta:IsCombine()
    return self:IsTeamCP() or self:IsTeamOTA()
end

function meta:IsTeamVort()
    return self:Team() == TEAM_VORT
end

function meta:GetHunger()
    return self:GetSyncVar(SYNC_HUNGER, 100)
end