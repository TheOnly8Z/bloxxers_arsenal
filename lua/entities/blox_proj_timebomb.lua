AddCSLuaFile()
ENT.PrintName = "Timebomb Projectile"
ENT.Base = "blox_proj_base"

DEFINE_BASECLASS(ENT.Base)

ENT.Model = "models/weapons/bloxxers_arsenal/projectiles/superball.mdl"
ENT.PhysicsMaterial = "plastic"
ENT.PhysicsSphere = 15

ENT.Mass = 20
ENT.GravityMultiplier = 2
ENT.Buoyancy = 0
ENT.Drag = 3

ENT.Damage = 1000 -- these are really wussy units
ENT.Radius = 328

ENT.NextTick = 0
ENT.TickInterval = 0.4
ENT.TickCount = 0

ENT.Color1 = Color(27, 42, 53) -- Black
ENT.Color2 = Color(196, 40, 28) -- Bright red

ENT.ReflectSpeed = 1500

function ENT:Initialize()
    BaseClass.Initialize(self)
    self:SetColor(self.Color1)
    self.NextTick = CurTime() + self.TickInterval
end

function ENT:Think()
    BaseClass.Think(self)
    if SERVER and self.NextTick < CurTime() then
        self.TickCount = self.TickCount + 1
        self.TickInterval = self.TickInterval * 0.92 -- Yes that's how they did it...
        self.NextTick = CurTime() + self.TickInterval
        if self.TickInterval <= 0.1 then
            self:Detonate()
        else
            self:SetColor(self.TickCount % 2 == 0 and self.Color1 or self.Color2)
            self:EmitSound("bloxxers_arsenal/timebomb/clickfast.wav", 80)
        end
    end
end

function ENT:Detonate()
    self:EmitSound("bloxxers_arsenal/timebomb/rocketshot.wav", 100)

    local fx = EffectData()
    fx:SetOrigin(self:GetPos())
    if self:WaterLevel() > 0 then
        util.Effect("WaterSurfaceExplosion", fx)
    else
        util.Effect("Explosion", fx)
    end

    local dmginfo = DamageInfo()
    dmginfo:SetDamageType(DMG_BLAST)
    dmginfo:SetDamage(self.Damage)
    dmginfo:SetAttacker(self:GetOwner())
    dmginfo:SetInflictor(self)
    dmginfo:SetDamageCustom(BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_BLASTJUMP)
    dmginfo:SetDamagePosition(self:GetPos())
    util.BlastDamageInfo(dmginfo, self:GetPos(), self.Radius)

    self:Remove()
end

function ENT:OnReflect(dmg)
    local attacker = dmg:GetAttacker()
    if attacker:IsPlayer() then
        self:SetOwner(attacker)

        local physobj = self:GetPhysicsObject()
        self.Reflected = true
        local speed = math.max(self.ReflectSpeed, physobj:GetVelocity():Length())
        physobj:AddVelocity(attacker:GetAimVector() * speed)
    end
end

function ENT:GravGunPunt(ply)
    self:SetOwner(ply)
    self.Reflected = true
    return true
end