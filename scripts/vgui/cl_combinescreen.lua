-- ===============================
-- Fonts
-- ===============================

surface.CreateFont("cmb_title", {
    font = "BoxedRoundLight",
    size = 22,
    weight = 400
})

surface.CreateFont("cmb_option", {
    font = "BoxedRoundLight",
    size = 14,
    weight = 400
})

local function PlayRandomClick()
    surface.PlaySound( "combine_tech/combine_tech_click_0" .. math.random( 1, 5 ) .. ".mp3" )
end

-- ===============================
-- PANEL
-- ===============================

local PANEL = {}

function PANEL:Init()
    self:SetSize(903, 571)
    self:Center()
    self:SetTitle("")
    self:SetSkin("combineSkin")
    self:ShowCloseButton(false)
    self:SetDraggable(false)
    self:MakePopup()

    self.currentPageElements = {}
    self.startupFinished = false

    self:CreateStartup()
end

-- ===============================
-- Prevent frame background from painting until startup finishes
-- ===============================

function PANEL:Paint(w, h)
    if not self.startupFinished then
        return -- fully transparent
    end

    derma.SkinHook("Paint", "Frame", self, w, h)
end

-- ===============================
-- STARTUP SEQUENCE
-- ===============================

function PANEL:CreateStartup()

    self.logoAlpha = 0

    self.startupPanel = vgui.Create("DPanel", self)
    self.startupPanel:Dock(FILL)

    self.startupPanel.Paint = function(s, w, h)
        local mat = Material("icons/player_factions/faction_combine.png")

        surface.SetDrawColor(35, 214, 248, self.logoAlpha)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(w/2 - 128, h/2 - 128, 256, 256)
    end

    -- Fade in logo using Think (no timers needed)
    self.startupPanel.Think = function()
        if self.logoAlpha < 255 then
            self.logoAlpha = math.Clamp(self.logoAlpha + FrameTime() * 255 * 2, 0, 255)
        end
    end

    -- Boot delay
    timer.Simple(2.3, function()
        if not IsValid(self) then return end

        self.startupFinished = true

        if IsValid(self.startupPanel) then
            self.startupPanel:Remove()
        end
		
		self:ShowCloseButton(true)
        self:CreateHomePage()
    end)
end

-- ===============================
-- Utility
-- ===============================

function PANEL:ClearPage()
    for _, v in ipairs(self.currentPageElements) do
        if IsValid(v) then v:Remove() end
    end
    self.currentPageElements = {}
end

-- ===============================
-- Vertical Back Bar (Left)
-- ===============================

function PANEL:CreateBackBar(callback)
    local backBar = vgui.Create("DButton", self)
    backBar:SetPos(0, 0)
    backBar:SetSize(10, self:GetTall())
    backBar:SetText("")
    backBar:SetCursor("hand")

    backBar.Paint = function(s, w, h)
        surface.SetDrawColor(35, 214, 248, s:IsHovered() and 255 or 180)
        surface.DrawRect(0, 0, w, h)
    end

    backBar.DoClick = function()
        PlayRandomClick()
        if callback then callback() end
    end

    table.insert(self.currentPageElements, backBar)
end

-- ===============================
-- HOME PAGE
-- ===============================

function PANEL:CreateHomePage()
    self:ClearPage()

    local title = vgui.Create("DLabel", self)
    title:SetText(":: Combine Mainframe Access Command Module ::")
    title:SetFont("cmb_title")
    title:SizeToContents()
    title:SetTextColor(Color(35,214,248))
    title:SetPos(231, 126)
    table.insert(self.currentPageElements, title)

    local options = {
        "Persons of Interest",
        "Conscript Index",
        "Team Index",
        "Civic Registrar",
        "Unit Database",
        "Security Feed",
        "Block Occupants",
		"Combine Network"
    }

    local barWidth = 445
    local barHeight = 32
    local spacing = 38
    local startY = 155
    local centerX = self:GetWide()/2 - barWidth/2

    for i, text in ipairs(options) do
        local btn = vgui.Create("DButton", self)
        btn:SetPos(centerX, startY + (i - 1) * spacing)
        btn:SetSize(barWidth, barHeight)
        btn:SetText("")
        btn:SetCursor("hand")

        btn.Paint = function(s, w, h)
            surface.SetDrawColor(0, 0, 0, 175, s:IsHovered() and 120 or 80)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(0,0,0, 2)
            surface.DrawOutlinedRect(0, 0, w, h)

            draw.SimpleText(
                ":: " .. text .. " ::",
                "cmb_option",
                w/2,
                h/2,
                Color(35,214,248),
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER
            )
        end

		btn.DoClick = function()
			PlayRandomClick()

			if text == "Civic Registrar" then
				self:OpenRegistrar()
			elseif text == "Team Index" then
				self:OpenTeamIndex()
			elseif text == "Security Feed" then
				self:OpenSecurityFeed()
			elseif text == "Unit Database" then
				self:OpenUnitDatabase()
			elseif text == "Combine Network" then
				self:OpenCombineGoogle()
			else
				self:OpenDummyPage(text)
			end
		end

        table.insert(self.currentPageElements, btn)
    end
end

