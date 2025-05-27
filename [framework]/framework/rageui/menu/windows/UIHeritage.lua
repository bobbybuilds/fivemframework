---@type table
local Heritage = {
	Background = { Dictionary = "pause_menu_pages_char_mom_dad", Texture = "mumdadbg", Width = 431, Height = 228 },
	Mum = { Dictionary = "char_creator_portraits", X = 25, Width = 228, Height = 228 },
	Dad = { Dictionary = "char_creator_portraits", X = 195, Width = 228, Height = 228 },
}

---HeritageWindow
---@param Mum number
---@param Dad number
---@return nil
---@public
function RageUI.HeritageWindow(Mum, Dad)

	---@type table
	local CurrentMenu = RageUI.CurrentMenu;

	if CurrentMenu ~= nil then
		if CurrentMenu() then
			if (Mum > 21) then
				Mum = 21
			end
			if (Mum < 0) then
				Mum = 0
			end
			if (Dad > 23) then
				Dad = 23
			end
			if (Dad < 0) then
				Dad = 0
			end

			Mum = ((Mum < 21) and "female_" .. Mum or "special_female_" .. (tonumber(string.sub(Mum, 2, 2)) - 1))
			Dad = ((Dad < 21) and "male_" .. Dad or "special_male_" .. (tonumber(string.sub(Dad, 2, 2)) - 1))

			RenderSprite(Heritage.Background.Dictionary, Heritage.Background.Texture, CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Heritage.Background.Width + (CurrentMenu.WidthOffset / 1), Heritage.Background.Height)
			RenderSprite(Heritage.Dad.Dictionary, Dad, CurrentMenu.X + Heritage.Dad.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Heritage.Dad.Width, Heritage.Dad.Height)
			RenderSprite(Heritage.Mum.Dictionary, Mum, CurrentMenu.X + Heritage.Mum.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, Heritage.Mum.Width, Heritage.Mum.Height)

			RageUI.ItemOffset = RageUI.ItemOffset + Heritage.Background.Height
		end
	end
end

