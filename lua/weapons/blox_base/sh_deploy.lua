
function SWEP:Deploy()
    self:SetHoldType(self.HoldType)
    local speed = 1
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("draw"))
    vm:SetPlaybackRate(speed)
    -- self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / speed)
    -- self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / speed)
    self:UpdateNextIdle()
    if IsFirstTimePredicted() then
        self:EmitSound(self.DrawSound)

        if IsValid(self:GetOwner().LastBloxxersSWEP) and self:GetOwner().LastBloxxersSWEP ~= self and self:GetOwner().LastBloxxersSWEP.OffhandUsable then
            self.OffhandWeapon = self:GetOwner().LastBloxxersSWEP
        end
        self:GetOwner().LastBloxxersSWEP = self
    end

    if IsValid(self.LHIKModel) then
        self.LHIKModel:Remove()
        self.LHIKModel = nil
    end

    return true
end

function SWEP:Holster()
    if IsValid(self.LHIKModel) then
        self.LHIKModel:Remove()
        self.LHIKModel = nil
    end
    return true
end