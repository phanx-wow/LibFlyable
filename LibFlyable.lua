--[[--------------------------------------------------------------------
	LibFlyable
	Replacement for the IsFlyableArea API function in World of Warcraft.
	Author : Phanx <addons@phanx.net>
	License: Public Domain
	This is free and unencumbered software released into the public domain.
	https://github.com/phanx-wow/LibFlyable
	https://wow.curseforge.com/projects/libflyable
----------------------------------------------------------------------]]
-- TODO:
-- Wintergrasp (mapID 501) status detection? Or too old to bother with?
-- Helheim Exterior Area (instanceMapID 1463) never flyable?
-- Draenor garrison flyable. IsFlyableArea OK?
-- Draenor shipyard flyable?
-- Legion class hall flyable for DK, druid, hunter. IsFlyableArea OK? Or mapID override.
-- Argus not flyable. IsFlyableArea OK? Or instanceMapID? Or mapID override.

local MAJOR, MINOR = "LibFlyable", 1
assert(LibStub, MAJOR.." requires LibStub")
local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end

----------------------------------------
-- Data
----------------------------------------

local ContinentSpells = {
	-- Continents/instances requiring a spell to fly:
	[1116] = 191645, -- Draenor (Draenor Pathfinder)
	[1464] = 191645, -- Tanaan Jungle (Draenor Pathfinder)
	[1220] = 233368, -- Broken Isles (Broken Isles Pathfinder)
	-- No-fly continents/instances where IsFlyableArea returns true:
	[1191] = -1, -- Ashran (PvP)
	[1265] = -1, -- Tanaan Jungle Intro
	[1463] = -1, -- Helheim Exterior Area
	-- No-fly class halls where IsFlyableArea returns true:
	-- Note some are flyable at the entrance, but not inside; just call it all unflyable.
	[1519] = -1, -- The Fel Hammer (Demon Hunter)
	[1514] = -1, -- The Wandering Isle (Monk)
	[1469] = -1, -- The Heart of Azeroth (Shaman)
	[1107] = -1, -- Dreadscar Rift (Warlock)
	[1479] = -1, -- Skyhold (Warrior)
}

-- Workaround for bug in patch 7.3.5
local FlyableContinents735 = {
	-- These continents previously required special spells to fly in.
	-- All such spells were removed from the game in patch 7.3.5, but
	-- the IsFlyableArea() API function was not updated accordingly,
	-- and incorrectly returns false on these continents for characters
	-- who did not know the appropriate spell before the patch.
	[   0] = true, -- Eastern Kingdoms (Flight Master's License)
	[   1] = true, -- Kalimdor (Flight Master's License)
	[ 646] = true, -- Deepholm (Flight Master's License)
	[ 571] = true, -- Northrend (Cold Weather Flying)
	[1220] = true, -- Dalaran (Cold Weather Flying) (only in Wrath version @ mapID 504)
	[ 870] = true, -- Pandaria (Wisdom of the Four Winds)
}

-- Workaround for bug in patch 7.3.5
local NoFlyZones735 = {
	-- These zones are not flyable on otherwise flyable continents.
}

local NoFlySubzones = {
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
local GetCurrentMapAreaID = GetCurrentMapAreaID -- Workaround for bug in patch 7.3.5
local IsIndoors = IsIndoors -- Workaround for bug in patch 7.3.5

local function CanFly()
	-- if not IsFlyableArea() -- Workaround for bug in patch 7.3.5
	if IsOnGarrisonMap() or IsOnShipyardMap() -- Warlords garrison
	or NoFlySubzones[GetSubZoneText() or ""] then
		return false
	end

	local _, _, _, _, _, _, _, instanceMapID = GetInstanceInfo()
	local reqSpell = ContinentSpells[instanceMapID]
	if reqSpell then
		return reqSpell > 0 and IsSpellKnown(reqSpell)
	end

	-- Workaround for bug in patch 7.3.5
	-- IsFlyableArea() incorrectly reports false in many locations for
	-- characters who did not have a zone-specific flying spell before
	-- the patch (which removed all such spells from the game).
	if not IsFlyableArea() then
		-- Might be affected by the bug, check more stuff...
		-- print("maybe...")

		if not FlyableContinents735[instanceMapID] then
			-- Continent is not affected by the bug. API is correct.
			-- print("nope: continent not bugged")
			return false
		end

		-- Continent is affected by the bug, check more stuff...
		if NoFlyZones735[GetCurrentMapAreaID()] then
			-- Continent is flyable, but zone is not. Note that this check
			-- won't be accurate if the world map is open to a zone other
			-- than the one in which the player is currently located.
			-- print("nope: zone excluded")
			return false
		end

		-- ¯\_(:/)_/¯
		-- print("probably...")
	end
	-- end of workaround

	return IsSpellKnown(34090) or IsSpellKnown(34091) or IsSpellKnown(90265)
end

----------------------------------------
-- Export
----------------------------------------

lib.ContinentSpells = lib.ContinentSpells
lib.FlyableContinents735 = FlyableContinents735
lib.NoFlyZones735 = NoFlyZones735
lib.NoFlySubzones = NoFlySubzones

lib.IsFlyableArea = CanFly
