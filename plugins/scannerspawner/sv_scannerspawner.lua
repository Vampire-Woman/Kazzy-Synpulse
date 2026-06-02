local scannerSpawnPositions = {
    Vector(850.85778808594, -3707.1887207031, 76.03125),
    Vector(147.21701049805, 1602.7504882813, 76.03125),
    Vector(-3407.0207519531, -2348.1872558594, 425.86560058594)
}

local function IsScannerAtPosition(scannerposition)
    for _, ent in pairs(ents.FindInSphere(scannerposition, 10)) do
        if ent:GetClass() == "npc_cscanner" then
            return true
        end
    end
    return false
end

local function SpawnScanners(scannerposition)
    if IsScannerAtPosition(scannerposition) then return end

    local scanner = ents.Create("npc_cscanner")
    if not IsValid(scanner) then return end

    scanner:SetPos(scannerposition)
    scanner:Spawn()
    scanner:Activate()

    scanner.spawnScannerPosition = scannerposition
    scanner.shouldRespawnScanner = true
end

local function SetupScanners(scn)
    for _, scannerposition in pairs(scn) do
        SpawnScanners(scannerposition)
    end
end

hook.Add("InitPostEntity", "SpawnScanners", function()
    SetupScanners(scannerSpawnPositions)
end)

hook.Add("PostCleanupMap", "SpawnScannersPostCleanupMap", function()
    SetupScanners(scannerSpawnPositions)
end)

hook.Add("OnNPCKilled", "ScannerKilled", function(scanner, attacker, inflictor)
    if IsValid(scanner) and scanner.shouldRespawnScanner then
        local scannerposition = scanner.spawnScannerPosition

        timer.Simple(60, function()
            SpawnScanners(scannerposition)
        end)
    end
end)