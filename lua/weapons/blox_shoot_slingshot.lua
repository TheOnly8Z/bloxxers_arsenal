AddCSLuaFile()

SWEP.PrintName = "Slingshot"
SWEP.Base = "blox_base_shoot"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "speedonerd, 8Z"
SWEP.Instructions = "Left Click: Shoot \nRight Click: Toss coin "
SWEP.Description = "Pelt your foes with little pebbles until they fear you!"
SWEP.Tips = [[- The Slingshot and most other guns can </color><color=255,120,120,255>headshot</color><color=150,150,150,255> for additional damage.

- Alternate fire will toss a </color><color=255,229,97,255>coin.</color><color=150,150,150,255> Hit this coin with a sword or shot projectile to send it flying towards the nearest enemy, dealing massive damage.

- Shooting a Time Bomb or Subspace Tripmine will instantly trigger it, bypassing its fuse time. This can be used in combat or to make explosive jumps easier. 
]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_slingshot.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.Slot = 1

SWEP.ShootEntity = "blox_proj_paintball"
SWEP.ShootForce = 4000
SWEP.ShootCooldown = 0.25
SWEP.ShootDelay = 0
SWEP.ShootOriginOffset = Vector(16, 20, 0)

SWEP.PogoLimit = 0

SWEP.HoldType = "pistol"

sound.Add({
    name = "BloxxersArsenal.Slingshot.Shoot",
    sound = "bloxxers_arsenal/slingshot/slingshot.wav",
    level = 70,
    channel = CHAN_WEAPON,
})

SWEP.ShootSound = Sound("BloxxersArsenal.Slingshot.Shoot")