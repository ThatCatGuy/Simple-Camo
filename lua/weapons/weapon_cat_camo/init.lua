AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local PeopleInCamo = {}
local CamoActivate = Sound("HL1/fvox/activated.wav")
local CamoDeactivate = Sound("HL1/fvox/deactivated.wav")

local function CamoIsEnabled(ply)
	return ply and ply.Camo
end

util.AddNetworkString("CamoDisable")
local function DisableCamo(ply)
	ply:SetNoDraw(false)
	ply.Camo = false
	ply:EmitSound(CamoDeactivate, 50, 100, 1, CHAN_AUTO )
	net.Start("CamoDisable")
		net.WriteEntity(ply)
	net.Broadcast()
end

util.AddNetworkString("CamoEnable")
local function EnableCamo(ply)
	ply:SetNoDraw(false)
	ply.Camo = true
	ply:EmitSound(CamoActivate, 50, 100, 1, CHAN_AUTO )
	net.Start("CamoEnable")
		net.WriteEntity(ply)
	net.Broadcast()
end

local function UpdateCamo(ply)
	if CamoIsEnabled(ply) then
		DisableCamo(ply)
	else
		EnableCamo(ply)
	end
end

local function CamoToggle(ply)
	UpdateCamo(ply)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 3)
	CamoToggle(self.Owner)
end

function SWEP:Think()
	local ply = self.Owner
	if CamoIsEnabled(ply) then
		if ply:GetVelocity():Length() <= 1 then
			ply:SetNoDraw(true)
		elseif ply:GetVelocity():Length() > 1 then
			ply:SetNoDraw(false)
		end
	end
end

function SWEP:Holster()
	if CamoIsEnabled(self.Owner) then
		DisableCamo(self.Owner)
	end
	return true
end

concommand.Add("_disable_camo", function(ply)
    if CamoIsEnabled(ply) then
        DisableCamo(ply)
    end
end)

local function RemoveCamoOnArrest(criminal, time, actor)
	if CamoIsEnabled(criminal) then
		DisableCamo(criminal)
	end
end
hook.Add("playerArrested", "Camo.RemoveOnArrest", RemoveCamoOnArrest)

local function RemoveCamoOnPhysgun(ply, ent)
	if ply:IsAdmin() and (ply:Team() == TEAM_ADMIN or ply:Team() == TEAM_MOD) and ent:IsPlayer() and CamoIsEnabled(ent) then
		DisableCamo(ply)
	end
end
hook.Add("PhysgunPickup", "Camo.RemoveOnPhysgun", RemoveCamoOnPhysgun)

local function CheckPlayerDead(ply)
	if CamoIsEnabled(ply) then
		DisableCamo(ply)
	end
end
hook.Add("PlayerDeath", "Camo.RemoveOnDeath", CheckPlayerDead)
hook.Add("OnPlayerChangedTeam", "Camo.RemoveOnJobChange", CheckPlayerDead)