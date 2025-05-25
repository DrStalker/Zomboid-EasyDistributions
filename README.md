A library to simplify loot distribution for modders by allowing a new item to copy an existing item's loot probabilities.

# For non-modders:

Install this mod if it is a requirement for another mod you want.  This mod can be added and removed freely, but the mods that depend on this may not be so easy-going.

# For Modders:

## Enabling the Library

Just add the following require line to a lua file in your mod's /media/lua/server folder, then place any calls to library below that so they execute as the .lua file is loaded.

```
require "EasyDistro"
```

In your mod.info file add `require=\NepEasyDistro` and add the library as a requirement on Steam to make it easier for users to download.

## Adding Items

To copy the loot distribution of an existing item call `EasyDistro.Add` with the identifier of your new item and the identifier of the item you want to copy. For example, if you create a new type of handgun and want it to show up everywhere the standard 9mm pistol shows up:

```
EasyDistro.AddItem("Base.MyNewGun","Base.Pistol")
```

The `AddItem` function supports an optional third parameter that will multiply the new items probability. For example, to add a purple pen that appear with 25% of the probability of a green pen:

```
EasyDistro.AddItem("Base.MyPurplePen", "Base.GreenPen", 0.25)
```


That's it.  Everything else is optional.


### Enabling verbose mode

To aid troubleshooting, you can call `EasyDistro.EnableVerbose()` which will list every entry as they are found, and again as they are added to the loot table.  Please don't leave this enabled in your mod when publishing, because it will affect all mods using this library and result in log file spam for all users!

### Force Updating the Item picker

If for some reason you update the loot tables after the ItemPicker has already initialized, `EasyDistro.UpdateItemPicker()`  will force the ItemPicker to re-read the ProceduralDistributions table.  This isn't needed if you call `EasyDistro.AddItem` as described above, but it you call it later for some reason this allows your changes to take effect.




Workshop ID: 3487312010
Mod ID: NepEasyDistro
