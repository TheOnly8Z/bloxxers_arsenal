
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

        if self.OffhandUsable then
            for i = 0, BLOXXERS_ARSENAL.MAX_OFFHAND_BINDS - 1 do
                local offhand = self:GetOwner():Blox_GetOffhandClass(i)
                if not offhand then
                    self:GetOwner():Blox_SetOffhandClass(self:GetClass())
                    break
                elseif offhand == self:GetClass() then
                    break
                end
            end
        end
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