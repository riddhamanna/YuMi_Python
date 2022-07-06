import YuMiPy as yp
import time


# commands = ["L_MOVE_L_1", "LgripPlateFromLCD", "L_MOVE_L_2", "L_MOVE_L_3", "LdropPlateOnCO2", "L_MOVE_L_2", "L_MOVE_L_3", "LgripPlateFromCO2", "L_MOVE_L_2", "L_MOVE_L_1", "LdropPlateOnLCD", "L_MOVE_L_2"]
#
# for command in commands:
#     s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     s.connect((HOST, PORT))
#     s.sendall(bytes(command,'utf-8'))
#     data = s.recv(1024)
#     print('Received', repr(data))
#     s.close()
#     time.sleep(1)

# grip in left gripper
yp.send(yp.command("Lgrip"))
time.sleep(1)

# grip out right gripper
yp.send(yp.command("Rleave"))
time.sleep(1)

# pick plate 1 from LCD to CO2 pad and back:
# joint move to bridge position
# linear move to position of plate 1 on LCD
# grip plate from LCD
# linear move to bridge between LCD and CO2 pad
# linear move to CO2 pad
# drop plate on CO2 pad
# linear move to bridge
# linear move to CO2 pad
# grip plate from CO2 pad
# linear move to bridge
# linear move to LCD plate position 1
# drop plate on LCD
# linear move to bridge position
demo_commands_pickNplace_plate = [["MOVE","J","L","lGripper","bridge_lcd_CO2"],
                                  ["MOVE","L","L","lGripper","plate_on_lcd_1"],
                                  ["LgripFromLCD"],
                                  ["MOVE","L","L","lGripper","bridge_lcd_CO2"],
                                  ["MOVE","L","L","lGripper","plate_on_CO2"],
                                  ["LdropPlateOnCO2"],
                                  ["MOVE","L","L","lGripper","bridge_lcd_CO2"],
                                  ["MOVE","L","L","lGripper","plate_on_CO2"],
                                  ["LgripPlateFromCO2"],
                                  ["MOVE","L","L","lGripper","bridge_lcd_CO2"],
                                  ["MOVE","L","L","lGripper","plate_on_lcd_1"],
                                  ["LdropPlateOnLCD"],
                                  ["MOVE","L","L","lGripper","bridge_lcd_CO2"],
                                  ]

for comm in demo_commands_pickNplace_plate:
    print(yp.send(yp.command(comm)))
    time.sleep(0.5)

print("demo executed")