-- ===============================
-- Dummy Sub Page
-- ===============================

function PANEL:OpenDummyPage(name)
    self:ClearPage()

    local title = vgui.Create("DLabel", self)
    title:SetText(":: " .. name .. " ::")
    title:SetFont("cmb_title")
    title:SizeToContents()
    title:SetTextColor(Color(35,214,248))
    title:SetPos(self:GetWide()/2 - title:GetWide()/2, 100)
    table.insert(self.currentPageElements, title)

    local status = vgui.Create("DLabel", self)
    status:SetText("ACCESSING DATABASE...")
    status:SetFont("cmb_option")
    status:SizeToContents()
    status:SetTextColor(Color(35,214,248))
    status:SetPos(self:GetWide()/2 - status:GetWide()/2, 160)
    table.insert(self.currentPageElements, status)

    self:CreateBackBar(function()
        self:CreateHomePage()
    end)
end

-- test page --

function PANEL:OpenCombineGoogle()
    self:ClearPage()

    -- Title
    local title = vgui.Create("DLabel", self)
    title:SetText(":: Combine Network ::")
    title:SetFont("cmb_title")
    title:SizeToContents()
    title:SetTextColor(Color(35,214,248))
    title:SetPos(self:GetWide()/2 - title:GetWide()/2, 40)
    table.insert(self.currentPageElements, title)

    -- Browser panel
    local browser = vgui.Create("DHTML", self)
    browser:SetPos(120, 80)
    browser:SetSize(660, 420)

    -- Try loading Google (may break, expected)
    browser:OpenURL("https://www.google.com")

    table.insert(self.currentPageElements, browser)

    -- Back bar
    self:CreateBackBar(function()
        self:CreateHomePage()
    end)
end

