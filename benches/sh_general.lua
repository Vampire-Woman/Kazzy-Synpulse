local BENCH = {}

BENCH.Class = "general"
BENCH.Name = " "
BENCH.Desc = " "
BENCH.Model = "models/mosi/fallout4/furniture/workstations/workshopbench.mdl"
BENCH.Illegal = true
BENCH.NotIllegalFor = {TEAM_CITIZEN}

impulse.RegisterBench(BENCH)