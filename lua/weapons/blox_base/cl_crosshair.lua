local cursor = Material("bloxxers_arsenal/cursor.png")
local cursor_wait = Material("bloxxers_arsenal/cursor_wait.png")
local s = 64

function SWEP:DoDrawCrosshair(x, y)
    surface.SetMaterial(self:GetNextPrimaryFire() > CurTime() and cursor_wait or cursor)
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawTexturedRect(x - s / 2, y - s / 2, s, s)

    return true
end