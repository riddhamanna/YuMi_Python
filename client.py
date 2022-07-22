import socket

HOST = "192.168.125.1"  # The server's hostname or IP address
PORT = 4646  # The port used by the server


while True:
    val = input("enter command: ")
    if val == "quit":
        break
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, PORT))
    s.sendall(bytes(val, "utf-8"))
    data = s.recv(1024)
    print("Received", repr(data))
    s.close()