-- ===============================
-- Civic Registrar (Player List / Mugshot View)
-- ===============================
function PANEL:OpenRegistrar()
    self:ClearPage()

    -------------------------------------------------
    -- TITLE
    -------------------------------------------------
    local title = vgui.Create("DLabel", self)
    title:SetText(":: Civic Registrar ::")
    title:SetFont("cmb_title")
    title:SizeToContents()
    title:SetTextColor(Color(35,214,248))
    title:SetPos(self:GetWide()/2 - title:GetWide()/2, 60)
    table.insert(self.currentPageElements, title)

    -------------------------------------------------
    -- SEARCH BAR
    -------------------------------------------------
    local searchBar = vgui.Create("DTextEntry", self)
    searchBar:SetPos(150, 85)
    searchBar:SetSize(600, 30)
    searchBar:SetFont("cmb_option")
    searchBar:SetPlaceholderText("Search citizen name or CID...")
    table.insert(self.currentPageElements, searchBar)

    searchBar.Paint = function(s, w, h)
        surface.SetDrawColor(0,0,0,180)
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(35,214,248,40)
        surface.DrawOutlinedRect(0,0,w,h)

        s:DrawTextEntryText(
            Color(35,214,248),
            Color(35,214,248),
            Color(35,214,248)
        )
    end

    -------------------------------------------------
    -- SCROLL PANEL
    -------------------------------------------------
    local scroll = vgui.Create("DScrollPanel", self)
    scroll:SetPos(150, 120)
    scroll:SetSize(600, 350)
    table.insert(self.currentPageElements, scroll)

    -------------------------------------------------
    -- NAME TABLES (PASTE YOUR FULL LISTS HERE)
    -------------------------------------------------
	local firstNames = {
		"Aaron",
		"Abel",
		"Adam",
		"Adrian",
		"Ahmad",
		"Aiden",
		"Alan",
		"Albert",
		"Alejandro",
		"Alex",
		"Alyx",
		"Alexander",
		"Alexei",
		"Ali",
		"Amir",
		"Amy",		
		"Andre",
		"Andrew",
		"Andro",
		"Angel",
		"Ant",
		"Anthony",
		"Antonio",
		"Ari",
		"Arjun",
		"Asher",
		"Austin",
		"Avi",
		"Ayden",
		"Aiden",
		"Beau",
		"Benjamin",
		"Bennett",
		"Blake",
		"Brandon",
		"Braylen",
		"Bruce",
		"Brigitte",		
		"Caleb",
		"Cameron",
		"Carl",
		"Carla",	
		"Carlos",
		"Carlisle",
		"Carter",
		"Charles",
		"Chase",
		"Christopher",
		"Cole",
		"Connor",
		"Christian",
		"Cristian",
		"Dale",
		"Damian",
		"Damon",
		"Daniel",
		"Darnell",
		"David",
		"DeAndre",
		"Donald",
		"Demetrius",
		"Deshawn",
		"Devone",
		"Dexter",
		"Diego",
		"Dominic",
		"Dylan",
		"Eli",
		"Elias",
		"Elijah",
		"Emiliano",
		"Enzo",
		"Eric",
		"Esteban",
		"Exegol",
		"Ethan",
		"Evan",
		"Ezra",
		"Felix",
		"Fernando",
		"Francisco",
		"Frank",
		"Gabriel",
		"Gavin",
		"George",
		"Gervonta",
		"Gideon",
		"Gustavo",
		"Hank",
		"Harvey",
		"Hector",
		"Henry",
		"Hiroshima",
		"Hudson",
		"Hunter",
		"Hayley",	
		"Ian",
		"Ibrahim",
		"Idris",
		"Isaac",
		"Isaiah",
		"Israel",	
		"Ivan",
		"Jack",
		"Jacob",
		"Jayden",
		"James",
		"Javier",
		"Jayden",
		"Jaylen",
		"Jeremiah",
		"Jerome",
		"Jerry",
		"Jeffrey",		
		"Jesse",
		"Jimmy",
		"Joaquin",
		"Jonah",
		"Jose",
		"Joseph",
		"Josh",
		"Julian",
		"June",
		"Jun",
		"Junior",
		"Kai",
		"Katie",	
		"Kenneth",
		"Keshawn",
		"Kevin",
		"Kilanti",
		"Laura",
		"Leon",
		"Levi",
		"Liam",
		"Logan",
		"Lucas",
		"Luis",
		"Marcus",
		"Mark",
		"Marshal",
		"Mason",
		"Mattteo",
		"Matteo",
		"Mateo",
		"Maurice",
		"Max",
		"Micah",
		"Michael",
		"Mike",
		"Miles",
		"Mohammad",
		"Moshe",
		"Musa",
		"Nathan",
		"Nicolas",
		"Nikolai",
		"Nikolas",
		"Niklaus",
		"Noah",
		"Nolan",
		"Norman",
		"Oscar",
		"Owen",
		"Parker",
		"Patrick",
		"Paul",	
		"Peter",
		"Rafael",
		"Reuben",
		"Ricardo",
		"Roman",
		"Rowan",
		"Rory",	
		"Rudolph",
		"Ryan",
		"Samuel",
		"Santiago",
		"Saul",
		"Sean",
		"Sebastian",
		"Sheldon",
		"Silas",
		"Simon",
		"Stan",
		"Stanley",
		"Stefan",	
		"Theo",
		"Tom",
		"Thomas",
		"Tomas",
		"Tony",
		"Tyler",
		"Vex",
		"Walter",
		"Wesley",
		"William",
		"Wyatt",
		"Xavier",
		"Youssef",
	}

	local lastNames = {
		"Trump",
		"Capricorn",
		"Afton",
		"Ali",
		"Allen",
		"Bailey",
		"Baker",
		"Bateman",
		"Bell",
		"Boniface",
		"Bennett",
		"Brooks",
		"Brown",
		"Burn",
		"Campbell",
		"Carter",
		"Carlisle",	
		"Clark",
		"Coleman",
		"Collins",
		"Cooper",
		"Cox",
		"Cruz",
		"Davenport",
		"Davis",
		"Delgado",
		"Edwards",
		"Elliot",
		"Ellis",
		"Epstein",		
		"Evans",
		"Ford",
		"Franklin",
		"Fring",
		"Fang",
		"Fitzgerald",
		"Goldberg",
		"Gonzalez",
		"Goodman",
		"Green",
		"Greenberg",
		"Griffin",
		"Hall",
		"Harper",
		"Hill",
		"Howard",
		"Jackson",
		"Jefferson",
		"Jenkins",
		"Johnson",
		"King",
		"Kleiner",
		"Lee",
		"Levy",
		"Lewis",
		"Long",
		"Short",
		"Little",
		"Marshall",
		"Martin",
		"McGill",
		"Miller",
		"Mitchell",
		"Mikaelson",	
		"Monroe",
		"Moore",
		"Murphy",
		"Okafor",
		"Ortiz",
		"Owens",
		"Parker",
		"Powell",
		"Pond",	
		"Price",
		"Richards",
		"Robins",
		"Roberts",
		"Richardson",
		"Robinson",
		"Robertson",
		"Roosevelt",
		"Rosen",
		"Rosenberg",
		"Ross",
		"Rothschild",
		"Rubio",
		"Russell",
		"Salem",
		"Salvatore",	
		"Savage",
		"Scott",
		"Silverman",
		"Simpson",
		"Smith",
		"Snow",
		"Sullivan",
		"Taylor",
		"Thomas",
		"Thompson",
		"Turner",
		"Underwood",
		"Lockwood",
		"Vanderbilt",
		"Vandervoort",
		"Vance",	
		"Vaughan",
		"Vega",
		"Walker",
		"Ward",
		"Warren",
		"Washington",
		"Wayne",
		"Weiss",
		"Wexler",
		"White",
		"Williams",
		"Wilson",
		"Wright",
		"Young",
	}

    -------------------------------------------------
    -- BUILD DATASET ONCE
    -------------------------------------------------
    local citizens = {}

    for i = 1, 2000 do
        citizens[i] = {
            name = table.Random(firstNames) .. " " .. table.Random(lastNames),
            cid = math.random(10000, 99999),
            city = math.random(8, 17),
			pts = math.random(0, 333)
        }
    end

    local citizenRows = {}

    -------------------------------------------------
    -- POPULATE FUNCTION
    -------------------------------------------------
    local function PopulateCitizens(filter)

        scroll:Clear()
        citizenRows = {}

        filter = string.lower(filter or "")

        for _, citizen in ipairs(citizens) do

            local matches =
                filter == "" or
                string.find(string.lower(citizen.name), filter, 1, true) or
                string.find(tostring(citizen.cid), filter, 1, true)

            if matches then

                local citizenName = citizen.name
                local cid = citizen.cid
                local city = citizen.city
				local pts = citizen.pts

                local row = vgui.Create("DButton", scroll)
                row:Dock(TOP)
                row:DockMargin(0,0,0,5)
                row:SetTall(40)
                row:SetText("")
                row:SetCursor("hand")

                row.Paint = function(s, w, h)
                    surface.SetDrawColor(0,0,0,180)
                    surface.DrawRect(0,0,w,h)

                    surface.SetDrawColor(35,214,248,40)
                    surface.DrawOutlinedRect(0,0,w,h)

                    draw.SimpleText(
                        "SUBJECT: " .. citizenName,
                        "cmb_option",
                        10,
                        h/2,
                        Color(35,214,248),
                        TEXT_ALIGN_LEFT,
                        TEXT_ALIGN_CENTER
                    )

                    draw.SimpleText(
                        "CID: " .. cid,
                        "cmb_option",
                        500,
                        h/2,
                        Color(35,214,248),
                        TEXT_ALIGN_LEFT,
                        TEXT_ALIGN_CENTER
                    )
                end

                -------------------------------------------------
                -- CLICK (FULL DETAIL PANEL INSIDE SAME FUNCTION)
                -------------------------------------------------
                row.DoClick = function()

                    PlayRandomClick()

                    -- clear list
                    for _, r in ipairs(citizenRows) do
                        if IsValid(r) then r:Remove() end
                    end

                    -------------------------------------------------
                    -- DETAIL PANEL
                    -------------------------------------------------
                    local panel = vgui.Create("DPanel", self)
                    panel:SetPos(150, 120)
                    panel:SetSize(600, 350)

                    panel.Paint = function(s, w, h)
                        surface.SetDrawColor(0,0,0,180)
                        surface.DrawRect(0,0,w,h)

                        surface.SetDrawColor(35,214,248,40)
                        surface.DrawOutlinedRect(0,0,w,h)
                    end

                    table.insert(self.currentPageElements, panel)
					
					local outline = vgui.Create("DPanel", panel)
					outline:SetPos(5, 60)
					outline:SetSize(205, 205)
					outline.Paint = function(s, w, h)
						surface.SetDrawColor(35,214,248,150)
						surface.DrawOutlinedRect(0,0,w,h)
					end
					table.insert(self.currentPageElements, outline)

					-------------------------------------------------
					-- MODEL
					-------------------------------------------------
					local modelView = vgui.Create("DModelPanel", panel)
					modelView:SetSize(256,256)
					modelView:SetPos(-27,08)
					modelView:SetFOV(32)
					modelView:SetCamPos(Vector(0,50,64))
					modelView:SetLookAt(Vector(0,0,64))
					modelView:SetAnimated(false)
					modelView:SetMouseInputEnabled(false)
					modelView.LayoutEntity = function() end

					-- Female override list (ONLY these names use female model)
					local femaleNames = {
						["Amy"] = true,
						["Brigitte"] = true,
						["Carla"] = true,
						["Hayley"] = true,
						["Katie"] = true,
						["Laura"] = true
					}

					-- Extract first name from "First Last"
					local firstName = string.Explode(" ", citizenName)[1]

					-- Choose model
					if femaleNames[firstName] then
						modelView:SetModel("models/Humans/Group01/Female_01.mdl")
					else
						modelView:SetModel("models/Humans/Group01/male_09.mdl")
					end

					modelView.Entity:SetAngles(Angle(0,90,0))

					table.insert(self.currentPageElements, modelView)

                    -------------------------------------------------
                    -- INFO PANEL
                    -------------------------------------------------
                    local infoScroll = vgui.Create("DScrollPanel", panel)
                    infoScroll:SetPos(280,10)
                    infoScroll:SetSize(310,330)
                    table.insert(self.currentPageElements, infoScroll)

                    local nameLabel = vgui.Create("DLabel", infoScroll)
                    nameLabel:SetFont("cmb_title")
                    nameLabel:SetText("SUBJECT: " .. citizenName)
                    nameLabel:SetTextColor(Color(35,214,248))
                    nameLabel:SetPos(0,0)
                    nameLabel:SizeToContents()

                    local cidLabel = vgui.Create("DLabel", infoScroll)
                    cidLabel:SetFont("cmb_option")
                    cidLabel:SetText("CID: " .. cid)
                    cidLabel:SetTextColor(Color(35,214,248))
                    cidLabel:SetPos(0,27)
                    cidLabel:SizeToContents()

                    local cityLabel = vgui.Create("DLabel", infoScroll)
                    cityLabel:SetFont("cmb_option")
                    cityLabel:SetText("CITY: " .. city)
                    cityLabel:SetTextColor(Color(35,214,248))
                    cityLabel:SetPos(0,40)
                    cityLabel:SizeToContents()
					
					local pointsLabel = vgui.Create("DLabel", infoScroll)
                    pointsLabel:SetFont("cmb_option")
                    pointsLabel:SetText("CIVIC POINTS: " .. pts)
                    pointsLabel:SetTextColor(Color(35,214,248))
                    pointsLabel:SetPos(0,53)
                    pointsLabel:SizeToContents()				

                    -------------------------------------------------
                    -- BACK BUTTON
                    -------------------------------------------------
                    local backBtn = vgui.Create("DButton", panel)
                    backBtn:SetSize(100,30)
                    backBtn:SetPos(panel:GetWide()/2 - 50, panel:GetTall() - 40)
                    backBtn:SetText("BACK")
                    backBtn:SetFont("cmb_option")
                    backBtn:SetTextColor(Color(35,214,248))

                    backBtn.Paint = function(s,w,h)
                        surface.SetDrawColor(0,0,0,175)
                        surface.DrawRect(0,0,w,h)

                        surface.SetDrawColor(35,214,248,80)
                        surface.DrawOutlinedRect(0,0,w,h)
                    end

                    backBtn.DoClick = function()
                        PlayRandomClick()
                        self:OpenRegistrar()
                    end

                    table.insert(self.currentPageElements, backBtn)
                end

                table.insert(citizenRows, row)
            end
        end
    end

    -------------------------------------------------
    -- SEARCH HOOK (DEBOUNCED)
    -------------------------------------------------
    searchBar.OnValueChange = function(s)
        timer.Remove("RegistrarSearch")

        timer.Create("RegistrarSearch", 0.15, 1, function()
            if not IsValid(s) then return end
            PopulateCitizens(s:GetValue())
        end)
    end

    -------------------------------------------------
    -- INITIAL LOAD
    -------------------------------------------------
    PopulateCitizens()

    -------------------------------------------------
    -- BACK BAR
    -------------------------------------------------
    self:CreateBackBar(function()
        self:CreateHomePage()
    end)
