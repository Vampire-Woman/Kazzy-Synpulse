-- Framework related
impulse.Config.Community = ""

impulse.Config.SchemaName = ""
impulse.Config.SchemaVersion = 0
impulse.Config.SchemaAuthor = "Bloodmore"
impulse.Config.SchemaCredits = "Bloodmore"

impulse.Config.MainColour = Color(81, 186, 142)
impulse.Config.InteractColour = Color(251, 197, 49)

impulse.Config.UserSlots = 999 -- any other slots will be donator slots

impulse.Config.IntroMusic = ""

impulse.Config.SignalsUpdateTime = 2

impulse.Config.WalkSpeed = 80
impulse.Config.JogSpeed = 210
impulse.Config.SlowWalkRatio = 1.3

impulse.Config.TalkDistance = 512
impulse.Config.WhisperDistance = 128
impulse.Config.YellDistance = 1024
impulse.Config.VoiceDistance = 512

impulse.Config.OOCLimit = 16
impulse.Config.OOCLimitVIP = 24

impulse.Config.PropLimit = 100
impulse.Config.PropLimitDonator = 250

impulse.Config.BuyableSpawnLimit = 999
impulse.Config.DroppedItemsLimit = 999
impulse.Config.DroppedMoneyLimit = 999
impulse.Config.ChairsLimit = 666

impulse.Config.StartingMoney = 0
impulse.Config.StartingBankMoney = 50
impulse.Config.MoneyModel = "models/props/cs_assault/money.mdl"
impulse.Config.CurrencyPrefix = "T"
impulse.Config.CurrencyName = "Tokens"
impulse.Config.ATMModel = "models/props_combine/combine_intwallunit.mdl"

impulse.Config.XPTime = 999999
impulse.Config.XPGet = 0
impulse.Config.XPGetVIP = 0

impulse.Config.RationTime = 3600

impulse.Config.AFKTime = 999999
impulse.Config.AFKKickRatio = 0.95

impulse.Config.TeamChangeTime = 0
impulse.Config.TeamChangeTimeDonator = 0

impulse.Config.ClassChangeTime = 0
impulse.Config.QuizWaitTime = 20 -- in mins

impulse.Config.RespawnTime = 60
impulse.Config.RespawnTimeDonator = 30

impulse.Config.BodyDeSpawnTime = 360 -- 6 mins
impulse.Config.BrokenLegsHealTime = 300 -- 5 mins

impulse.Config.PropPrice = 0
impulse.Config.PropPriceDonator = 0

impulse.Config.RPNameChangePrice = 50

impulse.Config.CosmeticGenderPrice = 1
impulse.Config.CosmeticModelSkinPrice = 1

impulse.Config.MaxLetters = 1

impulse.Config.HungerTime = 120
impulse.Config.HungerHealTime = 15

impulse.Config.InventoryMaxWeight = 30 -- in kg
impulse.Config.InventoryCPMaxWeight = 40 -- in kg
impulse.Config.InventoryOTAMaxWeight = 125 -- in kg
impulse.Config.InventoryVortMaxWeight = 60 -- in kg
impulse.Config.InventoryStorageMaxWeight = 500
impulse.Config.InventoryStorageMaxWeightVIP = 500
impulse.Config.InventoryItemDeSpawnTime = 86400 
impulse.Config.InventoryStorageModel = "models/props/cs_militia/footlocker01_closed.mdl"
impulse.Config.InventoryStoragePublicModel = "models/props/cs_militia/footlocker01_closed.mdl"

impulse.Config.GroupMakeCost = 100
impulse.Config.GroupXPRequirement = 5
impulse.Config.GroupMaxMembers = 20
impulse.Config.GroupMaxMembersVIP = 100
impulse.Config.GroupMaxRanks = 13
impulse.Config.GroupMaxRanksVIP = 20

impulse.Config.DiscordLeadModRoleID = ""
impulse.Config.AutoModCooldown = 99999 -- changed from 130 because it was falsely flagging people alot
impulse.Config.AutoModMaxRisk = 99999 -- changed from 15 because it was falsely flagging people alot

impulse.Config.CommunityURL = ""
impulse.Config.PanelURL = ""
impulse.Config.DonateURL = ""
impulse.Config.DiscordURL = ""
impulse.Config.SupportURL = ""
impulse.Config.DiscordRelayURL = ""
impulse.Config.RulesURL = ""
impulse.Config.TutorialURL = ""

