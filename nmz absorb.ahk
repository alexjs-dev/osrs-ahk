; Variables
startX := 3385 ; Starting X coordinate (top-left of first item)
startY := 920 ; Starting Y coordinate (top-left of first item)
distanceTravelX := 102 ; Distance between items in the X direction
distanceTravelY := 81 ; Distance between items in the Y direction
offset := 3 ; Random offset in pixels
routineInterval := 285000 ; Routine interval (5 minutes - 300000 ms)
isRunning := false ; Variable to check if the script is running
statsPotionIndex := 0 ; Index of the current stats boosting potion
absorptionPotionIndex := 0 ; Index of the current absorption boosting potion
potionDoseClicks := 4 ; Number of clicks per potion
currentAbsorptionDoses := potionDoseClicks ; Track doses remaining for current absorption potion
currentStatsDoses := potionDoseClicks ; Track doses remaining for current stats potion
maxStatsClicks := 16 ; Total clicks before stopping (4 potions * 4 doses each)
totalStatsClicks := 0 ; Track total stats clicks
totalRunTime := maxStatsClicks * 5 * 60 * 1000 ; Total runtime in milliseconds (16 * 5 minutes)
prayerClickDelayMin := 620 ; Minimum delay for prayer click in milliseconds
prayerClickDelayMax := 700 ; Maximum delay for prayer click in milliseconds
prayerToggleIntervalMin := 26000 ; Minimum interval for prayer toggle in milliseconds
prayerToggleIntervalMax := 32000 ; Maximum interval for prayer toggle in milliseconds
absorptionClickDelayMin := 50 ; Minimum delay for absorption click in milliseconds
absorptionClickDelayMax := 100 ; Maximum delay for absorption click in milliseconds
rockCakeX := 3677
rockCakeY := 1429

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
        SetTimer, ManageRoutine, Off
        SetTimer, RandomArrowKeyTimer, Off
        SetTimer, StopScriptTimer, Off
        SetTimer, PrayerToggleTimer, Off
        isRunning := false
        Tooltip, Script Stopped - All Stats Potions Used
        Sleep, 2000
        Tooltip
    }
}

; Function to manage absorption potions
ManageAbsorptionPotions()
{
    global absorptionPotionIndex, startX, startY, distanceTravelX, distanceTravelY, currentAbsorptionDoses, potionDoseClicks, absorptionClickDelayMin, absorptionClickDelayMax

    row := (absorptionPotionIndex // 4) + 2 ; Calculate row (starts from the third row)
    col := Mod(absorptionPotionIndex, 4) ; Calculate column

    x := startX + (col * distanceTravelX)
    y := startY + (row * distanceTravelY)

    Loop, 4
    {
        ClickItem(x, y)
        currentAbsorptionDoses--

        if (currentAbsorptionDoses <= 0)
        {
            absorptionPotionIndex++
            if (absorptionPotionIndex >= 20) ; Reset to first item after the last item (5 rows * 4 columns = 20 slots, starting from 3rd row)
            {
                absorptionPotionIndex := 0
            }
            currentAbsorptionDoses := potionDoseClicks
        }

        Random, sleepTime, %absorptionClickDelayMin%, %absorptionClickDelayMax%
        Sleep, sleepTime
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

; Function to toggle prayer (double-left click at specified coordinates)
PrayerToggle()
{
    global prayerClickDelayMin, prayerClickDelayMax, prayerToggleIntervalMin, prayerToggleIntervalMax

    xClick := 3414
    yClick := 265

    Random, offsetX, -2, 2
    Random, offsetY, -2, 2
    Random, clickDelay, %prayerClickDelayMin%, %prayerClickDelayMax%

    MouseMove, xClick + offsetX, yClick + offsetY, 10
    Click, left
    Sleep, clickDelay
    Click, left

    Random, sleepTime, %prayerToggleIntervalMin%, %prayerToggleIntervalMax%
    SetTimer, PrayerToggleTimer, %sleepTime%
}

; Routine to manage the 5-minute tasks
ManageRoutine:
If (isRunning)
{
    SetTimer, PrayerToggleTimer, Off ; Pause Prayer Toggle
    ManageStatsBoostingPotions()
    ManageAbsorptionPotions()

    ; Perform triple click on rockCake coords
    Loop, 2
    {
        ClickItem(rockCakeX, rockCakeY)
        Sleep, 50 ; Short delay between clicks
    }

    Random, nextRoutineTime, %routineInterval%, %routineInterval%
    SetTimer, ManageRoutine, %nextRoutineTime%
    SetTimer, PrayerToggleTimer, 2500 ; Resume Prayer Toggle after the routine
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

; Timer to manage prayer toggle
PrayerToggleTimer:
If (isRunning)
{
    PrayerToggle()
}
return

; Timer to stop the script after 16 * 5 minutes
StopScriptTimer:
SetTimer, ManageRoutine, Off
SetTimer, RandomArrowKeyTimer, Off
SetTimer, PrayerToggleTimer, Off
SetTimer, StopScriptTimer, Off
isRunning := false
Tooltip, Script Stopped - 80 Minutes Elapsed
Sleep, 2000
Tooltip
ExitApp
return

; Hotkey to start/stop the script with NumPad 0
\::
    if (isRunning)
    {
        SetTimer, ManageRoutine, Off
        SetTimer, RandomArrowKeyTimer, Off
        SetTimer, PrayerToggleTimer, Off
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
        SetTimer, ManageRoutine, 0 ; Immediately run the timer
        SetTimer, RandomArrowKeyTimer, 0 ; Immediately run the timer
        SetTimer, PrayerToggleTimer, 0 ; Immediately run the timer
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
