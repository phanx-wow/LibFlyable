--[[--------------------------------------------------------------------
	LibFlyable
	Replacement for the IsFlyableArea API function in World of Warcraft.
	Author : Phanx <addons@phanx.net>
	License: Public Domain
	This is free and unencumbered software released into the public domain.
	https://github.com/phanx-wow/LibFlyable
	https://wow.curseforge.com/projects/libflyable
----------------------------------------------------------------------]]
-- TODO: Find out when Wintergrasp (mapID 501) isn't flyable? Or too old to bother with?

local MAJOR, MINOR = "LibFlyable", 1
assert(LibStub, MAJOR.." requires LibStub")
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

----------------------------------------
-- Data
----------------------------------------

local flyingSpells = {
	-- Draenor Pathfinder
	[1116] = 191645, -- Draenor
	[1464] = 191645, -- Tanaan Jungle
	-- Broken Isles Pathfinder
	[1220] = 233368, -- Broken Isles
	-- NEVER
	[1191] = -1, -- Ashran
	[1265] = -1, -- Tanaan Jungle Intro
}

-- Workaround for bug in patch 7.3.5
local flyContinents735 = {
	-- These continents previously required special spells to fly in.
	-- All such spells were removed from the game in patch 7.3.5, but
	-- the IsFlyableArea() API function was not updated accordingly,
	-- and incorrectly returns false on these continents for characters
	-- who did not know the appropriate spell before the patch.
	[   0] = true, -- Eastern Kingdoms - Flight Master's License
	[   1] = true, -- Kalimdor         - Flight Master's License
	[ 646] = true, -- Deepholm         - Flight Master's License
	[ 571] = true, -- Northrend        - Cold Weather Flying
	[1220] = true, -- Dalaran          - Cold Weather Flying (only in Wrath version @ mapID 504)
	[ 870] = true, -- Pandaria         - Wisdom of the Four Winds
}

-- Workaround for bug in patch 7.3.5
local noFlyZones735 = {
	-- List of no-fly zones on otherwise flyable continents.
}

local noFlySubzones = {
	["Nespirah"] = true, ["Неспира"] = true, ["네스피라"] = true, ["奈瑟匹拉"] = true, ["奈斯畢拉"] = true,
}

----------------------------------------
-- Logic
----------------------------------------

local GetInstanceInfo = GetInstanceInfo
local GetSubZoneText = GetSubZoneText
local IsFlyableArea = IsFlyableArea
local IsSpellKnown = IsSpellKnown
local IsOnGarrisonMap = C_Garrison.IsOnGarrisonMap
local IsOnShipyardMap = C_Garrison.IsOnShipyardMap
local IsPlayerInGarrison = C_Garrison.IsPlayerInGarrison
-- Workaround for bug in patch 7.3.5
local GetCurrentMapAreaID = GetCurrentMapAreaID
local IsIndoors = IsIndoors

local function CanFly()
	-- if not IsFlyableArea() -- Workaround for bug in patch 7.3.5
	if IsPlayerInGarrison(LE_GARRISON_TYPE_7_0) -- Legion class order hall
	or IsOnGarrisonMap() or IsOnShipyardMap() -- Warlords garrison
	or noFlySubzones[GetSubZoneText() or ""] then
		return false
	end

	local _, _, _, _, _, _, _, instanceMapID = GetInstanceInfo()
	local reqSpell = flyingSpells[instanceMapID]
	if reqSpell then
		return reqSpell > 0 and IsSpellKnown(reqSpell)
	else
		-- Workaround for bug in patch 7.3.5
		-- IsFlyableArea() incorrectly reports false in many locations for
		-- characters who did not have a zone-specific flying spell before
		-- the patch (which removed all such spells from the game).
		if not IsFlyableArea() then
			-- Might be affected by the bug, check more stuff...
			-- print("maybe...")

			if not flyContinents735[instanceMapID] then
				-- Continent is not affected by the bug. API is correct.
				-- print("nope: continent not bugged")
				return false
			end

			-- Continent is affected by the bug, check more stuff...
			if noFlyZones735[GetCurrentMapAreaID()] then
				-- Continent is flyable, but zone is not. Note that this check
				-- won't be accurate if the world map is open to a zone other
				-- than the one in which the player is currently located.
				-- print("nope: zone excluded")
				return false
			end

			-- ¯\_(:/)_/¯
			-- print("probably...")
		end
		-- ^^^ end of workaround
		return IsSpellKnown(34090) or IsSpellKnown(34091) or IsSpellKnown(90265)
	end
end

----------------------------------------
-- Export
----------------------------------------

lib.flyingSpells = lib.flyingSpells
lib.flyContinents735 = flyContinents735
lib.noFlyZones735 = noFlyZones735
lib.noFlySubzones = noFlySubzones

lib.IsFlyableArea = CanFly