-- Optional, if you don't have it delete the line below. Used for newsfeed. Requires: https://wordpress.org/plugins/better-rest-api-featured-images/
impulse.Config.WordPressURL = ""
impulse.Config.DefaultWordPressImage = ""

impulse.Config.DisabledPlugins = {
	--["buildings"] = true
	["halloween"] = true
}

impulse.Config.DoorPrice = 10
impulse.Config.DoorGroups = {
	[1] = "Metropolice",
	[2] = "Combine Locked",
	[3] = "Workforce Locked",
	[4] = "Medical Workforce Locked",
	[5] = "Combine L:3"
}

impulse.Config.RankColours = {
	["superadmin"] = Color(201, 15, 12),
	["communitymanager"] = Color(84, 204, 5),
	["leadadmin"] = Color(64, 128, 64),
	["admin"] = Color(64, 128, 64),
	["moderator"] = Color(64, 128, 64),
	["donator"] = Color(212, 185, 9)
}

impulse.Config.SaveableAmmo = {
	["Pistol"] = true,
	["SMG1"] = true,
	["357"] = true,
	["Medkit"] = true,
	["Buckshot"] = true,
	["AR2"] = true,
	["Rifle"] = true
}

impulse.Config.Achievements = {
}

impulse.Config.ModQuickReplies = {
	"There are lots of reports being handled right now, you will be helped as quickly as possible."
}

impulse.Config.AutoModDict = {
	{
		Terms = {"HI DALE", "HELLO DALE", "DALE", "WHAT IS DALE", "WHO IS DALE"},
		Specific = true,
		IgnorePunc = true,
		RequestClose = true,
		Reply = "Fuck you."
	},
	{
		Terms = {"HELP", "JUST HELP", "HELP ME", "ADMIN HELP", "ADMIN", "COME HERE", "COME", "NEED STAFF", "NEED ADMIN", "ADMIN COME HERE", "ADMIN TO ME", "I NEED A ADMIN", "I NEED ADMIN", "TO ME", "MINGE", "HEY"},
		Specific = true,
		IgnorePunc = true,
		Reply = "Minimum word count too low to process request. Please add more information."
	},
	{
		Terms = {"STUCK"},
		IgnorePunc = true,
		RequestClose = true,
		Reply = "I've tried to get you un-stuck. This automated system might not always work, however. You can activate this by typing /unstuck in chat. If you are still stuck, just hang in there and we'll be with you shortly!",
		Command = "say /unstuck"
	}
}

impulse.Config.DefaultTeam = TEAM_CITIZEN

impulse.Config.DefaultMaleModels = {
	Model("models/player/impulse_zelpa/male_02.mdl"),
	Model("models/player/impulse_zelpa/male_04.mdl"),
	Model("models/player/impulse_zelpa/male_05.mdl"),
	Model("models/player/impulse_zelpa/male_06.mdl"),
	Model("models/player/impulse_zelpa/male_07.mdl"),
	Model("models/player/impulse_zelpa/male_08.mdl"),
	Model("models/player/impulse_zelpa/male_09.mdl"),
	Model("models/player/impulse_zelpa/male_10.mdl")
}

impulse.Config.DefaultFemaleModels = {
	Model("models/player/impulse_zelpa/female_01.mdl"),
	Model("models/player/impulse_zelpa/female_02.mdl")
}

impulse.Config.DefaultSkinBlacklist = {

}

--
-- Half Life 2: Roleplay Schema:
--

