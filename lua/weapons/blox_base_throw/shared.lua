AddCSLuaFile()

SWEP.PrintName = "Bloxxer's Arsenal Base Throwing"
SWEP.Base = "blox_base"
SWEP.Category = "Bloxxer's Arsenal"
SWEP.Spawnable = false

SWEP.Author = "8Z"
SWEP.Instructions = "Left Click: Throw Forwards\nRight Click: Toss Upwards"

SWEP.ViewModel = "models/weapons/bloxxers_arsenal/v_superball.mdl"
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 70
SWEP.UseHands = true

DEFINE_BASECLASS(SWEP.Base)

SWEP.ThrowEntity = "sent_ball"
SWEP.ThrowForce = 2000
SWEP.ThrowCooldown = 1.2
SWEP.ThrowDelay = 0.1
SWEP.ThrowOriginOffset = Vector(16, 16, 8)

SWEP.AltThrowEntity = nil
SWEP.AltThrow = true
SWEP.AltThrowForce = 500
SWEP.AltThrowDelay = 0.1
SWEP.AltThrowAngle = Angle(0, 0, 0)

SWEP.PogoLimit = 3
SWEP.PogoForce = 500
SWEP.PogoForceMin = 150
SWEP.PogoMaxVelocity = math.huge
SWEP.PogoMinVelocity = -math.huge

sound.Add({
    name = "BloxxersArsenal.Superball.Draw",
    sound = "bloxxers_arsenal/superball/boing.wav",
    level = 70,
    channel = CHAN_WEAPON,
})
sound.Add({
    name = "BloxxersArsenal.Superball.Throw",
    sound = "bloxxers_arsenal/superball/boing.wav",
    level = 70,
    channel = CHAN_WEAPON,
})

SWEP.DrawSound = Sound("BloxxersArsenal.Superball.Draw")
SWEP.ThrowSound = Sound("BloxxersArsenal.Superball.Throw")

SWEP.HoldType = "grenade"

function SWEP:SetupDataTables()
    BaseClass.SetupDataTables(self)
    self:NetworkVar("Float", 2, "NextThrowRelease")
    self:NetworkVar("Bool", 0, "ThrowAlt")

end

function SWEP:PrimaryAttack()
    local owner = self:GetOwner()

    local anim = "throw"

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    vm:SetPlaybackRate(1)
    self:UpdateNextIdle()

    self:EmitSound(self.ThrowSound)

    self:SetNextPrimaryFire(CurTime() + self.ThrowCooldown)
    self:SetNextThrowRelease(CurTime() + self.ThrowDelay)
    self:SetThrowAlt(false)

    owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE)

    if IsFirstTimePredicted() and self:AllowPogo() then
        if SERVER then
            self:GetOwner():SetVelocity(Vector(0, 0, math.min(0, self:GetOwner():GetVelocity().z) * -1 + Lerp((self.PogoCounter / self.PogoLimit) ^ 0.5, self.PogoForce, self.PogoForceMin)))
        end
        self.PogoCounter = self.PogoCounter + 1
    end
end

function SWEP:SecondaryAttack()
    if self:GetNextPrimaryFire() > CurTime() then return end
    if not self.AltThrow then return end
    local owner = self:GetOwner()

    local anim = "throw2"

    local vm = owner:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    vm:SetPlaybackRate(1)
    self:UpdateNextIdle()

    self:EmitSound(self.ThrowSound)

    self:SetNextPrimaryFire(CurTime() + self.ThrowCooldown)
    self:SetNextThrowRelease(CurTime() + self.AltThrowDelay)
    self:SetThrowAlt(true)

    owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM)
end

function SWEP:ThrowProjectile()
    if CLIENT then return end
    local owner = self:GetOwner()
    local alt = self:GetThrowAlt()

    local proj = ents.Create(alt and self.AltThrowEntity or self.ThrowEntity)
    if not IsValid(proj) then return end

    local origin = owner:GetShootPos()
    local ang = owner:GetAimVector():Angle()

    if self.ThrowOriginOffset then
        origin:Add(ang:Right() * self.ThrowOriginOffset.x)
        origin:Add(ang:Forward() * self.ThrowOriginOffset.y)
        origin:Add(ang:Up() * self.ThrowOriginOffset.z)
    end

    proj:SetPos(origin)
    proj:SetOwner(owner)
    proj:Spawn()

    if alt then
        if self.AltThrowAngle then
            local ang2 = Angle(ang)
            ang.p = 0
            ang:RotateAroundAxis(ang2:Right(), self.AltThrowAngle.p)
            ang:RotateAroundAxis(ang2:Forward(), self.AltThrowAngle.y)
            ang:RotateAroundAxis(ang2:Up(), self.AltThrowAngle.r)
        end
        proj:GetPhysicsObject():SetVelocity(ang:Forward() * self.AltThrowForce)
    else
        proj:GetPhysicsObject():SetVelocity(owner:GetAimVector() * self.ThrowForce)
    end
end


function SWEP:Think()
    BaseClass.Think(self)

    local curtime = CurTime()

    local releasetime = self:GetNextThrowRelease()
    if releasetime > 0 and curtime > releasetime then
        self:ThrowProjectile()
        self:SetNextThrowRelease(0)
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
    self:SetNextThrowRelease(0)
    return true
end