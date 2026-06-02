local BENCH = {}

BENCH.Class = "clothing"
BENCH.Name = "Tailoring Station"
BENCH.Desc = "Can be used to make clothing items."
BENCH.Model = "models/props_canal/winch02.mdl"
BENCH.Illegal = true
BENCH.NotIllegalFor = {TEAM_CITIZEN}

impulse.RegisterBench(BENCH)