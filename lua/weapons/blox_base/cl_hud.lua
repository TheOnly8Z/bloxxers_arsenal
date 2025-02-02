local cursor = Material("bloxxers_arsenal/cursor.png")
local cursor_wait = Material("bloxxers_arsenal/cursor_wait.png")
local cs = 64
local SS = ScreenScale

function SWEP:DoDrawCrosshair(x, y)
    surface.SetMaterial(self:GetNextPrimaryFire() > CurTime() and cursor_wait or cursor)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(x - cs / 2, y - cs / 2, cs, cs)

    return true
end

function SWEP:DrawHUD()
    local allow_offhand = self.FreeOffhand

    local s = SS(32)
    local gap = SS(8)
    local thickness = SS(1)
    local x = ScrW() / 2 - s * 1.5 - gap
    local y = ScrH() - s - SS(12)

    for i = 0, BLOXXERS_ARSENAL.MAX_OFFHAND_BINDS - 1 do
        surface.SetDrawColor(50, 50, 50, 150)
        surface.DrawRect(x, y, s, s)
        surface.SetDrawColor(155, 155, 155, 200)
        surface.DrawOutlinedRect(x, y, s, s, thickness)
        local class = ply:Blox_GetOffhandClass(i)
        if class == "" then class = nil end
        local wep = class and ply:GetWeapon(class)
        if class then
            local icon = BLOXXERS_ARSENAL.Icons[class]
            if not icon then
                BLOXXERS_ARSENAL.Icons[class] = weapons.Get(class).IconOverride or Material("entities/" .. class .. ".png", "smooth")
                icon = BLOXXERS_ARSENAL.Icons[class]
            end

            if IsValid(wep) and wep.OffhandShowCooldown then
                local fr = math.Clamp(wep:GetHUDCooldownFraction(self), 0, 1)
                if fr > 0 then
                    surface.SetDrawColor(0, 0, 0, 200)
                    surface.DrawRect(x + thickness, y + thickness + s * (1 - fr), s - thickness * 2, s * fr - thickness * 2)
                end
            end

            surface.SetDrawColor(255, IsValid(wep) and 255 or 150, IsValid(wep) and 255 or 150, (not IsValid(wep) or self == wep) and 100 or 255)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(x + thickness, y + thickness, s - thickness * 2, s - thickness * 2)

            if IsValid(wep) and  wep.OffhandShowClip then
                local clip = wep:GetHUDClip(self)
                surface.SetDrawColor(255, 255, 255, 255)
                draw.SimpleTextOutlined(clip, "Blox_Bind", x + s / 2, y + s / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
            end
        end

        if allow_offhand and ((self.OffhandUsable and BLOXXERS_ARSENAL.CONTEXT_MENU_PRESSED) or IsValid(wep)) then
            local bindname = string.upper(input.GetKeyName(BLOXXERS_ARSENAL.OFFHAND_CVAR[i]:GetInt()) or "")
            draw.SimpleTextOutlined(bindname, "Blox_Bind", x + s / 2, y + s, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black)
        end

        x = x + s + gap
    end

    if self.OffhandUsable and BLOXXERS_ARSENAL.CONTEXT_MENU_PRESSED then
        draw.SimpleTextOutlined("Press bind to set offhand", "Blox_Bind", ScrW() / 2, y - gap, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black)
    end
end