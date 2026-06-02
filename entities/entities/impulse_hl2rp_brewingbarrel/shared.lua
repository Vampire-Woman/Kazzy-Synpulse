ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Alcohol Brewer"
ENT.Author = "Bloodmore"
ENT.Category = "Suppressed: Citizen Tech"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.HUDName = "Alcohol Brewer"
ENT.HUDDesc = "Used to brew alcohol."

ENT.Ingredients = {
    {
        name = "Yeast",
        isPresent = false
    },
    {
        name = "Spices",
        isPresent = false
    }
}

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "StartTime")
    self:NetworkVar("Int", 1, "EndTime")
    if SERVER then
        self:SetStartTime(0)
        self:SetEndTime(0)
    end
end