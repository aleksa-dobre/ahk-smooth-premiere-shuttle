# Premiere Pro Mouse Shuttle (AutoHotkey v2)

Analog-style **mouse shuttle control** for **Adobe Premiere Pro**, built with **AutoHotkey v2**.

Control slow playback and shuttle speed using **horizontal mouse movement**, similar to professional jog/shuttle hardware.

---

## 🎬 How It Works

- Hold a mouse (or keyboard) button to **start playback**
- Move the mouse:
  - ➡️ Right → **Forward** (`Shift + L`)
  - ⬅️ Left → **Backward** (`Shift + J`)
- Small movement → **very slow playback**
- Faster movement → **smooth acceleration**
- Release the button → **Stop** (`K`)

---

## ✨ Features

- Smooth, non-linear acceleration
- Ultra-slow playback start
- Mouse movement–based control (no scroll wheel)
- One-line button configuration
- Active only in Adobe Premiere Pro
- AutoHotkey **v2 only**

---

## 🖱️ Control Button

Change **one line** in the script under **CONTROL BUTTON**:

```ahk
shuttleButton := "XButton1"
```
Examples:
- `shuttleButton := "XButton2"`
- `shuttleButton := "MButton"`
- `shuttleButton := "F13"`

---

## 📦 Requirements

- Windows
- Adobe Premiere Pro
- AutoHotkey v2
