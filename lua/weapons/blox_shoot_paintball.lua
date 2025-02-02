AddCSLuaFile()

SWEP.PrintName = "Paintball Gun"
SWEP.Base = "blox_base_shoot"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "speedonerd, 8Z"
SWEP.Instructions = "Left Click: Shoot"
SWEP.Description = "A non-violent weapon that is just for fun. Chase your friends around and paint the town red!"
SWEP.Tips = [[- The Paintball Gun and most other guns can </color><color=255,120,120,255>headshot</color><color=150,150,150,255> for additional damage.

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
SWEP.ShootOriginOffset = Vector(16, 20, 0)

SWEP.PogoLimit = 0

SWEP.HoldType = "pistol"