impulse.Config.ArrestCharges = {
	{name = "10-103m, disturbance by mentally unfit", severity = 1, sound = "npc/overwatch/radiovoice/disturbancemental10-103m.wav"},
	{name = "27, attempted crime", severity = 1, sound = "npc/overwatch/radiovoice/attemptedcrime27.wav"},
	{name = "51, non-sanctioned arson", severity = 3, sound = "npc/overwatch/radiovoice/nonsanctionedarson51.wav"},
	{name = "51B, threat to property", severity = 3, sound = "npc/overwatch/radiovoice/threattoproperty51b.wav"},
	{name = "63, criminal trespass", severity = 3, sound = "npc/overwatch/radiovoice/criminaltrespass63.wav"},
	{name = "69, possession of (contraband) resources", severity = 3, sound = "npc/overwatch/radiovoice/posession69.wav"},
	{name = "95, illegal carrying (weaponry)", severity = 3, sound = "npc/overwatch/radiovoice/illegalcarrying95.wav"},
	{name = "99, reckless operation", severity = 3, sound = "npc/overwatch/radiovoice/recklessoperation99.wav"},
	{name = "148, resisting arrest", severity = 3, sound = "npc/overwatch/radiovoice/resistingpacification148.wav"},
	{name = "243, assault on protection team", severity = 4, sound = "npc/overwatch/radiovoice/assault243.wav"},
	{name = "404, riot", severity = 3, sound = "npc/overwatch/radiovoice/riot404.wav"},
	{name = "507, public non-compliance", severity = 3, sound = "npc/overwatch/radiovoice/publicnoncompliance507.wav"},
	{name = "603, unlawful entry", severity = 3, sound = "npc/overwatch/radiovoice/unlawfulentry603.wav"},
	{name = "Disassociation from the civic populous", severity = 3, sound = "npc/overwatch/radiovoice/disassociationfromcivic.wav"},
	{name = "Promoting communal unrest", severity = 3, sound = "npc/overwatch/radiovoice/promotingcommunalunrest.wav"},
}

impulse.Config.DispatchLines = {
    {name = "Anti-citizen reported in this community", text = "Attention, ground-units: Anti-citizen reported in this community. Code: LOCK, CAUTERIZE, STABILIZE.", sound = "npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav", volume = 80},
    {name = "Anti-civil activity level 1", text = "You are charged with anti-civil activity level: ONE. Protection-unit prosecution code: DUTY, SWORD, OPERATE.", sound = "npc/overwatch/cityvoice/f_anticivil1_5_spkr.wav", volume = 85},
	{name = "Block search", text = "Attention, residents: This blocks contains potential civil infection. INFORM, CO-OPERATE, ASSEMBLE.", sound = "npc/overwatch/cityvoice/f_trainstation_inform_spkr.wav", volume = 90},
	{name = "Inspection positions", text = "Attention, please: All citizens in local residential block, assume your inspection-positions.", sound = "npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav", volume = 90},
	{name = "Unidentified person of interest", text="Attention please. Unidentified person of interest, confirm your civil status with local protection team immediately.", sound = "npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav", volume = 75},
	{name = "Status evasion in progress", text="Attention, protection-team, status evasion in progress in this community. RESPOND, ISOLATE, INQUIRE.", sound="npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav", volume = 85},
	{name = "Anti-civil evidence", text = "Protection team alert: Evidence of anti-civil activity in this community. Code: ASSEMBLE, CLAMP, CONTAIN.", sound = "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav", volume = 85},
	{name = "Socio-endagerment level 5", text = "Individual, you are now charged with Socio-Endangerment level: FIVE. Cease evasion immediately, receive your verdict.", sound = "npc/overwatch/cityvoice/f_ceaseevasionlevelfive_spkr.wav", volume = 85}
}

impulse.Config.MaxJailTime = 900
impulse.Config.MaxJailTimeGrunt = 420
impulse.Config.MinJailTime = 60
impulse.Config.MaxArrestCharges = 4

impulse.Config.DefaultBOLTime = 2700

impulse.Config.CameraRepairTime = 2400

impulse.Config.ManhackTime = 160

impulse.Config.MaxSquadSizeCP = 5
impulse.Config.MaxSquadSizeOTA = 5

impulse.Config.MaxSquadsCP = 4
impulse.Config.MaxSquadsOTA = 4
impulse.Config.SquadExpiryTime = 240

impulse.Config.MaxBarrels = 2
impulse.Config.BrewingTime = 600

impulse.Config.FurnaceTime = 15

impulse.Config.VendingRefillReward = 15

impulse.Config.ApartmentCost = 15 -- one time purchase amount

impulse.Config.ExplosionDoorRespawnTime = 230

impulse.Config.AmmoDrillTime = 180 -- 3 mins

