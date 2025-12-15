#Requires AutoHotkey v2.0
#HotIf WinActive("ahk_exe Adobe Premiere Pro.exe")

; ============================================================
; Premiere Pro Mouse Shuttle (AutoHotkey v2)
; ------------------------------------------------------------
; Analog-style shuttle playback using horizontal mouse movement
; Forward  -> Shift + L
; Backward -> Shift + J
; Release  -> K (Stop)
; ============================================================


; ---------- TUNING ----------
timerInterval := 15     ; Timer interval in ms (lower = smoother, higher = lighter CPU)

deadzone := 0.2         ; Minimum mouse movement before playback starts
smoothFactor := 0.35    ; Motion smoothing (0.25 = snappy, 0.5 = very smooth)

; Acceleration curve:
; - baseGain controls how slow playback starts
; - accelGain controls how gradually it accelerates
baseGain  := 0.015      ; Initial slow playback sensitivity
accelGain := 0.00008    ; Acceleration strength (quadratic)
maxPerTick := 3         ; Maximum playback impulses per timer tick


; ---------- STATE ----------
lastX := 0              ; Last mouse X position
active := false         ; Whether shuttle mode is active
smoothed := 0.0         ; Smoothed mouse delta
carry := 0.0            ; Floating-point accumulator for ultra-fine control


; ---------- CONTROL BUTTON ----------
; Change ONLY this line to use a different mouse or keyboard button
; Examples: "XButton2", "MButton", "F13"

shuttleButton := "XButton1"   ; <-- PLAY / SHUTTLE BUTTON


; Register dynamic hotkeys
Hotkey(shuttleButton, (*) => StartShuttle())
Hotkey(shuttleButton " Up", (*) => StopShuttle())


; ---------- SHUTTLE START ----------
StartShuttle() {
    global lastX, active, smoothed, carry, timerInterval

    MouseGetPos &lastX, &_      ; Store initial mouse position
    active := true
    smoothed := 0.0
    carry := 0.0

    SetTimer(MouseShuttle, timerInterval)
}


; ---------- SHUTTLE STOP ----------
StopShuttle() {
    global active

    active := false
    SetTimer(MouseShuttle, 0)
    Send "k"                    ; Stop playback in Premiere
}


; ---------- SHUTTLE CORE ----------
MouseShuttle() {
    global lastX, active, deadzone, smoothFactor
    global smoothed, carry, baseGain, accelGain, maxPerTick

    if !active
        return

    MouseGetPos &x, &_
    delta := x - lastX           ; Horizontal mouse movement
    lastX := x

    raw := Abs(delta)

    ; Smooth mouse movement (low-pass filter)
    smoothed := (smoothed * (1 - smoothFactor)) + (raw * smoothFactor)
    absd := smoothed

    ; Ignore tiny movements
    if absd < deadzone
        return

    ; Slow start + smooth acceleration curve
    rateF := (absd * baseGain) + (absd * absd * accelGain)

    ; Accumulate fractional impulses for analog behavior
    carry += rateF

    ; Send playback commands when enough impulse is accumulated
    n := 0
    while (carry >= 1 && n < maxPerTick) {
        carry -= 1
        n += 1

        if (delta > 0)
            Send "{Shift Down}l{Shift Up}"   ; Forward
        else
            Send "{Shift Down}j{Shift Up}"   ; Backward
    }
}

#HotIf
