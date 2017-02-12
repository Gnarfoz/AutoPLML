-- beware the loot gnomes
local bosses = {}
bosses["Trilliax"] = true
bosses["Tichondrius"] = true
bosses["Krosus"] = true
bosses["Star Augur Etraeus"] = true
bosses["Elisande"] = true
bosses["Gul'dan"] = true

local function check()
	if not InCombatLockdown() then
		local instance, type = IsInInstance()
		if instance and type == "raid" then
			for n=1,40 do
				if UnitExists("raid"..n.."target") then
					if bosses[UnitName("raid"..n.."target)] then
					end
				end
			end
		end
	end
end

local function OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		if (select(1,...)) == "AutoPLML" then
			AutoPLML:UnregisterAllEvents()
			AutoPLML = nil

			C_Timer.NewTicker(5, check)
		end
	end
end		
		
AutoPLML = CreateFrame("Frame")
AutoPLML:SetScript("OnEvent", OnEvent)
AutoPLML:RegisterEvent("ADDON_LOADED")