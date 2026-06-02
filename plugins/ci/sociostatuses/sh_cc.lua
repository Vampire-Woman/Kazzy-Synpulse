SOCIOSTATUS.name = "Sociostable"
SOCIOSTATUS.color = Color(48, 255, 228)
SOCIOSTATUS.description = ""
SOCIOSTATUS.sort = 1

function SOCIOSTATUS:OnCheckAccess(ply)
    return ply:IsUUHigherRank() or ply:IsAdmin()
end

SOCIOSTATUS_PRESERVED = SOCIOSTATUS.index