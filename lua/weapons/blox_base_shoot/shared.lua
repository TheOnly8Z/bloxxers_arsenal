-- wip shooting base derived from throwing
AddCSLuaFile()

SWEP.PrintName = "Bloxxer's Arsenal Base Shooting"
SWEP.Base = "blox_base"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = false

SWEP.Author = "8Z & speedonerd"
SWEP.Instructions = "Left Click: Shoot\nRight Click: Alternate fire"

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_paintball.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

DEFINE_BASECLASS(SWEP.Base)

SWEP.ShootEntity = "sent_paintball"
SWEP.ShootForce = 2000
SWEP.ShootCooldown = 0.8
SWEP.ShootDelay = 0
SWEP.ShootOriginOffset = Vector(16, 16, 8)
SWEP.ProjectileAngles = Angle()
SWEP.ShootCorrectionTrace = true

SWEP.AltShootEntity = nil
SWEP.AltShoot = false
SWEP.AltShootForce = 500
SWEP.AltShootDelay = 0
SWEP.AltShootCooldown = nil

SWEP.PogoLimit = 3
SWEP.PogoForce = 500
SWEP.PogoForceMin = 150
SWEP.PogoMaxVelocity = math.huge
SWEP.PogoMinVelocity = -math.huge

-- sound.Add({
    -- name = "BloxxersArsenal.Superball.Draw",
    -- sound = "bloxxers_arsenal/superball/boing.wav",
    -- level = 70,
    -- channel = CHAN_WEAPON,
-- })
sound.Add({
    name = "BloxxersArsenal.Paintball.Shoot",
    sound = "bloxxers_arsenal/paintball/shoot.wav",
    level = 70,
    channel = CHAN_WEAPON,
})

SWEP.DrawSound = nil
SWEP.ShootSound = Sound("BloxxersArsenal.Paintball.Shoot")

SWEP.HoldType = "pistol"

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 2, "NextShootDelay")
    self:NetworkVar("Bool", 0, "ShootAlt")

end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()

    local anim = "shoot"

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

function SWEP:SecondaryAttack()
    if self:GetNextPrimaryFire() > CurTime() then return end
    if not self.AltShoot then return end
    local owner = self:GetOwner()

    local anim = "shoot_alt"

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    vm:SetPlaybackRate(1)
    self:UpdateNextIdle()

    self:EmitSound(self.ShootSound)

    self:SetNextPrimaryFire(CurTime() + (self.AltShootCooldown or self.ShootCooldown))
    self:SetNextShootDelay(CurTime() + self.AltShootDelay)
    self:SetShootAlt(true)

    owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM)
end

function SWEP:ShootProjectile()
    if CLIENT then return end
    local owner = self:GetOwner()
    local alt = self:GetShootAlt()

    local proj = ents.Create(alt and self.AltShootEntity or self.ShootEntity)
    if not IsValid(proj) then return end

    local origin = owner:GetShootPos()
    local aimang = owner:GetAimVector():Angle()
    local ang = Angle(aimang)

    if self.ShootOriginOffset then
        origin:Add(ang:Right() * self.ShootOriginOffset.x)
        origin:Add(ang:Forward() * self.ShootOriginOffset.y)
        origin:Add(ang:Up() * self.ShootOriginOffset.z)
    end

    if self.ShootCorrectionTrace then
        local tr = util.TraceLine({
            start = origin,
            endpos = owner:GetShootPos() + aimang:Forward() * 4000,
            filter = {self, self:GetOwner()},
            mask = MASK_SOLID
        })
        if tr.Hit then
            aimang = tr.Normal:Angle()
        end
    end

    if self.ProjectileAngles then
        ang:RotateAroundAxis(aimang:Right(), self.ProjectileAngles.p)
        ang:RotateAroundAxis(aimang:Forward(), self.ProjectileAngles.y)
        ang:RotateAroundAxis(aimang:Up(), self.ProjectileAngles.r)
    end


    proj:SetPos(origin)
    proj:SetAngles(ang)
    proj.ProjectileAngle = aimang:Forward()
    proj:SetOwner(owner)
    proj:Spawn()

    if alt then
        proj:GetPhysicsObject():SetVelocity(aimang:Forward() * self.AltShootForce)
    else
        proj:GetPhysicsObject():SetVelocity(aimang:Forward() * self.ShootForce)
    end
end


function SWEP:Think()
    BaseClass.Think(self)

    local curtime = CurTime()

    local releasetime = self:GetNextShootDelay()
    if releasetime > 0 and curtime > releasetime then
        self:ShootProjectile()
        self:SetNextShootDelay(0)
    end
end


function SWEP:Deploy()
    BaseClass.Deploy(self)
    if self:GetOwner():IsPlayer() then
        local clr = self:GetOwner():GetWeaponColor():ToColor()
        self:SetColor(clr)
        self:GetOwner():GetViewModel():SetColor(clr)
    end
    return true
end

function SWEP:Holster()
    BaseClass.Holster(self)
    self:GetOwner():GetViewModel():SetColor(color_white)
    self:SetNextShootDelay(0)
    return true
end