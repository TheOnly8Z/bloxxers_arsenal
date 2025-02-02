hook.Add("EntityTakeDamage", "Bloxxers_Arsenal", function(ent, dmginfo)
    local dmgcustom = dmginfo:GetDamageCustom()

    if bit.band(dmgcustom, BLOXXERS_ARSENAL.CDMG_ACTIVE) ~= 0 then
        if bit.band(dmgcustom, BLOXXERS_ARSENAL.CDMG_BLASTJUMP) ~= 0 and ent == dmginfo:GetAttacker() then
            -- Launch the player
            ent:SetVelocity((ent:EyePos() - dmginfo:GetDamagePosition()):GetNormalized() * (dmginfo:GetInflictor().BlastJumpForce or dmginfo:GetDamage() * 2))
            dmginfo:SetDamage(dmginfo:GetDamageBonus())
            dmginfo:SetDamageType(DMG_BLAST_SURFACE) -- no ringing noise
        end
    end
end)