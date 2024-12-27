AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

---------------------------------------------------------------------
-- Functions to be implemented by inherited projectiles
---------------------------------------------------------------------

-- Called when the projectile receives damage marked as reflecting
function ENT:OnReflect(dmg) end


---------------------------------------------------------------------
-- End of functions to implement
---------------------------------------------------------------------

function ENT:Initialize()
    self:SetModel(self.Model)

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
    end
    self:PhysWake()

    self.SpawnTime = CurTime()
    if (self.LifeTime or 0) > 0 then
        self.DieTime = CurTime() + self.LifeTime
    end
end

function ENT:Think()
    if self.DieTime and self.DieTime <= CurTime() then
        SafeRemoveEntity(self)
    end
end

function ENT:PhysicsUpdate(phys)
    phys:SetVelocityInstantaneous(phys:GetVelocity() + physenv.GetGravity() * self.GravityMultiplier * engine.TickInterval())
end

function ENT:OnTakeDamage(dmg)
    if bit.band(dmg:GetDamageCustom(), BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_REFLECT) == BLOXXERS_ARSENAL.CDMG_ACTIVE + BLOXXERS_ARSENAL.CDMG_REFLECT then
        self:OnReflect(dmg)
        return 0
    end
end