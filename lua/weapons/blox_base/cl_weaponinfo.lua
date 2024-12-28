SWEP.InfoMarkup = nil

SWEP.MarkupTitleColor = "<color=230,230,230>"
SWEP.MarkupTextColor = "<color=150,150,150,255>"

function SWEP:PrintWeaponInfo(x, y, alpha)
    if self.DrawWeaponInfoBox == false then return end

    if not self.InfoMarkup then
        local str
        local title_color = self.MarkupTitleColor
        local text_color = self.MarkupTextColor
        str = "<font=HudSelectionText>"

        if self.Description ~= "" then
            str = str .. title_color .. "</color>" .. title_color .. self.Description .. "</color>\n\n"
        end

        if self.Instructions ~= "" then
            str = str .. title_color .. "Controls:\n" .. text_color .. self.Instructions .. "</color>\n"
        end

        if self.OffhandUsable then
            str = str .. title_color .. "<color=150,255,150>" .. "[USABLE IN OFF-HAND]" .. "</color>\n"
        end

        if self.Tips ~= "" then
            str = str .. title_color .. "\nTips:\n" .. text_color .. self.Tips .. "</color>\n"
        end

        -- if self.Author ~= "" then
        --     str = str .. title_color .. "\nAuthor:</color>\t" .. text_color .. self.Author .. "</color>\n"
        -- end

        str = str .. "</font>"
        self.InfoMarkup = markup.Parse(str, 250)
    end

    surface.SetDrawColor(60, 60, 60, alpha)
    surface.SetTexture(self.SpeechBubbleLid)
    surface.DrawTexturedRect(x, y - 64 - 5, 128, 64)
    draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(60, 60, 60, alpha))
    self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end