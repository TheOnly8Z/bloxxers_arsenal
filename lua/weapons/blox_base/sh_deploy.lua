
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
    end

    return true
end

function SWEP:Holster()
    return true
end