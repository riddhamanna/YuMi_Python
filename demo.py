import YuMiPy as yp
import time

# pick plate 1 from LCD to CO2 pad and back:
# joint move to bridge position
# linear move to position of plate 1 on LCD
# grip plate from LCD
# linear move to bridge between LCD and CO2 pad
# linear move to CO2 pad
# drop plate on CO2 pad
# linear move to bridge
# linear move to CO2 pad)
# grip plate from CO2 pad
# linear move to bridge
# linear move to LCD plate position 1
# drop plate on LCD
# linear move to bridge position
demo_commands_pickNplace_plate = [
    ["MOVE", "J", "L", "lGripper", "bridge_lcd_CO2", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "plate_on_lcd_2", "", "", ""],
    ["LgripPlateFromLCD", "", "", "", "", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "bridge_lcd_CO2", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "plate_on_CO2", "", "", ""],
    ["LdropPlateOnCO2", "", "", "", "", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "bridge_lcd_CO2", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "plate_on_CO2", "", "", ""],
    ["LgripPlateFromCO2", "", "", "", "", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "bridge_lcd_CO2", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "plate_on_lcd_1", "", "", ""],
    ["LdropPlateOnLCD", "", "", "", "", "", "", ""],
    ["MOVE", "L", "L", "lGripper", "bridge_lcd_CO2", "", "", ""],
]

demo_commands_vialGripOpenClose = [
    ["MOVE", "J", "L", "lGripper", "bridge_lcd_CO2", "", "", ""],
    ["MOVE", "J", "R", "rGripper", "vial_1", "", "", ""],
    ["RgripVialFromHolder", "", "", "", "", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_hold_open", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_hold_closed", "", "", ""],
    ["Lgrip", "", "", "", "", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_hold_open", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_on_pad_upright", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_on_pad_inverted", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_on_pad_upright", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_hold_open", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_hold_closed", "", "", ""],
    ["Lleave", "", "", "", "", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_hold_open", "", "", ""],
    ["MOVE", "L", "R", "rGripper", "vial_1", "", "", ""],
    ["RplaceVialInHolder", "", "", "", "", "", "", ""],
]

demo_commands_rasterCO2pad = [
    ["MOVE", "J", "R", "rSucker", "CO2_pad_origin", "", "", ""],
    ["OFFS", "L", "R", "rSucker", "current_pos", "50", "50", ""],
    ["MOVE", "L", "R", "rSucker", "CO2_pad_origin", "", "", ""],
    ["OFFS", "L", "R", "rSucker", "CO2_pad_origin", "100", "50", ""],
    ["MOVE", "L", "R", "rSucker", "CO2_pad_origin", "", "", ""],
]

# for comm in demo_commands_pickNplace_plate:
#     print(yp.send(yp.gen_command(comm[0], comm[1], comm[2], comm[3], comm[4])))
#     time.sleep(0.5)
#
# for comm in demo_commands_vialGripOpenClose:
#     print(yp.send(yp.gen_command(comm[0], comm[1], comm[2], comm[3], comm[4])))
#     time.sleep(0.5)

for comm in demo_commands_rasterCO2pad:
    print(yp.send(yp.gen_command(comm[0], comm[1], comm[2], comm[3], comm[4])))
    time.sleep(0.5)

print("demo executed")
