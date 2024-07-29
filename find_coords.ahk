#Persistent

; Variables to store coordinates
firstX := 0
firstY := 0
secondX := 0
secondY := 0
diffX := 0
diffY := 0

; Hotkey to record the coordinates of the first item
F1::
    MouseGetPos, firstX, firstY
    Tooltip, First item coordinates recorded %firstX% %firstY%
    Sleep, 2000
    Tooltip
return

; Hotkey to record the coordinates of the second item
F2::
    MouseGetPos, secondX, secondY
    Tooltip, Second item coordinates recorded %secondX% %secondY%
    Sleep, 2000
    Tooltip
return

; Hotkey to display the differences in X, Y distances
F3::
    diffX := Abs(secondX - firstX)
    diffY := Abs(secondY - firstY)
    Tooltip, Difference in X %diffX% px Difference in Y %diffY% px
    Sleep, 5000
    Tooltip
return

; Hotkey to exit the script
^Esc::ExitApp
