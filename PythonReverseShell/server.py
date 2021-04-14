import socket

SERVER_HOST = "0.0.0.0"
SERVER_PORT = 5555
BUFFER_SIZE = 1024

s = socket.socket()
s.bind((SERVER_HOST,SERVER_PORT))
s.listen()

print(f"Listening on {SERVER_HOST}:{SERVER_PORT} ...")

client_socket, client_address = s.accept()
print(f"{client_address[0]}:{client_address[1]} Connected")

message = "Hello and Welcome".encode()
client_socket.send(message)

while True:
    #get command
    command = input("Enter the command")
    #send to client
    client_socket.send(command.encode())
    if command.lower() == "exit":
        break

    result = client_socket.recv(BUFFER_SIZE).decode()
    print(result)

client_socket.close()
s.close()