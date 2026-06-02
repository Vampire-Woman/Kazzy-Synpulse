net.Receive("OpenPlazaVGUI", function()
    local deyploymentWait = vgui.Create("dropshipwait")
    deyploymentWait.sector = 1
end)

net.Receive("UpdatePlazaQueue", function()
    impulse.dp.queue.plaza = net.ReadTable()
end)