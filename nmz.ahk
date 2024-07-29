#Persistent

; Variables
startX := 3385 ; Starting X coordinate (top-left of first item)
startY := 920 ; Starting Y coordinate (top-left of first item)
distanceTravelX := 102 ; Distance between items in the X direction
distanceTravelY := 81 ; Distance between items in the Y direction
offset := 3 ; Random offset in pixels
prayerClickTimeMin := 82000 ; Minimum time for prayer potion click in milliseconds (1 minute 15 seconds) - 75000 ms for blowpipe, 105000 for melee
prayerClickTimeMax := 88000 ; Maximum time for prayer potion click in milliseconds (1 minute 18 seconds) - 78000 ms for blowpipe, 110000 for melee
statsBoostTimeMin := 299000 ; Minimum time for stats boosting potion (5 minutes - 299000 ms)
statsBoostTimeMax := 300000 ; Maximum time for stats boosting potion (5 minutes - 300000 ms)
isRunning := false ; Variable to check if the script is running
statsPotionIndex := 0 ; Index of the current stats boosting potion
prayerPotionIndex := 0 ; Index of the current prayer boosting potion
potionDoseClicks := 4 ; Number of clicks per potion
currentPrayerDoses := potionDoseClicks ; Track doses remaining for current prayer potion
currentStatsDoses := potionDoseClicks ; Track doses remaining for current stats potion
maxStatsClicks := 24 ; Total clicks before stopping (4 potions * 4 doses each)
totalStatsClicks := 0 ; Track total stats clicks
totalRunTime := maxStatsClicks * 5 * 60 * 1000 ; Total runtime in milliseconds (16 * 5 minutes)

; Function to click an item with random offset
ClickItem(x, y)
{
    global offset
    Random, offsetX, -offset, offset
    Random, offsetY, -offset, offset

    xClick := x + offsetX
    yClick := y + offsetY

    ; Realistic mouse movement
    MouseMove, xClick, yClick, 10
    Random, sleepTime, 50, 200
    Sleep, sleepTime
    Click, left

    Tooltip, Clicked at %xClick% %yClick%
    Sleep, 2000 ; Tooltip display time
    Tooltip
}

; Function to manage stats boosting potions
ManageStatsBoostingPotions()
{
    global statsPotionIndex, startX, startY, distanceTravelX, distanceTravelY, currentStatsDoses, potionDoseClicks, maxStatsClicks, totalStatsClicks

    row := (statsPotionIndex // 4) ; Calculate row (0 or 1)
    col := Mod(statsPotionIndex, 4) ; Calculate column

    x := startX + (col * distanceTravelX)
    y := startY + (row * distanceTravelY)

    ClickItem(x, y)
    totalStatsClicks++
    currentStatsDoses--

    if (currentStatsDoses <= 0)
    {
        statsPotionIndex++
        if (statsPotionIndex >= 8) ; Reset to first item after the last item (2 rows * 4 columns = 8 slots)
        {
            statsPotionIndex := 0
        }
        currentStatsDoses := potionDoseClicks
    }

    if (totalStatsClicks >= maxStatsClicks)
    {
        SetTimer, ManageStatsTimer, Off
        SetTimer, ManagePrayerTimer, Off
        SetTimer, RandomArrowKeyTimer, Off
        SetTimer, StopScriptTimer, Off
        isRunning := false
        Tooltip, Script Stopped - All Stats Potions Used
        Sleep, 2000
        Tooltip
    }
}

; Function to manage prayer boosting potions
ManagePrayerBoostingPotions()
{
    global prayerPotionIndex, startX, startY, distanceTravelX, distanceTravelY, currentPrayerDoses, potionDoseClicks

    row := (prayerPotionIndex // 4) + 2 ; Calculate row (starts from the third row)
    col := Mod(prayerPotionIndex, 4) ; Calculate column

    x := startX + (col * distanceTravelX)
    y := startY + (row * distanceTravelY)

    ClickItem(x, y)
    currentPrayerDoses--

    if (currentPrayerDoses <= 0)
    {
        prayerPotionIndex++
        if (prayerPotionIndex >= 20) ; Reset to first item after the last item (5 rows * 4 columns = 20 slots, starting from 3rd row)
        {
            prayerPotionIndex := 0
        }
        currentPrayerDoses := potionDoseClicks
    }
}

; Function to perform random arrow key movements
PerformRandomArrowKeyMovements()
{
    Random, key, 1, 4
    Random, duration, 1000, 3000 ; Duration between 1 to 3 seconds

    If (key = 1)
        Send, {Up down}
    Else If (key = 2)
        Send, {Down down}
    Else If (key = 3)
        Send, {Left down}
    Else If (key = 4)
        Send, {Right down}

    Sleep, %duration%

    If (key = 1)
        Send, {Up up}
    Else If (key = 2)
        Send, {Down up}
    Else If (key = 3)
        Send, {Left up}
    Else If (key = 4)
        Send, {Right up}
}

; Timer to manage stats boosting potions every 5 minutes
ManageStatsTimer:
If (isRunning)
{
    ManageStatsBoostingPotions()
    Random, statsBoostTime, %statsBoostTimeMin%, %statsBoostTimeMax%
    SetTimer, ManageStatsTimer, %statsBoostTime%
}
return

; Timer to manage prayer boosting potions every 1 minute and 20 seconds
ManagePrayerTimer:
If (isRunning)
{
    ManagePrayerBoostingPotions()
    Random, prayerClickTime, %prayerClickTimeMin%, %prayerClickTimeMax%
    SetTimer, ManagePrayerTimer, %prayerClickTime%
}
return

; Timer to perform random arrow key movements every 2-5 minutes
RandomArrowKeyTimer:
If (isRunning)
{
    PerformRandomArrowKeyMovements()
    Random, nextMoveTime, 120000, 300000 ; 2 to 5 minutes
    SetTimer, RandomArrowKeyTimer, %nextMoveTime%
}
return

; Timer to stop the script after 16 * 5 minutes
StopScriptTimer:
SetTimer, ManageStatsTimer, Off
SetTimer, ManagePrayerTimer, Off
SetTimer, RandomArrowKeyTimer, Off
SetTimer, StopScriptTimer, Off
isRunning := false
Tooltip, Script Stopped - 80 Minutes Elapsed
Sleep, 2000
Tooltip
return

; Hotkey to start/stop the script with NumPad 0
Numpad0::
    if (isRunning)
    {
        SetTimer, ManageStatsTimer, Off
        SetTimer, ManagePrayerTimer, Off
        SetTimer, RandomArrowKeyTimer, Off
        SetTimer, StopScriptTimer, Off
        isRunning := false
        Tooltip, Script Stopped
        Sleep, 2000
        Tooltip
    }
    else
    {
        isRunning := true
        Tooltip, Script Starting in 2 seconds...
        Sleep, 2000
        Tooltip
        ; Start timers
        SetTimer, ManageStatsTimer, 0 ; Immediately run the timer
        SetTimer, ManagePrayerTimer, 0 ; Immediately run the timer
        SetTimer, RandomArrowKeyTimer, 0 ; Immediately run the timer
        SetTimer, StopScriptTimer, -%totalRunTime% ; Run once after total runtime
        Tooltip, Script Running
        Sleep, 2000
        Tooltip
    }
return

; Hotkey to stop the script
^Esc::ExitApp

Random(min, max)
{
    Random, result, %min%, %max%
    return result
}
