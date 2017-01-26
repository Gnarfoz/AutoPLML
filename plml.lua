-- beware the loot gnomes
local function magic()
	--stuff
end

local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		if (select(1,...)) == "AutoPLML" then
			AutoPLML:UnregisterAllEvents()
			AutoPLML = nil
			magic()
		end
	end
end		
		
AutoPLML = CreateFrame("Frame")
AutoPLML:SetScript("OnEvent", OnEvent)
AutoPLML:RegisterEvent("ADDON_LOADED")