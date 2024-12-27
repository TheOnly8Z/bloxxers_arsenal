AddCSLuaFile()
ENT.PrintName = "Superball Projectile"
ENT.Base = "blox_proj_base"

DEFINE_BASECLASS(ENT.Base)

ENT.Model = "models/weapons/bloxxers_arsenal/projectiles/superball.mdl"
ENT.PhysicsMaterial = "metal_bouncy"
ENT.PhysicsSphere = 12.5

ENT.GravityMultiplier = 3
ENT.Buoyancy = 0
ENT.LifeTime = 10

ENT.MinBounces = 5
ENT.MaxBounces = 15
ENT.BounceSpeedMax = 0.9
ENT.BounceSpeedMin = 0.4

ENT.DamageSpeedThreshold = 1200
ENT.Damage = 50
ENT.DamageMin = 20

ENT.ReflectSpeed = 2500

ENT.Bounces = 0

local BounceSound = Sound( "garrysmod/balloon_pop_cute.wav" )
function ENT:PhysicsCollide(data, physobj)
    local hit_enemy = false
    local ent = data.HitEntity

    if data.Speed > 60 and data.DeltaTime > 0.15 then
        local pitch = Lerp((data.Speed - 60) / 100, 90, 110)
        sound.Play(BounceSound, self:GetPos(), 75, math.random(pitch - 10, pitch + 10), math.Clamp(data.Speed / 150, 0, 1))

        if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:Health() > 0) then
            local dmg = DamageInfo()
            dmg:SetAttacker(self:GetOwner())
            dmg:SetInflictor(self)
            dmg:SetDamage(Lerp((data.Speed / self.DamageSpeedThreshold) ^ 0.5, self.DamageMin, self.Damage))
            dmg:SetDamageType(DMG_CRUSH + DMG_CLUB)
            dmg:SetDamagePosition(data.HitPos)
            dmg:SetDamageForce(data.OurOldVelocity)
            ent:TakeDamageInfo(dmg)
            print(ent, data.Speed, math.Round(dmg:GetDamage(), 1))
            hit_enemy = true
        end
    end

    local speed_mult = Lerp((math.max(self.Bounces - self.MinBounces, 0) / (self.MaxBounces - self.MinBounces)) ^ 2, self.BounceSpeedMax, self.BounceSpeedMin)
    local old_vel = data.OurOldVelocity
    local new_dir = physobj:GetVelocity()
    new_dir:Normalize()
    local last_speed = math.max(data.OurOldVelocity:Length(), data.Speed)
    last_speed = math.max(new_dir:Length(), last_speed)

    if hit_enemy and self.Reflected then
        -- After reflecting, the Superball can plow through weak enemies like a bowling ball!
        timer.Simple(0.02, function()
            if IsValid(self) and IsValid(physobj) and (not IsValid(ent) or ent:Health() <= 0) then
                physobj:SetVelocity(old_vel * 0.8)
            end
        end)
    elseif hit_enemy and IsValid(self:GetOwner()) then
        -- Check LOS between owner and ball
        local tr = util.TraceLine({
            start = self:GetPos(),
            endpos = self:GetOwner():EyePos(),
            filter = {self, self:GetOwner()},
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
    if self.Bounces >= self.MaxBounces and data.Speed <= 100 then
        SafeRemoveEntity(self)
        return
    end

    physobj:SetVelocity(new_dir * last_speed * speed_mult)
end

function ENT:OnRemove()
    local eff = EffectData()
    eff:SetOrigin(self:GetPos())
    util.Effect("balloon_pop", eff)
end

function ENT:OnReflect(dmg)
    local attacker = dmg:GetAttacker()
    if attacker == self:GetOwner() then
        local physobj = self:GetPhysicsObject()
        self.Reflected = true
        local speed = math.max(self.ReflectSpeed, physobj:GetVelocity():Length())
        physobj:SetVelocity(self:GetOwner():GetAimVector() * speed)
        self.LifeTime = self.LifeTime + 2
        self.Bounces = 0
    end
end