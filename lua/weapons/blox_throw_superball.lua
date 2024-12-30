AddCSLuaFile()

SWEP.PrintName = "Superball"
SWEP.Base = "blox_base_throw"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "8Z"
SWEP.Description = "Super Happy Bouncy Fun Ball. For entertainment purposes only."
SWEP.Tips = [[- The Superball loses bounciness and damage with each bounce after the third.

- Certain weapons can </color><color=220,120,255,255>reflect</color><color=150,150,150,255> the Superball and reset its bounce count.

- Throw a ball at your feet while mid-air to </color><color=255,220,120,255>pogo</color><color=150,150,150,255>. This can be done at any vertical velocity, but only a few times.]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_superball.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.Slot = 3

SWEP.ThrowEntity = "blox_proj_superball"
SWEP.ThrowForce = 2000
SWEP.ThrowCooldown = 1.1
SWEP.ThrowDelay = 0.08

SWEP.AltThrowForce = 750
SWEP.AltThrowDelay = 0.1
SWEP.AltThrowAngle = Angle(60, 0, 0)

SWEP.HoldType = "grenade"