hook.Add("EntityTakeDamage", "Bloxxers_Arsenal", function(ent, dmginfo)
    local dmgcustom = dmginfo:GetDamageCustom()

    if bit.band(dmgcustom, BLOXXERS_ARSENAL.CDMG_ACTIVE) ~= 0 then
        if bit.band(dmgcustom, BLOXXERS_ARSENAL.CDMG_BLASTJUMP) ~= 0 and ent == dmginfo:GetAttacker() then
            -- Launch the player
            ent:SetVelocity((ent:GetPos() - dmginfo:GetDamagePosition()):GetNormalized() * dmginfo:GetDamage() * 2.5 + Vector(0, 0, dmginfo:GetDamage() * 2.5))
            return true
        end
    end
end)