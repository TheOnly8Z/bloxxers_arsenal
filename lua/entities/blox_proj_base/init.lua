AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

---------------------------------------------------------------------
-- Functions to be implemented by inherited projectiles
---------------------------------------------------------------------

-- Called when the projectile receives damage marked as reflecting
function ENT:OnReflect(dmg) end

-- Called when the projectile receives damage marked as detonating
function ENT:OnComboDetonate(dmg) end


---------------------------------------------------------------------
-- End of functions to implement
---------------------------------------------------------------------

function ENT:Initialize()
    self:SetModel(self.Model)
    if self.Material then
        self:SetMaterial(self.Material)
    end

    if self.PhysicsSphere then
        self:PhysicsInitSphere(self.PhysicsSphere, self.PhysicsMaterial)
    else
        self:PhysicsInit( SOLID_VPHYSICS )
    end
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    -- self:SetGravity(self.GravityMultiplier) -- only works with MOVETYPE_FLYGRAVITY

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableGravity(false)
        phys:SetBuoyancyRatio(self.Buoyancy)
        if self.Mass then
            phys:SetMass(self.Mass)
        end
        if self.Drag then
            phys:SetDragCoefficient(self.Drag)
        end
    end
    self:PhysWake()

    self.SpawnTime = CurTime()
end

function ENT:Think()
    if self.LifeTime > 0 and self.SpawnTime + self.LifeTime < CurTime() then
        SafeRemoveEntity(self)
    end
end

function ENT:PhysicsUpdate(phys)
    if self:WaterLevel() <= 2 then
        phys:SetVelocityInstantaneous(phys:GetVelocity() + physenv.GetGravity() * self.GravityMultiplier * engine.TickInterval())
    end
end

function ENT:OnTakeDamage(dmg)
    local cancel_damage = false
    if bit.band(dmg:GetDamageCustom(), BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_REFLECT) == BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_REFLECT then
        self:OnReflect(dmg)
        cancel_damage = true
    end

    if bit.band(dmg:GetDamageCustom(), BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_DETONATE) == BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_DETONATE then
        self:OnComboDetonate(dmg, bit.band(dmg:GetDamageCustom(), BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_BLASTCOMBO) == BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_BLASTCOMBO)
        cancel_damage = true
    end

    if cancel_damage then return 0 end

    self:TakePhysicsDamage(dmg)
end