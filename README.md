# osrs-ahk

quick how-to use it:

1. install AHK on your machine
2. run "find_coords.ahk"
3. Press "F1" to get a tooltip of current mouse's X and Y coords (useful for later)
4. Press "F2" to get a tooltip of currnet mouse'x Y and Y coords
5. Press "F3" to get the X and Y diff between F1 and F2 coords.


## Requirements
for NMZ training I recommend: nmz absorb.ahk
Requirements:
- 51 HP
- Rock cake
- Full-screen Rune-Lite or other launched (so coords are always static)
- Set quick-prayers to rapid heal (only rapid heal)
- Edit the config (details below)

## Get the following inventory setup:
```
1st row - Overloads (4) x4
28th item - Rock cake
The rest - Absobption potions
```


## Config setup


### Setup initial mouse pos
This should be the middle pixel of the 1st item (Overload) - use F1 for find_coords.ahk
```
startX := 3385 ;
startY := 920 ;
```

### Setup mouse travel X
This should be the X distance for 1st and 2nd item - use F1, F2, and F3. F3 will show you the diff for X and Y. tldr; dist between 1st and 2nd item.
```
distanceTravelX := 102 ;
```

### Setup mouse travel Y
This should be the Y distance for 1st item on first row and 1nd item on second row - use F1, F2, and F3. F3 will show you the diff for X and Y. tldr; dist between 1st item and 5th item.
```
distanceTravelY := 81 ;
```

### Setup coords for rock cake
Coords for rock cake (should be last item in your inventory)
```
rockCakeX := 3677
rockCakeY := 1429
```

### Setup coords for quick-prayers
Find
```PrayerToggle()```
change the
```
xClick := 3414
yClick := 265
```
to your coords for quick-prayers.


### Optional: Change start/stop key
If you want to change the start/stop key for script (Default NumPad 0) - Find this
```
; Hotkey to start/stop the script with NumPad 0
\::
```

change to any key you want eg. F1
```
F1::
```



## What to do?

1. Setup config
2. Start the script
3. Get to 51 HP (rock cake)
4. Get proper inventory setup
5. Gear up, auto-retaliate should be ON
6. Start NMZ
7. Drink one dose of Overload
8. Quickly drink all Absobption potions in reverse order (starting from last slot)
9. Press Start key (default: numpad 0)
10. Enjoy 80 minutes of AFK training

    




