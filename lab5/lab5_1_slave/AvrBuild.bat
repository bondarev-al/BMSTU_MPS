@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "E:\BMSTU\6_Microprocessors\labs\lab5\lab5_1_slave\labels.tmp" -fI -W+ie -C V2E -o "E:\BMSTU\6_Microprocessors\labs\lab5\lab5_1_slave\lab5_1_slave.hex" -d "E:\BMSTU\6_Microprocessors\labs\lab5\lab5_1_slave\lab5_1_slave.obj" -e "E:\BMSTU\6_Microprocessors\labs\lab5\lab5_1_slave\lab5_1_slave.eep" -m "E:\BMSTU\6_Microprocessors\labs\lab5\lab5_1_slave\lab5_1_slave.map" "E:\BMSTU\6_Microprocessors\labs\lab5\lab5_1_slave\lab5_1_slave.asm"