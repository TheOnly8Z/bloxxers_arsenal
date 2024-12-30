SWEP.LHIKModel = nil
SWEP.LHIKAnimation_IsIdle = false
SWEP.LHIKAnimation = nil
SWEP.LHIKAnimationStart = 0
SWEP.LHIKAnimationTime = 0

function SWEP:DoLHIKAnimation(model, key, time, spbitch)
    if not IsValid(self:GetOwner()) then return end

    if game.SinglePlayer() and not spbitch then
        timer.Simple(0, function() if IsValid(self) then self:DoLHIKAnimation(model, key, time, true) end end)
        return
    end

    local vm = self:GetOwner():GetViewModel()
    if not IsValid(vm) then return end

    local lhik_model
    local lhik_anim_model
    local LHIK_GunDriver
    local LHIK_CamDriver
    local offsetang

    if not IsValid(self.LHIKModel) or self.LHIKModel:GetModel() ~= model then
        if IsValid(self.LHIKModel) then self.LHIKModel:Remove() end
        self.LHIKModel = ClientsideModel(model)
    end

    self.LHIKModel:SetNoDraw(true)
    self.LHIKModel:DrawShadow(false)
    self.LHIKModel:SetPredictable(false)
    self.LHIKModel.Weapon = self
    self.LHIKModel:SetupBones()

    lhik_model = self.LHIKModel
    lhik_anim_model = false
    offsetang = Angle()

    if not IsValid(lhik_model) then return false end

    local seq = lhik_model:LookupSequence(key)

    if not seq then return false end
    if seq == -1 then return false end

    lhik_model:ResetSequence(seq)
    if IsValid(lhik_anim_model) then
        lhik_anim_model:ResetSequence(seq)
    end

    if not time or time < 0 then time = lhik_model:SequenceDuration(seq) end

    self.LHIKAnimation = seq
    self.LHIKAnimationStart = UnPredictedCurTime()
    self.LHIKAnimationTime = time

    self.LHIKAnimation_IsIdle = false

    if IsValid(lhik_anim_model) and LHIK_GunDriver then
        local att = lhik_anim_model:LookupAttachment(LHIK_GunDriver)
        local ang = lhik_anim_model:GetAttachment(att).Ang
        local pos = lhik_anim_model:GetAttachment(att).Pos

        self.LHIKGunAng = lhik_anim_model:WorldToLocalAngles(ang) - Angle(0, 90, 90)
        self.LHIKGunPos = lhik_anim_model:WorldToLocal(pos)

        self.LHIKGunAngVM = vm:WorldToLocalAngles(ang) - Angle(0, 90, 90)
        self.LHIKGunPosVM = vm:WorldToLocal(pos)
    end

    if IsValid(lhik_anim_model) and LHIK_CamDriver then
        local att = lhik_anim_model:LookupAttachment(LHIK_CamDriver)
        local ang = lhik_anim_model:GetAttachment(att).Ang

        self.LHIKCamOffsetAng = offsetang
        self.LHIKCamAng = lhik_anim_model:WorldToLocalAngles(ang)
    end

    -- lhik_model:SetCycle(0)
    -- lhik_model:SetPlaybackRate(dur / time)

    return true
end

SWEP.LHIKDelta = {}
SWEP.LHIKDeltaAng = {}

function SWEP:GetLHIKAnim()
    local cyc = (UnPredictedCurTime() - self.LHIKAnimationStart) / self.LHIKAnimationTime

    if cyc > 1 then return nil end
    if self.LHIKAnimation_IsIdle then return nil end

    return self.LHIKAnimation
end