end
-- ===============================
-- Team Index (Combine Only)
-- ===============================
function PANEL:OpenTeamIndex()
    self:ClearPage()

    -- Title
    local title = vgui.Create("DLabel", self)
    title:SetText(":: Team Index ::")
    title:SetFont("cmb_title")
    title:SizeToContents()
    title:SetTextColor(Color(35,214,248))
    title:SetPos(self:GetWide()/2 - title:GetWide()/2, 60)
    table.insert(self.currentPageElements, title)

    -- Scroll Panel
    local scroll = vgui.Create("DScrollPanel", self)
    scroll:SetPos(150, 120)
    scroll:SetSize(600, 350)
    table.insert(self.currentPageElements, scroll)

    local playerRows = {}

    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() ~= TEAM_CP and ply:Team() ~= TEAM_OTA then continue end

        local row = vgui.Create("DButton", scroll)
        row:Dock(TOP)
        row:DockMargin(0,0,0,5)
        row:SetTall(40)
        row:SetText("")
        row:SetCursor("hand")

        local sid64 = ply:SteamID64()
        local cid = string.sub(sid64, -5)
        local sid32 = ply:SteamID()
        local cid2 = string.sub(sid32, -9)

        row.Paint = function(s, w, h)
            surface.SetDrawColor(0,0,0,180)
            surface.DrawRect(0,0,w,h)

            surface.SetDrawColor(35,214,248,40)
            surface.DrawOutlinedRect(0,0,w,h)

            draw.SimpleText(
                "UNIT: " .. ply:Nick(),
                "cmb_option",
                10,
                h/2,
                Color(35,214,248),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER
            )

            draw.SimpleText(
                "CMB-" .. cid2,
                "cmb_option",
                500,
                h/2,
                Color(35,214,248),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER
            )
        end

        row.DoClick = function()
            PlayRandomClick()

            -- Remove list
            for _, r in ipairs(playerRows) do
                if IsValid(r) then r:Remove() end
            end

            -- Main panel
            local panel = vgui.Create("DPanel", self)
            panel:SetPos(150, 120)
            panel:SetSize(600, 350)
            panel.Paint = function(s, w, h)
                surface.SetDrawColor(0,0,0,180)
                surface.DrawRect(0,0,w,h)
                surface.SetDrawColor(35,214,248,40)
                surface.DrawOutlinedRect(0,0,w,h)
            end
            table.insert(self.currentPageElements, panel)

            -- Model
            local modelView = vgui.Create("DModelPanel", panel)
            modelView:SetSize(256,256)
            modelView:SetPos(-27,10)
            modelView:SetFOV(32)
            modelView:SetCamPos(Vector(0,50,64))
            modelView:SetLookAt(Vector(0,0,64))
            modelView:SetAnimated(false)
            modelView:SetMouseInputEnabled(false)
            modelView.LayoutEntity = function() end
            modelView:SetModel(ply:GetModel())

            for i = 0, ply:GetNumBodyGroups()-1 do
                modelView.Entity:SetBodygroup(i, ply:GetBodygroup(i))
            end

            modelView.Entity:SetSkin(ply:GetSkin())
            modelView.Entity:SetAngles(Angle(0,90,0))

            table.insert(self.currentPageElements, modelView)

            -- Outline
            local outline = vgui.Create("DPanel", panel)
            outline:SetPos(5, 60)
            outline:SetSize(205, 205)
            outline.Paint = function(s, w, h)
                surface.SetDrawColor(35,214,248,150)
                surface.DrawOutlinedRect(0,0,w,h)
            end
            table.insert(self.currentPageElements, outline)

            -- Info panel
            local infoScroll = vgui.Create("DScrollPanel", panel)
            infoScroll:SetPos(280, 10)
            infoScroll:SetSize(310, 330)
            table.insert(self.currentPageElements, infoScroll)

            local sbar = infoScroll:GetVBar()
            sbar.Paint = function() end
            sbar.btnUp.Paint = function() end
            sbar.btnDown.Paint = function() end
            sbar.btnGrip.Paint = function() end

            local nameLabel = vgui.Create("DLabel", infoScroll)
            nameLabel:SetFont("cmb_title")
            nameLabel:SetText(ply:Nick())
            nameLabel:SetTextColor(Color(35,214,248))
            nameLabel:SetPos(0, 0)
            nameLabel:SizeToContents()

            local infoText =
                "\nDivision: " .. team.GetName(ply:Team()) ..
                "\nCID: " .. cid ..
                "\nCMB: " .. cid2

            local detail = vgui.Create("DLabel", infoScroll)
            detail:SetFont("cmb_option")
            detail:SetTextColor(Color(35,214,248))
            detail:SetPos(0, nameLabel:GetTall() + 13)
            detail:SetText(infoText)
            detail:SizeToContents()

            -- Back button
            local backBtn = vgui.Create("DButton", panel)
            backBtn:SetSize(100,30)
            backBtn:SetPos(panel:GetWide()/2 - 50, panel:GetTall() - 40)
            backBtn:SetText("BACK")
            backBtn:SetFont("cmb_option")
            backBtn:SetTextColor(Color(35,214,248))
            backBtn.Paint = function(s,w,h)
                surface.SetDrawColor(0,0,0,175)
                surface.DrawRect(0,0,w,h)
                surface.SetDrawColor(35,214,248,80)
                surface.DrawOutlinedRect(0,0,w,h)
            end
            backBtn.DoClick = function()
                PlayRandomClick()
                self:OpenTeamIndex()
            end
            table.insert(self.currentPageElements, backBtn)
        end

        table.insert(playerRows, row)
    end

    for _, r in ipairs(playerRows) do
        table.insert(self.currentPageElements, r)
    end

    -- Back bar
    self:CreateBackBar(function()
        self:CreateHomePage()
    end)
