import socket
import time

HOST = "192.168.125.1"  # The server's hostname or IP address
PORT = 4646  # The port used by the server

# Declare robtargets and tools according to the targets listed in the 'targets' arrays in the left and right modules in the same order

right_targets = {
    "vial_1": "1",
    "vial_hold_closed": "2",
    "vial_hold_open": "3",
    "vial_on_pad_upright": "4",
    "vial_on_pad_inverted": "5",
    "CO2_pad_origin": "6",}

left_targets = {
    "bridge_lcd_CO2": "1",
    "plate_on_lcd_1": "2",
    "plate_on_lcd_2": "3",
    "plate_on_CO2": "4",
}

right_tools = {"rGripper": "1", "rSucker": "2"}

left_tools = {"lGripper": "1", "lSucker": "2"}

# Left specific commands:
# Lgrip
# Lleave
# LgripPlateFromLCD
# LdropPlateOnLCD
# LgripPlateFromCO2
# LdropPlateOnCO2
#
#
# Right specific commands:
# Rgrip
# Rleave
# RgripVialFromHolder


def gen_command(action="", action_type="", robot="", tool="", target="", x="", y="",z=""):
    """Function to generate string command to send to YuMi"""

    if robot == "":
        return action
    elif robot == "R":
        return (
            robot
            + "_"
            + action
            + "_"
            + action_type
            + "_"
            + right_tools[tool]
            + "_"
            + right_targets[target]
            + "_"
            + x
            + "#"
            + y
            + "#"
            + z
        )
    elif robot == "L":
        return (
            robot
            + "_"
            + action
            + "_"
            + action_type
            + "_"
            + left_tools[tool]
            + "_"
            + left_targets[target]
            +"_"
            + x
            + "#"
            + y
            + "#"
            + z
        )
    else:
        return "error"


def send(comm):
    """Function to send string command to YuMi and wait for it to get confirmation from YuMi"""
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, PORT))
    s.sendall(bytes(comm, "utf-8"))
    data = s.recv(1024)
    time.sleep(0.5)
    s.close()
    return str(data)
