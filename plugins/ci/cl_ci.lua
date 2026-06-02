impulse.ci = impulse.ci or {}

local colors = {
    ["white"] = Color(200, 200, 200),
    ["blue"] = Color(100, 160, 250),
    ["cyan"] = Color(0, 200, 200),
    ["yellow"] = Color(200, 200, 0),
    ["red"] = Color(250, 50, 50),
    ["orange"] = Color(250, 100, 0),
    ["green"] = Color(100, 250, 100),
}

net.Receive("impulseCitadelCombineTerminalOpen", function()
    local ent = net.ReadEntity()

    if not ( LocalPlayer():IsCP() ) then
        return
    end

    if not ( IsValid(ent) and ent:GetClass() == "impulse_hl2rp_terminal" ) then
        return
    end

    local combineterminal = vgui.Create("impulseCombineTerminal")
    combineterminal.entity = ent
end)

function impulse.ci.DrawCombineBox(x, y, width, height, bIcon, bBlur)
    if ( bBlur ) then
        impulse.Draw.BlurAt(x, y, width, height, 5)
    end

    surface.SetDrawColor(Color(0, 50, 50, 100))
    surface.DrawRect(x, y, width, height)

    surface.SetDrawColor(Color(0, 100, 100, 50))
    surface.SetMaterial(Material("impulse_citadel/terminal.png"))
    surface.DrawTexturedRect(x, y, width, height)

    surface.SetDrawColor(color_white)
    surface.DrawOutlinedRect(x, y, width, height, 2)

    if ( bIcon ) then
        impulse.Draw.Texture("impulse_citadel/logo_cmb.png", Color(0, 255, 255), width - height + x + 10, y + height / 2 - (height - 20) / 2, height - 20, height - 20, "smooth mips")
    end
end

function impulse.ci.DrawCombineLine(x, y, x2, y2, color)
    surface.SetDrawColor(color)
    surface.DrawLine(x, y, x + x2, y2)
    surface.DrawLine(x, y + 2, x + x2, y2 + 2)
    surface.DrawLine(x, y + 4, x + x2, y2 + 4)
end

function impulse.ci.DrawCombineLineVertical(x, y, x2, y2, color)
    surface.SetDrawColor(color)
    surface.DrawLine(x, y, x + x2, y2)
    surface.DrawLine(x + 2, y, x + x2 + 2, y2)
    surface.DrawLine(x + 4, y, x + x2 + 4, y2)
end

net.Receive("impulseCitadelDatafileSync", function()
    local data = net.ReadString()
    
    LocalPlayer().dataFile = data
end)