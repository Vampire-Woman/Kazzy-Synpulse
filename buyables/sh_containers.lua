impulse.Business.Define("Small Crate", {
    entity = "impulse_container",
    model = "models/Items/item_item_crate.mdl",  -- old: models/props_junk/wood_crate001a.mdl
    description = "Can store 8kg worth of items.",
    price = 55,
    refund = true,
    postSpawn = function(ent, ply)
    	ent:SetCapacity(8)
    end
})

impulse.Business.Define("Crate", {
    entity = "impulse_container",
    model = "models/props_junk/wood_crate001a.mdl",  -- old: models/props_junk/wood_crate001a.mdl
    description = "Can store 12kg worth of items.",
    price = 75,
    refund = true,
    postSpawn = function(ent, ply)
    	ent:SetCapacity(12)
    end
})

impulse.Business.Define("Large Crate", {
    entity = "impulse_container",
    model = "models/props_junk/wood_crate002a.mdl", -- old: models/props_junk/wood_crate002a.mdl
    description = "Can store 30kg worth of items.",
    price = 135,
    refund = true,
    postSpawn = function(ent, ply)
        ent:SetCapacity(30)
    end
})
