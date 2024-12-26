AddCSLuaFile()

SWEP.PrintName = "Linked Sword"
SWEP.Base = "blox_base_sword"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "8Z"
SWEP.Description = "With blood and iron."

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_sword.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.HitDistance = 96
SWEP.HitDistanceLunge = 128

SWEP.HitDelay = 0.08
SWEP.HitForceScale = 80
SWEP.SwingCooldown = 0.3
SWEP.SwingCooldownLunge = 0.75

SWEP.ComboCount = 2
SWEP.ComboResetTime = 0.4

SWEP.PogoLimit = 6
SWEP.PogoForce = 250
SWEP.PogoForceLunge = 500
SWEP.PogoCounter = 0

-- Bounds of the punch's hull trace
SWEP.HitSize = {
    Min = Vector(-32, -10, -8),
    Max = Vector(32, 10, 8)
}

SWEP.HitSizeLunge = {
    Min = Vector(-10, -10, -8),
    Max = Vector(10, 10, 8)
}

SWEP.HitDamage = 30
SWEP.ComboDamage = 60