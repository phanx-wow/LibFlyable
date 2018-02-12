# LibFlyable

**Replacement for the IsFlyableArea API function in World of Warcraft.**

Avoids these long-standing bugs with IsFlyableArea:

- Broken Isles zones are only flyable with the Broken Isles Pathfinder ability.
- Draenor zones are only flyable with the Draenor Pathfinder ability.
- Warlords garrisons and Legion class halls are *never* flyable.
- Ashran (PvP) and the Tanaan Jungle Intro are *never* flyable.

Also avoids the new bugs introduced in Patch 7.3.5:

- Pandaria zones no longer require Wisdom of the Four Winds.
- Northrend zones no longer require Cold Weather Flying.
- Eastern Kingdoms, Kalimdor, and Deepholm no longer require Flight Master's License.

These spells were removed from the game, and all characters can fly in these
zones, but IsFlyableArea returns false for characters who had not previously
learned the appropriate spell.


## Usage

```lua
lib = LibStub("LibFlyable")
isFlyable = lib:IsFlyableArea() -- true/false
```

**Source code and bug reports on GitHub:**
<https://github.com/phanx-wow/LibFlyable>

**URL to use with the CurseForge packager:**
`https://repos.curseforge.com/wow/libflyable`
Only tagged releases are pushed to CurseForge, so using this URL will ensure
the packager always gives you a tested and stable version of the library.


## Contributing

Pull requests and bug reports are encouraged. I no longer play WoW, so
I will not notice relevant game changes unless someone tells me about them.
If you are an experienced and active WoW addon author, and are interested in
becoming a permanent official maintainer of this library, please contact me.


## Unlicense

This is free and unencumbered software released into the public domain.

See the included `LICENSE.txt` file for more information.
