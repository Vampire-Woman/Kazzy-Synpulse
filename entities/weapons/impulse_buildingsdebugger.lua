if( CLIENT ) then
	SWEP.PrintName = "Buildings Plugin Debugger"
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	SWEP.CLMode = 0
end
SWEP.HoldType = "fists"

SWEP.Category = "impulse"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Delay			= 1
SWEP.Primary.Recoil			= 0	
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0 	
SWEP.Primary.ClipSize		= -1	
SWEP.Primary.DefaultClip	= -1	
SWEP.Primary.Automatic   	= false	
SWEP.Primary.Ammo         	= "none"
SWEP.IsAlwaysRaised = true
 
SWEP.Secondary.Delay		= 0.9
SWEP.Secondary.Recoil		= 0
SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic   	= false
SWEP.Secondary.Ammo         = "none"
SWEP.NextGo = 0

if SERVER then
	function SWEP:Deploy()
		if not self.Owner:IsSuperAdmin() then
			self.Owner:StripWeapon("impulse_buildingsdebugger")
		end
	end
end

function SWEP:DrawHUD()
	local w, h = ScrW(), ScrH()
	-- Draw a debugging notice
	draw.SimpleText("BUILDINGS DEBUG TOOL", "BudgetLabel", w/2, 25, Color(0,255,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	local invalidTerminals = 0
	local terminals = 0
	for _, trm in ipairs(ents.FindByClass("impulse_hl2rp_property_index")) do
		local v = trm:GetPos():ToScreen()
		if (true) then
			
			-- Draw info
			draw.SimpleText("[" .. tostring(trm:EntIndex()) .. "] TERMINAL: " .. trm:GetTag(), "BudgetLabel", v.x, v.y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			local tag = trm:GetTag()
			if (not tag) or (tag == "") then
				draw.SimpleText("ERR: NO TAG", "BudgetLabel", v.x, v.y + 15, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				invalidTerminals = invalidTerminals + 1
			elseif not impulse.Buildings.Data[tag] then
				draw.SimpleText("ERR: INVALID TAG", "BudgetLabel", v.x, v.y + 15, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				invalidTerminals = invalidTerminals + 1
			else
				draw.SimpleText("VALID", "BudgetLabel", v.x, v.y + 15, Color(0,255,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
	if invalidTerminals > 0 then
		draw.SimpleText(invalidTerminals .. " INVALID TERMINALS", "BudgetLabel", w/2, 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
end

if CLIENT then
	function SWEP:PrimaryAttack()
		local tr = self.Owner:GetEyeTrace()

		if IsValid(tr.Entity) then
			local ent = tr.Entity
			if ent:GetClass() == "impulse_hl2rp_property_index" then
				Derma_StringRequest("Vanguard: Buildings", "Enter a new tag", nil, function(txt)
					RunConsoleCommand("impulse_save_keyvalue", "Tag", txt)
					RunConsoleCommand("impulse_save_saveall")
					RunConsoleCommand("impulse_save_reload")
				end)
			end
		end
	end
end