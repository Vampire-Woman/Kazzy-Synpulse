AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

function ENT:Initialize()
	self.buttons = {}

	local position = self:GetPos()
	local f, r, u = self:GetForward(), self:GetRight(), self:GetUp()

	self.buttons[1] = position + f * 18 + r * -24.7 + u * 4

	self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	-- VM Item stocks
	self:SetStocks(util.TableToJSON({
		8
	}))

	self:SetActive(1)

	local physObj = self:GetPhysicsObject()
	if (IsValid(physObj)) then
		physObj:EnableMotion(false)
		physObj:Sleep()
	end
end

local itemLUT = {
	[1] = {
		item = "food_breenwater",
		niceName = ">B",
		price = 5,
		weight = 1,
	}
}

function ENT:Use(activator)
	if (self.nextUse or 0) > CurTime() then
		return
	end
	self.nextUse = CurTime() + 2

	if not IsValid(activator) then
		return
	end

	local button = self:getNearestButton(activator)
	if not button or not itemLUT[button] then
		return
	end


	local stocks = util.JSONToTable(self:GetStocks());

	if button and stocks and stocks[button] and stocks[button] > 0 then
		if activator:KeyDown(IN_WALK) then
			return
		else
			local item = itemLUT[button].item
			local niceName = itemLUT[button].niceName
			local price = itemLUT[button].price
			local weight = itemLUT[button].weight

			if not activator:CanAfford(price) then
				self:EmitSound("buttons/button2.wav")

				activator:Notify("You need " .. price .. " tokens to purchase this selection.")
				return
			end

			local plyInv = activator.InventoryWeight or 0
			if plyInv + weight > impulse.Config.InventoryMaxWeight then
				self:EmitSound("buttons/button8.wav")

				activator:Notify("You cannot carry anymore weight!")
				return
			end

			self:EmitSound("ambient/levels/labs/coinslot1.wav")

			stocks[button] = stocks[button] - 1
			if stocks[button] < 1 then
				self:EmitSound("buttons/button8.wav")
			end
			self:SetStocks(util.TableToJSON(stocks));

			activator:TakeMoney(price)
			activator:GiveInventoryItem(item)
			activator:Notify("Purchase of " .. niceName .. " for " .. price .. " tokens.")
		end
	end

	-- refill system for CWU
	if activator:Team() == TEAM_CITIZEN and activator:GetTeamClass() == CLASS_CWU_INDUSTRIAL and activator:KeyDown(IN_WALK) and activator:KeyDown(IN_USE) and stocks[button] then
		if stocks[button] > 0 then
			activator:Notify("This vending machine does not require a refill.")
			return
		end

		self:EmitSound("ambient/machines/combine_terminal_idle1.wav")
		activator:Notify("You have been paid 5 tokens for your refilling duties.")
		activator:GiveMoney(5)

		timer.Simple(1, function()
			if not IsValid(self) then
				return
			end

			stocks[button] = button == 1 and 10 or 5
			self:SetStocks(util.TableToJSON(stocks));
		end)
	end
end
