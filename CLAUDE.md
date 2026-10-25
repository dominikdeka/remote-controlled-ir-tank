# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Arduino-based remote-controlled tank with an IR "gun" for a multi-player shooting game. Two firmware sketches plus Eagle PCB designs for both boards. No build system, tests or linter in the repo.

- `arduino/remotePlus.ino` - vehicle firmware (receiver, motors, IR gun, hit counter display)
- `arduino/remotePlusPad.ino` - handheld controller firmware (joystick + buttons, transmitter)
- `eagle/ir_remote_controlled_veh.*` - vehicle board schematic/layout
- `eagle/remote_controller.*` - controller board schematic/layout
- `docs/hardware-upgrades.md` - optional part upgrades for a future PCB v2 (current hardware works)

Eagle `.sch`/`.brd` are binary-ish XML edited in Autodesk Eagle; do not hand-edit them.

## Building / flashing

Both sketches sit in one folder, which the Arduino IDE / `arduino-cli` will not compile as-is (a sketch folder must match the `.ino` name, and two `.ino` files in one folder are merged into one sketch, giving duplicate `setup`/`loop`). Copy each into its own folder first, e.g.:

```
mkdir -p /tmp/remotePlus && cp arduino/remotePlus.ino /tmp/remotePlus/
arduino-cli compile --fqbn <board-fqbn> /tmp/remotePlus
```

Board is not recorded in the repo (pinout fits an ATmega328 Uno/Nano class board). Required libraries:
- `RF24` (nRF24L01 radio)
- `IRremote` - vehicle only; code uses the legacy 2.x API (`irrecv.decode(&results)`, `results.value`, `irsend.sendJVC(data, bits, repeat)`), which breaks on IRremote 3.x+.

## Architecture

**Radio link (nRF24L01, 250 kbps).** Each vehicle/controller pair is selected by `veh_no` at the top of both sketches. It indexes the `pipes[]` (address) and `channels[]` tables, which are duplicated in both files and must stay identical. Set the same `veh_no` in both sketches before flashing a pair (currently vehicle = 0, pad = 4 in the repo).

**Packet format.** Controller sends `int data[5]` = `{joystickX, joystickY, joystickButton, buttonA, buttonB}` (analog 0-1023 for axes, 0/1 for buttons). It only transmits when an axis moves by >10 or a button changes, so the vehicle keeps its last drive command until the next packet. Changing the packet means editing both sketches.

**Vehicle game loop (`loop()` in `remotePlus.ino`):**
- Battery check on A5 (voltage divider x2, low LED below 7.6 V). Controller does the same at 3.9 V without divider.
- 3-digit 7-segment hit counter, multiplexed one digit per loop iteration through a 74HC595 shift register (`printDigits`, segment bitmasks are active-low). Display blinks during shot cooldown.
- Driving and shooting are only allowed while `shot_counter <= 5` (more hits = vehicle is "dead").
- Button A fires: IR JVC code `0xF503`, 5 s cooldown (`shot_delay`). `irrecv.enableIRIn()` must be called after `irsend` because sending disables the receiver.
- IR receive: `0xF503` = hit (counter++ with a shake/buzzer reaction), `0xF583` = counter-- (heal).
- `drive()` does tank steering: Y sets speed/direction for both tracks, X subtracts `turning_strength` from one side.

**Motor driver quirk.** `engineControl()` uses one direction pin + one PWM pin per motor; in BACKWARD the PWM is inverted (`255 - speed`) because the direction pin is HIGH.

**Pin constraints.** The vehicle uses pins 0 and 1 (`batteryLedPin`, `buzzerPin`) as GPIO, so `Serial` cannot be used for debugging there.
