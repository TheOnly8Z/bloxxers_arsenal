AddCSLuaFile()
ENT.PrintName = "Timebomb Projectile"
ENT.Base = "blox_proj_base"

DEFINE_BASECLASS(ENT.Base)

ENT.Model = "models/weapons/bloxxers_arsenal/projectiles/superball.mdl"
ENT.PhysicsMaterial = "plastic"
ENT.PhysicsSphere = 15

ENT.Mass = 10
ENT.GravityMultiplier = 2
ENT.Buoyancy = 0
ENT.Drag = 3

ENT.BlastJumpForce = 1500
ENT.Damage = 200 -- these are really wussy units
ENT.Radius = 328

ENT.ComboDamage = 500
ENT.ComboRadius = 512

ENT.NukeDamage = 300
ENT.NukeRadius = 1024

ENT.NextTick = 0
ENT.TickInterval = 0.4
ENT.TickCount = 0

ENT.Color1 = Color(27, 42, 53) -- Black
ENT.Color2 = Color(196, 40, 28) -- Bright red

ENT.ReflectSpeed = 600

function ENT:Initialize()
    BaseClass.Initialize(self)
    self:SetColor(self.Color1)
    self.NextTick = CurTime() + self.TickInterval
end

function ENT:PhysicsCollide(data, physobj)
    local ent = data.HitEntity

    if ent:GetClass() == "blox_proj_paintball" then
        self:Detonate()
    end
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
    if self.BOOM then return end
    self.BOOM = true

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
    dmginfo:SetDamageBonus(math.random(18, 24)) -- self damage
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
    return true
end

function ENT:OnComboDetonate(dmg, combo)
    local attacker = dmg:GetAttacker()
    if attacker:IsPlayer() then
        self:SetOwner(attacker)
    end
    if not combo then
        self:Detonate()
        return
    end
    if self.BOOM then return end
    self.BOOM = true

    local nuke = false

    -- SWAG MESSIAH
    -- TODO: really cool effect for this
    if self.Reflected then
        local tr = util.TraceLine({
            start = self:GetPos(),
            endpos = self:GetPos() - Vector(0, 0, 328),
            mask = MASK_SOLID_BRUSHONLY,
        })
        if tr.Fraction == 1 then
            nuke = true
        end
    end

    local radius, damage = self.ComboRadius, self.ComboDamage
    local selfdmg = math.random(18, 24)
    if nuke then
        radius, damage = self.NukeRadius, self.NukeDamage
        self.BlastJumpForce = 0
        selfdmg = 0
    end

    self:EmitSound("bloxxers_arsenal/timebomb/rocketshot.wav", 80)

    local fx = EffectData()
    fx:SetOrigin(self:GetPos())
    if self:WaterLevel() > 0 then
        util.Effect("WaterSurfaceExplosion", fx)
    else
        util.Effect("Explosion", fx)
        fx:SetScale(radius)
        util.Effect("ThumperDust", fx)
    end

    local dmginfo = DamageInfo()
    dmginfo:SetDamageType(DMG_BLAST)
    dmginfo:SetDamage(damage)
    dmginfo:SetAttacker(self:GetOwner())
    dmginfo:SetInflictor(self)
    dmginfo:SetDamageCustom(BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_BLASTJUMP)
    dmginfo:SetDamagePosition(self:GetPos())
    dmginfo:SetDamageBonus(selfdmg)
    util.BlastDamageInfo(dmginfo, self:GetPos(), radius)

    self:Remove()
end

function ENT:GravGunPunt(ply)
    self:SetOwner(ply)
    self.Reflected = true
    return true
end