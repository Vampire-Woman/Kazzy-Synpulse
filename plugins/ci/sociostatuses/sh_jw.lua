SOCIOSTATUS.name = "Judgment Waiver"
SOCIOSTATUS.color = Color(255, 76, 53)
SOCIOSTATUS.description = ""
SOCIOSTATUS.sort = 3

function SOCIOSTATUS:OnCheckAccess(ply)
    return ply:IsUUHigherRank() or ply:IsAdmin()
end

SOCIOSTATUS_FRACTURED = SOCIOSTATUS.index