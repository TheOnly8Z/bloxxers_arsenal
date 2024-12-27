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

local BounceSound = Sound( "garrysmod/balloon_pop_cute.wav" )
function ENT:PhysicsCollide(data, physobj)
    local attempt_bounceback = false

    if data.Speed > 60 and data.DeltaTime > 0.15 then
        local pitch = Lerp((data.Speed - 60) / 100, 90, 110)
        sound.Play(BounceSound, self:GetPos(), 75, math.random(pitch - 10, pitch + 10), math.Clamp(data.Speed / 150, 0, 1))

        local ent = data.HitEntity
        if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:Health() > 0) then
            local dmg = DamageInfo()
            dmg:SetAttacker(self:GetOwner())
            dmg:SetInflictor(self)
            dmg:SetDamage(50)
            dmg:SetDamageType(DMG_CRUSH)
            dmg:SetDamagePosition(data.HitPos)
            dmg:SetDamageForce(data.OurOldVelocity)
            ent:TakeDamageInfo(dmg)
            attempt_bounceback = true
        end
    end

    local speed_mult = 0.9
    local new_dir = physobj:GetVelocity()
    new_dir:Normalize()
    local last_speed = math.max(data.OurOldVelocity:Length(), data.Speed)
    last_speed = math.max(new_dir:Length(), last_speed)

    if attempt_bounceback and IsValid(self:GetOwner()) then
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
            if len <= 4000 then
                new_dir = (self:GetOwner():EyePos() + Vector(0, 0, math.max(len - 256, 0) * 0.5) - self:GetPos()):GetNormalized()
                speed_mult = 0.9
            end
        end
    end

    physobj:SetVelocity(new_dir * last_speed * speed_mult)
end