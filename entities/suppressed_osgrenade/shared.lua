ENT.Base			= "base_gmodentity" 
ENT.Type			= "anim"
ENT.PrintName		= "OS Grenade"
ENT.Author			= "Bloodmore"
ENT.Purpose			= "Boom."
ENT.Instructions	= "Boom."
ENT.Category 		= "impulse"

ENT.Spawnable = true
ENT.AdminOnly = true

local material = Material( "sprites/glow04_noz" )
local redCol = Color(255,0,0)

function ENT:Draw()

	cam.Start3D() -- Start the 3D function so we can draw onto the screen.
		render.SetMaterial( material )
		render.DrawSprite(self:GetPos(), 32, 32, redCol)
	cam.End3D()

end