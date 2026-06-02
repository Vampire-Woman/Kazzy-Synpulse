local ITEM = {}

ITEM.UniqueID = "item_emp"
ITEM.Name = "EMP Tool"
ITEM.Desc = "Can be used to bypass combine technology and defensive doors."
ITEM.Category = "Tools"
ITEM.Model = Model("models/weapons/w_emptool.mdl")
ITEM.FOV = 17.113180515759
ITEM.CamPos = Vector(-10, 25, 9)
ITEM.NoCenter = true
ITEM.Weight = 0.6

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.UseName = "Overload"
ITEM.UseWorkBarTime = 2
ITEM.UseWorkBarName = "Overloading..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "ambient/energy/weld1.wav"

local function FindTarget(ply)
    local nearest
    local nearestDist = math.huge

    for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), 200)) do
        if not IsValid(ent) then continue end

        local class = ent:GetClass()

        local valid =
            (class == "impulse_forcefield_combine") or
            (class == "func_door" and (
                ent:GetSyncVar(SYNC_DOOR_GROUP) == 1 or
                ent:GetSyncVar(SYNC_DOOR_GROUP) == 2
            ))

        if valid then
            local dist = ply:GetPos():DistToSqr(ent:GetPos())

            if dist < nearestDist then
                nearest = ent
                nearestDist = dist
            end
        end
    end

    return nearest
end

function ITEM:OnUse(ply)
    local target = FindTarget(ply)

    if not IsValid(target) then
        ply:EmitSound("buttons/button10.wav")
        ply:Notify("No combine technology found nearby.")
        return
    end

    local chance = math.random(1, 10)

    if chance <= 5 then
        ply:EmitSound("ambient/energy/zap1.wav")
        ply:Notify("The EMP attempt failed.")
        return
    end

    local class = target:GetClass()

    if class == "func_door" then
        target:Fire("Open")

        ply:EmitSound("buttons/combine_button1.wav")
        ply:Notify("You have successfully overloaded the door.")

    elseif class == "impulse_forcefield_combine" then
        if target.IsBroken and target:IsBroken() then
            ply:Notify("The forcefield is already disabled.")
            return
        end

        if target.BreakForcefield then
            target:BreakForcefield()

            ply:EmitSound("buttons/combine_button1.wav")
            ply:Notify("You have successfully overloaded the forcefield.")
        else
            ply:Notify("This forcefield cannot be overloaded.")
        end
    end
end

function ITEM:ShouldTraceUse(ply, ent)
    return IsValid(FindTarget(ply))
end

impulse.RegisterItem(ITEM)