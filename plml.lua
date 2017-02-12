-- beware the loot gnomes
local debug = true

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
			local found
			for n=1,40 do
				if UnitExists("raid"..n.."target") then
					if bosses[UnitName("raid"..n.."target")] then
						found = UnitName("raid"..n.."target")
					end
				end
			if found then break	end
			end
			if found then
				if GetLootMethod() ~= "master" then
					print("ML für: " .. found)
					SetLootMethod("master", "Venara")
					if debug then
						print("AutoPLML: Switching to master loot for " .. found)
					end
				end
			else
				if GetLootMethod() ~= "personalloot" then
					print("PL, niemand hat einen interessanten Boss im Target.")
					if debug then
						print("AutoPLML: Nobody is targeting a set token boss, switching to personal loot.")
					end
					SetLootMethod("personalloot")
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