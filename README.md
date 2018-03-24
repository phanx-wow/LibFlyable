# LibFlyable

**Replacement for the IsFlyableArea API function in World of Warcraft.**

Avoids these long-standing bugs with IsFlyableArea:

- Broken Isles zones are only flyable with the Broken Isles Pathfinder ability.
- Draenor zones are only flyable with the Draenor Pathfinder ability.
- Certain maps like Argus and the Tanaan Jungle Intro are not flyable.
- Certain Legion class halls are not flyable.


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
