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
						print("Interesting boss: " .. UnitName("raid"..n.."target"))
					end
				end
			end
		end
	end
end

local function magic()
	local timer = C_Timer.NewTimer(5, check)
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