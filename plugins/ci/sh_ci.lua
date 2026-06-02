PLUGIN.Name = "Combine Improvements"
PLUGIN.Desc = ""
PLUGIN.Author = "Riggs McGay"

impulse.ci = impulse.ci or {}
impulse.ci.socioStatus = impulse.ci.socioStatus or {}
impulse.ci.socioStatus.list = impulse.ci.socioStatus.list or {}
impulse.ci.display = impulse.ci.display or {}
impulse.ci.display.messages = impulse.ci.display.messages or {}
impulse.ci.display.messageID = impulse.ci.display.messageID or 0
impulse.ci.display.randomMessages = {
     "",
}
impulse.ci.directives = impulse.ci.directives or {}
impulse.ci.arrest = impulse.ci.arrest or {}
impulse.ci.arrest.config = {
	["arrestCharges"] = {
		{name = "10-103m, disturbance by mentally unfit", severity = 2, sound = "npc/overwatch/radiovoice/disturbancemental10-103m.wav"},
		{name = "27, attempted crime", severity = 2, sound = "npc/overwatch/radiovoice/attemptedcrime27.wav"},
		{name = "51, non-sanctioned arson", severity = 2, sound = "npc/overwatch/radiovoice/nonsanctionedarson51.wav"},
		{name = "51B, threat to property", severity = 2, sound = "npc/overwatch/radiovoice/threattoproperty51b.wav"},
		{name = "63, criminal trespass", severity = 2, sound = "npc/overwatch/radiovoice/criminaltrespass63.wav"},
		{name = "69, possession of (contraband) resources", severity = 2, sound = "npc/overwatch/radiovoice/posession69.wav"},
		{name = "95, illegal carrying (weaponry)", severity = 2, sound = "npc/overwatch/radiovoice/illegalcarrying95.wav"},
		{name = "99, reckless operation", severity = 2, sound = "npc/overwatch/radiovoice/recklessoperation99.wav"},
		{name = "148, resisting arrest", severity = 2, sound = "npc/overwatch/radiovoice/resistingpacification148.wav"},
		{name = "243, assault on protection team", severity = 2, sound = "npc/overwatch/radiovoice/assault243.wav"},
		{name = "404, riot", severity = 2, sound = "npc/overwatch/radiovoice/riot404.wav"},
		{name = "507, public non-compliance", severity = 2, sound = "npc/overwatch/radiovoice/publicnoncompliance507.wav"},
		{name = "603, unlawful entry", severity = 2, sound = "npc/overwatch/radiovoice/unlawfulentry603.wav"},
		{name = "Disassociation from the civic populous", severity = 2, sound = "npc/overwatch/radiovoice/disassociationfromcivic.wav"},
		{name = "Promoting communal unrest", severity = 2, sound = "npc/overwatch/radiovoice/promotingcommunalunrest.wav"},
	},
}

function impulse.ci.socioStatus.LoadFromDir(directory)
    for _, v in ipairs(file.Find(directory.."/*.lua", "LUA")) do
        local niceName = v:sub(4, -5)
        local index = #impulse.ci.socioStatus.list + 1
        local halt

        for _, v2 in ipairs(impulse.ci.socioStatus.list) do
            if ( v2.uniqueID == niceName ) then
                halt = true
            end
        end

        if ( halt == true ) then
            continue
        end

        SOCIOSTATUS = {index = niceName, uniqueID = niceName}
            SOCIOSTATUS.name = "Unknown"
            SOCIOSTATUS.description = "No description available."

            if ( PLUGIN ) then
                SOCIOSTATUS.plugin = PLUGIN.uniqueID
            end

            impulse.lib.LoadFile(directory.."/"..v, "shared")

            impulse.ci.socioStatus.list[niceName] = SOCIOSTATUS
        SOCIOSTATUS = nil
    end
end

function impulse.ci.socioStatus.Get(uniqueID)
    if not ( uniqueID ) then
        uniqueID = impulse.ci.socioStatus.GetCurrent()
    end

    return impulse.ci.socioStatus.list[uniqueID]
end

function impulse.ci.socioStatus.GetCurrent()
    return GetGlobalString("impulseCitadelSocioStatus", "sociostatus_preserved")
end

local toNumStatus = {
    ["cc"] = 1,
    ["cu"] = 2,
    ["jw"] = 3
}

function impulse.ci.socioStatus.ToNumber(status)
    if not ( status ) then
        status = impulse.ci.socioStatus.GetCurrent()
    end

    return toNumStatus[status]
end

impulse.ci.socioStatus.LoadFromDir(engine.ActiveGamemode().."/plugins/ci/sociostatuses")

/*
impulse.command.Add("SetSocioStatus", {
    arguments = impulse.type.text,
    superAdminOnly = true,
    OnRun = function(self, ply, socioStatus)
        local socioStatusTable

        for _, v in ipairs(impulse.ci.socioStatus.list) do
            if ( impulse.util.StringMatches(v.uniqueID, socioStatus) or impulse.util.StringMatches(v.name, socioStatus) ) then
                socioStatusTable = v
            end
        end

        if ( socioStatusTable ) then
            impulse.ci.socioStatus.Set(ply, socioStatusTable.index)
        else
            return "@invalidClass"
        end
    end
})
*/

hook.Add("CreateSyncVars", "CISyncVars", function()
    SYNC_DATAFILE = impulse.Sync.RegisterVar(SYNC_STRING)
end)