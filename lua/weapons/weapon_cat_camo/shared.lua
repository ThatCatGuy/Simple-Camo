SWEP.PrintName 					= "Camo"
SWEP.Slot 						= 2
SWEP.SlotPos 					= 0
SWEP.DrawAmmo 					= false
SWEP.Author 					= ""
SWEP.Instructions				= "Left click to go invisible."
SWEP.Contact 					= ""
SWEP.Purpose 					= ""
SWEP.ViewModel 					= "models/weapons/v_hands.mdl"
SWEP.WorldModel					= ""
SWEP.ViewModelFOV 				= 62
SWEP.ViewModelFlip 				= false
SWEP.Spawnable 					= true
SWEP.AdminSpawnable 			= true

SWEP.UseHands 					= false
SWEP.Category 					= "CatGuy Sweps"
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 0
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= ""
SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= 0
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= ""

function SWEP:SecondaryAttack()
	return
end

function SWEP:DrawWorldModel()
	return false
end

function SWEP:Reload()
	return
end

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end