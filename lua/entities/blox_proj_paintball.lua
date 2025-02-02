AddCSLuaFile()
ENT.PrintName = "Superball Projectile"
ENT.Base = "blox_proj_base"
DEFINE_BASECLASS(ENT.Base)
ENT.Model = "models/weapons/bloxxers_arsenal/projectiles/smallball.mdl"
ENT.PhysicsMaterial = "metal_bouncy"
ENT.PhysicsSphere = 4
ENT.GravityMultiplier = 1
ENT.Buoyancy = 0.01
ENT.LifeTime = 0
ENT.DamageSpeedThreshold = 0
ENT.Damage = 25

function ENT:Initialize()
    BaseClass.Initialize(self)

    if SERVER then
        self:SetColor(BLOXXERS_ARSENAL.RandomBrickColor())
    end
end

function ENT:Think()
    BaseClass.Think(self)
end

function ENT:PhysicsCollide(data, physobj)
    local ent = data.HitEntity

    if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() or ent:Health() > 0) then
        local dmg = DamageInfo()
        dmg:SetAttacker(self:GetOwner())
        dmg:SetInflictor(self)
        dmg:SetDamage(self.Damage)
        dmg:SetDamageType(DMG_BULLET)
        dmg:SetDamagePosition(data.HitPos)
        dmg:SetDamageBonus(BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_DETONATE)
        ent:TakeDamageInfo(dmg)

        local eff = EffectData()
        eff:SetOrigin(self:GetPos())
        eff:SetStart(self:GetColor():ToVector())
        util.Effect("MetalSpark", eff)
    end

    SafeRemoveEntity(self)
end

-- function ENT:OnReflect(dmg)
-- local attacker = dmg:GetAttacker()
-- if attacker:IsPlayer() then
-- self:SetOwner(attacker)
-- local physobj = self:GetPhysicsObject()
-- self.Reflected = true
-- local speed = math.max(self.ReflectSpeed, physobj:GetVelocity():Length())
-- physobj:SetVelocity(self:GetOwner():GetAimVector() * speed)
-- if self.Resets < self.MaxResets then
-- self.SpawnTime = CurTime()
-- self.Bounces = 0
-- self.Resets = self.Resets + 1
-- end
-- end
-- end
-- function ENT:GravGunPunt(ply)
-- self:SetOwner(ply)
-- self.Reflected = true
-- if self.Resets < self.MaxResets then
-- self.SpawnTime = CurTime()
-- self.Bounces = 0
-- self.Resets = self.Resets + 1
-- end
-- timer.Simple(0, function()
-- if IsValid(self) and IsValid(self:GetPhysicsObject()) then
-- self:GetPhysicsObject():SetVelocityInstantaneous(self:GetVelocity():GetNormalized() * self.ReflectSpeed)
-- end
-- end)
-- return true
-- end