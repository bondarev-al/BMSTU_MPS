@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "E:\BMSTU\6_Microprocessors\labs\lab4\lab4_4\labels.tmp" -fI -W+ie -C V2E -o "E:\BMSTU\6_Microprocessors\labs\lab4\lab4_4\lab4_4.hex" -d "E:\BMSTU\6_Microprocessors\labs\lab4\lab4_4\lab4_4.obj" -e "E:\BMSTU\6_Microprocessors\labs\lab4\lab4_4\lab4_4.eep" -m "E:\BMSTU\6_Microprocessors\labs\lab4\lab4_4\lab4_4.map" "E:\BMSTU\6_Microprocessors\labs\lab4\lab4_4\lab4_4.asm"