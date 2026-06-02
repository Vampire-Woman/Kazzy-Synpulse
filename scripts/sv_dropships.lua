util.AddNetworkString("JoinPlazaWait")
util.AddNetworkString("LeavePlazaWait")
util.AddNetworkString("UpdatePlazaWait")
util.AddNetworkString("DeploymentWarning")

function SCHEMA:SaveimpulseDeployers()
    local data = {}
    for _, v in ipairs(ents.FindByClass("impulse_hl2rp_dropshipdeployterminal")) do
        data[#data + 1] = {v:GetPos(), v:GetAngles()}
    end
    impulse.data.Set("impulseDeployers", data)
end

function SCHEMA:LoadimpulseDeployers()
    for _, v in ipairs(impulse.data.Get("impulseDeployers") or {}) do
        local impulseDeployers = ents.Create("impulse_hl2rp_dropshipdeployterminal")
        impulseDeployers:SetPos(v[1])
        impulseDeployers:SetAngles(v[2])
        impulseDeployers:Spawn()
    end
end

function SCHEMA:SaveData()
    self:SaveimpulseDeployers()
end

function SCHEMA:LoadData()
    self:LoadimpulseDeployers()
end