end

-- ===============================
-- Unit Database (Fake Infinite List)
-- ===============================
function PANEL:OpenUnitDatabase()
    self:ClearPage()

    -- Title
    local title = vgui.Create("DLabel", self)
    title:SetText(":: Unit Database ::")
    title:SetFont("cmb_title")
    title:SizeToContents()
    title:SetTextColor(Color(35,214,248))
    title:SetPos(self:GetWide()/2 - title:GetWide()/2, 60)
    table.insert(self.currentPageElements, title)

    -- Scroll Panel
    local scroll = vgui.Create("DScrollPanel", self)
    scroll:SetPos(150, 120)
    scroll:SetSize(600, 350)
    table.insert(self.currentPageElements, scroll)

    local unitRows = {}

    -- Generate lots of fake units
    for i = 1, 200 do
        local row = vgui.Create("DButton", scroll)
        row:Dock(TOP)
        row:DockMargin(0,0,0,5)
        row:SetTall(40)
        row:SetText("")
        row:SetCursor("hand")

        -- Generate fake data
		local fuckyou = math.random(111111111, 999999999)
		local stupid = math.random(10, 99)
        local unitNumber = string.format("%03d", math.random(0, 999))

		local unitNames = {
			"Defender","Hero","Jury","Victor","Line",
			"Patrol","Quick","Roller","King","Vice"
		}

		local unitName = table.Random(unitNames)
        local division = table.Random({
            "Civil Protection"
        })

        row.Paint = function(s, w, h)
            surface.SetDrawColor(0,0,0,180)
            surface.DrawRect(0,0,w,h)

            surface.SetDrawColor(35,214,248,40)
            surface.DrawOutlinedRect(0,0,w,h)

            draw.SimpleText(
                "UNIT: " .. unitName .. " " .. unitNumber,
                "cmb_option",
                10,
                h/2,
                Color(35,214,248),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER
            )

            draw.SimpleText(
                "CMB-" .. fuckyou,
                "cmb_option",
                500,
                h/2,
                Color(35,214,248),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER
            )
        end

        row.DoClick = function()
            PlayRandomClick()

            -- Remove list
            for _, r in ipairs(unitRows) do
                if IsValid(r) then r:Remove() end
            end

            -- Main panel
            local panel = vgui.Create("DPanel", self)
            panel:SetPos(150, 120)
            panel:SetSize(600, 350)
            panel.Paint = function(s, w, h)
                surface.SetDrawColor(0,0,0,180)
                surface.DrawRect(0,0,w,h)
                surface.SetDrawColor(35,214,248,40)
                surface.DrawOutlinedRect(0,0,w,h)
            end
            table.insert(self.currentPageElements, panel)

            -- Model (random combine model)
            local modelView = vgui.Create("DModelPanel", panel)
            modelView:SetSize(256,256)
            modelView:SetPos(-27,10)
            modelView:SetFOV(32)
            modelView:SetCamPos(Vector(0,50,64))
            modelView:SetLookAt(Vector(0,0,64))
            modelView:SetAnimated(false)
            modelView:SetMouseInputEnabled(false)
            modelView.LayoutEntity = function() end

            modelView:SetModel(table.Random({
                "models/Police.mdl"
            }))

            modelView.Entity:SetAngles(Angle(0,90,0))
            table.insert(self.currentPageElements, modelView)

            -- Outline
            local outline = vgui.Create("DPanel", panel)
            outline:SetPos(5, 60)
            outline:SetSize(205, 205)
            outline.Paint = function(s, w, h)
                surface.SetDrawColor(35,214,248,150)
                surface.DrawOutlinedRect(0,0,w,h)
            end
            table.insert(self.currentPageElements, outline)

            -- Info panel
            local infoScroll = vgui.Create("DScrollPanel", panel)
            infoScroll:SetPos(280, 10)
            infoScroll:SetSize(310, 330)
            table.insert(self.currentPageElements, infoScroll)

            local sbar = infoScroll:GetVBar()
            sbar.Paint = function() end
            sbar.btnUp.Paint = function() end
            sbar.btnDown.Paint = function() end
            sbar.btnGrip.Paint = function() end

            local nameLabel = vgui.Create("DLabel", infoScroll)
            nameLabel:SetFont("cmb_title")
            nameLabel:SetText("UNIT: " .. unitName .. " " .. unitNumber)
            nameLabel:SetTextColor(Color(35,214,248))
            nameLabel:SetPos(0, 0)
            nameLabel:SizeToContents()

            local status = table.Random({
                " ",
            })

            local infoText =
                "Division: " .. division ..
                "\nCID: " .. stupid .. unitNumber ..
                "\nCMB: " .. fuckyou ..
                "\n " .. status ..
                "\n " .. status

            local detail = vgui.Create("DLabel", infoScroll)
            detail:SetFont("cmb_option")
            detail:SetTextColor(Color(35,214,248))
            detail:SetPos(0, nameLabel:GetTall() + 27)
            detail:SetText(infoText)
            detail:SizeToContents()

            -- Back button
            local backBtn = vgui.Create("DButton", panel)
            backBtn:SetSize(100,30)
            backBtn:SetPos(panel:GetWide()/2 - 50, panel:GetTall() - 40)
            backBtn:SetText("BACK")
            backBtn:SetFont("cmb_option")
            backBtn:SetTextColor(Color(35,214,248))
            backBtn.Paint = function(s,w,h)
                surface.SetDrawColor(0,0,0,175)
                surface.DrawRect(0,0,w,h)
                surface.SetDrawColor(35,214,248,80)
                surface.DrawOutlinedRect(0,0,w,h)
            end
            backBtn.DoClick = function()
                PlayRandomClick()
                self:OpenUnitDatabase()
            end
            table.insert(self.currentPageElements, backBtn)
        end

        table.insert(unitRows, row)
    end

    for _, r in ipairs(unitRows) do
        table.insert(self.currentPageElements, r)
    end

    -- Back bar
    self:CreateBackBar(function()
        self:CreateHomePage()
    end)
