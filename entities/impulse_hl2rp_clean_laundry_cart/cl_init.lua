include("shared.lua")

function ENT:Draw()
  self:DrawModel()

  local pos = self:LocalToWorld(self:OBBCenter())
  local ang = self:GetAngles()
end
