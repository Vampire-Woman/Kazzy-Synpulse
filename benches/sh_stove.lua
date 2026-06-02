local BENCH = {}

BENCH.Class = "stove"
BENCH.Name = " "
BENCH.Desc = " "
BENCH.Model = "models/props_wasteland/kitchen_stove001a.mdl"
BENCH.Illegal = true
BENCH.NotIllegalFor = {TEAM_CITIZEN}

impulse.RegisterBench(BENCH)