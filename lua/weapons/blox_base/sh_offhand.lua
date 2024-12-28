-- Ability to use this weapon in the offhand while another weapon is active
SWEP.OffhandUsable = false

-- Ability to use other weapons in the offhand while this is the active weapon
SWEP.FreeOffhand = true

-- This is the active weapon and we are able to use offhand
function SWEP:OffhandReady()
    return self.FreeOffhand and self:GetNextSecondaryFire() <= CurTime()
end

-- This is the offhand weapon and we are able to be used
function SWEP:CanOffhandAttack()
    return self.OffhandUsable
end

function SWEP:OffhandAttack(wep)
end

function SWEP:OffhandThink(wep)
end


function SWEP:Reload()
    -- Testing
    -- if self:GetNextSecondaryFire() > CurTime() then return end
    -- self:SetNextSecondaryFire(CurTime() + 0.5)
    -- if IsFirstTimePredicted() then
    --     self:DoLHIKAnimation("models/weapons/bloxxers_arsenal/v_sword.mdl", "offhand")
    -- end

    if not self:OffhandReady() then return end

    local wep = self:GetOwner():GetWeapon("blox_sword_linked")
    if IsValid(wep) and wep:CanOffhandAttack() then
        self:SetActiveOffhand(wep)
        wep:OffhandAttack(self)
    end
end


if SERVER then
    function SWEP:DoLHIKAnimation(model, key, time)
        if game.SinglePlayer() then
            net.Start("blox_sp_lhikanim")
            net.WriteString(model)
            net.WriteString(key)
            net.WriteFloat(time or -1)
            net.Send(self:GetOwner())
        end
    end
end