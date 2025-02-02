AddCSLuaFile()

SWEP.PrintName = "Rocket Launcher"
SWEP.Base = "blox_base_shoot"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = true

SWEP.Author = "speedonerd, 8Z"
SWEP.Instructions = "Left Click: Fast Rocket\nRight Click: Slow Rocket"
SWEP.Description = "Do not point directly at face (unless it's your enemy's face)."
SWEP.Tips = [[- Slow rockets and rockets that immediately detonate have a shorter cooldown.

- Rockets do significantly more damage on a </color><color=255,120,120,255>direct hit</color><color=150,150,150,255>, indicated by sparks on impact.

- You can </color><color=255,220,120,255>blast jump</color><color=150,150,150,255> with the rockets, taking a little self damage and launching a fair distance.

- Shoot at bombs to detonate them. </color><color=255,120,120,255>Direct hits</color><color=150,150,150,255> will create a powerful </color><color=220,120,255,255>explosive combo</color><color=150,150,150,255>!]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_rocketlauncher.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Slot = 1

SWEP.ShootEntity = "blox_proj_rocket"
SWEP.ShootForce = 3500
SWEP.ShootCooldown = 5
SWEP.ShootDelay = 0
SWEP.ShootOriginOffset = Vector(10, 24, 0)
SWEP.ProjectileAngles = Angle(0, 0, 90)

SWEP.AltShoot = true
SWEP.AltShootForce = 750
SWEP.AltShootCooldown = 3.5

SWEP.HoldType = "rpg"

sound.Add({
    name = "BloxxersArsenal.Rocket.Shoot",
    sound = "bloxxers_arsenal/rocketlauncher/shoulder_fired_rocket.wav",
    level = 70,
    pitch = 108,
    channel = CHAN_WEAPON,
})

sound.Add({
    name = "BloxxersArsenal.Rocket.ShootAlt",
    sound = "bloxxers_arsenal/rocketlauncher/shoulder_fired_rocket.wav",
    level = 70,
    pitch = 100,
    channel = CHAN_WEAPON,
})

sound.Add({
    name = "BloxxersArsenal.Rocket.Swoosh",
    sound = "bloxxers_arsenal/rocketlauncher/swoosh.wav",
    level = 80,
    pitch = 100,
    channel = CHAN_WEAPON,
})

SWEP.DrawSound = nil
SWEP.ShootSound = Sound("BloxxersArsenal.Rocket.Shoot")
SWEP.AltShootSound = Sound("BloxxersArsenal.Rocket.ShootAlt")


function SWEP:PrimaryAttack()
    local owner = self:GetOwner()

    local anim = "shoot"

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    vm:SetPlaybackRate(1)
    self:UpdateNextIdle()

    owner:ViewPunch(Angle(math.Rand(-1, -3), 0, math.Rand(-2, 2)))

    self:EmitSound(self.ShootSound)

    self:SetNextPrimaryFire(CurTime() + self.ShootCooldown)
    self:SetNextShootDelay(CurTime() + self.ShootDelay)
    self:SetShootAlt(false)

    owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
end


function SWEP:SecondaryAttack()
    if self:GetNextPrimaryFire() > CurTime() then return end
    local owner = self:GetOwner()

    local anim = "shoot"

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    vm:SetPlaybackRate(1)
    self:UpdateNextIdle()

    owner:ViewPunch(Angle(math.Rand(-1, -3), 0, math.Rand(-2, 2)))

    self:EmitSound(self.AltShootSound)

    self:SetNextPrimaryFire(CurTime() + self.AltShootCooldown)
    self:SetNextShootDelay(CurTime() + self.ShootDelay)
    self:SetShootAlt(true)

    owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
end
