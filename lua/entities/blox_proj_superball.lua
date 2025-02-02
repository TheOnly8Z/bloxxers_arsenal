AddCSLuaFile()
ENT.PrintName = "Superball Projectile"
ENT.Base = "blox_proj_base"

DEFINE_BASECLASS(ENT.Base)

ENT.Model = "models/weapons/bloxxers_arsenal/projectiles/superball.mdl"
ENT.PhysicsMaterial = "metal_bouncy"
ENT.PhysicsSphere = 15

ENT.GravityMultiplier = 3
ENT.Buoyancy = 0.01
ENT.LifeTime = 6

ENT.MinBounces = 3
ENT.MaxBounces = 12
ENT.BounceSpeedMax = 0.9
ENT.BounceSpeedMin = 0.5

ENT.DamageSpeedThreshold = 1200
ENT.Damage = 50
ENT.DamageMin = 25

ENT.ReflectSpeed = 2000

ENT.Bounces = 0

ENT.Resets = 0
ENT.MaxResets = 10

function ENT:Initialize()
    BaseClass.Initialize(self)

    if SERVER then
        self:SetColor(BLOXXERS_ARSENAL.RandomBrickColor())
    end
end

function ENT:Think()
    BaseClass.Think(self)

    -- Never despawn when held
    if SERVER and self:IsPlayerHolding() then
        self.SpawnTime = CurTime()
    end
end

local BounceSound = Sound( "bloxxers_arsenal/superball/boing.wav" )
function ENT:PhysicsCollide(data, physobj)
    local hit_enemy = false
    local ent = data.HitEntity

    -- When superballs hit each other, the older one gets refreshed
    if ent:GetClass() == self:GetClass() then
        self.SpawnTime = math.max(self.SpawnTime, ent.SpawnTime)
        self.Bounces = math.min(self.Bounces, ent.Bounces)
    end

    if not self:IsPlayerHolding() and data.Speed > 60 then
        local lifedelta = math.Clamp(math.max(self.Bounces - self.MinBounces, 0) / self.MaxBounces, 0, 1) --math.Clamp((CurTime() - self.SpawnTime) / self.LifeTime, 0, 1)

        local pitch = Lerp(lifedelta, 100, 90)
        sound.Play(BounceSound, self:GetPos(), 75, math.random(pitch - 5, pitch + 5), math.Clamp(data.Speed / 1000, 0, 0.9))

        if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:Health() > 0) then
            local dmg = DamageInfo()
            dmg:SetAttacker(self:GetOwner())
            dmg:SetInflictor(self)
            dmg:SetDamage(Lerp(lifedelta, self.Damage, self.DamageMin))
            dmg:SetDamageType(DMG_GENERIC)
            dmg:SetDamagePosition(data.HitPos)
            dmg:SetDamageForce(data.OurOldVelocity * 30)

            ent:TakeDamageInfo(dmg)
            hit_enemy = true
        end

        if ent:GetPhysicsObject():IsValid() then
            ent:GetPhysicsObject():ApplyForceOffset(data.OurOldVelocity * ent:GetPhysicsObject():GetMass() ^ 0.5, data.HitPos)
        end

        local speed_mult = Lerp(lifedelta ^ 2, self.BounceSpeedMax, self.BounceSpeedMin)
        local old_vel = data.OurOldVelocity
        local new_dir = physobj:GetVelocity()
        new_dir:Normalize()
        local last_speed = math.max(data.OurOldVelocity:Length(), data.Speed)
        last_speed = math.max(new_dir:Length(), last_speed)

        if hit_enemy and self.Reflected then
            -- After reflecting, the Superball can plow through weak enemies like a bowling ball!
            timer.Simple(0, function()
                if IsValid(self) and IsValid(physobj) and (not IsValid(ent) or ent:Health() <= 0) then
                    physobj:SetVelocity(old_vel * 0.95)
                end
            end)
        elseif hit_enemy and IsValid(self:GetOwner()) then
            -- Check LOS between owner and ball
            local tr = util.TraceLine({
                start = self:GetPos(),
                endpos = self:GetOwner():EyePos(),
                filter = {self, self:GetOwner(), ent},
                mask = MASK_SOLID,
            })
            if tr.Fraction >= 1 then
                local diff = self:GetOwner():EyePos() - self:GetPos()
                local len = diff:Length()
                if len <= 2000 then
                    -- TODO This should calculate upwards angle so that the ball lands in front of the player without a bounce
                    new_dir = (self:GetOwner():EyePos() - self:GetPos()):GetNormalized()
                    speed_mult = 0.9
                end
            end
        end
        self.Bounces = self.Bounces + 1
        physobj:SetVelocity(new_dir * last_speed * speed_mult)
    end
    if self.Bounces >= self.MaxBounces and data.Speed <= 96 then
        SafeRemoveEntity(self)
        return
    end

end

function ENT:OnRemove()
    if SERVER then
        local eff = EffectData()
        eff:SetOrigin(self:GetPos())
        eff:SetStart(self:GetColor():ToVector())
        util.Effect("superball_pop", eff)
    end
end

function ENT:OnReflect(dmg)
    local attacker = dmg:GetAttacker()
    if attacker:IsPlayer() then
        self:SetOwner(attacker)
        local physobj = self:GetPhysicsObject()
        self.Reflected = true
        local speed = math.max(self.ReflectSpeed, physobj:GetVelocity():Length())
        physobj:SetVelocity(self:GetOwner():GetAimVector() * speed)
        if self.Resets < self.MaxResets then
            self.SpawnTime = CurTime()
            self.Bounces = 0
            self.Resets = self.Resets + 1
        end
    end
    return true
end

function ENT:GravGunPunt(ply)
    self:SetOwner(ply)
    self.Reflected = true
    if self.Resets < self.MaxResets then
        self.SpawnTime = CurTime()
        self.Bounces = 0
        self.Resets = self.Resets + 1
    end
    timer.Simple(0, function()
        if IsValid(self) and IsValid(self:GetPhysicsObject()) then
            self:GetPhysicsObject():SetVelocityInstantaneous(self:GetVelocity():GetNormalized() * self.ReflectSpeed)
        end
    end)
    return true
end