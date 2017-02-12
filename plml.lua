-- beware the loot gnomes
local masterlooter = "Venara"
local debug = true

local bosses = {}
bosses[104288] = true	-- Trilliax
bosses[103685] = true	-- Tichondrius
bosses[101002] = true	-- Krosus
bosses[103758] = true	-- Star Augur Etraeus
bosses[106643] = true	-- Elisande
bosses[104154] = true	-- Gul'dan

local function check()
	if not InCombatLockdown() then
		local instance, type = IsInInstance()
		if instance and type == "raid" then
			local found
			for n=1,40 do
				local unit = "raid"..n.."target"
				if UnitExists(unit) and UnitName(unit) and not UnitIsCorpse(unit) and not UnitIsDead(unit) and not UnitPlayerControlled(unit) then
					local _, _, _, _, _, mobId = strsplit("-", (UnitGUID(unit)))
					local id = tonumber(mobId)
					if bosses[id] then
						found = UnitName(unit)
						if debug then
							print("AutoPLML: Found interesting mob: " .. found)
						end
					end
				end
				if found then break	end
			end
			if found then
				if GetLootMethod() ~= "master" then
					if debug then
						print("AutoPLML: Switching to master loot for " .. found)
					end
					SetLootMethod("master", masterlooter)
				end
			else
				if GetLootMethod() ~= "personalloot" then
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