AddCSLuaFile()

SWEP.PrintName = "Paintball Gun"
SWEP.Base = "blox_base_shoot"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = false

SWEP.Author = "speedonerd"
SWEP.Instructions = "Left Click: Shoot"
SWEP.Description = "A gun which uses compressed air to shoot balls of paint. Totally non-lethal and completely safe."
SWEP.Tips = [[- The Superball loses bounciness and damage with each bounce after the third.

- Certain weapons can </color><color=220,120,255,255>reflect</color><color=150,150,150,255> the Superball and reset its bounce count.

- Throw a ball at your feet while mid-air to </color><color=255,220,120,255>pogo</color><color=150,150,150,255>. This can be done at any vertical velocity, but only a few times.]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_paintball.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.Slot = 1

SWEP.ShootEntity = "blox_proj_superball"
SWEP.ShootForce = 2000
SWEP.ShootCooldown = 0.5
SWEP.ShootDelay = 0
SWEP.ShootOriginOffset = Vector(0, 0, 8)

SWEP.HoldType = "pistol"