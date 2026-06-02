SOCIOSTATUS.name = "Unrest Procedure"
SOCIOSTATUS.color = Color(255, 214, 48)
SOCIOSTATUS.description = ""
SOCIOSTATUS.sort = 2

function SOCIOSTATUS:OnCheckAccess(ply)
    return ply:IsUUHigherRank() or ply:IsAdmin()
end

SOCIOSTATUS_MARGINAL = SOCIOSTATUS.index