AddCSLuaFile()

SWEP.PrintName = "Rocket Launcher"
SWEP.Base = "blox_base_shoot"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = false

SWEP.Author = "speedonerd"
SWEP.Instructions = "Left Click: Shoot"
SWEP.Description = "Do not point directly at face (unless it's your enemy's face)."
SWEP.Tips = [[yeah]]

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_rocketlauncher.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

SWEP.Slot = 1

SWEP.ShootEntity = "blox_proj_paintball"
SWEP.ShootForce = 6000
SWEP.ShootCooldown = 3.6
SWEP.ShootDelay = 0
SWEP.ShootOriginOffset = Vector(0, 20, 0)

SWEP.HoldType = "rpg"

sound.Add({
    name = "BloxxersArsenal.Rocket.Shoot",
    sound = "bloxxers_arsenal/rocketlauncher/swoosh.wav",
    level = 70,
    channel = CHAN_WEAPON,
})

SWEP.DrawSound = nil
SWEP.ShootSound = Sound("BloxxersArsenal.Rocket.Shoot")


function SWEP:PrimaryAttack()
    local owner = self:GetOwner()

    local anim = "shoot_then_reload"

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    vm:SetPlaybackRate(1)
    self:UpdateNextIdle()

    self:EmitSound(self.ShootSound)

    self:SetNextPrimaryFire(CurTime() + self.ShootCooldown)
    self:SetNextShootDelay(CurTime() + self.ShootDelay)
    self:SetShootAlt(false)

    owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL)

    if IsFirstTimePredicted() and self:AllowPogo() then
        if SERVER then
            self:GetOwner():SetVelocity(Vector(0, 0, math.min(0, self:GetOwner():GetVelocity().z) * -1 + Lerp((self.PogoCounter / self.PogoLimit) ^ 0.5, self.PogoForce, self.PogoForceMin)))
        end
        self.PogoCounter = self.PogoCounter + 1
    end
end