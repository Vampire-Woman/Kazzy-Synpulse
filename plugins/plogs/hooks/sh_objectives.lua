plogs.Register('Objectives', false)

plogs.AddHook("PlayerEditedObjective", function(id, new, tbl, totalTableAmount)
	plogs.PlayerLog(nil, 'Objectives', "Edited Directive #"..id.." to "..new, {
	    ["ID"] = id,
        ["New Directive"] = new,
        ["Total Directives"] = totalTableAmount
	})
end)

plogs.AddHook("PlayerAddedObjective", function(objective, tbl, amount)
	plogs.PlayerLog(nil, 'Objectives', "New Directive #"..amount..": "..objective, {
	    ["ID"] = amount,
        ["Directive"] = objective
	})
end)

plogs.AddHook("PlayerRemovedObjective", function(id, tbl, amount)
	plogs.PlayerLog(nil, 'Objectives', "Removed Directive #"..id, {
	    ["ID"] = id
	})
end)