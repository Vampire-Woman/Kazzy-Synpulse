CLASS_OFC=1
CLASS_PTL=2
CLASS_SV=3
CLASS_RL=4
CLASS_DISPATCH=5

TEAM_CP=impulse.Teams.Define({
name="Civil Protection",
color=Color(65,105,200,255),

description=[[
The CCA are the Universal Union’s human police force.
They are responsible for the enforcement of the UU’s laws,
and controlling the population.

The CCA consists of multiple divisions,
each with a specific role. Many join the CCA in hopes
of getting better rations, or simply for the power it
brings over their fellow citizens.
]],

loadout={
"impulse_hands"
},

salary=250,

model="models/police.mdl",
handModel="models/weapons/c_metrocop_hands.mdl",

percentLimit=true,
limit=0.3,

xp=0,
cp=true,

doorGroup={1},

blockNameChange=true,

runSpeed=190,

onBecome=function(ply)

local Spawnpoint={
Vector(1905, -1100, 85)
}

--ply:SetPos(table.Random(Spawnpoint))

local steamID=ply:SteamID64()
local lastDigits=string.Right(steamID,3)

local rankPoints = ply:GetRankPoints()

local formattedRank

if rankPoints < 10 then
    formattedRank = "0"..rankPoints
else
    formattedRank = tostring(rankPoints)
end

local unitName = "Hero "..lastDigits
local displayName = "["..formattedRank.."] "..unitName

ply:SetRPName(displayName, false)

if rankPoints>=75 then
ply:SetTeamClass(CLASS_RL)
elseif rankPoints>=40 then
ply:SetTeamClass(CLASS_SV)
elseif rankPoints>=15 then
ply:SetTeamClass(CLASS_PTL)
else
ply:SetTeamClass(CLASS_OFC)
end

ply:SetWalkSpeed(65)
ply:SetJumpPower(160)
ply:SetMaxHealth(100)

ply:SetHealth(100)

ply:GiveInventoryItem("wep_id",1,true)
end,

classes={

{
name="Officer [0+ Points]",
description="",
model="models/police.mdl",
skin=0,

bodygroups={
{1,0}
},

xp=0,

itemsAdd={
{class="wep_stunstick",amount=1}
},

noMenu=true
},

{
name="Officer [15+ Points]",
description="",
model="models/police.mdl",
skin=0,

bodygroups={
{1,0}
},

xp=0,

itemsAdd={
{class="wep_stunstick",amount=1},
{class="wep_pistol",amount=1}
},

noMenu=true
},

{
name="Officer [40+ Points]",
description="Manage local protection teams.",

model="models/police.mdl",

skin=0,

bodygroups={
{1,0}
},

xp=0,

itemsAdd={
{class="wep_stunstick",amount=1},
{class="wep_pistol",amount=1}
},

noMenu=true
},

{
name="Officer [75+ Points]",

description="Oversee the city's metropolice division.",

model="models/police.mdl",

skin=0,

bodygroups={
{1,1}
},

xp=0,

whitelisted=true,

itemsAdd={
{class="wep_stunstick",amount=1},
{class="wep_smg",amount=1}
},

noMenu=true
},

{
name="Rank Leader",

description="Not fucking used",

model="models/Kleiner.mdl",

whitelisted=true,

limit=1,

onBecome=function(ply,rank)

end
}
}
})

timer.Create("CP_ForceRPName", 5, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Team() == TEAM_CP then

            local steamID = ply:SteamID64()
            local lastDigits = string.Right(steamID, 3)

            local rankPoints = ply:GetRankPoints()

            local formattedRank
            if rankPoints < 10 then
                formattedRank = "0" .. rankPoints
            else
                formattedRank = tostring(rankPoints)
            end

            local unitName = "Hero " .. lastDigits
            local displayName = "[" .. formattedRank .. "] " .. unitName

            ply:SetRPName(displayName, false)
        end
    end
end)