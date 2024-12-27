AddCSLuaFile()

SWEP.PrintName = "Superball"
SWEP.Base = "blox_base_throw"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "8Z"
SWEP.Description = "Super Happy Bouncy Fun Ball. For entertainment purposes only."
SWEP.Tips = [[- The Superball's damage scales with its velocity, which reduces with each bounce.

- Certain weapons can </color><color=255,220,120,255>redirect</color><color=150,150,150,255> the Superball, resetting its velocity and bounce count.

- Throw a ball at your feet while mid-air to </color><color=255,220,120,255>pogo</color><color=150,150,150,255>.]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_superball.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.ThrowEntity = "blox_proj_superball"
SWEP.ThrowForce = 2000
SWEP.ThrowCooldown = 1
SWEP.ThrowDelay = 0.08

SWEP.AltThrowForce = 500
SWEP.AltThrowDelay = 0.1
SWEP.AltThrowAngle = Angle(60, 0, 0)