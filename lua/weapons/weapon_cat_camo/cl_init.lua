include("shared.lua")

SWEP.PrintName = "Camo"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

local CamoActivate = Sound("HL1/fvox/activated.wav")
local CamoDeactivate = Sound("HL1/fvox/deactivated.wav")

local CamoMat = Material("models/props_combine/com_shield001a")

local colorMofify = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

Camo = Camo or {}
local camoActive = false

function Camo.IsEnabled(ply)
	return ply.Camo
end

net.Receive("CamoDisable", function()
	local player = net.ReadEntity()
	if !player then return end
	if player == LocalPlayer() then
		surface.PlaySound(CamoDeactivate)
		camoActive = false
	end
	player.Camo = false
end)

net.Receive("CamoEnable", function()
	local player = net.ReadEntity()
	if !player then return end
	if player == LocalPlayer() then
		surface.PlaySound(CamoActivate)
		camoActive = true
	end
	player.Camo = true
end)

local function DrawCamoEffects()
	if camoActive then
		DrawColorModify(colorMofify)
		DrawMotionBlur(0.1, 0.5, 0.01)
		DrawToyTown(2,ScrH()/2)
	end
end
hook.Add("RenderScreenspaceEffects", "Camo.ShowEffects", DrawCamoEffects)

local function DrawPlayerMaterial(ply)
	if Camo.IsEnabled(ply) then
		render.ModelMaterialOverride(CamoMat)
	end
end
hook.Add("PrePlayerDraw", "Camo.SetPlayersMaterial", DrawPlayerMaterial)

local function RemoveCamoMaterial(ply)
	render.ModelMaterialOverride()
	if Camo.IsEnabled(ply) then 
		ply:SetNoDraw(false)
	end
end
hook.Add("PostPlayerDraw", "Camo.ResetMaterialOverride", RemoveCamoMaterial)

hook.Add("InitPostEntity", "Camo.BugFix", function() camoActive = false end)