@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "E:\BMSTU\6_Microprocessors\labs\lab3\labels.tmp" -fI -W+ie -C V2E -o "E:\BMSTU\6_Microprocessors\labs\lab3\lab3.hex" -d "E:\BMSTU\6_Microprocessors\labs\lab3\lab3.obj" -e "E:\BMSTU\6_Microprocessors\labs\lab3\lab3.eep" -m "E:\BMSTU\6_Microprocessors\labs\lab3\lab3.map" "E:\BMSTU\6_Microprocessors\labs\lab3\lab3.asm"