end

-- ===============================
-- Security Feed (Full Fixed Camera Version)
-- ===============================
function PANEL:OpenSecurityFeed()
    self:ClearPage()
    self.CameraActive = false -- ensure default

    -- Title
    local title = vgui.Create("DLabel", self)
    title:SetText(":: Security Feed ::")
    title:SetFont("cmb_title")
    title:SizeToContents()
    title:SetTextColor(Color(35,214,248))
    title:SetPos(self:GetWide()/2 - title:GetWide()/2, 60)
    table.insert(self.currentPageElements, title)

    -- Separate entities
    local cameras = ents.FindByClass("npc_combine_camera")
    local turrets = ents.FindByClass("npc_turret_ceiling")

    local startY = 120
    local spacing = 35

    -- Function to activate a camera/turret
    local function ActivateCamera(cam)
        if not IsValid(cam) then return end

        self.CameraActive = true

        -- Hide the close button
        if IsValid(self.btnClose) then
            self.btnClose:SetVisible(false)
        end

        -- Disable frame input so player can see camera view and Backspace works
        self:SetKeyboardInputEnabled(false)
        self:SetMouseInputEnabled(false)

        -- Hide all UI elements
        for _, v in ipairs(self.currentPageElements) do
            if IsValid(v) then
                v:SetVisible(false)
            end
        end

        -- Notify server
        net.Start("Combine_Security_Enter")
        net.WriteInt(cam:EntIndex(), 16)
        net.SendToServer()

        -- Camera view hook
        hook.Add("CalcView", "CombineCameraViewOverride", function(ply, pos, ang, fov)
            if IsValid(cam) then
                local attach = cam:GetAttachment(1)
                if attach then
                    return {
                        origin = attach.Pos,
                        angles = attach.Ang,
                        fov = fov,
                        drawviewer = false
                    }
                end
            end
        end)
		
		-- Determine camera type
		local camtype = nil
		local cameras = ents.FindByClass("npc_combine_camera")
		local turrets = ents.FindByClass("npc_turret_ceiling")
		local cam = nil

		if #cameras > 0 then
			camtype = ":: CAMERA "
			cam = cameras[1] -- just pick the first camera
		elseif #turrets > 0 then
			camtype = ":: TURRET "
			cam = turrets[1] -- pick the first turret
		end

		-- HUD overlay for camera mode
		hook.Add("HUDPaint", "CombineCameraOverlay", function()
			if IsValid(cam) and camtype then
				draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(35, 214, 248, 15))
				draw.SimpleText(" " .. camtype .. "VIEW ::", "Trebuchet24", ScrW()/2, 39, Color(35, 214, 248), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Press [BACKSPACE] to return", "Trebuchet18", ScrW()/2, ScrH()-50, Color(35, 214, 248), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end)

        -- Think hook to detect Backspace
        hook.Add("Think", "CombineCameraExitThink", function()
            if self.CameraActive and input.IsKeyDown(KEY_BACKSPACE) then
                -- Restore close button
                if IsValid(self.btnClose) then
                    self.btnClose:SetVisible(true)
                end

                -- Clean up hooks
                hook.Remove("CalcView", "CombineCameraViewOverride")
                hook.Remove("HUDPaint", "CombineCameraOverlay")
                hook.Remove("Think", "CombineCameraExitThink")

                -- Notify server camera exit
                net.Start("Combine_Security_Exit")
                net.SendToServer()

                -- Restore UI and input
                self.CameraActive = false
                self:SetKeyboardInputEnabled(true)
                self:SetMouseInputEnabled(true)

                for _, v in ipairs(self.currentPageElements) do
                    if IsValid(v) then
                        v:SetVisible(true)
                    end
                end
            end
        end)
    end

	-- Reset page elements
	if self.currentPageElements then
		for _, elem in ipairs(self.currentPageElements) do
			if IsValid(elem) then elem:Remove() end
		end
	end
	self.currentPageElements = {}
	startY = 10  -- Reset starting Y position
	self.faultLabel = nil  -- Clear fault label so it can be recreated

	-- Function to create buttons for a list of entities
	local function CreateCameraButtons(list, label)
		-- If no turrets and no cameras, show fault message
		if #turrets == 0 and #cameras == 0 then
			if not self.faultLabel then
				local noCam = vgui.Create("DLabel", self)
				local ply = LocalPlayer()
				local plysid = ply:SteamID()
				local ecc = string.sub(plysid, -3)
				noCam:SetFont("cmb_option")
				noCam:SetText("[SERIOUS FAULT] CANNOT CONNECT TO COMBINE CAMERA NETWORK.\nERROR CODE: " .. ecc .. "\nPLEASE CONTACT A TECHNICIAN.")
				noCam:SetTextColor(Color(35, 214, 248))
				noCam:SizeToContents()
				noCam:SetPos(265, 150)
				table.insert(self.currentPageElements, noCam)
				startY = startY + noCam:GetTall() + spacing
				self.faultLabel = noCam  -- store reference
			end
			return
		end

		-- Only create section if list has elements
		if #list > 0 then
			-- Section label
			local sectionLabel = vgui.Create("DLabel", self)
			sectionLabel:SetFont("cmb_option")
			sectionLabel:SetText(label .. "s")
			sectionLabel:SetTextColor(Color(35, 214, 248))
			sectionLabel:SizeToContents()
			sectionLabel:SetPos(50, startY)
			table.insert(self.currentPageElements, sectionLabel)
			startY = startY + sectionLabel:GetTall() + 5

			-- Buttons for each entity
			for i, ent in ipairs(list) do
				local btn = vgui.Create("DButton", self)
				btn:SetPos(50, startY + (i - 1) * spacing)
				btn:SetSize(300, 30)
				btn:SetText(label .. " " .. i)
				btn:SetFont("cmb_option")
				btn:SetTextColor(Color(35, 214, 248))
				btn:SetCursor("hand")

				btn.Paint = function(s, w, h)
					surface.SetDrawColor(0, 0, 0, 175)
					surface.DrawRect(0, 0, w, h)
					surface.SetDrawColor(35, 214, 248, 80)
					surface.DrawOutlinedRect(0, 0, w, h)
				end

				btn.DoClick = function()
					PlayRandomClick()
					ActivateCamera(ent)
				end

				table.insert(self.currentPageElements, btn)
			end

			startY = startY + #list * spacing + spacing
		end
	end

	-- Create separate sections
	CreateCameraButtons(turrets, "Ceiling Turret")
	CreateCameraButtons(cameras, "Security Camera")

	-- Back bar to return to home page
	self:CreateBackBar(function()
		PlayRandomClick()
		net.Start("Combine_Security_Exit")
		net.SendToServer()
		self:CreateHomePage()
	end)
end

-- Modify panel paint to hide frame during camera mode
function PANEL:Paint(w, h)
    if self.CameraActive then return end
    if not self.startupFinished then return end
    derma.SkinHook("Paint", "Frame", self, w, h)
end

vgui.Register("CombineScreen", PANEL, "DFrame")