function SWEP:DoLHIK()
    if not IsValid(self:GetOwner()) then return end

    local justhide = false
    local lhik_model = nil
    local lhik_anim_model = nil
    local hide_component = false
    local delta = 1

    local vm = self:GetOwner():GetViewModel()
    lhik_model = self.LHIKModel
    if not IsValid(lhik_model) then return end
    lhik_model:SetPos(vm:GetPos())
    lhik_model:SetAngles(vm:GetAngles())

    if delta == 1 and self.Customize_Hide > 0 then
        if not lhik_model or not IsValid(lhik_model) then
            justhide = true
            delta = math.min(self.Customize_Hide, delta)
        else
            hide_component = true
        end
    end

    if justhide then
        for _, bone in pairs(BLOXXERS_ARSENAL.LHIKBones) do
            local vmbone = vm:LookupBone(bone)

            if not vmbone then continue end -- Happens when spectating someone prolly

            local vmtransform = vm:GetBoneMatrix(vmbone)

            if not vmtransform then continue end -- something very bad has happened

            local vm_pos = vmtransform:GetTranslation()
            local vm_ang = vmtransform:GetAngles()

            local newtransform = Matrix()

            newtransform:SetTranslation(LerpVector(delta, vm_pos, vm_pos - (EyeAngles():Up() * 12) - (EyeAngles():Forward() * 12) - (EyeAngles():Right() * 4)))
            newtransform:SetAngles(vm_ang)

            vm:SetBoneMatrix(vmbone, newtransform)
        end
    end

    if not lhik_model or not IsValid(lhik_model) then return end

    lhik_model:SetupBones()

    if justhide then return end

    local cyc = (UnPredictedCurTime() - self.LHIKAnimationStart) / self.LHIKAnimationTime

    if self.LHIKAnimation and cyc < 1 then
        lhik_model:SetSequence(self.LHIKAnimation)
        lhik_model:SetCycle(cyc)
        if IsValid(lhik_anim_model) then
            lhik_anim_model:SetSequence(self.LHIKAnimation)
            lhik_anim_model:SetCycle(cyc)
        end
    else
        self.LHIKAnimation_IsIdle = true
    end

    local cf_deltapos = Vector(0, 0, 0)
    local cf = 0

    self.LHIKModel:DrawModel()

    for _, bone in pairs(BLOXXERS_ARSENAL.LHIKBones) do
        local vmbone = vm:LookupBone(bone)
        local lhikbone = lhik_model:LookupBone(bone)

        if not vmbone then continue end
        if not lhikbone then continue end

        local vmtransform = vm:GetBoneMatrix(vmbone)
        local lhiktransform = lhik_model:GetBoneMatrix(lhikbone)

        if not vmtransform then continue end
        if not lhiktransform then continue end

        local vm_pos = vmtransform:GetTranslation()
        local vm_ang = vmtransform:GetAngles()
        local lhik_pos = lhiktransform:GetTranslation()
        local lhik_ang = lhiktransform:GetAngles()

        local newtransform = Matrix()

        newtransform:SetTranslation(LerpVector(delta, vm_pos, lhik_pos))
        newtransform:SetAngles(LerpAngle(delta, vm_ang, lhik_ang))

        if self.LHIKDelta[lhikbone] and self.LHIKAnimation and cyc < 1 then
            local deltapos = lhik_model:WorldToLocal(lhik_pos) - self.LHIKDelta[lhikbone]

            if not deltapos:IsZero() then
                cf_deltapos = cf_deltapos + deltapos
                cf = cf + 1
            end
        end

        self.LHIKDelta[lhikbone] = lhik_model:WorldToLocal(lhik_pos)

        if hide_component then
            local new_pos = newtransform:GetTranslation()
            newtransform:SetTranslation(LerpVector(self.Customize_Hide, new_pos, new_pos - (EyeAngles():Up() * 12) - (EyeAngles():Forward() * 12) - (EyeAngles():Right() * 4)))
        end

        local matrix = Matrix(newtransform)

        vm:SetBoneMatrix(vmbone, matrix)

        -- local vm_pos, vm_ang = vm:GetBonePosition(vmbone)
        -- local lhik_pos, lhik_ang = lhik_model:GetBonePosition(lhikbone)

        -- local pos = LerpVector(delta, vm_pos, lhik_pos)
        -- local ang = LerpAngle(delta, vm_ang, lhik_ang)

        -- vm:SetBonePosition(vmbone, pos, ang)
    end
end

function SWEP:OnRemove()
    if IsValid(self.LHIKModel) then
        self.LHIKModel:Remove()
    end
end

function SWEP:PreDrawViewModel(vm)
    if not vm then return end
    if self:GetNextOffhandEnd() >= CurTime() then
        self:DoLHIK()
    end
end

net.Receive("blox_sp_lhikanim", function(len, ply)
    local wep  = LocalPlayer():GetActiveWeapon()
    local model = net.ReadString()
    local key  = net.ReadString()
    local time = net.ReadFloat() or -1

    if not wep.BloxxersArsenal then return end

    wep:DoLHIKAnimation(model, key, time)
end)
