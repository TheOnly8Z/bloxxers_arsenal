AddCSLuaFile()

SWEP.PrintName = "Timebomb"
SWEP.Base = "blox_base_throw"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "8Z"
SWEP.Instructions = "Left Click: Toss\nRight Click: Place"
SWEP.Description = "Tick tick boom boom!"
SWEP.Tips = [[- The Timebomb is powerful but doesn't go places by itself. Consider nudging it with something else.

- You are immune to your own Timebombs, and can be launched very far by the explosion.]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_timebomb.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 80
SWEP.UseHands = true

SWEP.Slot = 4

SWEP.DrawSound = ""
SWEP.ThrowSound = ""

SWEP.ThrowOriginOffset = Vector(12, 16, -12)

SWEP.ThrowEntity = "blox_proj_timebomb"
SWEP.ThrowForce = 400
SWEP.ThrowCooldown = 7
SWEP.ThrowDelay = 0.1

SWEP.AltThrowForce = 0
SWEP.AltThrowDelay = 0.15
SWEP.AltThrowAngle = Angle(-45, 0, 0)

SWEP.PogoLimit = 0

SWEP.HoldType = "slam"