impulse.Config.LootPools = {
	["garbage"] = {
		Items = {
			["util_metalplate"] = {Rarity = 200},
			["util_battery"] = {Rarity = 999},
			["util_electronics"] = {Rarity = 998},
			["food_canned_food"] = {Rarity = 997},
			["item_canopener"] = {Rarity = 996}
		},
		MaxRarity = 3100,
		MaxItems = 1,
		MaxWait = 700,
		MinWait = 210
	},
	["electronic"] = {
		Items = {
			["util_electronics"] = {Rarity = 950},
			["util_computerhardware"] = {Rarity = 996},
			["util_metalplate"] = {Rarity = 200}
		},
		MaxItems = 2,
		MaxWait = 860,
		MinWait = 430
	},
	["toolbox"] = {
        Items = {
            ["util_metalplate"] = {Rarity = 200},
            ["item_buildingkit"] = {Rarity = 900},
			["util_electronics"] = {Rarity = 900},
			["wep_crowbar"] = {Rarity = 950},
			["wep_pipe"] = {Rarity = 950},
			["wep_shovel"] = {Rarity = 950},
            ["wep_axe"] = {Rarity = 950},
            ["ammo_pistol"] = {Rarity = 950},
            ["ammo_smg"] = {Rarity = 950},
            ["item_flashlight"] = {Rarity = 990}
        },
        MaxItems = 3,
        MaxWait = 600,
        MinWait = 300
    },
	["mechanical"] = {
        Items = {
            ["util_metalplate"] = {Rarity = 200},
            ["util_fuel"] = {Rarity = 990},
            ["util_mechanicalengine"] = {Rarity = 999}
            
        },
        MaxItems = 3,
        MaxWait = 600,
        MinWait = 300
    },
	--["ammobox"] = {
		--Items = {
			--["ammo_smg"] = {Rarity = 600, Rep = 4},
			--["ammo_buckshot"] = {Rarity = 600, Rep = 4},
			--["ammo_rifle"] = {Rarity = 600, Rep = 4},
			--["ammo_pistol"] = {Rarity = 600, Rep = 4},
			--["ammo_357"] = {Rarity = 600, Rep = 4},
			--["item_cpsupplycrate"] = {Rarity = 300},
			--["item_otasupplycrate"] = {Rarity = 300}
		--},
		--MaxItems = 20,
		--MinItems = 12
	--},
	["shopbox"] = {
		Items = {
			--["wep_pistol"] = {Rarity = 800},
			--["wep_smg"] = {Rarity = 800},
			--["wep_357"] = {Rarity = 999},
			--["wep_akm"] = {Rarity = 950},
			--["wep_crossbow"] = {Rarity = 999},
			--["wep_shovel"] = {Rarity = 800},
			--["wep_pipe"] = {Rarity = 800},
			--["wep_cleaver"] = {Rarity = 800},
			--["wep_axe"] = {Rarity = 800},
			--["wep_crowbar"] = {Rarity = 800},
			["food_fish"] = {Rarity = 200},
			["food_bread"] = {Rarity = 200},
			["food_noodles"] = {Rarity = 200},
			["food_beer"] = {Rarity = 200},
			["food_donut"] = {Rarity = 200},
			["food_sweetroll"] = {Rarity = 200},
			["food_water"] = {Rarity = 200},
			["food_watermelon"] = {Rarity = 200},
			["food_tomato"] = {Rarity = 200},
			["food_tea"] = {Rarity = 200},
			["food_canned_food"] = {Rarity = 200},
			["food_friedrice"] = {Rarity = 200},
			["food_banana"] = {Rarity = 200},
			["food_coffee"] = {Rarity = 200},
			["food_burger"] = {Rarity = 200},
			["food_cheese"] = {Rarity = 200},
			["food_breenwater"] = {Rarity = 200},
			["food_cabbage"] = {Rarity = 200},
			["food_apple"] = {Rarity = 200},
			["food_bagofchips"] = {Rarity = 200},
			["food_pineapple"] = {Rarity = 200},
			["food_cabbage"] = {Rarity = 200},
			["food_orange"] = {Rarity = 200},
			["food_pear"] = {Rarity = 200},
			["food_wine"] = {Rarity = 200},
			["food_milk"] = {Rarity = 200},
			["food_cannedfood"] = {Rarity = 200},
			["food_jugwater"] = {Rarity = 200},
			["cos_green_shirt"] = {Rarity = 200},
			["cos_blue_shirt"] = {Rarity = 200},
			["cos_tan_shirt"] = {Rarity = 200},
			["cos_white_shirt"] = {Rarity = 200},
			["cos_brownpants"] = {Rarity = 200},
			["cos_paddedpants"] = {Rarity = 200},
			["cos_beanie_grey"] = {Rarity = 200},
			["cos_beanie_green"] = {Rarity = 200},
			["cos_glove_fingerless"] = {Rarity = 200},
			["cos_glove_fingered"] = {Rarity = 200},
			["cos_loyaljacket_a"] = {Rarity = 999},
			["cos_loyaljacket_b"] = {Rarity = 999},
			["cos_loyaljacket_c"] = {Rarity = 999},
			["item_lockpick"] = {Rarity = 200},
			["item_canopener"] = {Rarity = 200}
		},
		MaxItems = 1,
		MaxWait = 700,
		MinWait = 210
	}
	--["candybasket"] = {
	--	Items = {
	--		["wep_hal_horsemanaxe"] = {Rarity = 999},
	--		["cos_hal_skull"] = {Rarity = 800},
	--		["cos_hal_zombie"] = {Rarity = 800},
	--		["cos_hal_pumpkin"] = {Rarity = 800},
	--		["cos_hal_monkey"] = {Rarity = 800},
	--		["food_hal_candy_pink"] = {Rarity = 400},
	--		["food_hal_candy_red"] = {Rarity = 200},
	--		["food_hal_candy_purple"] = {Rarity = 200},
	--		["food_hal_candy_green"] = {Rarity = 200},
	--		["food_hal_candy_yellow"] = {Rarity = 200},
	--		["food_hal_candy_orange"] = {Rarity = 200},
	--	},
	--	MaxItems = 1,
	--	MaxWait = 700,
	--	MinWait = 210
	--}
}

