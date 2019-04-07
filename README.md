<p align="center">
<img src="https://raw.githubusercontent.com/nickbild/6502_os/master/img/vectron_logo_small.png">
</p>

# Vectron 64

Custom-built general purpose, programmable, [6502](https://en.wikipedia.org/wiki/MOS_Technology_6502)-based computer and operating system.

## Specs

* [6502 CPU](https://en.wikipedia.org/wiki/MOS_Technology_6502) clocked at 1 Mhz.
* 32KB RAM
* 32KB EEPROM
  - Programmable via custom microcontroller based platform.
* 16x2 character LCD display.
* PS/2 keyboard support.
* Built with 7400 series logic contemporary with the original 6502 CPU.

## Schematics

[Fritzing Schematics](https://raw.githubusercontent.com/nickbild/6502_os/master/schematics/6502_computer.fzz)

[Schematics Image](https://raw.githubusercontent.com/nickbild/6502_os/master/schematics/6502_computer_bb.png)

## Images

![6502 Computer](https://raw.githubusercontent.com/nickbild/6502_os/master/img/20190407_151837.jpg)

![LCD](https://raw.githubusercontent.com/nickbild/6502_os/master/img/20181110_210151.jpg)

## Operation

All slide switches must be switched to the right for normal operating mode.  Connect a 9V DC power supply and the computer will being running the program stored in ROM.

To program ROM, slide all switches to the left.  Connect a microcontroller dev board (Arduino-like) per wiring guidance in the schematics.  Code to perform the programming routine is available in my [EEPROM Burner](https://github.com/nickbild/eeprom_burner) repository.

## Bill of Materials

| Quantity	| Part Type	| Properties |
| 11	| Ceramic Capacitor	| package 200 mil [THT, multilayer]; voltage 6.3V; capacitance 0.1µF |
| 9	| Electrolytic Capacitor | package 100 mil [THT, electrolytic]; voltage 6.3V; capacitance 220µF |
| 1	| Electrolytic Capacitor | package 100 mil [THT, electrolytic]; voltage 6.3V; capacitance 47µF |
| 2	| Electrolytic Capacitor | package 100 mil [THT, electrolytic]; voltage 6.3V; capacitance 22µF |
| 1	| Ceramic Capacitor	package | 200 mil [THT, multilayer]; voltage 6.3V; capacitance 0.01µF |
| 3	| 74HC08 Logic AND Gate	| variant Variant 1; pins 14; chip label 74HC08; editable pin labels false; package DIP (Dual Inline) [THT]; pin spacing 300mil; part # 74HC08 |
| 3	| 74HCT688E	| pins 20; hole size 1.0mm,0.508mm; chip label 74HCT688E; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 1	| 74LS161A	| pins 16; hole size 1.0mm,0.508mm; chip label 74LS161A; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 1	| 74LS244AN	| pins 20; hole size 1.0mm,0.508mm; chip label 74LS244AN; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 1	| WDC 65C02	| pins 40; hole size 1.0mm,0.508mm; chip label WDC 65C02; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 5	| 74HC04 | pins 14; hole size 1.0mm,0.508mm; chip label 74HC04; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 1	| Voltage Regulator	| variant sink; chip 78005; package to220-igo; voltage 5V |
| 1	| 28C256-15 EEPROM | pins 28; hole size 1.0mm,0.508mm; chip label 28C256-15 EEPROM; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 1	| CY7C199-35PC SRAM | pins 28; hole size 1.0mm,0.508mm; chip label CY7C199-35PC SRAM; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 4	| 74LS32 | pins 14; hole size 1.0mm,0.508mm; chip label 74LS32; true; package DIP (Dual Inline) [THT]; pin spacing 300mil |
| 1	| LCD screen | pins 16; type Character |
| 2	| NPN-Transistor | package TO92 [THT]; type NPN (EBC) |
| 2	| 10kΩ Resistor | tolerance ±5%; resistance 10kΩ; package 2512 [SMD] |
| 2	| 5kΩ Resistor | tolerance ±5%; resistance 5kΩ; package 2512 [SMD] |
| 5	| 3.3kΩ Resistor | tolerance ±5%; resistance 3.3kΩ; package 2512 [SMD] |
| 1	| Pushbutton | package [THT] |
| 5	| 74HC595 | package DIP16 [THT]; type 74HC595 |
| 13	| SWITCH_SPDT | package kps-1290 |
| 1	| POT | variant 100k_3362u; package 3362u |
| 1	| mini DIN 6 Connector | variant pth; package mini-din6; connector Mini-DIN6 |
| 1	| Crystal | frequency 1 MHz; package THT; type crystal; pin spacing 5.08mm |

## About the Author

[Nick A. Bild, MS](https://nickbild79.firebaseapp.com/#!/)
