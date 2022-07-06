import socket
import time

HOST = '192.168.125.1'  # The server's hostname or IP address
PORT = 4646        # The port used by the server


commands = ["L_MOVE_L_1", "LgripPlateFromLCD", "L_MOVE_L_2", "L_MOVE_L_3", "LdropPlateOnCO2", "L_MOVE_L_2", "L_MOVE_L_3", "LgripPlateFromCO2", "L_MOVE_L_2", "L_MOVE_L_1", "LdropPlateOnLCD", "L_MOVE_L_2"]

for command in commands:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, PORT))
    s.sendall(bytes(command,'utf-8'))
    data = s.recv(1024)
    print('Received', repr(data))
    s.close()
    time.sleep(1)
