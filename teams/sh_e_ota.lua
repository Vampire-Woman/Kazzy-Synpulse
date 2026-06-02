CLASS_ECHO=1
CLASS_MACE=2
CLASS_ELITE=3
CLASS_SNIPER=4

TEAM_OTA=impulse.Teams.Define({
name="Overwatch Transhuman Arm",
color=Color(149,112,64),
description="Not like a Zombine, Alyx.",
loadout={"impulse_hands"},
salary=300,
model="models/Combine_Soldier.mdl",
handModel="models/weapons/c_arms_combine.mdl",
percentLimit=true,
limit=0.15,
xp=500,
cp=true,
doorGroup={1,2},
blockNameChange=true,
whitelisted=true,

onBecome=function(ply)

local Spawnpoints={
Vector(8926.81640625, -11400.448242188, -3663.96875),
Vector(8799.2138671875, -11404.737304688, -3663.96875),
Vector(8801.65234375, -11519.751953125, -3663.96875),
}

--ply:SetPos(table.Random(Spawnpoints))
ply:SetRunSpeed(impulse.Config.JogSpeed)
ply:SetWalkSpeed(65)
ply:SetJumpPower(160)
ply:SetHealth(100)
ply:SetMaxHealth(100)
ply:SetHunger(100)
ply:FixLegs()
ply:AllowFlashlight(true)
ply:GiveInventoryItem("wep_id",1,true)
fuck = math.random(1,9)

if fuck >= 7 then
    ply:SetTeamClass(3)
elseif fuck >= 4 then
    ply:SetTeamClass(2)
else
    ply:SetTeamClass(1)
end

local names={
"Sword",
"Hammer",
"Striker",
"Slash",
"Scar",
"Star",
"Sweeper",
"Swift",
"Fist",
"Stab"
}

ply:SetRPName(table.Random(names).." "..impulse.ZeroNumber(math.random(1000,9999),1),false)

net.Start("impulseHL2RPCombineOverlayBoot")
net.Send(ply)
end,

classes={
{
name="Soldier",
description="Standard OTA infantry.",
model="models/Combine_Soldier.mdl",
skin=0,

itemsAdd={
{class="wep_smg",amount=1}
},

xp=1000,
armour=120
},

{
name="Shotgunner",
description="Close-quarters OTA unit.",
model="models/Combine_Soldier.mdl",
skin=1,

itemsAdd={
{class="wep_shotgun",amount=1}
},

xp=1500,
armour=130
},

{
name="Elite",
description="Elite OTA soldier.",
model="models/Combine_Super_Soldier.mdl",
skin=0,

itemsAdd={
{class="wep_ar2",amount=1}
},

xp=4200,
armour=200,
whitelisted=true
},

{
name="Sniper",
description="Long-range OTA marksman.",
model="models/Combine_Soldier.mdl",
skin=0,

itemsAdd={
{class="wep_mini14",amount=1}
},

xp=1500,
armour=110
}
}
})