AddCSLuaFile()

SWEP.PrintName = "Paintball Gun"
SWEP.Base = "blox_base_shoot"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "speedonerd"
SWEP.Instructions = "Left Click: Shoot"
SWEP.Description = "A sporting device which uses compressed air to shoot balls of paint. Very safe and definitely non-lethal."
SWEP.Tips = [[- The paintball gun's projectiles can synergize with other items.

- Shooting a Time Bomb or Subspace Tripmine will instantly trigger it, bypassing its fuse time. This can be used in combat or to make explosive jumps easier. 
]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_paintball.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.Slot = 1

SWEP.ShootEntity = "blox_proj_paintball"
SWEP.ShootForce = 6000
SWEP.ShootCooldown = 0.6
SWEP.ShootDelay = 0
SWEP.ShootOriginOffset = Vector(0, 20, 0)

SWEP.HoldType = "pistol"