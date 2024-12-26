AddCSLuaFile()

SWEP.PrintName = "Linked Sword"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "8Z"
SWEP.Description = "With blood and iron."

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_sword.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = ""

SWEP.DrawAmmo = false

SWEP.SwingSound = Sound("WeaponFrag.Throw")
SWEP.LungeSound = Sound("WeaponFrag.Throw")
SWEP.HitSound = Sound("weapons/knife/knife_hitwall1.wav")

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