--
-- Plugins
--

impulse.Config.PassiveMusic = {	
    { "music/HL1_song3.mp3", 132 },
    { "music/HL1_song26.mp3", 38 },
    { "music/HL1_song20.mp3", 85 },
	
    { "music/HL2_song0.mp3", 40 },
    { "music/HL2_song10.mp3", 29 },
    { "music/HL2_song13.mp3", 54 },
    { "music/HL2_song2.mp3", 173 },
	{ "music/HL2_song30.mp3", 104 },
    { "music/HL2_song17.mp3", 61 },
	
    { "music/HL2_song26_trainstation1.mp3", 91 },
    { "music/HL2_song27_trainstation2.mp3", 72 },

	{ "music/entropyzero/uprising/questionable_life_choices.mp3", 60 },
	{ "music/entropyzero/uprising/ghost_particle.mp3", 90 },
	{ "music/entropyzero/uprising/everyone_pays_a_price.mp3", 103 },
	{ "music/entropyzero/uprising/combine_zombies.mp3", 45 },
	{ "music/entropyzero/uprising/distant_light.mp3", 43 },
	{ "music/entropyzero/uprising/victor.mp3", 30 },
	{ "music/entropyzero/uprising/combine_walls.mp3", 120 },
	
	{ "impulse_citadel/music/a1_intro_hallway.mp3", 48 },
	{ "impulse_citadel/music/a1_intro_hallway_short.mp3", 20 },
	{ "impulse_citadel/music/trek2_long.mp3", 123 },
	{ "impulse_citadel/music/trek3_long.mp3", 110 },
	{ "impulse_citadel/music/hallway_long.mp3", 83 }
}

impulse.Config.CombatMusic = {
	{"music/HL2_song12_long.mp3", 73},
	{"music/HL2_song14.mp3", 159},
	{"music/HL2_song15.mp3", 69},
	{"music/HL2_song16.mp3", 170},
	{"music/HL2_song20_submix0.mp3", 103},
	{"music/hl1_song10.mp3", 105},	
	{"rootssounds/hl01.mp3", 175},	
	{"rootssounds/hl11.mp3", 114},	
	{"music/HL2_song20_submix4.mp3", 139},
	{"music/HL2_song29.mp3", 135},
	{"music/HL2_song3.mp3", 90},
	{"music/HL2_song31.mp3", 98},
	{"music/HL2_song4.mp3", 65},
	{"music/HL2_song6.mp3", 45}
}

impulse.Config.WashTime = 30
impulse.Config.DirtyClothDelay = 120
impulse.Config.DirtyCartMaxCloth = 4

impulse.Config.MoneyPerCloth = 2
impulse.Config.PhraseCleanClothes = "<clothes> clean clothes"
impulse.Config.PhraseDirtyClothes = "<clothes> dirty clothes"
impulse.Config.PhraseNotifyText = "You received <money> for washing <clothes> clothes"
