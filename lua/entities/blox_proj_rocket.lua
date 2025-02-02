AddCSLuaFile()
ENT.PrintName = "Rocket Launcher Projectile"
ENT.Base = "blox_proj_base"

DEFINE_BASECLASS(ENT.Base)

ENT.Model = "models/hunter/blocks/cube025x1x025.mdl"
ENT.Material = "models/weapons/bloxxers_arsenal/rocketlauncher/rocket"
-- ENT.PhysicsSphere = 4

ENT.GravityMultiplier = 0
ENT.Buoyancy = 0.01
ENT.LifeTime = 0
ENT.Drag = 0

ENT.BlastJumpForce = 600
ENT.Radius = 256
ENT.Damage = 50
ENT.DamageDirectHit = 100

function ENT:Initialize()
    BaseClass.Initialize(self)

    if SERVER then
        self:SetColor(BLOXXERS_ARSENAL.RandomBrickColor())

        -- Instantly detonate for more consistant blast jumps
        local tr = util.TraceHull({
            start = self:GetPos(),
            endpos = self:GetPos() + (self.ProjectileAngle or self:GetForward()) * 72,
            filter = {self, self:GetOwner()},
            mask = MASK_SOLID
        })
        if tr.Hit then
            self:SetPos(tr.HitPos)
            self:Detonate(tr.Entity)
            local wep = IsValid(self:GetOwner()) and self:GetOwner():GetWeapon("blox_shoot_rocket_launcher")
            if IsValid(wep) then
                wep:SetNextPrimaryFire(CurTime() + wep.AltShootCooldown)
            end
        else
            self.SwooshSound = CreateSound(self, "BloxxersArsenal.Rocket.Swoosh")
            self.SwooshSound:Play()
        end
    end
end

function ENT:OnRemove()
    if self.SwooshSound then
        self.SwooshSound:Stop()
    end
end

function ENT:Think()
    BaseClass.Think(self)
end

function ENT:Detonate(ent)
    if self.BOOM then return end
    self.BOOM = true

    local direct_hit = IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() or ent:Health() > 0 or ent.IsBloxxersProjectile)

    local dmginfo = DamageInfo()
    dmginfo:SetDamageType(DMG_BLAST)
    dmginfo:SetDamage(direct_hit and self.DamageDirectHit or self.Damage)
    dmginfo:SetAttacker(self:GetOwner())
    dmginfo:SetInflictor(self)
    dmginfo:SetDamageCustom(BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_BLASTJUMP + BLOXXERS_ARSENAL.CDMG_DETONATE + (direct_hit and BLOXXERS_ARSENAL.CDMG_BLASTCOMBO or 0))
    dmginfo:SetDamagePosition(self:GetPos())
    dmginfo:SetDamageBonus(math.Rand(5, 10))
    util.BlastDamageInfo(dmginfo, self:GetPos(), self.Radius)

    local fx = EffectData()
    fx:SetOrigin(self:GetPos())
    util.Effect("helicoptermegabomb", fx)
    if direct_hit then
        fx:SetNormal(self:GetForward())
        util.Effect("cball_explode", fx)
    end

    self:EmitSound("bloxxers_arsenal/rocketlauncher/explode_hq.wav", 95)

    SafeRemoveEntity(self)
end

function ENT:PhysicsCollide(data, physobj)
    self:Detonate(data.HitEntity)
end