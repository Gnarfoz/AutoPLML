-- beware the loot gnomes
local masterlooter = "Venara"
local debug = false

local raids = {}
raids[1530] = true	-- The Nighthold
raids[1676] = true	-- Tomb of Sargeras

local difficulties = {}
difficulties[14] = true	-- Normal
difficulties[15] = true	-- Heroic
difficulties[16] = true	-- Mythic

local bosses = {}
--bosses[104288] = true	-- Trilliax
--bosses[103685] = true	-- Tichondrius
--bosses[101002] = true	-- Krosus
--bosses[103758] = true	-- Star Augur Etraeus
--bosses[106643] = true	-- Elisande
--bosses[104154] = true	-- Gul'dan
bosses[120996] = true -- Atrigan
bosses[116691] = true -- Belac
bosses[116407] = true -- Harjatan
bosses[115767] = true -- Mistress Sassz'ine
bosses[118462] = true -- Soul Queen Dejahna
bosses[118460] = true -- Engine of Souls
bosses[118289] = true -- Maiden of Vigilance
bosses[120436] = true -- Fallen Avatar
bosses[120437] = true -- Maiden of Valor
bosses[117264] = true -- Maiden of Valor


local function check()
	if not InCombatLockdown() then
		if IsInInstance() then
			local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize = GetInstanceInfo()
			if instanceType == "raid" and raids[instanceMapID] and difficulties[difficultyID] then
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